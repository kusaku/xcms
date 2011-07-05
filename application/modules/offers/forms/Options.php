<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Options
 *
 * @author aleksey.f
 */
class Offers_Form_Options extends Admin_Form_Edit {
    public function init() {
		parent::init();
		$reg = Zend_Registry::getInstance();
			// Глобальные настройки (global)
		$offers_big_size = $reg->get( 'offers_big_size' );
		$this->addElement( 'text', 'offers_big_size', array(
			'label' => 'Большие изображения',
			'value' => $offers_big_size,
			'validators' => array( array( 'Int' ) ),
			'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в режиме увеличения.'
		));
		$offers_square_big = $reg->get( 'offers_square_big' );
		$this->addElement( 'checkbox', 'offers_square_big', array(
			'label' => 'Большие сделать квадратом',
			'value' => $offers_square_big,
			'description' => 'Преобразовать загружаемые большие изображения в квадрат'
		));
		$offers_medium_size = $reg->get( 'offers_medium_size' );
		$this->addElement( 'text', 'offers_medium_size', array(
			'label' => 'Средние изображения',
			'value' => $offers_medium_size,
			'validators' => array( array( 'Int' ) ),
			'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть выведены на странице с подробным описанием элемента каталога.'
		));
		$offers_square_medium = $reg->get( 'offers_square_medium' );
		$this->addElement( 'checkbox', 'offers_square_medium', array(
			'label' => 'Средние сделать квадратом',
			'value' => $offers_square_medium,
			'description' => 'Преобразовать загружаемые средние изображения в квадрат'
		));
		$offers_small_size = $reg->get( 'offers_small_size' );
		$this->addElement( 'text', 'offers_small_size', array(
			'label' => 'Миниатюрные изображения',
			'value' => $offers_small_size,
			'validators' => array( array( 'Int' ) ),
			'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в списке элементов каталога.'
		));
		$offers_square_small = $reg->get( 'offers_square_small' );
		$this->addElement( 'checkbox', 'offers_square_small', array(
			'label' => 'Миниатюры сделать квадратом',
			'value' => $offers_square_small,
			'description' => 'Преобразовать загружаемые миниатюры элементов каталога в квадрат'
		));
		$offers_socbuttons = $reg->get( 'offers_socbuttons' );
		$this->addElement( 'checkbox', 'offers_socbuttons', array(
			'label' => 'Отображение социальных кнопок',
			'value' => $offers_socbuttons,
			'description' => 'Включить отображение социальных кнопок в полном тексте акции'
		));
		$this->setElementDecorators( array(
		array('Label', array('nameimg' => 'ico_help.gif')), 
		'ViewHelper',
		'Errors',
		array('HtmlTag', array( 'class' => 'fullwidth' ))
	));
    }
}

?>
