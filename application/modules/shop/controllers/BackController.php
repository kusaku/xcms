<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля каталога
 * 
 * @category   Xcms
 * @package    Catalog
 * @subpackage Controller
 * @version    $Id:
 */

class Shop_BackController extends Xcms_Controller_Back {
	
	public function  preDispatch() {
            $catalog = $this->getRequest ()->getParam ( 'category' ) ;
            $orders = $this->getRequest ()->getParam ( 'orders' );
            $users = $this->getRequest()->getParam('users');
            $orderinfo = $this->getRequest()->getParam('orderinfo');
            $userorders = $this->getRequest()->getParam('userorders');
            if(isset($catalog)) {
                $this->type = 1;
            } elseif(isset($orders)) {
                $this->type = 2;
            } elseif(isset($users)) {
                $this->type = 3;
            } elseif(isset($orderinfo)) {
                $this->type = 4;
            } else {
                $this->type = 5;
            }
        }


        
        /**
	 * Дочерние элементы структуры
	 * @return void
	 */
	public function getAction() {
            switch($this->type) {
                case 1://Каталог
                    $this->_forward( 'getcatalog' );
                    break;
                case 2:// Заказы
                    $this->_forward( 'getorders' );
                    break;
                case 3:// Клиенты
                    $this->_forward( 'getusers' );
                    break;
                case 4:// Информация о заказе
                    $this->_forward('getorderinfo');
                    break;
                case 5://
                    $this->_forward('getusersorders');
                    break;
            }
        }
        
	
        /**
         * Получение дерева каталога
         */
        public function getcatalogAction() {
	        $category_id = ( int ) $this->getRequest ()->getParam ( 'category' );
	        if( empty($category_id) ) $category_id = 0;
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'category');
			if ( isset($type) ) {
				$cat_type_id = $type->id;
			} else {
				throw new Exception( 'Тип данных категория магазина не существует' );
			}
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'item');
			if ( isset($type) ) {
				$item_type_id = $type->id;
			} else {
				throw new Exception( 'Тип данных элемент каталога не существует' );
			}
			$mce = Model_Collection_Elements::getInstance ();
			$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
			$options = $bootstraps['shop']->getModuleOptions();
			$actions = $options['actions'];
			if(!$category_id>0) {
			    $categories = $mce->getChildren ( $category_id, 2, $cat_type_id );
			    $data = array();
			    foreach ( $categories as $k => $have ) {
				    $category = $mce->getElement ( $k );
				    $categoryClass = $category->getType()->getElementClass();
				    if ( ! $category->isReadable() ) continue;
				    $count_items = count($mce->getChildren ( $k, 1));
				    if( $count_items > 0 )
					    $expandable = true;
				    else
					    $expandable = ! empty ( $have );
				    $data[] = array (
					    'id' => $category->id,
					    'title' => $category->getObject()->title,
					    'expandable' => $expandable,
					    'count' => count( $have ),
					    'elementClass' => $categoryClass,
					    'controller' => 'shop',
					    'element' => 'category',
					    'actions'=>$actions['category'],
					    //'accept' => '.shop_item, .shop_category'
				    );
			    }
			} else {
			    $categories_items = $mce->getChildren ( $category_id, 1, $item_type_id );
			    foreach ( $categories_items as $k => $catalog_item ) {
					    $items = $mce->getElement ( $k );
					    $itemsClass = $items->getType()->getElementClass();
					    if ( ! $items->isReadable() ) continue;
					    if($itemsClass == 'shop_category') {
						    $id= $items->id;
						    $class = 'category';
					    }
					    else{
							$id = $items->id;
							$class = 'orders';
					    }
					    $data[] = array(
						    'id' => $id,
						    'title' => $items->getObject()->title,
						    'expandable' => false,
						    'elementClass' => $itemsClass,
						    'controller' => 'shop',
						    'element' => $class,
						    'actions'=>$actions['orders'], //Костыль
						    'accept' => ''
					    );
			    }
			}
            $this->getResponse()->setBody( $this->view->json( $data ) );
        }
        
        /**
         * Получение списка заказов
         */
        public function getordersAction() {
            /*$orders = Model_Collection_ShopOrders::getInstance();
            $orders = $orders->fetchAll();*/
            $ord = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'orders');
            $ord_obj_type = $ord->getObjectType();
            $groups = $ord_obj_type->getFieldGroups();
            $orders = Model_Collection_Objects::getInstance()->getObjectsByType($ord_obj_type->id);
            $data['fields'] = array();
            foreach($groups as $group) {
                $fields = $group->getFields();
                foreach($fields as $field) {
		    $type = strtolower($field->getType()->name);
		    if($type == "select") {
			//print_r($field->id_guide);
			$opts = Model_Collection_Objects::getInstance()->getGuideObjects($field->id_guide);
			$s = array();
			$s[] = "0:...";
			$vals = array();
			$vals[] = "...";
			foreach($opts as $id=>$opt) {
			    $s[]= $id.":".$opt->title;
			    $vals[$id] = $opt->title;
			}
			$values = join(";",$s);
			$editoptions = array("value"=>$values);
		    } else {
			$editoptions ="";
			$type = "text";
		    }
                    $data['fields'][] = array('name'=>$field->name,'title'=>$field->title,'visible'=>true,'edittype'=> $type,"editoptions"=>$editoptions, "values"=>$vals);
                }
            }
            $data['data'] = array();
            foreach($orders as $order) {
                $vals = $order->getValues();
                $k = array();
                foreach($data['fields'] as $field){
                    // По id пользователя получаем данные о нем
                    if($field['name'] == 'shop_order_userid') {
                        //$vals[$field['name']] = 'User Name';//Model_Collection_Objects::getInstance()->getEntity($vals['shop_order_userid'])->title;
                        $res = Model_Collection_Users::getInstance()->getUserByObject($vals['shop_order_userid']);
                        if(is_object($res)){
                            $m  = $res->getValues();
                            $vals[$field['name']] = $m['user_name'].' '.$m['user_surname'];
                        }else
                            $vals[$field['name']] = 'Клиент не определён';
                    } elseif ($field['name'] == 'shop_order_sum') {
                        $vals[$field['name']] .= ' р.';
                    }						
						else{
			if($field['edittype']=='select') {
			    $vals[$field['name']] = isset($field['values'][$vals[$field['name']]]) ? $field['values'][$vals[$field['name']]] : '...'; 
			} else {
			    $vals[$field['name']] = isset($vals[$field['name']]) ? $vals[$field['name']] : '';
			}
                    }
                }
                $data['data'][$order->id] = $vals;
            }
            $this->getResponse()->setBody( $this->view->json( $data ) );
            
            //$ord = Model_Collection_ObjectTypes::getInstance()->getEntity($id)
        }

        /**
         * Получение списка заказов
         */
        public function getordersarrayAction() {
            /*$orders = Model_Collection_ShopOrders::getInstance();
            $orders = $orders->fetchAll();*/
            $ord = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'orders');
            $ord_obj_type = $ord->getObjectType();
            $groups = $ord_obj_type->getFieldGroups();
            $orders = Model_Collection_Objects::getInstance()->getObjectsByType($ord_obj_type->id);
            $data['fields'] = array();
            foreach($groups as $group) {
                $fields = $group->getFields();
                foreach($fields as $field) {
				    $type = strtolower($field->getType()->name);
				    if($type == "select") {
						//print_r($field->id_guide);
						$opts = Model_Collection_Objects::getInstance()->getGuideObjects($field->id_guide);
						$s = array();
						$s[] = "0:...";
						$vals = array();
						$vals[] = "...";
						foreach($opts as $id=>$opt) {
						    $s[]= $id.":".$opt->title;
						    $vals[$id] = $opt->title;
						}
						$values = join(";",$s);
						$editoptions = array("value"=>$values);
				    } else {
						$editoptions ="";
						$type = "text";
				    }
                    $data['fields'][] = array('name'=>$field->name,'title'=>$field->title,'visible'=>true,'edittype'=> $type,"editoptions"=>$editoptions, "values"=>$vals);
                }
            }
            $data['data'] = array();
            foreach($orders as $order) {
                $vals = $order->getValues();
                $k = array();
                foreach($data['fields'] as $field){
                    // По id пользователя получаем данные о нем
                    if($field['name'] == 'shop_order_userid') {
                        //$vals[$field['name']] = 'User Name';//Model_Collection_Objects::getInstance()->getEntity($vals['shop_order_userid'])->title;
                        $res = Model_Collection_Users::getInstance()->getUserByObject($vals['shop_order_userid']);
                        if(is_object($res)){
                            $m  = $res->getValues();
                            $vals[$field['name']] = $m['user_name'].' '.$m['user_surname'];
                        }else
                            $vals[$field['name']] = 'Клиент не определён';
                    } elseif ($field['name'] == 'shop_order_sum') {
                        $vals[$field['name']] .= ' р.';
                    }
						else{
			if($field['edittype']=='select') {
			    $vals[$field['name']] = isset($field['values'][$vals[$field['name']]]) ? $field['values'][$vals[$field['name']]] : '...';
			} else {
			    $vals[$field['name']] = isset($vals[$field['name']]) ? $vals[$field['name']] : '';
			}
                    }
                }
                $data['data'][$order->id] = $vals;
            }
            return $data ;

            //$ord = Model_Collection_ObjectTypes::getInstance()->getEntity($id)
        }

        /**
         * Получение списка покупателей
         * 
         */
        public function getusersAction() {
            $users = Model_Collection_ShopOrders::getInstance()->getOrdersUsers();
            $mcu = Model_Collection_Users::getInstance();
	    
	    $users = $mcu->getUsersByGroup(2);
		//$users = $mcu->fetchAll();
            $us = array();
            $data = array();
            foreach($users as $user) {
                $us[$user->id] = $user->getValues();
            }
            $utype = Model_Collection_ElementTypes::getInstance()->getModuleElementType('users', 'user');
            $user_type = $utype->getObjectType();
            $groups = $user_type->getFieldGroups();
            $data['fields'] = array();
            foreach($groups as $group) {
                $fields = $group->getFields();
                foreach($fields as $field) {
                    if($field->name == 'user_password') continue;
		    $type = strtolower($field->getType()->name);
		    if($type == "select") {
				//print_r($field->id_guide);
				$opts = Model_Collection_Objects::getInstance()->getGuideObjects($field->id_guide);
				$s = array();
				$s[] = "0:...";
				$vals = array();
				$vals[] = "...";
				foreach($opts as $id=>$opt) {
					$s[]= $id.":".$opt->title;
					$vals[$id] = $opt->title;
				}
				$values = join(";",$s);
				$editoptions = array("value"=>$values);
		    } else {
				$editoptions ="";
				$type = "text";
		    }
                    $data['fields'][] = array('name'=>$field->name,'title'=>$field->title,'visible'=>true,"edittype"=>$type,"editoptions"=>$editoptions,"values"=>$vals);
                }
            }
            $data['data'] = $us;
	    foreach($data['data'] as $id=>$user) {
			foreach($data['fields'] as $field) {
				if($field['edittype']=='select') {
					$data['data'][$id][$field['name']] = $field['values'][$data['data'][$id][$field['name']]];
				}
			}
	    }
            $this->getResponse()->setBody( $this->view->json( $data ) );
        }


        /**
         * Просомтр заказов пользователя
         */
        public function getusersordersAction() {
			//print_r($this->getRequest()->getParams());
            $ord = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'orders');
            $ord_obj_type = $ord->getObjectType();
            $groups = $ord_obj_type->getFieldGroups();
            
            $data['fields'] = array();
            foreach($groups as $group) {
                $fields = $group->getFields();
                foreach($fields as $field) {
                    if($field->name == 'shop_order_userid') continue;
                    $data['fields'][] = array('name'=>$field->name,'title'=>$field->title,'visible'=>true);
                }
            }
            $data['data'] = array();
            $orders = Model_Collection_ShopOrders::getInstance()->getUserOrders($this->getRequest()->getParam('userorders'));
            foreach($orders as $order){
                $ord_obj = Model_Collection_Objects::getInstance()->getEntity($order->id_obj);
                $vals = $ord_obj->getValues();
                foreach($data['fields'] as $field) {
                    // По id пользователя получаем данные о нем
                    if($field['name'] == 'shop_order_userid') {
                        continue;
                        //$vals[$field['name']] = 'User Name';//Model_Collection_Objects::getInstance()->getEntity($vals['shop_order_userid'])->title;
                    } else {
                        $vals[$field['name']] = isset($vals[$field['name']]) ? $vals[$field['name']] : '';
                    }
                }
                $data['data'][$order->id] = $vals;
            }
            $this->getResponse()->setBody( $this->view->json( $data ) );
        }


        
        /**
         * Получение информации о заказе
         */
        public function getorderinfoAction() {
            $order = Model_Collection_ShopOrders::getInstance()->getEntityByObject($this->getRequest()->getParam('orderinfo'));
            $order_id  = $order->id;
            $ordinfo = Model_Collection_ShopOrderInfo::getInstance()->getEntityByOrder($order_id);
            $elements = array();
            $fields = array();
            $ord = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'orders');
            $ord_obj_type = $ord->getObjectType();
            $obj_db = Model_Collection_ObjectTypes::getInstance()->getDbObjectTypes();
            $sel = $obj_db->select()->where('id_parent=?',$ord_obj_type->id);
            $otype = $obj_db->fetchRow($sel);
            $groups = $otype->getFieldGroups();
            $data['fields'] = array();
            foreach($groups as $group) {
                $fields = $group->getFields();
                foreach($fields as $field) {
                    if($field->name == 'shop_order_userid') continue;
                    $data['fields'][] = array('name'=>$field->name,'title'=>$field->title,'visible'=>true);
                }
            }
            foreach($ordinfo as $row) {
                $el = Model_Collection_Objects::getInstance()->getEntity($row->id_obj);
				$e = $el->getValues();
				$element = Model_Collection_Elements::getInstance()->getEntity($e['shop_order_itemid']);
				$e['shop_order_itemid'] = '<a href="/'.$element->urlname.'" target="_blank">'.$element->getObject()->title.'</a>';
				$elements[] = $e;
            }
            /*foreach($elements as $elem){
                $data['fields'] = array();
                foreach($elem as $field=>$val) {
                    $data['fields'][] = array('name'=>$field,'title'=>$field,'visible'=>true);
                }
            }*/
            $data['data'] = $elements;
            $this->getResponse()->setBody( $this->view->json( $data ) );
            
        }
        
	/**
	 * Страница создания элемента (перенаправление на edit)
	 * @return void
	 * создать категорию         /admin/catalog/new/category/0
	 * создать элемент каталога  /admin/catalog/new/category/5/item/add
	 */
	public function newAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			$item_id = $this->getRequest ()->getParam ( 'element' );
			if ( isset( $item_id ) ) {
				// создание элемента каталога
				$this->getRequest ()->setParam ( 'element', 'new' );
			} else {
				// создание категории
				$this->getRequest()->setParam( 'parent', $category_id  );
				$this->getRequest ()->setParam ( 'act', 'new' );
			}
		}
		$this->_forward( 'edit' );
	}
	
	
	public function newitemAction() {
		$category_id = $this->getRequest ()->getParam ( 'category' );
		if ( isset( $category_id ) ) {
			/*$item_id = $this->getRequest ()->getParam ( 'item' );
			if ( isset( $item_id ) ) {
				// создание элемента каталога*/
				$this->getRequest ()->setParam ( 'orders', 'new' );
			/*} else {
				// создание категории
				$this->getRequest()->setParam( 'parent', $category_id  );
				$this->getRequest ()->setParam ( 'act', 'new' );
			}*/
				
			$this->getRequest()->setParam( 'parent', $category_id  );
		}
		$this->_forward( 'edit' );
	}
	
	/**
	 * Страница создания и редактирования элемента
	 * Примеры:
	 * редактировать категорию   /admin/catalog/edit/category/5
	 * редакт. товар       /admin/catalog/edit/category/5/item/5
	 * @return void
	 * @throws Exception если элемент не существует или заданы неправильные идентификаторы (не в production)
	 */
	public function editAction() {
		$parent_id =$this->getRequest ()->getParam ( 'category' );
		$action = $this->getRequest ()->getParam ( 'action' );
		$category_id = (int)$this->getRequest ()->getParam ( 'category' );

		$data = array();
		if ( isset ( $category_id ) ) {
			if ( $action == 'new' ) {
				$data['category_img'] = true;
				//создание категории
				$type_cat = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'category');
				if ( isset($type_cat) ) {
					$type_cat_id = $type_cat->id;
				} else {
					throw new Exception( 'Тип данных каталог категорий не существует' );
				}
				$parent_id = (int) $this->getRequest ()->getParam ( 'parent' );
				$element = Model_Collection_Elements::getInstance ()
					->createElement ( $parent_id, $type_cat_id, 'Категория ' );
			}else{
				$complex_id = $category_id = (int) $category_id;
				if ( $category_id > 0 ) {
					$data['category_img'] = true;
					$element = Model_Collection_Elements::getInstance()->getElement( $category_id );
					$item_id = $this->getRequest()->getParam('orders');// Такая жопа, в таьх один тип элемента на один таб, сл-но 2-й элемент-заказы
					if ( isset( $item_id ) ) {
						if ( $item_id == 'new' ) {
							$data['category_img'] = false;
							// Создание товара
							$type_item = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'item');
							if ( isset($type_item) ) {
								$type_item_id = $type_item->id;
							} else {
								throw new Exception( 'Тип данных элемент каталога не существует' );
							}
							if ( $element->id_type == $type_item_id ) { // подкаталога
								$category_id = $element->id_parent; // небывает
							}		
							$element = Model_Collection_Elements::getInstance ()
								->createElement ( $category_id, $type_item_id );
						}else{
							$data['category_img'] = false;
							// Получение элемента каталога
							$item_id = (int) $item_id;
							if ( $item_id > 0 ) {
								$element = Model_Collection_Elements::getInstance()
									->getElement ( $item_id );
							} else {
								if ( APPLICATION_ENV != 'production' )
									throw new Exception( 'Неправильный идентификатор элемента');
							}
						}
					}else{
						
					}
				}else{
					if ( APPLICATION_ENV != 'production' )
						throw new Exception( 'Неправильный идентификатор каталога категорий' );
				}
			}
		}
		if (! isset ( $element )) {
			throw new Exception ( 'Нет элемента' );
		}
		$writable = $element->isWritable();
		$form = $element->getEditForm(!$writable);
		$request = $this->getRequest();
		if ( $writable and $this->getRequest()->isPost() ) {
			if ( $form->isValid( $request->getPost() ) ) {
				$element->setValues( $form->getValues() );
				$element->commit();
				$form = $element->getEditForm ();
				$data = array (
					'id' => $element->id,
					'parent_id' => $element->id_parent,
					'title' => $element->getObject()->title
				);
				if ( $category_id == 'new' ) {
					$data['expandable'] = false;
				}
			} else {
				$this->setIsErrors( $form );
			}
		}
		$data ['form'] = $form->render();;
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	
	public function editordersAction() {
	    $id = $this->getRequest()->getParam('id');
	    $order = Model_Collection_Objects::getInstance()->getEntity($id);
		unset($_POST['shop_order_userid']); // Убираем из поста "как-бы ИД пользователя" - там нам передалось имя пользователя :-(
	    $order->setValues( $this->getRequest()->getPost() );
	    $order->commit();
		/* Всё ниже писал Лёша. Я так и не понял что он хотел этим сказать */
	    //$order = Model_Collection_ShopOrders::getInstance()->getEntityByObject($id);
	    //$order->id_user = $this->getRequest()->getParam('shop_order_user');
		//$order->id_user = $uid;
		//print $uid;
	    //$order->save();
	}
	
	
