<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Options
 *
 * @author aleksey.f
 */
class Search_Form_Options extends Admin_Form_Edit {
    public function init() {
	parent::init();
	$reg = Zend_Registry::getInstance();

	$searchActive = $reg->get( 'search_active' );
	$this->addElement( 'checkbox', 'search_active', array(
		'label' => 'Поиск включен',
		'value' => $searchActive,
		'description' => 'Включить/отключить поиск'
	));

	$this->setElementDecorators( array(
		array('Label', array('nameimg' => 'ico_help.gif')), 
		'ViewHelper',
		'Errors',
		array('HtmlTag', array( 'class' => 'fullwidth' ))
	));


    }
}

?>
