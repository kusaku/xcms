/*
 * module.js
 * Класс модуля, отвечает за создание интерфейса модуля (леаутов и виджетов).
 */

/*
 * Функция конструктор
 * @param (string) name	  Имя модуля
 * @param (object) options  Настройки модуля
 * @param (object) layout	  Объект лейаута
 * @param (array)  widgets  Объекты исп. виджетов
 */
function Module(){
	this.name;
	this.options;
	this.layout;
	this.widgets;
}

/*
 * 
 */
Module.prototype.init = function(){
	
}

/*
 * Возвращает объект лейаута
 * @param (object) layout Объект лейаута
 * @param (string) name	Имя модуля 
 */
Module.prototype.getLayout = function(){
	this.name = this.options.controller;
    return this.createLayout();
}

/*
 * 
 */
Module.prototype.activateModule = function(  ){
    $("#curmod").html(" / "+this.options.title);
    this.options.pane = 0;
    this.getLayout();
    this.createWidget(this.options.widjet);
}

/*
 * Создание лейаута
 */
Module.prototype.createLayout = function(){
	var type = this.getType();
	switch( type ){
		case 'pane':
			this.getPane();
			break;
		case 'tabs':
			this.getTabs();
			break;
		default:
			this.getPane();
	}
        return this.layout;
}

/*
 * Создание виджета
 * @param (object) widjet Виджет для модулей
 */
Module.prototype.createWidget = function( widjet ){
    switch( widjet ){
        case 'tree':
            this.simpleTreeWidjet();
            //this.simpleTreeWidjet();
            break;
        case 'table':
            this.tableWidget();
            break;
        case 'expanded_tree':
            this.expandedtreeWidjet();
            break;
        case 'ediform':
            this.editformWidjet();
            break;
        default:
            this.mainTreeWidjet();
            //this.simpleTreeWidjet();
    }
    return;
}

Module.prototype.expandedtreeWidjet = function() {
    
}

/*
 * Установка опций модуля
 * @param (object) module_options Опции модуля
 */
Module.prototype.setOption = function( module_options ){
	this.options = module_options;
}

/*
 * Получение типа лайаута
 */
Module.prototype.getType = function(){
	return this.options.layout.type;
}

/*
 * Получение типа pane лайаута
 */
Module.prototype.getPane = function(){
	this.layout =  this.getContainer();
}

/**
 * Табы
 */
Module.prototype.getTabs = function() {
    var container = this.getContainer();
    container.tabs("destroy");
    container.empty();
    container.append('<div id="tabs"><ul></ul></div>');
    var tabs = $("#tabs");
    tabs.tabs({ 
        tabTemplate: '<li class="xcms-tabs"><div class="xcms-tabs-tab"><a href="#{href}"><span>#{label}</span></a></div></li>',
        ajaxOptions: {
            method: 'post'
        }
    } );
    $.each(this.options.layout.panes, function(el, obj) {
        tabs.tabs("add",'#tabs-'+el,obj.title,el);
    });
    //container.tabs();
    var sel  = tabs.tabs( "option", "selected" );
    var self = this;
    tabs.tabs({
        select: function(event, ui) {
	    
            var sel = ui.index;
            //alert(sel);
            self.layout = $('#tabs-'+sel);
            self.options.pane = sel;
	    $("#curmod").html(" / <a href=\"#\" onClick=\"main.activateModule('"+self.options.controller+"');\">"+self.options.title+"</a> / "+self.options.layout.panes[sel].title);
            self.createWidget(self.options.layout.panes[sel].widjet);
        }
        
    });
    this.layout = $('#tabs-'+sel);
    return this.layout;
}


Module.prototype.editSettings = function() {
    var url = '/admin/'+this.options.controller+'/getoptions';
    var self = this;
    $.ajax({
	url: url,
	//data: qString,
	type: 'get',
	dataType: 'json',
	beforeSend: function(){
		$("#content").append($('<div></div>').addClass('load'));
	},
	error: function(){
		throw 'Error! Wrong JSON answer';
	},
	success: function(data){
	    $('.load').remove();
	    var dial = $('<div></div>')
			.attr({
				'id' : 'dialog-form',
				'title' : 'Настройки модуля '+self.options.title
			}).append( data['form'] );
			dial.find('input[type=checkbox]').checkbox();
			dial.find('input[type=radio]').radio();
	    dial.dialog("destroy");
	    dial.dialog({
		    autoOpen: false,
		    height: 400,
		    width: 600,
		    modal: true,
		    buttons: {
			    'Сохранить': function() {
				var form = dial.find("#editform");
				$('#dialog-form').remove();
				self.saveSettings(form);
				
			    },
			    'Отмена': function() {
				    $(this).dialog('close');
				    $('#dialog-form').remove();
			    }
		    },
		    close: function() {
			    $('#dialog-form').remove();
		    }
	    });
	    $("#dialog-form").dialog('open');
	}
		
    });
    
}

