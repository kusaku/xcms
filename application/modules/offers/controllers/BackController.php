<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля акции
 * 
 * @category   Xcms
 * @package    Offers
 * @subpackage Controller
 * @version    $Id:
 */

class Offers_BackController extends Xcms_Controller_Back {
	
	/**
	 * Дочерние элементы структуры
	 * @return void
	 */
	public function getAction() {
		$category_id = ( int ) $this->getRequest ()->getParam ( 'category' );
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('offers', 'category');
		if ( isset($type) ) {
			$cat_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных лент акций не существует' );
		}
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('offers', 'item');
		if ( isset($type) ) {
			$item_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных акции не существует' );
		}
		
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
	    $options = $bootstraps['offers']->getModuleOptions();
	    $actions = $options['actions'];
		
		$mce = Model_Collection_Elements::getInstance ();
		$categories = $mce->getChildren ( $category_id, 2, $cat_type_id );
		$data = array();
		foreach ( $categories as $k => $have ) {
			$category = $mce->getElement ( $k );
			$categoryClass = $category->getType()->getElementClass();
			if ( ! $category->isReadable() ) continue;
			$count_items = count($mce->getChildren ( $k, 1));
			if( $count_items > 0 )
				$expandable = true;
			else
				$expandable = ! empty ( $have );
			$data[] = array (
				'id' => $category->id,
				'title' => $category->getObject()->title,
				'expandable' => $expandable,
				'count' => count( $have ),
				'elementClass' => $categoryClass,
				'controller' => 'offers',
				'element' => 'category',
				'actions' => $actions['category']
			);
		}
		$news = $mce->getChildren ( $category_id, 1, $item_type_id );
		foreach ( $news as $k => $news_item ) {
			$items = $mce->getElement ( $k );
			$itemsClass = $items->getType()->getElementClass();
			if ( ! $items->isReadable() ) continue;
			$data[] = array(
				'id' => $items->id,
				'title' => $items->getObject()->title,
				'expandable' => false,
				'elementClass' => $itemsClass,
				'controller' => 'offers',
				'element' => 'item',
				'actions' => $actions['item']
			);
		}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * редактировать ленту   /admin/offers/edit/category/5
	 * редакт. акцию       /admin/offers/edit/category/5/element/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset ( $category_id ) ) {
			if ( $category_id == 'new' ) {
				$data['category_img'] = true;
				//создание ленты акций
				$type_cat = Model_Collection_ElementTypes::getInstance()->getModuleElementType('offers', 'category');
				if ( isset($type_cat) ) {
					$type_cat_id = $type_cat->id;
					$max = (int) Zend_Registry::get('offers')->maxcats;
					if ( !empty($max) ) {
						$total = Model_Collection_Elements::getInstance()->countElementsByType($type_cat_id);
						if ( $total >= $max )
							throw new Exception ( 'Превышено максимальное разрешенное количество лент акций' );
					}
				} else {
					throw new Exception( 'Тип данных лент акций не существует' );
				}
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( 0, $type_cat_id );
			}else{
				// Получить ленту акций
				$complex_id = $category_id = (int) $category_id;
				if ( $category_id > 0 ) {
					$data['category_img'] = true;
					$element = Model_Collection_Elements::getInstance()->getElement( $category_id );
					$item_id = $this->getRequest()->getParam ( 'element' );
					if ( isset( $item_id ) ) {
						if ( $item_id == 'new' ) {
							$data['category_img'] = false;
							// Создание акции
							$type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('offers', 'item');
							if ( isset($type_item) ) {
								$type_item_id = $type_item->id;
							} else {
								throw new Exception( 'Тип данных акции не существует' );
							}
							if ( $element->id_type == $type_item_id ) { // подакции
								$category_id = $element->id_parent; // небывает
							}		
							$element = Model_Collection_Elements::getInstance ()
								->createElement ( $category_id, $type_item_id );
						}else{
							$data['category_img'] = false;
							// Получение акции
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
						throw new Exception( 'Неправильный идентификатор ленты акции' );
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
					if ( !empty($max) ) {
						$total++;
						if ( $total >= $max )
							$data['createElement'] = false;
						else
							$data['createElement'] = true;
					}
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
	 * создать ленту         /admin/offers/new/category/0
	 * создать акцию       /admin/offers/new/category/5/element/add
	 */
	public function newAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			if ( $category_id > 0 ) {
				// создание акции
				$this->getRequest ()->setParam ( 'element', 'new' );
			} else {
				// создание ленты акций
				$this->getRequest ()->setParam ( 'category', 'new' );
			}
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
		$item_id = $this->getRequest ()->getParam ( 'item' );
		if( isset( $category_id ) ) {
			$category_id = (int) $category_id;
			if( $category_id > 0 ){
				// удаление ленты
				$success = Model_Collection_Elements::getInstance () 
					->delElement ( $category_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении ленты акций' );
			}
		} else {
			$item_id = (int) $item_id;
			if( $item_id > 0 ){
				// удаление акции
				$success = Model_Collection_Elements::getInstance () ->delElement( $item_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении акции' );
			}
		}
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
	
	/**
	 * Загрузка фотографий
	 * @return string
	 */
	public function  uploadAction(){
		$cat =  $this->getRequest()->getParam('cat');
		$config = array();
		$reg = Zend_Registry::getInstance();
		if( $cat === 'false' ){
			$config = array(
				"offers/big" => array( "size"=>$reg->get( 'offers_big_size' ), "quality"=>100, "square" => $reg->get( 'offers_square_big' )),
				"offers/medium" => array( "size"=>$reg->get( 'offers_medium_size' ), "quality"=>80, "square" => $reg->get( 'offers_square_medium' )),
				"offers/small" => array( "size"=>$reg->get( 'offers_small_size' ), "quality"=>80, "square" => $reg->get( 'offers_square_small' )),
				"offers/backend" => array( "size"=>75, "square" => true)
			);
		}
		$Image = new Model_Image('public/offers/', $config);
		$img = $Image->LoadImages('userfile');
		if($img!=false)
			$this->getResponse()->setBody( 'offers/backend/'.$img );
		else
			$this->getResponse()->setBody( "error" );
	}
	
	public function getoptionsAction() {
	    $form = new Offers_Form_Options();
	    $data['form'] = $form->render();
	    $this->getResponse()->setBody( $this->view->json( $data ) );
	}
}