/*
 * init.js
 * Главный класс отвечающий за начальную инициализацию
 */
$(function() {
	checkBrowser();
	main = new Main();
	main.init();
	toMain();
	/*Логотип*/
	$('#logo a').bind('click', function( event ) {
		toMain( main );
		return false;
	} );
	/*Карусель для меню модулей*/
	$('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});
    $('.menu_item').hover( function(){
    	if($(this).attr('picture')=='config') pict='admin';
        else pict=$(this).attr('picture');
        $(this).attr('src', '/cms/images/menu/noflash/'+pict+'Over.png');
    }, function(){
        if($(this).attr('picture')=='config') pict='admin';
        else pict=$(this).attr('picture');
        $(this).attr('src', '/cms/images/menu/noflash/'+pict+'.png');
    });
    $("#settings").click( function() { main.moduleSettings() } );
});

function toMain(){
	$('#content').empty();
	main.activateModule('admin');
	$('#navigation').empty().append($('<a>').attr('href', '/admin/').text('Главная').bind('click', function(event){
		toMain(main);
		return false;
	})).append($('<span>').attr('id', 'curmod'));
	flash = document.getElementById('main_flash');
	if (flash.reset) 
		flash.reset();
}

function moduleClick( name ){
	main.activateModule( name );
}

function checkBrowser() {
	var ua = $.browser;
	if ( ua.msie) {
		uaver = ua.version.slice(0,1);
		uaver = uaver*1;
		if(uaver < 8) {
			//alert("You are uses a fucking browser");
			errmess = '<div>';
			errmess += '<div style="text-align:center;"><b>Внимание!</b><br/>';
			errmess += '</div><br/>';
			errmess += 'Данная версия браузера сильно устарела, ее использование может привести к нарушениям в работе системы управления сайтом и угрожать безопасности компьютера.<br/><br/>';
			errmess += 'Для корректной и безопасной работы CMS "Фабрика сайтов" следует скачать и установить последнюю версию одного из следующих браузеров:';
			errmess += '<table align="center" style="margin-top: 20px;"><tr>';
			errmess += '<td style="text-align:center;"><a href="http://www.google.com/chrome/" target="_blank"><img style="width:64px; height: 64px;" src="/cms/images/browsers/ChromeAdm.png" /></a></td>';
			errmess += '<td style="text-align:center; padding-left: 50px;"><a href="http://www.mozilla.com/ru/firefox/" target="_blank"><img style="width:64px; height: 64px;" src="/cms/images/browsers/FirefoxAdm.png" /></a></td>';
			errmess += '<td style="text-align:center; padding-left: 50px;"><a href="http://opera.com/" target="_blank"><img style="width:64px; height: 64px;" src="/cms/images/browsers/OperaAdm.png" /></a></td>';
			errmess += '</tr><tr>';
			errmess += '<td style="text-align:center;"><a href="http://www.google.com/chrome/" target="_blank">Google Chrome</a></td>';
			errmess += '<td style="text-align:center; padding-left: 50px;"><a href="http://www.mozilla.com/ru/firefox/" target="_blank">Mozilla Firefox</a></td>';
			errmess += '<td style="text-align:center; padding-left: 50px;"><a href="http://opera.com/" target="_blank">Opera</a></td>';
			errmess += '</tr></table>';
			errmess += '</div>';
			var dialog_form = $(errmess)
			.attr({
				'id' : 'brerr-dialog-form',
				'title' : 'Внимание'
			});
			$('body').append(dialog_form);
			$("#brerr-dialog-form").dialog("destroy");
			$("#brerr-dialog-form").dialog({
					autoOpen: false,
					height: 300,
					width: 500,
					modal: true,
					buttons: {
						'Я осознаю опасность, продолжить': function() {
							$(this).dialog('close');
							$("#brerr-dialog-form").remove();
						}
					}
			});
			$("#brerr-dialog-form").dialog("open");
		}
	}
}
