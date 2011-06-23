<?php
/**
 * 
 * Свойство - Краткий отзыв, ограниченный 300 знаками
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id:
 */

class Model_Entity_Property_ResponsePreview extends Model_Entity_Property_Text {
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Textarea( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setAttrib( 'class', $this->getTypeName() )
				->setAttrib( 'rows', 10 )
				->clearDecorators()
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'fullwidth' ) )
				->addValidator( 'StringLength', false, array('max'=> 450, 'encoding' => 'UTF-8'));
		return $element;
	}
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_Text $this
	 */
	public function commit() {
		if ( $this->isVirtual() and array_key_exists( 'val_text', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}