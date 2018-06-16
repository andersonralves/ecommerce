<?php

$baseUrl = "http://".$_SERVER['HTTP_HOST'];
$baseUrl .= str_replace(basename($_SERVER['SCRIPT_NAME']),"",$_SERVER['SCRIPT_NAME']);

define("BASE_URL", $baseUrl);