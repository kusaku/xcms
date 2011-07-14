<?php
/**
 * Контроллер для взаимодействия с системой Робокасса
 *
 * @author Konstantin.I
 */
class Shop_RoboxController extends Xcms_Controller_Modulefront {
	
	public function viewAction() {
		$method = $this->getRequest()->getParam('method');
		switch($method) {
			case "request":
				$this->request();
			break;
			case "success":
				$this->success();
			break;
			case "fail":
				$this->fail();
			break;
			default:
				throw new Exception("Not specified param 'Method'");
		}
		exit();
	}
	
	/**
	 * Обработка запроса от робокассы о платеже
	 */
	public function request() {
		$reg = Zend_Registry::getInstance();
    	$mrhLogin = $reg->get("shop_robox_login");
    	$mrhPasswd2 = $reg->get("shop_robox_passwd_2");
    	
    	$sum = $_POST["OutSum"];
    	$orderId = (int)$_POST["InvId"];
    	$crc = $_POST["SignatureValue"];
    	$crc = strtoupper($crc);
    	
    	$mycrc = strtoupper(md5("$sum:$orderId:$mrhPasswd2"));
    	
    	if (strtoupper($mycrc) != strtoupper($crc)) {
    		echo "Bad signature"; return;
    	}
    	
		$payStatusFieldId = Model_Collection_Fields::getInstance()->getFieldIdByName('shop_order_payed');
        $payStatusFieldEntity = Model_Collection_Fields::getInstance()->getEntity($payStatusFieldId);
        $payStatusGuide = Model_Collection_Objects::getInstance()->getGuideObjects($payStatusFieldEntity->id_guide);
        foreach($payStatusGuide as $payStatus) {
        	if($payStatus->title == "Оплачен")
        		$PayedId = $payStatus->id;
        }
    	
    	$mce = Model_Collection_Objects::getInstance();
    	$order = $mce->getEntity($orderId);
    	$order->setValue('shop_order_payed', $PayedId)';
    	$order->commit(true);
    	echo "OK$orderId\n"; return;
	}
	
	/**
	 * Страница успешной оплаты
	 */
	public function success() {
		echo "OK";
	}
	
	/**
	 * Страница незавершенной оплаты
	 */
	public function fail() {
		echo "Fail";
	}
	
}