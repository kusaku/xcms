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
                $this->view->register_errors = $form->getMessages();
            }
        }
        $this->view->form = $form;
        $this->renderContent('register.phtml');
    }

	/**
	 * Регистрация гостя.
	 * Применяется в случае покупки "без регистрации".
	 * Логином становится EMail, пароль генерируется.
	 *
	 * <form method="post">
		<p>Логин
		<input type="text" name="login" id="login" value="" class="UserLogin input-text"></p>
		<p>Пароль
		<input type="password" name="user_password" id="user_password" value="" class="UserPassword"></p>
		<p>Имя пользователя
		<input type="text" name="user_name" id="user_name" value="Новый" class="Name input-text"></p>
		<p>Фамилия пользователя
		<input type="text" name="user_surname" id="user_surname" value="" class="String input-text"></p>
		<p>Email
		<input type="text" name="user_email" id="user_email" value="" class="Email input-text"></p>
		<p>
		<input type="submit" name="regbutton" id="regbutton" value="Сохранить"></p>
		</form>
	 *
	 *
	 */
	public function  guestRegAction() {
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
                $this->view->register_errors = $form->getMessages();
            }
        }
        $this->view->form = $form;
        $this->renderContent('register.phtml');
    }
}
?>
