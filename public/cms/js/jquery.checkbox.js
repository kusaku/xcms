/*
 * jQuery UI Checkbox
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */
(function($) {

$.widget("ui.checkbox", {
	
	options: {
		classTag: 'niceCheck',
		multiCheckbox: false
	},
	
	_create: function() {
		this._initCheckbox();
	},
	
	_initCheckbox: function(){
		var self = this, o = this.options;
		if (!o.multiCheckbox) {
			var checkName = self.element.attr("name"),
			checkId = self.element.attr("id"),
			checkChecked = self.element.attr("checked"),
			checkDisabled = self.element.attr("disabled"),
			checkValue = self.element.attr("value");
			if( self.element.siblings('input').size()==0 ){
				if(checkChecked){
					self.element.parent('label').eq(0).before("<span class='"+o.classTag+" niceChecked'>"+
						"<input type='checkbox'"+
						"name='"+checkName+"'"+
						"id='"+checkId+"'"+
						"checked='"+checkChecked+"'"+
						"value='"+checkValue+"'"+"></span>");
				}else{
					self.element.parent('label').eq(0).before("<span class='"+o.classTag+"'>"+
						"<input type='checkbox'"+
						"name='"+checkName+"'"+
						"id='"+checkId+"'"+
						"value='"+checkValue+"'"+
						"></span>");
				}
				self.element.parents('label').prev().bind("mousedown", function(e) { self._changeCheck($(this)); });
				self.element.parents('label').prev().find("input").eq(0).bind("change", function(e) { self._changeVisualCheck($(this)); });
				if($.browser.msie){
					self.element.parents('label').prev().find("input").eq(0).bind("click", function(e) { self._changeVisualCheck($(this)); });  
				}
			}else{
				if(checkChecked){
					self.element.after("<span class='"+o.classTag+" niceChecked'>"+
						"<input type='checkbox'"+
						"name='"+checkName+"'"+
						"id='"+checkId+"'"+
						"checked='"+checkChecked+"'"+
						"value='"+checkValue+"'"+"></span>");
				}else{
					self.element.after("<span class='"+o.classTag+"'>"+
						"<input type='checkbox'"+
						"name='"+checkName+"'"+
						"id='"+checkId+"'"+
						"value='"+checkValue+"'"+
						"></span>");
				}
				
				//* если checkbox disabled - добавляем соотвсмтвующи класс для нужного вида и добавляем атрибут disabled для вложенного chekcbox */     
				if(checkDisabled){
					self.element.next().addClass("niceCheckDisabled");
					self.element.next().find("input").eq(0).attr("disabled","disabled");
				}
				
				self.element.next().bind("mousedown", function(e) { self._changeCheck($(this)); });
				self.element.next().find("input").eq(0).bind("change", function(e) { self._changeVisualCheck($(this)); });
				if($.browser.msie){
					self.element.next().find("input").eq(0).bind("click", function(e) { self._changeVisualCheck($(this)); });  
				}
			}
			self.element.remove();
		}else{
			self.element.wrap(
				$('<span></span>')
					.addClass( o.classTag )
					.mousedown(
						function() {
							self._changeCheck( $(this) );   
						})
			);
			self._selectCheckbox();
		}
	},
	
	_changeVisualCheck: function( input ){
		var self = this, o = this.options;
		var wrapInput = input.parent();
		if(!input.attr("checked")) {
			wrapInput.removeClass("niceChecked");
		}else{
			wrapInput.addClass("niceChecked");
		}
	},
	
	_selectCheckbox: function(){
		var self = this, o = this.options;
		var span = self.element.parent('span').eq(0);
		if(self.element.attr("checked")) {
			span.css("background-position","0 -13px");	
		}
	},
	
	_changeCheck: function( span ){
		var self = this, o = this.options;
		if (o.multiCheckbox) {
			var input = span.children(span).eq(0);
			if ( !input.attr("checked") ) {
				span.css("background-position", "0 -13px");
				input.attr("checked", "checked");
			}
			else {
				span.css("background-position", "0 0");
				input.attr("checked", false);
			}
		}
		else {
			var input_hidden = span.siblings("input").eq(0);
			var input = span.find("input").eq(0);
			if(span.attr("class").indexOf("niceCheckDisabled")==-1){
				if (!input.attr("checked")) {
					span.addClass("niceChecked");
					input.attr("checked", true);
					input_hidden.attr("value", 1);
				}
				else {
					input.attr("checked", false).focus();
					span.removeClass("niceChecked");
					input_hidden.attr("value", 0);
				
				}
			}
		}
	}
	
});

})(jQuery);