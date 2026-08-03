-- MySQL dump 10.13  Distrib 9.7.1, for macos15.7 (arm64)
--
-- Host: localhost    Database: flow_app
-- ------------------------------------------------------
-- Server version	9.7.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '3a7e5b6a-8e64-11f1-ab8b-be70f57d9265:1-120';

--
-- Current Database: `flow_app`
--

/*!40000 DROP DATABASE IF EXISTS `flow_app`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `flow_app` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `flow_app`;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'other',
  `count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES ('cat_01','Electronics','phone',124),('cat_02','Fashion','fashion',89),('cat_03','Home','home',56),('cat_04','Sports','sports',34),('cat_05','Vehicles','car',21),('cat_06','Toys','toys',18);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conversations`
--

DROP TABLE IF EXISTS `conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conversations` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_a_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_b_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_message` text COLLATE utf8mb4_unicode_ci,
  `last_message_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `unread_count` int NOT NULL DEFAULT '0',
  `is_online` tinyint(1) NOT NULL DEFAULT '0',
  `product_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `product_image` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_conv_pair` (`user_a_id`,`user_b_id`),
  KEY `idx_conv_user_a` (`user_a_id`),
  KEY `idx_conv_user_b` (`user_b_id`),
  CONSTRAINT `fk_conv_a` FOREIGN KEY (`user_a_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_conv_b` FOREIGN KEY (`user_b_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conversations`
--

LOCK TABLES `conversations` WRITE;
/*!40000 ALTER TABLE `conversations` DISABLE KEYS */;
INSERT INTO `conversations` VALUES ('conv_001','user_001','user_002','Si, esta disponible. Te lo puedo enviar manana.','2026-08-03 17:55:21',2,1,'iPhone 15 Pro Max 256GB','','2026-08-02 18:10:21'),('conv_002','user_001','user_003','Gracias por la compra!','2026-08-03 16:10:21',0,0,'Nike Air Max 90 Talla 10','','2026-08-01 18:10:21'),('conv_003','user_001','user_004','Tiene algun descuento?','2026-08-02 18:10:21',1,1,'MacBook Air M2 13\"','','2026-08-02 18:10:21');
/*!40000 ALTER TABLE `conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `user_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listing_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`listing_id`),
  KEY `fk_favs_listing` (`listing_id`),
  CONSTRAINT `fk_favs_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_favs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
INSERT INTO `favorites` VALUES ('user_001','list_001','2026-08-03 18:10:21'),('user_001','list_003','2026-08-03 18:10:21');
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `listings`
--

DROP TABLE IF EXISTS `listings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `listings` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seller_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `currency` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NGN',
  `images` json NOT NULL,
  `category` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subcategory` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_featured` tinyint(1) NOT NULL DEFAULT '0',
  `view_count` int NOT NULL DEFAULT '0',
  `favorite_count` int NOT NULL DEFAULT '0',
  `item_condition` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_listings_category` (`category`),
  KEY `idx_listings_status` (`status`),
  KEY `idx_listings_seller` (`seller_id`),
  CONSTRAINT `fk_listings_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `listings`
--

LOCK TABLES `listings` WRITE;
/*!40000 ALTER TABLE `listings` DISABLE KEYS */;
INSERT INTO `listings` VALUES ('list_001','user_002','iPhone 15 Pro Max 256GB','Como nuevo, con caja y accesorios originales. Bateria al 98%.',18500.00,'NGN','[]','Electronics','','active','2026-08-03 15:10:21',0,234,18,'Like new','Ciudad de Mexico'),('list_002','user_003','Nike Air Max 90 Talla 10','Zapatos deportivos en excelente estado, usados solo dos veces.',1800.00,'NGN','[]','Fashion','','active','2026-08-02 18:10:21',0,89,7,'Used','Guadalajara'),('list_003','user_004','MacBook Air M2 13\"','16GB RAM, 512GB SSD. Perfecto estado, con cargador original.',21000.00,'NGN','[]','Electronics','','active','2026-07-31 18:10:21',1,412,45,'Like new','Monterrey'),('list_004','user_005','Sofa 3 Plazas Color Gris','Sofa moderno en tela premium, muy cómodo y sin manchas.',5500.00,'NGN','[]','Home','','active','2026-07-29 18:10:21',0,67,4,'Used','Puebla'),('list_005','user_006','Bicicleta de Montaña Trek','21 velocidades, suspension delantera. Ideal para senderismo.',4200.00,'NGN','[]','Sports','','active','2026-08-01 18:10:21',0,156,12,'Used','Queretaro'),('list_010','user_001','PlayStation 5 + 2 Mandos','Consola en perfecto estado con dos mandos DualSense.',8500.00,'NGN','[]','Electronics','','active','2026-07-24 18:10:21',0,189,14,'Like new','Ciudad de Mexico');
/*!40000 ALTER TABLE `listings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `conversation_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_msg_sender` (`sender_id`),
  KEY `idx_msg_conversation` (`conversation_id`),
  CONSTRAINT `fk_msg_conv` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_msg_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES ('msg_001','conv_001','user_001','Hola, esta disponible el iPhone?','','2026-08-03 17:10:21',1),('msg_002','conv_001','user_002','Si, esta disponible.','','2026-08-03 17:25:21',1),('msg_003','conv_001','user_001','Cual es el precio final?','','2026-08-03 17:40:21',1),('msg_004','conv_001','user_002','Si, esta disponible. Te lo puedo enviar manana.','','2026-08-03 17:55:21',0),('msg_005','conv_002','user_001','Recibi los zapatos, gracias!','','2026-08-03 15:10:21',1),('msg_006','conv_002','user_003','Gracias por la compra!','','2026-08-03 16:10:21',1),('msg_007','conv_003','user_001','Buenas tardes, me interesa el MacBook.','','2026-08-02 19:10:21',1),('msg_008','conv_003','user_004','Hola! Si esta disponible.','','2026-08-02 18:10:21',1),('msg_009','conv_003','user_001','Tiene algun descuento?','','2026-08-02 19:10:21',0);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `body` text COLLATE utf8mb4_unicode_ci,
  `type` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_notif_user` (`user_id`),
  CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES ('notif_001','user_001','Order Shipped','Your order #FLW-001 has been shipped.','order',0,'2026-08-03 17:40:21','{\"orderId\": \"ord_001\"}'),('notif_002','user_001','New Message','Maria Lopez sent you a message.','message',0,'2026-08-03 16:10:21','{\"conversationId\": \"conv_001\"}'),('notif_003','user_001','Payment Received','Payment of $18,500 confirmed for order #FLW-001.','order',1,'2026-08-03 12:10:21','{\"orderId\": \"ord_001\"}'),('notif_004','user_001','Weekend Sale','Up to 40% off on electronics. Don\'t miss out!','promotion',1,'2026-08-02 18:10:21',NULL),('notif_005','user_001','Account Verified','Your account has been successfully verified.','system',1,'2026-08-01 18:10:21',NULL),('notif_006','user_001','New Message','Ana Garcia sent you a message.','message',0,'2026-08-03 13:10:21','{\"conversationId\": \"conv_003\"}');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buyer_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seller_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listing_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `listing_title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `listing_image` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `currency` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NGN',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `shipping_address` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `payment_method` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_paid` tinyint(1) NOT NULL DEFAULT '0',
  `quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_orders_seller` (`seller_id`),
  KEY `fk_orders_listing` (`listing_id`),
  KEY `idx_orders_buyer` (`buyer_id`),
  KEY `idx_orders_status` (`status`),
  CONSTRAINT `fk_orders_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_orders_listing` FOREIGN KEY (`listing_id`) REFERENCES `listings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_orders_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES ('ord_001','user_001','user_002','list_001','iPhone 15 Pro Max 256GB','',18500.00,'NGN','shipped','2026-08-01 18:10:21','Av. Reforma 123, Ciudad de Mexico','',1,1),('ord_002','user_001','user_004','list_003','MacBook Air M2 13\"','',21000.00,'NGN','delivered','2026-07-27 18:10:21','Calle Independencia 456, Monterrey','',1,1),('ord_003','user_001','user_003','list_002','Nike Air Max 90 Talla 10','',1800.00,'NGN','pending','2026-08-03 12:10:21','Blvd. Vallarta 789, Guadalajara','',0,1),('ord_004','user_001','user_005','list_004','Sofa 3 Plazas Color Gris','',5500.00,'NGN','confirmed','2026-08-03 06:10:21','Calle 5 de Mayo 101, Puebla','',1,1),('ord_005','user_001','user_006','list_005','Bicicleta de Montaña Trek','',4200.00,'NGN','cancelled','2026-07-24 18:10:21','Av. Universidad 202, Queretaro','',0,1);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `seller_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reviewer_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `user_avatar` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rating` int NOT NULL DEFAULT '5',
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `text` text COLLATE utf8mb4_unicode_ci,
  `has_photo` tinyint(1) NOT NULL DEFAULT '0',
  `photo_url` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_reviews_seller` (`seller_id`),
  CONSTRAINT `fk_reviews_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES ('rev_001','user_002','user_001','Carlos Mendoza','',5,'2026-07-29 18:10:21','Excelente vendedor! El producto llego en perfecto estado y muy rapido.',0,''),('rev_002','user_002',NULL,'Laura Sanchez','',5,'2026-07-19 18:10:21','Muy profesional. Recomendado 100%.',1,''),('rev_003','user_002',NULL,'Roberto Diaz','',4,'2026-07-04 18:10:21','Buen producto, demoro un poco el envio pero todo bien.',0,''),('rev_004','user_003',NULL,'Pedro Ramirez','',4,'2026-07-24 18:10:21','Buena calidad, tal como se veia en las fotos.',0,''),('rev_005','user_004',NULL,'Sofia Torres','',5,'2026-07-31 18:10:21','MacBook en perfecto estado. Envio super rapido.',0,''),('rev_006','user_004',NULL,'Miguel Angel','',5,'2026-07-26 18:10:21','Excelente vendedor, muy confiable.',0,'');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_follows`
--

DROP TABLE IF EXISTS `user_follows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_follows` (
  `follower_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `followee_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followee_id`),
  KEY `fk_follows_followee` (`followee_id`),
  CONSTRAINT `fk_follows_followee` FOREIGN KEY (`followee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_follows_follower` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_follows`
--

LOCK TABLES `user_follows` WRITE;
/*!40000 ALTER TABLE `user_follows` DISABLE KEYS */;
INSERT INTO `user_follows` VALUES ('user_001','user_005','2026-08-03 18:10:21'),('user_001','user_006','2026-08-03 18:10:21'),('user_002','user_001','2026-08-03 18:10:21'),('user_003','user_001','2026-08-03 18:10:21'),('user_004','user_001','2026-08-03 18:10:21');
/*!40000 ALTER TABLE `user_follows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `avatar_url` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `is_verified` tinyint(1) NOT NULL DEFAULT '0',
  `location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rating` decimal(3,2) NOT NULL DEFAULT '0.00',
  `reviews_count` int NOT NULL DEFAULT '0',
  `listings_count` int NOT NULL DEFAULT '0',
  `sales_count` int NOT NULL DEFAULT '0',
  `bio` text COLLATE utf8mb4_unicode_ci,
  `member_duration` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `positive_percent` decimal(5,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('user_001','Carlos Mendoza','carlos@example.com','+52 55 1234 5678','',1,'Ciudad de Mexico, Mexico',4.90,3,12,48,'','',0.00,'2024-08-03 18:10:21'),('user_002','Maria Lopez','maria@example.com','+52 33 1111 2222','',1,'Guadalajara, Mexico',4.80,3,24,95,'Vendedor profesional de electrónicos. Envío a todo el país.','2 years',98.50,'2024-08-03 18:10:21'),('user_003','Juan Perez','juan@example.com','+52 81 3333 4444','',0,'Monterrey, Mexico',4.20,1,15,32,'Ropa y calzado deportivo de marca.','1 year',92.00,'2025-08-03 18:10:21'),('user_004','Ana Garcia','ana@example.com','+52 22 5555 6666','',1,'Puebla, Mexico',4.90,2,32,128,'Apple products specialist. Certified reseller.','3 years',99.20,'2023-08-03 18:10:21'),('user_005','Pedro Sanchez','pedro@example.com','+52 44 7777 8888','',0,'Puebla, Mexico',4.50,0,8,21,'Muebles y hogar.','8 months',95.00,'2025-12-03 18:10:21'),('user_006','Laura Torres','laura@example.com','+52 44 9999 0000','',0,'Queretaro, Mexico',4.60,0,5,15,'Deportes y aire libre.','1 year',94.00,'2025-08-03 18:10:21'),('user_1785760999495','12345@g','12345@g','','',0,'',0.00,0,0,0,NULL,'',0.00,'2026-08-03 18:13:19');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-03 18:14:05
