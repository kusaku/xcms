<?php
/**
 * 
 * Авторизация
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Controller
 * @version    $Id: AuthController.php 234 2010-06-28 07:25:10Z igor $
 */

class Admin_AuthController extends Xcms_Controller_Admin {
	
	/**
	 * Вход
	 * @return void
	 */
	public function loginAction() {
		$messenger = $this->_helper->getHelper('FlashMessenger');
		$messages = array();
		$db = $this->getInvokeArg('bootstrap')->getResource( 'db' );
		$form = new Admin_Form_Auth_Login();
		$request = $this->getRequest();
		if ( $request->isPost() ) {
			if ( $form->isValid( $request->getPost() ) ) {
				$adapter = new Zend_Auth_Adapter_DbTable ( 
					$db, 
					'users', 
					'name', 
					'password',
					'? AND is_active != 0'
				);
				$adapter->setIdentity( $form->getValue( 'username' ) );
				$adapter->setCredential( md5( Zend_Registry::get('staticSalt') . $form->getValue( 'password' ) ) );
				$auth = Zend_Auth::getInstance();
				try{
					$result = $auth->authenticate( $adapter );
				} catch ( Exception $e ) {
					throw Main::logErr( $e );
				}
				$messages = $result->getMessages(); 
				if ( $result->isValid() ) {
					//foreach ( $messages as $message ) $messenger->addMessage( $message );
					$storage = $auth->getStorage();
					$user_row_data = $adapter->getResultRowObject( array( 'id' , 'name', 'id_object', 'id_usergroup') );
					//$user_group = Model_Collection_Objects::getInstance()->getEntity( $user_row_data->id_usergroup );
					$storage->write( $user_row_data );
					// перенаправляем на главную модуля Admin
					$this->_redirect( $this->view->url( array('module'=>'admin'), null, true ) );
					return;
				} else {
					//$this->getResponse()->setHttpResponseCode( 401 );
				}
			}
		}
		$this->view->jQuery()
			->addJavascriptFile( $this->view->BaseUrl( 'cms/js/dialog_error.js' ) );
		$this->view->messages = $messages + $messenger->getMessages();
		$this->view->form = $form;
	}
	
	/**
	 * Выход
	 * @return void
	 */
	public function logoutAction() {
		Zend_Auth::getInstance()->clearIdentity();
		$this->_redirect( $this->view->url( array('action'=>'login') ) );
		return;
	}
}