<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Adding
 *
 * @author aleksey.f
 */
class Shop_Form_Adding extends Zend_Form {

    public function init() {
        $this->addElement(
            'text',
            'count',
            array(
                'label' => 'Количество',
                'value' => 1
            )
        );
        $this->addElement(
            'submit',
            'add_to_order',
            array(
                'label' => 'Заказать',
            )
        );
        foreach($this->getElements() as $element) {
            $element->removeDecorator('HtmlTag');
            $element->removeDecorator('DtDdWrapper');
            $element->removeDecorator('Label');
            $element->removeDecorator('Errors');
        }
    }

}
?>
