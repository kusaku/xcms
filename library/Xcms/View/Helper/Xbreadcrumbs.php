<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Breadscrumbs
 *
 * @author aleksey.f
 */
class Xcms_View_Helper_Xbreadcrumbs extends Zend_View_Helper_Abstract {

    public $view;

    public function setView(Zend_View_Interface $view)
    {
       	$this->view = $view;
    }

    


    public function  xbreadcrumbs($simbol = '>') {
        $mce = Model_Collection_Elements::getInstance()->fetchAll();
        $s = new Zend_Navigation();
        foreach($mce as $elem) {
            $page = $elem->getPage();
            if ( $page->isVisible() ) {
                        if($this->view->element->id == $page->id) {
                            $page->setActive(true);
                        }
                        $s->addPage( $page );
                }
        }
        foreach ( $mce as $elem ) { // использовать foreach container нельзя из-за find
                if ( !empty( $elem->id_parent ) ) {
                        $parent = $s->findById( $elem->id_parent );
                        if ( isset( $parent ) ) {
                                $page = $s->findById( $elem->id );
                                if ( !isset($page) ) continue;
                                $page->setParent( $parent );
                                $parent_element = Model_Collection_Elements::getInstance()->getEntity( $elem->id_parent );
                                if ( $parent_element->getValue( 'menu_showsub' ) ) {
                                        $page->setVisible( true );
                                }
                        }
                }
        }
        
        $this->view->breadcrumbs()->setContainer($s)->setMinDepth(0)->setSeparator(' '.$simbol.' ');
        return (string)$this->view->breadcrumbs();
        //$output = $this->view->breadcrumbs()->render();
        //print_r($this->view->breadcrumbs());
        //return $output;
    }
    /*
 * 
 */
}

