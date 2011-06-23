<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля галерея
 * 
 * @category   Xcms
 * @package    Gallery
 * @subpackage Controller
 * @version    $Id:
 */
class Gallery_BackController extends Xcms_Controller_Back {
	
	/**
	 * Дочерние элементы структуры
	 * @return void
	 */
	public function getAction() {
		$category_id = ( int ) $this->getRequest ()->getParam ( 'category' );
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('gallery', 'category');
		if ( isset($type) ) {
			$cat_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных категория галереи не существует' );
		}
		$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('gallery', 'item');
		if ( isset($type) ) {
			$item_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных элемент галереи не существует' );
		}
		
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
	    $options = $bootstraps['gallery']->getModuleOptions();
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
				'controller' => 'gallery',
				'element' => 'category',
				'actions' => $actions['category']
			);
		}
		$categories_items = $mce->getChildren ( $category_id, 1, $item_type_id );
		foreach ( $categories_items as $k => $catalog_item ) {
			$items = $mce->getElement ( $k );
			$itemsClass = $items->getType()->getElementClass();
			if ( ! $items->isReadable() ) continue;
			if($itemsClass == 'gallery_category') {
				$element = 'category';
				$id = $items->id;
			} else {
				$element = 'item';
				$id = $items->id;
			}
			$data[] = array(
				'id' => $id,
				'title' => $items->getObject()->title,
				'expandable' => false,
				'elementClass' => $itemsClass,
				'controller' => 'gallery',
				'element' => $element,
				'actions' => $actions['item']
			);
		}
		// Записываем в тело ответа данные в формате JSON,
		// заголовки ответа устанавливаются плагином (см. Zend_View_Helper_Json)
		$this->getResponse()->setBody( $this->view->json( $data ) );

	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * редактировать категорию   /admin/gallery/edit/category/5
	 * редакт. товар       /admin/gallery/edit/category/5/item/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$parent_id = 0; // TODO Нужно продумать и переписать этот метод, когда будут изменены виджеты.
		$action = $this->getRequest ()->getParam ( 'act' );
		$category_id = $this->getRequest ()->getParam ( 'category' );
		$data = array();
		if ( isset ( $category_id ) ) {
			if ( $action == 'new' ) {
				$data['category_img'] = true;
				//создание категории
				$type_cat = Model_Collection_ElementTypes::getInstance()->getModuleElementType('gallery', 'category');
				if ( isset($type_cat) ) {
					$type_cat_id = $type_cat->id;
				} else {
					throw new Exception( 'Тип данных категория галереи не существует' );
				}
				$parent_id = (int) $this->getRequest ()->getParam ( 'parent' );
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( $parent_id, $type_cat_id );
			}else{
				// Получить категорию
				$complex_id = $category_id = (int) $category_id;
				if ( $category_id > 0 ) {
					$data['category_img'] = true;
					$element = Model_Collection_Elements::getInstance()->getElement( $category_id );
					$item_id = $this->getRequest()->getParam ( 'element' );
					if ( isset( $item_id ) ) {
						if ( $item_id == 'new' ) {
							$data['category_img'] = false;
							// Создание товара
							$type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('gallery', 'item');
							if ( isset($type_item) ) {
								$type_item_id = $type_item->id;
							} else {
								throw new Exception( 'Тип данных элемент галереи не существует' );
							}
							if ( $element->id_type == $type_item_id ) { // подкаталога
								$category_id = $element->id_parent; // небывает
							}		
							$element = Model_Collection_Elements::getInstance ()
								->createElement ( $category_id, $type_item_id );
						}else{
							$data['category_img'] = false;
							// Получение элемента каталога
							$item_id = (int) $item_id;
							if ( $item_id > 0 ) {
								$element = Model_Collection_Elements::getInstance()
									->getElement ( $item_id );
							} else {
								if ( APPLICATION_ENV != 'production' )
									throw new Exception( 'Неправильный идентификатор элемента');
							}
						}
					}else{
						
					}
				}else{
					if ( APPLICATION_ENV != 'production' )
						throw new Exception( 'Неправильный идентификатор каталога категорий' );
				}
			}
		}
		if (! isset ( $element )) {
			throw new Exception ( 'Нет элемента' );
		}
		$writable = $element->isWritable();
		$form = $element->getEditForm(!$writable);
		$request = $this->getRequest();
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
	 * создать категорию         /admin/gallery/new/category/0
	 * создать элемент каталога  /admin/gallery/new/category/5/item/add
	 */
	public function newAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			// создание категории
			$this->getRequest()->setParam( 'parent', $category_id  );
			$this->getRequest ()->setParam ( 'act', 'new' );
		}
		$this->_forward( 'edit' );
	}
	
	/**
	 * Страница создания элемента категории (перенаправление на edit)
	 * @return void
	 * создать категорию         /admin/gallery/new/category/0
	 */
	public function newitemAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		$this->getRequest()->setParam( 'category', $category_id  );
		$this->getRequest()->setParam( 'element', 'new'  );
		$this->getRequest ()->setParam ( 'act', 'newitem' );
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
	 * Загрузка фотографий
	 * @return string
	 */
	public function  uploadAction(){
		//$cat =  $this->getRequest()->getParam('cat');
		$config = array();
		$reg = Zend_Registry::getInstance();
		
		// Переменная $cat иногда теряется в новой админке. Хотя что уж там - ни разу нормально не пришла. Будем делать без неё.
		/*if( $cat === 'true' ){
				$config = array("kategory" => array( "size"=>$reg->get( 'gallery_kategory_size' ), "quality"=>80, "square" => $reg->get( 'gallery_square_kategory' )));
			}else/**/

		$config = array(
			"big" => array( "size"=>$reg->get( 'gallery_big_size' ), "quality"=>100, "square" => $reg->get( 'gallery_square_big' )),
			"medium" => array( "size"=>$reg->get( 'gallery_medium_size' ), "quality"=>80, "square" => $reg->get( 'gallery_square_medium' )),
			"small" => array( "size"=>$reg->get( 'gallery_small_size' ), "quality"=>80, "square" => $reg->get( 'gallery_square_small' )),
			"kategory" => array( "size"=>$reg->get( 'gallery_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' )),
			"backend" => array( "size"=>75, "square"=>true ), // картинка для админки
		);
		$Image = new Model_Image('public/gallery/', $config);
		$img = $Image->LoadImages('userfile');
		if($img!=false)
			$this->getResponse()->setBody( 'gallery/backend/'.$img );
		else
			$this->getResponse()->setBody( "error" );
	}
	
	/**
	 * Удаление элемента в корзину с заданным id
	 * @return void
	 */
	public function deleteAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		$item_id = $this->getRequest ()->getParam ( 'item' );
		if(isset($category_id)) {
			$category_id = (int) $category_id;
			if( $category_id > 0 ) {
				$success = Model_Collection_Elements::getInstance () 
					->delElement ( $category_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении категории галереи' );
			}
		} elseif($item_id) {
			$item_id = (int) $item_id;
			if( $item_id > 0 ) {
				$success = Model_Collection_Elements::getInstance ()->delElement( $item_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении элемента' );
			}
		}
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
}