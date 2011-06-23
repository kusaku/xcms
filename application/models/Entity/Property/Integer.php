<?php
/**
 * 
 * Свойство - целое число
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Integer.php 629 2011-02-09 10:18:59Z kifirch $
 */

class Model_Entity_Property_Integer extends Model_Entity_Property {
	
	/**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @return Model_Entity_Property_Integer $this
	 */
	public function setValue($value) {
		if ( $value != $this->getValue() ) {
			$this->val_int = (int) $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return string
	 */
	public function getValue() {
		return (int) $this->val_int;
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
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) )
				->addFilter( 'Int' );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_Integer $this
	 */
	public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_int', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}