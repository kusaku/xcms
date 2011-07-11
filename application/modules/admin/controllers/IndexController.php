<?php
/**
 * 
 * Основной контроллер административного интерфеса
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Controller
 * @version    $Id: IndexController.php 595 2010-12-08 09:09:55Z igor $
 */

class Admin_IndexController extends Xcms_Controller_Admin {
	
	/**
	 * Предисперчеризация, проверяем права
	 * @return void
	 */
	public function preDispatch() {
		// получаем пользователя
		$auth = Zend_Auth::getInstance();
		if ( $auth->hasIdentity() 
			// дополнительная проверка на принадлежность к группе администраторов
			//and ( $auth->getIdentity()->id_usergroup == Model_Collection_Users::ADMINISTRATOR )
			) {
			$this->view->username = $auth->getIdentity()->name;
		} else {
			$this->_redirect( $this->view->url( array( 'controller'=>'auth', 'action'=>'login') ) );
			return;
		}
	}
	
	/**
	 * Действие по-умолчанию
	 * @return void
	 */
	public function indexAction() {
		$view = $this->view;
        
        
        // получение списка модулей  для главного меню
        $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
        $order = Zend_Registry::getInstance()->get( 'modules_order' ); // список сортировки
        if ( !isset($order) ) $order = array();
        $data = array();
        // Проходим по модулям с бутстрапом
        foreach ( $bootstraps as $name => $bootstrap ) {
            if ( method_exists( $bootstraps[ $name ], 'getModuleOptions' ) ) {
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
                }
            }
            if ( !isset($data[$name]) ) {
                $order = array_diff( $order, array($name) ); // удаляем модуль из списка сортировки
            } 
        }
        // Сортировка модулей
        $order = array_diff( $order, array('content') );
        $order = array_values( $order ); // переиндексация
        $last = sizeof( $order ) - 1;
        foreach ( $data as $name=>$options ) {
            if ( $name!='content' ) {
                    $ord = array_search( $name, $order );
                    $data[$name]['ord'] = ( $ord !== false ) ? $ord : $last++ ;     
               }        
        }      
        
        $this->view->modulesList = $data;
        
		// Messages
		//$view->messages = $this->_helper->getHelper('FlashMessenger')->getMessages();
		// JQuery
		//$view->jQuery()->setLocalPath($view->BaseUrl() . '/cms/resources/jquery/jquery-1.6.2.min.js');
		$view->jQuery()
			->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/jquery.form.js' )
			//->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/jquery.xml2json.js' )
		;
		// Скрипты админки
		/*$view->jQuery()
			//->addJavascriptFile ( $view->BaseUrl() . '/cms/js/init.js' )
            ->addJavascriptFile ( $view->BaseUrl() . '/cms/js/swfobject.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/swfmodule.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.tree.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.treemenu.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.treeform.js' )

			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.editform.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.response.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.checkbox.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.radio.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jScrollPane.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/cusel.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.treecatalog.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.mousewheel.js' )
            ->addJavascriptFile ( $view->BaseUrl() . '/cms/js/ajaxuploader.js' )
            ->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.liquidcarousel.js' ) ;*/
       // Новые скрипты админки
       $view->jQuery()
               ->addStylesheet($view->baseUrl('/cms/css/ui.jqgrid.css'))
	       ->addStylesheet($view->baseUrl('/cms/css/admin.css'))
           // ->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/init.js' )
        	 ->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/init.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/main.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/module.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/tree.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.fields.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/simpletree.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/maintree.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/toolbar.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/contextmenu.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/form.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/panelform.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/dialogform.js' )
                ->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/grid.locale-ru.js' )

                ->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/ui.multiselect.js' )                                                
                ->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/jquery.jqGrid.min.js' )                        
                ->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/grid.subgrid.js' )                        
                ->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/jquery.tablednd.js' )                                                      
                 ->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/grid.celledit.js' )
                //->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/jquery/plugins/jquery.dataTables.js' )
                ->addJavascriptFile ( $view->BaseUrl() . '/cms/interface/table.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.checkbox.js' )
                        ->addJavascriptFile ( $view->BaseUrl() . '/cms/js/ajaxuploader.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.radio.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jScrollPane.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/cusel.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.mousewheel.js' )
        	->addJavascriptFile ( $view->BaseUrl() . '/cms/js/swfobject.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/swfmodule.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.ui.nestedSortable.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.liquidcarousel.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.livequery.js' )
			->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.jeegoocontext.js' )
                                ->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.treemenu.js' )
                                ->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.treeform.js' )
                                ->addJavascriptFile ( $view->BaseUrl() . '/cms/js/jquery.fields.js' )
			;
		// TinyMCE
		$view->jQuery()
			->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/tiny_mce/jquery.tinymce.js' );
		//firebug
		$view->jQuery()
			->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/firebug/firebug.js' );
	     // CodeMirror
		$view->jQuery()
			->addJavascriptFile ( $view->BaseUrl() . '/cms/resources/codemirror/js/codemirror.js' );
		$view->headTitle( Zend_Registry::get('name') );
	}
}
