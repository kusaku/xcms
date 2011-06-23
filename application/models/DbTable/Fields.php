<?php
/**
 * 
 * Интерфейс доступа к таблице данных полей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Fields.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_Fields extends Zend_Db_Table_Abstract {
	protected $_name = 'fields';
	protected $_rowClass = 'Model_Entity_Field';
	
	protected $_referenceMap = array (
		'Type' => array (
			'columns' => 'id_type', 
			'refTableClass' => 'Model_DbTable_FieldTypes', 
			'refColumns' => 'id'
		),
		'Guide' => array (
			'columns' => 'id_guide', 
			'refTableClass' => 'Model_DbTable_Content', 
			'refColumns' => 'id'
		)
	);
}
