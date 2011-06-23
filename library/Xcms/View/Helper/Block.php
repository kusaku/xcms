<?php
/**
 * 
 * Помошник вида: блок
 * 
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id: Block.php alex $
 */

class Zend_View_Helper_Block extends Zend_View_Helper_Abstract {

        public $view;

        public function setView(Zend_View_Interface $view)
        {
            $this->view = $view;
        }
	
    
	/**
	 * Рендерит блок
	 * @return string
	 */
	public function block( $title , $data = null, $url = null) {
            $mcb = Model_Collection_Blocks::getInstance();
            $block = $mcb->getEntityByTitle($title);
            // Проверка на существование блока
            if( ! ($block instanceof Model_Entity_Block) ) {
                return 'Блок "'.$title.'" не найден в системе';
            }
            $blockFile = 'block'.DIRECTORY_SEPARATOR.$block->getFilename();
            if( $data == null ) {
                    try {
                            $output = $this->view->partial($blockFile);
                    } catch (Exception $e) {
                            return $e->getMessage();
                    }
                    return $output;
            } else {
                $etype_id = Model_Collection_ObjectTypes::getInstance()->getEntity($block->id_object)->id_element_type;
                if( $url != null ) {
                    $table = Model_Collection_Elements::getInstance()->getDbElements();
                    $element = $table->fetchRow(
                            $table->select()
                                    ->where( 'urlname = ?', $url )
                                    ->where( 'is_active = ?', 1 )
                                    ->where( 'is_deleted != ?', 1 )
                    );
                    $elements = $element->getChildren($etype_id,"ord");
                } else {
                    $elements = Model_Collection_Elements::getInstance()->getElementsByType($etype_id,'ord');
                }
                
                $blockData = array();
                $edata= array();
                foreach($elements as $element) {
                    $edata[] = $element->getValues();
                }
                if( $data == 'all' ) {
                    $blockData = $edata;
                } elseif( substr( $data, 0, 6) == 'random' ) {
                    $limit = (int) str_ireplace('random ', '', $data);
                    $lim = ($limit > count($edata) ) ? count($edata):$limit;
                    $blockData = array();
                    for($i = 0;$i<$lim; $i++) {
                        $key = array_rand($edata);
                        if($check[$key] <> 0) {
                            $i--;
                        } else {
                            $check[$key] = 1;
                            $blockData[$i] = $edata[$key];
                        }
                        
                    }
                    
                } elseif( substr( $data, 0, 4) == 'last' ) {
                        $limit = (int) str_ireplace('last ', '', $data);
                        $edata = array_reverse($edata);
                        $blockData = array_slice($edata, 0, $limit, true);
                }
            $output = $this->view->partial($blockFile
            ,array('data'=>$blockData));
            return $output;
	}
    }
}