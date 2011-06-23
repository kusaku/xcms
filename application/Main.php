<?php
/**
 *
 * Главный Bootstrap и главный класс Системы
 *
 * @category   Xcms
 * @version    $Id: Main.php 241 2010-07-16 12:24:37Z renat $
 *
 */

class Main extends Zend_Application_Bootstrap_Bootstrap {

	/**
	 * Список прав доступа
	 * @var Zend_Acl
	 */
	static protected $_acl;

	/**
	 * Текущий язык
	 * @var Model_Entity_Language
	 */
	static protected $_language;
	
	static protected $_cache;



	/**
	 * Инициализация автозагрузчика
	 * @return void
	 */
	protected function _initAutoload() {
		$autoloader = new Zend_Application_Module_Autoloader (
			array (
				'namespace' => '',
				'basePath' => dirname ( __FILE__ )
			)
		);
		return $autoloader;
	}



	/**
	 * Инициализация реестра, должен исполнятся первым
	 * @see Model_Registry
	 * @return void
	 */
	protected function _initRegistry() {
		Zend_Registry::setClassName('Model_Registry');
		$configFile = dirname( __FILE__ ) . '/configs/edition.php';
		if ( ! file_exists( $configFile) ) {
			throw new Exception('Конфигурационный файл редакции системы не существует!');
		}

		$config = new Zend_Config( require $configFile );
		foreach ( $config as $key=>$value ) {
			Zend_Registry::set( $key, $value ); // исп. стандартный (без БД)
		}
		Zend_Registry::set( 'version', $this->getOption('version') );
		Zend_Registry::set( 'installed', $this->getOption('installed'));
	}


	
	/**
	 * Инициализация подключения к БД
	 * @return void
	 */
	protected function _initDb() {
        
		$config = $this->getOption('db');
		if(is_array($config)) {
	        // Создает экземпляр Zend_Db_Adapter
			try {
				$db = Zend_Db::factory($config['adapter'],
				$config['params'] );
				//var_dump($db);
			} catch (Exception $e) {
	        	return;
	        }
	        try {
	        	$db->getConnection();
	        } catch (Exception $e) {
	        	return;
	        }
			//var_dump($db->getConnection());
			//Zend_Auth_Adapter_DbTable($db);
			Zend_Db_Table_Abstract::setDefaultAdapter($db);
			$db->getProfiler()->setEnabled(true);
		} else {
			return;
		}
		return $db;
	}

	/**
	 * Инициализация кеширования
	 * @return void
	 */
	protected function _initCaching() {
		$this->bootstrapCachemanager();
		Zend_Registry::set( 'Zend_Cache', $this->cachemanager );
		Zend_Db_Table_Abstract::setDefaultMetadataCache(
			$this->cachemanager->getCache('database')
		);
	}

	/**
	 * Инициализация логеров
	 * @see Zend_Log
	 * @return void
	 */
	protected function _initLoggers() {
		date_default_timezone_set('Europe/Moscow');
		$resources = $this->getOption('resources');
		if ( isset($resources->log) ) {
			$this->bootstrapLog();
			Zend_Registry::set( 'Zend_Log', $this->log );
			$this->bootstrapTranslate();
			$translator = $this->translate;
			$translator->setOptions( array(
				'log' => $this->getLog()
			));
		}
	}

	/**
	 * Установка utf8 в MySQL
	 * @return void
	 */
	protected function _initDbNames() {
		$db = $this->getOption('db');
                $flag = stripos($db['adapter'],'MySQL');
		if(is_array($db)){
	 		if ( $flag!==false && $this->db ) {
	 			
	        		$stmt = $this->db->query("SET NAMES utf8");
			} else {
				return;
			}
		} else {
			return;
		}
	}

        /**
	 * Возвращает роль ACL текущего пользователя, либо гостя
	 * @return Zend_Acl_Role роль ACL
	 * @see Model_Entity_User::getRoleByIdentity()
	 */
	static public function getCurrentUserRole() {
		return Model_Collection_Users::getRoleByIdentity(
			Zend_Auth::getInstance()->getIdentity()
		);
	}

	/**
	 * Возвращает список прав доступа (ACL)
	 * @return Zend_Acl
	 */
	static public function getAcl() {
		if ( !isset( self::$_acl ) ) {
			self::$_acl = new Zend_Acl();
			self::$_acl->addRole(
				new Zend_Acl_Role( Model_Collection_Users::GUEST )
			);
			self::$_acl->addRole(
				new Zend_Acl_Role( Model_Collection_Users::REGISTERED )
				,Model_Collection_Users::GUEST
			);
			self::$_acl->addRole( // полный доступ
				new Zend_Acl_Role( Model_Collection_Users::ADMINISTRATOR )
				,Model_Collection_Users::REGISTERED
			);
		}
		return self::$_acl;
	}

	/**
	 * Возвращает текущий язык
	 * @return Model_Entity_Language
	 */
	static public function getCurrentLanguage() {
		if ( !isset( self::$_language ) ) {
			self::$_language = Model_Collection_Languages::getInstance()->getDefault();
		}
		return self::$_language;
	}

	/**
	 * Возвращает транслятор
	 * @return Zend_Translate
	 */
	static public function getTranslator() {
		// инициализируется ресурсом Translate
		if ( ! Zend_Registry::isRegistered( 'Zend_Translate' ) ) {
			return null;
		}
		return Zend_Registry::get( 'Zend_Translate' );
	}

	/**
	 * Возвращает лог
	 * @see _initLoggers()
	 * @return Zend_Log
	 */
	static public function getLog() {
		// инициализируется ресурсом Log
		if ( ! Zend_Registry::isRegistered( 'Zend_Log' ) ) {
			return null;
		}
		return Zend_Registry::get( 'Zend_Log' );
	}

	/**
	 * Запись в лог дампа
	 * Использование:
	 * <code>
	 * Main::logDebug( $data );
	 * </code>
	 * @param mixed $data
	 * @return void
	 */
	static public function logDebug( $data ) {
		$log = self::getLog();
		if ( isset( $log ) ) $log->debug($data);
	}
	

	/**
	 * Запись в лог исключения
	 * Использование логера для отслеживания ошибок:
	 * <code>
	 * try {
	 * 	// Код с ошибкой
	 * } catch ( Exception $e ) {
	 * 	Main::logErr( $e );
	 * }
	 * </code>
	 * @param Exception $e
	 * @return Exception $e
	 */
	static public function logErr( $e ) {
		$log = self::getLog();
		if ( isset( $log ) ) $log->err( $e );
		return $e;
	}


}