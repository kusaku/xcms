<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля контента
 * 
 * @category   Xcms
 * @package    Content
 * @subpackage Controller
 * @version    $Id: BackController.php 626 2011-01-31 16:44:19Z kifirch $
 */

class Content_BackController extends Xcms_Controller_Back {
	
	/**
	 * Главная
	 * @return void
	 */
	public function indexAction() {
		$data = array(
			'text' => 
				'<div id="main">
				<h2>Уважаемые владельцы сайтов!</h2>
				<p>Благодарим за то, что Вы выбрали «Фабрику сайтов»! Мы будем рады, если наши услуги и разработки помогут Вам добиться успеха!</p>
				<p>Современный бизнес невозможно представить без Интернета, и наша компания поможет Вам использовать неограниченные возможности Всемирной сети. В основе нашей работы лежит стремление сделать веб-технологии доступными и простыми в использовании, превратить их в удобный инструмент реализации Ваших проектов. Именно этими принципами мы руководствовались при разработке CMS. Создавая систему управления сайтом, мы использовали самые современные технологии и учли наиболее актуальные на сегодняшний день тенденции сайтостроения, благодаря чему CMS обладает высокой скоростью работы и расширенными возможностями.</p>
				<p>Вы становитесь обладателем инновационного продукта, позволяющего значительно оптимизировать администрирование Вашего сайта. Интуитивный интерфейс поможет Вам быстро разобраться в методике управления веб-ресурсом и оперативно вносить любые изменения и дополнения в контент, не затрачивая много времени и сил. </p>
				<p>Быстро освоить управление сайтом сможет даже начинающий пользователь, не имеющий опыта работы с CMS: для редактирования веб-страниц достаточно базовых навыков работы с компьютером, в частности, с текстовыми редакторами.	</p>
				<p>Расширенный функционал позволяет выполнять в один или несколько кликов следующие операции:
				<ul>
				<li>изменение параметров выравнивания текста;</li>
				<li>добавление и удаление ссылок;</li>
				<li>загрузка и удаление изображений;</li>
				<li>добавление текста с очисткой от форматирования и многое другое.</li>
				</ul></p>
				<p>Таким образом, Вы сможете быстро менять наполнение Вашего веб-ресурса, сделав его актуальным и динамичным, оперативно отображать на страницах сайта самую свежую информацию и реализовывать свои идеи. </p>
				<p>Начав работу с CMS от «Фабрики сайтов», Вы почувствуете, что управлять веб-ресурсом – это удобно и просто. </p>
				</div>' 
		);
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Дочерние элементы структуры
	 * @return void
	 */
	public function getAction() {
		$id = ( int ) $this->getRequest ()->getParam ( 'element' );
		$mce = Model_Collection_Elements::getInstance ();
		$children = $mce->getChildren ( $id, 2 );
		// получаем все модули
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
		$data = array();
		foreach ( $children as $k => $have ) {
			$element = $mce->getElement ( $k );
			$elementClass = $element->getType()->getElementClass();
			$classes = explode('_', $elementClass);
			empty($classes[1]) ? $class = 'element' : $class = $classes[1];
			$config = Zend_Registry::get( 'content' );
			$module = $element->getType()->getModule();
			if ( method_exists( $bootstraps[ $module ], 'getModuleOptions' ) ) {
				$options = $bootstraps[$module]->getModuleOptions();
				$el_actions = @$options['actions'][$class];
				if(is_array($el_actions)){
					if($element->isWritable()) {
						$actions = $el_actions;
						$controller = $options['controller'];
					}
				} else {
					$actions = array();
				}
			}
			$data[] = array (
				'id' => $element->id,
				'title' => $element->getObject()->title,
				'expandable' => ! empty ( $have ),
				'count' => count( $have ),
				'elementClass' => $elementClass,
				'element' => $class,
				'controller' => $module,
				'actions' => $actions 
			);
		}
		// Записываем в тело ответа данные в формате JSON,
		// заголовки ответа устанавливаются плагином (см. Zend_View_Helper_Json)
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * создать	/admin/content/edit/element/new/parent/5
	 * редакт.	/admin/content/edit/element/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 * @throws Exception при добавлении, если превышено максимальное разрешенное количество страниц
	 */
	public function editAction() {
		$parent_id = 0;
		$element_id = $this->getRequest ()->getParam ( 'element' );
		if ( isset ( $element_id ) ) {
			if ($element_id == 'new') {
				// создание нового
				$max = (int) Zend_Registry::get('content')->maxpages;
				if ( !empty($max) ) {
					$total_pages = Model_Collection_Elements::getInstance()->countElementsByType(17);
					if ( $total_pages >= $max )
						throw new Exception ( 'Превышено максимальное разрешенное количество страниц' );
				}
				$parent_id = ( int ) $this->getRequest ()->getParam ( 'parent' );
				if ( !empty($parent_id) and !Zend_Registry::get('content')->subpages ) {
					throw new Exception ( 'Подстраницы создавать запрещено' );
				}
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( $parent_id );
			} else {
				// редактирование
				$element_id = ( int ) $element_id;
				if ($element_id > 0) {
					$element = Model_Collection_Elements::getInstance ()
						->getElement ( $element_id );
				} else {
					if (APPLICATION_ENV != 'production')
						throw new Exception ( 'Неправильный идентификатор элемента' );
				}
			}
		}
		if (! isset ( $element )) {
			throw new Exception ( 'Нет элемента' );
		}
		$writable = $element->isWritable();
		$form = $element->getEditForm(!$writable);
		$data = array();
		$request = $this->getRequest();
		if ( $writable and $this->getRequest()->isPost() ) {
			if ( $form->isValid( $request->getPost() ) ) {
				$element->setValues( $form->getValues() );
				$element->commit();
				$form = $element->getEditForm();
				$data = array (
					'id' => $element->id,
					'parent_id' => $parent_id,
					'title' => $element->getObject()->title,
					'elementClass' => $element->getType()->getElementClass(),
					'actions' => array(
						'edit' => 'Редактировать',
			 			'new' => 'Создать',
						'copy' => 'Копировать',
						'delete' => 'Удалить'
					)
				);
				if ( $element_id == 'new' ) {
					$data['expandable'] = false;
					if ( !empty($max) ) {
						$total_pages++;
						if ( $total_pages >= $max )
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
	 */
	public function newAction() {
		$parent_id = $this->getRequest()->getParam( 'element' );
		$this->getRequest()->setParam( 'parent', $parent_id );
		$this->getRequest()->setParam( 'element', 'new' );
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
	 * Копирование элемента с заданным id вместе с данными
	 * @return void
	 * @throws Exception если элемент скопировать не удалось (не в production)
	 */
	public function cloneAction() {
		$element_id = ( int ) $this->getRequest()->getParam ( 'element' );
		$mce = Model_Collection_Elements::getInstance ();
		$children = $mce->getChildren ( $element_id );
		$element = $mce->cloneElement ( $element_id, true );
		if (! $element and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при клонировании элемента' );
		$baseUrl = $this->view->BaseUrl() . '/cms/images/';
		$data = array (
			'id' => $element->id,
			'title' => $element->getObject()->title,
			'expandable' => ! empty ( $children )
		);
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Копирование элемента с заданным id
	 * @throws Exception если элемент скопировать не удалось (не в production)
	 * @return void
	 */
	public function copyAction() {
		$element_id = ( int ) $this->getRequest()->getParam( 'element' );
		$mce = Model_Collection_Elements::getInstance();
		$children = $mce->getChildren( $element_id );
		$element = $mce->copyElement( $element_id, true );
		if (! $element and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при копировании элемента' );
		$baseUrl = $this->view->BaseUrl() . '/cms/images/';
		$data = array (
			'id' => $element->id,
			'title' => $element->getObject()->title,
			'expandable' => ! empty( $children ),
			'icons' => array(
				$baseUrl . 'ico_catalog_category.png',
				$baseUrl . 'ico_content_.png'
			)
		);
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Перемещение элемента с заданным id
	 * Пример:	/admin/content/move/element/4/dest/3/before/9
	 * @return void
	 * @throws Exception если элемент переместить не удалось (не в production)
	 */
	public function moveAction() {
                $elements = $this->getRequest()->getParam('element');
                $ord = 0;
//                print_r($elements);
                $els = array();
                foreach($elements as $id=>$element) {
                    $els[$id]['parent_id'] = $element;
                    $els[$id]['ord'] = 0;
                    if($element == 'root')$els[$id]['parent_id'] = 0;
                    $ord++;
                }
                //print_r($els);

				$m = array(); // MEGAMASSIVE BLACK HOLE =)

                $mce = Model_Collection_Elements::getInstance();
                $db = $mce->getDbElements();
                $s = $db->select()->where('id IN('.join(',',array_keys($elements)).')')->order(array('id_parent','id_type','ord'));
                $rows = $db->fetchAll($s);
				$temp = 1;

				$tp = array();

                foreach($rows as $ord=>$element) {
                    //print($element->id.' ');//.$element->id_parent);
                    $els[$element->id]['type'] = $element->id_type;
					$m[$element->id_type][$element->id_parent][$element->id] = $temp;
					$temp++;
                    if($els[$element->id]['parent_id'] != $element->id_parent) {
                        $mce->moveElement( $element->id, $els[$element->id]['parent_id'] );
                    }
					
                }

				$osiudf = 1;
				foreach ($els as $key=>$element) {
					$tp[$element['type']]++;
					$els[$key]['ord']=$tp[$element['type']];
					$els[$key]['ord']=$osiudf;
					$osiudf++;
				}/**/

				foreach($rows as $ord=>$element) {
                    if($els[$element->id]['ord'] != $element->ord) {
                        $mce->moveElement( $element->id, $element->id_parent, null, $els[$element->id]['ord']);
                    }
                }

			print_r ($m);

				foreach ($m as $t=>$types) {
					foreach ($types as $p=>$parents) {
						$size = sizeof($parents);
						$val = 1;
						foreach ($parents as $i=>$item)
						{
							$m[$t][$p][$i] = $val;
							$val++;
						}
					}
				}

/**/
				//print_r ($m);

/*				$onebyone = 0;
				foreach($elements as $id=>$element) {
					if ( $id != $rows[$onebyone]->id )
							print 'Alarm!'.$id."\n";
                    $onebyone++;
                }
/**/

                //print_r($els);
		/*$element_id = $this->getRequest()->getParam ( 'element' );
		if( isset( $element_id ) )
			$element_id = ( int )$element_id;
		else
			$element_id = ( int ) $this->getRequest()->getParam ( 'category' );
		$destination_id = ( int ) $this->getRequest()->getParam( 'dest' );
		$before_id = $this->getRequest()->getParam( 'before' );
		if( isset( $before_id ) )
			$before_id = ( int ) $before_id;
		$success = Model_Collection_Elements::getInstance ()
			->moveElement( $element_id, $destination_id, $before_id );
		if (! $success and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при перемещении элемента' );*/
	}
	
	public function  uploadAction(){
		$element_id = $this->getRequest()->getParam ( 'element' );
		$mce = Model_Collection_Elements::getInstance ();
		$module = $mce->getElement($element_id)->getType()->getModule();
		$this->_forward('upload', 'back', $module);
	}

	/**
	 * Удаление элемента в корзину с заданным id
	 * @return void
	 * @throws Exception если элемент удалить не удалось (не в production)
	 */
	public function deleteAction() {
		$element_id = ( int ) $this->getRequest()->getParam( 'element' );
		$success = Model_Collection_Elements::getInstance()
			->delElement ( $element_id );
		if (! $success and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при удалении элемента' );
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
	
	
	public function getoptionsAction() {
	    $form = new Content_Form_Options();
	    $data['form'] = $form->render();
	    $this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	
	public function saveoptionsAction() {
	    $request = $this->getRequest();
	    $form = new Content_Form_Options();
	    if($form->isValid($request->getPost())) {
		$reg = Zend_Registry::getInstance();
		$values = $form->getValues();
		foreach ( $values as $key=>$value ) {
		// Временное решение для Robots.txt
			$robotsFile = APPLICATION_PATH . '/../public/robots.txt';
			if( $key == 'robots_text' ){
				if ( file_exists( $robotsFile ) ){
					file_put_contents( $robotsFile, $value);
				}else{
					$frobots = fopen($robotsFile, 'w');
					fclose( $frobots );
					file_put_contents( $robotsFile, $value);
				}
			}
			if ( $reg->isRegistered( $key ) ) {
				if ( $reg->get( $key ) != $value ) {
					$reg->update( $key, $value );
				}
			} else {
				$reg->add( $key, $value );
			}
		}
		$reg->commit();
		// очищаем кеш
		$cache = Model_Abstract_Collection::getCache();
		$cache->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			array( 'Navigation' )
		);
	    }
	    $data['form'] = $form->render();
	    $this->getResponse()->setBody( $this->view->json( $data ) );
	}
}
