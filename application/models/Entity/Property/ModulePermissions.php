<?php
/**
 * 
 * Свойство - права группы пользователей на модуль (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id $
 */

class Model_Entity_Property_ModulePermissions extends Model_Entity_Property_MultiCheckbox {
	
	const INVALID_MODE = 'Некорректный тип прав на элемент';
	
	/**
	 * Массив возможных значений (список групп пользователей)
	 * @var array
	 */
	protected static $_options;
	
	/**
	 * Массив измененных привелегий Zend_Db_Table_Row permission
	 * @var array
	 */
	protected $_permissions = array();
	
	/**
	 * Устанавливает значение свойства
	 * @param array $value
	 * @param Model_Entity_Element $element OPTIONAL объект элемента данного свойства
	 * @return Model_Entity_Property_ModulePermissions $this
	 */
	public function setValue( $value, $element=null ) {
		$old = $this->getValue( $element );
		$allowList = array_diff( $value, $old ) or array();
		$denyList = array_diff( $old, $value ) or array();
		$role = Model_Collection_Users::getGroupRoleById( $this->getObject()->id )->getRoleId();
		foreach ( $allowList as $action ) {
			if ( is_numeric( $action ) ) {
				$resource_id = $action;
				$mode = null;
			} else {
				list( $resource_id, $mode ) = explode( '-', $action );
			}
			$etype = Model_Collection_ElementTypes::getInstance()->getEntity( $resource_id );
			$permission = $etype->getPermission( $role, $mode );
			if ( $permission->allow != 1 ) {
				$this->_permissions[] = $permission;
				$etype->setPermission( $role, $mode, 1 );
			}
		}
		foreach ( $denyList as $action ) {
			if ( is_numeric( $action ) ) {
				$resource_id = $action;
				$mode = null;
			} else {
				list( $resource_id, $mode ) = explode( '-', $action );
			}
			$etype = Model_Collection_ElementTypes::getInstance()->getEntity( $resource_id );
			$permission = $etype->getPermission( $role, $mode );
			if ( $permission->allow != 0 ) {
				$this->_permissions[] = $permission;
				$etype->setPermission( $role, $mode, 0 );
			}
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Entity_Element $element OPTIONAL объект элемента данного свойства
	 * @return array
	 */
	public function getValue( $element=null ) {
		$mcet = Model_Collection_ElementTypes::getInstance();
		$role = Model_Collection_Users::getGroupRoleById( $this->getObject()->id );
		$actions = array_keys( $this->getOptions() );
		$checked = array();
		foreach ( $actions as $action ) {
			if ( is_numeric( $action ) ) {
				$id = $action;
				$mode = null;
			} else {
				list( $id, $mode ) = explode( '-', $action );
			}
			$etype = $mcet->getEntity( $id );
			if ( $etype->isActionAllowed( $role, $mode ) ) {
				$checked[] = $action;
			}
		}
		return $checked;
	}
	
	/**
	 * Возвращает массив возможных значений
	 * @return array value=>title
	 */
	protected function getOptions() {
		if ( ! isset( self::$_options ) ) {
			self::$_options = array();
			$etypes = Model_Collection_ElementTypes::getInstance()->fetchAll();
			foreach( $etypes as $etype ) {
				if ( $etype->title != null ) { 
					$actions = $etype->getActions();
					foreach( $actions as $name=>$title ) {
						// Для дальнейшего распознования используем 'идТипаЭлемента-имяПривелегии'
						$name = $etype->id . '-' . $name;
						$title = $etype->title . ': ' . $title;
						self::$_options[ $name ] = $title;
					}
				} elseif ( $etype->controller == 'back' ) { // права на администр. часть модуля
					self::$_options[ $etype->id ] = 'Административный интерфейс модуля "' . $etype->module . '"';
				} elseif ( $etype->module == 'admin' ) {
					switch ( $etype->controller ) {
						case '': 
							self::$_options[ $etype->id ] = 'Доступ в административный интерфейс'; 
							break;
						case 'module': 
							self::$_options[ $etype->id ] = 'Меню административного интерфейса'; 
							break;
						case 'config':
							self::$_options[ $etype->id ] = 'Настройки'; 
							break;
					}
				}
			}
		}
		return self::$_options;
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * TODO стоит вертуть setValue для всех а отсуда убрать?
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		return parent::getFormElement()
			->setValue( $this->getValue() ) // исп. объектом
		;
	}
	
	/**
	 * Сохраняет значение свойства
	 * @return Model_Entity_Property $this
	 */
	public function commit() {
		foreach ( $this->_permissions as $permission ) {
			$permission->save();
		}
		return $this;
	}
}