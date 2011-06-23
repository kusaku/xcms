/*
 * init.js
 * Главный класс отвечающий за начальную инициализацию
 */
$(function() {
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