/**
	 * Страница создания элемента категории (перенаправление на edit)
	 * @return void
	 * создать категорию         /admin/catalog/new/category/0
	 */
	public function newcategoryAction() {
		$category_id = $this->getRequest ()->getParam ( 'shop_category' );
		$this->getRequest()->setParam( 'parent', $category_id  );
		$this->getRequest ()->setParam ( 'act', 'new' );
		$this->_forward( 'edit' );
	}
	
	/**
	 * Перемещение элемента с заданным id
	 * @return void
	 */
	public function moveAction() {
		$this->_forward('move', 'back', 'content');
	}
	
	
	/**
	 * Удаление элемента в корзину с заданным id
	 * @return void
	 */
	public function deleteAction() {
		$category_id = $this->getRequest ()->getParam ( 'shop_category' );
		if( isset( $category_id ) ){
			$category_id = (int) $category_id;
			if( $category_id > 0 ){
				$item_id = $this->getRequest ()->getParam ( 'element' );
				if( isset( $item_id ) ){
					$item_id = (int) $item_id;
					if( $item_id > 0 ){
						// удаление товара
						$success = Model_Collection_Elements::getInstance () ->delElement( $item_id );
						if (! $success and (APPLICATION_ENV != 'production'))
							throw new Exception ( 'Ошибка при удалении товара' );
						}
				}else{
					// удаление категории каталога
					$success = Model_Collection_Elements::getInstance () 
						->delElement ( $category_id );
					if (! $success and (APPLICATION_ENV != 'production'))
						throw new Exception ( 'Ошибка при удалении категории каталога' );
				}
			}
		}
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
	
	public function printAction() {
		$order_id = $this->getRequest ()->getParam ( 'orders' );
		$orderObj = Model_Collection_Objects::getInstance()->getEntity($order_id);
		$order = Model_Collection_ShopOrders::getInstance()->getEntityByObject($order_id);
		$ordinfo = Model_Collection_ShopOrderInfo::getInstance()->getEntityByOrder($order->id);
		$elements = array();
		foreach($ordinfo as $row) {
			$el = Model_Collection_Objects::getInstance()->getEntity($row->id_obj);
			$e = $el->getValues();
			$element = Model_Collection_Elements::getInstance()->getEntity($e['shop_order_itemid']);
			$e['shop_order_itemname'] = $element->getObject()->title;
			$elements[] = $e;
		}
		$data = $orderObj->getValues();
		$data['elements'] = $elements;
		$user = Model_Collection_Users::getInstance()->getUserByObject($data["shop_order_userid"]);
		$data['user'] = $user->getValues();
		
		$ord = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'orders');
		$ord_obj_type = $ord->getObjectType();
		$groups = $ord_obj_type->getFieldGroups();
		foreach($groups as $group) {
			$fields = $group->getFields();
			foreach($fields as $field) {
				if($field->name == 'shop_order_city') {
					$cities = Model_Collection_Objects::getInstance()->getGuideObjects($field->id_guide);
					foreach ($cities as $city){
						if ($city->id == $data['shop_order_city']) {
							$data['cityname'] = $city->title;
						}
					}
				}
				
				if($field->name == 'shop_order_delivery') {
					$deliveries = Model_Collection_Objects::getInstance()->getGuideObjects($field->id_guide);
					foreach ($deliveries as $delivery){
						if ($delivery->id == $data['shop_order_delivery']) {
							$data['deliveryname'] = $delivery->title;
							$data['deliverysum'] = $delivery->getValue('shop_order_delivery_price');
						}
					}
				}
				
				if($field->name == 'shop_order_payment') {
					$payments = Model_Collection_Objects::getInstance()->getGuideObjects($field->id_guide);
					foreach ($payments as $payment){
						if ($payment->id == $data['shop_order_payment']) {
							$data['paymentname'] = $payment->title;
						}
					}
				}
			}
		}
		$this->getResponse()->setBody( $this->view->partial('shop/print.phtml', $data) );
	}
}
