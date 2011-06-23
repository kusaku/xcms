<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ShopOrderInfo
 *
 * @author aleksey.f
 */
class Model_Collection_ShopOrderInfo extends Model_Abstract_Collection {

    protected function __construct() {
		$this->setEntName ( 'ShopOrderInfo' );
	}

	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_ShopOrderInfo экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}

	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbShopOrderInfo() {
		return $this->getDbTable( 'Model_DbTable_ShopOrderInfo' );
	}

        /**
	 * Возвращает шаблон блока с указанным id
	 * @param int $id идентификатор
	 * @return Model_Collection_ShopOrderInfo
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
	 * @return array
	 */
	public function getEntityByOrder( $id_order ) {
		$selectEnt = $this->getDbShopOrderInfo()
			->select()
			->where('id_order=?', $id_order);
		$entities = $this->getDbShopOrderInfo()->fetchAll($selectEnt);
		return $entities;
	}
      
        
        
	/**
	 * Добавление нового заказа
	 * return Model_Entity_ShopOrderInfo
	 */
	public function addOrderInfo( $data=array() ){
                unset($data['id']);
		$new_object = $this->addEntity( $this->getDbShopOrderInfo()->createRow( $data ) );
		return $new_object;
	}

}
?>
