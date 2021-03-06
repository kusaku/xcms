<?php
/**
 * 
 * Свойство - флаг
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Boolean.php 191 2010-05-21 09:59:29Z igor $
 */

class Model_Entity_Property_Boolean extends Model_Entity_Property {
	
	/**
	 * Устанавливает значение свойства
	 * @param bool $value
	 * @return Model_Entity_Property_Boolean $this
	 */
	public function setValue( $value ) {
		if ( $value != $this->getValue() ) {
			$this->val_int = (bool) $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return bool
	 */
	public function getValue() {
		return (bool) $this->val_int;
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Checkbox( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( 'ViewHelper' )
				->addDecorator( array('span'=>'HtmlTag'), array( 'tag'=>'div' ) )
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_Boolean $this
	 */
	public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_int', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}