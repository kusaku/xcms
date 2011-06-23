<?php
/**
 * 
 * Контроллер ошибок
 * 
 * @category   Xcms
 * @package    Default
 * @subpackage Controller
 * @version    $Id: ErrorController.php 629 2011-02-09 10:18:59Z kifirch $
 */

class ErrorController extends Zend_Controller_Action {
	
	public function errorAction() {
		$errors = $this->_getParam ( 'error_handler' );
		
		if ( $errors->exception instanceof Xcms_Exception_AccessDenied ) {
			$this->_forward( 'denied' );
		}
		
		switch ($errors->type) {
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER :
			case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION :
				
				// 404 error -- controller or action not found
				$this->getResponse ()->setHttpResponseCode ( 404 );
				$message = 'Page not found';
				break;
			default :
				// application error 
				$this->getResponse ()->setHttpResponseCode ( 500 );
				$message = 'Application error';
				break;
		}
        
        // Log exception, if logger available
        if ( (bool) $log = $this->getLog() ) {
            $log->crit($this->view->message, $errors->exception);
        }
		
		$this->view->message = $message;
		$this->view->exception = $errors->exception;
		$this->view->request = $errors->request;
	}
	
	public function deniedAction() {
		$this->_helper->viewRenderer->setNoRender ();
		$this->_helper->getHelper ( 'layout' )->disableLayout ();

		/*
		 * Вместо редиректа выдавалась ошибка, но она возникала при регистрации, а это ППЦ.
		 * Если есть мысль как переделать - welcome!
		 */
		$this->_redirect('/');
		/*$this->getResponse()
			->setHttpResponseCode( 403 )
			->setBody( 'Access denied!' );*/
	}
	
	public function getLog() {
		$bootstrap = $this->getInvokeArg ( 'bootstrap' );
		if (! $bootstrap->hasPluginResource ( 'Log' )) {
			return false;
		}
		$log = $bootstrap->getResource ( 'Log' );
		return $log;
	}
}

