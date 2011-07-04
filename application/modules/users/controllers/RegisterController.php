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

	public function  viewAction() {

		$storage = Zend_Auth::getInstance()->getStorage();
		$this->setDataFrom( $this->getRequest()->getParam('id') );
        $form = new Users_Form_Register();
		$is_guest = false;

		/**
		 * Если мы получили параметр guest, то формируем недостающие поля из имеющихся.
		 */
		if ( (bool)$this->getRequest()->getParam('guest') ){
			$_POST['login'] = $_POST['user_email'];
			$_POST['user_password'] = substr(md5(time().'sdk;gj'),1,6);
			$_POST['user_surname'] = '(быстрая покупка)';
			$is_guest = true;
		}

        if($this->getRequest()->isPost()) {
            if( $form->isValid( $this->getRequest()->getParams() ) ) {
                $mcu = Model_Collection_Users::getInstance();
                $user = $mcu->createUser( array( 'id_usergroup'=>Model_Collection_Users::REGISTERED ) );
                try {
                    $user->setValues($this->getRequest()->getPost());
                    if( Zend_Registry::getInstance()->get('users_active_mode') == 1 ) {
                        $user->is_active = 1;
                    }
                    $user->commit();
                } catch(Exception $e) {
                    $this->view->fatalerror = $e->getMessage();
                    $this->view->is_regist = false;
                }
                $this->view->is_regist = true;
				$storage->write( $user );
            } else {
                $this->view->register_errors = $form->getMessages();
            }
        }
        $this->view->form = $form;
		if ( $this->view->is_regist ){


			$title = 'Регистрация прошла успешно!';
			$mess =  htmlspecialchars(trim($_POST['user_name'].", поздравляем Вас! Регистрация прошла успешно!\nВаши логин: ".$_POST['login']."\nи пароль: ".$_POST['user_password']."\n\nС уважением, администрация сайта “".Zend_Registry::getInstance()->get('site_name')."”."));
			$from = (string) $reg->get( 'shop_email' );
			$headers =
				"Content-type: text/html; charset=utf-8\r\n"
				. "From: =?UTF-8?B?".base64_encode($from)."?= <{$from}>\r\n"
				. "Reply-To: =?UTF-8?B?".base64_encode($from)."?= <{$from}>";

			mail($_POST['user_email'], $title, $mess, $headers);

		if ( $is_guest ){
			$uri = Zend_Uri_Http::fromString('http://'.$_SERVER['HTTP_HOST'].'/shopcart');
			$this->_redirect($uri->__toString());
			return true;
		}


		}

		$this->renderContent('register.phtml');
    }

}