<?php
/**
 * 
 * Форма обратной связи
 * 
 * @category   Xcms
 * @package    Feedback
 * @subpackage Form
 * @version    $Id: $
 */

class Feedback_Form_Send extends Zend_Form {
	
	public function init() {
		$this->setName( 'feedbackform' );
		$this->setMethod( 'post' );
		
	}
	
	public function addCaptcha() {
		$this->addElement( 'captcha', 'cpc', array(
			'label' => "Введите код с картинки:",
			'captcha' =>  array(
				'captcha' => 'Image',
				'wordLen' => 4,
				'timeout' => 300,
				'width' => 100,
				'dotnoiselevel' =>20,
				'linenoiselevel' => 2,
				'font'    => './captcha/arial.ttf',
				'imgDir'    => './captcha/images/',
        		'imgUrl'    => '/captcha/images/'
			)
		));
	}
	
	public function addSubmitButton() {
		$this->addElement ( 'submit', 'submit', array (
			'ignore' => true, 
			'label' => 'отправить' 
		) );
		// защита от CSRF атак (подделка межсайтовых запросов)
		$this->addElement( 'hash', 'no_csrf', array(
			'salt' => 'Un1qU3'
		) );
	}
}
