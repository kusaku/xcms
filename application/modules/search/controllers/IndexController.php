<?php
/**
 * Description of IndexController
 *
 * @author aleksey.f
 */
class Search_IndexController extends Xcms_Controller_Modulefront{

    public function  viewAction() {
        $string = $this->getRequest()->getParam('search_string');
		$string = strToLower($string); // переводим в нижний регистр для нечувствительности к регистру. Ну уж вот так странно она реализована в Zend_Search_Lucene
        $where = $this->getRequest()->getParam('search_where');
        if( !empty($string) && strlen($string)>3 ) {
            Zend_Search_Lucene_Analysis_Analyzer::setDefault(new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8_CaseInsensitive());
            Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding('UTF-8');
            Zend_Search_Lucene::setDefaultSearchField(NULL);
            try {
                $index = Zend_Search_Lucene::open(APPLICATION_PATH.'/../data/search');
            } catch (Exception $e) {
                $this->reindexAction();
                $index = Zend_Search_Lucene::open(APPLICATION_PATH.'/../data/search');
            }
                if(preg_match('/\w+\d+\w+/',$string)) {
                    $query = Zend_Search_Lucene_Search_QueryParser::parse($string);
                } else {
                    $words = explode(" ",$string);
                    $queryes = array();
                    if(count($words)>1) {
                        foreach($words as $word) {
                            $queryes[]= $word.'~';
                        }
                        $querystr = join(" or ",$queryes);
                        $query = Zend_Search_Lucene_Search_QueryParser::parse($querystr);
                    } else {
                        $query = Zend_Search_Lucene_Search_QueryParser::parse($string.'~');// Zend_Search_Lucene_Search_QueryParser::parse();
                    }
                }
            //}
            try{
                $hits = $index->find($query,'element_type',SORT_STRING,SORT_DESC);
            }catch(Exception $e){
                print $e->getMessage();
                /*print_r($e->getTrace());*/
            }
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
        

        //$this->renderContent('search.phtml');
        //$this->_forward('view');
    }
  
    public function reindexAction() {
        Zend_Search_Lucene_Analysis_Analyzer::setDefault(new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num_CaseInsensitive());
        $ind = Zend_Search_Lucene::create(APPLICATION_PATH.'/../data/search',true);
        //Zend_Search_Lucene_Analysis_Analyzer::setDefault( new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());
        $mce = Model_Collection_Elements::getInstance();
        $elems = $mce->fetchAll();
        foreach($elems as $elem) {
            if($elem->is_active && !$elem->is_deleted) {
            $otype =$elem->getObject()->getType()->__toString();
            $etype = $elem->getType()->__toString();
            if($etype == 'Поиск')continue;
            $fields  = $elem->getValues( true );

            $doc = new Zend_Search_Lucene_Document();
            foreach($fields as $name=>$value) {
                $doc->addField(Zend_Search_Lucene_Field::text($name,$value,'UTF-8'));
            }
            $doc->addField(Zend_Search_Lucene_Field::text('element_type',$otype,'UTF-8'));
            $ind->addDocument($doc);
            }
        }
        $ind->commit();
        $ind->optimize();
        //$this->getResponse()->setBody( $this->view->json( $data ) );
    }
}
?>
