<?php
/**
 * 
 * Абстрактный информационный объект (сущность)
 * наследует стандартный класс строки Zend_Db
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Abstract
 * @version    $Id: Entity.php 183 2010-05-12 08:36:48Z renat $
 */

abstract class Model_Abstract_Entity extends Zend_Db_Table_Row_Abstract {
	
	/**
	 * Возвращает значение int для идентификаторов, string для остальных
	 *
	 * @param  string $columnName колонка
	 * @return int|string         значение
	 * @throws Model_Exception если не существует
	 */
	public function __get($columnName) {
		if (! array_key_exists ( $columnName, $this->_data )) {
			throw new Model_Exception ( "Неизвестное значение '$columnName' " );
		}
		if (preg_match ( '/^i(d|s)(_|$)/', $columnName )) {
			return ( int ) $this->_data [$columnName];
		}
		return $this->_data [$columnName];
	}
	
	/**
	 * Очищает кеш
	 */
	abstract public function removeCache();
	
	/**
	 * Если есть изменения - сохранить в базу 
	 * @return Model_Abstract_Entity $this
	 */
	public function commit() {
		if ( !empty( $this->_modifiedFields ) ) {
			$this->removeCache();
			$this->save();
		}
		return $this;
	}
}