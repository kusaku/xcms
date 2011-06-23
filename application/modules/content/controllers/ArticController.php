<?php
/**
 * 
 * Контроллер публикации статей из Artic
 * 
 * @category   Xcms
 * @package    Content
 * @subpackage Controller
 * @version    $Id: $
 */

class Content_ArticController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$artic_active = (bool) Zend_Registry::getInstance()->get( 'artic_active' );
		if ( $artic_active ) {
			$idk = (int) $this->getRequest()->getParam('idk');
			$st  = (int) $this->getRequest()->getParam('st');
			$url = urlencode("http://".$_SERVER["HTTP_HOST"].$_SERVER["REQUEST_URI"]);
			$rip = $_SERVER["REMOTE_ADDR"];
			$ua  = urlencode($_SERVER["HTTP_USER_AGENT"]);
			$to = "http://artic.fabricasaitov.ru/export/?idk=$idk&st=$st&url=$url&rip=$rip&ua=$ua";
			$this->setTemplate( Model_Collection_Templates::getInstance()->getDefault()->filename );
			$artic_title = (string) Zend_Registry::getInstance()->get( 'artic_title' );
			if ( empty($artic_title) ) $artic_title = 'Статьи';
			$this->setMeta( $artic_title );
			$this->view->element = (object) array(
				'title_text' => $artic_title,
				'text'       => iconv('windows-1251', 'utf-8', file_get_contents($to)),
				'default'    => false
			);
			$this->renderContent();
		} else {
			$this->_redirect( $this->view->baseUrl('/') ); // на главную
		}
	}
}
