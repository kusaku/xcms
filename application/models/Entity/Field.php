<?php
/**
 * 
 * Поле
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: Field.php 238 2010-07-02 11:43:40Z renat $
 */

class Model_Entity_Field extends Model_Abstract_Entity {
	
	/**
	 * Связь поле - группа полей, используется для новых полей (при создании)
	 * @var Zend_Db_Table_Row
	 */
	protected $_con;
	
	/**
	 * Магический метод используемый при приведении объекта к строке
	 * @return string
	 */
	public function __toString() {
		return (string) $this->title;
	}
	
	/**
	 * Возвращает тип
	 * @return Model_Entity_FieldType
	 */
	public function getType() {
		return Model_Collection_FieldTypes::getInstance()->getEntity( $this->id_type );
	}
	
	/**
	 * Возвращает связь к полю, по-умолчанию создает при ее отсутствии
	 * @param Model_Entity_FieldsGroup $group группа полей
	 * @param bool $create создавать если отсутствует
	 * @return Zend_Db_Table_Row|null
	 */
	public function getFieldController( $group, $create=true ) {
		if ( !isset( $this->_con ) ) {
			if ( $this->id != 0 ) {
				$con_table = Model_Collection_Fields::getInstance()->getDbFieldsController();
				// запрос
				$rows = $con_table->find( $this->id, $group->id );
				if ( $rows->count() > 0 ) {
					// найден
					return $this->_con = $rows->current();
				}
			}
			if ( $create ) {
				// создаем
				return $this->createFieldController( $group );
			} else {
				return null;
			}
		}
		return $this->_con;
	}
	
	/**
	 * Создает связь с группой полей
	 * @param Model_Entity_FieldsGroup $group группа полей
	 * @param int $ord OPTIONAL порядок 
	 * @return Zend_Db_Table_Row
	 */
	public function createFieldController( $group, $ord=null ) {
		return $this->_con = Model_Collection_Fields::getInstance()
			->getDbFieldsController()->createRow( array( 
				'id_field' => $this->id, 
				'id_group' => $group->id, 
				'ord' => $ord 
			) 
		);
	}
	
	/**
	 * Удаляет связь с группой полей
	 * @param Model_Entity_FieldsGroup $group группа полей
	 * @return int число удаленных строк (1)
	 */
	public function delFieldController( $group ) {
		$con = $this->getFieldController( $group, false );
		if ( $con ) {
			$result = $con->delete();
			if ( $result ) $this->_con = null;
			return $result;
		}
		return 0;
	}
	
	/**
	 * Устанавливает значения из массива
	 * @param array $values
	 * @return Model_Entity_FieldType $this
	 */
	public function setValues( $values ) {
		if ( isset($values['title']) and $this->title != $values['title'] ) 
			$this->title = $values['title'];
		if ( isset($values['name']) and $this->name != $values['name'] ) 
			$this->name = $values['name'];
		if ( isset($values['tip']) and $this->tip != $values['tip'] ) 
			$this->tip = $values['tip'];
		if ( isset($values['type']) and $this->id_type != $values['type']=(int)$values['type'] )
			$this->id_type = $values['type'];
		if ( isset($values['guide']) and $this->id_guide != $values['guide']=(int)$values['guide'] )
			$this->id_guide = $values['guide'];
		if ( isset($values['required']) and $this->is_required != $values['required']=(bool)$values['required'] )
			$this->is_required = $values['required'];
		return $this;
	}
	
	/**
	 * Возвращает форму редактирования поля
	 * @todo еще поля, декораторы
	 * @return Zend_Form
	 */
	public function getEditForm() {
		$form = new Admin_Form_Edit();
		$form->addElement( 'text', 'title', array(
			'label' => 'Название',
			'required' => true,
			'filters' => array( 'StringTrim' ),
			'value' => $this->title
		));
		$form->addElement( 'text', 'name', array(
			'label' => 'Идентификатор',
			'required' => true,
			'filters' => array( 'StringTrim' ),
			'validators' => array( array( 'Regex', false, array('/^[a-z0-9_]+$/') ) ),
			'value' => $this->name
		));
		$form->addElement( 'text', 'tip', array(
			'label' => 'Подсказка',
			'value' => $this->tip
		));
		$form->addElement( 'select', 'type', array(
			'label' => 'Тип поля',
			'value' => $this->id_type
		));
		$ft_opt = Model_Collection_FieldTypes::getInstance()->fetchAll( true );
		$form->type->setMultiOptions( $ft_opt );
		$form->addElement( 'select', 'guide', array(
			'label' => 'Справочник',
			'value' => $this->id_guide
		));
		$ot_guides = array( '...' ) + Model_Collection_ObjectTypes::getInstance()->getGuides();
		$form->guide->setMultiOptions( $ot_guides );
		$form->addElement( 'checkbox', 'required', array(
			'label' => 'Обязательное',
			'value' => $this->is_required
		));
		$form->setElementDecorators( array(
			array('Label', array('nameimg' => 'ico_help.gif')), 
			'ViewHelper',
			'Errors',
			array('HtmlTag', array( 'class' => 'halfwidth' ))
		));
		$form->getElement('required')->setDecorators(array(
			'ViewHelper',
			array(array('elementDiv' => 'HtmlTag'), array( 'class' => 'multidiv' )),
			array('Label', array('nameimg' => 'ico_help.gif')),
			'Errors',
			array('HtmlTag', array( 'class' => 'halfwidth'))
		));
		return $form;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
		$cache = Model_Abstract_Collection::getCache();
		$tags = array('FieldsAll', 'Field'.$this->id);
		/* 
		$rows = $this->findManyToManyRowset( 
			Model_Collection_ObjectTypes::getInstance()->getDbFieldGroups(),
			Model_Collection_Fields::getInstance()->getDbFieldsController()
		);
		$tags = array('FieldGroupsAll');
		foreach( $rows as $row ) {
			$tags[] = 'FieldGroup' . $row->id;
		}*/
		$cache->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			$tags
		);
	}
	
	/**
	 * Сохранение в БД
	 * @return Model_Entity_FieldType $this
	 */
	public function commit() {
		if ( !empty( $this->_modifiedFields ) ) {
			if ( $this->is_locked ) { // изменять нельзя, но не прицеплять
				throw new Model_Exception( 'Поле защищено от изменения' );
			}
			//$this->removeCache(); // не используется
			$this->save();
		}
		if ( isset( $this->_con ) ) {
			if ( $this->_con->id_field == 0 ) {
				$this->_con->id_field = $this->id;
			}
			$this->_con->save();
		}
		return $this;
	}
	
	/**
	 * Удаление из БД - не должно использоваться
	 * @return int число удаленных строк
	 */
	public function delete() {
		//$this->removeCache(); // не используется
		$n = parent::delete();
		if ( ( $n > 0 ) and isset( $this->_con ) ) {
			//$n += $this->_con->delete(); // если нет поддержки DRI
			$this->_con = null;
		}
		return $n;
	}
}
