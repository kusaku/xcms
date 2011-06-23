<?php
/**
 * 
 * Контроллер xml-схем
 * 
 * @category   Xcms
 * @package    Content
 * @subpackage Controller
 * @version    $Id: SitemapController.php 565 2010-11-15 10:00:46Z kifirch $
 */

class Content_SitemapController extends Xcms_Controller_Modulefront {
	
	/**
	 * Инициализация
	 */
	public function init() {
		// Отключаем авто-рендеринг
		$this->_helper->viewRenderer->setNoRender ();
		$this->_helper->getHelper ( 'layout' )->disableLayout ();
	}
	
	public function indexAction() {
		$navigation = new Zend_Navigation();
		$table = Model_Collection_Elements::getInstance()->getDbElements();
		$rows = $table->fetchAll( $table->select()
			->where( 'is_active = 1' ) 
			->where( 'is_deleted = 0')
		);
		foreach ( $rows as $row ) {
			$navigation->addPage( $row->getPage() );
		}
		$this->view->navigation( $navigation );
		$this->view->navigation()->setAcl( Main::getAcl() )->setRole( Main::getCurrentUserRole() );
		$this->getResponse()
			->setHeader ( 'Content-Type', 'text/xml; charset=utf-8' )
			->setBody( $this->view->navigation()->sitemap()->setFormatOutput(true) );
	}

        public function viewAction() {
        	$reg = Zend_Registry::getInstance();
        	echo $reg->get( 'site_name' );
            $navigation = new Zend_Navigation();
            $this->setDataFrom( $this->getRequest()->getParam('id') );
            $table = Model_Collection_Elements::getInstance()->getDbElements();
            $rows = $table->fetchAll( $table->select()
                    ->where( 'is_active = 1' )
                    ->where( 'is_deleted = 0')
            );
            foreach ( $rows as $row ) {
                    $navigation->addPage( $row->getPage() );
            }
            $this->view->navigation( $navigation );
            $xmenu = new Xcms_View_Helper_Menu();
            $xmenu->setView($this->view);
            $xmenu->menu($navigation);
            $this->getResponse()->setBody($xmenu->renderMenu());
        }
}