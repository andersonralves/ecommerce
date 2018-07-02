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

-- Copiando estrutura para procedure db_ecommerce.sp_addresses_save
DROP PROCEDURE IF EXISTS `sp_addresses_save`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_addresses_save`(
pidaddress int(11), 
pidperson int(11),
pdesaddress varchar(128),
pdesnumber varchar(16),
pdescomplement varchar(32),
pdescity varchar(32),
pdesstate varchar(32),
pdescountry varchar(32),
pdeszipcode char(8),
pdesdistrict varchar(32)
)
BEGIN

	IF pidaddress > 0 THEN
		
		UPDATE tb_addresses
        SET
			idperson = pidperson,
            desaddress = pdesaddress,
            desnumber = pdesnumber,
            descomplement = pdescomplement,
            descity = pdescity,
            desstate = pdesstate,
            descountry = pdescountry,
            deszipcode = pdeszipcode, 
            desdistrict = pdesdistrict
		WHERE idaddress = pidaddress;
        
    ELSE
		
		INSERT INTO tb_addresses (idperson, desaddress, desnumber, descomplement, descity, desstate, descountry, deszipcode, desdistrict)
        VALUES(pidperson, pdesaddress, pdesnumber, pdescomplement, pdescity, pdesstate, pdescountry, pdeszipcode, pdesdistrict);
        
        SET pidaddress = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_addresses WHERE idaddress = pidaddress;

END//
DELIMITER ;

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

-- Copiando estrutura para procedure db_ecommerce.sp_orders_save
DROP PROCEDURE IF EXISTS `sp_orders_save`;
DELIMITER //
CREATE DEFINER=`ecommerce`@`localhost` PROCEDURE `sp_orders_save`(
pidorder INT,
pidcart int(11),
piduser int(11),
pidstatus int(11),
pidaddress int(11),
pvltotal decimal(10,2)
)
BEGIN
	
	IF pidorder > 0 THEN
		
		UPDATE tb_orders
        SET
			idcart = pidcart,
            iduser = piduser,
            idstatus = pidstatus,
            idaddress = pidaddress,
            vltotal = pvltotal
		WHERE idorder = pidorder;
        
    ELSE
    
		INSERT INTO tb_orders (idcart, iduser, idstatus, idaddress, vltotal)
        VALUES(pidcart, piduser, pidstatus, pidaddress, pvltotal);
		
		SET pidorder = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * 
    FROM tb_orders a
    INNER JOIN tb_ordersstatus b USING(idstatus)
    INNER JOIN tb_carts c USING(idcart)
    INNER JOIN tb_users d ON d.iduser = a.iduser
    INNER JOIN tb_addresses e USING(idaddress)
    WHERE idorder = pidorder;
    
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
    
    SET FOREIGN_KEY_CHECKS = 0;
	
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
	
    DELETE FROM tb_addresses WHERE idperson = vidperson;
    DELETE FROM tb_addresses WHERE idaddress IN(SELECT idaddress FROM tb_orders WHERE iduser = piduser);
	DELETE FROM tb_persons WHERE idperson = vidperson;
    
    DELETE FROM tb_userslogs WHERE iduser = piduser;
    DELETE FROM tb_userspasswordsrecoveries WHERE iduser = piduser;
    DELETE FROM tb_orders WHERE iduser = piduser;
    DELETE FROM tb_cartsproducts WHERE idcart IN(SELECT idcart FROM tb_carts WHERE iduser = piduser);
    DELETE FROM tb_carts WHERE iduser = piduser;
    DELETE FROM tb_users WHERE iduser = piduser;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
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
  `desnumber` varchar(16) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `deszipcode` char(8) NOT NULL,
  `desdistrict` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idaddress`),
  KEY `fk_addresses_persons_idx` (`idperson`),
  CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_addresses: ~5 rows (aproximadamente)
