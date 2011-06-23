<?php
/**
 * 
 * Базовый класс контроллеров модулей административного интерфейса
 * 
 * @category   Xcms
 * @package    Xcms_Controller
 * @version    $Id: Back.php 629 2011-02-09 10:18:59Z kifirch $
 */

abstract class Xcms_Controller_Back extends Zend_Controller_Action {
	
	/**
	 * Инициализация
	 * @return void
	 */
	public function init() {
		$this->_helper->viewRenderer->setNoRender();
		$this->_helper->layout->disableLayout();
	}
	
	/**
	 * Для групп полей с ошибками устанавливает класс 'error'
	 * @param Admin_Form_Edit $form
	 * @return void
	 */
	protected function setIsErrors( $form ) {
		$displayGroups = $form->getDisplayGroups();
		foreach ( $displayGroups as $group ) {
			$elements = $group->getElements();
			foreach ( $elements as $element ) {
				if ( $element->hasErrors() ) {
					$header = $group->getDecorator('Header');
					if ( isset( $header ) ) {
						$header->setOption( 'class', $header->getOption('class') . ' error' );
					}
					continue;
				}
			}
		}
	}

                /**
	 * Загрузка фотографий
	 * @return string
	 */
	public function  uploadAction(){
		$cat =  (bool)$this->getRequest()->getParam('cat'); // А может нафиг всё это? :)
		$module = $this->getRequest()->getModuleName();
		$config = array();
		$reg = Zend_Registry::getInstance();
//		if( !$cat ){
//				$config = array("kategory" => array( "size"=>$reg->get( 'catalog_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' )));
//			}else{
				$config = array(
					"big" => array( "size"=>$reg->get( 'catalog_big_size' ), "quality"=>100, "square" => $reg->get( 'square_big_active' )),
					"medium" => array( "size"=>$reg->get( 'catalog_medium_size' ), "quality"=>80, "square" => $reg->get( 'square_medium_active' )),
					"small" => array( "size"=>$reg->get( 'catalog_small_size' ), "quality"=>80, "square" => $reg->get( 'square_small_active' )),
					"kategory" => array( "size"=>$reg->get( 'catalog_kategory_size' ), "quality"=>80, "square" => $reg->get( 'square_kategory_active' ))
				);
//			}
		$Image = new Model_Image('public/'.$module.'/', $config);
		$img = $Image->LoadImages('userfile');
		if($img!=false)
			$this->getResponse()->setBody( $module.'/backend/'.$img );
		else
			$this->getResponse()->setBody( "error" );
/*
$data = "Param CAT: ".$cat."\n";
$data .= "Param MODULE: ".$module."\n";
$data .= "Param CONFIG: ".print_r($config, true)."\n";
$data .= "==========\n";
$filename = "/home/samba/public/www/lehaeurop/log.txt";
$fh = fopen($filename, "a+");
fwrite($fh, $data);
fclose($fh);
/**/

        }
	
	public function getoptionsAction() {
	    $module = $this->getRequest()->getModuleName();
	    if($module == 'admin')$module = 'content';
	    $moduleform = ucfirst($module)."_Form_Options";
	    if(class_exists($moduleform)) {
		$form = new $moduleform;
		$data['form'] = $form->render();
	    } else {
		$data['form'] = 'Для этого модуля нет настроек';
	    }
	    $this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	
	public function saveoptionsAction() {
	    $request = $this->getRequest();
	    $module = $this->getRequest()->getModuleName();
	    if($module == 'admin')$module = 'content';
	    $moduleform = ucfirst($module)."_Form_Options";
	    if(class_exists($moduleform)) {
		$form = new $moduleform;
		if($form->isValid($request->getPost())) {
		    $reg = Zend_Registry::getInstance();
		    $values = $form->getValues();
		    foreach ( $values as $key=>$value ) {
			if ( $reg->isRegistered( $key ) ) {
				if ( $reg->get( $key ) != $value ) {
					$reg->update( $key, $value );
				}
			} else {
				$reg->add( $key, $value );
			}
		    }
		    $reg->commit();
		    // очищаем кеш
		    /*$cache = Model_Abstract_Collection::getCache();
		    $cache->clean(
			    Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			    array( 'Navigation' )
		    );*/
		}
		$data['form'] = $form->render();
	    } else {
		$data['form'] = 'Для этого модуля нет настроек';
	    }
	    $this->getResponse()->setBody( $this->view->json( $data ) );
	}
}