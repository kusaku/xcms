<?php
/**
 * 
 * Интерфейс доступа к таблице данных шаблонов
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Templates.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_Templates extends Zend_Db_Table_Abstract {
	protected $_name = 'templates';
	protected $_rowClass = 'Model_Entity_Template';
	
	protected $_referenceMap = array (
		'Language' => array (
			'columns' => 'id_lang', 
			'refTableClass' => 'Model_DbTable_Languages', 
			'refColumns' => 'id'
		)
	);
}