<?php
/**
 * 
 * Интерфейс доступа к таблице данных объектов
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Objects.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_Objects extends Zend_Db_Table_Abstract {
	protected $_name = 'objects';
	protected $_rowClass = 'Model_Entity_Object';
	
	protected $_referenceMap = array (
		'Type' => array (
			'columns' => 'id_type', 
			'refTableClass' => 'Model_DbTable_ObjectTypes', 
			'refColumns' => 'id'
		)
	);
}