<?php
/**
 * 
 * Интерфейс доступа к таблице данных типов объектов
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: ObjectTypes.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_ObjectTypes extends Zend_Db_Table_Abstract {
	protected $_name = 'object_types';
	protected $_rowClass = 'Model_Entity_ObjectType';
	
	protected $_referenceMap = array (
		'Parent' => array (
			'columns' => 'id_parent', 
			'refTableClass' => 'Model_DbTable_ObjectTypes', 
			'refColumns' => 'id'
		),
		'ElementType' => array (
			'columns' => 'id_element_type', 
			'refTableClass' => 'Model_DbTable_ElementTypes', 
			'refColumns' => 'id'
		)
	);
}