<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of OrderControler
 *
 * @author aleksey.f
 */
class Shop_OrderController extends Xcms_Controller_Modulefront {

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

    public function deleteSession() {
        $session = $this->getSession();
        $session->items = array();
    }

    /**
     *  Сценарии использования
     */
    public function viewAction() {
        $this->setDataFrom( $this->getRequest()->getParam('id') );
        $request = $this->getRequest();
        $session = $this->getSession();
        Main::logDebug($_SESSION);
        if($request->isPost()) {
            if($request->getParam('recalc')) {
                $this->recalculate();
            }
            if($request->getParam('delete') || $request->getParam('delete_x') ) {
                $this->removeFromOrder($request->getParams());
                $this->_redirect($_SERVER['HTTP_REFERER'] );
            }
            if($request->getParam('next_step')) {
                (int)$session->orderStep += 1;
            }
            if($request->getParam('prev_step')) {
                $session->orderStep -=1;
                if($session->orderStep<=1) {
                    $session->orderStep = 1;
                }
            }
            if($request->getParam('order_confirm')) {
                $s_result = $this->saveOrder();
                $session->orderStep = 'saved';
            }
        } else {
			(int)$session->orderStep = 1;
		}
        if(!isset($session->orderStep)) $session->orderStep = 1;
        $auth = Zend_Auth::getInstance();
        var_dump($auth->getIdentity());
        switch ($session->orderStep ) {
            case 1:
                $this->view->sum = $session->orderSum;
                $this->view->items = $session->items;
                if($auth->hasIdentity() || Zend_Registry::get('buy_without_reg')==0) {
                    $this->view->next = true;
                } else {
                    $this->view->next = false;
                }
                $this->renderContent( 'order/step1.phtml' );
                break;
            case 2:
				// Получаем данные о пользователе
				$user = Model_Collection_Users::getInstance()->getEntity( $auth->getIdentity()->id )->getValues();
				$this->view->user = $user;

                $this->view->sum = $session->orderSum;
                $this->view->items = $session->items;
                $this->renderContent( 'order/step2.phtml' );
                break;
			case 3:
				// Получаем данные о пользователе
				$user = Model_Collection_Users::getInstance()->getEntity( $auth->getIdentity()->id )->getValues();
				$this->view->user = $user;

                $this->view->sum = $session->orderSum;
                $this->view->items = $session->items;
                $this->renderContent( 'order/step3.phtml' );
                break;
            case 'saved':
            	if($s_result["robox"])
            		$this->view->robox_link = $s_result["robox_link"];
                $this->renderContent( 'order/saved.phtml' );
				(int)$session->orderStep = 1;
                unset($session->orderStep);
                $this->deleteSession();
                break;
            default:
                $this->renderContent( 'order/step1.phtml' );
                break;
        }
    }

    /**
     * Пересчет корзины
     */
    public function recalculate() {
        $params = $this->getRequest()->getParams();
        $session = $this->getSession();
        foreach ($session->items as $id=>$item) {
            if($params['multiple'][$id] != $item['count']) {
                if( is_numeric($params['multiple'][$id]) && $params['multiple'][$id]>0 ) {
                        $session->orderSum -= $item['price']*$item['count'];
                        $item['count'] = (int)$params['multiple'][$id];
                        $session->items[$id]['count'] = (int)$params['multiple'][$id];
                        $session->orderSum += $item['price']*$item['count'];
                } elseif(is_numeric($params['multiple'][$id]) && $params['multiple'][$id] == 0) {
                    $this->removeFromOrder( array('delete'=>$id) );
                }
            }
        }
    }

    public function saveOrder() {
		/*print_r($_POST);
		die();/**/
        $auth = Zend_Auth::getInstance();
        $session = $this->getSession();
        $type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'orders');
        $table = Model_Collection_ObjectTypes::getInstance()->getDbObjectTypes();
        $otype = $table->fetchRow($table->select()->where('id_element_type=?',(int)$type->id ));
        $ord_type = Model_Collection_ObjectTypes::getInstance()->getChildren($otype->id);
        foreach($ord_type as $key=>$value) {
            $ordinfo = Model_Collection_ObjectTypes::getInstance()->getEntity($key);
        }
        //id	id_type	is_locked	title
        $data_order['id_type'] = $otype->id;
        $data_order['is_locked'] = 1;
        $data_order['title'] = 'Заказ №';
		$user = Model_Collection_Users::getInstance()->getEntity($auth->getIdentity()->id);
        $order = Model_Collection_Objects::getInstance()->createObject($data_order);
        
