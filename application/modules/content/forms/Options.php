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
class Content_Form_Options extends Admin_Form_Edit {
    public function init() {
	parent::init();
	$reg = Zend_Registry::getInstance();
		// Глобальные настройки (global)
	$site_name = (string) $reg->get( 'site_name' );
	$this->addElement( 'text', 'site_name', array(
		'label' => 'Название сайта (Title)',
		'value' => $site_name,
		'description' => 'Этот Title используется на всех страницах с незаполненными настройками для поисковых систем'
	));
	$site_description = (string) $reg->get( 'site_description' );
	$this->addElement( 'text', 'site_description', array(
		'label' => 'Описание сайта (Description)',
		'value' => $site_description,
		'description' => 'Этот Description используется на всех страницах с незаполненными настройками для поисковых систем'
	));
	$site_keywords = (string) $reg->get( 'site_keywords' );
	$this->addElement( 'text', 'site_keywords', array(
		'label' => 'Ключевые слова (Keywords)',
		'value' => $site_keywords,
		'description' => 'Этот Keywords используется на всех страницах с незаполненными настройками для поисковых систем'
	));
	$use_urlnames = $reg->get( 'use_urlnames' );
	$this->addElement( 'checkbox', 'use_urlnames', array(
		'label' => 'Использовать адреса (URL) из настроек для поисковых систем',
		'value' => $use_urlnames,
		'description' => 'Включить/отключить использование адреса страницы в настройках для поисковых систем'
	));
	$parse_content = $reg->get( 'parse_content' );
	$this->addElement( 'checkbox', 'parse_content', array(
		'label' => 'Включить поддержку блоков в контенте',
		'value' => $parse_content,
		'description' => 'Включить/отключить отображение блоков, выводимых в тексте страницы'
	));
	$this->addDisplayGroup( 
		array( 'site_name', 'site_description', 'site_keywords', 'use_urlnames', 'parse_content' ), 
		'global', 
		array('description' => 'Глобальные настройки' )
	);
	/*$this->addDisplayGroupButtons( 'global', 'edit' );*/
	// Настройки Artic (artic)
	$artic_active = $reg->get( 'artic_active' );
	$this->addElement( 'checkbox', 'artic_active', array(
		'label' => 'Обмен статей',
		'value' => $artic_active,
		'description' => 'Включить/отключить страницу обмена статей'
	));
	$artic_title = (string) $reg->get( 'artic_title' );
	$this->addElement( 'text', 'artic_title', array(
		'label' => 'Название страницы (Title)',
		'value' => $artic_title,
		'description' => 'Этот Title используется на всех страницах статей'
	));
	$artic_urlname = (string) $reg->get( 'artic_urlname' );
	/*$this->addElement( 'text', 'artic_urlname', array(
		'label' => 'Адрес страницы статей',
		'value' => $artic_urlname,
		'description' => 'Адрес страницы отображаемый в браузерной строке'
	));*/
	$this->addDisplayGroup( 
		array( 'artic_active', 'artic_title', 'artic_urlname' ), 
		'artic', 
		array('description' => 'Настройки обмена статьями' )
	);
       /* $this->addDisplayGroupButtons( 'artic', 'edit' );*/

	$this->setElementDecorators( array(
		array('Label', array('nameimg' => 'ico_help.gif')), 
		'ViewHelper',
		'Errors',
		array('HtmlTag', array( 'class' => 'fullwidth' ))
	));

	// Robots.txt
	$robotsFile = APPLICATION_PATH . '/../public/robots.txt';
	if( file_exists( $robotsFile ) ){
		$robotsText = file_get_contents( $robotsFile );
	}else{
		$robotsText = '';
	}

	$this->addElement( 'textarea', 'robots_text', array(
		'label' => 'Содержимое файла Robots.txt',
		'rows' => '10',
		'value' => $robotsText,
		'description' => 'Файл настроек для поисковых роботов'
	));

	$this->addDisplayGroup( 
		array( 'robots_text' ), 
		'robots', 
		array('description' => 'Файл Robots.txt' )
	);
    }
}

?>
