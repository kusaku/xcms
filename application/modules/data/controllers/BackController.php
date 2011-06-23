<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля типами данных (типы объектов)
 * 
 * @category   Xcms
 * @package    Data
 * @subpackage Controller
 * @version    $Id: BackController.php 238 2010-07-02 11:43:40Z renat $
 */

class Data_BackController extends Xcms_Controller_Back {

	/**
	 * Дочерние типы данных
	 * @return void
	 */
	public function getAction(){
		$id = (int) $this->getRequest ()->getParam ( 'otype' );
                $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
                $options = $bootstraps['data']->getModuleOptions();
                $actions = $options['actions'];
		$mcot = Model_Collection_ObjectTypes::getInstance();
		$data = array();
		if( isset( $id ) ) {
			// получаем группы полей с полями для типа данных
			$group_id = $this->getRequest ()->getParam ( 'group' );
			if( isset( $group_id ) ){
				//print 'group_id SET';
				$groups = $mcot->getEntity( $id )->getFieldGroups();
				foreach ( $groups as $group ) {
					// Поля
					$fields = $group->getFields();
					$fields_data = array();
					foreach ( $fields as $field ) {
						$fields_data[] = array(
							'id' => array( $id, $group->id, $field->id ),
						 	'title' => $field->title,
							'expandable' => false,
							'is_locked' => $field->is_locked,
							//'is_locked' => false,
							'controller' => 'data',
							'actions' => $actions['field'],
							'element' => 'otype',
							'elementClass' => 'field',
							'dialog'=>true,
							'icons' => array()
						);
					}
					// Группы
					$data[] = array(
						//'id' => $group->id,
						'id' => array( $id, $group->id, 0 ),
						'title' => $group->title,
						'expandable' => false,
						'actions' => $actions['group'],
						'controller' => 'data',
						'elementClass' => 'group',
						'fields' => $fields_data,
                                                'element' => 'group',
						'is_locked' => $group->is_locked,					
						'icons' => array()					
					);
				}
			} else {
				// получаем дочерние типы данных (0 - корневые)
				$children = $mcot->getChildren( $id, 2 );
				foreach ( $children as $child=>$descendants ) {
					$datatype = $mcot->getEntity( $child );
					$data[]= array(
						'id'     => $child,
						'title'  => $datatype->title,
						'expandable' => !empty( $descendants ),
						'is_locked' => $datatype->is_locked,
                                                'controller' => 'data',
                                                'actions' => $actions['otype'],
                                                'element' => 'otype',
						'icons' => array()
					);
				}
			}
		}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}

