<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля статей
 * 
 * @category   Xcms
 * @package    Articles
 * @subpackage Controller
 * @version    $Id:   $
 */

class Articles_BackController extends Xcms_Controller_Back {
	
	/**
	 * Дочерние элементы структуры
	 * @return void
	 */
	public function getAction() {
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('articles', 'category');
		if ( isset($type) ) {
			$cat_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных лент статей не существует' );
		}
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('articles', 'item');
		if ( isset($type) ) {
			$item_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных статей не существует' );
		}
                $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
                $options = $bootstraps['articles']->getModuleOptions();
                $actions = $options['actions'];
                $category_id = ( int ) $this->getRequest ()->getParam ( 'category' );
		$mce = Model_Collection_Elements::getInstance ();
		//$categories = $mce->getChildren ( 0, 1, $cat_type_id );
                $categories = $mce->getChildren ( $category_id, 2, $cat_type_id );
		$data = array();
		foreach ( $categories as $k => $have ) {
			$category = $mce->getElement ( $k );
			$categoryClass = $category->getType()->getElementClass();
			/*if ( ! $category->isReadable() ) continue;
			$news_data = array();
			$news = $mce->getChildren ( $k, 1 );
			foreach ( $news as $k => $news_item ) {
				$items = $mce->getElement ( $k );
				$itemsClass = $items->getType()->getElementClass();
				if ( ! $items->isReadable() ) continue;
				$news_data[] = array(
					'id' => $items->id,
					'title' => $items->getObject()->title,
					'expandable' => false,
                                        'controller' => 'articles',
					'elementClass' => $itemsClass,
                                        'element'=> 'item',
					'accept' => ''
				);
			}*/
                        $count_items = count($mce->getChildren ( $k, 1));
			if( $count_items > 0 )
				$expandable = true;
			else
				$expandable = ! empty ( $have );
			$data[] = array (
				'id' => $category->id,
				'title' => $category->getObject()->title,
			//	'fields' => $news_data,
				//'count' => count( $news ),
                                'expandable' => $expandable,
                                'controller' => 'articles',
                                'element' => 'category',
				'elementClass' => $categoryClass,
				'accept' => '.articles_item',
                                'actions' => $actions['category']
			);
		}
                $articles_items = $mce->getChildren ( $category_id, 1, $item_type_id );
                foreach ( $articles_items as $k => $news_item ) {
				$items = $mce->getElement ( $k );
				$itemsClass = $items->getType()->getElementClass();
				if ( ! $items->isReadable() ) continue;
				$data[] = array(
					'id' => $items->id,
					'title' => $items->getObject()->title,
					'expandable' => false,
                                        'controller' => 'articles',
					'elementClass' => $itemsClass,
                                        'element'=> 'item',
					'accept' => '',
                                        'actions' => $actions['item']
				);
			}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * редактировать ленту   /admin/articles/edit/category/5
	 * редакт. статью       /admin/articles/edit/category/5/item/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset ( $category_id ) ) {
			if ( $category_id == 'new' ) {
				//создание ленты статей
				$type_cat = Model_Collection_ElementTypes::getInstance()->getModuleElementType('articles', 'category');
				if ( isset($type_cat) ) {
					$type_cat_id = $type_cat->id;
				} else {
					throw new Exception( 'Тип данных лент статей не существует' );
				}
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( 0, $type_cat_id );
			}else{
				// Получить ленту статей
				$complex_id = $category_id = (int) $category_id;
				if ( $category_id > 0 ) {
					$element = Model_Collection_Elements::getInstance()->getElement( $category_id );
					$item_id = $this->getRequest()->getParam ( 'item' );
					if ( isset( $item_id ) ) {
						if ( $item_id == 'new' ) {
							// Создание статьи
							$type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('articles', 'item');
							if ( isset($type_item) ) {
								$type_item_id = $type_item->id;
							} else {
								throw new Exception( 'Тип данных статьи не существует' );
							}
							if ( $element->id_type == $type_item_id ) { // подновостей
								$category_id = $element->id_parent; // небывает
							}		
							$element = Model_Collection_Elements::getInstance ()
								->createElement ( $category_id, $type_item_id );
						}else{
							// Получение статей
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
						throw new Exception( 'Неправильный идентификатор ленты новостей' );
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
		$data ['form'] = $form->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания элемента (перенаправление на edit)
	 * @return void
	 * создать ленту         /admin/articles/new/category/0
	 * создать статью       /admin/articles/new/category/5/item/add
	 */
	public function newAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			$item_id = $this->getRequest ()->getParam ( 'item' );
			if ( isset( $item_id ) ) {
				// создание статьи
				$this->getRequest ()->setParam ( 'item', 'new' );
			} else {
				// создание ленты статей
				$this->getRequest ()->setParam ( 'category', 'new' );
			}
		}
		$this->_forward( 'edit' );
	}
	
        
        public function newitemAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			// создание элемента каталога
			$this->getRequest ()->setParam ( 'item', 'new' );
		}
		$this->_forward( 'edit' );
	}
        
	/**
	 * Перемещение элемента с заданным id
	 * @return void
	 */
	public function moveAction() {
		$this->_forward('move', 'back', 'content');
	}
	
	/**
	 * Удаление элемента в корзину с заданным id
	 * @return void
	 */
	public function deleteAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if( isset( $category_id ) ){
			$category_id = (int) $category_id;
			if( $category_id > 0 ){
				$item_id = $this->getRequest ()->getParam ( 'item' );
				if( isset( $item_id ) ){
					$item_id = (int) $item_id;
					if( $item_id > 0 ){
						// удаление статьи
						$success = Model_Collection_Elements::getInstance () ->delElement( $item_id );
						if (! $success and (APPLICATION_ENV != 'production'))
							throw new Exception ( 'Ошибка при удалении статьи' );
						}
				}else{
					// удаление ленты статей
					$success = Model_Collection_Elements::getInstance () 
						->delElement ( $category_id );
					if (! $success and (APPLICATION_ENV != 'production'))
						throw new Exception ( 'Ошибка при удалении ленты статей' );
				}
			}
		}
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
}