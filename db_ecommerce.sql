-- --------------------------------------------------------
-- Servidor:                     127.0.0.1
-- Versão do servidor:           5.7.19 - MySQL Community Server (GPL)
-- OS do Servidor:               Win64
-- HeidiSQL Versão:              9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Copiando estrutura do banco de dados para db_ecommerce
CREATE DATABASE IF NOT EXISTS `db_ecommerce` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `db_ecommerce`;

-- Copiando estrutura para procedure db_ecommerce.sp_carts_save
DROP PROCEDURE IF EXISTS `sp_carts_save`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_carts_save`(
pidcart INT,
pdessessionid VARCHAR(64),
piduser INT,
pdeszipcode CHAR(8),
pvlfreight DECIMAL(10,2),
pnrdays INT
)
BEGIN

    IF pidcart > 0 THEN
        
        UPDATE tb_carts
        SET
            dessessionid = pdessessionid,
            iduser = piduser,
            deszipcode = pdeszipcode,
            vlfreight = pvlfreight,
            nrdays = pnrdays
        WHERE idcart = pidcart;
        
    ELSE
        
        INSERT INTO tb_carts (dessessionid, iduser, deszipcode, vlfreight, nrdays)
        VALUES(pdessessionid, piduser, pdeszipcode, pvlfreight, pnrdays);
        
        SET pidcart = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_carts WHERE idcart = pidcart;

END//
DELIMITER ;

-- Copiando estrutura para procedure db_ecommerce.sp_categories_save
DROP PROCEDURE IF EXISTS `sp_categories_save`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_categories_save`(
pidcategory INT,
pdescategory VARCHAR(64)
)
BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END//
DELIMITER ;

-- Copiando estrutura para procedure db_ecommerce.sp_products_save
DROP PROCEDURE IF EXISTS `sp_products_save`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_products_save`(
pidproduct int(11),
pdesproduct varchar(64),
pvlprice decimal(10,2),
pvlwidth decimal(10,2),
pvlheight decimal(10,2),
pvllength decimal(10,2),
pvlweight decimal(10,2),
pdesurl varchar(128)
)
BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END//
DELIMITER ;

-- Copiando estrutura para procedure db_ecommerce.sp_userspasswordsrecoveries_create
DROP PROCEDURE IF EXISTS `sp_userspasswordsrecoveries_create`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create`(
piduser INT,
pdesip VARCHAR(45)
)
BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END//
DELIMITER ;

-- Copiando estrutura para procedure db_ecommerce.sp_usersupdate_save
DROP PROCEDURE IF EXISTS `sp_usersupdate_save`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_usersupdate_save`(
piduser INT,
pdesperson VARCHAR(64), 
pdeslogin VARCHAR(64), 
pdespassword VARCHAR(256), 
pdesemail VARCHAR(128), 
pnrphone BIGINT, 
pinadmin TINYINT
)
BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
		desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
	WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
		deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
	WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END//
DELIMITER ;

-- Copiando estrutura para procedure db_ecommerce.sp_users_delete
DROP PROCEDURE IF EXISTS `sp_users_delete`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_users_delete`(
piduser INT
)
BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    DELETE FROM tb_users WHERE iduser = piduser;
    DELETE FROM tb_persons WHERE idperson = vidperson;
    
END//
DELIMITER ;

-- Copiando estrutura para procedure db_ecommerce.sp_users_save
DROP PROCEDURE IF EXISTS `sp_users_save`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_users_save`(
pdesperson VARCHAR(64), 
pdeslogin VARCHAR(64), 
pdespassword VARCHAR(256), 
pdesemail VARCHAR(128), 
pnrphone BIGINT, 
pinadmin TINYINT
)
BEGIN
	
    DECLARE vidperson INT;
    
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END//
DELIMITER ;

-- Copiando estrutura para tabela db_ecommerce.tb_addresses
DROP TABLE IF EXISTS `tb_addresses`;
CREATE TABLE IF NOT EXISTS `tb_addresses` (
  `idaddress` int(11) NOT NULL AUTO_INCREMENT,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `nrzipcode` int(11) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idaddress`),
  KEY `fk_addresses_persons_idx` (`idperson`),
  CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_addresses: ~0 rows (aproximadamente)
