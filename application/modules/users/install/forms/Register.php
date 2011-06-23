<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Register
 *
 * @author aleksey.f
 */
class Users_Form_Register extends Zend_Form{

    public function  init() {
        parent::init();
        $userform = Model_Collection_Users::getInstance()->createUser(array( 'id_usergroup'=>Model_Collection_Users::REGISTERED ))->getEditForm();
      
        $this->addElements($userform->getElements());
        $this->addElement(
                'submit',
                'regbutton',
                array(
                    'label' => 'Сохранить'
                ));
        foreach($this->getElements() as $element) {
            $element->removeDecorator('HtmlTag');
            $element->removeDecorator('DtDdWrapper');
            $element->removeDecorator('Label');
            $element->removeDecorator('Errors');
        }
    }

}
?>
