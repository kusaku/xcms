<?php
/**
 * 
 * Свойство - Фотография Клиента
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id:
 */

class Model_Entity_Property_PhotoClient extends Model_Entity_Property_String {
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Hidden( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( array('elementDiv' => 'HtmlTag'), array( 'id' => 'upload_client', 'tag' => 'a' ) )
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