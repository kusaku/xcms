/*
 * jQuery UI Response
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */
(function($) {
$.widget("ui.response", $.ui.treeform, {
	
	options: {
		module: null,
		controller: null,
		animationSpeed: 500
	},

	_create: function() {
		this._request( 'get' );
	},
	
	_request: function( type, exitOnSubmit ){
		var self = this;
		var element = this.element;
		var qString;
		var form = element.find("#editform");
		if( type == 'post' ){
			qString = form.formSerialize(); // формирование строки с перемеными из формы
		}
		var url = self._getUrl();
		$.ajax({
			url: url,
			data: qString,
			type: type,
			dataType: 'json',
			error: function(){
				throw 'Error! Wrong JSON answer';
			},
			beforeSend: function(){
				element.empty();
				element.append(
						$('<div></div>')
							.addClass('load'));
			},
			success: function( data ){
				if ( !exitOnSubmit ) {
					self._updateForm( data['form'] );
				}
				else {
					self.off();
				}
				
			}
		});
	}, 
	
	_updateForm: function( data ){
		var self = this;
		var element = self.element;
		element.html( data );
		//element.find('#formcontainer').accordion({ animated: 'slide', 'autoHeight': false });
		element.find('textarea.HtmlText').tinymce({
			script_url  : '/cms/resources/tiny_mce/tiny_mce.js',
			mode        : 'textareas',
			theme       : 'simple'
		});
		element.find('input.Date').datepicker({
			dateFormat  : "yy-mm-dd",
			showOn      : 'button',
			buttonImage : '/cms/images/calendar.gif'
		});
		element.find('input:submit, button').button();
		var save_buttons = element.find('input:submit, button[name^=save]');
		save_buttons.each( function() {
			if ( this.disabled ) {
				$(this).button('disable');
			}
		});
		element.find(':input').focus( function(){
			save_buttons.button('enable').attr('disabled', '');
		});
		element.find('#fieldset-response_active').fields({
			container: element,
			module: 'admin',
			controller: 'response',
			types: [
			  {
				  element: 'status/active/category',
				  actions: { 
			      	//'delete' : 'Удалить группу полей',
			      	'edit'   : 'Редактировать ленту отзывов',
			      	'new'    : 'Создать отзыв'
		   		  }
		      },
		      {
		    	  element: 'element',
		    	  actions:{
		    	  	'delete' : 'Удалить отзыв',
		    	  	'edit'   : 'Редактировать отзыв'
			  	  }
		      }
		    ],
		    dialog: false,
		    update_tree: false,
		    done: function(){
				element.fields('destroy');
				self._request( 'get' );
			}
		});
		element.find('#fieldset-response_new').fields({
			container: element,
			module: 'admin',
			controller: 'response',
			types: [
			  {
				  element: 'status/unactive/category',
				  actions: { 
			      //	'delete' : 'Удалить группу полей',
			      	'edit'   : 'Редактировать ленту отзывов',
			      	'new'    : 'Создать отзыв'
		   		  }
		      },
		      {
		    	  element: 'element',
		    	  actions:{
		    	  	'delete' : 'Удалить поле',
		    	  	'edit'   : 'Редактировать поле'
			  	  }
		      }
		    ],
		    dialog: false,
		    update_tree: false,
		    done: function(){
				element.fields('destroy');
				self._request( 'get' );
			}
		});
		element.find('#fieldset-bulletin_active').fields({
			container: element,
			module: 'admin',
			controller: 'bulletin',
			types: [
			  {
				  element: 'status/active/category',
				  actions: { 
			      	//'delete' : 'Удалить группу полей',
			      	'edit'   : 'Редактировать ленту объявлений',
			      	'new'    : 'Создать объявление'
		   		  }
		      },
		      {
		    	  element: 'element',
		    	  actions:{
		    	  	'delete' : 'Удалить объявление',
		    	  	'edit'   : 'Редактировать объявление'
			  	  }
		      }
		    ],
		    dialog: false,
		    update_tree: false,
		    done: function(){
				element.fields('destroy');
				self._request( 'get' );
			}
		});
		element.find('#fieldset-bulletin_new').fields({
			container: element,
			module: 'admin',
			controller: 'bulletin',
			types: [
			  {
				  element: 'status/unactive/category',
				  actions: { 
			      //	'delete' : 'Удалить группу полей',
			      	'edit'   : 'Редактировать ленту объявлений',
			      	'new'    : 'Создать объявление'
		   		  }
		      },
		      {
		    	  element: 'element',
		    	  actions:{
		    	  	'delete' : 'Удалить объявление',
		    	  	'edit'   : 'Редактировать объявление'
			  	  }
		      }
		    ],
		    dialog: false,
		    update_tree: false,
		    done: function(){
				element.fields('destroy');
				self._request( 'get' );
			}
		});
		element.find('#fieldset-faq_active').fields({
			container: element,
			module: 'admin',
			controller: 'faq',
			types: [
			  {
				  element: 'status/active/category',
				  actions: { 
			      	'edit'   : 'Редактировать ленту вопросов',
			      	'new'    : 'Создать вопрос'
		   		  }
		      },
		      {
		    	  element: 'element',
		    	  actions:{
		    	  	'delete' : 'Удалить вопрос',
		    	  	'edit'   : 'Редактировать вопрос'
			  	  }
		      }
		    ],
		    dialog: false,
		    update_tree: false,
		    done: function(){
				element.fields('destroy');
				self._request( 'get' );
			}
		});
		element.find('#fieldset-faq_new').fields({
			container: element,
			module: 'admin',
			controller: 'faq',
			types: [
			  {
				  element: 'status/unactive/category',
				  actions: { 
			      	'edit'   : 'Редактировать ленту вопросов',
			      	'new'    : 'Создать вопрос'
		   		  }
		      },
		      {
		    	  element: 'element',
		    	  actions:{
		    	  	'delete' : 'Удалить вопрос',
		    	  	'edit'   : 'Редактировать вопрос'
			  	  }
		      }
		    ],
		    dialog: false,
		    update_tree: false,
		    done: function(){
				element.fields('destroy');
				self._request( 'get' );
			}
		});
		element.find('.header').click(
				function(event){
					var panel = $(event.target).parents('div.panel');
					var cont = panel.children('.content');
					if ( cont.css("display")=='none' ) {
						cont.slideDown( self.options.animationSpeed, function(){panel.attr('style', 'overflow:visible');} );
						$(this).removeClass('arrow_down').addClass('arrow_up').attr('title', 'Свернуть');
					} else {
						cont.slideUp( self.options.animationSpeed );
						panel.attr('style', 'overflow:hidden');
						$(this).removeClass('arrow_up').addClass('arrow_down').attr('title', 'Развернуть');
					}
			});
		element.find('input[type=checkbox]').checkbox();
		element.find('span[class^=nice]').click( function(){
			save_buttons.button('enable').attr('disabled', '');
		});
		element.find('button[name^=cancel]')
			.unbind('click')
			.bind('click',
				function(){
					self.off();
				}
		);
		element.find('button[name^=save_exit]')
			.unbind('click')
			.bind('click',
				function(){
					self._request( 'post', true );
				}
			);
		element
			.unbind('submit')
			.submit(
				function(){
					self._request( 'post' );
					return false;
				});
		
	},
	
	_getUrl: function( ) {
		var o = this.options;
		var action = 'get';
		var url = '/'+ o.module +'/'+ o.controller +'/' + action + '/all';
		return url;
	},
	
	off: function() {
		this._trigger('done');
	},
	
	destroy: function() {
		$.Widget.prototype.destroy.call( this );
		this.element.empty();
	}
	
});
})(jQuery);