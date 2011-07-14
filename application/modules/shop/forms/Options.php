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
class Shop_Form_Options extends Admin_Form_Edit {
    
    public function init() {
	parent::init();
	$reg = Zend_Registry::getInstance();
		// Глобальные настройки (global)
	$catalog_big_size = $reg->get( 'catalog_big_size' );
	$this->addElement( 'text', 'catalog_big_size', array(
		'label' => 'Большие изображения',
		'value' => $catalog_big_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в режиме увеличения.'
	));
	$square_big_active = $reg->get( 'square_big_active' );
	$this->addElement( 'checkbox', 'square_big_active', array(
		'label' => 'Большие сделать квадратом',
		'value' => $square_big_active,
		'description' => 'Преобразовать загружаемые большие изображения в квадрат'
	));
	$catalog_medium_size = $reg->get( 'catalog_medium_size' );
	$this->addElement( 'text', 'catalog_medium_size', array(
		'label' => 'Средние изображения',
		'value' => $catalog_medium_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть выведены на странице с подробным описанием элемента каталога.'
	));
	$square_medium_active = $reg->get( 'square_medium_active' );
	$this->addElement( 'checkbox', 'square_medium_active', array(
		'label' => 'Средние сделать квадратом',
		'value' => $square_medium_active,
		'description' => 'Преобразовать загружаемые средние изображения в квадрат'
	));
	$catalog_small_size = $reg->get( 'catalog_small_size' );
	$this->addElement( 'text', 'catalog_small_size', array(
		'label' => 'Миниатюрные изображения',
		'value' => $catalog_small_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в списке элементов каталога.'
	));
	$square_small_active = $reg->get( 'square_small_active' );
	$this->addElement( 'checkbox', 'square_small_active', array(
		'label' => 'Миниатюры сделать квадратом',
		'value' => $square_small_active,
		'description' => 'Преобразовать загружаемые миниатюры элементов каталога в квадрат'
	));
	$catalog_kategory_size = $reg->get( 'catalog_kategory_size' );
	$this->addElement( 'text', 'catalog_kategory_size', array(
		'label' => 'Изображения категорий',
		'value' => $catalog_kategory_size,
		'validators' => array( array( 'Int' ) ),
		'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения для категорий каталога.'
	));
	$square_kategory_active = $reg->get( 'square_kategory_active' );
	$this->addElement( 'checkbox', 'square_kategory_active', array(
		'label' => 'Категории сделать квадратом',
		'value' => $square_kategory_active,
		'description' => 'Преобразовать загружаемые миниатюры категорий каталога в квадрат'
	));
	$scenario_reg = (string) $reg->get( 'buy_without_reg' );
	$this->addElement( 'checkbox', 'buy_without_reg', array(
		'label' => 'Заказ без регистрации Вкл.',
		'value' => $scenario_reg,
		'description' => 'Разрешить клиентам делать заказ без регистрации в интернет-магазине'
	));
	$shop_email = (string) $reg->get( 'shop_email' );
	$this->addElement( 'text', 'shop_email', array(
		'label' => 'E-mail службы поддержки',
		'value' => $shop_email,
		'description' => 'Обратный адрес, для автоматических сообщений интернет-магазина.'
	));
	$shop_socbuttons = $reg->get( 'shop_socbuttons' );
	$this->addElement( 'checkbox', 'shop_socbuttons', array(
		'label' => 'Отображение социальных кнопок',
		'value' => $shop_socbuttons,
		'description' => 'Включить отображение социальных кнопок на странице отдельного товара'
	));
	
	$shop_robox_login = $reg->get( 'shop_robox_login' );
	$this->addElement( 'text', 'shop_robox_login', array(
		'label' => 'Merchant-логин',
		'value' => $shop_robox_login,
		'description' => 'Логин мерчанта в системе Робокасса'
	));
	$shop_robox_passwd_1 = $reg->get( 'shop_robox_passwd_1' );
	$this->addElement( 'text', 'shop_robox_passwd_1', array(
		'label' => 'Merchant-пароль 1',
		'value' => $shop_robox_passwd_1,
		'description' => 'Пароль#1 в системе Робокасса'
	));
	$shop_robox_passwd_2 = $reg->get( 'shop_robox_passwd_2' );
	$this->addElement( 'text', 'shop_robox_passwd_2', array(
		'label' => 'Merchant-пароль 2',
		'value' => $shop_robox_passwd_2,
		'description' => 'Пароль#2 в системе Робокасса'
	));
	$shop_robox_delivid = $reg->get( 'shop_robox_delivid' );
	$this->addElement( 'text', 'shop_robox_delivid', array(
		'label' => 'ID метода оплаты',
		'value' => $shop_robox_delivid,
		'description' => 'ID элемента справочника для оплаты через Робокассу'
	));
	$shop_robox_test = $reg->get( 'shop_robox_test' );
	$this->addElement( 'checkbox', 'shop_robox_test', array(
		'label' => 'Тестовый режим',
		'value' => $shop_robox_test,
		'description' => 'Включить/отключить тестовый режим оплаты'
	));
	
	$this->addDisplayGroup( 
		array( 
			'buy_without_reg', 'shop_email', 'shop_socbuttons'
		), 
		'shop', 
		array('description' => 'Настройки магазина' )
	);
	$this->addDisplayGroup( 
		array( 
			'shop_robox_login', 'shop_robox_passwd_1', 'shop_robox_passwd_2', 'shop_robox_delivid', 'shop_robox_test'
		), 
		'robokassa', 
		array('description' => 'Настройки Робокассы' )
	);
	$this->addDisplayGroup( 
		array( 
			'catalog_big_size','square_big_active','catalog_medium_size',
			'square_medium_active','catalog_small_size','square_small_active',
			'catalog_kategory_size','square_kategory_active'
		), 
		'images', 
		array('description' => 'Настройки изображений' )
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
