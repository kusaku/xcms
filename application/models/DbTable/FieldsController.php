<?php
/**
 * 
 * Интерфейс доступа к таблице связи поля-группы
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: FieldsController.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_FieldsController extends Zend_Db_Table_Abstract {
	protected $_name = 'fields_controller';
	protected $_sequence = false;
	
	protected $_referenceMap = array (
		'Field' => array (
			'columns' => 'id_field', 
			'refTableClass' => 'Model_DbTable_Fields', 
			'refColumns' => 'id'
		), 
		'FieldGroup' => array (
			'columns' => 'id_group', 
			'refTableClass' => 'Model_DbTable_FieldGroups', 
			'refColumns' => 'id'
		)
	);
}