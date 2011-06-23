<?php
/**
 * 
 * Форма настроек
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Form
 * @version    $Id: Edit.php 629 2011-02-09 10:18:59Z kifirch $
 */

class Admin_Form_Config_Edit extends Admin_Form_Edit 
{
	public function init() 
	{
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
		$this->addDisplayGroup( 
			array( 'site_name', 'site_description', 'site_keywords', 'use_urlnames' ), 
			'global', 
			array('description' => 'Глобальные настройки' )
		);
		$this->addDisplayGroupButtons( 'global', 'edit' );
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
		$this->addDisplayGroupButtons( 'artic', 'edit' );
		
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
		$this->addDisplayGroupButtons( 'robots', 'edit' );
		
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('catalog', 'back');
		if ( isset($type) ) {
			// Настройки Каталога (catalog)
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
			$catalog_items_count = $reg->get( 'catalog_items_count' );
			$this->addElement( 'text', 'catalog_items_count', array(
				'label' => 'Элементов на странице',
				'value' => $catalog_items_count,
				'validators' => array( array( 'Int' ) ),
				'description' => 'Максимальное количество элементов, выводимых в списке на одной странице'
			));
			$this->addDisplayGroup( 
				array( 'catalog_big_size', 'square_big_active', 'catalog_medium_size', 'square_medium_active', 'catalog_small_size', 'square_small_active', 'catalog_kategory_size', 'square_kategory_active', 'catalog_items_count' ), 
				'catalog', 
				array('description' => 'Настройки каталога' )
			);
			$this->addDisplayGroupButtons( 'catalog', 'edit' );
		}
		$type_news = Model_Collection_ElementTypes::getInstance()->getModuleElementType('news', 'back');
		if ( isset($type_news) ) {
			$news_items_count = $reg->get( 'news_items_count' );
			$this->addElement( 'text', 'news_items_count', array(
				'label' => 'Новостей на странице',
				'value' => $news_items_count,
				'size' => '100',
				'description' => 'Максимальный количество новостей на странице'
			));
			$this->addDisplayGroup( 
				array( 'news_items_count' ), 
				'news', 
				array('description' => 'Настройки новостей' )
			);
			$this->addDisplayGroupButtons( 'news', 'edit' );
		}
		$type_news = Model_Collection_ElementTypes::getInstance()->getModuleElementType('articles', 'back');
		if ( isset($type_news) ) {
			$articles_items_count = $reg->get( 'articles_items_count' );
			$this->addElement( 'text', 'articles_items_count', array(
				'label' => 'Статей на странице',
				'value' => $articles_items_count,
				'size' => '100',
				'description' => 'Максимальный количество статей на странице'
			));
			$this->addDisplayGroup( 
				array( 'articles_items_count' ), 
				'articles', 
				array('description' => 'Настройки статей' )
			);
			$this->addDisplayGroupButtons( 'articles', 'edit' );
		}
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('gallery', 'back');
		if ( isset($type) ) {
			// Настройки Галереи (gallery)
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
				'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть выведены на странице с подробным описанием элемента галереи.'
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
				'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в списке элементов галереи.'
			));
			$gallery_square_small = $reg->get( 'gallery_square_small' );
			$this->addElement( 'checkbox', 'gallery_square_small', array(
				'label' => 'Миниатюры сделать квадратом',
				'value' => $gallery_square_small,
				'description' => 'Преобразовать загружаемые миниатюры элементов галереи в квадрат'
			));
			$gallery_kategory_size = $reg->get( 'gallery_kategory_size' );
			$this->addElement( 'text', 'gallery_kategory_size', array(
				'label' => 'Изображения категорий',
				'value' => $gallery_kategory_size,
				'validators' => array( array( 'Int' ) ),
				'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения для категорий галереи. '
			));
			$gallery_square_kategory = $reg->get( 'gallery_square_kategory' );
			$this->addElement( 'checkbox', 'gallery_square_kategory', array(
				'label' => 'Категории сделать квадратом',
				'value' => $gallery_square_kategory,
				'description' => 'Преобразовать загружаемые миниатюры категорий галереи в квадрат'
			));
			$gallery_items_count = $reg->get( 'gallery_items_count' );
			$this->addElement( 'text', 'gallery_items_count', array(
				'label' => 'Элементов на странице',
				'value' => $gallery_items_count,
				'validators' => array( array( 'Int' ) ),
				'description' => 'Максимальное количество элементов, выводимых в списке на одной странице'
			));
			$this->addDisplayGroup( 
				array( 'gallery_big_size', 'gallery_square_big', 'gallery_medium_size', 'gallery_square_medium', 'gallery_small_size', 'gallery_square_small', 'gallery_kategory_size', 'gallery_square_kategory', 'gallery_items_count' ), 
				'gallery', 
				array('description' => 'Настройки галереи' )
			);
			$this->addDisplayGroupButtons( 'gallery', 'edit' );
		}
		$type_bulletin = Model_Collection_ElementTypes::getInstance()->getModuleElementType('bulletin', 'back');
		if ( isset($type_bulletin) ) {
			$bulletin_items_count = $reg->get( 'bulletin_items_count' );
			$this->addElement( 'text', 'bulletin_items_count', array(
				'label' => 'Объявлений на странице',
				'value' => $bulletin_items_count,
				'size' => '100',
				'description' => 'Максимальный количество объявлений на странице'
			));
			$bulletin_captcha = $reg->get( 'bulletin_captcha' );
			$this->addElement( 'checkbox', 'bulletin_captcha', array(
				'label' => 'Включить captcha',
				'value' => $bulletin_captcha,
				'description' => 'Включить captcha'
			));
			$this->addDisplayGroup( 
				array( 'bulletin_items_count', 'bulletin_captcha' ), 
				'bulletin', 
				array('description' => 'Настройки объявлений' )
			);
			$this->addDisplayGroupButtons( 'bulletin', 'edit' );
		}
		$type_faq = Model_Collection_ElementTypes::getInstance()->getModuleElementType('faq', 'back');
		if ( isset($type_faq) ) {
			$faq_items_count = $reg->get( 'faq_items_count' );
			$this->addElement( 'text', 'faq_items_count', array(
				'label' => 'Вопросов на странице',
				'value' => $faq_items_count,
				'size' => '100',
				'description' => 'Максимальный количество вопросов на странице'
			));
			$faq_captcha = $reg->get( 'faq_captcha' );
			$this->addElement( 'checkbox', 'faq_captcha', array(
				'label' => 'Включить captcha',
				'value' => $faq_captcha,
				'description' => 'Включить captcha'
			));
			$this->addDisplayGroup( 
				array( 'faq_items_count', 'faq_captcha' ), 
				'faq', 
				array('description' => 'Настройки ЧаВо' )
			);
			$this->addDisplayGroupButtons( 'faq', 'edit' );
		}
		
		/* Найтройки спецпредложений */
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('offers', 'back');
		if ( isset($type) ) {
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
				'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть выведены на странице с подробным описанием элемента.'
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
				'description' => 'Размер по ширине в пикселах, до которого будут пропорционально уменьшены загружаемые изображения. В таком размере изображения могут быть показаны в списке элементов.'
			));
			$offers_square_small = $reg->get( 'offers_square_small' );
			$this->addElement( 'checkbox', 'offers_square_small', array(
				'label' => 'Миниатюры сделать квадратом',
				'value' => $offers_square_small,
				'description' => 'Преобразовать загружаемые миниатюры элементов в квадрат'
			));
			$offers_items_count = $reg->get( 'offers_items_count' );
			$this->addElement( 'text', 'offers_items_count', array(
				'label' => 'Элементов на странице',
				'value' => $offers_items_count,
				'validators' => array( array( 'Int' ) ),
				'description' => 'Максимальное количество элементов, выводимых в списке на одной странице'
			));
			$this->addDisplayGroup( 
				array( 'offers_big_size', 'offers_square_big', 'offers_medium_size', 'offers_square_medium', 'offers_small_size', 'offers_square_small', 'offers_items_count' ), 
				'offers', 
				array('description' => 'Настройки акций' )
			);
			$this->addDisplayGroupButtons( 'offers', 'edit' );
		}
                $type =  Model_Collection_ElementTypes::getInstance()->getModuleElementType('users', 'register');
                if( isset($type) ) {
                        $users_active_mode = $reg->get( 'users_active_mode' );
			$this->addElement( 'checkbox', 'users_active_mode', array(
				'label' => 'Регистрация без премодерации',
				'value' => $users_active_mode,
				'description' => 'Активировать пользователей при регистрации автоматически'
			));
                        $this->addDisplayGroup(
				array( 'users_active_mode'),
                                'users',
				array('description' => 'Настройки регистрации' )
			);
			$this->addDisplayGroupButtons( 'users', 'edit' );
                }
	}
}