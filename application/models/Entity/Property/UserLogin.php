<?php
/**
 * 
 * Свойство - логин пользователя (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: UserLogin.php 128 2010-03-02 07:54:19Z renat $
 */

class Model_Entity_Property_UserLogin extends Model_Entity_Property_String {
	
	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_User $wrapper объект-обертчик для виртуальных свойств
	 * @return Model_Entity_Property_UserLogin $this
	 */
	public function setValue( $value, $wrapper=null ) {
		if ( $value != $this->getValue( $wrapper ) ) {
			$wrapper->name = $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Entity_Element $wrapper объект-обертчик для виртуальных свойств
	 * @return int
	 */
	public function getValue( $wrapper=null ) {
		if ( ! $wrapper instanceof Model_Entity_User ) {
			throw new Model_Exception ( self::INVALID_WRAPPER );
		}
		return $wrapper->name;
	}
}