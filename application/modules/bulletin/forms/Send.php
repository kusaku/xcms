<?php
/**
 * 
 * Форма обратной связи
 * 
 * @category   Xcms
 * @package    Bulletin
 * @subpackage Form
 * @version    $Id: $
 */
 
class Bulletin_Form_Send extends Zend_Form {
	
	public function init() {
		$this->addPrefixPath(
			'Xcms_Form_Decorator',
			'Xcms/Form/Decorator/',
			'decorator'
		);
		$email = new Xcms_Form_Validate_Email();
		$this->setName( 'bulletinform' );
		$this->setMethod( 'post' );
		$this->addElement( 'text', 'bulletin_name', array(
			'label' => 'Ваше имя:',
			'class' => 'bulletin_name',
			'required' => true,
			'filters' => array( 'StringTrim', 'StripTags' )
		) );
		//$this->getElement('bulletin_name')->se
		$this->addElement( 'text', 'bulletin_email', array (
			'label' => 'Ваш e-mail:',
			'class' => 'bulletin_email',
			'required' => true,
			'filters' => array( 'StringTrim' ),
			'validators' => array( $email )
		) );
		//$this->bulletin_email->addPrefixPath('Xcms_Form_Validate', 'Xcms/Form/Validate', 'validator');
		$this->addElement( 'text', 'bulletin_phone', array(
			'label' => 'Ваш телефон:',
			'class' => 'bulletin_phone',
			'filters' => array( 'StringTrim', 'StripTags' )
		) );
		$this->addElement( 'textarea', 'bulletin_maintext', array (
			'label' => 'Ваше объявление:',
			'required' => true,
			'class' => 'bulletin_maintext',
			'rows' => 3,
			'filters' => array( array('StripTags', array('allowTags' => array('p', 'br'))) )
		) );
		$reg = Zend_Registry::getInstance();
		if($reg->get( 'bulletin_captcha' )){
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
		$this->addElement ( 'submit', 'submit', array (
			'ignore' => true, 
			'label' => 'отправить' 
		) );		
		$this->setElementDecorators( array(
			array ('LabelRequired', array('required' => true)),
			'ViewHelper',
			'Errors'
		),
		array('bulletin_name', 'bulletin_email', 'bulletin_maintext'));
		$this->setElementDecorators( array(
			'LabelRequired',
			'ViewHelper',
			'Errors'
		),
		array('bulletin_phone'));
		// защита от CSRF атак (подделка межсайтовых запросов)
		$this->addElement( 'hash', 'no_csrf', array(
			'salt' => 'Un1qU3'
		) );
		
	}
}