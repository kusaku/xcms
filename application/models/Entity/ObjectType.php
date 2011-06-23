<?php
/**
 * 
 * Тип объекта
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: ObjectType.php 241 2010-07-16 12:24:37Z renat $
 */

class Model_Entity_ObjectType extends Model_Abstract_Entity {
	
	/**
	 * Флаг "все группы полей загружены"
	 * @var bool
	 */
	protected $_loaded = false;
	
	/**
	 * Массив всех групп полей типа объекта name=>group
	 * @var array Model_Entity_FieldsGroup
	 */
	protected $_groups = array();
		
	/**
	 * Массив используется для поиска
	 * @var array
	 */
	protected $_index = array();
	
	/**
	 * Магический метод используемый при приведении объекта к строке
	 * @return string
	 */
	public function __toString() {
		return $this->title;
	}

    /**
     * Магический метод используемый при сериализации
     * @return array
     */
    public function __sleep() {
    	return array( '_tableClass', '_primary', '_data', '_cleanData', '_readOnly' ,'_modifiedFields', '_loaded', '_groups', '_index' );
    }

    /**
     * Магический метод используемый для восстановления
     * @return void
     */
    public function __wakeup() {
		foreach ( $this->_groups as $group ) {
			$group->setTable( Model_Collection_ObjectTypes::getInstance()->getDbFieldGroups() );
		}
    }
	
	/**
	 * Возвращает, загружены ли группы полей
	 * @return bool
	 */
	public function isLoaded() {
		return $this->_loaded;
	}
	
	/**
	 * Возвращает родительский тип
	 * @return Model_Entity_ObjectType|null родитель
	 */
	public function getParent() {
		if ( !empty( $this->id_parent ) ) {
			return Model_Collection_ObjectTypes::getInstance()
				->getEntity( $this->id_parent );
		} else {
			return null;
		}
	}
	
	/**
	 * Возвращает соответствующий тип элементов
	 * @return Model_Entity_ElementType|null тип элементов
	 */
	public function getElementType() {
		if ( !empty( $this->id_element_type ) ) {
			return Model_Collection_ElementTypes::getInstance()
				->getEntity( $this->id_element_type );
		} else {
			return null;
		}
	}
	
	/**
	 * Возвращает массив групп полей
	 * @return array массив групп полей name=>Model_Entity_FieldsGroup
	 */
	public function getFieldGroups() {
		$this->_loadFieldGroups();
		return $this->_groups;
	}
			
	/**
	 * Проверяет, загружена ли группа полей с данным именем
	 * @param string $name имя группы полей
	 * @return bool
	 */
	public function isFieldsGroupLoaded ( $name ) {
		return array_key_exists($name, $this->_groups);
	}

	/**
	 * Возвращает группу полей по идентификатору
	 * @param int $group_id идентификатор группы полей
	 * @return Model_Entity_FieldsGroup
	 */
	public function getFieldsGroupById( $group_id ) {
		$group_name = $this->getFieldsGroupNameById( $group_id );
		if ( isset( $this->_groups[ $group_name ] ) ) {
			return $this->_groups[ $group_name ];
		}
		return null;
	}
	
	/**
	 * Возвращает имя группы полей по идентификатору
	 * @param int $id
	 * @return string|null
	 */
	public function getFieldsGroupNameById( $id ) {
		$this->_loadFieldGroups();
		if ( isset( $this->_index['groupid'][ $id ] ) ) {
			return $this->_index['groupid'][ $id ];
		}
		return null;
	}
	
	/**
	 * Возвращает идентификатор группы полей по имени
	 * @param string $name
	 * @return int|null
	 */
	public function getFieldsGroupIdByName( $name ) {
		$this->_loadFieldGroups();
		if ( isset( $this->_groups[ $name ] ) ) {
			return $this->_groups[ $name ]->id;
		}
		return null;
	}
	
