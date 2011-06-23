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
class Zend_View_Helper_Search {
    //put your code here

    public $view;


    public function setView(Zend_View_Interface $view)
    {
       	$this->view = $view;
    }

    /**
     * Рендер формы поиска
     * @return string
     */
    public function search() {
        $reg = Zend_Registry::getInstance();
        $mce = Model_Collection_Elements::getInstance();
        $search_element = $mce->getEntity(2);
        if($reg->get('search_active')) {
            $form = new Search_Form_Search();
            $form->setAction($search_element->urlname);
            $form->populate($_POST);
            $output = '<p>';
            $output .=  $form->render();
            $output .= '</p>';
            return $output;
        }
        return '';
    }
}
?>
