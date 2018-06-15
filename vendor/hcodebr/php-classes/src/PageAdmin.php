<?php

namespace Hcode;

use Rain\Tpl;

class PageAdmin extends  Page
{
    private $tpl;
    private $options = [];
    private $defaults = [
        "data"=>[]
    ];

    public function __construct($opts = array(), $tpl_dir = "/views/admin/")
    {
        $this->options = array_merge($this->defaults, $opts);

        parent::__construct($opts, $tpl_dir);
    }

}