	/**
	 * Создает новую группу полей
	 * @param array $data OPTIONAL
	 * @return Model_Entity_FieldsGroup
	 */
	public function createFieldsGroup( $data=array() ) {
		unset( $data ['id'] );
		$data[ 'id_obj_type' ] = $this->id;
		$mcot = Model_Collection_ObjectTypes::getInstance();
		$group = $mcot->getDbFieldGroups()->createRow( $data );
		return $this->addFieldsGroup( $group );
	}
	
	/**
	 * Удаляет группу полей
	 * @todo удаление группы полей из дочерних типов ?
	 * @param int $group_id идентификатор удаляемой группы полей
	 * @param bool $and_children удалить также из всех дочерних типов
	 * @return int число удаленных строк
	 */
	public function delFieldsGroup( $group_id, $and_children=false ) {
		$group_name = $this->getFieldsGroupNameById( $group_id );
		if ( !isset( $group_name ) ) return 0;
		$c = Model_Collection_Fields::getInstance();
		Main::logDebug( $c->getDbFieldsController()->fetchAll()->count() );
		$result = $this->_groups[ $group_name ]->delete();
		Main::logDebug( $c->getDbFieldsController()->fetchAll()->count() );
		if ( $result ) {
			// TODO удаление группы полей из дочерних типов ?
			$this->_groups[ $group_name ] = null;
		}
		return $result;
	}
	
	/**
	 * Добавляет группу полей
	 * @param $group Model_Entity_FieldsGroup
	 * @return Model_Entity_FieldsGroup
	 */
	public function addFieldsGroup( $group ) {
		$this->_index['groupid'][ $group->id ] = $group->name;
		return $this->_groups[ $group->name ] = $group;
	}
	
	/**
	 * Инициализация
	 */
	public function init() {
	}
	
	/**
	 * Копирует все группы полей из заданного типа в текущий
	 * @param Model_Entity_ObjectType $from_type
	 * @return Model_Entity_ObjectType $this
	 */
	public function copyFieldGroups( $from_type ) {
		$groups = & $from_type->getFieldGroups();
		foreach ( $groups as $id=>$group ) {
			// Для каждого типа - группы полей свои
			$this->_copyFieldsGroup( $group );
		}
		return $this;
	}
	
	/**
	 * Копирует группу полей в текущий тип объекта
	 * Копируемая группа полей должна быть сохранена в БД 
	 * @param Model_Entity_FieldsGroup $from_group
	 * @return Model_Entity_FieldsGroup новая группа
	 */
	protected function _copyFieldsGroup( $from_group ) {
		// Создаем новую группу полей
		$data = $from_group->toArray();
		unset( $data[ 'id' ] );
		$data[ 'id_obj_type' ] = $this->id;
		$data[ 'is_locked' ] = 0;
		$new_group = $this->addFieldsGroup( 
			$from_group->getTable()->createRow( $data ) 
		);
		// Поля: создаем связи
		$fields = $from_group->getFields();
		foreach ( $fields as $field ) {
			$new_group->attachField( $field );
		}
		return $new_group;
	}
	
	/**
	 * Загружает группы полей типа объекта из БД, если они не загружены
	 * @return Model_Entity_ObjectType $this
	 */
	protected function _loadFieldGroups() {
		if ( ! $this->isLoaded() ) {
			$mcot = Model_Collection_ObjectTypes::getInstance(); // коллекция типов объектов
			$groups = $this->findDependentRowset( 
				$mcot->getDbFieldGroups(), 
				null, 
				$this->select()->order( 'ord' ) 
			);
			$this->_groups = array ();
			foreach ( $groups as $group ) {
				$this->addFieldsGroup( $group );
			}
			$this->_loaded = true;
			Model_Abstract_Collection::getCache()
				->save( $this, 'ObjectType'.$this->id, array('ObjectType'.$this->id, 'ObjectTypes') );
		}
		return $this;
	}
	
