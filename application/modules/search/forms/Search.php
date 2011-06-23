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
class Search_Form_Search extends Zend_Form {

    /**
     * Создает форму поиска
     */
    public function  init() {
        $this->setMethod( 'GET' );
        $this->setName( 'searchform' );
        $this->addElement(
            'text',
            'search_string',
            array(
                'value' => '',
                'label' => 'Поиск',
                'required' => true,
                'validators' => array('NotEmpty'),
            ));
        $this->addElement(
            'submit',
            'search',
            array(
                'label' => 'Искать',
            ));
    }
}
?>
