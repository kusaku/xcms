<?php
/**
 * 
 * Свойство - псевдостатический адрес a.k.a. "URL страницы" (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Urlname.php 349 2010-09-02 11:22:11Z kifirch $
 */

class Model_Entity_Property_Urlname extends Model_Entity_Property_String {
	
	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return Model_Entity_Property_Urlname $this
	 */
	public function setValue( $value, $element=null ) {
		$value =  strtr( $value, ' ', '_' ) ;
		if ( $value != $this->getValue( $element ) ) {
			$element->urlname = $value;
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
		return $element->urlname;
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = parent::getFormElement();
		$field
			->addFilter( 'Callback', array( 'strtr', array( '_', ' ' ) ) )
		//	->addFilter( 'Alnum', array( true ) )
		;
		return $field;
	}
}