DELETE FROM `tb_addresses`;
/*!40000 ALTER TABLE `tb_addresses` DISABLE KEYS */;
INSERT INTO `tb_addresses` (`idaddress`, `idperson`, `desaddress`, `desnumber`, `descomplement`, `descity`, `desstate`, `descountry`, `deszipcode`, `desdistrict`, `dtregister`) VALUES
	(1, 1, 'Rua Major Antenor Francisco do Nascimento', '3-57', '', 'Bauru', 'SP', 'Brasil', '17066093', 'Jardim Andorfato', '2018-07-02 16:47:04');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_carts: ~5 rows (aproximadamente)
DELETE FROM `tb_carts`;
/*!40000 ALTER TABLE `tb_carts` DISABLE KEYS */;
INSERT INTO `tb_carts` (`idcart`, `dessessionid`, `iduser`, `deszipcode`, `vlfreight`, `nrdays`, `dtregister`) VALUES
	(1, 'rof84mo3o83spfiq4ubdad4mi7', NULL, NULL, NULL, NULL, '2018-06-19 15:37:30'),
	(2, '9tme083kqbm8hp62urj0e3lci5', NULL, '17022000', 211.38, 2, '2018-06-21 17:32:56'),
	(3, 'kj8rmcm73jtb4np37l9ushifu3', 1, '17034350', 78.41, 2, '2018-06-22 17:24:45'),
	(4, '375m99nptcpgnrcu7htcmj8br0', NULL, '17034350', 157.92, 2, '2018-06-28 19:13:52'),
	(5, 'u0f4irt3hj4lghct4a0nr5k3n1', NULL, '17066093', 123.39, 1, '2018-06-29 16:15:54');
