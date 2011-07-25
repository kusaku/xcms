<?php
/**
 * 
 * Элемент дерева структуры сайта
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: Element.php 532 2010-10-19 12:25:00Z kifirch $
 */

class Model_Entity_Element extends Model_Abstract_Entity {
    
    /**
     * Префикс идентификатора ресурса
     */
    const RESOURCE_PREFIX = '';
	
	/**
	 * Тип элемента дерева
	 * @var Model_Entity_ElementType
	 */
	protected $_type;
	
	/**
	 * Объект
	 * @var Model_Entity_Object
	 */
	protected $_object;
	
	/**
	 * Шаблон элемента дерева
	 * @var Model_Entity_Template
	 */
	protected $_template;
	
	/**
	 * Права на элемент
	 * @var array
	 */
	protected $_permissions = array();
	
	/**
	 * Возвращает тип
	 * @return Model_Entity_ElementType тип элемента
	 */
	public function getType() {
		if ( !isset( $this->_type ) ) {
			$this->_type = Model_Collection_ElementTypes::getInstance()->getEntity( $this->id_type );
		}
		return $this->_type;
	}
	
	/**
	 * Возвращает объект (учитываются права доступа)
	 * @return Model_Entity_Object
	 * @throws Model_Exception если у текущего пользователя нет прав на чтение данных элемента
	 */
	public function getObject() {
		if ( !isset( $this->_object ) ) {
			/*if ( ! $this->isReadable() ) {
				throw new Model_Exception( "Нет прав на чтение данных элемента дерева с id='{$this->id}' " );
			}*/
			$this->_object = Model_Collection_Objects::getInstance()->getEntity( $this->id_obj );
		}
		return $this->_object;
	}
	
	/**
	 * Возвращает родительский элемент
	 * @return Model_Entity_Element
	 */
	public function getParent() {
		return Model_Collection_Elements::getInstance()->getEntity( $this->id_parent );
	}

        /**
	 * Возвращает дочерние элементы
	 * @param int $type_id OPTIONAL идентификатор типа элементов (null)
	 * @param string $order OPTIONAL колонка или поле сортировки (ord) можно исп. DESC
	 * @return array
	 */
	public function getChildren( $type_id=null, $order='ord' ) {
		$table = Model_Collection_Elements::getInstance()->getDbElements();
		$select = $table->select()
			->where( 'is_active = 1' )
			->where( 'is_deleted = 0' ) 
		;
		if ( isset($type_id) ) {
			$select->where( 'id_type = ?', (int) $type_id );
		}
		list($order_col) = explode( ' ', $order );
		$user_sort = ! in_array( $order_col, $table->info('cols') );
		if ( !$user_sort ) { // сортировка уровня БД
			$select->order( $order );
		}
		$rows = $this->findDependentRowset( $table, null, $select );
		$items = array();
		foreach ( $rows as $row ) {
			$items[ $row->id ] = Model_Collection_Elements::getInstance()->addEntity( $row );
		}
		if ( $user_sort ) { // php-cортировка uasort с использованием Model_Collection_Elements::compare()
			$d = explode( ' ', $order );
			$field = $d[0];
			$dir = isset($d[1]) ? $d[1] : ''; // порядок сортировки
			if ( empty($type_id) ) $type_id = $this->id_type;
			$etype = Model_Collection_ElementTypes::getInstance()->getEntity( $type_id );
			$etype->setCompareBy( $field );
			$fun = ($dir == 'DESC') ? 'compareRev' : 'compare';
			uasort( $items, array( Model_Collection_Elements::getInstance(), $fun ) );
		}
		return $items;
	}
	
	/**
	 * Возвращает ресурс списока прав доступа (ACL) элемента
	 * @return Zend_Acl_Resource
	 */
	public function getAclResource() {
		$acl = Main::getAcl();
		$resource_id = self::RESOURCE_PREFIX . $this->id;
		if ( ! $acl->has( $resource_id ) ) {
			$resource = new Zend_Acl_Resource( $resource_id ); // ресурс ACL для страницы
			$acl->add( 
				$resource, 
				$this->getType()->getAclResource() // наследуем права из типа элемента
			);
			if( $this->id != 0 ){
				$permissions_table = Model_Collection_Elements::getInstance()->getDbPermissionsElements();
				$permissions = $this->findDependentRowset( $permissions_table );
				foreach($permissions as $permission) {
					$role = Model_Collection_Users::getGroupRoleById( $permission->id_owner );
					/*
					 * null - inherited
					 * 0 - deny
					 * 1 - allow
					 */
					$mode = empty( $permission->mode ) ? null : $permission->mode; // mode=null - полные права на ресурс
					if ( ! is_null( $permission->allow ) ) {
						if ( $permission->allow ) {
							$acl->allow( $role, $resource, $mode );
						} else {
							$acl->deny( $role, $resource, $mode );
						}
					}
					// Сохраняем чтобы [можно было] изменять в сеттерах
					$this->_permissions[ $role->getRoleId() . $mode ] = $permission;
				}
			}
			return $resource;
		} else {
			return $acl->get( $resource_id );
		}
	}
	
