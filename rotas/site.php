<?php

use \Hcode\Page;
use \Hcode\Model\Product;
use \Hcode\Model\Category;
use \Hcode\Model\Cart;
use \Hcode\Model\Address;
use \Hcode\Model\User;

// Rota Principal
$app->get('/', function() {

    $products = Product::listAll();

	$page = new Page();

	$page->setTpl("index", [
	    'products'=> Product::checkList($products)
    ]);

});

// Exibir a categoria e seus produtos
$app->get("/categories/:idcategory", function($idcategory){

    $page = (isset($_GET['page']))? (int)$_GET['page'] : 1;

    $category = new Category();

    $category->get((int)$idcategory);

    $pagination = $category->getProductsPage($page);

    $pages = [];

    for($i=1; $i <= $pagination['pages']; $i++) {
        array_push($pages, [
            'link'=>'/categories/'.$category->getidcategory().'?page='.$i,
            'page'=>$i
        ]);
    }

    $page = new Page();

    $page->setTpl("category", array(
        "category"=>$category->getValues(),
        "products"=>$pagination["data"],
        "pages"=>$pages
    ));

});

// Exibir os detalhes do produto
$app->get("/products/:desurl", function($desurl){

    $product = new Product();

    $product->getFromUrl($desurl);

    $page = new Page();

    $page->setTpl("product-detail", array(
        "product"=>$product->getValues(),
        "categories"=>$product->getCategories()
    ));

});

// Exibir carrinho de compras
$app->get("/cart", function(){

    $cart = Cart::getFromSession();

    $page = new Page();

    $page->setTpl("cart", [
        'cart'=>$cart->getValues(),
        'products'=>$cart->getProducts(),
        'error'=>Cart::getMsgError()
    ]);

});

// Adicionando um item do produto no carrinho de compras
$app->get("/cart/:idproduct/add", function($idproduct){

    $product = new Product();

    $product->get((int)$idproduct);

    $cart = Cart::getFromSession();

    $qtd = (isset($_GET['qtd'])) ? (int)$_GET['qtd'] : 1;

    for ($i = 0; $i < $qtd; $i++) {
        echo "<script>alert('Oi');</script>";
        $cart->addProduct($product);
    }

    header("Location: /cart");
    exit;

});

// Removendo um item do produto do carrinho de compras
$app->get("/cart/:idproduct/minus", function($idproduct){

    $product = new Product();

    $product->get((int)$idproduct);

    $cart = Cart::getFromSession();

    $cart->removeProduct($product);

    header("Location: /cart");
    exit;

});

// Removendo todos os  itens do produto do carrinho de compras
$app->get("/cart/:idproduct/remove", function($idproduct){

    $product = new Product();

    $product->get((int)$idproduct);

    $cart = Cart::getFromSession();

    $cart->removeProduct($product, true);

    header("Location: /cart");
    exit;

});

// Calcula o frete
$app->post("/cart/freight", function(){

    $cart = Cart::getFromSession();

    $cart->setFreight($_POST['zipcode']);

    header("Location: /cart");
    exit;

});

// Finalizar compra
$app->get("/checkout", function(){

    User::verifyLogin(false);

    $address = new Address();
    $cart = Cart::getFromSession();

    if (!isset($_GET['zipcode'])) {

        $_GET['zipcode'] = $cart->getdeszipcode();

    }

    if (isset($_GET['zipcode'])) {

        $address->loadFromCEP($_GET['zipcode']);

        $cart->setdeszipcode($_GET['zipcode']);

        $cart->save();

        $cart->getCalculateTotal();

    }

    if (!$address->getdesaddress()) $address->setdesaddress('');
    if (!$address->getdescomplement()) $address->setdescomplement('');
    if (!$address->getdesdistrict()) $address->setdesdistrict('');
    if (!$address->getdescity()) $address->setdescity('');
    if (!$address->getdesstate()) $address->setdesstate('');
    if (!$address->getdescountry()) $address->setdescountry('');
    if (!$address->getdeszipcode()) $address->setdeszipcode('');

    $page = new Page();

    $page->setTpl("checkout", [
        'cart'=> $cart->getValues(),
        'address'=>$address->getValues(),
        'products'=>$cart->getProducts(),
        'error'=>Address::getMsgError()
    ]);

});

$app->post("/checkout", function(){

    User::verifyLogin(false);

    if (!isset($_POST['zipcode']) || $_POST['zipcode'] === '') {
        Address::setMsgError("Informe o CEP.");
        header("Location: /checkout");
        exit;
    }

    if (!isset($_POST['desaddress']) || $_POST['desaddress'] === '') {
        Address::setMsgError("Informe o Endereço.");
        header("Location: /checkout");
        exit;
    }

    if (!isset($_POST['desdistrict']) || $_POST['desdistrict'] === '') {
        Address::setMsgError("Informe o Bairro.");
        header("Location: /checkout");
        exit;
    }

    if (!isset($_POST['descity']) || $_POST['descity'] === '') {
        Address::setMsgError("Informe a Cidade.");
        header("Location: /checkout");
        exit;
    }

    if (!isset($_POST['desstate']) || $_POST['desstate'] === '') {
        Address::setMsgError("Informe o Estado.");
        header("Location: /checkout");
        exit;
    }

    if (!isset($_POST['descountry']) || $_POST['descountry'] === '') {
        Address::setMsgError("Informe o País.");
        header("Location: /checkout");
        exit;
    }

    $user = User::getFromSession();

    $address = new Address();

    $_POST['deszipcode'] = $_POST['zipcode'];
    $_POST['idperson'] = $user->getidperson();

    $address->setData($_POST);

    $address->save();

    header("Location: /order");
    exit;

});

