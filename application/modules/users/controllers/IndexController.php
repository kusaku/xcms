<?php
/**
 * Description of IndexContoller
 *
 * @author aleksey.f
 */
class Users_IndexController extends Xcms_Controller_Modulefront {
    //put your code here

    public function viewAction() {
        $auth = Zend_Auth::getInstance();
        $logoutForm = new Users_Form_Logout();
        $loginForm = new Users_Form_Login();
        if(!$auth->hasIdentity()) {
            $data = $this->getRequest()->getPost();
            if($this->_request->isPost()) {
                if($loginForm->isValid($data)) {
                    $db = $this->getInvokeArg('bootstrap')->getResource( 'db' );
                    $adapter = new Zend_Auth_Adapter_DbTable (
                            $db,
                            'users',
                            'name',
                            'password',
                            '? AND is_active != 0'
                    );
                    Main::logDebug($db);
                    $adapter->setIdentity( $loginForm->getValue( 'username' ) );
                    $adapter->setCredential( md5( Zend_Registry::get('staticSalt') . $loginForm->getValue( 'userpass' ) ) );

                    try{
                            $result = $auth->authenticate( $adapter );
                    } catch ( Exception $e ) {
                            throw Main::logErr( $e );
                    }
                    $messages = $result->getMessages();
                    if ( $result->isValid() ) {
                            $storage = $auth->getStorage();
                            $user_row_data = $adapter->getResultRowObject( array( 'id' , 'name', 'id_object', 'id_usergroup') );
                            $storage->write( $user_row_data );
                            $output  = 'Вы вошли как '.$auth->getIdentity()->name.'<br/>'.$logoutForm->render();
                    } else {
                            $output  = $loginForm->render();
                    }
                } 
            } else {
                $output = $loginForm->render();
            }
        } else {
            
            if($this->_request->isPost()) {
                $auth->getStorage()->clear();
                $output = $loginForm->render();
            } else {
                $output = 'Вы вошли как '.$auth->getIdentity()->name.'<br/>'.$logoutForm->render();
            }
        }
		$this->_redirect($_SERVER['HTTP_REFERER']);
    }

}
?>