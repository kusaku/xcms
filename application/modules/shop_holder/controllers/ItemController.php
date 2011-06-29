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
	
	public function  preDispatch() {
		$action = $this->getRequest()->getActionName();
		$this->_forward($action, 'item', 'catalog');
	}
}