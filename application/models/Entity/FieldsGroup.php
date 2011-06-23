<?php
/**
 * 
 * Группа полей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: FieldsGroup.php 238 2010-07-02 11:43:40Z renat $
 */

class Model_Entity_FieldsGroup extends Model_Abstract_Entity {
	
	/**
	 * Массив всех полей группы name=>field
	 * @var array Model_Entity_Field
	 */
	protected $_fields = array();
	
	/**
	 * Порядок последнего поля в группе
	 * @var int
	 */
	protected $_last_ord;

    /**
     * Магический метод используемый используется для передачи ожидаемых данных для сериализации
     * @return array
     */
    public function __sleep() {
    	return array( '_tableClass', '_primary', '_data', '_cleanData', '_readOnly' ,'_modifiedFields', '_fields', '_last_ord' );
    }

    /**
     * Магический метод используемый для восстановления
     * @return void
     */
    public function __wakeup() {
    	$mcf = Model_Collection_Fields::getInstance();
		foreach ( $this->_fields as $field ) {
			$field->setTable( $mcf->getDbFields() );
			if ( ! $mcf->isLoaded( $field->id ) ) {
				$mcf->addEntity( $field );
			}
		}
    }
	
	/**
	 * Возвращает поле по его идентификатору
	 * @param int $id
	 * @return Model_Entity_Field|null
	 */
	public function getFieldById( $id ) {
		$field = Model_Collection_Fields::getInstance()->getEntity( $id );
		if ( isset( $field ) and ($field == $this->getFieldByName($field->name)) ) {
			return $field;
		} else {
			return null;
		}
	}
	
	/**
	 * Возвращает поле по его имени
	 * @param string $name
	 * @return Model_Entity_Field|null
	 */
	public function getFieldByName( $name ) {
		if ( isset( $this->_fields[ $name ] ) ) {
			return $this->_fields[ $name ];
		} else {
			return null;
		}
	}
		
	/**
	 * Возвращает массив полей name=>field
	 * @return array Model_Entity_Field массив полей
	 */
	public function getFields() {
		return $this->_fields;
	}
	
	/**
	 * Возвращает порядок последнего поля в группе
	 * @return int
	 */
	public function getLastOrd() {
		if ( !isset( $this->_last_ord ) ) {
			if ( ( $this->id == 0 ) or empty( $this->_fields ) ) {
				// новая группа полей или полей нет
				return $this->_last_ord = 1;
			} else {
				// запрос
				$table = Model_Collection_Fields::getInstance()
					->getDbFieldsController();
				$last = $this->findDependentRowset( 
					$table, null, 
					$table->select()->order( 'ord DESC' )->limit(1)
				)->current();
				if ( isset( $last ) ) {
					return $this->_last_ord = (int) $last->ord;
				} else {
					return $this->_last_ord = 1;
				}
			}
		}
		return $this->_last_ord;
	}
	
	/**
	 * Добавляет новое поле в группу
	 * @param Model_Entity_Field $field добавляемое поле
	 * @return Model_Entity_Field поле
	 */
	public function addField( $field ) {
		return $this->_fields[ $field->name ] = $field;
	}
	
	/**
	 * Создает новое поле
	 * @param array $data OPTIONAL
	 * @return Model_Entity_Field поле
	 */
	public function createField( $data=array() ) {
		unset( $data ['id'] );
		$mcf = Model_Collection_Fields::getInstance(); // коллекция полей
		$field = $mcf->getDbFields()->createRow( $data );
		return $this->attachField( $field );
	}
	
	/**
	 * Добавляет существующее поле в группу
	 * @param Model_Entity_Field $field поле
	 * @return Model_Entity_Field поле
	 */
	public function attachField( $field ) {
		// Создаем связь группа - поле
		$field->createFieldController( $this, $this->getLastOrd() );
		$this->_last_ord++;
		return $this->addField( $field );
	}
	
