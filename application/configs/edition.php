<?php
return array(
	'name' => 'xCMS',
	'type' => 'corp',// Тип сайта 
	'content' => array(	
		'subpages' => true, // допускает создание подстраниц
		'maxpages' => 0 // максимальное количество страниц
	),
	'news' => array(
		'maxcats' => 0 // максимальное количество лент новостей
	),
	'offers' => array(
		'maxcats' => 1 // максимальное количество лент акций
	),
	'staticSalt' => 'aAg4vE7a' // соль
);