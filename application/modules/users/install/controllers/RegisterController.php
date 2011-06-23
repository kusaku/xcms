<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of RegisterController
 *
 * @author aleksey.f
 */
class Users_RegisterController extends Xcms_Controller_Modulefront {
    //put your code here
    public function  viewAction() {
        $this->setDataFrom( $this->getRequest()->getParam('id') );
        $form = new Users_Form_Register();
        if($this->getRequest()->isPost()) {
            if( $form->isValid( $this->getRequest()->getParams() ) ) {
                $mcu = Model_Collection_Users::getInstance();
                $user = $mcu->createUser( array( 'id_usergroup'=>Model_Collection_Users::REGISTERED ) );
                try {
                    $user->setValues($this->getRequest()->getPost());
                    $reg = Zend_Registry::getInstance();
                    if( $reg->get('users_active_mode') == 1 ) {
                        $user->is_active = 1;
                    }
                    $user->commit();
                } catch(Exception $e) {
                    $this->view->fatalerror = $e->getMessage();
                    $this->view->is_regist = false;
                }
                $this->view->is_regist = true;
            } else {
                $this->view->register_errors = $form->getErrorMessages();
            }
        }
        $this->view->form = $form;
        $this->renderContent('register.phtml');
    }
}
?>