DELETE FROM `tb_addresses`;
/*!40000 ALTER TABLE `tb_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_addresses` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_carts
DROP TABLE IF EXISTS `tb_carts`;
CREATE TABLE IF NOT EXISTS `tb_carts` (
  `idcart` int(11) NOT NULL AUTO_INCREMENT,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `deszipcode` char(8) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `nrdays` int(11) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcart`),
  KEY `FK_carts_users_idx` (`iduser`),
  CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_carts: ~0 rows (aproximadamente)
DELETE FROM `tb_carts`;
/*!40000 ALTER TABLE `tb_carts` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_carts` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_cartsproducts
DROP TABLE IF EXISTS `tb_cartsproducts`;
CREATE TABLE IF NOT EXISTS `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL AUTO_INCREMENT,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcartproduct`),
  KEY `FK_cartsproducts_carts_idx` (`idcart`),
  KEY `FK_cartsproducts_products_idx` (`idproduct`),
  CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_cartsproducts: ~0 rows (aproximadamente)
DELETE FROM `tb_cartsproducts`;
/*!40000 ALTER TABLE `tb_cartsproducts` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_cartsproducts` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_categories
DROP TABLE IF EXISTS `tb_categories`;
CREATE TABLE IF NOT EXISTS `tb_categories` (
  `idcategory` int(11) NOT NULL AUTO_INCREMENT,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcategory`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_categories: ~5 rows (aproximadamente)
DELETE FROM `tb_categories`;
/*!40000 ALTER TABLE `tb_categories` DISABLE KEYS */;
INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
	(3, 'Google', '2018-06-17 16:24:11'),
	(5, 'Android', '2018-06-17 16:37:50'),
	(6, 'Apple', '2018-06-17 16:37:57'),
	(7, 'Motorola', '2018-06-17 16:40:01'),
	(9, 'XIamoi', '2018-06-17 16:57:06');
/*!40000 ALTER TABLE `tb_categories` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_orders
DROP TABLE IF EXISTS `tb_orders`;
CREATE TABLE IF NOT EXISTS `tb_orders` (
  `idorder` int(11) NOT NULL AUTO_INCREMENT,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idorder`),
  KEY `FK_orders_carts_idx` (`idcart`),
  KEY `FK_orders_users_idx` (`iduser`),
  KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_orders: ~0 rows (aproximadamente)
DELETE FROM `tb_orders`;
/*!40000 ALTER TABLE `tb_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_orders` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_ordersstatus
DROP TABLE IF EXISTS `tb_ordersstatus`;
CREATE TABLE IF NOT EXISTS `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL AUTO_INCREMENT,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idstatus`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_ordersstatus: ~4 rows (aproximadamente)
DELETE FROM `tb_ordersstatus`;
/*!40000 ALTER TABLE `tb_ordersstatus` DISABLE KEYS */;
INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
	(1, 'Em Aberto', '2017-03-13 03:00:00'),
	(2, 'Aguardando Pagamento', '2017-03-13 03:00:00'),
	(3, 'Pago', '2017-03-13 03:00:00'),
	(4, 'Entregue', '2017-03-13 03:00:00');
/*!40000 ALTER TABLE `tb_ordersstatus` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_persons
DROP TABLE IF EXISTS `tb_persons`;
CREATE TABLE IF NOT EXISTS `tb_persons` (
  `idperson` int(11) NOT NULL AUTO_INCREMENT,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idperson`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_persons: ~2 rows (aproximadamente)
DELETE FROM `tb_persons`;
/*!40000 ALTER TABLE `tb_persons` DISABLE KEYS */;
INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
	(1, 'Anderson Ricardo Alves', 'andersonricardo.alves@gmail.com', 0, '2017-03-01 03:00:00'),
	(7, 'Suporte', 'suporte@hcode.com.br', 1112345678, '2017-03-15 16:10:27');
