<?php

use \Hcode\PageAdmin;
use \Hcode\Model\User;

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

?>