<?php

use \Hcode\PageAdmin;
use \Hcode\Model\User;

// Página Admin
$app->get('/admin', function() {

    User::verifyLogin();

    $page = new PageAdmin();

    $page->setTpl("index");

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

    $password = $_POST["password"];

    $user->setPassword($password);

    $page = new PageAdmin(array(
        "header"=>false,
        "footer"=>false
    ));

    $page->setTpl("forgot-reset-success");

});

?>