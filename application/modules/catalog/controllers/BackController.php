<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля каталога
 * 
 * @category   Xcms
 * @package    Catalog
 * @subpackage Controller
 * @version    $Id:
 */

class Catalog_BackController extends Xcms_Controller_Back {
	
    
        protected  $actions = array(
                    'category'=>array(
                            'edit' => 'Редактировать',
                            'newsub'   => 'Создать категорию',
                            'newitem'    => 'Создать товар',
                            'delete' => 'Удалить',
                    ),
                    'item'=>array('edit'=>'Редактировать товар')
                );


    /**
	 * Дочерние элементы структуры
	 * @return void
	 */
	public function getAction() {
		$category_id = ( int ) $this->getRequest ()->getParam ( 'category' );
		$c_type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'category');
		if ( isset($c_type) ) {
			$cat_type_id = $c_type->id;
		} else {
			throw new Exception( 'Тип данных каталог категорий не существует' );
		}
		$i_type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'item');
		if ( isset($i_type) ) {
			$item_type_id = $i_type->id;
		} else {
			throw new Exception( 'Тип данных элемент каталога не существует' );
		}
		$mce = Model_Collection_Elements::getInstance ();
                
		$categories = $mce->getChildren ( $category_id, 2, $cat_type_id );
        $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
        $options = $bootstraps['catalog']->getModuleOptions();
        $actions = $options['actions'];
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
                'controller' => 'catalog',
                'element' => 'category',
				'elementClass' => $categoryClass,
                'actions'=>$actions['category']
				//'accept' => '.catalog_item, .catalog_category'
			);
		}
		$categories_items = $mce->getChildren ( $category_id, 1, $item_type_id );
		foreach ( $categories_items as $k => $catalog_item ) {
				$items = $mce->getElement ( $k );
				$itemsClass = $items->getType()->getElementClass();
				if ( ! $items->isReadable() ) continue;
				if($itemsClass == 'catalog_category') {
					$id= $items->id;
                                        $class = 'category';
                                }
				else{
                                    $class = 'item';
                                }
					//$id = array( $category_id, $items->id );
				$data[] = array(
					'id' => $items->id,
					'title' => $items->getObject()->title,
					'expandable' => false,
					'elementClass' => $itemsClass,
                                        'controller' => 'catalog',
                                        'element' => $class,
                                        'actions'=>$actions[$class],
					'accept' => ''
				);
			}

		$this->getResponse()->setBody( $this->view->json( $data ) );

	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * редактировать категорию   /admin/catalog/edit/category/5
	 * редакт. товар       /admin/catalog/edit/category/5/item/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$parent_id = 0; // TODO Нужно продумать и переписать этот метод, когда будут изменены виджеты.
		$action = $this->getRequest ()->getParam ( 'act' );
		$category_id = $this->getRequest ()->getParam ( 'category' );
                //if(!isset ($category_id)) $category_id = $this->getRequest ()->getParam ( 'element' );
		$data = array();
		if ( isset ( $category_id ) ) {
			if ( $action == 'new' ) {
				$data['category_img'] = true;
				//создание категории
				$type_cat = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'category');
				if ( isset($type_cat) ) {
					$type_cat_id = $type_cat->id;
				} else {
					throw new Exception( 'Тип данных каталог категорий не существует' );
				}
				$parent_id = (int) $this->getRequest ()->getParam ( 'parent' );
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( $parent_id, $type_cat_id, 'Новая категория' );
			}else{
				// Получить категорию
				$complex_id = $category_id = (int) $category_id;
				if ( $category_id > 0 ) {
                                    $data['category_img'] = true;
                                    $element = Model_Collection_Elements::getInstance()->getElement( $category_id );
                                }
                                $item_id = $this->getRequest()->getParam ( 'item' );
                                if ( $item_id == 'new' ) {
                                    $data['category_img'] = false;
                                    // Создание товара
                                    $type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'item');
                                    if ( isset($type_item) ) {
                                            $type_item_id = $type_item->id;
                                    } else {
                                            throw new Exception( 'Тип данных элемент каталога не существует' );
                                    }
                                    if ( $element->id_type == $type_item_id ) { // 
                                            $category_id = $element->id_parent; // небывает
                                    }		
                                    $element = Model_Collection_Elements::getInstance ()
                                            ->createElement ( $category_id, $type_item_id, 'Новый товар' );
                                }
                        }
                }else {
                    $item_id = $this->getRequest()->getParam ( 'item' );
                    if ( isset( $item_id ) ) {
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
                    }else{
                        if ( APPLICATION_ENV != 'production' )
                            throw new Exception( 'Неправильный идентификатор каталога категорий' );
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
		$data ['form'] = $form->render();;
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания элемента (перенаправление на edit)
	 * @return void
	 * создать категорию         /admin/catalog/new/category/0
	 * создать элемент каталога  /admin/catalog/new/category/5/item/add
	 */
	public function newAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			$item_id = $this->getRequest ()->getParam ( 'element' );
			if ( isset( $item_id ) ) {
				// создание элемента каталога
				$this->getRequest ()->setParam ( 'element', 'new' );
			} else {
				// создание категории
				$this->getRequest()->setParam( 'parent', $category_id  );
				$this->getRequest ()->setParam ( 'act', 'new' );
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
	 * Страница создания элемента категории (перенаправление на edit)
	 * @return void
	 * создать категорию         /admin/catalog/new/category/0
	 */
	public function newcategoryAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		$this->getRequest()->setParam( 'parent', $category_id  );
		$this->getRequest ()->setParam ( 'act', 'new' );
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
		$cat =  $this->getRequest()->getParam('cat');
		$config = array();
		$reg = Zend_Registry::getInstance();

		// Переменная $cat иногда теряется в новой админке. Хотя что уж там - ни разу нормально не пришла. Будем делать без неё.
		/*if( $cat === 'true' ){
				$config = array("kategory" => array( "size"=>$reg->get( 'catalog_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' )));
			}else{
				$config = array(
					"big" => array( "size"=>$reg->get( 'catalog_big_size' ), "quality"=>100, "square" => $reg->get( 'square_big_active' )),
					"medium" => array( "size"=>$reg->get( 'catalog_medium_size' ), "quality"=>80, "square" => $reg->get( 'square_medium_active' )),
					"small" => array( "size"=>$reg->get( 'catalog_small_size' ), "quality"=>80, "square" => $reg->get( 'square_small_active' ))
				);
			}/**/
		
		$config = array(
			"shop/big" => array( "size"=>$reg->get( 'catalog_big_size' ), "quality"=>100, "square" => $reg->get( 'square_big_active' ) ),
			"shop/medium" => array( "size"=>$reg->get( 'catalog_medium_size' ), "quality"=>80, "square" => $reg->get( 'square_medium_active' )),
			"shop/small" => array( "size"=>$reg->get( 'catalog_small_size' ), "quality"=>80, "square" => $reg->get( 'square_small_active' ) ),
			"shop/kategory" => array( "size"=>$reg->get( 'catalog_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' )),
			"shop/backend" => array( "size"=>75, "square"=>true ), // картинка для админки
		);

		$Image = new Model_Image('public/', $config);
		$image = $Image->LoadImages('userfile');
		if($image!=false)
			$this->getResponse()->setBody( $image );
		else
			$this->getResponse()->setBody( "error" );
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
				// удаление категории каталога
					$success = Model_Collection_Elements::getInstance () 
						->delElement ( $category_id );
					if (! $success and (APPLICATION_ENV != 'production'))
						throw new Exception ( 'Ошибка при удалении категории каталога' );
			}
		} else {
                    $item_id = $this->getRequest ()->getParam ( 'item' );
                    if( isset( $item_id ) ){
                            $item_id = (int) $item_id;
                            if( $item_id > 0 ){
                                    // удаление товара
                                    $success = Model_Collection_Elements::getInstance () ->delElement( $item_id );
                                    if (! $success and (APPLICATION_ENV != 'production'))
                                            throw new Exception ( 'Ошибка при удалении товара' );
                                    }
                    }
                }
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
}