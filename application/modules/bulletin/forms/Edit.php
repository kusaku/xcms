<?php
/**
 * 
 * Форма настроек
 * 
 * @category   Xcms
 * @package    Bulletin
 * @subpackage Form
 * @version    $Id:
 */

class Bulletin_Form_Edit extends Admin_Form_Edit 
{
	public function init() 
	{
		parent::init();
		$this->addElement('hidden', 'bul_act', array(
			'value' => $this->id
		));
		$this->addDisplayGroup( 
			array( 'bul_act' ), 
			'bulletin_active', 
			array('description' => 'Опубликованные' )
		);
		$this->addElement('hidden', 'bul_new', array(
			'value' => $this->id
		));
		$this->addDisplayGroup( 
			array( 'bul_new' ), 
			'bulletin_new', 
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