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
class Offers_Form_Options extends Admin_Form_Edit {
    public function init() {
		parent::init();
		$reg = Zend_Registry::getInstance();
			// Глобальные настройки (global)
		$offers_socbuttons = $reg->get( 'offers_socbuttons' );
		$this->addElement( 'checkbox', 'offers_socbuttons', array(
			'label' => 'Отображение социальных кнопок',
			'value' => $offers_socbuttons,
			'description' => 'Включить отображение социальных кнопок в полном тексте акции'
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
