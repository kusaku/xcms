<?php
/**
 * 
 * Свойство - e-mail
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Email.php 623 2011-01-18 12:48:46Z kifirch $
 */

class Model_Entity_Property_Email extends Model_Entity_Property_String {
	
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
                $email = new Xcms_Form_Validate_Email();
		$field = parent::getFormElement();
		$field
			->addValidator( $email )
		;
		return $field;
	}
}