// Login
$app->get("/login", function(){

    $page = new Page();

    $page->setTpl("login", [
        'error'=>User::getError(),
        'errorRegister'=>User::getErrorRegister(),
        'registerValues'=> (isset($_SESSION['registerValues'])) ? $_SESSION['registerValues'] : [
            'name'=> '',
            'email'=>'',
            'phone'=>''
        ]
    ]);

});

// Validar login
$app->post("/login", function(){

    try {
        User::login($_POST['login'], $_POST['password']);
    } catch(Exception $e) {

        User::setError($e->getMessage());

    }

    header("Location: /checkout");
    exit;

});

// Logout
$app->get('/logout', function(){

    User::logout();

    unset($_SESSION['registerValues']);

    header("Location: /login");
    exit;
});

// Novo usuário
$app->post('/register', function(){

    $_SESSION['registerValues'] = $_POST;

    if (!isset($_POST['name']) || $_POST['name'] == '') {

        User::setErrorRegister("Preencha o seu nome.");
        header('Location: /login');
        exit;
    }

    if (!isset($_POST['email']) || $_POST['email'] == '') {

        User::setErrorRegister("Preencha o seu email.");
        header('Location: /login');
        exit;
    }

    if (!isset($_POST['password']) || $_POST['password'] == '') {

        User::setErrorRegister("Preencha a senha");
        header('Location: /login');
        exit;
    }

    if (User::checkLoginExist($_POST['email']) === true) {

        User::setErrorRegister("Este endereço de e-mail já está sendo usado por outro usuário.");
        header('Location: /login');
        exit;

    }

    $user = new User();

    $user->setData([
        'inadmin'=>0,
        'deslogin'=>$_POST['email'],
        'desperson'=>$_POST['name'],
        'desemail'=>$_POST['email'],
        'despassword'=>$_POST['password'],
        'nrphone'=>$_POST['phone']
    ]);

    $user->save();

    User::login($_POST['email'], $_POST['password']);

    header('Location: /checkout');
    exit;

});

// Esqueceu a senha
$app->get("/forgot", function(){

    $page = new Page();

    $page->setTpl("forgot");
});

// Enviando link de recuperação
$app->post("/forgot", function(){

    $user = User::getForgot($_POST['email'], false);

    header("Location: /forgot/sent");
    exit;
});

// Confirmação de envio do email redefinição de senha
$app->get("/forgot/sent", function(){

    $page = new Page();

    $page->setTpl("forgot-sent");
});


// Informar a nova senha
$app->get("/forgot/reset", function(){

    $user = User::validForgotDecrypt($_GET["code"]);

    $page = new Page();

    $page->setTpl("forgot-reset", array(
        "name"=>$user["desperson"],
        "code"=>$_GET["code"]
    ));
});

// Gravando a nova senha
$app->post("/forgot/reset", function(){

    $forgot = User::validForgotDecrypt($_POST["code"]);

    User::setForgotUsed($forgot["idrecovery"]);

    $user = new User();

    $user->get($forgot["iduser"]);

    $password = $_POST["password"];

    $user->setPassword($password);

    $page = new Page();

    $page->setTpl("forgot-reset-success");

});

// Minha conta
$app->get('/profile', function(){

    User::verifyLogin(false);

    $user = User::getFromSession();

    $page = new Page();

    $page->setTpl("profile",[
        'user' => $user->getValues(),
        'profileMsg'=> User::getSuccess(),
        'profileError'=> User::getError()
    ]);
});

$app->post('/profile', function(){

    User::verifyLogin(false);

    if(!isset($_POST['desperson']) || $_POST['desperson'] === '') {
        User::setError("Preencha o seu nome.");
        header('Location: /profile');
        exit;
    }

    if(!isset($_POST['desemail']) || $_POST['desemail'] === '') {
        User::setError("Preencha o seu e-mail.");
        header('Location: /profile');
        exit;
    }

    $user = User::getFromSession();

    if ($_POST['desemail'] !== $user->getdesemail()) {

        if(User::checkLoginExist($_POST['desemail']) === true){

            User::setError("Este e-mail já está cadastrado.");
            header('Location: /profile');
            exit;

        }

    }

    $_POST['iduser'] = $user->getiduser();
    $_POST['inadmin'] = $user->getinadmin();
    $_POST['despassword'] = $user->getdespassword();
    $_POST['deslogin'] = $_POST['desemail'];

    $user->setData($_POST);
    $user->update(false);

    $_SESSION[ User::SESSION ] = $user->getValues();

    User::setSuccess("Dados alterados com sucesso.");

    header("Location: /profile");
    exit;

});

?>