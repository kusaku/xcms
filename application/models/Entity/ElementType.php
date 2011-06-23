<?php
/**
 * 
 * Тип элемента дерева сайта 
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: ElementType.php 623 2011-01-18 12:48:46Z kifirch $
 */

class Model_Entity_ElementType extends Model_Abstract_Entity {
    
    /**
     * Префикс идентификатора ресурса
     */
    const RESOURCE_PREFIX = '#';
	
	/**
	 * Массив прав
	 * @var array
	 */
	protected $_permissions = array();
	
	/**
	 * Имя поля для сортировки
	 * @var string
	 */
	protected $_compareBy = 'title';
	
	/**
	 * Магический метод используемый при приведении объекта к строке
	 * @return string
	 */
	public function __toString() {
		return (string) $this->title;
	}
	/**
	* Возвращает имя модуля
	* @return string
	*/
	public function getModule(){
		return $this->module;
	}

        public function getAction(){
            return $this->action;
        }

        

	public function getElementClass() {
		return $this->module . '_' . $this->controller;
	}
	
	/**
	 * Возвращает соответствующий тип данных
	 * @return Model_Entity_ObjectType|null тип данных
	 */
	public function getObjectType() {
		$table = Model_Collection_ObjectTypes::getInstance()->getDbObjectTypes();
		return $table->fetchRow( $table->select()
			->where( 'id_element_type = ?', $this->id ) 
		);
	}
	
	/**
	 * Возвращает ресурс типа_элемента
	 * @return Zend_Acl_Resource
	 */
	public function getAclResource() {
		$acl = Main::getAcl();
		$resource_id = self::RESOURCE_PREFIX . $this->id;
		if ( ! $acl->has( $resource_id ) ) {
			$resource = new Zend_Acl_Resource( $resource_id );
			$acl->add( $resource );
			// Запрещено все, что не разрешено
			$permissions_table = Model_Collection_ElementTypes::getInstance()->getDbPermissionsModules();
			$permissions = $this->findDependentRowset( $permissions_table );
			foreach($permissions as $permission) {
				$role = Model_Collection_Users::getGroupRoleById( $permission->id_owner );
				/*
				 * null - inherited
				 * 0 - deny
				 * 1 - allow
				 */
				if ( ! is_null( $permission->allow ) ) {
					$mode = empty( $permission->mode ) ? null : $permission->mode; // mode=null - полные права на ресурс
					if ( $permission->allow ) {
						$acl->allow( $role, $resource, $mode );
					} else {
						$acl->deny( $role, $resource, $mode );
					}
				}
				// Сохраняем чтобы [можно было] изменять в сеттерах
				$this->_permissions[ $role->getRoleId() ][ $mode ] = $permission;
			}
			return $resource;
		} else {
			return $acl->get( $resource_id );
		}
	}
	
	/**
	 * Проверяет, есть ли у роли $role привелегия $mode
	 * @param Zend_Acl_Role|string $role роль ACL субъекта
	 * @param string $mode имя привелегии
	 * @return bool
	 */
	public function isActionAllowed( $role, $mode ) {
		$resource = $this->getAclResource();
		$mode = empty( $mode ) ? null : $mode; // mode=null - полные права на ресурс
		if ( ! Main::getAcl()->hasRole( $role ) ) {
			$role = Model_Collection_Users::GUEST;
		}
		return Main::getAcl()->isAllowed( $role, $resource, $mode );
	}
	
	/**
	 * Проверяет права $mode для ролей $roles
	 * @param array $roles массив ролей (идентификаторов ролей) субъектов
	 * @param string $mode имя привелегии
	 * @return array массив идентификаторов субъектов имеющих искомые права
	 */
	public function checkPermissions( $roles, $mode ) {
		$resource = $this->getAclResource();
		$mode = empty( $mode ) ? null : $mode;
		$allowList = array();
		foreach ( $roles as $role ) {
			if ( Main::getAcl()->hasRole( $role ) and 
				 Main::getAcl()->isAllowed( $role, $resource, $mode ) )
				$allowList[] = $role;
		}
		return $allowList;
	}
	
	/**
	 * Возвращает строку БД (либо создает новую) для привелегии $mode для роли
	 * @param Zend_Acl_Role|string $role роль ACL субъекта
	 * @param string $mode имя привелегии
	 * @return Zend_Db_Table_Row строка БД из PermissionsModules
	 */
	public function getPermission( $role, $mode ) {
		$role = (string) $role;
		$resource = $this->getAclResource()->getResourceId();
		$mode = (string) $mode;
		if ( ! isset( $this->_permissions[ $role ][ $mode ] ) ) {
			$permissions_table = Model_Collection_ElementTypes::getInstance()->getDbPermissionsModules();
			return $this->_permissions[ $role ][ $mode ] =
				$permissions_table->createRow( array(
					'id_owner' => $role,
					'id_etype' => $this->id, // без префикса
					'mode' => $mode,
					'allow' => null
				)
			);
		}
		return $this->_permissions[ $role ][ $mode ];
	}
	
	/**
	 * Устанавливает привелегию $mode для роли
	 * @param Zend_Acl_Role|string $role роль ACL субъекта
	 * @param string $mode имя привелегии
	 * @param int $allow 1|0 разрешить или нет
	 * @return Model_Entity_ElementType $this
	 */
	public function setPermission( $role, $mode, $allow ) {
		$permission = $this->getPermission( $role, $mode );
		if ( $permission->allow != $allow ) {
			$permission->allow = $allow;
			$mce = Model_Collection_Elements::getInstance();
			$elements = $this->findDependentRowset( $mce->getDbElements() );
			foreach( $elements as $element ) {
				$actions = $this->getActions();
				foreach( $actions as $mode=>$action )
					$element->setPermission( $role, $mode, null );
			}
		}
		return $this;
	}
	
	/**
	 * Возвращает имя поля сортировки
	 * @return string
	 */
	public function getCompareBy() {
		return $this->_compareBy;
	}
	
	/**
	 * Устанавливает имя поля сортировки
	 * @param $name
	 * @return Model_Entity_ElementType $this
	 * @todo проверить на существование поля соотв. ObjectType-а
	 */
	public function setCompareBy( $name ) {
		$this->_compareBy = $name;
		return $this;
	}
	
	/**
	 * Возвращает список возможный действий над элементами данного типа 
	 * @return array
	 * @todo сделать динамическим (из БД?)
	 */
	public function getActions() {
		return array(
			"view" => "просмотр", 
			"edit" => "изменение"
		);
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
	}
	
	/**
	 * Сохранить в базу все изменения
	 * @return Model_Entity_ElementType $this
	 * @throws Model_Exception ошибка при сохранении в БД
	 */
	public function commit() {
		$this->removeCache();
		try {
			if ( !empty( $this->_modifiedFields ) ) {
				$this->save();
			}
		} catch ( Exception $e ) {
			throw new Model_Exception( $e );
		}
		return $this;
	}
}