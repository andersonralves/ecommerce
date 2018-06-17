<?php

use \Hcode\Page;

// Rota Principal
$app->get('/', function() {
    
	$page = new Page();

	$page->setTpl("index");

});


?>