<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Views
 *
 * @author kifirch
 */
class Model_DbTable_Views extends Zend_Db_Table_Abstract {
	protected $_name = 'views';
	protected $_rowClass = 'Model_Entity_View';

	protected $_referenceMap = array (
		'elementType' => array (
			'columns' => 'id_etype',
			'refTableClass' => 'Model_DbTable_ElementTypes',
			'refColumns' => 'id'
		)
	);
}
?>
