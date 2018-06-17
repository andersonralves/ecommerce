<?php

use \Hcode\PageAdmin;
use \Hcode\Model\User;
use \Hcode\Model\Category;

// Lista todas as categorias
$app->get("/admin/categories", function(){

    User::verifyLogin();

    $categories = Category::listAll();

    $page = new PageAdmin();

    $page->setTpl("categories", array(
        "categories"=>$categories
    ));
});

// Criar categoria
$app->get("/admin/categories/create", function(){   

    User::verifyLogin(); 

    $page = new PageAdmin();

    $page->setTpl("categories-create");
});

// Gravando a categoria
$app->post("/admin/categories/create", function(){    

    User::verifyLogin();

    $category = new Category();

    $category->setData($_POST);

    $category->save();

    header("Location: /admin/categories");
    exit;

});

// Excluindo a categoria
$app->get("/admin/categories/:idcategory/delete", function($idcategory){  

    User::verifyLogin();  

    $category = new Category();

    $category->get((int)$idcategory);

    $category->delete();

    header("Location: /admin/categories");
    exit;

});

// Alterar a categoria
$app->get("/admin/categories/:idcategory", function($idcategory){   

    User::verifyLogin(); 

    $category = new Category();

    $category->get((int)$idcategory);

    $page = new PageAdmin();

    $page->setTpl("categories-update", array(
        "category"=>$category->getValues()
    ));

});

// Alterando a categoria
$app->post("/admin/categories/:idcategory", function($idcategory){    

    User::verifyLogin();

    $category = new Category();

    $category->get((int)$idcategory);

    $category->setData($_POST);

    $category->save();

    header("Location: /admin/categories");
    exit;

});

// Alterando a categoria
$app->get("/categories/:idcategory", function($idcategory){    

    $category = new Category();

    $category->get((int)$idcategory);

    $page = new Page();

    $page->setTpl("category", array(
        "category"=>$category->getValues(),
        "products"=>[]
    ));

});

?>