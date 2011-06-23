<?php
/**
 * 
 * Свойство - дата
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Date.php 199 2010-06-02 08:50:44Z renat $
 */

class Model_Entity_Property_Date extends Model_Entity_Property_String {
	
	/**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @return Model_Entity_Property_String $this
	 */
	public function setValue($value) {
		if ( $value != $this->getValue() ) {
			$date = date_create( $value );
			if ( $date ) {
				$this->val_varchar = $date->format('Y-m-d');
			}
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return string
	 */
	public function getValue() {
		if ( empty($this->val_varchar) ) {
			return date( 'Y-m-d' );
		}
		return (string) $this->val_varchar;
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new ZendX_JQuery_Form_Element_DatePicker( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'UiWidgetElement' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
}