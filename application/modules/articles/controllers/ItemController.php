<?php
/**
 * 
 * Контроллер статей
 * 
 * @category   Xcms
 * @package    Articles
 * @subpackage Controller
 * @version    $Id: ItemController.php 231 2010-06-24 13:56:27Z renat $
 */

class Articles_ItemController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$this->setDataFrom( $this->getRequest()->getParam('id') );
		$publish_date = date_create( $this->view->element->publish_date_from );
		$this->view->element->publish_date_from = $publish_date->format( 'd.m.Y' );
		$this->view->element->source = empty($this->view->element->publish_src_link) ? 
			$this->view->element->publish_src_text :
			'<a href="'.$this->view->element->publish_src_link.'" target="_blank">'.$this->view->element->publish_src_text.'</a>';
		$this->renderContent( 'item.phtml' );
	}
}