/*!40000 ALTER TABLE `tb_persons` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_products
DROP TABLE IF EXISTS `tb_products`;
CREATE TABLE IF NOT EXISTS `tb_products` (
  `idproduct` int(11) NOT NULL AUTO_INCREMENT,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idproduct`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_products: ~7 rows (aproximadamente)
DELETE FROM `tb_products`;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
	(3, 'Notebook 14" 4GB 1TB', 1949.99, 345.00, 23.00, 30.00, 2000.00, 'notebook-14-4gb-1tb', '2017-03-13 03:00:00'),
	(4, 'iPad 128GB Wi-Fi Tela LED IPS 9.7" CÃ¢mera 8MP Prata - Apple', 2999.00, 16.90, 24.00, 0.70, 0.46, 'ipad-128-tela-led-camera8m-prata', '2018-06-17 21:31:58'),
	(5, 'Smartphone Motorola Moto G5 Plus', 1135.23, 15.20, 7.40, 0.70, 0.16, 'smartphone-motorola-moto-g5-plus', '2018-06-18 15:55:38'),
	(6, 'Smartphone Moto Z Play', 1887.78, 14.10, 0.90, 1.16, 0.13, 'smartphone-moto-z-play', '2018-06-18 15:55:38'),
	(7, 'Smartphone Samsung Galaxy J5 Pro', 1299.00, 14.60, 7.10, 0.80, 0.16, 'smartphone-samsung-galaxy-j5', '2018-06-18 15:55:38'),
	(8, 'Smartphone Samsung Galaxy J7 Prime', 1149.00, 15.10, 7.50, 0.80, 0.16, 'smartphone-samsung-galaxy-j7', '2018-06-18 15:55:38'),
	(9, 'Smartphone Samsung Galaxy J3 Dual', 679.90, 14.20, 7.10, 0.70, 0.14, 'smartphone-samsung-galaxy-j3', '2018-06-18 15:55:38');
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_productscategories
DROP TABLE IF EXISTS `tb_productscategories`;
CREATE TABLE IF NOT EXISTS `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  PRIMARY KEY (`idcategory`,`idproduct`),
  KEY `fk_productscategories_products_idx` (`idproduct`),
  CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_productscategories: ~8 rows (aproximadamente)
DELETE FROM `tb_productscategories`;
/*!40000 ALTER TABLE `tb_productscategories` DISABLE KEYS */;
INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
	(6, 4),
	(5, 5),
	(5, 6),
	(5, 7),
	(7, 7),
	(5, 8),
	(7, 8),
	(5, 9);
/*!40000 ALTER TABLE `tb_productscategories` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_users
DROP TABLE IF EXISTS `tb_users`;
CREATE TABLE IF NOT EXISTS `tb_users` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT '0',
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`iduser`),
  KEY `FK_users_persons_idx` (`idperson`),
  CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_users: ~2 rows (aproximadamente)
DELETE FROM `tb_users`;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
	(1, 1, 'admin', '$2y$12$YlooCyNvyTji8bPRcrfNfOKnVMmZA9ViM2A3IpFjmrpIbp5ovNmga', 1, '2017-03-13 03:00:00'),
	(7, 7, 'suporte', '$2y$12$HFjgUm/mk1RzTy4ZkJaZBe0Mc/BA2hQyoUckvm.lFa6TesjtNpiMe', 1, '2017-03-15 16:10:27');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_userslogs
DROP TABLE IF EXISTS `tb_userslogs`;
CREATE TABLE IF NOT EXISTS `tb_userslogs` (
  `idlog` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idlog`),
  KEY `fk_userslogs_users_idx` (`iduser`),
  CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_userslogs: ~0 rows (aproximadamente)
DELETE FROM `tb_userslogs`;
/*!40000 ALTER TABLE `tb_userslogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_userslogs` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_userspasswordsrecoveries
DROP TABLE IF EXISTS `tb_userspasswordsrecoveries`;
CREATE TABLE IF NOT EXISTS `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idrecovery`),
  KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`),
  CONSTRAINT `fk_userspasswordsrecoveries_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_userspasswordsrecoveries: ~3 rows (aproximadamente)
DELETE FROM `tb_userspasswordsrecoveries`;
/*!40000 ALTER TABLE `tb_userspasswordsrecoveries` DISABLE KEYS */;
INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
	(1, 7, '127.0.0.1', NULL, '2017-03-15 16:10:59'),
	(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 16:11:18'),
	(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 16:37:12');
/*!40000 ALTER TABLE `tb_userspasswordsrecoveries` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
