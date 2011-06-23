<?php
/**
 * 
 * Свойство - файл
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: File.php 137 2010-03-12 14:58:50Z renat $
 */

class Model_Entity_Property_File extends Model_Entity_Property {
	
	/**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @return Model_Entity_Property_File $this
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
		$element = new Zend_Form_Element_File( $field->name );
		/*$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				//->setDestination( realpath(APPLICATION_PATH . '/../public/files') )
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( 'Label', array( 'nameimg' => 'ico_help.gif' ) )
				->addDecorator( 'File' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) )
				->clearValidators()
				//->addValidator('Count', false, 1)
				//->addValidator('Size', false, 102400)
				->setValueDisabled( true );*/
		$element = new Zend_Form_Element_Hidden( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( 'Upload' )
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) );
		return $element;
	}
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_File $this
	 */
	public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_varchar', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}