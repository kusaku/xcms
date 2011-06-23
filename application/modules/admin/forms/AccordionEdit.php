<?php
/**
 * 
 * Стандартная форма редактирования
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Form
 * @version    $Id: AccordionEdit.php 118 2010-02-24 12:31:57Z renat $
 */

class Admin_Form_AccordionEdit extends Admin_Form_Edit {

	/**
	 * Инициализация формы
	 * @return void
	 */
	public function init() {
		$this->addPrefixPath(
			'Xcms_Form_Decorator',
			'Xcms/Form/Decorator/',
			'decorator'
		);
		$this->setMethod( 'post' );
		$this->setName( 'editform' );
		$this->setDecorators(array(
			'FormElements',
			array('AccordionContainer', array(
				'id' => 'formcontainer'
			)),
			'Form',
		));
	}

	/**
	 * Добавляет группу отображения
	 * @param  array $elements
	 * @param  string $name
	 * @param  array|Zend_Config $options
	 * @return Admin_Form_Edit $this
	 */
	public function addDisplayGroup(array $elements, $name, $options = null) {
		ZendX_JQuery_Form::addDisplayGroup( $elements, $name, $options );
		$dg = $this->getDisplayGroup( $name );
		$dg->setDecorators( array( 
			array( 'FormElements' ), 
			array( 'Fieldset', array( 'class' => 'content' ) ), 
			array( 'HtmlTag' ), 
			array( 'AccordionPane', array(
				'jQueryParams' => array(
					'containerId' => 'editform',
					'title' => $dg->getDescription()
				)
			) )
		) );
 		return $this;
	}
}