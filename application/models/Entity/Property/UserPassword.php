<?php
/**
 * 
 * Свойство - пароль доступа пользователя (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: UserPassword.php 156 2010-03-22 14:50:31Z renat $
 */

class Model_Entity_Property_UserPassword extends Model_Entity_Property_Password {
	
	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_User $wrapper объект-обертчик для виртуальных свойств
	 * @return Model_Entity_Property_UserPassword $this
	 */
	public function setValue( $value, $wrapper=null ) {
		if ( ! $wrapper instanceof Model_Entity_User ) {
			throw new Model_Exception ( self::INVALID_WRAPPER );
		}
		if ( !empty( $value ) ) {
			$value = md5( Zend_Registry::get('staticSalt') . $value );
			if ( $value != $wrapper->password ) {
				$wrapper->password = $value;
			}
		}
		return $this;
	}
}