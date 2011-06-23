<?php
/**
 * 
 * Свойство - число с плавующей точкой
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id:
 */
class Model_Entity_Property_Float extends Model_Entity_Property {
	
	/**
	 * Устанавливает значение свойства
	 * @param float $value
	 * @return Model_Entity_Property_Float $this
	 */
	public function setValue($value) {
		if ( $value != $this->getValue() ) {
			$this->val_float =  (float) $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return float
	 */
	public function getValue() {
		return (float) $this->val_float;
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
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_Float $this
	 */
	public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_float', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}