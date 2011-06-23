<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Search
 *
 * @author aleksey.f
 */
class Catalog_Form_Search extends Zend_Form {

    public function  init() {
        parent::init();
        $this->setMethod('GET');
        $this->addElement(
            'select',
            'category',
            array(
                'label' => 'Категория',
            )
        );
        $this->addElement(
            'multiCheckbox',
            'search_field',
            array(
                'label' => 'Поля поиска'
            )
        );
        $this->addElement(
            'text',
            'query',
            array(
                'label' => 'Искать слово'
            )
        );

        $this->addElement(
            'text',
            'min_price',
             array(
                 'label' => 'Мин. цена',
                 'validators' => array('digits')
             )
        );
        $this->addElement(
            'text',
            'max_price',
             array(
                 'label' => 'Макс. цена',
                 'validators' => array('digits')
             )
        );
        $this->addElement(
            'submit',
            'go',
            array(
                'label' => 'Искать'
            )
        );
    }

}
?>
