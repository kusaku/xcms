<?php
/**
 * 
 * Абстрактная коллекция
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Abstract
 * @version    $Id: Collection.php 199 2010-06-02 08:50:44Z renat $
 */

abstract class Model_Abstract_Collection extends Model_Abstract_Singleton {
	
	/**
	 * Централизованное хранилище интерфейсов доступа к таблицам данных
	 * @var array Zend_Db_Table_Abstract
	 */
	private static $_tables = array ();
	
	/**
	 * Имя класса хранимых объектов без префиксов
	 * @var string
	 */
	protected $_entName;
	
	/**
	 * Объекты коллекции
	 * @var array Model_Abstract_Entity
	 */
	protected $_entities = array ();
	
	/**
	 * Разрешает кеширование
	 * @var bool
	 */
	protected $_caching = false;
	
	/**
	 * Устанавливает интерфейс доступа к таблице данных
	 * @param string $dbTable название класса производного от Zend_Db_Table_Abstract
	 * @return true
	 * @throws Model_Exception если $dbTable не является дочерним классом Zend_Db_Table_Abstract
	 */
	protected function setDbTable( $dbTable ) {
		if ( is_string ( $dbTable ) ) {
			$dbTableName = $dbTable;
			$dbTable = new $dbTableName ( );
		}
		if ( ! $dbTable instanceof Zend_Db_Table_Abstract ) {
			throw new Model_Exception ( "Неизвестный интерфейс доступа к таблице данных" );
		}
		Model_Abstract_Collection::$_tables[$dbTableName] = $dbTable;
		return true;
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных по названию
	 * или устанавливает при его отсутствии
	 * По умолчанию - таблица коллекции
	 * @param string $dbTable название класса производного от Zend_Db_Table_Abstract
	 * @return Zend_Db_Table_Abstract
	 */
	protected function getDbTable( $dbTable = null ) {
		if ( !isset( $dbTable ) ) {
			$dbTable = 'Model_DbTable_'.$this->getEntName().'s';
		}
		if ( !isset( Model_Abstract_Collection::$_tables[$dbTable] ) ) {
			$this->setDbTable ( $dbTable );
		}
		return Model_Abstract_Collection::$_tables[$dbTable];
	}
	
	/**
	 * Возвращает фронт кеша коллекции
	 * @return Zend_Cache_Core
	 */
	public static function getCache() {
		return Zend_Registry::get( 'Zend_Cache' )->getCache( 'models' );
	}
	
	/**
	 * Очищает кеш коллекции
	 * @return Model_Abstract_Collection $this
	 */
	public function clearCache() {
		self::getCache()->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			array($this->getEntName().'s')
		);
	}
	
	/**
	 * Задает имя класса объектов коллекции
	 * @param string $entName
	 * @return Model_Abstract_Collection
	 */
	protected function setEntName( $entName ) {
		$this->_entName = ( string ) $entName;
		return $this;
	}
	
	/**
	 * Возвращает имя класса объектов коллекции
	 * @return string
	 */
	public function getEntName() {
		return $this->_entName;
	}
	
	/**
	 * Проверяет загружен ли в коллекцию объект с указанным id 
	 * @param int $id идентификатор объекта
	 * @return bool
	 */
	final public function isLoaded( $id ) {
		return array_key_exists ( $id, $this->_entities );
	}
	
	/**
	 * Возвращает объект коллекции с указанным id
	 * Если такого объекта в коллекции нет, он добавляется 
	 * @param int $id идентификатор объекта
	 * @return Model_Abstract_Entity
	 */
	public function getEntity( $id ) {
		if ( ! $this->isLoaded ( $id ) ) {
			$this->_loadEntity( $id );
		}
		return $this->_entities [ $id ];
	}
	
	/**
	 * Добавляет информационный объект в коллекцию
	 * Для доп.действий переопределить
	 * @param Model_Abstract_Entity $entity
	 * @return Model_Abstract_Entity
	 */
	public function addEntity( $entity ) {
		return $this->_entities [ $entity->id ] = $entity;
	}
	
	/**
	 * Создает новый объект коллекции, сохраняет в БД
	 * @param array $data ассоциативный массив свойств объекта
	 * @return Model_Abstract_Entity|null
	 */
	public function newEntity( array $data ) {
		unset( $data ['id'] );
		$entity = $this->getDbTable()->createRow( $data );
		if ( $entity->save() ) {
			$entity->removeCache();
			return $this->addEntity( $entity );
		}
		return null;
	}
	
	/**
	 * Удаляет объект из коллекции и БД
	 * @param int $id идентификатор удаляемого объекта
	 * @return int число удаленных строк
	 */
	public function delEntity( $id ) {
		$entity = $this->getEntity( $id );
		$result = $entity->delete();
		if ( $result ) {
			$entity->removeCache();
			unset ( $this->_entities[ $id ] );
		}
		return $result;
	}
	
	/**
	 * Задает данные объекту коллекции, сохраняет в БД
	 * @param array $data ассоциативный массив свойств объекта
	 * @param int $id идентификатор обновляемого объекта
	 * @return Model_Abstract_Collection $this
	 */
	public function setFromArray( array $data, $id ) {
		if ( $this->isLoaded ( $id ) ) {
			$this->getEntity ( $id )->setFromArray ( $data )->commit();
		}
		return $this;
	}
	
	/**
	 * Загружает объект в коллекцию из БД
	 * @param int $id идентификатор загружаемого объекта
	 * @return Model_Abstract_Collection $this
	 */
	protected function _loadEntity( $id ) {
		$cacheId = $this->getEntName().$id;
		if ( ! $this->_caching or ! ( $entity = $this->getCache()->load( $cacheId ) ) ) {
			$rows = $this->getDbTable()->find( $id );
			if ( count($rows)>0 ) {
				$entity = $rows->current();
				if ( $this->_caching )
					$this->getCache()->save( $entity, $cacheId, array($cacheId, $this->getEntName().'s') );
			}
		} else {
			$entity->setTable( $this->getDbTable() );
		}
		$this->addEntity( $entity );
		return $this;
	}
	
	/**
	 * Возвращает массив всех объектов загруженных в коллекцию
	 * @return array Model_Abstract_Entity
	 */
	public function fetchAll() {
		$this->_loadAll();
		return $this->_entities;
	}
	
	/**
	 * Загружает из БД все обекты коллекции
	 * @return Model_Abstract_Collection $this
	 */
	protected function _loadAll() {
		$this->_entities = array ();
		$cacheId = $this->getEntName().'s';
		if ( ! $this->_caching or ! ( $entities = $this->getCache()->load( $cacheId ) ) ) {
			$rows = $this->getDbTable ()->fetchAll ();
			foreach ( $rows as $row ) {
				$this->addEntity( $row );
			}
			if ( $this->_caching )
				$this->getCache()->save( $this->_entities, $cacheId, array($cacheId, $cacheId.'All') );
		} else {
			foreach ( $entities as $row ) {
				$this->addEntity( $row );
				$row->setTable( $this->getDbTable() );
			}
		}
		return $this;
	}
}