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

class Guides_BackController extends Xcms_Controller_Back {
	

    /**
	 * Дочерние элементы структуры
	 * @return void
	 */
	public function getAction() {
		$guide_id = ( int ) $this->getRequest ()->getParam ( 'guide' );
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
		$options = $bootstraps['guides']->getModuleOptions();
		$actions = $options['actions'];
		$data = array();
		if ( $guide_id == 0 ){
			$mcot = Model_Collection_ObjectTypes::getInstance();
			$guides = $mcot->getGuidesGuides();
			foreach ($guides as $guide){
				$data[] = array (
					'id'=>$guide->id,
					'title'=>$guide->title,
					'actions'=>$actions['guide'],
					'expandable'=>true,
					'controller'=>'guides',
					'element'=>'guide'
				);
			}
		} else {
			$objects = Model_Collection_Objects::getInstance()->getObjectsByType($guide_id);
			foreach ($objects as $object){
				$data[] = array (
					'id'=>$object->id,
					'title'=>$object->title,
					'expandable'=>false,
					'actions'=>$actions['item'],
					'controller'=>'guides',
					'element'=>'item'
				);
			}
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
		$item_id = $this->getRequest ()->getParam ( 'guide' );

		$data = array();

		if ( $this->getRequest()->getParam('item') == 'new' ) {
			$data['id_type'] = $item_id;
			$object = Model_Collection_Objects::getInstance ()->createObject ($data);
		}
		else $object = Model_Collection_Objects::getInstance()->getEntity($item_id);

		$form = $object->getEditForm();

		$form->populate( $object->getValues() );

		$request = $this->getRequest();
		if ( $request->isPost() ) { // получены данные формы
			if ( $form->isValid( $request->getPost() ) ) { // форма валидна
				$object->setValues( $form->getValues() );
				// Транзакции, очистка кеша и логирование работает только для ObjectType::commit()
				$object->commit(); // сохранение в БД

				$form = $object->getEditForm (); // обновляем форму
				$data = array(
					'title'	=> $object->title
				);
			}
		}
/**/

		$data ['form'] = $form->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
        
	public function newitemAction() {
		$guide_id = $this->getRequest ()->getParam ( 'guide' );
		if ( isset( $guide_id ) ) {
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