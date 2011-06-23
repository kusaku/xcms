/*
 * Jquery Fs Toolbar
 * toolbar.js
 * Виджет, отвечает за создание тулбара для элемента дерева.
 * 
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */

(function($) {

$.widget("fs.toolbar", {
	options:{
		container: null
	},
	
	_create: function(){
		this._initToolbar();
	},
	
	/*
	 *	Инициализация тулбара 
	 */
	_initToolbar: function(){
		this._Position();
	},
	
	/*
     * Метод по заданию позиционирования Тулбара
     */
	_Position: function(){
		var self = this, o = this.options;
		var header = self.element;
		if ( !header ) throw 'Error! Node header is not exists';
		var is_locked = header.data('context').is_locked;
		if( !is_locked ){
			o.container.children('.tree-toolbar-context')
				.show().position({
					of: header,
					my: 'right',
					at: 'right',
					collision: 'none none'
				})
				.data('current', header); // Сохраняем заголовок текущего элемента
		}
		else{
			o.container.children('.tree-toolbar-locked')
				.show().position({
					of: header,
					my: 'right',
					at: 'right',
					collision: 'none none'
				})
				.data('current', header); // Сохраняем заголовок текущего элемента

		}
	}
});
})(jQuery);