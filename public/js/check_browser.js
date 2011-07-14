$(document).ready(function(){
	if($.cookie('check_browser_rem') == null)
		checkBrowser();
});

function checkBrowser() {
	var ua = $.browser;
	if ( ua.msie) {
		uaver = ua.version.slice(0,1);
		uaver = uaver*1;
		if(uaver < 8) {
			errmess = '<div><table width="100%"><tr>';
			errmess += '<td style="width: auto;">';
			errmess += '<h2>Вы используете устаревший браузер!</h2>';
			errmess += '<p>Мы рекомендуем скачать и установить один из современных быстрых и безопасных браузеров, перечисленных справа:</p>';
			errmess += '</td><td><a target="_blank" href="http://www.google.com/chrome/"><img src="/cms/images/browsers/Chrome.png"><br/>Google Chrome</a></td>';
			errmess += '<td><a target="_blank" href="http://www.mozilla.com/ru/firefox/"><img src="/cms/images/browsers/Firefox.png"><br/>Mozilla Firefox</a></td>';
			errmess += '<td><a target="_blank" href="http://opera.com/"><img src="/cms/images/browsers/Opera.png"><br/>Opera</a></td>';
			errmess += '<td id="dialog_close"><a href="###"><img src="/cms/images/browsers/dialog_close.png" /></a></td>';
			errmess +='</tr></table></div>';
			var browser_err = $(errmess)
			.attr({
				'id' : 'browser_error_dialog'
			});
			$('body').prepend(browser_err);
			$('#dialog_close').click(function(){
				$('#browser_error_dialog').css('display','none');
				$.cookie('check_browser_rem', 'true', { expires: 7 });
				return false;
			});
		}
	}
}