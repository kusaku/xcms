<?php
/**
 * 
 */

class Model_Collection_Blocks extends Model_Abstract_Collection {
	
	protected function __construct() {
		$this->setEntName ( 'Block' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_Blocks экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbBlocks() {
		return $this->getDbTable( 'Model_DbTable_Blocks' );
	}
	
	/**
	 * Возвращает шаблон блока с указанным id
	 * @param int $id идентификатор
	 * @return Model_Collection_Blocks
	 */
	public function getEntity( $id ) {
		if ( ! $this->isLoaded ( $id ) ) {
			$this->_loadAll();
		}
		return $this->_entities [ $id ];
	}
	
	/**
	 * Возращает шаблон блока по названию
	 * @param string $title
	 * @return Model_Collection_Blocks
	 */
	public function getEntityByTitle( $title ) {
		$selectEnt = $this->getDbBlocks()
			->select()
			->where('title=?', $title);
		$entity = $this->getDbBlocks()->fetchRow($selectEnt);
		return $this->getEntity($entity->id);
	}
	
	/**
	 * Создание нового шаблона блока
	 * 
	 */
	public function createBlock( $data=array() ){
		unset( $data['id'] );
		$data['filename'] = mktime();
		$data['title'] = 'Блок ' . date_create()->format( 'd.m.y' );
		$new_object = $this->addEntity( $this->getDbBlocks()->createRow( $data ) );
		return $new_object;
	}
}