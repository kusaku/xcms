<?php

class Xcms_Form_Validate_FileExists extends Zend_Validate_Abstract {

	const MSG_EXISTS = 'msgExists';
	
	protected $_messageTemplates = array(
	  self::MSG_EXISTS => "Файл '%value%' уже существует",
	);
	
	public function isValid($value) {
		$this->_setValue($value);
 
        if ( file_exists(APPLICATION_PATH.'/../data/db/'.$value.'.sql') ) {
            $this->_error(self::MSG_EXISTS);
            return false;
        }
        return true;
	}
}