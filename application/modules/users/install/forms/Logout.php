<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Logout
 *
 * @author aleksey.f
 */
class Users_Form_Logout extends Zend_Form  {
    //put your code here
     public function  init() {
        parent::init();
        $this->addElement(
            'submit',
            'logout',
            array(
                'label'=>'Выйти'
            ));
        $this->setAction('/users/index/view');
     }
}
?>
