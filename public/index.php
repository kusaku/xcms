<?php

// Define path to application directory
defined('APPLICATION_PATH')
    || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application'));

if( file_exists(APPLICATION_PATH.'/../installed')!==true ) {
    header('Location: /install/');
    return;
}
// Define application environment
defined('APPLICATION_ENV')
    || define('APPLICATION_ENV', (getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production'));

// Ensure library/ is on include_path
set_include_path(implode(PATH_SEPARATOR, array(
    realpath(APPLICATION_PATH . '/../library'),
    get_include_path(),
)));

define('DB_CONFIG_FILE', APPLICATION_PATH . '/configs/config.ini');

/** Zend_Application */

require_once 'Zend/Application.php';  

require_once 'Zend/Config/Ini.php';
 
try {
    $main_config = new Zend_Config_Ini( APPLICATION_PATH . '/configs/application.ini' , APPLICATION_ENV,  array('skipExtends'  => false,
                                        'allowModifications' => true));
} catch (Exception $e) {
    die('Не удалось найти основной файл конфигурации<br/>'.APPLICATION_PATH.'/configs/application.ini<br>'.$e->getMessage());
}
try {
    $db_config = new Zend_Config_Ini( DB_CONFIG_FILE , APPLICATION_ENV,  array('skipExtends'  => false,
                                        'allowModifications' => true));
} catch (Exception $e) {
    die('Не удалось найти файл конфигурации Базы данных<br/>'.DB_CONFIG_FILE);
}
	
	$application = new Zend_Application(
	    APPLICATION_ENV,
	        $main_config->merge($db_config)
	);
	$application->bootstrap()->run();
// Create application, bootstrap, and run

