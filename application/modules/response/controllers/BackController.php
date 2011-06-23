<?php
/**
 * 
 * "Асинхронный" контроллер для управления настройками
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Controller
 * @version    $Id: $
 */

class Response_BackController extends Xcms_Controller_Back {
	
	/**
	 * Установленные модули
	 * @return void
	 */
	public function getAction() {
		$status =  $this->getRequest ()->getParam ( 'status' );
		$data = array();
		if( !isset( $status ) ){
			$form = new Response_Form_Edit();
			$data['form'] = $form->render();
		}else if( $status == 'active' || $status == 'unactive' ){
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('response', 'category');
			if ( isset($type) ) {
				$cat_type_id = $type->id;
			} else {
				throw new Exception( 'Тип данных лента отзывов не существует' );
			}
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('response', 'item');
			if ( isset($type) ) {
				$item_type_id = $type->id;
			} else {
				throw new Exception( 'Тип данных отзывы не существует' );
			}
			$mce = Model_Collection_Elements::getInstance ();
				$categories = $mce->getChildren ( 0, 1, $cat_type_id );
			foreach ( $categories as $k => $have ) {
				$category = $mce->getElement ( $k );
				$categoryClass = $category->getType()->getElementClass();
				if ( ! $category->isReadable() ) continue;
				$news_data = array();
				if( $status == 'active' )
					$news = $mce->getChildren ( $k, 1, $item_type_id, false );
				else
					$news = $mce->getChildren ( $k, 1, $item_type_id, true, false );
				foreach ( $news as $k => $news_item ) {
					$items = $mce->getElement ( $k );
					$itemsClass = $items->getType()->getElementClass();
					if ( ! $items->isReadable() ) continue;
					$news_data[] = array(
						'id' => array( $category->id, $items->id ),
						'title' => $items->getObject()->title,
						'expandable' => false,
						'elementClass' => $itemsClass,
						'accept' => ''
					);
				}
				$data[] = array (
					'id' => $category->id,
					'title' => $category->getObject()->title,
					'fields' => $news_data,
					'count' => count( $news ),
					'elementClass' => $categoryClass,
					'accept' => '.news_item'
				);
			}
		}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * редактировать ленту   /admin/response/edit/category/5
	 * редакт. отзыв       /admin/response/edit/category/5/item/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset ( $category_id ) ) {
			if ( $category_id == 'new' ) {
				//создание ленты новостей
				$type_cat = Model_Collection_ElementTypes::getInstance()->getModuleElementType('news', 'category');
				if ( isset($type_cat) ) {
					$type_cat_id = $type_cat->id;
					$max = (int) Zend_Registry::get('news')->maxcats;
					if ( !empty($max) ) {
						$total = Model_Collection_Elements::getInstance()->countElementsByType($type_cat_id);
						if ( $total >= $max )
							throw new Exception ( 'Превышено максимальное разрешенное количество лент новостей' );
					}
				} else {
					throw new Exception( 'Тип данных лент новостей не существует' );
				}
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( 0, $type_cat_id );
			}else{
				// Получить ленту отзывов
				$complex_id = $category_id = (int) $category_id;
				if ( $category_id > 0 ) {
					$element = Model_Collection_Elements::getInstance()->getElement( $category_id );
					$item_id = $this->getRequest()->getParam ( 'item' );
					if ( isset( $item_id ) ) {
						if ( $item_id == 'new' ) {
							// Создание отзыва
							$type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('response', 'item');
							if ( isset($type_item) ) {
								$type_item_id = $type_item->id;
							} else {
								throw new Exception( 'Тип данных отзыв не существует' );
							}
							if ( $element->id_type == $type_item_id ) { // под отзывов
								$category_id = $element->id_parent; // небывает
							}		
							$element = Model_Collection_Elements::getInstance ()
								->createElement ( $category_id, $type_item_id );
						}else{
							// Получение отзыва
							$item_id = (int) $item_id;
							if ( $item_id > 0 ) {
								$element = Model_Collection_Elements::getInstance()
									->getElement ( $item_id );
							} else {
								if ( APPLICATION_ENV != 'production' )
									throw new Exception( 'Неправильный идентификатор элемента');
							}
						}
					}
				}else{
					if ( APPLICATION_ENV != 'production' )
						throw new Exception( 'Неправильный идентификатор ленты отзывов' );
				}
			}
		}
		if (! isset ( $element )) {
			throw new Exception ( 'Нет элемента' );
		}
		$writable = $element->isWritable();
		$form = $element->getEditForm(!$writable);
		$request = $this->getRequest();
		$data = array();
		if ( $writable and $this->getRequest()->isPost() ) {
			if ( $form->isValid( $request->getPost() ) ) {
				$element->setValues( $form->getValues() );
				$element->commit();
				$form = $element->getEditForm ();
				$data = array (
					'id' => $element->id,
					'parent_id' => $element->id_parent,
					'title' => $element->getObject()->title
				);
				if ( $category_id == 'new' ) {
					$data['expandable'] = false;
				}
			} else {
				$this->setIsErrors( $form );
			}
		}
		$data ['form'] = ( string ) $form;
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания элемента (перенаправление на edit)
	 * @return void
	 * создать ленту         /admin/response/new/category/0
	 * создать отзыв       /admin/response/new/category/5/item/add
	 */
	public function newAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			$item_id = $this->getRequest ()->getParam ( 'item' );
			if ( isset( $item_id ) ) {
				// создание новости
				$this->getRequest ()->setParam ( 'item', 'new' );
			} else {
				// создание ленты новостей
				$this->getRequest ()->setParam ( 'category', 'new' );
			}
		}
		$this->_forward( 'edit' );
	}
	
	/**
	 * Загрузка фотографий
	 * @return string
	 */
	public function  uploadAction(){
		$cat =  $this->getRequest()->getParam('cat');
		$Image = new Model_Image($cat, 'public/catalog/', false);
		$image = $Image->LoadImages('userfile', false);
		if($image!=false){
			$this->getResponse()->setBody( $image );
		}
		else
			$this->getResponse()->setBody( "error" );
	}
}