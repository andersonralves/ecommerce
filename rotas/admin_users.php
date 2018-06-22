<?php

use \Hcode\PageAdmin;
use \Hcode\Model\User;

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
    $_POST["despassword"] = $_POST["despassword"];

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

?>