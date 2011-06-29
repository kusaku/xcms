<?php
class Zend_View_Helper_ExtSearch  extends Zend_View_Helper_Abstract {
    
    public $view;
    public $tree = array();
    public $table = array();
    public $index = 0;

    public function setView(Zend_View_Interface $view) {
       	$this->view = $view;
    }

    public function treeCreate($parent=NULL, $maxlevel, $level = 0) {
        $list=$this->table[$parent];
        foreach( $list AS $key => $data )
        {
            $this->tree[$this->index] =$list[$key];
            $this->tree[$this->index]['level']=$level;
            $this->index++;
            if ((isset($this->table[$key])) AND (($maxlevel>=$level+1) OR ($maxlevel==0)))
            {
              $this->treeCreate($key,$maxlevel,$level+1);
            }
        }
    }

    public function extSearch() {
        try {
            $form = new Extsearch_Form_Search();
        } catch(Exception $e) {
            return '';
        }
        $categories = array();
        $mce = Model_Collection_Elements::getInstance();
        $mcet = Model_Collection_ElementTypes::getInstance();
        // Получаем поля для поиска
        $etype_elem = $mcet->getModuleElementType('shop', 'item');
        if( isset($etype_elem) ) {
            $otype = $etype_elem->getObjectType();
            $fgroups = $otype->getFieldGroups();
            $fields = array();
            foreach($fgroups as $group) {
                foreach($group->getFields() as $field) {
                    if( ($field->name == 'name' || preg_match('/^shop/', $field->name)  )&& !preg_match('/image|price/', $field->name) )
                    $fields[$field->name] = $field->title;
                }
            }
            // Получаем категории
            $etype = $mcet->getModuleElementType('shop', 'category');
            $mco = Model_Collection_Objects::getInstance();
            $all = array();
            $all = $mce->getElementsByType($etype->id,'id,id_parent');
            
            foreach($all as $elem) {
                $obj = $mco->getEntity($elem->id_obj);
                $this->table[empty($elem->id_parent) ? 0 :$elem->id_parent][$elem->id] = array('id'=>$elem->id, 'title'=>$obj->title);
            }
            if (count($this->table) > 0 ) {
                $this->treeCreate(0,0,0);
                foreach($this->tree as $elem) {
                    $categories[$elem[id]] = ' '.str_repeat(' :: ', $elem[level]).' '.$elem[title];
                }
                // Получаем Url
                $etype = $mcet->getModuleElementType('extsearch');
                $search = $mce->getElementsByType($etype->id);
                foreach($search as $elem) {
                    $url = $elem->urlname;
                }
                $select = $form->getElement('category');
                $select->addMultiOptions($categories);
                //$select = $form->getElement('field');
                //$select->addMultiOptions($fields);
                $elem = $form->getElement('search_field');
                foreach($fields as $name=>$field) {
                    $elem->addMultiOption($name, $field);
                }
                //$form->addElement($elem);
                $form->setAction($url);
                $category = empty($_GET['category']) ? $this->view->element->id : $_GET['category'];
                $data = array('category'=>$category,'query'=>$_GET['query'],'search_field'=>$_GET['search_field'],'max_price'=>$_GET['max_price'],'min_price' => $_GET['min_price'] );
                $form->populate($data);
                return $form->render();
            } else {
                return 'Каталог пуст';
            }
        } else {
            return '';
        }
    }
}
?>
