<?php
/**
 * 
 * Свойство - группа пользователей (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: UserGroup.php 119 2010-02-25 13:10:46Z renat $
 */

class Model_Entity_Property_UserGroup extends Model_Entity_Property_Radio {
	
	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_User $wrapper 
	 * @return Model_Entity_Property_UserGroup $this
	 */
	public function setValue( $value, $wrapper=null ) {
		if ( $value != $this->getValue( $wrapper ) ) {
			$wrapper->id_usergroup = (int) $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Entity_User $wrapper 
	 * @return int
	 */
	public function getValue( $wrapper=null ) {
		if ( ! $wrapper instanceof Model_Entity_User ) {
			throw new Model_Exception ( self::INVALID_WRAPPER );
		}
		return $wrapper->id_usergroup;
	}
}