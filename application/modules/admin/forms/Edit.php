<?php
/**
 * 
 * Стандартная форма редактирования
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Form
 * @version    $Id: Edit.php 326 2010-08-24 03:34:50Z kifirch $
 */

class Admin_Form_Edit extends ZendX_JQuery_Form {

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
		$this->removeDecorator( 'HtmlTag' );
	}

	/**
	 * Добавляет группу отображения
	 * @param  array $elements
	 * @param  string $name
	 * @param  array|Zend_Config $options
	 * @return Admin_Form_Edit $this
	 */
	public function addDisplayGroup(array $elements, $name, $options = null) {
		parent::addDisplayGroup( $elements, $name, $options );
		$dg = $this->getDisplayGroup( $name );
		if ( isset($options['style']) and $options['style']=='display: none;' ) {
			$nameimg = 'arrow_down';
			$title = 'Развернуть';
		} else {
			$nameimg = 'arrow_up';
			$title = 'Свернуть';
		}
		$dg->setDecorators( array( 
			array( 'FormElements' ), 
			array( 'Fieldset', array( 'class' => 'content' ) ), 
			array( 'Header',  array(
				'placement' => 'prepend', 
				'class' => 'header '.$nameimg, 
				'tag' => 'div',
				'title' => $title
			) ), 
			array( 'HtmlTag', array('class' => 'panel') ) 
		) );
 		return $this;
	}
	
	/**
	 * Добавляет кнопки для группы полей
	 * @param $name имя группы полей (группы отображения)
	 * @param $action действие (edit или add)
	 * @return Admin_Form_Edit $this
	 */
	public function addDisplayGroupButtons( $name, $action='edit', $skip = array() ) {
		$save = new Zend_Form_Element_Submit( 'save_'.$name );
		$save_exit = new Zend_Form_Element_Submit( 'save_exit_'.$name );
		if ( $action == 'edit' ) {
			$save->setOptions( array('label' => 'Применить', 'ignore' => true, 'disabled' =>'disabled', 'class' => 'ui-decor-save') );
			$save_exit->setOptions(	array('label' => 'Сохранить', 'ignore' => true, 'disabled' =>'disabled') );
		} elseif ( $action == 'add' ) {
			$save->setOptions( array('label' => 'Добавить', 'ignore' => true ) );
			$save_exit->setOptions(	array('label' => 'Сохранить', 'ignore' => true) );
		} elseif ( $action == 'cancel') {
                        $cancel = new Zend_Form_Element_Button( 'cancel_'.$name );
                        $cancel->setOptions( array('label' => 'Отменить' ) );
                        $cancel->removeDecorator( 'DtDdWrapper' );
                        $this->getDisplayGroup( $name )->addElements( array( $cancel ) );
                        return $this;
                }
		
		$cancel = new Zend_Form_Element_Button( 'cancel_'.$name );
		$cancel->setOptions( array('label' => 'Отменить' ) );
		$save
			->removeDecorator( 'DtDdWrapper' )
			->addDecorator( 'HtmlTag', array( 'class' => 'submit', 'openOnly' => true ) );
		$save_exit
			->removeDecorator( 'DtDdWrapper' )
			->addDecorator( 'HtmlTag', array( 'closeOnly' => true ) );
		$cancel
			->removeDecorator( 'DtDdWrapper' );
		$this->getDisplayGroup( $name )->addElements( array( $save, $cancel, $save_exit ) );
		return $this;
	}
}