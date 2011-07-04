<?php
//ini_set('register_globals',"0");
session_start();
//if(!is_int($_SESSION['step'])) $_SESSION['step']=-1;
defined('APPLICATION_PATH')
    || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application'));
define('DB_CONFIG_FILE', APPLICATION_PATH . '/configs/config.ini');
if (!defined('PHP_VERSION_ID')) {
    $version = explode('.', PHP_VERSION);
    define('PHP_VERSION_ID', ($version[0] * 10000 + $version[1] * 100 + $version[2]));
}
set_include_path(implode(PATH_SEPARATOR, array(
    realpath(APPLICATION_PATH . '/../library'),
    get_include_path(),
)));
global $edition;
//print_r($_SESSION);
$edition = include(APPLICATION_PATH.'/configs/edition.php');


$steps = array (
		'0'  => 'Начало установки',
		'1' => 'Настройки сервера',
		'2' => 'Параметры установки',
		'3' => 'Подключение к Базе Данных',
		'4' => 'Проверка настроек',
                '5' => 'База данных создана',
                '6' => 'Создание администратора',
                '7' => 'Установка завершена'
	);

if( ! isset($_SESSION['step']) ) {
    $_SESSION['step'] = -1;
    if( $_SESSION['step'] <= -1 ) {
        $_SESSION['step'] = -1;
    }
}
$errors = array();

/**
 * Подключение к БД
 * @global res $link
 * @return array(string,boolean)
 */
function check_db_connection() {
    global $link;
    $link = @mysql_connect($_SESSION['db_host'],$_SESSION['db_login'],$_SESSION['db_pass']);
    if(! $link) {
        $result['message'] = mysql_error();
        $result['result'] = false;
        return $result;
    }
    $result['message'] = '';
    $result['result'] = true;
    return $result;
}

/**
 * Создание БД
 * @global res $link
 * @return boolean
 */
function create_db() {
    global $link;
    $db_file =  APPLICATION_PATH.'/../data/db/'. $_SESSION['dump_file'];
    $s = file_get_contents($db_file);
    //$s = preg_replace('/\s+--\s\w+\s\w+/','',$s);
    $s = preg_replace('/--[\s\w]+\n/U','',$s);
    $q = explode(";\n",$s);
	//echo "<pre>"; var_dump($q); echo "</pre>"; exit;
    if($_SESSION['db_create']==1) {
        mysql_query('CREATE DATABASE IF NOT EXISTS `'.$_SESSION['db_name'].'`');
    }
    mysql_select_db($_SESSION['db_name'],$link);// or die(mysql_error());
    mysql_query('SET NAMES utf8');
    mysql_query('START TRANSACTION');
    foreach ($q as $query) {
        if( trim($query)!='' ) {
            $now_query = $query;
            if(!mysql_query($query)){

                $result['message'] .=
                    'Ошибка при создании Базы данных: <br/>'
                    .mysql_error();
                $result['result'] = false;
                mysql_query('ROLLBACK');
                return $result;
            }
        }
    }
    mysql_query('COMMIT');
    mysql_close();
    $result['message'] = '';
    $result['result'] = true;
    return $result;
}

