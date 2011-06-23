<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля "Пользователи"
 * 
 * @category   Xcms
 * @package    Users
 * @subpackage Controller
 * @version    $Id $
 */

class Users_BackController extends Xcms_Controller_Back {
	
	/**
	 * Получение групп пользователей и пользователи
	 * @return void
	 */
	public function getAction(){
	//	$baseUrl = $this->view->BaseUrl() . '/cms/images/';
		// все пользователи
                $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
                $options = $bootstraps['users']->getModuleOptions();
		$actions = $options['actions'];
		$group_id = (int)$this->getRequest()->getParam('group');
		if($group_id>0) {
		    $users = Model_Collection_Users::getInstance()->getUsersByGroup($group_id);//  ->fetchAll();
		    $data = array();
		    foreach ( $users as $user ) {
			    $data[] = array(
				    'id'         => array( $user->id_usergroup, $user->id ),
				    'title'      => $user->getObject()->title,
				    'expandable' => false,
				    'element' => 'user',
				    'controller' => 'users',
				    'actions' => $actions['user'],
				    'icons'      => array(
					    $baseUrl . 'ico_users_user.png',
					    $baseUrl . 'ico_users_user.png'
				    )
			    );
		    }
		} else {
		    // все группы пользователей
		    $groups = Model_Collection_Objects::getInstance()
			    ->getObjectsByType( Model_Collection_Users::USERGROUP_OTYPE_ID );
		    $data = array();
		    foreach ( $groups as $group ) {
			    if ( $group->id == Model_Collection_Users::ADMINISTRATOR and 
				     Zend_Auth::getInstance()->getIdentity()->id_usergroup == Model_Collection_Users::LIMITED ) continue;
			    /*if ( $group->id == Model_Collection_Users::GUEST or
				     $group->id == Model_Collection_Users::REGISTERED ) continue;*/
			    $user_data = isset( $users_data[ $group->id ] ) ? $users_data[ $group->id ] : array();
			    $data[]= array(
				    'id'         => $group->id,
				    'title'      => $group->title,
				    'expandable' => true,
				    'element' => 'group',
				    'controller' => 'users',
				    'actions'=>$actions['group'],
				    'is_locked'  => false, //($group->id == Model_Collection_Users::GUEST)
				    /*'icons'      => array(
					    $baseUrl . 'ico_users_group.png',
					    $baseUrl . 'ico_users_group.png'
				    ),*/
				//    'fields'		=> $user_data
			    );
		    }
		}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	
	public function newitemAction() {
	   // $group = $this->getRequest()->getParam('user');
	    $this->getRequest()->setParam('user', 'new');
	    //$this->getRequest()->setParam('group', $group );
	    
	    $this->_forward('edit');
	}
	
	/**
	 * Страница создания и редактирования
	 * @return void
	 * @throws Exception если группы или пользователи не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$group_id = $this->getRequest()->getParam ( 'group' );
		/*print_r($this->getRequest()->getParams());
		return;*/
		$data = array ();
		if ( isset( $group_id ) ) {
			if ( $group_id == 'new' ) {
				// создание группы пользователей
				$dataobj = $objecttype = Model_Collection_Objects::getInstance()
					->createObject( array( 'id_type' => Model_Collection_Users::USERGROUP_OTYPE_ID ) );
				$data['title'] = 'Создание группы';
			} else {
				// получить группу пользователей
				$complex_id = $group_id = (int) $group_id;
				if ( $group_id > 0 ) {
					$dataobj = Model_Collection_Objects::getInstance()
						->getEntity ( $group_id );
					$data['title'] = 'Редактирование группы';
					$user_id = $this->getRequest()->getParam ( 'user' );
					if ( isset( $user_id ) ) {
						if ( $user_id == 'new' ) {
							// создание пользователя
							$dataobj = Model_Collection_Users::getInstance()
								->createUser( array( 'id_usergroup' => $group_id ) );
							$data['title'] = 'Создание пользователя';
						} else {
							// получить пользователя
							$user_id = (int) $user_id;
							$complex_id = array( $group_id, $user_id );
							if ( $user_id > 0 ) {
								$dataobj = Model_Collection_Users::getInstance()
									->getEntity ( $user_id );
								$data['title'] = 'Редактирование пользователя';
								// редактирование пользователя
							} else {
								if ( APPLICATION_ENV != 'production' )
									throw new Exception( 'Неправильный идентификатор пользователя' );
							}
						}
					}
					// редактирование группы пользователей
				} else {
					if ( APPLICATION_ENV != 'production' )
						throw new Exception( 'Неправильный идентификатор группы пользователей' );
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
				if ( $group_id == 'new' ) {
					$complex_id = $dataobj->id;
				} elseif ( isset( $user_id ) and ( $user_id == 'new' ) ) {
					$complex_id = array( $group_id, $dataobj->id );
				}
				$form = $dataobj->getEditForm();
			//	$baseUrl = $this->view->BaseUrl() . '/cms/images/';
				$data = array (
					'id' => $complex_id,
					'title' => (string) $dataobj
				);
			}
		}
	//	$data['title'] = 'Редактирование пользователя';
		$data ['form'] = $form->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания (перенаправление на edit)
	 * @return void
	 */
	public function newAction() {
		$group_id = $this->getRequest ()->getParam ( 'group' );
		if ( isset( $group_id ) ) {
			$user_id = $this->getRequest ()->getParam ( 'user' );
			if ( isset( $user_id ) ) {
				// создание пользователя
				$this->getRequest ()->setParam ( 'user', 'new' );
			} else {
				// создание группы пользователей
				$this->getRequest ()->setParam ( 'group', 'new' );
			}
		}
		$this->_forward( 'edit' );
	}
	
	/**
	 * Необратимое удаление
	 * @return void
	 * @throws Exception если элемент удалить не удалось (не в production)
	 */
	public function deleteAction() {
		$group_id = $this->getRequest ()->getParam ( 'group' );
		if( isset( $group_id ) ){
			$group_id = (int) $group_id;
			if( $group_id > 0 ){
				$user_id = $this->getRequest ()->getParam ( 'user' );
				if( isset( $user_id ) ){
					$user_id = (int) $user_id;
					if( $user_id > 0 ){
						// удаление пользователя
						$success = Model_Collection_Users::getInstance () ->delEntity( $user_id );
						if (! $success and (APPLICATION_ENV != 'production'))
							throw new Exception ( 'Ошибка при удалении пользователя' );
						}
				}else{
					// удаление группы пользователей
					$success = Model_Collection_Objects::getInstance ()
						->delEntity ( $group_id );
					if (! $success and (APPLICATION_ENV != 'production'))
						throw new Exception ( 'Ошибка при удалении группы пользователей' );
				}
			}
		}
	}
}
