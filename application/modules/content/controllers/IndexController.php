<?php
/**
 * 
 * Контроллер по-умолчанию модуля контента
 * 
 * @category   Xcms
 * @package    Content
 * @subpackage Controller
 * @version    $Id: IndexController.php 629 2011-02-09 10:18:59Z kifirch $
 */

class Content_IndexController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента: доступ по алиасу
	 * @return void
	 */
	public function aliasAction() {
		$urlname = $this->getRequest()->getParam( 'urlname' );
                /**
                 * Это для Artic
                 * $url должен быть для microsoft.ru
                 */
                $url = $_SERVER['HTTP_HOST'];
                $url = str_replace('.', '', $url);
                if($urlname == $url) {
                    $this->_forward('view','Artic');
                    return;
                }
                Main::logDebug($this->getRequest());
		/*$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
		$modules = array_keys( (array) $bootstraps );
		if ( in_array( $urlname, $modules ) ) {
			$this->_forward( 'index', 'index', 'admin' );	
		}*/
		$table = Model_Collection_Elements::getInstance()->getDbElements();
		$element = $table->fetchRow(
			$table->select()
				->where( 'urlname = ?', $urlname )
				->where( 'is_active = ?', 1 )
				->where( 'is_deleted != ?', 1 )
		);
		if ( isset( $element ) ) {
			$this->getRequest()->setParam( 'id', $element->id );
		} else {
                        $this->_redirect('/404');
			/*if (APPLICATION_ENV != 'production')
				throw new Exception( 'Алиас не существует' );
			else
				throw new Zend_Controller_Dispatcher_Exception( 'Страница не существует' );*/
		}
		$etype = $element->getType();
		$module = $etype->module;
		$controller = empty($etype->controller) ? 'index' : $etype->controller;
                Main::logDebug($etype,$controller,$module);
                
		$this->_forward( 'view', $controller, $module );
	}
}
