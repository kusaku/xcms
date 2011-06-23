<?php
/**
 * 
 * Форма подготовки к переносу
 * 
 * @category   Xcms
 * @package    Install
 * @subpackage Form
 * @version    $Id: $
 */
class System_Form_Prepare extends Admin_Form_Edit {
	
	public function init() {
		parent::init();
		//require_once dirname(realpath((__FILE__))).'/Validate/FileExists.php';
		//$this->addPrefixPath('Dump_File_Exists', dirname(realpath((__FILE__))).'/Validate/');
		$exists = new Xcms_Form_Validate_FileExists();
		$dump_name = 'dump_'.date("dmy_Hi");
                $this->addElement('hidden', 'system',
                        array('value' => 1));
                $this->addElement('hidden', 'dumps',
                        array('value' => 1));
		$this->addElement(
			'text',
			'prepare',
			array(
					'label' => 'Имя файла дампа',
					'value' => $dump_name,
					'required' => true,
					'validators' => array($exists, 'NotEmpty'),
					'description' => 'Имя файла дампа, под которым он будет сохранен'
				)
		);
		
		$this->setElementDecorators( array(
			array('Label', array('nameimg' => 'ico_help.gif')),
			'ViewHelper',
			'Errors',
			array('HtmlTag', array( 'class' => 'halfwidth' ))
		));
	}
	
}