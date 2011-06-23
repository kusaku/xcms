<?php
/**
 * 
 * Свойство - список с множественным выбором
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: MultiSelect.php 137 2010-03-12 14:58:50Z renat $
 */

class Model_Entity_Property_MultiSelect extends Model_Entity_Property {
	
	/**
	 * Устанавливает значение свойства
	 * @param array $value
	 * @return Model_Entity_Property_MultiSelect $this
	 */
	public function setValue($value) {
		if ( $value != $this->getValue() ) {
			$this->val_text = serialize( $value );
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return array
	 */
	public function getValue() {
		return unserialize( $this->val_text );
	}
	
	/**
	 * Возвращает массив возможных значений
	 * @return array value=>title
	 */
	protected function getOptions() {
		return 
			Model_Collection_Objects::getInstance()
				->getGuideObjects( $this->getField()->id_guide );
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Multiselect( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setAttrib( 'class', $this->getTypeName() )
				->clearDecorators()
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
				->addDecorator( 'ViewHelper' )
				->addDecorator( 'Errors' )
				->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) )
				->setMultiOptions( $this->getOptions() );
		if ( ! $this->isVirtual() ) {
			$element->setValue( $this->getValue() );
		}
		return $element;
	}
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_MultiSelect $this
	 */
	public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_text', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}