	/**
	 * Проверяет, есть ли у текущего пользователя привелегия $mode
	 * @param string $mode имя привелегии
	 * @return bool
	 */
	protected function _isAllowed( $mode ) {
		$user = Main::getCurrentUserRole();
		$resource = $this->getAclResource();
		if ( ! Main::getAcl()->hasRole( $user ) ) {
			$user = Model_Collection_Users::GUEST;
		}
		return Main::getAcl()->isAllowed( $user, $resource, $mode );
	}
	
	/**
	 * Проверяет, есть ли у текущего пользователя права на чтение
	 * @return bool
	 */
	public function isReadable() {
		return $this->_isAllowed( 'view' );
	}
	
	/**
	 * Проверяет, есть ли у текущего пользователя права на запись
	 * @return bool
	 */
	public function isWritable() {
		return $this->_isAllowed( 'edit' );
	}
	
	/**
	 * Проверяет права на элемент $mode для ролей $roles
	 * @param array $roles идентификаторов ролей субъектов
	 * @param array $modes имена привелегий
	 * @return array массив идентификаторов субъектов имеющих искомые права
	 */
	public function checkPermissions( $roles, $modes ) {
		$resource = $this->getAclResource();
		$allowList = array();
		foreach ( $roles as $role ) {
			$allowList[$role] = array();
			foreach( $modes as $k=>$mode ){
				if ( Main::getAcl()->hasRole( $role ) and 
					Main::getAcl()->isAllowed( $role, $resource, $mode ) )
					$allowList[$role][] = $k;
			}
		}
		return $allowList;
	}
	
	/**
	 * Возвращает строку БД (либо создает новую) для привелегии $mode для роли
	 * @param Zend_Acl_Role|string $role роль ACL субъекта
	 * @param string $mode OPTIONAL имя привелегии
	 * @return Zend_Db_Table_Row строка БД из PermissionsModules
	 */
	public function getPermission( $role, $mode=null ) {
		$role = (string) $role;
		$resource = $this->getAclResource()->getResourceId();
		$mode = (string) $mode;
		if ( ! isset( $this->_permissions[ $role . $mode ] ) ) {
			$permissions_table = Model_Collection_Elements::getInstance()->getDbPermissionsElements();
			return $this->_permissions[ $role . $mode ] = 
				$permissions_table->createRow( array(
					'id_owner' => $role,
					'id_element' => $this->id, // без префикса
					'mode' => $mode,
					'allow' => null
				)
			);
		}
		return $this->_permissions[ $role . $mode ];
	}
	
