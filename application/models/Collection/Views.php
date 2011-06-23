<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Views
 *
 * @author kifirch
 */
class Model_Collection_Views extends Model_Abstract_Collection {

	protected function __construct() {
		$this->setEntName ( 'View' );
	}

	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_View экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}

	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbViews() {
		return $this->getDbTable( 'Model_DbTable_Views' );
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
	 * Возращает шаблоны блока по типу
	 * @param string $title
	 * @return array of Model_Collection_View
	 */
	public function getEntitiesByType( $id_type ) {
		$selectEnt = $this->getDbViews()
			->select()
			->where('id_etype=?', (int) $id_type);
		$rows = $this->getDbViews()->fetchAll($selectEnt);
                $items = array();
		foreach ( $rows as $row ) {
			$items[ $row->id ] = $this->addEntity( $row );
		}
		return $items;
	}

	/**
	 * Создание нового шаблона блока
	 *
	 */
	public function createView( $data=array() ){
		unset( $data['id'] );
		$data['filename'] = mktime();
		$data['title'] = 'Вид ' . date_create()->format( 'd.m.y' );
		$new_object = $this->addEntity( $this->getDbViews()->createRow( $data ) );
		return $new_object;
	}
}
?>
