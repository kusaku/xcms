<?php
/**
 * 
 * Свойство - группа флагов (чекбоксов, двумерный)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id:
 */

class Model_Entity_Property_MultiCheckbox2d extends Model_Entity_Property_MultiSelect {
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 * @todo добавить ->setValue( $this->getValue() ) (нельзя из-за дочерних классов)
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_MultiCheckbox( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setSeparator('')
				->setRegisterInArrayValidator( false )
				->setAttrib( 'class', $this->getTypeName() . ' radiobutton' ) // TODO переименовать класс
				->clearDecorators()
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper', array('helper' => 'formMultiCheckbox2d') )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'fullwidth' ) )
				->setMultiOptions( $this->getOptions() );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
}