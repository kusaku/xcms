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
class Gallery_Form_Options extends Admin_Form_Edit {
    
    public function init() {
	parent::init();
	$reg = Zend_Registry::getInstance();
		// Глобальные настройки (global)
	$gallery_big_size = $reg->get( 'gallery_big_size' );
	$this->addElement( 'text', 'gallery_big_size', array(
		'label' => 'Большие изображения',
		'value' => $gallery_big_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в режиме увеличения.'
	));
	$gallery_square_big = $reg->get( 'gallery_square_big' );
	$this->addElement( 'checkbox', 'gallery_square_big', array(
		'label' => 'Большие сделать квадратом',
		'value' => $gallery_square_big,
		'description' => 'Преобразовать загружаемые большие изображения в квадрат'
	));
	$gallery_medium_size = $reg->get( 'gallery_medium_size' );
	$this->addElement( 'text', 'gallery_medium_size', array(
		'label' => 'Средние изображения',
		'value' => $gallery_medium_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть выведены на странице с подробным описанием элемента каталога.'
	));
	$gallery_square_medium = $reg->get( 'gallery_square_medium' );
	$this->addElement( 'checkbox', 'gallery_square_medium', array(
		'label' => 'Средние сделать квадратом',
		'value' => $gallery_square_medium,
		'description' => 'Преобразовать загружаемые средние изображения в квадрат'
	));
	$gallery_small_size = $reg->get( 'gallery_small_size' );
	$this->addElement( 'text', 'gallery_small_size', array(
		'label' => 'Миниатюрные изображения',
		'value' => $gallery_small_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в списке элементов каталога.'
	));
	$gallery_square_small = $reg->get( 'gallery_square_small' );
	$this->addElement( 'checkbox', 'gallery_square_small', array(
		'label' => 'Миниатюры сделать квадратом',
		'value' => $gallery_square_small,
		'description' => 'Преобразовать загружаемые миниатюры элементов каталога в квадрат'
	));
	$gallery_kategory_size = $reg->get( 'gallery_kategory_size' );
	$this->addElement( 'text', 'gallery_kategory_size', array(
		'label' => 'Изображения категорий',
		'value' => $gallery_kategory_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения для категорий каталога.'
	));
	$gallery_square_kategory = $reg->get( 'gallery_square_kategory' );
	$this->addElement( 'checkbox', 'gallery_square_kategory', array(
		'label' => 'Категории сделать квадратом',
		'value' => $gallery_square_kategory,
		'description' => 'Преобразовать загружаемые миниатюры категорий каталога в квадрат'
	));
	$this->addDisplayGroup( 
		array( 
			'gallery_big_size','gallery_square_big','gallery_medium_size',
			'gallery_square_medium','gallery_small_size','gallery_square_small',
			'gallery_kategory_size','gallery_square_kategory'
		), 
		'global', 
		array('description' => 'Глобальные настройки' )
	);
	$this->setElementDecorators( array(
		array('Label', array('nameimg' => 'ico_help.gif')), 
		'ViewHelper',
		'Errors',
		array('HtmlTag', array( 'class' => 'fullwidth' ))
	));
    }
}

?>
