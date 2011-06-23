<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ShopChart
 *
 * @author aleksey.f
 */
class Xcms_View_Helper_ShopCart extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view) {
        $this->view = $view;
    }
    
    public function shopCart() {
        $session = Zend_Session::namespaceGet('XcmsShop');
        $data->orderSum = $session['orderSum'];
        $data->items = $session['items'];
        $data->count = count($session['items']);
        $etype = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'order');
        $elements = Model_Collection_Elements::getInstance()->getElementsByType($etype->id);
        $order = array_shift($elements);
        $data->orderLink = $order->getPage()->getHref();
        $output = $this->view->partial( 'shop/cart.phtml', array('data'=>$data) );
        return $output;
    }

}
?>
