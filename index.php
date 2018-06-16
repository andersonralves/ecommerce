<?php

session_start();

require_once("res/config.php");
require_once("vendor/autoload.php");

use \Slim\Slim;
use Hcode\Page;
use Hcode\PageAdmin;
use Hcode\Model\User;

$app = new Slim();

$app->config('debug', true);

// Rota Principal
$app->get('/', function() {
    
	$page = new Page();

	$page->setTpl("index");

});

// Página Admin
$app->get('/admin', function() {

    User::verifyLogin();

    $page = new PageAdmin();

    $page->setTpl("index");

});

// Login Admin
$app->get('/admin/login', function(){

    $page = new PageAdmin(array(
        "header"=>false,
        "footer"=>false
    ));

    $page->setTpl("login");
});

// Valida o login e redireciona
$app->post('/admin/login', function(){

    User::login($_POST["login"], $_POST["password"]);

    header("Location: /admin");
    exit;

});

// Logout Admin
$app->get('/admin/logout', function(){

    User::logout();

    header("Location: /admin");
    exit;

});

// Listar usuarios
$app->get('/admin/users', function(){

    User::verifyLogin();

    $users = User::listAll();

    $page = new PageAdmin();

    $page->setTpl("users", array(
        "users"=>$users
    ));

});

// Cadastrar usuario
$app->get('/admin/users/create', function(){

    User::verifyLogin();

    $page = new PageAdmin();

    $page->setTpl("users-create");

});

// Gravando usuário
$app->post("/admin/users/create", function(){

    User::verifyLogin();

    $user = new User();

    $_POST["inadmin"] = (isset($_POST["inadmin"]))? 1 : 0;
    $_POST["despassword"] = password_hash($_POST["despassword"], PASSWORD_DEFAULT, [
        "cost"=>12
    ]);

    $user->setData($_POST);

    $user->save();

    header("Location: /admin/users");

    exit;


});

// Excluindo o usuario
$app->get("/admin/users/:iduser/delete", function($iduser){

    User::verifyLogin();

    $user = new User();

    $user->get((int)$iduser);

    $user->delete();

    header("Location: /admin/users");
    exit;
});

// Alterar usuario
$app->get('/admin/users/:iduser', function($iduser){

    User::verifyLogin();

    $user = new User();

    $user->get((int)$iduser);

    $page = new PageAdmin();

    $page->setTpl("users-update", array(
        "user"=>$user->getValues()
    ));

});

// Alterando o usuário
$app->post("/admin/users/:iduser", function($iduser){

    User::verifyLogin();

    $_POST["inadmin"] = (isset($_POST["inadmin"]))? 1 : 0;

    $user = new User();

    $user->get((int)$iduser);

    $user->setData($_POST);

    $user->update();

    header("Location: /admin/users");
    exit;

});

// Esqueceu a senha
$app->get("/admin/forgot", function(){

    $page = new PageAdmin(array(
        "header"=>false,
        "footer"=>false
    ));

    $page->setTpl("forgot");
});

// Enviando link de recuperação
$app->post("/admin/forgot", function(){

    $user = User::getForgot($_POST['email']);

    header("Location: /admin/forgot/sent");
    exit;
});

// Confirmação de envio do email redefinição de senha
$app->get("/admin/forgot/sent", function(){

    $page = new PageAdmin(array(
        "header"=>false,
        "footer"=>false
    ));

    $page->setTpl("forgot-sent");
});


// Informar a nova senha
$app->get("/admin/forgot/reset", function(){

    $user = User::validForgotDecrypt($_GET["code"]);

    $page = new PageAdmin(array(
        "header"=>false,
        "footer"=>false
    ));

    $page->setTpl("forgot-reset", array(
        "name"=>$user["desperson"],
        "code"=>$_GET["code"]
    ));
});

// Gravando a nova senha
$app->post("/admin/forgot/reset", function(){

    $forgot = User::validForgotDecrypt($_POST["code"]);

    User::setForgotUsed($forgot["idrecovery"]);

    $user = new User();

    $user->get($forgot["iduser"]);

    $password = password_hash($_POST["password"], PASSWORD_DEFAULT, [
        "cost"=>12
    ]);

    $user->setPassword($password);

    $page = new PageAdmin(array(
        "header"=>false,
        "footer"=>false
    ));

    $page->setTpl("forgot-reset-success");

});


$app->run();

?>