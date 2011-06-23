var params = {};
params.menu = "false";
params.quality = "high";
params.wmode = "transparent";
params.allowscriptaccess = "sameDomain";
var flashvars = {};
flashvars.xmlLink= "/admin/module/get/xml/all"; // полный путь к XML файлу
flashvars.imgLink="/cms/images/menu/";
flashvars.functPress = "main.activateModule";
flashvars.trashFunct = "updateTrash";
flashvars.dragFunct = "false";
flashvars.resetFunct = "reset";
swfobject.embedSWF("/cms/flash/flashBar_782x56.swf", "main_flash", "100%", "56", "9.0.0", "", flashvars, params);

