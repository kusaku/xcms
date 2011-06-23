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
class Shop_Form_Options extends Admin_Form_Edit {
    
    public function init() {
	parent::init();
	$reg = Zend_Registry::getInstance();
		// Глобальные настройки (global)
	$scenario_reg = (string) $reg->get( 'buy_without_reg' );
	$this->addElement( 'checkbox', 'buy_without_reg', array(
		'label' => 'Возможность заказа без регистрации',
		'value' => $scenario_reg,
		'description' => 'Делает возможным покупку в магазине незарегистрированным пользователям'
	));
	$this->addDisplayGroup( 
		array( 'buy_without_reg' ), 
		'global', 
		array('description' => 'Глобальные настройки' )
	);
	$this->setElementDecorators( array(
		array('Label', array('nameimg' => 'ico_help.gif')), 
		'ViewHelper',
		'Errors',
		array('HtmlTag', array( 'class' => 'fullwidth' ))
	));
    }
}

?>