	/**
	 * Устанавливает привелегию $mode на элемент для роли
	 * @param Zend_Acl_Role|string $role роль ACL субъекта
	 * @param string $mode имя привелегии
	 * @param int $allow 1|0 разрешить или нет
	 * @return Model_Entity_Element $this
	 */
	public function setPermission( $role, $mode, $allow ) {
		$permission = $this->getPermission( $role, $mode );
		if ( is_null( $allow ) ) {
			if ( isset( $this->_permissions[ $role . $mode ] ) ) {
				$permission->delete();
				unset( $this->_permissions[ $role . $mode ] );
			}
			return $this;
		}
		if ( is_null( $permission->allow ) or ( (int) $allow != $permission->allow ) ) {
			if ( $allow ) {
				Main::getAcl()->allow( $role, $this->getAclResource(), $mode );
			} else {
				Main::getAcl()->deny( $role, $this->getAclResource(), $mode );
			}
			$permission->allow = $allow;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства по имени поля, если не существует - null
	 * @param string $field_name
	 * @return mixed
	 */
	public function getValue( $field_name ) {
		$property = $this->getObject()->getPropertyByName( $field_name );
		if ( isset($property) ) {
			return $property->isVirtual() ? $property->getValue( $this ) : $property->getValue();
		}
		return null;
	}
	
	/**
	 * Устанавливает значение свойства
	 * @param string $field_name
	 * @param mixed $value
	 * @return Model_Entity_Element $this
	 */
	public function setValue( $field_name, $value ) {
		if($field_name == "urlname" && file_exists("./" . $value))
			return false;
		$property = $this->getObject()->getPropertyByName( $field_name );
		if ( isset( $property ) ) {
			if ( $property->isVirtual() ) {
				$property->setValue( $value, $this );
			} else {
				// TODO разрешено ли пользователю работать с группами?
				$property->setValue( $value );
			}
		} else {
			throw new Model_Exception ( "Ошибка при присвоении значения свойству '$field_name' " );
		}
		return $this;
	}
	
	/**
	 * Устанавливает значения свойств элемента из массива
	 * @param array $values массив значений: имя_поля => значение
	 * @return Model_Entity_Element $this
	 */
	public function setValues( $values ) {
		foreach ( $values as $name=>$value ) {
			$property = $this->getObject()->getPropertyByName( $name );
			if ( isset( $property ) ) {
				$this->setValue( $name, $value ); // исп. метод элемента
			}
		}
		return $this;
	}
	
	/**
	 * Возвращает значения свойств элемента
	 * @param bool $inc_nonpublic OPTIONAL включить в результаты не публичные данные (false)
	 * @return array массив значений: имя_поля => значение
	 */
	public function getValues( $inc_nonpublic=false ) {
		$groups = $this->getObject()->getPropertyGroups();
		$values = array();
		foreach ( $groups as $group ) {
			foreach ( $group as $field_id ) {
				$field = $this->getObject()->getPropertyById( $field_id )->getField();
				if ( $inc_nonpublic or $field->is_public ) {
					$values[ $field->name ] = $this->getValue( $field->name ); // исп. метод элемента
				}
			}
		}
		$values['id'] = $this->id;
		$values['updatetime'] = $this->updatetime;
		// TODO добавить другие, нужные для фронта, поля без свойств
		return $values;
	}
		
	/**
	 * Возвращает форму редактирования элемента
	 * @param bool $disabled OPTIONAL блокировать форму (false)
	 * @return Zend_Form
	 */
	public function getEditForm( $disabled=false ) {
		$skip = array();
		if ( ! Model_Collection_ElementTypes::getInstance()
				->getModuleElementType( 'users', 'group' ) // разрешено ли работать с группами пользователей?
					->isActionAllowed( Main::getCurrentUserRole(), 'edit' ) )
			$skip[] = 'permissions_elements';
		$form = $this->getObject()->getEditForm( $disabled, true, $skip );
		$form->setDefaults( $this->getValues( true ) );
		return $form;
	}
	
	/**
	 * Возвращает шаблон элемента
	 * @return Model_Entity_Template шаблон элемента
	 */
	public function getTemplate() {
		if ( ! isset( $this->_template ) ) {
			if ( empty( $this->id_tpl ) ) {
				$this->_template = Model_Collection_Templates::getInstance()
					->getDefault();
			} else {
				$this->_template = Model_Collection_Templates::getInstance()
					->getEntity( $this->id_tpl );
			}
		}
		return $this->_template;
	}
	
	/**
	 * @return Zend_Navigation_Page
	 */
	public function getPage() {
		$data = array(
			'id'        => $this->id, 
			'label'     => $this->getObject()->title,
			'title'     => $this->getObject()->title,
			'params'    => array( 
				'id'=>$this->id 
			),
			'resource'  => $this->getAclResource(),
			'privilege' => 'view',
			'visible'   => $this->is_active and ! $this->is_deleted,
			'lastmod'   => $this->updatetime,
		);
                
		$etype = $this->getType();
		$data[ 'module' ] = $etype->module;
		$data[ 'controller' ] = empty($etype->controller) ? 'page' : $etype->controller;
		if ( $this->is_default ) {
			$data[ 'route' ] = 'home';
		} else {
			if ( Zend_Registry::getInstance()->get( 'use_urlnames' ) ) {
				$data[ 'action' ] = 'alias';
				$data[ 'route' ] = 'content_alias';
				$data[ 'params' ] = array( 'urlname'=>$this->urlname );
			} else {
				$data[ 'action' ] = 'view';
				$data[ 'route' ] = $data['module'].'_'.$data['controller'];
			}
		}
                
		if ( $this->getValue( 'menu_collapsed' ) ) {
			$data[ 'collapsed' ] = true;
		}
		$page = Zend_Navigation_Page::factory( $data );
                return $page;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
		$cache = Model_Abstract_Collection::getCache();
		$tags = array('ElementsAll', 'Element'.$this->id);
		if ( !empty($this->id_menu) or in_array( 'id_menu', $this->_modifiedFields ) ) {
			$tags[] = 'Navigation';
		}
		if ( !empty( $this->is_default ) ) {
			$tags[] = 'Element0';
		}
		$cache->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			$tags
		);
	}
	
    /**
	 * Сохранить в базу все изменения (учитываются права доступа)
	 * @return Model_Entity_Element $this
	 * @throws Model_Exception если у текущего пользователя нет прав на редактирование элемента
	 */
	public function commit() {
		if ( ! $this->isWritable() ) {
			throw new Model_Exception( "Нет прав на редактирование элемента дерева с id='{$this->id}' " );
		}
		$this->removeCache();
		$db = $this->getTable()->getAdapter()->beginTransaction();
		try {
            // commit
            $this->getObject()->commit();
			if ( $this->id_obj == 0 ) {
				$this->id_obj = $this->getObject()->id;
			}
			if ( $this->id_parent == 0 ) {
				$this->id_parent = null;
			}
			//if ( !empty( $this->_modifiedFields ) ) { // TODO как определить внесены ли какие-либо изменения?
				$this->updatetime = date_create()->format('Y-m-d H:i:s'); // дата изменения
				$this->save();
			//}
			$db->commit();
                        
		} catch ( Exception $e ) {
			$db->rollBack();
			throw new Model_Exception( $e );
		}
		Model_Search::getInstance()->index($this);
		return $this;
	}
}