/*
 * main.js
 * Главный класс отвечающий за работу с модулями
 */

/*
 * Функция конструктур
 * @param (array) modules	Массив модулей
 * @param (integer) current Индентификатор текущего модуля	
 */
function Main(){
	this.modules={};
	this.current;
}

/*
 * Запрос настройки модулей и первичной инициализации
 */
Main.prototype.init = function(){
	var self = this;
	$.ajax({
		url: "/admin/module/get/all",
		type: 'post',
		beforeSend: function(){
			$('#module').empty().append(
				$('<div></div>')
					.addClass('load'));
		},
		dataType: 'json',
		success: function(data){
			$('#module').empty();
			$.each(data, function(module, option){
				self.modules[module] = self.createModule( module, option );
			});
			self.current = self.modules['admin'];	
			self.activateModule('content');
		}
	});
}

/*
 * Возвращает объект модуля
 * @param (string) name Имя модуля
 */
Main.prototype.getModule = function( name ){
	var self = this;
	var module = {};
	module =self.modules[name];
	return module;
}


Main.prototype.moduleSettings = function() {
    var self = this;
    var module = {};
    module = self.current;
    if (typeof module != "undefined") {
	module.editSettings();
    }
}

/*
 * Активирует модуль по имени
 * @param (string) name Имя модуля
 */
Main.prototype.activateModule = function( name ){
	var self = this;
	if( name == 'admin'){
		var block = $('#content');
		$.ajax({
			url: '/content/back/index',
			type: 'get',
			dataType: 'json',
			error: function(){
				throw 'Error! Wrong JSON answer';
			},
			beforeSend: function(){
				block.append(
					$('<div></div>')
						.addClass('load'));
			},
			success: function( data ){
				block.html( data['text'] );
			}
		});
		self.current = self.getModule( name );
		//self.setNavigation( 'admin' );
	} else if(name == 'search') {
		var block = $('#content');
		$.ajax({
			url: '/search/back/get/element/0',
			type: 'get',
			dataType: 'json',
			error: function(){
				throw 'Error! Wrong JSON answer';
			},
			beforeSend: function(){
				block.append(
					$('<div></div>')
						.addClass('load'));
			},
			success: function( data ){
				block.html( data['text'] );
			}
		});
		self.current = self.getModule( name );
	}else{
		self.current = self.getModule( name );
		module = self.current;
		if(module.options.controller == 'data') {
			module.options.viewform = 'panel';
		}
		if (typeof module != "undefined") {
			module.activateModule();
		}
	}
}

/*
 * Создает екземпляр класса модуль и его возвращает
 * @param (object) module_options Опции модуля
 */
Main.prototype.createModule = function( name, module_options ){
	var module = new Module( name );
	module.setOption( module_options );
	return module;
}

/*
 * 
 */
Main.prototype.setNavigation = function( name ){
	
}