	/**
	 * Удаляет поле из группы
	 * @param int $field_id
	 * @return int число удаленных (1)
	 */
	public function detachField( $field_id ) {
		$this->removeCache();
		return $this->getFieldById( $field_id )->delFieldController( $this );
	}
	
	/**
	 * Инициализация
	 */
	public function init() {
		$this->_loadFields();
	}
	
	/**
	 * Загружает поля в группу
	 * @return Model_Entity_FieldsGroup $this
	 */
	protected function _loadFields() {
		$mcf = Model_Collection_Fields::getInstance(); // коллекция полей
		$fields = $this->findManyToManyRowset( 
			$mcf->getDbFields(),           // целевая таблица
			$mcf->getDbFieldsController(), // таблица пересечений
			null, null, 
			$this->select()->order( 'ord' ) 
		);
		$this->_fields = array ();
		foreach ( $fields as $field ) {
			$this->addField( $mcf->addEntity( $field ) ); // + в коллекцию
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
		if ( isset($values['name']) and $this->name != $values['name'] ) 
			$this->name = $values['name'];
		if ( isset($values['visible']) and $this->is_visible != $values['visible']=(bool)$values['visible'] ) 
			$this->is_visible = $values['visible'];
		return $this;
	}
	
	/**
	 * Возвращает форму редактирования типа объекта (в разработке)
	 * @todo еще поля, декораторы
	 * @return Zend_Form
	 */
	public function getEditForm() {
		$form = new Admin_Form_Edit();
		$form->addElement( 'text', 'title', array(
			'label' => 'Название',
			'required' => true,
			'value' => $this->title
		));
		$form->addElement( 'text', 'name', array(
			'label' => 'Идентификатор',
			'required' => true,
			'filters' => array( 'StringTrim' ),
			'validators' => array( array( 'Regex', false, array('/^[a-z0-9_]+$/') ) ),
			'value' => $this->name
		));
		$form->addElement( 'checkbox', 'visible', array(
			'label' => 'Открыть по умолчанию',
			'value' => $this->is_visible
		));
		$form->setElementDecorators( array(
			array('Label', array('nameimg' => 'ico_help.gif')), 
			'ViewHelper',
			'Errors',
			array('HtmlTag', array( 'class' => 'halfwidth' ))
		));
		$form->getElement('visible')->setDecorators(array(
			'ViewHelper',
			array(array('elementDiv' => 'HtmlTag'), array( 'class' => 'multidiv' )),
			array('Label', array('nameimg' => 'ico_help.gif')),
			'Errors',
			array('HtmlTag', array( 'class' => 'halfwidth'))
		));
		return $form;
	}
	
	/**
	 * Очищает кеш (не используется)
	 * @return void
	 */
	public function removeCache() {
		/*$cache = Model_Abstract_Collection::getCache();
		$tags = array('FieldGroupsAll', 'FieldGroup'.$this->id, 'ObjectType'.$this->id_obj_type);
		$cache->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			$tags
		);*/
	}
	
	/**
	 * Сохранение в БД
	 * @return Model_Entity_FieldsGroup $this
	 */
	public function commit() {
		if ( $this->is_locked ) {
			throw new Model_Exception( 'Группа полей защищена от изменения' );
		}
		$is_new = false;
		if ( !empty( $this->_modifiedFields ) ) {
			$is_new = ( $this->id == 0 );
			$this->save();
		}
		foreach ( $this->_fields as $field ) {
			if ( $is_new ) {
				$con = $field->getFieldController( $this );
				$con->id_group = $this->id;
			}
			$field->commit();
		}
		return $this;
	}
	
	/**
	 * Удаление из БД группы полей 
	 * @return int число удаленных строк
	 */
	public function delete() {
		/*foreach ( $this->_fields as $field ) { // если нет поддержки DRI
			// нельзя удалить поля т.к они могут использоваться другими группами
			$n += $this->detachField( $field );  // если нет поддержки DRI
		}*/
		return parent::delete();
	}
}
