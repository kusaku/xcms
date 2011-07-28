<?php
/**
 * 
 * Базовый класс контроллеров фронта модулей
 * 
 * @category   Xcms
 * @package    Xcms_Controller
 * @version    $Id: Modulefront.php 629 2011-02-09 10:18:59Z kifirch $
 */

abstract class Xcms_Controller_Modulefront extends Zend_Controller_Action {
	
        /**
	 * Инициализация
	 * @return void
	 */
	public function init() {
		$this->getResponse ()
			->setHeader ( 'Content-Type', 'text/html; charset=utf-8' );
		$view = $this->view;
		// Мета-теги
		$view->headMeta()
			->setHttpEquiv ( 'Content-Type', 'text/html; charset=utf-8' );
		// Стили
		$view->headLink()
			->appendStylesheet( '/cms/css/reset-min.css' )
			->appendStylesheet( '/cms/css/fonts-min.css' );
		// Defaults
		$reg = Zend_Registry::getInstance();
		$title = (string) $reg->get( 'site_name' );
		if ( ! empty( $title ) ) {
			$view->headTitle()->set( $title );
		}
		$view->headTitle()
			->setIndent( 2 )
			->setSeparator(' - ');
		$view->headMeta()
			->setIndent( 2 )
			->setName('keywords', (string) $reg->get( 'site_keywords' ) )
			->setName('description', (string) $reg->get( 'site_description' ) );
		$view->headLink()
			->setIndent( 2 );
		// Проверка версии браузера
		$reg = Zend_Registry::getInstance();
		if($reg->get('check_browser')) {
			$this->view->check_browser = true;
		}
		// Навигация
		$view->navigation( Model_Collection_Elements::getInstance()->getNavigation() );
		$view->navigation()->menu()->setIndent( 2 )->setMaxDepth(2);;
		$view->navigation()->breadcrumbs()->setIndent( 2 );
		$view->navigation()->setAcl( Main::getAcl() )->setRole( Main::getCurrentUserRole() );
	}
	
	/**
	 * Действие по умолчанию
	 * @return void
	 */
	public function indexAction() {
		$this->_forward( 'view' );
	}
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
            $this->setDataFrom( $this->getRequest()->getParam('id') );
            $element = Model_Collection_Elements::getInstance()->getEntity($this->view->element->id);
            $etype = Model_Collection_ElementTypes::getInstance()->getEntity($element->id_type);
            if($etype->module != 'content') {
                $this->_forward( 'alias', 'index', 'content', array('urlname'=>$this->view->element->urlname ) );
            } else {
                $this->renderContent();
            }
	}
	
	/**
	 * Рендерит основной контент, по возможности используя шаблоны из templates/модуль/
	 * @param string OPTIONAL $template_name имя шаблона, по умолчанию 'view.phtml'
	 * @return void
	 */
	public function renderContent( $template_name='view.phtml' ) {
		$module = $this->getRequest()->getModuleName();
		if ( !isset($template_name) ) $template_name = $this->getRequest()->getControllerName() . '.phtml';
		$relative = "$module/$template_name";
		if ( is_file( realpath($this->_helper->layout->getLayoutPath()).'/'.$relative ) ) {
			// шаблон контента существует
			$this->_helper->viewRenderer->setNoRender();
			$this->renderScript( $relative );
		} else {
			// авторендеринг
		}
	}
	
	/**
	 * Рендерит блок, по возможности используя шаблоны из templates/partials/
	 * @param string OPTIONAL $template_name имя шаблона
	 * @param mixed $data
	 * @return string
	 */
	public function partial( $template_name, $data ) {
		$module = $this->getRequest()->getModuleName();
		if ( is_file( realpath($this->_helper->layout->getLayoutPath()).'/partials/'.$template_name ) ) {
			// шаблон существует в temlates/partials/
			return $this->view->partial('partials/'.$template_name, $data);
		} else {
			return $this->view->partial($template_name, $module, $data);
		}
	}
	
	/**
	 * Возвращает данные страницы по идентификатору (проверка прав на элемент)
	 * @param int $id
	 * @return void
	 */
	protected function setDataFrom( $element_id ) {
		$mce = Model_Collection_Elements::getInstance();
		$element_id = ( int ) $element_id;
		if ( ! ( $data = $mce->getCache()->load( "Elements_Data_$element_id" ) ) ) {
			try {
				$element = empty( $element_id ) ? $mce->getDefault() : $mce->getElement( $element_id );
			} catch ( Exception $e ) {
				if (APPLICATION_ENV != 'production')
					throw new Exception( 'Элемент не существует' );
				else
					throw new Zend_Controller_Dispatcher_Exception( 'Элемент не существует' );
				$element = $mce->getDefault();
			}
                        
			if ( ! $element->isReadable() ) {
				$this->_forward( 'denied', 'error', 'default' );
			}
			$data = (object) $element->getValues();
			$data->template_name = $element->getTemplate()->filename;
			if ( empty( $data->title ) ) $data->title = Zend_Registry::get ('site_name');
			if ( empty( $data->title_text ) ) $data->title_text = $data->name;
			$mce->getCache()->save( $data, 'Edata'.$element_id, array('Elements', 'Element'.$element_id) );
		}
                //$this->_forward('alias', 'index', 'content',array('urlname'=>$data->urlname));
                $this->view->element = $data;
		$this->setTemplate( $data->template_name );
		$this->setMeta( $data->title, $data->meta_keywords, $data->meta_description );
	}



        /**
	 * Устанавливает шаблон
	 * @param string $template_name
	 * @return void
	 */
	protected function setTemplate( $template_name ) {
		if( ! empty( $template_name ) ){
			$this->getHelper( 'layout' )->setLayout( $template_name );
		}
	}
	
	/**
	 * Устанавливает TITLE, KEYWORDS, DESCRIPTION
	 * @param string $title
	 * @param string $keywords OPTIONAL
	 * @param string $description OPTIONAL
	 * @return void
	 */
	protected function setMeta( $title, $keywords=null, $description=null ) {
		if ( ! empty( $title ) ) {
			$this->view->headTitle()->set( $title );
		}
		if ( ! empty( $keywords ) ) {
			$this->view->headMeta()->setName('keywords', $keywords );
		}
		if ( ! empty( $description ) ) {
			$this->view->headMeta()->setName('description', $description );
		}
	}
}