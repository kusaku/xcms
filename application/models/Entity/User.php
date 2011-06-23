<?php
/**
 * 
 * Пользователь
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: User.php 191 2010-05-21 09:59:29Z igor $
 */

class Model_Entity_User extends Model_Abstract_Entity {
	
	/**
	 * Объект
	 * @var Model_Entity_Object
	 */
	protected $_object;
	
	/**
	 * Возвращает объект
	 * @return Model_Entity_Object
	 */
	public function getObject() {
		if ( !isset( $this->_object ) ) {
			$this->_object = Model_Collection_Objects::getInstance()->getEntity( $this->id_object );
		}
		return $this->_object;
	}
	
	/**
	 * Магический метод используемый при приведении объекта к строке,
	 * возвращает имя пользователя
	 * @return string
	 */
        public function __toString()
        {
                    return (string) $this->getObject()->title;
        }
	
	/**
	 * Возвращает значение свойства по имени поля
	 * @param string $field_name
	 * @return mixed
	 */
	public function getValue( $field_name ) {
		$property = $this->getObject()->getPropertyByName( $field_name );
		return $property->isVirtual() ? $property->getValue( $this ) : $property->getValue();
	}
	
	/**
	 * Устанавливает значение свойства
	 * @param string $field_name
	 * @param mixed $value
	 * @return Model_Entity_User $this
	 */
	public function setValue( $field_name, $value ) {
		$property = $this->getObject()->getPropertyByName( $field_name );
		if ( isset( $property ) ) {
			if ( $property->isVirtual() ) {
				$property->setValue( $value, $this );
			} else {
				$property->setValue( $value );
			}
		} else {
			throw new Model_Exception ( "Ошибка при присвоении значения свойству '$field_name' " );
		}
		return $this;
	}
	
	/**
	 * Устанавливает значения свойств из массива
	 * @param array $values массив значений: имя_поля => значение
	 * @return Model_Entity_User $this
	 */
	public function setValues( $values ) {
		foreach ( $values as $name=>$value ) {
			$property = $this->getObject()->getPropertyByName( $name );
			if ( isset( $property ) ) {
				$this->setValue( $name, $value );
			}
		}
		return $this;
	}
	
	/**
	 * Возвращает значения свойств
	 * @param bool $inc_nonpublic OPTIONAL включить в результаты не публичные данные
	 * @todo Метод getValues объекта данных возвращает не все свойства - возможно изм. метод loadProperties чтобы использовать getValues объекта
	 * @return array массив значений: имя_поля => значение
	 */
	public function getValues( $inc_nonpublic=false ) {
		$groups = $this->getObject()->getPropertyGroups();
		$values = array();
		foreach ( $groups as $group ) {
			foreach ( $group as $field_id ) {
				$field = $this->getObject()->getPropertyById( $field_id )->getField();
				if ( $inc_nonpublic or $field->is_public ) {
					$values[ $field->name ] = $this->getValue( $field->name ); // исп. метод элемента
				}
			}
		}
		return $values;
	}
		
	/**
	 * Возвращает форму редактирования объекта
	 * @return Zend_Form
	 */
	public function getEditForm() {
		$form = new Admin_Form_Edit();
		$object = $this->getObject();
		$groups = $object->getPropertyGroups();
		foreach ( $groups as $group_id => $property_ids ) {
			$names = array();
			// поля
			foreach ( $property_ids as $property_id ) {
				$property = $object->getPropertyById( $property_id );
				$form->addElement( $property->getFormElement() );
				$names[] = $property->getField()->name;
			}
			$group = $object->getPropertyGroupById( $group_id );
		}
		$form->setDefaults( $this->getValues( true ) );
		if ( $this->id != 0 ) {
			$form->getElement( 'user_password' )->setRequired( false );
		}
		return $form;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
	}
	
	/**
	 * Сохранить в базу все изменения
	 * @return Model_Entity_User $this
	 */
	public function commit() {
		$db = $this->getTable()->getAdapter()->beginTransaction();
		try {
			$this->getObject()->commit();
			if ( $this->id_object == 0 ) {
				$this->id_object = $this->getObject()->id;
			}
			if ( !empty( $this->_modifiedFields ) ) {
				$this->save();
			}
			$db->commit();
		} catch ( Exception $e ) {
			$db->rollBack();
			throw new Model_Exception( $e );
		}
		return $this;
	}
}