<?php
/**
 * 
 * Интерфейс доступа к таблице данных прав пользователей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: PermissionsModules.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_PermissionsModules extends Zend_Db_Table_Abstract {
	protected $_name = 'permissions_modules';
	
	protected $_referenceMap = array (
		'Owner' => array (
			'columns' => 'id_owner', 
			'refTableClass' => 'Model_DbTable_Users', 
			'refColumns' => 'id'
		),
		'ElementType' => array (
			'columns' => 'id_etype', 
			'refTableClass' => 'Model_DbTable_ElementTypes', 
			'refColumns' => 'id'
		),
	);
}