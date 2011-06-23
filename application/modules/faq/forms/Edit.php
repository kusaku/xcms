<?php
/**
 * 
 * Форма настроек
 * 
 * @category   Xcms
 * @package    Faq
 * @subpackage Form
 * @version    $Id:
 */

class Faq_Form_Edit extends Admin_Form_Edit 
{
	public function init() 
	{
		parent::init();
		$this->addElement('hidden', 'faq_act', array(
			'value' => $this->id
		));
		$this->addDisplayGroup( 
			array( 'faq_act' ), 
			'faq_active', 
			array('description' => 'Опубликованные' )
		);
		$this->addElement('hidden', 'f_new', array(
			'value' => $this->id
		));
		$this->addDisplayGroup( 
			array( 'f_new' ), 
			'faq_new', 
			array('description' => 'Новые и неопубликованные' )
		);
		$this->setElementDecorators( array(
			array('Label', array('nameimg' => 'ico_help.gif')), 
			'ViewHelper',
			'Errors',
			array('HtmlTag', array( 'class' => 'fullwidth' ))
		));
	}
}