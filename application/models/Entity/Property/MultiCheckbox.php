<?php
/**
 * 
 * Свойство - группа флагов (чекбоксов)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: MultiCheckbox.php 193 2010-05-26 08:52:04Z igor $
 */

class Model_Entity_Property_MultiCheckbox extends Model_Entity_Property_MultiSelect {
	
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
				->setAttrib( 'class', $this->getTypeName() . ' radiobutton' ) // TODO переименовать класс
				->clearDecorators()
				->addDecorator( 'ViewHelper' )
				->addDecorator( array('elementDiv' => 'HtmlTag'), array( 'class' => 'multidiv' ) )
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) )
				->setMultiOptions( $this->getOptions() );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
}