<?php

session_start();

require_once("res/config.php");
require_once("vendor/autoload.php");

use \Slim\Slim;

$app = new Slim();

$app->config('debug', true);

// Carregando rotas
require_once('rotas/site.php');
require_once('rotas/admin.php');
require_once('rotas/admin_login.php');
require_once('rotas/admin_users.php');
require_once('rotas/admin_categories.php');
require_once('rotas/admin_products.php');

$app->run();

?>