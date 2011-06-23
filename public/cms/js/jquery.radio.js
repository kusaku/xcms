/*
 * jQuery UI Radiobutton
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */
(function($) {

$.widget("ui.radio", {
	
	options: {
		classTag: 'niceRadio'
	},
	
	_create: function() {
		this._initRadiobutton();
	},
	
	_initRadiobutton: function(){
		var self = this, o = this.options;
		self._startRadiobutton();
	},
	
	_startRadiobutton: function(){
		var self = this, o = this.options, element = this.element,
		radioName = element.attr("name"),
	    radioId = element.attr("id"),
   		radioChecked = element.attr("checked"),
    	radioDisabled = element.attr("disabled"),
    	/*radioTab = element.attr("tabindex"),*/
	    radioValue = element.attr("value");
		if(radioChecked)
	        element.after("<span class='niceRadio radioChecked'>"+
	            "<input type='radio'"+
	            "name='"+radioName+"'"+
	            "id='"+radioId+"'"+
	            "checked='"+radioChecked+"'"+
	           // "tabindex='"+radioTab+"'"+
	            "value='"+radioValue+"' /></span>");
	    else
	        element.after("<span class='niceRadio'>"+
	            "<input type='radio'"+
	            "name='"+radioName+"'"+
	            "id='"+radioId+"'"+
	           // "tabindex='"+radioTab+"'"+
	            "value='"+radioValue+"' /></span>");
     	if(radioDisabled)
	    {
	        element.next().addClass("niceRadioDisabled");
	        element.next().find("input").eq(0).attr("disabled","disabled");
	    }
		element.next().bind("mousedown", function(e) { self._changeRadio($(this)) });
	    element.next().find("input").eq(0).bind("change", function(e) { self._changeVisualRadio($(this)) });
	    if($.browser.msie)
	    {
	        element.next().find("input").eq(0).bind("click", function(e) { self._changeVisualRadio($(this)) });  
	    }
	    element.remove();
		return true
	},
	
	_changeRadio: function( span ){
		var self = this, o = this.options,
		element = this.element,
	    input = element.find("input").eq(0);
	    var name=input.attr("name");
	         
	    $("."+ o.classTag +" input").each(function()
		{   
	        if($(this).attr("name")==name)
	        {
	            $(this).parent().removeClass("radioChecked");
	        }       
	    });                  
	     
	    if(element.attr("class").indexOf("niceRadioDisabled")==-1)
	    {  
	        element.addClass("radioChecked");
	        input.attr("checked", true);
	    }  
	    return true;
	},
	
	_changeVisualRadio: function( input ){
		var self = this, o = this.options;
		var wrapInput = input.parent();
	    var name=input.attr("name");
	         
	    $("."+o.classTag+" input").each(
	     
	    function() {
	      
	        if($(this).attr("name")==name)
	        {
	            $(this).parent().removeClass("radioChecked");
	        }
	        
	        
	    });
	 
	    if(input.attr("checked"))
	    {
	        wrapInput.addClass("radioChecked");
	    }
	}
	
});

})(jQuery);