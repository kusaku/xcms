<?php
/**
 * 
 * Интерфейс доступа к таблице данных пользователей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Users.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_Users extends Zend_Db_Table_Abstract {
	protected $_name = 'users';
	protected $_rowClass = 'Model_Entity_User';
	
	protected $_referenceMap = array (
		'Object' => array (
			'columns' => 'id_object', 
			'refTableClass' => 'Model_DbTable_Objects', 
			'refColumns' => 'id'
		),
		'UserGroup' => array (
			'columns' => 'id_usergroup', 
			'refTableClass' => 'Model_DbTable_Objects', 
			'refColumns' => 'id'
		)
	);
}