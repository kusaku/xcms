<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ProfileController
 *
 * @author aleksey.f
 */
class Users_ProfileController extends Xcms_Controller_Modulefront {

    public function  viewAction() {
        $this->setDataFrom( $this->getRequest()->getParam('id') );
        $do = $this->getRequest()->getParam('do');
        if(empty($do)) {
            $mcu = Model_Collection_Users::getInstance();
            $user = $mcu->getEntity(Zend_Auth::getInstance()->getIdentity()->id);
            if(isset ($user->id) ) {
                $request = $this->getRequest();
                $this->view->show = 'just';
                if($request->isPost()) {
                    if($request->getParam('edit')) {
                        $form = new Users_Form_Register();
                        $form->populate($user->getValues());
                        $this->view->form = $form;
                        $this->view->show='edit';
                    } else {
                        $user->setValues($this->getRequest()->getPost());
                        $user->commit();
                    }
                }
            } else {
                return;
            }
            $this->view->user = (object)$user->getValues();
            $this->renderContent('profile.phtml');
        } else {
            switch( $do ) {
                case 'edit':
                    $this->edit();
                    break;
                case 'changepassword':
                    $this->changepassword();
                    break;
            }
        }
        
        
    }

    public function edit() {
        $this->setDataFrom( $this->getRequest()->getParam('id') );
        $mcu = Model_Collection_Users::getInstance();
        $user = $mcu->getEntity(Zend_Auth::getInstance()->getIdentity()->id);
        $request = $this->getRequest();
        $form = new Users_Form_Register();
        $form->getElement('user_password')->setRequired(false);
        if($request->isPost()) {
            $request->setParam('user_password', null);
            $request->setParam('login', $user->getValue('login'));
            if($form->isValid($request->getParams())) {
                $user->setValues($form->getValues());
                $user->is_active = 1;
                $user->commit();
                $this->view->errors = 'Изменения сохранены';
            } else {
                $this->view->errors = $form->getMessages();
                Main::logDebug($form->getErrors());
            }
        }
        $form->populate($user->getValues());
        $this->view->show='edit';
        $this->view->form = $form;
        $this->view->user = (object)$user->getValues();
        $this->renderContent('profile.phtml');
    }

    public function changepassword() {
        $this->setDataFrom( $this->getRequest()->getParam('id') );
        $mcu = Model_Collection_Users::getInstance();
        $user = $mcu->getEntity(Zend_Auth::getInstance()->getIdentity()->id);
        $request = $this->getRequest();
        $form = new Users_Form_Changepassword();
        if($request->isPost()) {
            if($form->isValid($request->getParams())) {
                $ident = md5( Zend_Registry::get('staticSalt') . $form->getValue( 'old_password' ) );
                if($ident == $user->password) {
                    if($form->getValue('new_password') == $form->getValue('new_password_confirm')) {
                        $user->password = md5(Zend_Registry::get('staticSalt').$form->getValue('new_password'));
                        $user->commit();
                        $this->view->errors = 'Изменения сохранены';
                    } else {
                        $this->view->errors = 'Пароль не совпадает с подтверждением';
                    }
                } else {
                    $this->view->errors = 'Старый пароль не верен';
                }
            } else {
                Main::logDebug($form->getErrors());
            }
        }
        $form->populate($user->getValues());
        $this->view->show='editpass';
        $this->view->form = $form;
        $this->view->user = (object)$user->getValues();
        $this->renderContent('profile.phtml');
    }
    


}
?>
