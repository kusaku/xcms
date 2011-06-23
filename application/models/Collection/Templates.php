<?php
/**
 * 
 * Коллекция шаблонов
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: Templates.php 176 2010-04-20 11:54:36Z renat $
 */

class Model_Collection_Templates extends Model_Abstract_Collection {
	
	/**
	 * Идентификатор шаблона по умолчанию
	 * @var int
	 */
	protected $_default;
	
	/**
	 * Конструктор коллекции
	 * Загружает все шаблоны
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'Template' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_Templates экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbTemplates() {
		return $this->getDbTable( 'Model_DbTable_Templates' );
	}
	
	/**
	 * Возвращает шаблон с указанным id
	 * @param int $id идентификатор
	 * @return Model_Collection_Templates
	 */
	public function getEntity( $id ) {
		if ( ! $this->isLoaded ( $id ) ) {
			$this->_loadAll();
		}
		return $this->_entities [ $id ];
	}
	
	/**
	 * Возвращает шаблон поумолчанию
	 * @return Model_Entity_Template
	 * @todo учитывать текущий язык
	 */
	public function getDefault() {
		if ( ! isset( $this->_default ) ) {
			$table = $this->getDbTemplates();
			$this->addEntity( $table->fetchRow(
				$table->select()->where( 'is_default = 1' )
			) );
		}
		return $this->_entities[ $this->_default ];
	}
	
	/**
	 * Устанавливает шаблон по умолчанию
	 * @param int $id
	 * @return Model_Collection_Templates $this
	 */
	public function setDefault( $id ) {
		if ( $id != $this->_default ) {
			$new = $this->getEntity( $id );
			if ( isset ( $new ) ) {
				$old = $this->getDefault();
				$old->is_default = 0;
				$old->commit();
				$new->is_default = 1;
				$new->commit();
				$this->_default = $id;
			}
		}
		return $this;
	}
	
	/**
	 * Добавляет шаблон в коллекцию
	 * @param Model_Entity_Template $entity
	 * @return Model_Entity_Template
	 */
	public function addEntity( $entity ) {
		if ( $entity->is_default ) {
			$this->_default = $entity->id;
		}
		return $this->_entities [ $entity->id ] = $entity;
	}
	
	/**
	 * Создание нового шаблона
	 * 
	 */
	public function createTemplate( $data=array() ){
		unset( $data['id'] );
		$data['id_lang'] = Main::getCurrentLanguage()->id;
		$data['filename'] = mktime();
		$data['title'] = 'Шаблон ' . date_create()->format( 'd.m.y' );
		$new_object = $this->addEntity( $this->getDbTemplates()->createRow( $data ) );
		return $new_object;
	}
}