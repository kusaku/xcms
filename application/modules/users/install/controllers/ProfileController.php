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
        if($request->isPost()) {
            $request->setParam('user_password', $user->password);
            if($form->isValid($request->getParams())) {
                $user->setValues($form->getValues());
                $user->commit();
                $this->view->errors = 'Изменения сохранены';
            } else {
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
                $user->commit();
                $this->view->errors = 'Изменения сохранены';
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
