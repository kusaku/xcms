<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ShopOrdersInfo
 *
 * @author aleksey.f
 */
class Model_DbTable_ShopOrderInfo  extends Zend_Db_Table_Abstract {
	protected $_name = 'shop_order_info';
	protected $_rowClass = 'Model_Entity_ShopOrderInfo';

        protected $_referenceMap = array (
                'Order' => array(
                    	'columns' => 'id_order',
			'refTableClass' => 'Model_DbTable_Orders',
			'refColumns' => 'id'
                ),
		'Object' => array (
			'columns' => 'id_obj',
			'refTableClass' => 'Model_DbTable_Objects',
			'refColumns' => 'id'
		),
                'Element' => array (
			'columns' => 'id_element',
			'refTableClass' => 'Model_DbTable_Elements',
			'refColumns' => 'id'
                )
	);
}
?>
