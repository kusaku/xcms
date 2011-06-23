<?php
/**
 * 
 * Свойство - фотография
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id:
 */

class Model_Entity_Property_Photo extends Model_Entity_Property_String {
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Hidden( $field->name );
		$module = $this->getObject()->getType()->getElementType()->getModule();
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setAttribs( array('class' => $this->getTypeName(), 'module' => $module))
				->clearDecorators()
				->addDecorator( array('elementDiv' => 'HtmlTag'), array( 'id' => 'upload', 'tag' => 'a' ) )
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper', array('helper' => 'formPhoto') )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
	
}