<?php
/**
 * 
 * Свойство - ссылка на другой элемент_структуры
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: TreeRel.php 238 2010-07-02 11:43:40Z renat $
 * 
 * @todo использовать val_rel_elem
 */

class Model_Entity_Property_TreeRel extends Model_Entity_Property_Select {
	
	/**
	 * Возвращает массив возможных значений
	 * @return array value=>title
	 */
	protected function getOptions() {
		// TODO возможно использовать тип элементов
		return 
			array( '...' ) + 
			Model_Collection_Elements::getInstance()
				->getChildren( $this->getField()->id_guide );
	}
}