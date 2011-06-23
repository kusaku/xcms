<?php
/**
 * 
 * Интерфейс доступа к таблице данных групп полей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: FieldGroups.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_FieldGroups extends Zend_Db_Table_Abstract {
	protected $_name = 'field_groups';
	protected $_rowClass = 'Model_Entity_FieldsGroup';
	
	protected $_referenceMap = array (
		'ObjectType' => array (
			'columns' => 'id_obj_type', 
			'refTableClass' => 'Model_DbTable_ObjectTypes', 
			'refColumns' => 'id'
		)
	);
}