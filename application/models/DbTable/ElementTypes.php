<?php
/**
 * 
 * Интерфейс доступа к таблице данных типов элементов дерева сайта
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_DbTable
 * @version    $Id: ElementTypes.php 190 2010-05-19 09:53:07Z renat $
 */

class Model_DbTable_ElementTypes extends Zend_Db_Table_Abstract {
	protected $_name = 'element_types';
	protected $_rowClass = 'Model_Entity_ElementType';
}