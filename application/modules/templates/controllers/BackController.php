<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля шаблонов
 * 
 * @category   Xcms
 * @package    Templates
 * @subpackage Controller
 * @version    $Id: BackController.php 238 2010-07-02 11:43:40Z renat $
 */

class Templates_BackController extends Xcms_Controller_Back {


        public function  preDispatch() {
            $site = $this->getRequest ()->getParam ( 'site' ) ;
            $block = $this->getRequest ()->getParam ( 'block' );
            $view = $this->getRequest()->getParam('view');
            if(isset($site)) {
                $this->type = 1;
            } elseif(isset($view)) {
                $this->type = 2;
            } else {
                $this->type = 3;
            }
        }
	
	/**
	 * Шаблоны сайта
	 * @return void
	 */
	public function getAction(){
            switch($this->type) {
                case 1: // Шаблоны
                    $templates = Model_Collection_Templates::getInstance()->fetchAll();
                    $baseUrl = $this->view->BaseUrl() . '/cms/images/';
                    $data = array();
                    foreach ( $templates as $template ) {
                        if ( $template->filename == 'default' ) continue;
                        $data[]= array(
                            'id'     => $template->id,
                            'title'  => $template->title,
                            'expandable' => false,
                            'controller' => 'templates',
                            'element' => 'site',
                            'icons' => array()
                        );
                    }
                    break;
                case 2: // виды
                    $modules = Model_Collection_ElementTypes::getInstance()->getModules();
                    $c_views = Model_Collection_Views::getInstance();
                    $data = array();
                    foreach ( $modules as $module ) {
                        $views = $c_views->getEntitiesByType($module->id);
                        foreach ( $views as $view ) {
                            $data[] = array(
					'id' => $view->id,
					'title' => $module->title.'/'.$view->title,
					'expandable' => false,
                                        'controller' => 'templates',
                                        'element' => 'view',
					'elementClass' => 'view',
					'accept' => ''
				);
                        }
                    }

                    break;
                case 3: // Блоки
                    $blocks = Model_Collection_Blocks::getInstance()->fetchAll();
                    $baseUrl = $this->view->BaseUrl() . '/cms/images/';
                    $data = array();
                    foreach ( $blocks as $block ) {
                            $data[]= array(
                                    'id'     => $block->id,
                                    'title'  => $block->title,
                                    'controller' => 'templates',
                                    'element' => 'block',
                                    'expandable' => false,
                                    'icons' => array()
                            );
                    }
                    break;
            }
            $this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания и редактирования шаблона
	 * @return void
	 * @throws Exception если шаблон не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$parent_id = 0;
                switch ($this->type) {
                    case 1: // Шаблоны
                        $template_id =(int) $this->getRequest()->getParam('site');
                        if ( isset ( $template_id ) ) {
                            if ($template_id == 0) {
                                // TODO создание нового - только в корень?
                                $parent_id = ( int ) $this->getRequest ()->getParam ( 'parent' );
                                $template = Model_Collection_Templates::getInstance ()
                                        ->createTemplate ();
                            } else {
                                // редактирование
                                $template_id = ( int ) $template_id;
                                if ($template_id > 0) {
                                        $template = Model_Collection_Templates::getInstance ()
                                                ->getEntity ( $template_id );
                                } else {
                                        if (APPLICATION_ENV != 'production')
                                                throw new Exception ( 'Неправильный идентификатор шаблона' );
                                }
                            }
                        }
                        if (! isset ( $template )) {
                            throw new Exception ( 'Нет элемента' );
                        }
                        $form = $template->getEditForm ();
                        $request = $this->getRequest ();
                        $data = array ();
                        if ($this->getRequest ()->isPost ()) {
                            if ($form->isValid ( $request->getPost () )) {
                                $template->setValues ( $form->getValues () );
                                $template->commit ();
                                if ( $template_id == 'new' ) {
                                    // меняем форму при добавлении
                                    $form = $template->getEditForm ();
                                }
                                $data = array (
                                    'id' => $template->id,
                                    'parent_id' => $parent_id,
                                    'title' => $template->title
                                );
                            }
                        }
                        break;
                    case 2: // Модули
                        $template_id =(int) $this->getRequest()->getParam('view');
                                // редактирование
                        $template_id = ( int ) $template_id;
                        if ($template_id > 0) {
                                $template = Model_Collection_Views::getInstance ()
                                        ->getEntity ( $template_id );
                        } else {
                                if (APPLICATION_ENV != 'production')
                                        throw new Exception ( 'Неправильный идентификатор шаблона' );
                        }
                        if (! isset ( $template )) {
                            throw new Exception ( 'Нет элемента' );
                        }
                        $form = $template->getEditForm ();
                        $request = $this->getRequest ();
                        $data = array ();
                        if ($this->getRequest ()->isPost ()) {
                            if ($form->isValid ( $request->getPost () )) {
                                $template->setValues ( $form->getValues () );
                                $template->commit ();
                                if ( $template_id == 'new' ) {
                                    // меняем форму при добавлении
                                    $form = $template->getEditForm ();
                                }
                                $data = array (
                                    'id' => $template->id,
                                    'parent_id' => $parent_id,
                                    'title' => $template->title
                                );
                            }
                        }
                        break;
                    case 3: // Блоки
                        $block_id = $this->getRequest ()->getParam ( 'block' );
                        if ( isset ( $block_id ) ) {
                            if ($block_id == 0) {
                                // TODO создание нового - только в корень?
                                $parent_id = ( int ) $this->getRequest ()->getParam ( 'parent' );
                                $block = Model_Collection_Blocks::getInstance()
                                ->createBlock();
                            } else {
                                // редактирование
                                $block_id = ( int ) $block_id;
                                if ($block_id > 0) {
                                    $block = Model_Collection_Blocks::getInstance ()
                                                ->getEntity ( $block_id );
                                } else {
                                    if (APPLICATION_ENV != 'production')
                                        throw new Exception ( 'Неправильный идентификатор шаблона' );
                                }
                            }
                        }
                        $form = $block->getEditForm();
                        $request = $this->getRequest ();
                        $data = array ();
                        if ($this->getRequest ()->isPost ()) {
                            if ($form->isValid ( $request->getPost () )) {
                                $block->setValues ( $form->getValues () );
                                $block->commit ();
                                if ( $block_id == 'new' ) {
                                    // меняем форму при добавлении
                                    $form = $block->getEditForm ();
                                }
                                $data = array (
                                    'id' => $block->id,
                                    'parent_id' => $parent_id,
                                    'title' => $block->title
                                );
                            }
                        }
                        break;
                }
		$data ['form'] = $form->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания элемента (перенаправление на edit)
	 * @return void
	 */
	public function newAction() {
            switch ($this->type) {
                case 1:
                    $parent_id = $this->getRequest ()->getParam ( 'site' );
                    $this->getRequest ()->setParam ( 'site', 0 );
                    break;
                case 2:
                    $parent_id = $this->getRequest ()->getParam ( 'view' );
                    $this->getRequest ()->setParam ( 'view', 0 );
                    break;
                case 3:
                    $parent_id = $this->getRequest ()->getParam ( 'block' );
                    $this->getRequest ()->setParam ( 'block', 0 );
                    break;
            }
            $this->getRequest ()->setParam ( 'parent', $parent_id );
            $this->_forward( 'edit' );
	}
	
	/**
	 * Необратимое удаление
	 * @return void
	 * @throws Exception если элемент удалить не удалось (не в production)
	 */
	public function deleteAction() {
		switch ($this->type) {
			case 1:
				$template_id = ( int ) $this->getRequest ()->getParam ( 'site' );
				$success = Model_Collection_Templates::getInstance ()
					->delEntity ( $template_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении элемента' );
				break;
			case 3:
				$block_id = ( int ) $this->getRequest ()->getParam ( 'block' );
				$success = Model_Collection_Blocks::getInstance ()
					->delEntity ( $block_id );
				if (! $success and (APPLICATION_ENV != 'production'))
					throw new Exception ( 'Ошибка при удалении элемента' );
				break;
		}
	}
}