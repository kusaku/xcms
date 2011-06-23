<?php
class Xcms_Form_Validate_Email extends Zend_Validate_Abstract
{
	const NOT_VALID = 'EmailIsNotValid';
	
	protected $_messageTemplates = array(
		self::NOT_VALID => "Email is not valid" // your error message
	);
	
	public function isValid($value, $context = null){
		$ev = new Zend_Validate_EmailAddress();
        	if ( !$ev->isValid($value) ){
            	$this->_error(self::NOT_VALID);
                return false;
			}
            return true;
        }
}