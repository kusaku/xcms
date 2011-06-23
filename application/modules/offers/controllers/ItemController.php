<?php
/**
 * 
 * Контроллер акций
 * 
 * @category   Xcms
 * @package    Offers
 * @subpackage Controller
 * @version    $Id: ItemController.php 231 2010-12-07 13:56:27Z igor $
 */

class Offers_ItemController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$this->setDataFrom( $this->getRequest()->getParam('id') );
		$publish_date = date_create( $this->view->element->publish_date_from );
		$this->view->element->publish_date_from = $publish_date->format( 'd.m.Y' );
		$this->renderContent( 'item.phtml' );
	}
}