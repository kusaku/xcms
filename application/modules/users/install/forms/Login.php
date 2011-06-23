<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Enter
 *
 * @author aleksey.f
 */
class Users_Form_Login extends Zend_Form  {

    public function  init() {
        //parent::init();
        $this->setMethod('post');
        $this->addElement(
            'text',
            'username',
            array(
                'required' => true,
                'label' => 'Логин'
            )
        );
        $this->addElement(
            'password',
            'userpass',
            array(
                'required' => true,
                'label' => 'Пароль'
            )
        );
        $this->addElement(
                'submit', 'login', array(
          'label'   => 'Войти'
        ));
        $this->setAction('/users/index/view');
        foreach($this->getElements() as $element) {
            $element->removeDecorator('Errors');
        }
    }

}
?>
