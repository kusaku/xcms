<?php
/**
 * 
 * Базовый класс контроллеров административного интерфейса
 * 
 * @category   Xcms
 * @package    Xcms_Controller
 * @version    $Id: Admin.php 244 2010-07-28 10:38:11Z igor $
 */

abstract class Xcms_Controller_Admin extends Zend_Controller_Action {
	
	/**
	 * Инициализация
	 * @return void
	 */
	public function init() {
		$this->getHelper ( 'layout' )
			->setLayoutPath ( APPLICATION_PATH . "/modules/admin/layouts/scripts" )
			->setLayout ( 'admin' );
		$this->getResponse ()
			->setHeader ( 'Content-Type', 'text/html; charset=utf-8' );
		$view = $this->view;
		// Мета-теги
		$view->headMeta()
			->setHttpEquiv ( 'Content-Type', 'text/html; charset=utf-8' );
		// Стили
		$view->headLink()
			->appendStylesheet( '/cms/css/reset-min.css' )
			->appendStylesheet( '/cms/css/fonts-min.css' )
			->appendStylesheet( '/cms/css/admin.css' )
			->appendStylesheet( '/cms/css/cusel.css' );
			//->appendStylesheet( '/cms/css/selectsComments.css' );
		// JQuery
		$view->addHelperPath ( 'ZendX/JQuery/View/Helper/', 'ZendX_JQuery_View_Helper' );
		$view->jQuery()
			//->setVersion     ( '1.4.2' )
			->setLocalPath   ( $view->BaseUrl() . "/cms/resources/jquery/jquery-1.4.2.min.js" )
			//->setUiVersion   ( '1.8' )
			->setUiLocalPath ( $view->BaseUrl() . "/cms/resources/jquery/ui/jquery-ui-1.8.10.custom.js" )
			->addStylesheet ( $view->BaseUrl() . "/cms/resources/jquery/ui/themes/ui-lightness/jquery-ui-1.8.custom.css" )
			->uiEnable()
		;
	}
}
