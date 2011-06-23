<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ShopOrders
 *
 * @author aleksey.f
 */
class Model_DbTable_ShopOrders extends Zend_Db_Table_Abstract {
	protected $_name = 'shop_orders';
	protected $_rowClass = 'Model_Entity_ShopOrder';

        protected $_referenceMap = array (
		'Object' => array (
			'columns' => 'id_obj',
			'refTableClass' => 'Model_DbTable_Objects',
			'refColumns' => 'id'
		),
                'User' => array (
			'columns' => 'id_user',
			'refTableClass' => 'Model_DbTable_Users',
			'refColumns' => 'id'
                )
	);
}
?>
