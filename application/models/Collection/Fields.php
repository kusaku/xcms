<?php
 /**
 * 
 * Коллекция полей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: Fields.php 201 2010-06-04 14:01:07Z renat $
 */

class Model_Collection_Fields extends Model_Abstract_Collection {
	
	/**
	 * Массив используется для поиска в коллекции
	 * @var array
	 */
	protected $_index = array();
		
	/**
	 * Конструктор коллекции
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'Field' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_Fields экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
		
	/**
	 * Возвращает интерфейс доступа к таблице данных полей
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbFields() {
		return $this->getDbTable( 'Model_DbTable_Fields' );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице пересечений Поля-Группы
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbFieldsController() {
		return $this->getDbTable( 'Model_DbTable_FieldsController' );
	}
	
	/**
	 * Добавляет информационный объект в коллекцию
	 * @param Model_Entity_Field $row
	 * @return Model_Entity_Field
	 */
	public function addEntity( $entity ) {
		$this->_index['name'][ $entity->name ] = $entity->id;
		return parent::addEntity( $entity );
	}
	
	/**
	 * Возвращает идентификатор поля по его имени
	 * @param $name имя поля
	 * @return int|null
	 */
	public function getFieldIdByName( $name ) {
		if ( ! isset( $this->_index['name'][ $name ] ) ) {
			$table = $this->getDbFields();
			$field = $table->fetchRow( $table->select()->where( 'name = ?', $name ) );
			if ( isset( $field ) ) {
				$this->addEntity( $field );
				return $field->id;
			}
		} else {
			return $this->_index['name'][ $name ];
		}
		return null; // fail
	}
}