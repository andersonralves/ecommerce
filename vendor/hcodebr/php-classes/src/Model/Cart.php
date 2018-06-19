<?php

namespace Hcode\Model;

use \Hcode\Mailer;
use \Hcode\Model;
use \Hcode\Model\User;
use \Hcode\DB\Sql;

class Cart extends Model
{
    const SESSION = "Cart";

    public static function getFromSession()
    {
        $cart = new Cart();

        if ( isset($_SESSION[Cart::SESSION]) && (int)$_SESSION[Cart::SESSION]["idcart"] > 0) {

            $cart->get((int) $_SESSION[Cart::SESSION]["idcart"]);

        } else {

            #$cart->getFromSessionId();

            if (!(int)$cart->getidcart() > 0) {
                $data = [
                    'dessessionid'=>session_id()
                ];

                if(User::checkLogin(false)) {

                    $user = User::getFromSession();

                    $data['iduser'] = $user->getiduser();
                }

                $cart->setData($data);

                $cart->save();

                $cart->setToSession();
            }

        }

        return $cart;
    }

    public function setToSession()
    {
        $_SESSION[Cart::SESSION] = $this->getValues();
    }
    
    public function get($idcart)
    {
        $sql = new Sql();

        $results = $sql->select("SELECT * FROM tb_carts WHERE idcart = :idcart",
            array(
                ":idcart"=>$idcart
            ));

        if (count($results) > 0) {
            $this->setData($results[0]);
        }

    }

    public function getFromSessionId($idcart)
    {
        $sql = new Sql();

        $results = $sql->select("SELECT * FROM tb_carts WHERE dessessionid = :dessessionid",
            array(
                ":dessessionid"=>session_id()
            ));

        if (count($results) > 0) {
            $this->setData($results[0]);
        }
    }

    public function save()
    {
        $sql = new Sql();

        $results = $sql->select("CALL sp_carts_save(:idcart, :dessessionid, :iduser, :dezipcode, :vlfreight, 
            :nrdays)", array(

                ":idcart"=>$this->getidcart(),
                ":dessessionid"=>$this->getdessessionid(),
                ":iduser"=>$this->getiduser(),
                ":dezipcode"=>$this->getdezipcode(),
                ":vlfreight"=>$this->getvlfreight(),
                ":nrdays"=>$this->getnrdays()
            ));

        $this->setData($results[0]);

    }

    /*
    public function delete()
    {
        $sql = new Sql();

        $sql->query("DELETE FROM tb_categories WHERE idcategory = :idcategory", array(
            ":idcategory"=>$this->getidcategory()
        ));

        Category::updateFile();
    }

    public static function updateFile()
    {
        $categories = Category::listAll();

        $html = array();

        foreach ($categories as $row) {
            array_push($html, '<li><a href="/categories/' . $row["idcategory"] . '">' . $row["descategory"]. '</a></li>');
        }

        file_put_contents($_SERVER["DOCUMENT_ROOT"] . DS . "views" . DS . "categories-menu.html", implode("", $html));
    }

    public function getProducts($related = true)
    {
        $sql = new Sql();

        if ($related === true) {

            return $sql->select("
                SELECT * FROM tb_products WHERE idproduct IN (
                    SELECT a.idproduct
                    FROm tb_products a
                    INNER JOIN tb_productscategories b ON a.idproduct = b.idproduct
                    WHERE b.idcategory = :idcategory
                );
            ", [":idcategory"=>$this->getidcategory()] );

        } else {

            return $sql->select("
                SELECT * FROM tb_products WHERE idproduct NOT IN (
                    SELECT a.idproduct
                    FROm tb_products a
                    INNER JOIN tb_productscategories b ON a.idproduct = b.idproduct
                    WHERE b.idcategory = :idcategory
                );
            ", [":idcategory"=>$this->getidcategory()] );

        }
    }

    public function getProductsPage($page = 1, $itemsPerPage = 8)
    {
        $start = ($page-1) * $itemsPerPage;

        $sql = new Sql();

        $results = $sql->select("
            SELECT SQL_CALC_FOUND_ROWS *
            FROM tb_products a 
            INNER JOIN tb_productscategories b ON a.idproduct = b.idproduct
            INNER JOIN tb_categories c ON c.idcategory = b.idcategory
            WHERE c.idcategory = :idcategory
            LIMIT $start, $itemsPerPage;            
        ", [
            ":idcategory"=>$this->getidcategory()
        ]);

        $resultTotal = $sql->select("SELECT FOUND_ROWS() AS nrtotal");

        return [
            "data"=>Product::checkList($results),
            'total'=>(int)$resultTotal[0]["nrtotal"],
            'pages'=>ceil($resultTotal[0]["nrtotal"] / $itemsPerPage)
        ];
    }

    public function addProduct(Product $product)
    {
        $sql = new Sql();

        $sql->query("INSERT INTO tb_productscategories (idcategory, idproduct) VALUES(:idcategory, :idproduct)", [
                ":idcategory"=>$this->getidcategory(),
                "idproduct"=>$product->getidproduct()
        ]);
    }

    public function removeProduct(Product $product)
    {
        $sql = new Sql();

        $sql->query("DELETE FROM tb_productscategories WHERE idcategory = :idcategory AND idproduct = :idproduct", [
            ":idcategory"=>$this->getidcategory(),
            "idproduct"=>$product->getidproduct()
        ]);
    }
    */

}