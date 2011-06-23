<?php
/**
 * 
 * Свойство - пароль
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Password.php 137 2010-03-12 14:58:50Z renat $
 */

class Model_Entity_Property_Password extends Model_Entity_Property_String {
	
	/**
	 * Устанавливает значение свойства, предварительно закодировав в md5
	 * @param int $value
	 * @param Model_Entity OTPTIONAL $wrapper объект-обертчик для виртуальных свойств
	 * @return Model_Entity_Property_Password $this
	 */
	public function setValue( $value, $wrapper=null ) {
		$value = md5( $value );
		if ( $value != $this->getValue() ) {
			$this->val_varchar = $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства (заглушка)
	 * @param Model_Entity OPTIONAL $wrapper объект-обертчик для виртуальных свойств
	 * @return int
	 */
	public function getValue( $wrapper=null ) {
		return null;
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Password( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) )
				->addFilter( 'StringTrim' );
		return $element;
	}
}