Module.prototype.saveSettings = function(form) {
    var self = this;
    var url = '/admin/'+this.options.controller+'/saveoptions';
    var qString = form.formSerialize();
    $.ajax({
	url: url,
	data: qString,
	type: 'post',
	dataType: 'json',
	beforeSend: function(){
		$("#content").append($('<div></div>').addClass('load'));
	},
	error: function(){
		throw 'Error! Wrong JSON answer';
	},
	success: function(data){
	    $('.load').remove();
	    var dial = $('<div></div>')
			.attr({
				'id' : 'dialog-form',
				'title' : 'Настройки модуля '+self.options.title
			}).append( data['form'] );
			dial.find('input[type=checkbox]').checkbox();
			dial.find('input[type=radio]').radio();
	    dial.dialog("destroy");
	    dial.dialog({
		    autoOpen: false,
		    height: 400,
		    width: 600,
		    modal: true,
		    buttons: {
			    'Сохранить': function() {
				self.saveSettings(dial.html());
			    },
			    'Отмена': function() {
				    $(this).dialog('close');
				    $('#dialog-form').remove();
			    }
		    },
		    close: function() {
			    $('#dialog-form').remove();
		    }
	    });
	    $("#dialog-form").dialog('open');
	}
		
    });
}

/*
 * Получить контейнер для лайаута
 */
Module.prototype.getContainer = function(){
	if( this.name == 'content' ){
		return $('#jqmenu');
	}else{
		return $('#content');
	}
}

/**
 * Форма редактирования
 **/
Module.prototype.editformWidjet = function() {
    var container = this.layout;
    var option = this.options;
    option.module = 'admin';
    container.panelform('destroy');
    container.panelform(option).unbind('panelformappend')
                        .bind('panelformappend', function(e, hash){
                                var node = container.maintree( 'createNode', hash.data );
                                container.maintree( 'appendNode', node, hash.parent );
                                return;
                        });
}

/**
 * Таблицы
 **/
Module.prototype.tableWidget = function() {
    var container = this.layout;
    var option = this.options;
    option.module = 'admin';
    container.table('destroy');
    container.table(option)
        .unbind()
        .bind('tablenew', function(e, hash){
            switch (option.viewform) {
                case 'panel':
                    option.target = hash.target;
                    option.action = 'new';
                    container.panelform('destroy');
                    container.panelform( option )
                        .unbind('panelformappend')
                        .bind('panelformappend', function(e, hash){
                                var node = container.maintree( 'createNode', hash.data );
                                container.maintree( 'appendNode', node, hash.parent );
                                return;
                        });
                    break;
                case 'dialog':
                    container.dialogform('destroy');
                    container.dialogform();
                    break;
                default:
                    container.panelform('destroy');
                    container.panelform();
            }
        });
}


Module.prototype.mainTreeWidjet = function(){
	var container = this.getContainer();
	var option = this.options; // TODO ТУт кроется ошибка, могут быть несколько модулей с несколькими настройками
	option.module = 'admin';
	container.maintree('destroy');
	container.maintree(option)
		.unbind()
		.bind('maintreenew', function(e, hash){
			switch (option.viewform) {
				case 'panel':
					option.target = hash.target;
					option.action = 'new';
					$('#content').panelform('destroy');
					$('#content').panelform( option )
						.unbind('panelformappend')
						.bind('panelformappend', function(e, hash){
							var node = container.maintree( 'createNode', hash.data );
							container.maintree( 'appendNode', node, hash.parent );
							return;
						});
					break;
				case 'dialog':
					alert(';asdfhiluikervuhevrh');
					$('#content').dialogform('destroy');
					$('#content').dialogform();
					break;
				default:
					$('#content').panelform('destroy');
					$('#content').panelform();
			}
		})
                .bind('maintreenewsub', function(e, hash){
			switch (option.viewform) {
				case 'panel':
					option.target = hash.target;
					option.action = 'new';
					$('#content').panelform('destroy');
					$('#content').panelform( option )
						.unbind('panelformappend')
						.bind('panelformappend', function(e, hash){
							var node = container.maintree( 'createNode', hash.data );
							container.maintree( 'appendNode', node, hash.parent );
							return;
						});
					break;
				case 'dialog':
					$('#content').dialogform('destroy');
					$('#content').dialogform();
					break;
				default:
					$('#content').panelform('destroy');
					$('#content').panelform();
			}
		})
                .bind('maintreenewitem',function(e, hash){
			switch (option.viewform) {
				case 'panel':
					option.target = hash.target;
					option.action = 'newitem';
					$('#content').panelform('destroy');
					$('#content').panelform( option )
						.unbind('panelformappend')
						.bind('panelformappend', function(e, hash){
							var node = container.maintree( 'createNode', hash.data );
							container.maintree( 'appendNode', node, hash.parent );
							return;
						});
					break;
				case 'dialog':
					$('#content').dialogform('destroy');
					$('#content').dialogform();
					break;
				default:
					$('#content').panelform('destroy');
					$('#content').panelform();
			}
		})
		.bind('maintreeedit', function(e, hash){
			switch (option.viewform) {
				case 'panel':
					option.target = hash.target;
					option.action = 'edit';
                                        
					$('#content').panelform('destroy');
					$('#content').panelform( option );
					break;
				case 'dialog':
					$('#content').dialogform('destroy');
					$('#content').dialogform();
					break;
				default:
					$('#content').panelform('destroy');
					$('#content').panelform();
			}
		})
		.bind('maintreecopy', function(e, hash){
			alert('Привет');
		});
}