	/**
	 * Устанавливает значения из массива
	 * @param array $values
	 * @return Model_Entity_ObjectType $this
	 */
	public function setValues( $values ) {
		if ( isset($values['title']) and $this->title != $values['title'] ) 
			$this->title = $values['title'];
		if ( isset($values['element_type']) and $this->id_element_type != $values['element_type']=(int)$values['element_type'] )
			$this->id_element_type = $values['element_type'];
		if ( isset($values['public']) and $this->is_public != $values['public']=(bool)$values['public'] )
			$this->is_public = $values['public'];
		return $this;
	}
	
	/**
	 * Возвращает форму редактирования типа объекта (в разработке)
	 * @todo еще поля, декораторы
	 * @return Zend_Form
	 */
	public function getEditForm() {
		$form = new Admin_Form_Edit();
		$form->addElement( 'hidden', 'otype', array(
			'value' => $this->id
		));
		$form->addElement( 'text', 'title', array(
			'label' => 'Название',
			'required' => true,
			'value' => $this->title,
			'description' => 'Название типа данных'
		));
		$form->addElement( 'select', 'element_type', array(
			'label' => 'Назначение типа',
			'value' => $this->id_element_type,
			'description' => 'Выбрать назначение типа'
		));
		$et_opt = Model_Collection_ElementTypes::getInstance()->getPublic();
		$et_opt = array( '...' ) + $et_opt;
		$form->element_type->setMultiOptions( $et_opt );
		$form->addElement( 'checkbox', 'public' , array( 
			'label' => 'Общедоступный',
			'value' => $this->is_public,
			'description' => 'Общедоступный'
		));
		$form->setElementDecorators( array(
			array('Label', array('nameimg' => 'ico_help.gif')), 
			'ViewHelper',
			'Errors',
			array('HtmlTag', array( 'class' => 'fullwidth_content' ))
		));
		$form
			->addDisplayGroup( 
				array( 'title', 'element_type', 'public', 'save', 'save_exit', 'cancel' ), 
				'common', 
				array('description' => 'Тип данных' )
			)
			->addDisplayGroupButtons( 'common', ($this->id ? 'edit' : 'add' ) )
		;
		if ( $this->id != 0 ) {
			$form->addDisplayGroup(
				array( 'otype' ),
				'fields',
				array('description' => 'Поля' )
			);
		}
		return $form;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
		$cache = Model_Abstract_Collection::getCache();
		$tags = array('ObjectTypesAll', 'ObjectType'.$this->id);
		$cache->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			$tags
		);
	}
	
	/**
	 * Сохранить в базу созданный тип объекта
	 * @return Model_Entity_ObjectType $this
	 */
	public function commit() {
		if ( $this->is_locked ) {
			throw new Model_Exception( 'Тип данных защищен от изменения' );
		}
		$this->removeCache();
		$db = $this->getTable()->getAdapter()->beginTransaction();
		try{
			if ( !empty( $this->_modifiedFields ) ) {
				$this->save();
			}
			foreach ( $this->_groups as $group ) {
				if ( $group->id_obj_type == 0 ) {
					// Если новый, то у его групп id_obj_type == 0
					$group->id_obj_type = $this->id;
					// TODO вставить также во все дочерние типы?
//					$mcot = Model_Collection_ObjectTypes::getInstance();
//					$children = $mcot->getChildrenList( $this->id );
//					foreach ( $children as $child ) {
//						$child->copyFieldsGroup( $group );
//						$child->commit();
//					}
				}
				$group->commit();
			}
			$db->commit();
		} catch ( Exception $e ) {
			$db->rollBack();
			throw new Model_Exception( $e );
		}
		return $this;
	}
	
	/**
	 * Удаление из БД типа данных 
	 * @return int число удаленных строк
	 */
	public function delete() {
		$this->removeCache();
		$db = $this->getTable()->getAdapter()->beginTransaction();
		try {
			/*$this->_loadFieldGroups(); // удаляем группы если нет поддержки DRI
			foreach ( $this->_groups as $group ) {
				$group->delete(); // ZDT не поддерживает множественные каскады - удаляем сами
			}*/
			parent::delete();
			return $db->commit();
		} catch ( Exception $e ) {
			$db->rollBack();
			throw new Model_Exception( $e );
		}
	}
}