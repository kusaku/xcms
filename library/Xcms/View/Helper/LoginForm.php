<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of LoginForm
 *
 * @author aleksey.f
 */
class Zend_View_Helper_LoginForm extends Zend_View_Helper_Action {

    public $view;

    public function setView(Zend_View_Interface $view) {
        $this->view = $view;
    }
    
    public function loginForm() {
        $auth = Zend_Auth::getInstance();
        $logoutForm = new Users_Form_Logout();
        $loginForm = new Users_Form_Login();
        if(!$auth->hasIdentity()) {
            if($_POST['login']) {
                if($loginForm->isValid($_POST)) {
                    return $loginForm->render();
                } else {
                    $output = 'Неправильные логин или пароль<br/>';
                    $loginForm->populate($_POST);
                    $output.= $loginForm->render();
                }
            } else {
                $loginForm->populate($_POST);
                $output.= $loginForm->render();
            }
        } else {
           $output = 'Вы вошли как <a href="/Profile">'.$auth->getIdentity()->name.'</a>';
		   $output .='	<form enctype="application/x-www-form-urlencoded" action="/users/index/view" method="post"><dl class="zend_form">
						<dt id="logout-label">&nbsp;</dt><dd id="logout-element">
						<input type="submit" name="logout" id="logout" value="Выйти"  style="background-color: #FF6E00; color: #FFF; border: 0; padding: 5px 10px; margin: 3px;cursor: pointer;"></dd></dl></form>';
        }
        //$output = $loginForm->render();

		$output='<div class="border"><h3>Авторизация</h3>'.$output.'</div>';


        return $output;
    }
}
?>
