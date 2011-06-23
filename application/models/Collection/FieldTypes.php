<?php
/**
 * 
 * Коллекция типов полей
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: FieldTypes.php 183 2010-05-12 08:36:48Z renat $
 */

class Model_Collection_FieldTypes extends Model_Abstract_Collection {
	
	/**
	 * Разрешает кеширование
	 * @var bool
	 */
	protected $_caching = true;
		
	/**
	 * Конструктор коллекции
	 * Загружает все типы полей
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'FieldType' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_FieldTypes экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных типов полей
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbFieldTypes() {
		return $this->getDbTable( 'Model_DbTable_FieldTypes' );
	}
	
	/**
	 * Возвращает тип поля с указанным id
	 * @param int $id идентификатор
	 * @return Model_Entity_FieldType
	 */
	public function getEntity( $id ) {
		if ( ! $this->isLoaded ( $id ) ) {
			$this->_loadAll();
		}
		return $this->_entities [ $id ];
	}
	
	/**
	 * Возвращает является ли тип поля виртуальным или нет
	 * @param Model_Entity_FieldType $type тип поля
	 * @return bool
	 */
	protected function isNotVirtual( $type ) {
		return ! $type->is_virtual;
	}
	
	/**
	 * Возвращает массив типов полей
	 * @param bool $inc_virtual OPTIONAL включить виртуальные (по-умолчанию true)
	 * @return array
	 */
	public function fetchAll( $inc_virtual=true ) {
		$this->_loadAll();
		if ( $inc_virtual ) {
			return $this->_entities;
		} else {
			return array_filter( $this->_entities, array( $this, 'isNotVirtual' ) );
		}
	}
}