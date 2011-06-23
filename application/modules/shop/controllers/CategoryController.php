<?php
/**
 * 
 * Контроллер категорий каталога
 * 
 * @category   Xcms
 * @package    Catalog
 * @subpackage Controller
 * @version    $Id:
 */
class Shop_CategoryController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$this->setDataFrom( $this->getRequest()->getParam('id') );
		$category_id = $this->view->element->id;
		$category = Model_Collection_Elements::getInstance()->getElement( $category_id );
		$template = $category->getValue('shop_category_view');
		if( !$template )
			$template = 'category.phtml';
		$cat_type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('shop', 'category');
		if ( isset($cat_type) ) {
			$cat_type_id = $cat_type->id;
		} else {
			throw new Exception( 'Тип данных категория каталога не существует' );
		}
		$item_type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('shop', 'item');
		if ( isset($item_type) ) {
			$item_type_id = $item_type->id;
		} else {
			throw new Exception( 'Тип данных элемент каталога не существует' );
		}
		/* Категории */
		$children_category = $category->getChildren( $cat_type_id );
		$cat = array();
		$catitem = array();
		$cat_container = new Zend_Navigation(); // Контейнер для хранения категорий
		$cat_item_container = new Zend_Navigation();// Контейнер для хранения категорий и их товаров
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
			/* Формирование контейнера с категорией и товаром ее */
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
		
		/* Товары */
		$children_item = $category->getChildren( $item_type_id );
		$items = array();
		$item_container = new Zend_Navigation();
		foreach ( $children_item as $k => $have ) {
			$element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
			
			$item_container->addPage( $element->getPage()
				->set('items', $element->getValues()));
		}
		$item_count = (int) Zend_Registry::getInstance()->get('catalog_items_count');
		if( $item_count <= 0 )
			$item_count = 10;
		$paginator = Zend_Paginator::factory( $item_container );
		$paginator->setItemCountPerPage($item_count);
		$paginator->setCurrentPageNumber( intval($this->getRequest()->getParam('page')) );
		$this->view->items = $paginator;
		$this->renderContent( $template );
	}

        public function addToOrder($params) {
            $session = $this->getSession();
            if(! isset($params['count'])) {
                $count = 1;
            } else {
                $count = $params['count'];
            }
            $id = $params['id'];
            $element = Model_Collection_Elements::getInstance()->getElement($id);
            $vals = (object)$element->getValues();
            if(! isset( $session->items[$id] ) ) {
                $session->items[$id] = array('price'=>$vals->shop_item_price, 'count'=>$count, 'name'=>$vals->name, 'href'=>$element->getPage()->getHref(), 'values'=>$vals );
            } else {
                $session->items[$id]['count']+=$count;
            }
            $session->orderSum += $vals->shop_item_price*$count;
        }
}