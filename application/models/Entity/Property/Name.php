<?php
/**
 * 
 * Свойство - заголовок объекта a.k.a. "короткое название" (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Name.php 156 2010-03-22 14:50:31Z renat $
 */

class Model_Entity_Property_Name extends Model_Entity_Property_String {
	
	/**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @param Model_Abstract_Entity $wrapper OPTIONAL объект-обертчик для виртуальных свойств
	 * @return Model_Entity_Property_Name $this
	 */
	public function setValue( $value, $wrapper=null ) {
		if ( $this->getObject()->title !== $value ) {
			$this->getObject()->title = $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Abstract_Entity $wrapper OPTIONAL объект-обертчик для виртуальных свойств
	 * @return string
	 */
	public function getValue( $wrapper=null ) {
		return $this->getObject()->title;
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		return parent::getFormElement()
			->setValue( $this->getValue() );
	}
}