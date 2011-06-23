<?php
/**
* 
* Помошник вида: список модулей в удобном виде
* 
* @category   Xcms
* @package    Admin
* @subpackage View_Helper
* @version    $Id: ModulesList.php 237 2010-12-08 10:52:00Z b00tanik $
*/

class Admin_View_Helper_ModulesList extends Zend_View_Helper_Abstract {

    public function modulesList() {
        $rawData = $this->view->modulesList;
        // переделываем список модулей в вид, удобный для использования в меню
        //print_r($rawData);
        $returnData = array();
        foreach ($rawData as $moduleName=>$moduleData){
            if($moduleName!='trash' && $moduleName!='content'){ 
                if(!isset($moduleData['layout']['panes'])){
                    $returnData[$moduleName]=$moduleData['type'];
                } else {
                    $returnData[$moduleName]=$moduleData['layout']['panes'][0]['element'];
                }
            }
        }
        // ставим корзину последней
        $returnData['trash']='trash';
        
        return $returnData;
    }
}