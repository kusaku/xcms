<?php
/**
 * 
 * Интерфейс доступа к таблице данных елементов дерева сайта
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Elements.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_Elements extends Zend_Db_Table_Abstract {
	protected $_name = 'elements';
	protected $_rowClass = 'Model_Entity_Element';
	
	protected $_referenceMap = array (
		'Type' => array (
			'columns' => 'id_type', 
			'refTableClass' => 'Model_DbTable_ElementTypes', 
			'refColumns' => 'id'
		),
		'Parent' => array (
			'columns' => 'id_parent', 
			'refTableClass' => 'Model_DbTable_Elements', 
			'refColumns' => 'id'
		),
		'Object' => array (
			'columns' => 'id_obj', 
			'refTableClass' => 'Model_DbTable_Objects', 
			'refColumns' => 'id'
		),
		'Template' => array (
			'columns' => 'id_tpl', 
			'refTableClass' => 'Model_DbTable_Templates', 
			'refColumns' => 'id'
		),
		'Language' => array (
			'columns' => 'id_lang', 
			'refTableClass' => 'Model_DbTable_Languages', 
			'refColumns' => 'id'
		),
		'Menu' => array (
			'columns' => 'id_menu', 
			'refTableClass' => 'Model_DbTable_Objects', 
			'refColumns' => 'id'
		)
	);
}