<?php
/**
 * Плагин контроллера - AccessCheck
 *
 * @category   Xcms
 * @package    Xcms_Controller
 * @subpackage Plugins
 * @version    $Id: AccessCheck.php 238 2010-07-02 11:43:40Z renat $
 */

class Xcms_Controller_Plugin_AccessCheck extends Zend_Controller_Plugin_Abstract {
	
	/**
	 * Проверяет права доступа
	 * 
	 * @param Zend_Controller_Request_Abstract $request
	 * @return void
	 * @todo использовать роуты
	 */
    public function preDispatch(Zend_Controller_Request_Abstract $request) {
        $action = $request->getActionName();
        if ( $action == 'error' ) return;
        $role = Main::getCurrentUserRole();
        $module = $request->getModuleName();
        $controller = $request->getControllerName();
        if ( $module == 'default' ) {
            //if ( $controller == 'resources' ) return;
            if ( $controller == 'version' ) return;
            $module = 'content';
        }
        if ( $controller == 'index' or $controller == 'error' ) {
            $controller = '';
        }
        if ( $module == 'content' and $controller == 'page' ) {
            $controller = '';
        }
        if ( $action == 'index' or $action == 'alias' or $action == 'get' ) {
            $action = 'view';
        }
        $resource = Model_Collection_ElementTypes::getInstance()
        ->getAclResource($module, $controller);
        if ( ! Main::getAcl()->isAllowed( $role, $resource, $action ) ) {
            if ( $module == 'admin' and $controller == '' ) {
                    $request
                            ->setControllerName('auth')
                            ->setActionName('login');
            } else {
                    $request->setModuleName('default')
                            ->setControllerName('error')
                            ->setActionName('denied');
            }
            return;
        }
    }
}