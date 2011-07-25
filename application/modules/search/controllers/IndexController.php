<?php
/**
 * Description of IndexController
 *
 * @author aleksey.f
 */
class Search_IndexController extends Xcms_Controller_Modulefront{

    public function  viewAction() {
    	$reind = $this->getRequest()->getParam('ind');
    	if($reind)
    		$this->reindex($reind, 100);
    		
    	$string = $this->getRequest()->getParam('search_string');
        if( !empty($string) && strlen($string)>1 ) {
        	$search = Model_Search::getInstance();
        	$hits = $search->find($string);
            $etypes = array();
            foreach( $hits  as $hit ) {
                $etypes[] = $hit->element_type;
            }
            $etypes = array_unique($etypes);
            rsort($etypes);
            $this->setDataFrom($this->getRequest()->getParam('id'));
            $this->view->etypes = $etypes;
            $this->view->query = $string;
            $this->view->hits = $hits;
            $this->view->error = false;
        } else {
            $this->setDataFrom($this->getRequest()->getParam('id'));
            $this->view->etypes = $etypes;
            $this->view->query = $string;
            $this->view->hits = $hits;
            $this->view->error = true;
        }
        $this->render();
    }
  
    public function reindex($offset, $limit) {
    	$search = Model_Search::getInstance();
        $elems = Model_Collection_Elements::getInstance()->fetchAll();
        $indexSize = $search->getSize(true);
        if($indexSize >= count($elems)) return;
        $i=0;
        foreach($elems as $elem) {
        	$i++;
        	if($indexSize >= $i || $offset > $i) continue;
        	if(($offset+$limit) < $i) return;
        	if(!$search->getDocById($elem->id))
        		$search->index($elem);
        }
        $search->optimize();
    }
}