function config_write() {
    require_once 'Zend/Config.php';
    require_once 'Zend/Config/Writer/Ini.php';
    // Конфиг config.ini
    $config = new Zend_Config(array(),true);
    $config->production = array();
    $config->testing = array();
    $config->development = array();
    $config->setExtend('development','production');
    $config->setExtend('testing','production');
    //production section
    $config->production =array (
        'db' => array(
                'adapter' => 'PDO_MySQL',
                'params' => array(
                    'username' => $_SESSION['db_login'],
                    'password' => $_SESSION['db_pass'],
                    'host' => $_SESSION['db_host'],
                    'dbname' => $_SESSION['db_name']
                )
        )
    );
    //development section
    $config->development = array (
        'db' => array(
            'params' =>
                array(
                    'profiler' => array(
                        'enabled' => 1,
                        'class' => 'Zend_Db_Profiler_Firebug'
                    )
                )
         )
    );
    // Сохранение
    $writer = new Zend_Config_Writer_Ini(array('config'   => $config,
                                               'filename' => DB_CONFIG_FILE));
    $writer->write();
    $conf = parse_ini_file(DB_CONFIG_FILE);
    if($conf['db.params.username']!=$_SESSION['db_login'] || $conf['db.params.dbname']!=$_SESSION['db_name']) {
        $result['message'] = 'Ошибка записи конфигурационного файла';
        $result['result'] = false;
        return $result;
    }
    $result['message'] = '';
    $result['result'] = true;
    return $result;
}

/**
 * Создание суперпользователя
 * @param <type> $post 
 */
