<?php

use \Hcode\PageAdmin;
use \Hcode\Model\User;

// Alterar senha
$app->get('/admin/users/:iduser/password', function($iduser){

    User::verifyLogin();

    $user = new User();

    $user->get((int)$iduser);

    $page = new PageAdmin();

    $page->setTpl("users-password", array(
        "user"=>$user->getValues(),
        'msgError'=>User::getError(),
        'msgSuccess'=>User::getSuccess()
    ));

});

// Alterando senha
$app->post('/admin/users/:iduser/password', function($iduser){

    User::verifyLogin();

    if (!isset($_POST['despassword']) || $_POST['despassword'] === '') {
        User::setError("Preencha a nova senha.");
        header("Location: /admin/users/$iduser/password");
        exit;
    }

    if (!isset($_POST['despassword-confirm']) || $_POST['despassword-confirm'] === '') {
        User::setError("Preencha a confirmação da nova senha.");
        header("Location: /admin/users/$iduser/password");
        exit;
    }

    if ($_POST['despassword'] !== $_POST['despassword-confirm'] ) {
        User::setError("As senhas não conferem.");
        header("Location: /admin/users/$iduser/password");
        exit;
    }

    $user = new User();

    $user->get((int)$iduser);

    $user->setPassword($_POST['despassword']);

    User::setSuccess("Senha alterada com sucesso.");
    header("Location: /admin/users/$iduser/password");
    exit;

});

// Listar usuarios
$app->get('/admin/users', function(){

    User::verifyLogin();

    $search = (isset($_GET['search'])) ? $_GET['search'] : "";
    $page = (isset($_GET['page'])) ? (int)$_GET['page'] : 1;

    if($search != '') {
        $pagination = User::getPageSearch($search, $page, 5);
    } else {
        $pagination = User::getPage($page, 5);
    }

    $pages = [];

    for($x = 0; $x < $pagination['pages']; $x++) {
        array_push($pages, [
            'href'=>'/admin/users?'.http_build_query([
                'page'=>$x+1,
                'search'=>$search
            ]),
            'text'=>$x+1
        ]);
    }

    $page = new PageAdmin();

    $page->setTpl("users", array(
        "users"=>$pagination['data'],
        'search'=>$search,
        'pages'=>$pages
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