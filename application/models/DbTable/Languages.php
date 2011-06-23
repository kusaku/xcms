<?php
/**
 * 
 * Интерфейс доступа к таблице данных языков
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Languages.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_Languages extends Zend_Db_Table_Abstract {
	protected $_name = 'languages';
	protected $_rowClass = 'Model_Entity_Language';
}