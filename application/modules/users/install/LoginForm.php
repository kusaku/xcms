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
            if($_POST) {
                if($loginForm->isValid($_POST)) {
                    return $loginForm->render();
                } else {
                    $output = 'Неправильные логин или пароль<br/>';
                    $loginForm->populate($_POST);
                    $output.= $loginForm->render();
                }
            } else {
                $output = 'Неправильные логин или пароль<br/>';
                $loginForm->populate($_POST);
                $output.= $loginForm->render();
            }
        } else {
           $output = 'Вы вошли как '.$auth->getIdentity()->name.'<br/>'.$logoutForm->render();
        }
        //$output = $loginForm->render();
        return $output;
    }
}
?>
