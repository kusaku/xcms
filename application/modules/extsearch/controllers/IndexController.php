<?

/**
 * Контроллер расширенного поиска
 */

class Extsearch_IndexController extends Xcms_Controller_Modulefront {
    //put your code here
    private $items = array();
    
    public function viewAction() {
        $this->setDataFrom( $this->getRequest()->getParam('id') );
        //$publish_date = date_create( $this->view->element->publish_date_from );
        //$this->view->element->publish_date_from = $publish_date->format( 'd.m.Y' );
        $data = $this->getRequest()->getParams();
        $category = $data['category'];
        $field = $data['search_field'];
        $query = $data['query'];
        $min_price = $data['min_price'];
        $max_price = $data['max_price'];
        $item_type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('shop', 'item');
        $cat_elem = Model_Collection_Elements::getInstance()->getElement($category);
        $this->getChildrenItems( $category, $item_type->id, $cat_elem->id_type, $query, $field, $data );
        $items = $this->items;
		
        $item_container = new Zend_Navigation();
        $itemsCount = 0;
        foreach ( $items as $element ) {
        		$itemsCount++;
                $s_element = Model_Collection_Elements::getInstance()->getElement ( $element->id );
                //var_dump($s_element->getValues()); exit;
                if($s_element) {
                    $item_container->addPage(
                    	$s_element->getPage()//->set('items', $s_element->getValues())
                    	->set('item_image', $s_element->getValue('shop_item_image') )
                    	->set('item_price', $s_element->getValue('shop_item_price') )
                    );
                } else {
                    main::logDebug($element->id);
                    
                }
        }
        $this->view->itemsCount = $itemsCount;
        
        $paginator = Zend_Paginator::factory( $item_container );
        $paginator->setItemCountPerPage(9999999);
        $this->view->items = $paginator;
        $this->renderContent();
    }
    
    private function getChildrenItems( $category ,$item_type_id,$categ_type_id,$query, $field, $data) {
        $cat_elem = Model_Collection_Elements::getInstance()->getElement($category);
        $items = $cat_elem->getChildren();
        if(count($items)>0) {
            foreach($items as $element) {
                if($element->id_type == $item_type_id) {
                    if(empty($query) || count($field)==0 ) {
                        if(!empty($data['min_price']) && empty($data['max_price'])) {
                            if( $element->getValue('shop_item_price') >= $data['min_price'] ) {
                                $this->items[] = $element;
                            }
                        } elseif( empty($data['min_price']) && !empty($data['max_price']) ) {
                            if( $element->getValue('shop_item_price') <= $data['max_price'] ) {
                                $this->items[] = $element;
                            }
                        } elseif( !empty($data['min_price']) && !empty($data['max_price']) ) {
                            if( $element->getValue('shop_item_price') <= $data['max_price'] && $element->getValue('shop_item_price') >= $data['min_price']) {
                                $this->items[] = $element;
                            }
                        } else {
                            $this->items[] = $element;
                        } /**/
                    } else {
                       if(count($field)>0) {
                           $res = false;
                           foreach($field as $fname) {
                               if( $res ) break;
                               $res = preg_match('/'.$query.'/iu', $element->getValue($fname) );
                           }
                           if($res) {
                               if(!empty($data['min_price']) && empty($data['max_price'])) {
                                    if( $element->getValue('shop_item_price') >= $data['min_price'] ) {
                                        $this->items[] = $element;
                                    }
                                } elseif( empty($data['min_price']) && !empty($data['max_price']) ) {
                                    if( $element->getValue('shop_item_price') <= $data['max_price'] ) {
                                        $this->items[] = $element;
                                    }
                                } elseif( !empty($data['min_price']) && !empty($data['max_price']) ) {
                                    if( $element->getValue('shop_item_price') <= $data['max_price'] && $element->getValue('shop_item_price') >= $data['min_price']) {
                                        $this->items[] = $element;
                                    }
                                } else {
                                    $this->items[] = $element;
                                }
                           }
                       }
                    }
                } else {
                    $this->getChildrenItems($element->id, $item_type_id, $categ_type_id,$query, $field, $data);
                }
            }
        } else {
            return;
        }
       
    }

}

