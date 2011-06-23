<?php
/**
 * 
 * Свойство объекта
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: Property.php 623 2011-01-18 12:48:46Z kifirch $
 */

class Model_Entity_Property extends Model_Abstract_Entity {
	
	const INVALID_WRAPPER = 'Некорректный wrapper при попытке получить значение виртуального свойства';
	
	/**
	 * Имя типа поля свойства
	 * @var string
	 */
	protected $_typename;
    
	/**
	 * Возвращает поле свойства объекта
	 * @return Model_Entity_Field поле
	 */
	public function getField() {
		return Model_Collection_Fields::getInstance()->getEntity( $this->id_field );
	}
	
	/**
	 * Возвращает объект которому принадлежит данное свойство
	 * @return Model_Entity_Object объект
	 */
	public function getObject() {
		return Model_Collection_Objects::getInstance()->getEntity( $this->id_obj );
	}
	
	/**
	 * Возвращает имя типа поля свойства объекта
	 * @return string имя типа поля
	 */
	public function getTypeName() {
		if ( !isset( $this->_typename ) ) {
			$this->_typename = $this->getField()->getType()->name;
		}
		return $this->_typename;
	}
	
	/**
	 * Инициализация
	 */
	public function init() {
		if ( empty( $this->_cleanData ) ) {
			$this->_modifiedFields[ 'id_obj' ] = true;
			$this->_modifiedFields[ 'id_field' ] = true;
		}
	}
	
	/**
	 * Возвращает флаг того, что свойство не сохраняется в БД
	 * Для виртуальных свойств переопределить в дочернем классе
	 * @return bool
	 */
	public function isVirtual() {
		return (bool) $this->getField()->getType()->is_virtual;
	}

        /**
         * Возвращает флаг того, что свойтсво наследуемое
         * @return bool
         */
        public function isInheritable() {
            return (bool) $this->getField()->is_inheritable;
        }


        /**
	 * Устанавливает значение свойства
	 * Необходимо переопределить в дочернем классе
	 * @throws всегда выбрасывает исключение
	 */
	public function setValue($value) {
		throw new Model_Exception( "Запрещенное обращение к свойству базового типа" );
	}
	
	/**
	 * Возвращает значение свойства
	 * Необходимо переопределить в дочернем классе
	 * @throws всегда выбрасывает исключение
	 */
	public function getValue() {
		throw new Model_Exception( "Запрещенное обращение к свойству базового типа" );
	}
	
	/**
	 * Возвращает элемент формы для свойства
	 * Необходимо переопределить в дочернем классе
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		return new Zend_Form_Element( $this->getField()->name );
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
	}
	
	/**
	 * Сохраняет значение невиртуального свойства
	 * @return Model_Entity_Property $this
	 */
	public function commit() {
            if ( !$this->isVirtual() ) {
                    $this->save();
            }
            return $this;
	}
}