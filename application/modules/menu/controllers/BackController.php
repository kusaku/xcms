<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля "Меню"
 * 
 * @category   Xcms
 * @package    Menu
 * @subpackage Controller
 * @version    $Id $
 */

class Menu_BackController extends Xcms_Controller_Back {
	
	/**
	 * Получение групп пользователей и пользователи
	 * @return void
	 */
	public function getAction(){
		$baseUrl = $this->view->BaseUrl() . '/cms/images/';
		$items = Model_Collection_Objects::getInstance()
			->getObjectsByType( 10 );
                $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
		$options = $bootstraps['menu']->getModuleOptions();
                $actions = $options['actions'];
                $options = $bootstraps['menu']->getModuleOptions();
                $actions = $options['actions'];
		$data = array();
		foreach ( $items as $item ) {
			$data[]= array(
				'id'         => $item->id,
				'title'      => $item->title,
				'expandable' => false,
                                'controller' => 'menu',
                                'element' => 'menuset',
				'elementClass' => '',
                                'actions'=>$actions['menuset'],
				'icons'      => array(
					$baseUrl . 'ico_menu_.png',
					$baseUrl . 'ico_menu_.png'
				)
			);
		}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания и редактирования
	 * @return void
	 * @throws Exception если не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$menu_id = $this->getRequest()->getParam ( 'menuset' );
		$data = array ();
		if ( isset( $menu_id ) ) {
			if ( $menu_id == 'new' ) {
				$dataobj = $objecttype = Model_Collection_Objects::getInstance()
					->createObject( array( 'id_type' => 10 ) );
				$data['title'] = 'Создать меню';
			} else {
				$menu_id = (int) $menu_id;
				if ( $menu_id > 0 ) {
					$dataobj = Model_Collection_Objects::getInstance()
						->getEntity ( $menu_id );
					$data['title'] = 'Редактировать название блока меню';
				} else {
					if ( APPLICATION_ENV != 'production' )
						throw new Exception( 'Неправильный идентификатор меню' );
				}
			}
		}
		if ( ! isset($dataobj) ) {
			throw new Exception( 'Нет объекта для редактирования' );
		}
		$form = $dataobj->getEditForm();
		$request = $this->getRequest();
		if ($this->getRequest()->isPost()) {
			if ($form->isValid ( $request->getPost() )) {
				$dataobj->setValues ( $form->getValues() );
				$dataobj->commit ();
				if ( $menu_id == 'new' ) {
					$menu_id = $dataobj->id;
				}
				$form = $dataobj->getEditForm();
				$data = array (
					'id' => $menu_id,
					'title' => (string) $dataobj
				);
			}
		}
		$data ['form'] = $form->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания (перенаправление на edit)
	 * @return void
	 */
	public function newAction() {
		$menu_id = $this->getRequest ()->getParam ( 'menuset' );
		if ( isset( $menu_id ) ) {
			$this->getRequest ()->setParam ( 'menuset', 'new' );
		}
		$this->_forward( 'edit' );
	}
	
	/**
	 * Необратимое удаление
	 * @return void
	 * @throws Exception если удалить не удалось (не в production)
	 */
	public function deleteAction() {
		$menu_id = ( int ) $this->getRequest ()->getParam ( 'menuset' );
		$success = Model_Collection_Objects::getInstance ()
			->delEntity ( $menu_id );
		if (! $success and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при удалении меню' );
	}
}