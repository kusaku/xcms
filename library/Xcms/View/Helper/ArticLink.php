<?php
/**
 * 
 * Помошник вида: ссылка на страницу статей
 * 
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id: ArticLink.php 238 2010-07-02 11:43:40Z renat $
 */

class Zend_View_Helper_ArticLink extends Zend_View_Helper_Abstract {

	/**
	 * Рендерит ссылку на страницу обмена статей Artic
	 * @param string $icon имя файла-иконки для ссылки
	 * @param string $style OPTIONAL стиль для иконки
	 * @return string
	 */
	public function articLink( $icon='', $style='' ) {
		$output = '';
		if ( Zend_Registry::getInstance()->get( 'artic_active' ) ) {
			//$href = $this->view->url( array('module'=>'content', 'controller'=>'artic'), 'default', true );
                        $href = $_SERVER['HTTP_HOST'];
                        $href = str_replace('.', '', $href);
			$src = $this->view->baseUrl("/images/$icon");
			$output = '<a href="'.$href.'" class="artic-link"><img border="0" alt="a" src="'.$src.'" style="'.$style.'"/></a>';
		}
		return $output;
	}
}