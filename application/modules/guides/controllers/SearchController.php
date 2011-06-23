<?php

/**
 * Контроллер поиска по каталогу
 *
 * @author aleksey.f
 */
class Catalog_SearchController extends Xcms_Controller_Modulefront {
    //put your code here
    private $items = array();
    
    
    private function getChildrenItems( $category ,$item_type_id,$categ_type_id,$query, $field, $data) {
        $cat_elem = Model_Collection_Elements::getInstance()->getElement($category);
        $items = $cat_elem->getChildren();
        if(count($items)>0) {
            foreach($items as $element) {
                if($element->id_type == $item_type_id) {
                    if(empty($query) || count($field)==0) {
                        if(!empty($data['min_price']) && empty($data['max_price'])) {
                            if( $element->getValue('catalog_item_price') >= $data['min_price'] ) {
                                $this->items[] = $element;
                            }
                        } elseif( empty($data['min_price']) && !empty($data['max_price']) ) {
                            if( $element->getValue('catalog_item_price') <= $data['max_price'] ) {
                                $this->items[] = $element;
                            }
                        } elseif( !empty($data['min_price']) && !empty($data['max_price']) ) {
                            if( $element->getValue('catalog_item_price') <= $data['max_price'] && $element->getValue('catalog_item_price') >= $data['min_price']) {
                                $this->items[] = $element;
                            }
                        } else {
                            $this->items[] = $element;
                        }
                    } else {
                       if(count($field)>0) {
                           $res = false;
                           foreach($field as $fname) {
                               if( $res ) break;
                               $res = preg_match('/'.$query.'/i', $element->getValue($fname) );
                           }
                           if($res) {
                               if(!empty($data['min_price']) && empty($data['max_price'])) {
                                    if( $element->getValue('catalog_item_price') >= $data['min_price'] ) {
                                        $this->items[] = $element;
                                    }
                                } elseif( empty($data['min_price']) && !empty($data['max_price']) ) {
                                    if( $element->getValue('catalog_item_price') <= $data['max_price'] ) {
                                        $this->items[] = $element;
                                    }
                                } elseif( !empty($data['min_price']) && !empty($data['max_price']) ) {
                                    if( $element->getValue('catalog_item_price') <= $data['max_price'] && $element->getValue('catalog_item_price') >= $data['min_price']) {
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
        $item_type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('catalog', 'item');
        $cat_elem = Model_Collection_Elements::getInstance()->getElement($category);
        $this->getChildrenItems( $category, $item_type->id, $cat_elem->id_type,$query, $field, $data );
        $items = $this->items;

        $item_container = new Zend_Navigation();
        foreach ( $items as $element ) {
                $s_element = Model_Collection_Elements::getInstance()
				->getElement ( $element->id );
                if($s_element) {
                    $item_container->addPage($s_element->getPage()
                                            ->set('items', $s_element->getValues()));
                } else {
                    main::logDebug($element->id);
                    
                }
        }
        $paginator = Zend_Paginator::factory( $item_container );
        $this->view->items = $paginator;
        $this->renderContent( 'search.phtml' );
    }

}

