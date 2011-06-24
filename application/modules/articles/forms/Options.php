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
class Articles_Form_Options extends Admin_Form_Edit {
    public function init() {
		parent::init();
		$reg = Zend_Registry::getInstance();
			// Глобальные настройки (global)
		$articles_socbuttons = $reg->get( 'articles_socbuttons' );
		$this->addElement( 'checkbox', 'articles_socbuttons', array(
			'label' => 'Отображение социальных кнопок',
			'value' => $articles_socbuttons,
			'description' => 'Включить отображение социальных кнопок в полном тексте новости'
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
