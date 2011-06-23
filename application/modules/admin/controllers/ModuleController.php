<?php
/**
 * 
 * "Асинхронный" контроллер для доступа к установленным модулям
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Controller
 * @version    $Id: ModuleController.php 346 2010-09-02 11:20:30Z kifirch $
 */

class Admin_ModuleController extends Xcms_Controller_Back {
	
	/**
	 * Установленные модули
	 * @return void
	 * @todo использовать роуты
	 */
	public function getAction() {
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
		$order = Zend_Registry::getInstance()->get( 'modules_order' ); // список сортировки
		if ( !isset($order) ) $order = array();
		$data = array();
		// Проходим по модулям с бутстрапом
		foreach ( $bootstraps as $name => $bootstrap ) {
			if ( method_exists( $bootstraps[ $name ], 'getModuleOptions' ) ){
				$options = $bootstrap->getModuleOptions();
                                if ( $name == 'admin' ) {
                                        $controller = 'config';
                                } else {
                                        $controller = 'back';
                                }
                                $resource = Model_Collection_ElementTypes::getInstance()->getAclResource( $name, $controller );
                                if ( Main::getAcl()->isAllowed( Main::getCurrentUserRole(), $resource ) ) {
                                        if ( $name == 'trash' ) {
                                                $options['deleted'] = count( Model_Collection_Elements::getInstance()->getDeleted() );
                                        }
                                        $data[$name] = $options;
                                        /*
                                        if($name == 'feedback') {
                                            unset($data[$name]);
                                        }
                                        */
                                }

			}
			if ( !isset($data[$name]) )  {
				$order = array_diff( $order, array($name) ); // удаляем модуль из списка сортировки
			} 
		}
		// Сортировка модулей
		$order = array_diff( $order, array('content') );
		$order = array_values( $order ); // переиндексация
		$last = sizeof( $order ) ;
		foreach ( $data as $name=>$options ) {
                    if ( $name!='content') {
                        $ord = array_search( $name, $order );
                        $data[$name]['ord'] = ( $ord !== false ) ? $ord : $last++ ;
                    }
		}
                Zend_Registry::set('modules_order',$order);
		if ( !is_null($this->getRequest()->getParam('xml')) ) {
			$this->getResponse ()
				->setHeader ( "Content-Type", "text/xml; charset=utf-8" );
			$this->getResponse()->setBody( 
				Model_ArrayToXML::toXml( $data, 'modulesList' ) 
			);
		} else {
			$this->getResponse()->setBody( $this->view->json( $data ) );
		}
	}
}

?>