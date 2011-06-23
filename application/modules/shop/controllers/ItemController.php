<?php
/**
 * 
 * Контроллер товара
 * 
 * @category   Xcms
 * @package    Catalog
 * @subpackage Controller
 * @version    $Id:
 */

class Shop_ItemController extends Xcms_Controller_Modulefront {
	
    protected $_namespace = 'XcmsShop';
    protected $_session;
 
    /**
     * Get the session namespace we're using
     *
     * @return Zend_Session_Namespace
     */
    public function getSession()
    {
        if (null === $this->_session) {
            $this->_session =
                new Zend_Session_Namespace($this->_namespace);
        }
         return $this->_session;
    }

    /**
     * Возвращает ссылку на "корзину"
     * @return String
     */
    private function getOrderlink() {
        $type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'order' );
        $elements = Model_Collection_Elements::getInstance()->getElementsByType($type->id);
        $order = array_shift($elements);
        return $order->getPage()->getHref();
    }



    /**
     * Просмотр контента
     * @return void
     */
    public function viewAction() {
        $this->setDataFrom( $this->getRequest()->getParam('id') );
        //$publish_date = date_create( $this->view->element->publish_date_from );
        //$this->view->element->publish_date_from = $publish_date->format( 'd.m.Y' );
        $request = $this->getRequest();

		
        if( $_GET['ajax'] == true ){
			$this->_helper->layout->disableLayout();
			$this->_helper->viewRenderer->setNoRender();

			if( $request->getParam( 'add_to_order' ) ) {
				$this->addToOrder($request->getParams());
				if( $request->getParam( 'ajax' ) ){
					$session = Zend_Session::namespaceGet('XcmsShop');
					$data->orderSum = $session['orderSum'];
					$data->items = $session['items'];
					$data->count = count($session['items']);
					$etype = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'order');
					$elements = Model_Collection_Elements::getInstance()->getElementsByType($etype->id);
					$order = array_shift($elements);
					$data->orderLink = $order->getPage()->getHref();

					print $this->partial( 'shop/cart.phtml', array('data'=>$data) );

					}
			};

			if( $request->getParam( 'delete_from_order' ) ) {

				$this->removeFromOrder($request->getParams());
				if( $request->getParam( 'ajax' ) ){
					$session = Zend_Session::namespaceGet('XcmsShop');
					$data->orderSum = $session['orderSum'];
					$data->items = $session['items'];
					$data->count = count($session['items']);
					$etype = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'order');
					$elements = Model_Collection_Elements::getInstance()->getElementsByType($etype->id);
					$order = array_shift($elements);
					$data->orderLink = $order->getPage()->getHref();

					print $this->partial( 'shop/cart.phtml', array('data'=>$data) );
				}
			};



        } else {

			$this->view->order_link = $this->getOrderlink();
			$this->view->form = new Shop_Form_Adding;
			$session = $this->getSession();
			if( isset( $session->items[ $this->getRequest()->getParam('id')] ) ) {
				$this->view->already_ordered = true;
			}
			$element = Model_Collection_Elements::getInstance()->getElement($this->getRequest()->getParam('id'))->getParent();
			$this->view->parent_link = $element->urlname;
			$this->renderContent( 'item.phtml' );
		}
    }

    /**
     * Добавление товара к заказу
     * @param array $params
     */
    public function addToOrder($params) {
        $session = $this->getSession();
        if(! isset($params['count'])) {
            $count = 1;
        } else {
            $count = $params['count'];
        }
        $id = $params['id'];
        $element = Model_Collection_Elements::getInstance()->getElement($id);
        $vals = (object)$element->getValues();
        if(! isset( $session->items[$id] ) ) {
            $session->items[$id] = array('price'=>$vals->shop_item_price, 'count'=>$count, 'name'=>$vals->name, 'href'=>$element->getPage()->getHref(), 'values'=>$vals );
        } else {
            $session->items[$id]['count']+=$count;
        }
		$this->summ();
    }

	 /**
     *
     * @param array $params
     */
    public function removeFromOrder($params) {
		$session = $this->getSession();

        $id = $params['id'];
        $element = Model_Collection_Elements::getInstance()->getElement($id);
        $vals = (object)$element->getValues();
        unset($session->items[$id]);

		$this->summ();
    }

	private function summ(){
		$session = $this->getSession();
		$session->orderSum = 0;
		foreach ($session->items as $item) {
			$session->orderSum += $item['price']*$item['count'];
		}
	}
}