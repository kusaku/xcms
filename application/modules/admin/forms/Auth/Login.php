<?php
/**
 * 
 * Форма авторизации
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Form
 * @version    $Id: Login.php 174 2010-04-20 10:58:18Z igor $
 */

class Admin_Form_Auth_Login extends ZendX_JQuery_Form 
{
	public function init() 
	{
		$this->setName( 'loginform' );
		$this->setMethod( 'post' );
		$this->addElement( 'text', 'username', array(
			'label' => 'Логин:',
			/*'required' => true, */
			'filters' => array( 'StringTrim' )
		) );
		$this->addElement( 'password', 'password', array (
			'label' => 'Пароль:'
			/*'required' => true */
		) );
		$this->addElement ( 'submit', 'submit', array (
			'ignore' => true, 
			'label' => 'Войти' 
		) );
		/*$this->setDecorators(array(
			'FormElements',
			'Form',
			array('DialogContainer', array(
				'jQueryParams'  => array(
					'bgiframe'  => true,
					'modal'     => true,
					//'draggable' => false,
					'resizable' => false,
					//'closeOnEscape' => false,
					'title'     => 'Требуется авторизация'
				)
			))
		));*/
		$this->setElementDecorators(
			array('Label', 'ViewHelper', 'Errors', array('HtmlTag', array('class' => 'auth_input'))),
			array('username', 'password')
		);
		$this->setElementDecorators(
			array('ViewHelper', 'Errors', array('HtmlTag', array('class' => 'auth_submit'))),
			array('submit')
		);
		$this->addDisplayGroup(
			array( 'username', 'password', 'submit' ), 
			'identials'
		);
		$this->identials->setDecorators( array( 
			array( 'FormElements' ), 
			array( 'Fieldset')
		));
		$this->setDecorators(array(
			array('FormElements'),
			array('Form'),
			array(
				array('elementDiv' => 'HtmlTag'),
				array('placement' => 'prepend', 'tag' => 'div', 'id' => 'authlogo')
			),
			array( 'HtmlTag', array('id' => 'authorization'))
		));
	}
}