<?php
/**
 * 
 * Свойство - активность (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Active.php 394 2010-09-16 11:50:56Z igor $
 */

class Model_Entity_Property_Active extends Model_Entity_Property_Boolean {
	
	/**
	 * Устанавливает значение свойства
	 * @param bool $value
	 * @param Model_Abstract_Entity $wrapper объект-обертчик для виртуальных свойств
	 * @return Model_Entity_Property_Publish $this
	 */
	public function setValue( $value, $wrapper=null ) {
		if ( $value != $this->getValue( $wrapper ) ) {
			$wrapper->is_active = (int) $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Abstract_Entity $wrapper объект-обертчик для виртуальных свойств
	 * @return bool
	 */
	public function getValue( $wrapper=null ) {
		if ( ! $wrapper instanceof Model_Abstract_Entity ) {
			throw new Model_Exception ( self::INVALID_WRAPPER );
		}
		return (int) $wrapper->is_active;
	}
}