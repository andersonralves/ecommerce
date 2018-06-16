<?php

#### CONSTANTS
$baseUrl = "http://".$_SERVER['HTTP_HOST'];
$baseUrl .= str_replace(basename($_SERVER['SCRIPT_NAME']),"",$_SERVER['SCRIPT_NAME']);

define("BASE_URL", $baseUrl);
define("EMAIL_USERNAME", "contadevv@gmail.com");
define("EMAIL_PASSWORD", "xxxxx");
define("EMAIL_NAME_FROM", "Conta DEVV");