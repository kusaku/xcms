<?php
/**
 * 
 * Версия
 * 
 * @category   Xcms
 * @package    Default
 * @subpackage Controller
 * @version    $Id: VersionController.php 238 2010-07-02 11:43:40Z renat $
 */

class VersionController extends Zend_Controller_Action {
	
	/**
	 * Инициализация
	 */
	public function init() {
		// Отключаем авто-рендеринг
		$this->_helper->viewRenderer->setNoRender ();
		$this->_helper->getHelper ( 'layout' )->disableLayout ();
	}
	
	/*
	 * Возвращает данные о версии cms в xml
	 */
	public function indexAction() {
		$data = array();
		foreach ( array('name', 'version', 'type') as $k ) {
			$data[$k] = Zend_Registry::get( $k );
		}
		$this->getResponse()
			->setHeader ( "Content-Type", "text/xml; charset=utf-8" )
			->setBody( Model_ArrayToXML::toXml( $data, 'info' ) );
	}
}

