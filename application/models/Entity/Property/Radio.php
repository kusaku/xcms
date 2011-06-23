<?php
/**
 * 
 * Свойство - радио кнопка
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Radio.php 238 2010-07-02 11:43:40Z renat $
 */

class Model_Entity_Property_Radio extends Model_Entity_Property {
	
	/**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @return Model_Entity_Property_Radio $this
	 */
	public function setValue($value){
		if ( $value != $this->getValue() ) {
			$this->val_rel_obj = (int) $value;
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return string
	 */
	public function getValue() {
		return (int) $this->val_rel_obj;
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
	 * @todo не используется переопределенный декоратор Label
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		$field = $this->getField();
		$element = new Zend_Form_Element_Radio( $field->name );
		$element->setLabel( $field->title )
				->setDescription( $field->tip )
				->setRequired( $field->is_required )
				->setSeparator('')
				->setAttrib( 'class', $this->getTypeName() . ' radiobutton' )
				->clearDecorators()
				->addDecorator( 'ViewHelper' )
				->addDecorator( array('elementDiv' => 'HtmlTag'), array( 'class' => 'radiodiv' ) )
				->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
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
	 * @return Model_Entity_Property_Radio $this
	 */
	public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_rel_obj', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}