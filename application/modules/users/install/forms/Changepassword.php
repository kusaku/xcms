<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Changepassword
 *
 * @author aleksey.f
 */
class Users_Form_Changepassword extends Zend_Form  {
    public function  init() {
        parent::init();
        $this->addElement(
            'password',
            'old_password',
            array('required' => true)
        );
        $this->addElement(
            'password',
            'new_password',
            array('required' => true)
        );
        $this->addElement(
            'password',
            'new_password_confirm',
            array('required' => true)
        );
        $this->addElement(
            'submit',
            'change',
            array('label'=>'Сохранить')
        );
    }

    public function  isValid($data) {
        parent::isValid($data);
        
    }
}
?>
