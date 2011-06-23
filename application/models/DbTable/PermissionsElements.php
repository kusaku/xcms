<?php
/**
 * 
 * Интерфейс доступа к таблице данных прав пользователей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: PermissionsElements.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_PermissionsElements extends Zend_Db_Table_Abstract {
	protected $_name = 'permissions_elements';
	
	protected $_referenceMap = array (
		'Owner' => array (
			'columns' => 'id_owner', 
			'refTableClass' => 'Model_DbTable_Users', 
			'refColumns' => 'id'
		),
		'Element' => array (
			'columns' => 'id_element', 
			'refTableClass' => 'Model_DbTable_Elements', 
			'refColumns' => 'id'
		),
	);
}