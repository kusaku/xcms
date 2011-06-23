<?php
/**
 * 
 * Интерфейс доступа к таблице данных значений полей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Content.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_Content extends Zend_Db_Table_Abstract {
	protected $_name = 'content';
	protected $_rowClass = 'Model_Entity_Property';
	
	protected $_referenceMap = array (
		'Object' => array (
			'columns' => 'id_obj', 
			'refTableClass' => 'Model_DbTable_Objects', 
			'refColumns' => 'id'
		),
		'Field' => array (
			'columns' => 'id_field', 
			'refTableClass' => 'Model_DbTable_Fields', 
			'refColumns' => 'id'
		),
		'ObjectRel' => array (
			'columns' => 'val_rel_obj', 
			'refTableClass' => 'Model_DbTable_Objects', 
			'refColumns' => 'id'
		),
		'TreeRel' => array (
			'columns' => 'val_rel_elem', 
			'refTableClass' => 'Model_DbTable_Elements', 
			'refColumns' => 'id'
		),
	);
}