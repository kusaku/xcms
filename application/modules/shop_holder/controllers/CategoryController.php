<?php
/**
 * 
 * Контроллер категорий каталога
 * 
 * @category   Xcms
 * @package    Catalog
 * @subpackage Controller
 * @version    $Id:
 */
class Shop_CategoryController extends Xcms_Controller_Modulefront {
	
	public function  preDispatch() {
		$action = $this->getRequest()->getActionName();
		$this->_forward($action, 'category', 'catalog');
	}
	
}