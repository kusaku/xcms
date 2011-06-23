<?php
/**
 * 
 * Свойство - тип объекта (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: ObjType.php 143 2010-03-17 10:20:14Z renat $
 */

class Model_Entity_Property_ObjType extends Model_Entity_Property_Select {
	
	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_Element $element OPTIONAL объект элемента данного свойства
	 * @return Model_Entity_Property_ObjType $this
	 */
	public function setValue( $value, $element=null ) {
		$value = (int) $value;
		if ( $this->getObject()->id_type !== $value ) {
			//$this->getObject()->id_type = $value;
			$this->getObject()->setType( $value ); // TODO убрать? изм. тип после всех
		}
		return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @param Model_Entity_Element $element OPTIONAL объект элемента данного свойства
	 * @return int
	 */
	public function getValue( $element=null ) {
		return $this->getObject()->id_type;
	}
	
	/**
	 * Возвращает массив возможных значений
	 * @return array value=>title
	 */
	protected function getOptions() {
		$mcot = Model_Collection_ObjectTypes::getInstance();
		$parent = $this->getObject()->getType()->getParent();
		if ( ! isset($parent) or ! $parent->is_public ) {
			$parent = $this->getObject()->getType(); // собственный
		}
		$ops = array( $parent->id => $parent->title );
		$parent_id = $parent->id;
		return $ops + $mcot->getChildrenList( $parent_id );
	}
}