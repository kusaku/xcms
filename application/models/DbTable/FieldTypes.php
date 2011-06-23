<?php
/**
 * 
 * Интерфейс доступа к таблице данных типов полей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: FieldTypes.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_FieldTypes extends Zend_Db_Table_Abstract {
	protected $_name = 'field_types';
	protected $_rowClass = 'Model_Entity_FieldType';
}
