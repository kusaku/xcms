<?php
/**
 * 
 * Свойство - страница по умолчанию (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: DefaultPage.php 119 2010-02-25 13:10:46Z renat $
 */

class Model_Entity_Property_DefaultPage extends Model_Entity_Property_Boolean {
	
	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return Model_Entity_Property_DefaultPage $this
	 */
	public function setValue( $value, $element=null ) {
		if ( $value != $this->getValue( $element ) ) {
			Model_Collection_Elements::getInstance()->setDefault( $element->id );
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return int
	 */
	public function getValue( $element=null ) {
		if ( ! $element instanceof Model_Entity_Element ) {
			throw new Model_Exception ( self::INVALID_WRAPPER );
		}
		return $element->is_default;
	}
}