Module.prototype.simpleTreeWidjet = function(){
	var container = this.layout;
	var option = this.options; // TODO ТУт кроется ошибка, могут быть несколько модулей с несколькими настройками
	option.module = 'admin';
	container.simpletree('destroy');
	container.simpletree(option)
		.unbind()
		.bind('simpletreenew', function(e, hash){
			switch (option.viewform) {
				case 'panel':
					option.target = hash.target;
					option.action = 'new';
					/*$('#content')*/container.panelform('destroy');
					/*$('#content')*/container.panelform( option )
						.unbind('panelformappend')
						.bind('panelformappend', function(e, hash){
							var node = container.simpletree( 'createNode', hash.data );
							container.simpletree( 'appendNode', node, hash.parent );
							return;
							//$.fs.simpletree.appendnode;
								/*if (!current) {
									self._appendNode(node, self.element);
								}
								else {
									self._appendNode(node, parent);
								}*/
						});
					break;
				case 'dialog':
					option.target = hash.target;
					option.action = 'new';
					container.dialogform('destroy');
					container.dialogform(option).unbind('panelformappend').bind('panelformappend', function(e, hash)
					{
						var node = container.simpletree( 'createNode', hash.data );
						container.simpletree( 'appendNode', node, hash.parent );
							$.fs.simpletree.appendnode;
							/*if (!current) {
								self._appendNode(node, self.element);
							}
							else {
								self._appendNode(node, parent);
							}*/
						return;
					});
					break;
				default:
					container.panelform( 'destroy' );
					container.panelform( option );
			}
		})
                .bind('simpletreenewitem',function(e, hash){
			switch (option.viewform) {
				case 'panel':
					option.target = hash.target;
					option.action = 'newitem';
					container.panelform('destroy');
					container.panelform( option )
						.unbind('panelformappend')
						.bind('panelformappend', function(e, hash){
							var node = container.maintree( 'createNode', hash.data );
							container.maintree( 'appendNode', node, hash.parent );
							return;
						});
					break;
				case 'dialog':
					option.target = hash.target;
					option.action = 'newitem';
					container.dialogform('destroy');
					container.dialogform( option );
					break;
				default:
					$('#content').panelform('destroy');
					$('#content').panelform();
			}
		})
		.bind('simpletreeedit', function(e, hash){
			switch (option.viewform) {
				case 'panel':
					option.target = hash.target;
					option.action = 'edit';
					/*$('#content')*/container.panelform('destroy');
					/*$('#content')*/container.panelform( option );
					break;
				case 'dialog':
					option.target = hash.target;
					option.action = 'edit';
					container.dialogform('destroy');
					container.dialogform( option );
					break;
				default:
					/*$('#content')*/container.panelform('destroy');
					/*$('#content')*/container.panelform();
			}
		})
                /*
                 * Для модуля типы данных 
                 */
                .bind('simpletreeeditfield', function(e, hash){
                    option.viewform = 'dialog';
                    option.target = hash.target;
                    option.action = 'edit';
                    container.dialogform('destroy');
                    container.dialogform( option );
		})
                .bind('simpletreenewfield', function(e, hash){
                    option.viewform = 'dialog';
                    option.target = hash.target;
                    option.action = 'new';
                    container.dialogform('destroy');
                    container.dialogform( option );
		})
		.bind('simpletreecopy', function(e, hash){
			alert('Привет');
		});
}

