<?php
/**
 * 
 * Вопрос-Ответ
 * 
 * @category   Xcms
 * @package    Faq
 * @subpackage Form
 * @version    $Id: $
 */
 
class Faq_Form_Send extends Zend_Form {
	
	public function init() {
		$this->addPrefixPath(
			'Xcms_Form_Decorator',
			'Xcms/Form/Decorator/',
			'decorator'
		);
		$email = new Xcms_Form_Validate_Email();
		$this->setName( 'faqform' );
		$this->setMethod( 'post' );
		$this->addElement( 'text', 'faq_name', array(
			'label' => 'Ваше имя:',
			'class' => 'faq_name',
			'required' => true,
			'filters' => array( 'StringTrim', 'StripTags' )
		) );
		$this->addElement( 'text', 'faq_email', array (
			'label' => 'Ваш e-mail:',
			'class' => 'faq_email',
			'required' => true,
			'filters' => array( 'StringTrim' ),
			'validators' => array( $email )
		) );
		$this->addElement( 'textarea', 'faq_question', array (
			'label' => 'Ваш вопрос:',
			'required' => true,
			'class' => 'faq_question',
			'rows' => 3,
			'filters' => array( array('StripTags', array('allowTags' => array('p', 'br'))) )
		) );
		$reg = Zend_Registry::getInstance();
		if($reg->get( 'faq_captcha' )){
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
		array('faq_name', 'faq_email', 'faq_question'));
		// защита от CSRF атак (подделка межсайтовых запросов)
		$this->addElement( 'hash', 'no_csrf', array(
			'salt' => 'Un1qU3'
		) );
		
	}
}