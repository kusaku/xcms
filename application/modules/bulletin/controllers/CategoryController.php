<?php
/**
 * 
 * Контроллер Объявлений
 * 
 * @category   Xcms
 * @package    Bulletin
 * @subpackage Controller
 * @version    $Id:
 */
class Bulletin_CategoryController extends Xcms_Controller_Modulefront {
	
	/**
	 * Просмотр контента
	 * @return void
	 */
	public function viewAction() {
		$id = (int) $this->getRequest()->getParam('id');
		$this->setDataFrom( $id );
		$form = new Bulletin_Form_Send();
		$request = $this->getRequest();
		if ( $request->isPost() ) {
			if ( $form->isValid( $request->getPost() ) ) {
				$data = (object) $form->getValues();
				$type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('bulletin', 'item');
				if ( isset($type_item) ) {
					$type_item_id = $type_item->id;
				} else {
					throw new Exception( 'Тип данных объявления не существует' );
				}
				$data->name = 'Новое Объявление от '.$data->bulletin_name.', '.$data->bulletin_email;
				$data->publish = false;
				$element = Model_Collection_Elements::getInstance ()->createElement ( $id, $type_item_id );
				$element->setValues( $data );
				$element->commit();
				$this->view->sent = true;
			}
		}
		$this->view->form = $form;
		$category_id = $this->view->element->id;
		$category = Model_Collection_Elements::getInstance()->getElement( $category_id );
		$item_type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('bulletin', 'item');
		if ( isset($item_type) ) {
			$item_type_id = $item_type->id;
		} else {
			throw new Exception( 'Тип данных объявления не существует' );
		}
		$children = $category->getChildren( $item_type_id );
		$items = array();
		$item_container = new Zend_Navigation();
		foreach ( $children as $k => $have ) {
			$element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
			$item_container->addPage( $element->getPage()
				->set('items', $element->getValues() )
			);
		}
		$item_count = (int) Zend_Registry::getInstance()->get('bulletin_items_count');
		if( $item_count <= 0 )
			$item_count = 10;
		$paginator = Zend_Paginator::factory( $item_container );
		$paginator->setItemCountPerPage($item_count);
		$paginator->setCurrentPageNumber( intval($this->getRequest()->getParam('page')) );
		$this->view->items = $paginator;
		$this->renderContent( 'view.phtml' );
	}
}