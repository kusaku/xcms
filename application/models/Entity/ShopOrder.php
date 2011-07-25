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
class Model_Entity_ShopOrder extends Model_Abstract_Entity {

    /**
     *
     * @var Model_Entity_Object
     */
    protected $_object;


    public function setValues() {
        
    }

    public function  removeCache() {
        ;
    }

    public function  refresh() {
        parent::refresh();
    }
    
	/**
     * Генерация ссылки для редиректа на страницу оплаты
     */
    static public function createRoboxLink($orderId, $orderSum) {
    	$reg = Zend_Registry::getInstance();
    	$mrhLogin = $reg->get("shop_robox_login");
    	$mrhPasswd = $reg->get("shop_robox_passwd_1");
    	$testMode = $reg->get("shop_robox_test");
    	$desc = "Заказ №" . $orderId;
    	$crc = md5("$mrhLogin:$orderSum:$orderId:$mrhPasswd");
    	$page = "https://merchant.roboxchange.com/Index.aspx";
    	if((bool)$testMode)
    		$page = "http://test.robokassa.ru/Index.aspx";
    	$url = $page . "?MrchLogin=$mrhLogin&"."OutSum=$orderSum&InvId=$orderId&Desc=$desc&SignatureValue=$crc";
    	return $url;
    }
    
}
?>