function create_superuser($post) {
    global $edition;
    $password = substr(md5($post['superuser_login'].time()),1,8);
    $key = $edition['staticSalt'];
    $link = mysql_connect($_SESSION['db_host'],$_SESSION['db_login'],$_SESSION['db_pass']);
    mysql_select_db($_SESSION['db_name'],$link);
    mysql_query('SET NAMES utf8');
    if(!mysql_query('
        INSERT INTO users(name,id_object,id_usergroup,is_active,password)
        VALUES("'.$post['superuser_login'].'",10025,3,1,"'.md5($key.$password).'")
        ON DUPLICATE KEY UPDATE id_usergroup=3,password="'.md5($key.$password).'"
            ') ) {
        $result['result'] = false;
        $result['message'] = 'Ошибка при создании пользователя';
        mysql_close();
        return $result;
    }
    $_SESSION['superuser_password'] = $password;
    $result['result'] = true;
    $result['message'] = '';
    mysql_close();
    file_put_contents(APPLICATION_PATH.'/../installed','');
    return $result;
    //id	name	id_object	id_usergroup	is_active	password
    //1         master	5               3               1               6442f810d42825ec2de9bfade765147d
}

/**
 * Вывод формы, в зависимости от шага
 * @param int $step | Текущий шаг
 * @param array $errors | Глобальный массив ошибок
 * @return string
 */
function step_control($step,$errors) {
    $html = '<form method="post" id="installStep">';
    switch($step) {
        //Лицензия
        case 0:
            $licensetext = file_get_contents('license.txt');
            $html .= '  <div style="text-align:left;margin:10px;width:90%;height:200px;overflow:auto;">'.$licensetext.'</div>
                        <div class="error">'.$errors['license'].'</div>
                        <div class="navigation">
                        <div class="lic_agree">
                        <input type="hidden" name="license_agree" value="0">
                        <input type="checkbox" id="license_agree" name="license_agree" checked="'.(empty($_POST['license_agree']) ? 0 : $_POST['license_agree'] ).'" value="1">
                        <label for="license_agree" class="elem_label">Принять лицензию</label>
                        </div><input type="submit" name="next" id="next" value="Далее" class="navigation_submit_next">
                        </div>';
            break;
        //Настройки сервера
        case 1:
            $html .= '
                        <div class="element" style="margin-top:50px;">
                            <div class="elem">
                                Версия PHP:
                            </div>
                            <div class="value">
                            '.((PHP_VERSION_ID>50200) ? PHP_VERSION : '<div class="error">'.PHP_VERSION.'</div>') .'
                            </div>
                            <div class="error">'.$errors['php_version'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Поддержка MySQL:
                            </div>
                            <div class="value">
                            '.(extension_loaded("mysql") ? "Да" : '<span class="error">Нет</span>').'
                            </div>
                            <div class="error">'.$errors['mysql'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Права на директории:
                            </div>
                            <div class="value">
                            '.(is_writable(APPLICATION_PATH.'/../') ? "Да" : '<span class="error">Нет</span>').'
                            </div>
                            <div class="error">'.$errors['writable'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Поддержка GD2:
                            </div>
                            <div class="value">
                            '.(extension_loaded("gd") ? "Да" : '<span class="error">Нет</span>').'
                            </div>
                            <div class="error">'.$errors['gd'].'</div>
                        </div>
                         <div class="element">
                            <div class="elem">
                                Поддержка Zip:
                            </div>
                            <div class="value">
                            '.(extension_loaded("zip") ? "Да" : '<span class="error">Нет</span>').'
                            </div>
                            <div class="error">'.$errors['zip'].'</div>
                        </div>
                        <div class="navigation">
                            <input type="submit" name="prev" id="prev" value="Назад" class="navigation_submit_prev"><input type="submit" name="next" id="next" value="Далее" class="navigation_submit_next">
                        </div>';
            break;
        // Выбор дампа БД
        case 2:
            $dir = opendir(APPLICATION_PATH.'/../data/db/');
            $values[0] = '------';
            while (false !== ($file = readdir($dir))) {
                if( substr( $file ,-4 , 4) == '.sql') {
                    $values[$file] = $file;
                }
            }
            $select = '<select name="dump_file">';
            foreach($values  as $key=>$val) {
                $select.='<option value="'.$key.'" '.( ($_SESSION['dump_file']==$key) ? 'selected': '').'>'.$val.'</option>';
            }
            $select.='</select>';
            $html .= '
                    <div style="margin-top:100px;">
                        Файл дампа ../data/db/:<br/>
                        '.$select.'<br/>
                        <div class="error">'.$errors['dump'].'</div>
                    </div>
                    <div class="navigation">
                        <input type="submit" name="prev" id="prev" value="Назад" class="navigation_submit_prev"><input type="submit" name="next" id="next" value="Далее" class="navigation_submit_next">
                    </div>';
            break;
        // Настройки подключения к серверу
        case 3:
            $html .= '
                    <div class="error">'.$errors['connection'].'</div>
                    <div class="element" style="margin-top:50px;">
                            <div class="elem">
                                Пользователь БД:
                            </div>
                            <div class="value">
                                <input type="text" name="db_login" value="'.(empty($_POST['db_login']) ? $_SESSION['db_login'] : $_POST['db_login']).'"/>
                            </div>
                            <div class="error">'.$errors['db_login'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Пароль к БД:
                            </div>
                            <div class="value">
                                <input type="password" name="db_pass" value="'.$_POST['db_pass'].'"/>
                            </div>
                            <div class="error">'.$errors['db_pass'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Сервер БД:
                            </div>
                            <div class="value">
                                <input type="text" name="db_host" value="'.(empty($_POST['db_host']) ? $_SESSION['db_host'] : $_POST['db_host']).'"/>
                            </div>
                            <div class="error">'.$errors['db_host'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Название БД:
                            </div>
                            <div class="value">
                                <input type="text" name="db_name" value="'.(empty($_POST['db_name']) ? $_SESSION['db_name'] : $_POST['db_name']).'"/>
                            </div>
                            <div class="error">'.$errors['db_name'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                            <label for="db_create" class="elem_label">Создать БД: </label>
                            </div>
                            <div class="value">
                            <input type="hidden" name="db_create" value="0">
                            <input type="checkbox" id="db_create" name="db_create" '.(empty($_SESSION['db_create']) ? '' : 'checked' ).' value="1">
                            </div>
                            <div class="error">'.$errors['db_create'].'</div>
                        </div>
                        <div class="navigation">
                            <input type="submit" name="prev" id="prev" value="Назад" class="navigation_submit_prev"/>
                            <input type="submit" name="next" id="next" value="Далее" class="navigation_submit_next"/>
                        </div>';
            break;
        // Проверка настроек сервера
        case 4:
            $s = '<table class="InstallResult">
                    <tr>
                        <td>Пользователь MySQL: </td><td class="val">'.$_SESSION['db_login'].'</td>
                    </tr>
                    <tr>
                        <td>Сервер MySQL: </td><td class="val">'.$_SESSION['db_host'].'</td>
                    </tr>
                    <tr>
                        <td>Название БД: </td><td class="val">'.$_SESSION['db_name'].'</td>
                    </tr>
                </table>';

            $html .= $s.'<div class="navigation">
                        <input type="submit" name="prev" id="prev" value="Назад" class="navigation_submit_prev"><input type="submit" name="next" id="next" value="Далее" class="navigation_submit_next">
                      </div>';
            break;
        // Результат создания БД
        case 5:
            $html .= '<div class="element">
                            <div class="elem">
                                Соединение с БД:
                            </div>
                            <div class="value">
                            '.(empty($errors['db_connection']) ? "Успешно" : '<span class="error">Ошибка</span>').'
                            </div>
                            <div class="error">'.$errors['db_connection'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Создание БД:
                            </div>
                            <div class="value">
                            '.(empty($errors['db_create']) ? "Успешно" : '<span class="error">Ошибка</span>').'
                            </div>
                            <div class="error">'.$errors['db_create'].'</div>
                        </div>
                        <div class="element">
                            <div class="elem">
                                Конфиг создан:
                            </div>
                            <div class="value">
                            '.(empty($errors['ini_result']) ? "Успешно" : '<span class="error">Ошибка</span>').'
                            </div>
                            <div class="error">'.$errors['ini_result'].'</div>
                        </div>
                        <div class="navigation">';
                        if( !empty($errors) )
                            $html.='<input type="submit" name="prev" id="prev" value="Назад" class="navigation_submit_prev">';
                        else{
                            $html.='<input type="submit" name="next" id="next" value="Далее" class="navigation_submit_next">';
                        }
                        $html.='</div>';
            break;
        // Создание суперадмина
        case 6:
            $html .= '<div class="element">
                            <div class="elem">
                                Логин суперпользователя:
                            </div>
                            <div class="value">
                                <input type="text" name="superuser_login" value="'.(empty($_POST['superuser_login']) ? $_SESSION['superuser_login'] : $_POST['superuser_login']).'"/>
                            </div>
                            <div class="error">'.$errors['superuser_login'].'</div>
                        </div>
                        <div class="navigation">
                        <input type="submit" name="prev" id="prev" value="Назад" class="navigation_submit_prev"><input type="submit" name="next" id="next" value="Далее" class="navigation_submit_next">
                        </div>';
            break;
        // Установка завершена
        case 7:
            $html.= '<p><b style="color:red;">Внимание!!!</b>
                    Не забудьте записать пароль суперадминистратора
                    </p>
                    <p>
                    Поздравляем, установка успешно завершена. 
                    </p>
                    <table class="InstallResult">
                    <tr>
                        <td>Пользователь MySQL: </td><td class="val">'.$_SESSION['db_login'].'</td>
                    </tr>
                    <tr>
                        <td>Сервер MySQL: </td><td class="val">'.$_SESSION['db_host'].'</td>
                    </tr>
                    <tr>
                        <td>Название БД: </td><td class="val">'.$_SESSION['db_name'].'</td>
                    </tr>
                    <tr><td></td><td class="val"></td></tr>
                    <tr>
                        <td>Логин суперпользователя: </td><td class="val">'.$_SESSION['superuser_login'].'</td>
                    </tr>
                    <tr>
                        <td>Пароль суперпользователя: </td><td class="val">'.$_SESSION['superuser_password'].'</td>
                    </tr>
                    <tr><td></td><td class="val"></td></tr>
                    <tr>
                            <td>Начать работу с сайтом: </td><td class="val"><a href="'.$_SERVER['HTTP_ORIGIN'].'/admin">'.$_SERVER['HTTP_HOST'].'/admin</a></td>
                    </tr>
                </table>';
            break;

    }
    $html .='</form>';
    return $html;
}

/**
 * Проверка форм на ошибки
 * @param int $step
 * @param array $errors
 * @return boolean
 */
function check_step($step,$errors) {
    $errors=array();
    switch($step) {
        case 0:
            if( $_POST['license_agree']!=1 ) {
                $errors['license'] = 'Вы должны принять условия лицензии';
            } 
            break;
        case 1:
            if ( PHP_VERSION_ID < 50200 ) {
                $errors['php_version'] = 'Необходима версия PHP не ниже 5.2 '.PHP_VERSION_ID;
                return false;
            }
            if (!extension_loaded("mysql") ) {
                $errors['mysql'] = 'Необходима поддержка MySQL';
                return false;
            }
            if (!extension_loaded("gd") ) {
                $errors['mysql'] = 'Необходима поддержка GD';
                return false;
            }
            if (!extension_loaded("zip") ) {
                $errors['zip'] = 'Необходима поддержка Zip';
                return false;
            }
            if (!is_writable(APPLICATION_PATH.'/../') ) {
                $errors['writable'] = 'Необходимы права на запись';
                return false;
            }
            break;
        case 2:
            if( $_POST['dump_file']=='0' ) {
                $errors['dump'] = 'Выберите файл дампа';
            }
            break;
        case 3:
            if( empty($_POST['db_login']) ) {
                $errors['db_login'] = 'Необходимо ввести имя';
                return false;
            }
            if( empty($_POST['db_host']) ) {
                $errors['db_host'] = 'Необходимо ввести хост';
                return false;
            }
            if( empty($_POST['db_name']) ) {
                $errors['db_name'] = 'Необходимо ввести имя БД';
                return false;
            }
            $link = @mysql_connect($_POST['db_host'],$_POST['db_login'],$_POST['db_pass']);
            if(! $link) { 
                $errors['connection'] = 'Неверные параметры подключения';
                return false;
            }
            if( $_POST['db_create'] == 1 ) {
                if(mysql_select_db($_POST['db_name']) ) {
                    $errors['db_create'] = 'БД&nbsp;'.$_POST['db_name'].' уже существует';
                }
            } else {
                if(! mysql_select_db($_POST['db_name']) ) {
                    $errors['db_create'] = 'БД&nbsp;'.$_POST['db_name'].' не существует';
                } 
            }
            mysql_close();
            break;
        case 4:
            $res_conn = check_db_connection();
            if($res_conn['result']) {
                $res_create = create_db();
                if($res_create['result']) {
                    $res_config = config_write();
                }
            }

            if(!$res_conn['result'])$errors['db_connection'] = $res_conn['message'];
            if(!$res_create['result'])$errors['db_create'] = $res_create['message'];
            if(!$res_config['result'])$errors['ini_result'] = $res_config['message'];
            return true;
            break;
        case 5:
            break;
        case 6:
            if(!empty( $_POST['superuser_login'] ) ) {
                $su_result = create_superuser($_POST);
                if(!$su_result['result']) $errors['superuser_login']=$su_result['message'];
            } else {
                $errors['superuser_login'] = 'Логин не может быть пустым';
            }
            break;
    }
    if( count($errors)>0 ) {
        return false;
    }
    foreach ($_POST as $key=>$value) {
        $_SESSION[$key] = $value;
    }
    return true;
}


if(@$_REQUEST['next']) {
    if( check_step($_SESSION['step'],&$errors) ) {
        $_SESSION['step'] +=1;
        if( $_SESSION['step'] >= ( count($steps)) ) {
            $_SESSION['step'] = 7;
        }
    } 
}
if(@$_REQUEST['prev']) {
    $_SESSION['step'] -=1;
}
$html = step_control($_SESSION['step'],$errors);
//print_r($_POST);
//print_r($_SESSION);
//print_r($errors);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
<html>
    <head>
        <title>Установка xCMS</title>
        <link href="/cms/css/base.css" media="screen" rel="stylesheet" type="text/css"/>
        <link href="/cms/css/selectsComments.css" media="screen" rel="stylesheet" type="text/css"/>
        <link href="/cms/resources/jquery/ui/themes/ui-lightness/jquery-ui-1.8.custom.css" media="screen" rel="stylesheet" type="text/css"/>
        <link href="/cms/css/cusel.css" media="screen" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" src="/cms/resources/jquery/jquery-1.4.2.min.js"></script>
        <script type="text/javascript" src="/cms/resources/jquery/jquery.validation.js"></script>
        <script type="text/javascript" src="/cms/resources/jquery/ui/jquery-ui-1.8.1.custom.js"></script>
        <script type="text/javascript" src="/cms/js/jScrollPane.js"></script>
        <script type="text/javascript" src="/cms/js/jquery.checkbox.js"></script>
        <script type="text/javascript" src="/cms/js/cusel.js"></script>
        <script type="text/javascript" src="/cms/js/jquery.mousewheel.js"></script>
        <script type="text/javascript" src="/cms/js/install.js"></script>
    </head>
    <body>
    <?if( file_exists(APPLICATION_PATH.'/../installed') && $_SESSION['step']<4) : ?>
        <div id="wrap">
        <div id="logoMain"></div>
	<div id="text">
	<p class="error">
	Внимание!
	</p>
	<p>
	Установка CMS Фабрика сайтов, успешно выполнена.
	Дальнейшее использование данного мастера установки
	невозможно. Предлагаем перейти на
	главную страницу сайта.
	</p>
	<div class="link_install">
	<a href="/">На главную</a>
	<img src="/cms/images/arrowOrangeRight.gif" class="arrow"/>
	</div>
	</div>
        </div>
    <? elseif ($_SESSION['step']==-1 && !file_exists(APPLICATION_PATH.'/../installed') ):?>
        <div id="wrap">
	<div id="logoMain"></div>
	<div id="text">
	<p>Вас приветствует мастер установки xCMS компании «Фабрика сайтов»!
            Благодарим Вас за выбор нашего продукта! Процесс установки
            автоматизирован. Пожалуйста, следуйте подсказкам, заполняйте
            необходимые поля и, убедившись в правильности их заполнения,
            нажимайте кнопку «Далее». На последнем шаге буде отображен
            автоматически сгенерированный пароль суперадминистратора.
            Убедительная просьба сохранить логин и пароль в известном
            только Вам месте и не сообщать их третьим лицам.
	</p>
	<div class="link_install">
	<form method="post">
              <input type="submit" name="next" id="next" value="Начать установку CMS" class="navigation_submit_next2"/>
        </form>
	</div>
        </div>
	</div>
    <? else: ?>
        <div id="main">
            <div id="logo">
            <img src="/cms/images/mainLogo.png"  alt="Фабрика сайтов" border="0" />
            </div>
                <div id="header">
                    Мастер установки <span class="fc">CMS</span> системы
                </div>
                <div id="step">
                <?php $flag = false;?>
                <?php foreach ($steps as $key=>$step_name):?>
                <div <?php if($key==$_SESSION['step']):?>class="now_step">
                <?php $flag = true;?>
                <?php elseif($flag):?>
                class="future_step">
                <?php else:?>
                    class="step">
                <?php endif;?>
                    <?=$step_name;?>
                <?php if($key==$_SESSION['step']):?>
                <img src="/cms/images/arrowOrangeRight.gif" class="arrow"/>
                <?php endif;?>
                </div>
                <?php endforeach;?>
                </div>
                    <div id="content">
                        <?=$html;?>
                    </div>
        </div>
   <? endif;?>
	</body>
</html>
<?
if($_SESSION['step']==7 ){
    session_destroy();
}
?>
