<?php
/**
 * 
 * Свойство - строка
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: String.php 180 2010-04-28 08:40:18Z igor $
 */

class Model_Entity_Property_String extends Model_Entity_Property {
	
	/**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @return Model_Entity_Property_String $this
	 */
	public function setValue($value) {
		if ( $value != $this->getValue() ) {
			$this->val_varchar = (string) $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return string
	 */
	public function getValue() {
		return (string) $this->val_varchar;
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Text( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setAttrib( 'class', $this->getTypeName().' input-text' )
				->clearDecorators()
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) )
				->addFilter( 'StringTrim' );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_String $this
	 */
	public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_varchar', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}