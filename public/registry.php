<?
mysql_connect("sandbox.loc","remote","123456789") or die("db1");
mysql_select_db("xcmsshop") or die("db2");

$res = mysql_query("SELECT * FROM `registry` WHERE 1");
if(mysql_num_rows($res)>0)
	while($tmp = mysql_fetch_assoc($res)) {
		$val = @unserialize ( $tmp["val"] );
		if(mysql_query("UPDATE `registry` SET `val`='" . @json_encode($val) . "' WHERE `var`='" . $tmp["var"] . "'"))
			echo "UPDATED OPTION '" . $tmp["var"] . "'<br/>";
		else
			echo "TRABLES WITH OPTION '" . $tmp["var"] . "'<br/>";
	}
