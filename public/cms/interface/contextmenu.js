(function($) {

$.widget("fs.contextmenu", {
	options:{
		actions: null,
		container:null
	},
	
	_create: function(){
		var self = this, o = this.options;
		var actions = $(this.element).data('context').actions;
		if(typeof actions == 'undefined')
			actions = o.actions;
		this._createContextMenu( actions );
	},
	
	/*
	 * Создание контекстного меню(контейнера)
	 * @param {Array} actions Массив кнопок действий
	 */
	_createContextMenu: function( actions ){
		var self = this, o = this.options;
		ul = o.container;
		ul.empty();
		self._appendChildren( actions, ul );
	},
	
	/*
	 * Создание ноды
	 * @param {Object} action Действие
	 * @param {Object} name Название действия
	 */
	_createNode: function( action, name ){
		var node = $('<li id="action_' + action +'"></li>')
						.append(
							$('<span></span>')
								.addClass( action+ ' icon' )
						)
						.append( name );
		return node;
	},
	
	/*
	 * Добавление элементов  в контейнер
	 * @param {Object} actions Массив кнопок действий
	 * @param {Object} parent Родительский контейнер
	 */
	_appendChildren: function( actions, parent ){
		var self = this;
		$.each(actions, function(i, item) {
			var node = self._createNode( i, item );
			parent.append( node );
		});
	}
});
})(jQuery);