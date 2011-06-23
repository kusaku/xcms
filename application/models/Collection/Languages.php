<?php
/**
 * 
 * Коллекция языков
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: Languages.php 176 2010-04-20 11:54:36Z renat $
 */

class Model_Collection_Languages extends Model_Abstract_Collection {
	
	/**
	 * Идентификатор языка по умолчанию
	 * @var int
	 */
	protected $_default;
		
	/**
	 * Конструктор коллекции
	 * Загружает все языки
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'Language' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_Languages экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbLanguages() {
		return $this->getDbTable( 'Model_DbTable_Languages' );
	}
	
	/**
	 * Возвращает язык с указанным id
	 * @param int $id идентификатор
	 * @return Model_Entity_Language
	 */
	public function getEntity( $id ) {
		if ( ! $this->isLoaded ( $id ) ) {
			$this->_loadAll();
		}
		return $this->_entities [ $id ];
	}
	
	/**
	 * Возвращает язык поумолчанию
	 * @return Model_Entity_Language
	 */
	public function getDefault() {
		if ( ! isset( $this->_default ) ) {
			$table = $this->getDbLanguages();
			$this->addEntity( $table->fetchRow(
				$table->select()->where( 'is_default = ?', 1 )
			) );
		}
		return $this->_entities[ $this->_default ];
	}
	
	/**
	 * Добавляет язык в коллекцию
	 * @param Model_Entity_Language $entity
	 * @return Model_Entity_Language
	 */
	public function addEntity( $entity ) {
		if ( $entity->is_default ) {
			$this->_default = $entity->id;
		}
		return $this->_entities [ $entity->id ] = $entity;
	}
}