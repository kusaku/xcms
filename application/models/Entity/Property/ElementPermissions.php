<?php
/**
 * 
 * Свойство - права на элемент (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: ElementPermissions.php 184 2010-05-12 08:44:21Z igor $
 */

class Model_Entity_Property_ElementPermissions extends Model_Entity_Property_MultiCheckbox2d {
	
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
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return Model_Entity_Property_ElementPermissions $this
	 */
	public function setValue( $value, $element=null ) {
		$mode = $this->getMode();
		$old = $this->getValue( $element );
		$allowList = array();
		$denyList = array();
		$options = $this->getOptions();
		foreach($old as $key=>$val){
			if( empty($value[$key]) )
				continue;
			if( empty($old[$key]) ){
				$array = $value[$key];
			}else{	
				$array = array_diff( $value[$key], $old[$key] );
			}
			if(!empty($array)){
				$allowList[$key] = $array;
			}
		}
		foreach($old as $key=>$val){
			if( empty($old[$key]) )
				continue;
			if( empty($value[$key]) ){
				$array = $old[$key];
			}else{
				$array = array_diff( $old[$key], $value[$key] );
			}
			if(!empty($array)){
				$denyList[$key] = $array;
			}
		}
		foreach ( $allowList as $role_id=>$role_val ) {
				foreach ( $role_val as $mode_id ) {
						$mode = $options[1][$mode_id];
						$permission = $element->getPermission( $role_id, $mode );
						if ( $permission->allow !== '1' ) {
							$this->_permissions[] = $permission;
							$element->setPermission( $role_id, $mode, 1 );
						}
				}
		}
		foreach ( $denyList as $role_id=>$role_val ) {
				foreach ( $role_val as $mode_id ) {
						$mode = $options[1][$mode_id];
						$permission = $element->getPermission( $role_id, $mode );
						if ( $permission->allow !== '0' ) {
							$this->_permissions[] = $permission;
							$element->setPermission( $role_id, $mode, 0 );
						}
				}
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return array
	 */
	public function getValue( $element=null ) {
		if ( ! $element instanceof Model_Entity_Element ) {
			throw new Model_Exception ( self::INVALID_WRAPPER );
		}
		$options = $this->getOptions();
		$role_ids = array_keys( $options[0] );
		$permissions = $element->checkPermissions( $role_ids, $options[1] );
		return $permissions;
	}
	
	/**
	 * Возвращает массив возможных значений
	 * @return array value=>title
	 */
	protected function getOptions() {
		if ( ! isset( self::$_options ) ) {
			self::$_options = array(
				Model_Collection_Objects::getInstance()->getGuideObjects( $this->getField()->id_guide ), 
				array( 'view', 'edit')
			);
		}
		return self::$_options;
	}
	
	/**
	 * Возвращает имя привелегии для данного свойства
	 * @return string
	 */
	protected function getMode() {
		list(,$mode) = explode( '_', $this->getField()->name );
		if ( ! in_array( $mode, array('elements') ) ) {
			throw new Model_Exception ( self::INVALID_MODE );
		}
		return $mode;
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