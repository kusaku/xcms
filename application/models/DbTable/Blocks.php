<?php
/**
 * 
 * Интерфейс доступа к таблице данных шаблонов
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: Blocks.php 190 2010-08-11 10:41:07Z alex $
 */

class Model_DbTable_Blocks extends Zend_Db_Table_Abstract {
	protected $_name = 'blocks';
	protected $_rowClass = 'Model_Entity_Block';
}