/*!40000 ALTER TABLE `tb_carts` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_cartsproducts
DROP TABLE IF EXISTS `tb_cartsproducts`;
CREATE TABLE IF NOT EXISTS `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL AUTO_INCREMENT,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcartproduct`),
  KEY `FK_cartsproducts_carts_idx` (`idcart`),
  KEY `FK_cartsproducts_products_idx` (`idproduct`),
  CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_cartsproducts: ~75 rows (aproximadamente)
DELETE FROM `tb_cartsproducts`;
/*!40000 ALTER TABLE `tb_cartsproducts` DISABLE KEYS */;
INSERT INTO `tb_cartsproducts` (`idcartproduct`, `idcart`, `idproduct`, `dtremoved`, `dtregister`) VALUES
	(1, 1, 4, '2018-06-19 12:51:08', '2018-06-19 15:42:58'),
	(2, 1, 4, '2018-06-19 14:34:39', '2018-06-19 15:44:42'),
	(3, 1, 4, '2018-06-19 14:34:42', '2018-06-19 15:49:42'),
	(4, 1, 3, '2018-06-19 12:51:43', '2018-06-19 15:51:30'),
	(5, 1, 4, '2018-06-19 14:44:11', '2018-06-19 17:34:51'),
	(6, 1, 3, '2018-06-19 15:03:49', '2018-06-19 17:34:58'),
	(7, 1, 5, '2018-06-19 15:03:47', '2018-06-19 17:35:02'),
	(8, 1, 5, '2018-06-19 15:03:47', '2018-06-19 17:35:10'),
	(9, 1, 4, '2018-06-19 14:44:11', '2018-06-19 17:42:15'),
	(10, 1, 4, '2018-06-19 14:44:11', '2018-06-19 17:43:37'),
	(11, 1, 4, '2018-06-19 14:44:11', '2018-06-19 17:44:08'),
	(12, 1, 4, '2018-06-19 14:45:13', '2018-06-19 17:44:30'),
	(13, 1, 4, '2018-06-19 14:45:13', '2018-06-19 17:44:45'),
	(14, 1, 4, '2018-06-19 14:45:13', '2018-06-19 17:44:52'),
	(15, 1, 4, '2018-06-19 14:45:13', '2018-06-19 17:45:00'),
	(16, 1, 4, '2018-06-19 14:45:13', '2018-06-19 17:45:06'),
	(17, 1, 4, '2018-06-19 14:48:11', '2018-06-19 17:48:08'),
	(18, 1, 4, '2018-06-19 14:49:24', '2018-06-19 17:48:18'),
	(19, 1, 4, '2018-06-19 14:51:43', '2018-06-19 17:50:07'),
	(20, 1, 4, '2018-06-19 14:51:43', '2018-06-19 17:51:38'),
	(21, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:55:33'),
	(22, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:56:04'),
	(23, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:56:22'),
	(24, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:56:38'),
	(25, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:57:02'),
	(26, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:57:54'),
	(27, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:58:14'),
	(28, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:58:30'),
	(29, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:58:30'),
	(30, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:58:30'),
	(31, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:58:50'),
	(32, 1, 4, '2018-06-19 15:01:48', '2018-06-19 17:58:59'),
	(33, 1, 4, '2018-06-19 15:01:48', '2018-06-19 18:01:42'),
	(34, 1, 4, '2018-06-19 15:01:48', '2018-06-19 18:01:42'),
	(35, 1, 4, '2018-06-19 15:01:48', '2018-06-19 18:01:42'),
	(36, 1, 4, '2018-06-19 15:01:48', '2018-06-19 18:01:42'),
	(37, 1, 4, '2018-06-19 15:01:48', '2018-06-19 18:01:42'),
	(38, 1, 4, '2018-06-19 15:02:05', '2018-06-19 18:02:01'),
	(39, 1, 4, '2018-06-19 15:02:36', '2018-06-19 18:02:01'),
	(40, 1, 4, '2018-06-19 15:03:45', '2018-06-19 18:02:01'),
	(41, 1, 4, '2018-06-19 15:03:45', '2018-06-19 18:02:01'),
	(42, 1, 4, '2018-06-19 15:03:45', '2018-06-19 18:02:01'),
	(43, 1, 4, '2018-06-19 15:03:45', '2018-06-19 18:02:01'),
	(44, 1, 4, '2018-06-19 15:03:45', '2018-06-19 18:02:01'),
	(45, 1, 4, '2018-06-19 15:03:45', '2018-06-19 18:02:12'),
	(46, 1, 4, '2018-06-19 15:03:45', '2018-06-19 18:02:21'),
	(47, 1, 9, '2018-06-19 17:01:33', '2018-06-19 18:04:55'),
	(48, 1, 4, '2018-06-19 17:01:30', '2018-06-19 18:05:01'),
	(49, 1, 7, '2018-06-19 17:01:38', '2018-06-19 18:05:07'),
	(50, 1, 8, NULL, '2018-06-19 18:05:12'),
	(51, 1, 6, '2018-06-19 17:01:35', '2018-06-19 18:05:15'),
	(52, 1, 7, '2018-06-19 17:02:07', '2018-06-19 18:05:24'),
	(53, 1, 7, '2018-06-19 17:02:10', '2018-06-19 18:05:24'),
	(54, 1, 7, '2018-06-19 17:02:12', '2018-06-19 18:05:24'),
	(55, 1, 8, NULL, '2018-06-19 20:02:18'),
	(56, 2, 8, '2018-06-21 15:29:11', '2018-06-21 17:34:58'),
	(57, 2, 8, '2018-06-21 15:29:18', '2018-06-21 17:35:01'),
	(58, 2, 4, '2018-06-21 15:28:57', '2018-06-21 18:01:53'),
	(59, 2, 4, '2018-06-21 15:29:02', '2018-06-21 18:28:00'),
	(60, 2, 4, NULL, '2018-06-21 18:28:48'),
	(61, 2, 4, NULL, '2018-06-21 18:57:45'),
	(62, 2, 4, NULL, '2018-06-21 18:58:10'),
	(63, 3, 4, '2018-06-22 17:39:29', '2018-06-22 20:38:58'),
	(64, 3, 4, NULL, '2018-06-22 20:39:25'),
	(65, 4, 4, NULL, '2018-06-28 19:14:03'),
	(66, 4, 4, NULL, '2018-06-28 19:30:40'),
	(67, 4, 5, NULL, '2018-06-28 19:32:40'),
	(68, 5, 4, '2018-06-29 17:50:14', '2018-06-29 16:16:00'),
	(69, 5, 3, '2018-06-29 13:16:19', '2018-06-29 16:16:13'),
	(70, 5, 6, '2018-06-29 16:12:27', '2018-06-29 16:16:25'),
	(71, 5, 9, '2018-06-29 16:14:21', '2018-06-29 17:44:57'),
	(72, 5, 6, '2018-06-29 16:12:59', '2018-06-29 19:12:17'),
	(73, 5, 9, '2018-06-29 17:50:11', '2018-06-29 19:14:14'),
	(74, 5, 4, NULL, '2018-06-29 20:50:07'),
	(75, 5, 4, NULL, '2018-06-29 20:50:24');
/*!40000 ALTER TABLE `tb_cartsproducts` ENABLE KEYS */;

-- Copiando estrutura para tabela db_ecommerce.tb_categories
DROP TABLE IF EXISTS `tb_categories`;
CREATE TABLE IF NOT EXISTS `tb_categories` (
  `idcategory` int(11) NOT NULL AUTO_INCREMENT,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idcategory`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

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
  `idaddress` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idorder`),
  KEY `FK_orders_users_idx` (`iduser`),
  KEY `fk_orders_ordersstatus_idx` (`idstatus`),
  KEY `fk_orders_carts_idx` (`idcart`),
  KEY `fk_orders_addresses_idx` (`idaddress`),
  CONSTRAINT `fk_orders_addresses` FOREIGN KEY (`idaddress`) REFERENCES `tb_addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_orders: ~2 rows (aproximadamente)
DELETE FROM `tb_orders`;
/*!40000 ALTER TABLE `tb_orders` DISABLE KEYS */;
INSERT INTO `tb_orders` (`idorder`, `idcart`, `iduser`, `idstatus`, `idaddress`, `vltotal`, `dtregister`) VALUES
	(3, 5, 1, 1, 7, 5683.60, '2018-06-29 17:46:00'),
	(4, 5, 1, 2, 8, 6121.39, '2018-06-29 20:50:32'),
	(5, 5, 1, 1, 1, 6121.39, '2018-07-02 16:47:05');
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

-- Copiando dados para a tabela db_ecommerce.tb_persons: ~3 rows (aproximadamente)
DELETE FROM `tb_persons`;
/*!40000 ALTER TABLE `tb_persons` DISABLE KEYS */;
INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
	(1, 'Anderson Ricardo Alves', 'andersonricardo.alves@gmail.com', 0, '2017-03-01 03:00:00'),
	(7, 'Suporte', 'suporte@hcode.com.br', 1112345678, '2017-03-15 16:10:27'),
	(8, 'Anderson TI', 'anderson.ti@plasutil.com.br', 123, '2018-06-22 19:45:31');
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

-- Copiando dados para a tabela db_ecommerce.tb_users: ~3 rows (aproximadamente)
DELETE FROM `tb_users`;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
	(1, 1, 'admin', '$2y$12$NEaPNyR5.EEJSmd4ViU/7.m2itM6AxDuWDFWXWZkD.kITyFGnfcPK', 1, '2017-03-13 03:00:00'),
	(7, 7, 'suporte', '$2y$12$HFjgUm/mk1RzTy4ZkJaZBe0Mc/BA2hQyoUckvm.lFa6TesjtNpiMe', 1, '2017-03-15 16:10:27'),
	(8, 8, 'anderson.ti@plasutil.com.br', '$2y$12$mnbOiE.UF.USx0riYmnNDONx5BDga.qoUaAgeo8pHwg2CHeJVe9EW', 0, '2018-06-22 19:45:31');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- Copiando dados para a tabela db_ecommerce.tb_userspasswordsrecoveries: ~5 rows (aproximadamente)
DELETE FROM `tb_userspasswordsrecoveries`;
/*!40000 ALTER TABLE `tb_userspasswordsrecoveries` DISABLE KEYS */;
INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
	(1, 7, '127.0.0.1', NULL, '2017-03-15 16:10:59'),
	(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 16:11:18'),
	(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 16:37:12'),
	(4, 8, '127.0.0.1', NULL, '2018-06-22 20:44:48'),
	(5, 8, '127.0.0.1', NULL, '2018-06-22 20:47:38'),
	(6, 8, '127.0.0.1', '2018-06-22 17:49:51', '2018-06-22 20:48:23');
/*!40000 ALTER TABLE `tb_userspasswordsrecoveries` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
