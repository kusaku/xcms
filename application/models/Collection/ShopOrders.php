<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ShopOrders
 *
 * @author aleksey.f
 */
class Model_Collection_ShopOrders extends Model_Abstract_Collection {

    protected function __construct() {
		$this->setEntName ( 'ShopOrder' );
	}

	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_ShopOrders экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}

	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbShopOrders() {
		return $this->getDbTable( 'Model_DbTable_ShopOrders' );
	}

        /**
	 * Возвращает шаблон блока с указанным id
	 * @param int $id идентификатор
	 * @return Model_Collection_ShopOrders
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
	public function getEntityByObject( $id_obj ) {
		$selectEnt = $this->getDbShopOrders()
			->select()
			->where('id_obj=?', $id_obj);
		$entity = $this->getDbShopOrders()->fetchRow($selectEnt);
		return $this->getEntity($entity->id);
	}

	/**
	 * Добавление нового заказа
	 *
	 */
	public function addOrder( $data=array() ){
		unset( $data['id'] );
		$new_object = $this->addEntity( $this->getDbShopOrders()->createRow( $data ) );
		return $new_object;
	}

        
        public function getOrdersUsers() {
            $selectEnt = $this->getDbShopOrders()
                    ->select()->from($this->getDbTable()) ->distinct()->columns(array('id_user'));
            $entities = $this->getDbShopOrders()->fetchAll($selectEnt);
            return $entities;
            
        }
        
        public function getUserOrders($user_id) {
            $selectEnt = $this->getDbShopOrders()
                    ->select()->where('id_user=?',$user_id);
            $entities = $this->getDbShopOrders()->fetchAll($selectEnt);
            return $entities;
        }
}
?>