	/**
	 * Страница редактирования и создания
	 * Примеры:
	 * создать объект		/admin/data/edit/otype/new/parent/5
	 * редактировать поле	/admin/data/edit/otype/5/group/5/field/2
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$objecttype_id = $this->getRequest()->getParam ( 'otype' );
		$parent_id = $this->getRequest()->getParam ( 'parent' );

		if ( isset ($parent_id) ) $parent_id = (int) $parent_id;
			else $parent_id = null;

		if ( isset( $objecttype_id ) ) {
			if ( $objecttype_id == 'new' ) {
				// создание типа объекта
				$datatype = $objecttype = Model_Collection_ObjectTypes::getInstance()
					->createObjectType( $parent_id );

				$datatype->createFieldsGroup( array(
					'name'=>md5(time()),
					'id_obj_type'=>$this->id,
					'is_active'=>1,
					'is_locked'=>0,
					'is_visible'=>1,
					'title'=>'FieldGroup'.md5(time()),
					'ord'=>0
				) );

			} else {
				// получить тип объекта
				$complex_id = $objecttype_id = (int) $objecttype_id;
				if ( $objecttype_id > 0 ) {
					$datatype = $objecttype = Model_Collection_ObjectTypes::getInstance()
						->getEntity ( $objecttype_id );
					$fieldsgroup_id = $this->getRequest()->getParam ( 'group' );
					if ( isset( $fieldsgroup_id ) ) {
						if ( $fieldsgroup_id == 'new' ) {
							// создание группы полей
							$datatype = $datatype
								->createFieldsGroup();
						} else {
							// получить группу полей
							$complex_id = $fieldsgroup_id = (int) $fieldsgroup_id;
							if ( $fieldsgroup_id > 0 ) {
								$datatype = $datatype
									->getFieldsGroupById ( $fieldsgroup_id );
								$field_id = $this->getRequest()->getParam ( 'field' );
								if ( isset( $field_id ) ) {
									if ( $field_id == 'new' ) {
										// создание поля
										$datatype = $datatype
											->createField();
									} else {
										// получить поле
										$field_id = (int) $field_id;
										$complex_id = array( $fieldsgroup_id, $field_id );
										if ( $field_id > 0 ) {
											$datatype = $datatype
												->getFieldById ( $field_id );
											// редактирование поля
										} else {
											if ( APPLICATION_ENV != 'production' )
												throw new Exception( 'Неправильный идентификатор поля' );
										}
									}
								}
								// редактирование группы полей
							} else {
								if ( APPLICATION_ENV != 'production' )
									throw new Exception( 'Неправильный идентификатор группы полей' );
							}
						}
					}
					// редактирование типа объекта
				} else {
					if ( APPLICATION_ENV != 'production' )
						throw new Exception( 'Неправильный идентификатор типа данных' );
				}
			}
		}
		if ( ! isset($datatype) ) {
			throw new Exception( 'Нет объекта для редактирования' );
		}
		$form = $datatype->getEditForm();
		$request = $this->getRequest();
		if ( $this->getRequest()->isPost() ) { // получены данные формы
			if ( $form->isValid( $request->getPost() ) ) { // форма валидна
				$datatype->setValues( $form->getValues() );
				// Транзакции, очистка кеша и логирование работает только для ObjectType::commit()
				$objecttype->commit(); // сохранение в БД
				if ( $objecttype_id == 'new' ) {
					$complex_id = $datatype->id;
				} elseif ( isset( $fieldsgroup_id ) and ( $fieldsgroup_id == 'new' ) ) {
					$complex_id = $datatype->id;
				} elseif ( isset( $field_id ) and ( $field_id == 'new' ) ) {
					$complex_id = array( $fieldsgroup_id, $datatype->id );
				}
				$form = $datatype->getEditForm (); // обновляем форму
				$data = array( 
					'id'	=> $complex_id, 
					'title'	=> $datatype->title 
				);
				if ( isset( $datatype->id_parent ) )
					$data[ 'parent_id' ] = $datatype->id_parent;
			}
		}
		$data['form'] = $form->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Страница создания (перенаправление на edit)
	 * Примеры:
	 * создать объект		/admin/data/new/otype/5
	 * редактировать поле	/admin/data/new/otype/5/group/5/field
	 * @return void
	 */
	public function newAction() {
		$objecttype_id = $this->getRequest ()->getParam ( 'otype' );
		if ( isset( $objecttype_id ) ) {
			$fieldsgroup_id = $this->getRequest ()->getParam ( 'group' );
			if ( isset( $fieldsgroup_id ) ) {
				$field_id = $this->getRequest ()->getParam ( 'field' );
				if ( isset( $field_id ) ) {
					// создание поля
					$this->getRequest ()->setParam ( 'field', 'new' );
				} else {
					// создание группы полей
					$this->getRequest ()->setParam ( 'group', 'new' );
				}
			} else {
				// создание типа объекта
				$this->getRequest ()->setParam ( 'otype', 'new' );
				$this->getRequest ()->setParam ( 'parent', $objecttype_id );
			}
		}
		$this->_forward( 'edit' );
	}

	/**
	 * Необратимое удаление
	 * @return void
	 * @throws Exception если удалить не удалось (не в production)
	 */
	public function deleteAction() {
		$result = 0;
		$objecttype_id = $this->getRequest()->getParam ( 'otype' );
		if ( isset( $objecttype_id ) ) {
			$objecttype_id = (int) $objecttype_id;
			if ( $objecttype_id > 0 ) {
				$mcot = Model_Collection_ObjectTypes::getInstance();
				$datatype = $mcot->getEntity ( $objecttype_id );
				$fieldsgroup_id = $this->getRequest()->getParam ( 'group' );
				if ( isset( $fieldsgroup_id ) ) {
					$fieldsgroup_id = (int) $fieldsgroup_id;
					if ( $fieldsgroup_id > 0 ) {
						$fieldgroup = $datatype
							->getFieldsGroupById ( $fieldsgroup_id );
						$field_id = $this->getRequest()->getParam ( 'field' );
						if ( isset( $field_id ) ) {
							$field_id = (int) $field_id;
							if ( $field_id > 0 ) {
								// удаление поля из группы
								$result = $fieldgroup->detachField( $field_id );
							}
						} else {
							// удаление группы полей
							$result = $datatype->delFieldsGroup( $fieldsgroup_id );
						}
					}
				} else {
					// удаление типа объекта
					$result = $mcot->delEntity( $objecttype_id );
				}
			}
		}
		if ( ! $result and ( APPLICATION_ENV != 'production' ) )
			throw new Exception( 'Ошибка при удалении данных' );
	}
	
	/**
	 * Копирование типа данных с заданным id (в разработке)
	 * @todo копирование групп полей и полей
	 * @return void
	 * @throws Exception если скопировать не удалось (не в production)
	 */
	public function cloneAction() {
		$datatype_id = ( int ) $this->getRequest ()->getParam ( 'otype' );
		$datatype = Model_Collection_ObjectTypes::getInstance()->cloneObjectType( $datatype_id );
		if ( ! $datatype and ( APPLICATION_ENV != 'production' ) )
			throw new Exception( 'Ошибка при клонировании типа данных' );
	}
}
