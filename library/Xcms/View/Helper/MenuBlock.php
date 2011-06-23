<?php
/**
 * 
 * Помошник вида: меню
 * 
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id: MenuBlock.php 500 2010-10-14 08:31:04Z kifirch $
 */

class Zend_View_Helper_MenuBlock extends Zend_View_Helper_Abstract {

	public function checkActive($pages,$k = 0) {
            static $level;
            foreach($pages as $page) {
               if(count($page->pages)>0){
                   $i = $k+1;
                   $this->checkActive($page->pages, $i);
               }
               if($this->view->element->id == $page->id){
                   $page->setActive(true);
                   $level = $k;
               }
            }
            return $level;
        }
        /**
	 * Рендерит блок меню, если меню только одно, его название можно не указывать (null)
	 * @param string $label OPTIONAL название блока меню
	 * @param string $partial OPTIONAL шаблон
	 * @return string
	 */
	public function menuBlock( $label=null, $partial=null ) {
		$nav = $this->view->navigation();
                $xmenu = new Xcms_View_Helper_Menu();
                if ( empty($label) ) {
			$menu = $nav->menu()->getContainer();
		} else {
			$menu = $nav->findOneByLabel($label);
		}
                if( isset($menu) ) {
                    $a = $this->checkActive($menu->getPages());
                }
                $xmenu->setView($this->view);
                $xmenu->menu($nav->getContainer());
		if ( empty($menu) ) return '';
		if ( empty($partial) ) { // стандартный рендеринг на ul-li
			return $xmenu->renderMenu($menu, array('ulClass'=>$menu->class,'minDepth'=>null,'maxDepth'=>null,'onlyActiveBranch'=>$menu->showSub,'renderParent'=>true) );
		} else { // рендеринг по шаблону
			return $xmenu->renderPartial( $menu, $partial );
		}
	}
}
