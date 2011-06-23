<?php
/**
 * 
 * Исключение модели
 * 
 * @category   Xcms
 * @package    Model
 * @version    $Id: Exception.php 104 2010-02-01 13:55:16Z renat $
 * 
 */

class Model_Exception extends Zend_Exception {
	
	/**
	 * Создает исключение, если новое - записывает в лог
	 * 
	 * @param  string|Exception $msg OPTIONAL сообщение или предыдущее исключение
	 * @param  int $code OPTIONAL код исключения
	 * @param  Exception $previous OPTIONAL предыдущее исключение
	 * @return void
	 */
	public function __construct( $msg = '', $code = 0, Exception $previous = null) {
		if ( $msg instanceof Exception ) {
			$previous = $msg;
			$msg = $previous->getMessage();
			if ( ! $code ) {
				$code = $previous->getCode();
			}
		}
		parent::__construct ( $msg, $code, $previous );
		if ( isset( $previous ) ) {
			if ( ! $previous instanceof Model_Exception ) {
				Main::logErr( $previous );
			}
		} else {
			Main::logErr( $this );
		}
	}

}