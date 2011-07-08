<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля объявлений
 * 
 * @category   Xcms
 * @package    Bulletin
 * @subpackage Controller
 * @version    $Id: $
 */

class Bulletin_BackController extends Xcms_Controller_Back {
	
	/**
	 * Установленные модули
	 * @return void
	 */
	public function getAction() {
		$pub = $this->getRequest ()->getParam ( 'category' );
		//$unpub = $this->getRequest ()->getParam ( 'category_unpub' );
		if(isset($pub)) {
			$status = 'active';
			$category_id = $pub;
		} else {
			$status = 'unactive';
			$category_id = $this->getRequest ()->getParam ( 'category_un' );
		}
		//$status =  $this->getRequest ()->getParam ( 'status' );
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
		$options = $bootstraps['bulletin']->getModuleOptions();
		$actions = $options['actions'];
		$data = array();
		if( !isset( $status ) ){
			$form = new Bulletin_Form_Edit();
			$data['form'] = $form->render();
		}else if( $status == 'active' || $status == 'unactive' ){
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('bulletin', 'category');
			if ( isset($type) ) {
				$cat_type_id = $type->id;
			} else {
				throw new Exception( 'Тип данных лента объявлений не существует' );
			}
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('bulletin', 'item');
			if ( isset($type) ) {
				$item_type_id = $type->id;
			} else {
				throw new Exception( 'Тип данных объявления не существует' );
			}
			$mce = Model_Collection_Elements::getInstance ();
			$categories = $mce->getChildren ( $category_id, 2, $cat_type_id );
			foreach ( $categories as $k => $have ) {
				$category = $mce->getElement ( $k );
				$categoryClass = $category->getType()->getElementClass();
				if ( ! $category->isReadable() ) continue;
				if($status == "active")
					$elementName = 'category';
				else
					$elementName = 'category_un';
				$data[] = array (
					'id' => $category->id,
					'title' => $category->getObject()->title,
					'expandable' => true,
					'elementClass' => $categoryClass,
					'controller' => 'bulletin',
					'element' => $elementName,
					'actions' => $actions['category']
				);
			}
			
			if( $status == 'active' )
				$news = $mce->getChildren ( $category_id, 1, $item_type_id, false );
			else
				$news = $mce->getChildren ( $category_id, 1, $item_type_id, true, false );
			foreach ( $news as $k => $news_item ) {
				$items = $mce->getElement ( $k );
				$itemsClass = $items->getType()->getElementClass();
				if ( ! $items->isReadable() ) continue;
				$data[] = array(
					'id' => $items->id,
					'title' => $items->getObject()->title,
					'expandable' => false,
					'elementClass' => $itemsClass,
					'controller' => 'bulletin',
					'element' => 'item',
					'actions' => $actions['item']
				);
			}
		}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * редактировать ленту   /admin/bulletin/edit/category/5
	 * редакт. отзыв       /admin/bulletin/edit/category/5/element/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		$categoryun_id = $this->getRequest ()->getParam ( 'category_un' );
		if(!isset($category_id))
			$category_id = $categoryun_id;
		elseif(isset($categoryun_id))
			$item_id = $categoryun_id;
		$data = array();
		if ( isset ( $category_id ) ) {
			if ( $category_id == 'new' ) {
				//создание ленты объявлений
				$type_cat = Model_Collection_ElementTypes::getInstance()->getModuleElementType('bulletin', 'category');
				if ( isset($type_cat) ) {
					$type_cat_id = $type_cat->id;
				} else {
					throw new Exception( 'Тип данных лент объявлений не существует' );
				}
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( 0, $type_cat_id );
			}else{
				// Получить ленту объявлений
				$complex_id = $category_id = (int) $category_id;
				if ( $category_id > 0 ) {
					$element = Model_Collection_Elements::getInstance()->getElement( $category_id );
					//$item_id = $this->getRequest()->getParam ( 'element' );
					if ( isset( $item_id ) ) {
						if ( $item_id == 'new' ) {
							// Создание объявления
							$type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('bulletin', 'item');
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
							// Получение объявлений
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
	 * создать ленту         /admin/bulletin/new/category/0
	 * создать отзыв       /admin/bulletin/new/category/5/element/add
	 */
	public function newAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			$item_id = $this->getRequest ()->getParam ( 'element' );
			if ( isset( $item_id ) ) {
				// создание объявления
				$this->getRequest ()->setParam ( 'element', 'new' );
			} else {
				// создание ленты объявлений
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
		if( isset( $category_id ) ){
			$category_id = (int) $category_id;
			if( $category_id > 0 ){
				// удаление ленты объявлений
				$success = Model_Collection_Elements::getInstance () 
					->delElement ( $category_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении ленты объявления' );
			}
		}
		$item_id = $this->getRequest ()->getParam ( 'item' );
		if( isset( $item_id ) ){
			$item_id = (int) $item_id;
			if( $item_id > 0 ){
				// удаление объявлений
				$success = Model_Collection_Elements::getInstance () ->delElement( $item_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении объявления' );
				}
		}
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
}