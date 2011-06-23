<?php
// scripts/load.sqlite.php

/**
 * Script for creating and loading database
 */

// Initialize the application path and autoloading
defined('APPLICATION_PATH')
    || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application'));
set_include_path(implode(PATH_SEPARATOR, array(
    APPLICATION_PATH . '/../library',
    get_include_path(),
)));
require_once 'Zend/Loader/Autoloader.php';
Zend_Loader_Autoloader::getInstance();

// Define some CLI options
$getopt = new Zend_Console_Getopt(array(
    'withdata|w' => 'Load database with sample data',
    'env|e-s'    => 'Application environment for which to create database (defaults to development)',
    'help|h'     => 'Help -- usage message',
));
try {
    $getopt->parse();
} catch (Zend_Console_Getopt_Exception $e) {
    // Bad options passed: report usage
    echo $e->getUsageMessage();
    return false;
}

// If help requested, report usage message
if ($getopt->getOption('h')) {
    echo $getopt->getUsageMessage();
    return true;
}
define('DB_CONFIG_FILE', APPLICATION_PATH . '/configs/config.ini');
// Initialize values based on presence or absence of CLI options
$withData = true; //$getopt->getOption('w');
$env      = $getopt->getOption('e');
defined('APPLICATION_ENV')
    || define('APPLICATION_ENV', (null === $env) ? 'development' : $env);

    
$db_config = new Zend_Config_Ini( DB_CONFIG_FILE , APPLICATION_ENV,  array('skipExtends'  => false,
                                    'allowModifications' => true));
$main_config = new Zend_Config_Ini( APPLICATION_PATH . '/configs/application.ini' , APPLICATION_ENV,  array('skipExtends'  => false,
                                    'allowModifications' => true));    
// Initialize Zend_Application
$application = new Zend_Application(
    APPLICATION_ENV,
    $main_config->merge($db_config)
);

// Initialize and retrieve DB resource
$bootstrap = $application->getBootstrap();
$bootstrap->bootstrap('db');
$dbAdapter = $bootstrap->getResource('db');

// let the user know whats going on (we are actually creating a 
// database here)
if ('testing' != APPLICATION_ENV) {
	date_default_timezone_set('Europe/Moscow');
	echo date(DATE_RFC822) . PHP_EOL;
    echo 'Writing Database in (control-c to cancel): ' . PHP_EOL;
    /*for ($x = 5; $x > 0; $x--) {
        echo $x . "\r"; sleep(1);
    }*/
}

// Check to see if we have a database file already
$options = $bootstrap->getOption('db');
$dbFile  = $options['params']['dbname'];
if (file_exists($dbFile)) {
    unlink($dbFile);
}

// this block executes the actual statements that were loaded from 
// the schema file.
try {
    $schemaSql = file_get_contents(dirname(__FILE__) . '/schema.sqlite.sql');
    // use the connection directly to load sql in batches
    $dbAdapter->getConnection()->exec($schemaSql);
    chmod($dbFile, 0666);

    if ('testing' != APPLICATION_ENV) {
        echo PHP_EOL;
        echo 'Database Created';
        echo PHP_EOL;
    }
    
    if ($withData) {
        $dataSql = file_get_contents(dirname(__FILE__) . '/data.sqlite.sql');
        // use the connection directly to load sql in batches
        $dbAdapter->getConnection()->exec($dataSql);
        if ('testing' != APPLICATION_ENV) {
            echo 'Data Loaded.';
            echo PHP_EOL;
        }
    }
    
} catch (Exception $e) {
    echo 'AN ERROR HAS OCCURED:' . PHP_EOL;
    echo $e->getMessage() . PHP_EOL;
    return false;
}

// generally speaking, this script will be run from the command line
return true;
