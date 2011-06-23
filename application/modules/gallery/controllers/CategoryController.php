<?php
/**
 * 
 * Контроллер категорий галереи
 * 
 * @category   Xcms
 * @package    Gallery
 * @subpackage Controller
 * @version    $Id:
 */
class Gallery_CategoryController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$this->setDataFrom( $this->getRequest()->getParam('id') );
		$category_id = $this->view->element->id;
		$category = Model_Collection_Elements::getInstance()->getElement( $category_id );
		$template = $category->getValue('catalog_view');
		if( !$template )
			$template = 'fancybox.phtml';
		$cat_type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('gallery', 'category');
		if ( isset($cat_type) ) {
			$cat_type_id = $cat_type->id;
		} else {
			throw new Exception( 'Тип данных категория галереи не существует' );
		}
		$item_type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('gallery', 'item');
		if ( isset($item_type) ) {
			$item_type_id = $item_type->id;
		} else {
			throw new Exception( 'Тип данных элемент галереи не существует' );
		}
		/* Категории */
		$children_category = $category->getChildren( $cat_type_id );
		$cat = array();
		$catitem = array();
		$cat_container = new Zend_Navigation();
		$cat_item_container = new Zend_Navigation();
		foreach ( $children_category as $k => $have ) {
			$element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
			$page = $element->getPage();
			/* Добавить подкатегории к контейнеру с категориями */
			$sub_children = $element->getChildren( $cat_type_id );
			foreach ( $sub_children as $k => $have ) {
				$sub_element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
				$page->addPage($sub_element->getPage()
					->set('items', $sub_element->getValues()));
			}
			$cat_container->addPage( $page 
				->set('items', $element->getValues())
			);
			/* Формирование контейнера с категорией и изображения ее */
			$page_item = $element->getPage();
			$sub_item_children = $element->getChildren( $item_type_id );	
			foreach ( $sub_item_children as $k => $have ) {
				$sub_item = Model_Collection_Elements::getInstance()
				->getElement ( $k );
				$page_item->addPage($sub_item->getPage()
					->set('items', $sub_item->getValues()));
			}
			$cat_item_container->addPage( $page_item
				->set('items', $element->getValues()) );
		}
		$this->view->cat = $cat_container;
		$this->view->catitem = $cat_item_container;
		
		$children_item = $category->getChildren( $item_type_id );
		$items = array();
		$item_container = new Zend_Navigation();
		foreach ( $children_item as $k => $have ) {
			$element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
			
			$item_container->addPage( $element->getPage()
				->set('items', $element->getValues()));
		}
		$item_count = (int) Zend_Registry::getInstance()->get('gallery_items_count');
		if( $item_count <= 0 )
			$item_count = 10;
		$paginator = Zend_Paginator::factory( $item_container );
		$paginator->setItemCountPerPage($item_count);
		$paginator->setCurrentPageNumber( intval($this->getRequest()->getParam('page')) );
		$this->view->items = $paginator;
		$this->renderContent( $template );
	}
}