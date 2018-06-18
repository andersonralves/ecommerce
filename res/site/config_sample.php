<?php
/**
 * Renomear este arquivo para config.php com as informações de e-mail
 */

#### CONSTANTS ###########

define("DS", DIRECTORY_SEPARATOR);

// URL
$baseUrl = "http://".$_SERVER['HTTP_HOST'];
$baseUrl .= str_replace(basename($_SERVER['SCRIPT_NAME']),"",$_SERVER['SCRIPT_NAME']);
define("BASE_URL", $baseUrl);

// EMAIL
define("EMAIL_USERNAME", "conta de email");
define("EMAIL_PASSWORD", "senha do email");
define("EMAIL_NAME_FROM", "nome da conta");