        $payStatusFieldId = Model_Collection_Fields::getInstance()->getFieldIdByName('shop_order_payed');
        $payStatusFieldEntity = Model_Collection_Fields::getInstance()->getEntity($payStatusFieldId);
        $payStatusGuide = Model_Collection_Objects::getInstance()->getGuideObjects($payStatusFieldEntity->id_guide);
        foreach($payStatusGuide as $payStatus) {
        	if($payStatus->title == "Не оплачен")
        		$NoPayedId = $payStatus->id;
        }
        
        $values = array(
            'shop_order_userid'=>  $user->id_object,
            'shop_order_number'=>rand(0,100000),
            'shop_order_sum'=>$session->orderSum,
			'shop_order_date'=> date("Y-m-d H:i:s"),
			'shop_order_comment'=> $_POST['shop_order_comment'],
			'shop_order_address'=> $_POST['shop_order_address'],
			'shop_order_delivery'=> $_POST['shop_order_delivery'],
			'shop_order_city'=> $_POST['shop_order_city'],
			'shop_order_status'=> $_POST['shop_order_status'],
			'shop_order_payment'=> $_POST['shop_order_payment'],
			'shop_order_phone'=> $_POST['user_phone'],
        	'shop_order_payed' => $NoPayedId
        );
        $rOrderSum = $values["shop_order_sum"];
        $order->setValues($values);
        $order->commit();

		$values = array(
			'user_address'=> $_POST['shop_order_address'],
			'user_phone'=> $_POST['user_phone']
		);
		$user->setValues($values);
//		die($email);
		$user->commit();
		$user = $user->getValues();
		$email = $user['user_email'];

        $data['id_obj'] = $order->id;
        $data['id_user'] = $auth->getIdentity()->id;
        $shopOrder = Model_Collection_ShopOrders::getInstance()->addOrder($data);
        $shopOrder->commit();
        foreach($session->items as $key=>$value) {
            $data['id_type'] = $ordinfo->id;
            $data['is_locked'] = 1;
            $data['title'] = 'Информация о заказе №';
            $order_info = Model_Collection_Objects::getInstance()->createObject($data);
            $values = array(
                'shop_order_itemid'=>$key,
                'shop_order_item_price'=>$value['price'],
                'shop_order_item_count'=>$value['count']
            );
            $order_info->setValues($values);
            $order_info->commit();
            $data['id_order'] = $shopOrder->id;
            $data['id_obj'] = $order_info->id;
            $data['id_element'] = $key;
            $shopOrderInfo = Model_Collection_ShopOrderInfo::getInstance()->addOrderInfo($data);
            $shopOrderInfo->commit();
            //Main::logDebug($order_info->id);
        }

        $reg = Zend_Registry::getInstance();
		$title = 'Поступил заказ!';
		$mess =  htmlspecialchars(trim($email.' '.$_POST['shop_order_address'].' '.$_POST['shop_order_comment']));
		$from = (string) $reg->get( 'shop_email' );
		$headers =
			"Content-type: text/html; charset=utf-8\r\n"
			. "From: =?UTF-8?B?".base64_encode($from)."?= <{$from}>\r\n"
			. "Reply-To: =?UTF-8?B?".base64_encode($from)."?= <{$from}>";
		
		if (mail($email, $title, $mess, $headers)) print '*-вам отправлено информационное письмо на адрес "'.$email.'".';
		else print '*-при отправке письма с информацией о заказе возникли сложности. Письмо не отправлено.';

		$result = array();
		$result["id"] = $order->id;
		if($reg->get('shop_robox_delivid') == $_POST["shop_order_payment"]) {
			$result['robox'] = true;
			$result['robox_link'] = $this->createRoboxLink($order->id, $rOrderSum);
		}
        return $result;
    }


    /**
     * Удаление товара из заказа
     * @param array $params
     */
    public function removeFromOrder($params) {
        $session = $this->getSession();
        $id = empty($params['delete']) ? $params['delete'] : $params['delete_x'];
        $sum = $session->items[$id]['count']*$session->items[$id]['price'];
        unset($session->items[$id]);
        $session->orderSum -= $sum;
    }
    
    /**
     * Генерация ссылки для редиректа на страницу оплаты
     */
    public function createRoboxLink($orderId, $orderSum) {
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
