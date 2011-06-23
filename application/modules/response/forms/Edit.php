<?php
/**
 * 
 * Форма настроек
 * 
 * @category   Xcms
 * @package    Response
 * @subpackage Form
 * @version    $Id:
 */

class Response_Form_Edit extends Admin_Form_Edit 
{
	public function init() 
	{
		parent::init();
		$this->addElement('hidden', 'res_act', array(
			'value' => $this->id
		));
		$this->addDisplayGroup( 
			array( 'res_act' ), 
			'response_active', 
			array('description' => 'Опубликованные' )
		);
		$this->addElement('hidden', 'res_new', array(
			'value' => $this->id
		));
		$this->addDisplayGroup( 
			array( 'res_new' ), 
			'response_new', 
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