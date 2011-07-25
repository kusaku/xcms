<?php
/**
 * 
 * Коллекция пользователей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: Users.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_Collection_Users extends Model_Abstract_Collection {
	
	/*
	 * Идентификаторы типов данных
	 */
	const USERGROUP_OTYPE_ID = 1;
	const USER_OTYPE_ID      = 2;

    /**
     * Идентификаторы системных групп пользователей ( используется в ACL ), не менять
     */
    const GUEST         = 1; // также пользователь 'гость'
    const REGISTERED    = 2;
    const ADMINISTRATOR = 3;
    const LIMITED       = 4; // ограниченный доступ
    
    /**
     * Префиксы идентификаторов ролей (не применяются для гостя)
     */
	const GROUP_ROLE_PREFIX = ''; // группы пользователей
    const USER_ROLE_PREFIX  = '#'; // пользователя
	
	/**
	 * Конструктор коллекции
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'User' );
	}
	
        
        /**
         * Возвращает пользователя по id объекта
         * @param int $id 
         */
        public function getUserByObject($id) {
            $sel = $this->getDbUsers()->select()->where('id_object=?', (int)$id);
            $obj = $this->getDbUsers()->fetchRow($sel);
            return $this->getEntity($obj->id);            
        }


        public function getUsersByGroup($group_id) {
	    $sel = $this->getDbUsers()->select()->where('id_usergroup=?', (int)$group_id);
	    $rows = $this->getDbUsers()->fetchAll($sel);
	    return $rows;
	}
	
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_Users экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbUsers() {
		return $this->getDbTable( 'Model_DbTable_Users' );
	}
	
	/**
	 * Возвращает и добавляет в ACL роль для пользователя, по-умолчанию и в случае его отсутствия - для гостя
	 * @param mixed $identity целочисленный идентификатор пользователя либо объект-хранилище данных пользователя
	 * @return Zend_Acl_Role роль ACL
	 */
	static public function getRoleByIdentity( $identity = null ) {
		$user_id = 0;
		$usergroup_id = null;
		if ( is_object( $identity ) ) {
			if ( ! is_null( $identity->id ) ) {
				$user_id = $identity->id;
				$usergroup_id = isset( $identity->id_usergroup ) ? $identity->id_usergroup : (self::GUEST);
			} else {
				if (APPLICATION_ENV != 'production')
					throw new Model_Exception( 'Некорректные данные о пользователе' );
			}
		}
		// префикс позволяет разделять роли групп и пользователей
		$role_id = ( $user_id != 0 ) ? (self::USER_ROLE_PREFIX.$user_id) : (self::GUEST);
		if ( Main::getAcl()->hasRole( $role_id ) ) {
			return Main::getAcl()->getRole( $role_id );
		} else {
			$group = !empty($usergroup_id) ? self::getGroupRoleById( $usergroup_id ) : null;
			$role = new Zend_Acl_Role( $role_id );
			Main::getAcl()->addRole( $role, $group );
			return $role;
		}
	}
	
	/**
	 * Возвращает и добавляет в ACL роль для группы пользователя
	 * @param int $identity целочисленный идентификатор группы пользователей
	 * @return Zend_Acl_Role роль ACL
	 */
	static public function getGroupRoleById( $usergroup_id ) {
		$usergroup_id = (int) $usergroup_id;
		$role_id = ( $usergroup_id != 0 ) ? (self::GROUP_ROLE_PREFIX.$usergroup_id) : (self::GUEST);
		if ( Main::getAcl()->hasRole( $role_id ) ) {
			return Main::getAcl()->getRole( $role_id );
		} else {
			$role = new Zend_Acl_Role( $role_id );
			Main::getAcl()->addRole( $role, self::REGISTERED );
			return $role;
		}
	}
	
	/**
	 * Создает нового пользователя и добавляет его в коллекцию (доступен по id=0)
	 * @param $data OPTIONAL данные инициализации
	 * @return Model_Collection_Users
	 */
	public function createUser( $data=array() ) {
		if ( !isset($data['id_usergroup']) or empty($data['id_usergroup']) ) {
			throw new Model_Exception( 'Не указана группа для пользователя' );
		}
		// Создаем объект данных
		$new_object = Model_Collection_Objects::getInstance()->createObject( array(
			'id_type' => self::USER_OTYPE_ID,
			'title'   =>'Новый'
		) );
		if ( ! isset( $new_object ) ) {
			throw new Model_Exception( "Ошибка создания объекта данных для нового пользователя" );
		}
		unset( $data['id'] );
		$data[ 'id_object' ] = $new_object->id; // фактически == 0
		$new_object = $this->addEntity( $this->getDbUsers()->createRow( $data ) );
		return $new_object;
	}
	
	public function getUserByName($name) {
		$sel = $this->getDbUsers()->select()->where('name=?', $name);
	    $row = $this->getDbUsers()->fetchRow($sel);
	    return $row;
	}
}