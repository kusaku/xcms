<?php
/**
 * 
 * Контроллер лент акций
 * 
 * @category   Xcms
 * @package    Offers
 * @subpackage Controller
 * @version    $Id: CategoryController.php 254 2010-12-07 13:37:54Z igor $
 */

class Offers_CategoryController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$this->setDataFrom( $this->getRequest()->getParam('id') );
		$category_id = $this->view->element->id;
		$type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('offers', 'item');
		if ( isset($type) ) {
			$type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных акции не существует' );
		}
		$category = Model_Collection_Elements::getInstance()->getElement( $category_id );
		$children = $category->getChildren( $type_id, 'publish_date_from DESC' );
		$items = array();
		$container = new Zend_Navigation();
		foreach ( $children as $k => $have ) {
			$element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
			$container->addPage( $element->getPage()
				->set('items', $element->getValues())
			);
		}
		$item_count = (int) Zend_Registry::getInstance()->get('offers_items_count');
		if( $item_count <= 0 )
			$item_count = 10;
		$paginator = Zend_Paginator::factory( $container );
		$paginator->setItemCountPerPage($item_count);
		$paginator->setCurrentPageNumber( intval($this->getRequest()->getParam('page')) );
		$this->view->items = $paginator;
		$this->renderContent( 'category.phtml' );
	}
}
