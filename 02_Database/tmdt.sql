-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: tmdt
-- ------------------------------------------------------
-- Server version	8.0.46

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

--
-- Current Database: `tmdt`
--

/*!40000 DROP DATABASE IF EXISTS `tmdt`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tmdt` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tmdt`;

--
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('SUPER_ADMIN','MANAGER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MANAGER',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `failedLoginAttempts` int NOT NULL DEFAULT '0',
  `lockedUntil` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Admin_username_key` (`username`),
  KEY `Admin_role_idx` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
INSERT INTO `Admin` VALUES (1,'admin','$2a$10$TNqWyAn3ZBcRjgeMOlkLMO.zRMqetPD4GFdhSS/ov6YD9I//3OnfW','Quản trị viên','SUPER_ADMIN',1,0,NULL,'2026-10-05 04:43:06.106','2026-10-07 09:14:23.858');
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AdminAuditLog`
--

DROP TABLE IF EXISTS `AdminAuditLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AdminAuditLog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `adminId` int NOT NULL,
  `action` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `entityType` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entityId` int DEFAULT NULL,
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `AdminAuditLog_adminId_idx` (`adminId`),
  KEY `AdminAuditLog_action_idx` (`action`),
  KEY `AdminAuditLog_entityType_entityId_idx` (`entityType`,`entityId`),
  CONSTRAINT `AdminAuditLog_adminId_fkey` FOREIGN KEY (`adminId`) REFERENCES `Admin` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AdminAuditLog`
--

LOCK TABLES `AdminAuditLog` WRITE;
/*!40000 ALTER TABLE `AdminAuditLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `AdminAuditLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AdminLoginAttempt`
--

DROP TABLE IF EXISTS `AdminLoginAttempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AdminLoginAttempt` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `adminId` int DEFAULT NULL,
  `ip` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `reason` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `AdminLoginAttempt_username_idx` (`username`),
  KEY `AdminLoginAttempt_adminId_idx` (`adminId`),
  CONSTRAINT `AdminLoginAttempt_adminId_fkey` FOREIGN KEY (`adminId`) REFERENCES `Admin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AdminLoginAttempt`
--

LOCK TABLES `AdminLoginAttempt` WRITE;
/*!40000 ALTER TABLE `AdminLoginAttempt` DISABLE KEYS */;
INSERT INTO `AdminLoginAttempt` VALUES (1,'admin',NULL,'172.18.0.1',0,'not_found','2026-10-05 04:40:03.386'),(2,'admin',1,'172.18.0.1',1,NULL,'2026-10-05 04:43:15.218'),(3,'admin',1,'172.18.0.1',1,NULL,'2026-10-05 05:21:23.670'),(4,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 13:53:20.622'),(5,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 13:53:51.558'),(6,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 13:53:58.927'),(7,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 14:01:45.989'),(8,'admin',1,'172.18.0.4',1,NULL,'2026-10-07 09:14:23.867');
/*!40000 ALTER TABLE `AdminLoginAttempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Amenity`
--

DROP TABLE IF EXISTS `Amenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Amenity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scope` enum('GENERAL','ROOM') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GENERAL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Amenity_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Amenity`
--

LOCK TABLES `Amenity` WRITE;
/*!40000 ALTER TABLE `Amenity` DISABLE KEYS */;
/*!40000 ALTER TABLE `Amenity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Area`
--

DROP TABLE IF EXISTS `Area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Area` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Area_slug_key` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Area`
--

LOCK TABLES `Area` WRITE;
/*!40000 ALTER TABLE `Area` DISABLE KEYS */;
INSERT INTO `Area` VALUES (21,'Đà Lạt','da-lat','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1),(22,'Đà Nẵng','da-nang','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',2),(23,'Hội An','hoi-an','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',3),(24,'Sa Pa','sa-pa','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',4);
/*!40000 ALTER TABLE `Area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Booking`
--

DROP TABLE IF EXISTS `Booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Booking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinHash` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('HOMESTAY','TOUR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PENDING_DEPOSIT','DEPOSITED','CONFIRMED','COMPLETED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_DEPOSIT',
  `productId` int DEFAULT NULL,
  `propertyId` int DEFAULT NULL,
  `roomTypeId` int DEFAULT NULL,
  `tourId` int DEFAULT NULL,
  `tourDepartureId` int DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `guestName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guestEmail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `guestPhone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `checkIn` date DEFAULT NULL,
  `checkOut` date DEFAULT NULL,
  `nights` int DEFAULT NULL,
  `guests` int NOT NULL DEFAULT '1',
  `children` int NOT NULL DEFAULT '0',
  `totalPrice` int NOT NULL,
  `depositAmount` int NOT NULL,
  `remainingAmount` int NOT NULL,
  `paymentMethod` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transactionId` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depositPaidAt` datetime(3) DEFAULT NULL,
  `discountCode` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discountAmount` int NOT NULL DEFAULT '0',
  `discountConsumed` tinyint(1) NOT NULL DEFAULT '0',
  `heldUntil` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  `lookupFailCount` int NOT NULL DEFAULT '0',
  `lookupLockedUntil` datetime(3) DEFAULT NULL,
  `cancelledAt` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Booking_code_key` (`code`),
  KEY `Booking_productId_idx` (`productId`),
  KEY `Booking_propertyId_idx` (`propertyId`),
  KEY `Booking_tourId_idx` (`tourId`),
  KEY `Booking_userId_idx` (`userId`),
  KEY `Booking_status_idx` (`status`),
  KEY `Booking_roomTypeId_fkey` (`roomTypeId`),
  CONSTRAINT `Booking_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Booking_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Booking_roomTypeId_fkey` FOREIGN KEY (`roomTypeId`) REFERENCES `RoomType` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Booking_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Booking_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Booking`
--

LOCK TABLES `Booking` WRITE;
/*!40000 ALTER TABLE `Booking` DISABLE KEYS */;
INSERT INTO `Booking` VALUES (26,'BK-HBJZYPCJ4',NULL,'HOMESTAY','DEPOSITED',NULL,38,80,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Nhận phòng muộn ~21h. Xin phòng tầng cao, yên tĩnh.','2026-10-28','2026-10-30',2,2,0,1700000,510000,1190000,'VNPAY',NULL,'2026-09-28 00:00:00.000',NULL,0,0,NULL,'2026-10-08 16:45:44.982','2026-10-08 16:45:44.982',0,NULL,NULL),(27,'BK-SV2XDUGNN',NULL,'HOMESTAY','PENDING_DEPOSIT',NULL,39,83,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Cần thêm 1 giường phụ cho trẻ em.','2026-11-12','2026-11-14',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-08 17:00:44.998','2026-10-08 16:45:44.999','2026-10-08 16:45:44.999',0,NULL,NULL),(28,'BK-B2K8G46A8',NULL,'HOMESTAY','COMPLETED',NULL,40,85,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Kỳ nghỉ gia đình.','2026-09-18','2026-09-20',2,2,0,2200000,660000,1540000,'VNPAY',NULL,'2026-08-19 00:00:00.000',NULL,0,0,NULL,'2026-10-08 16:45:45.009','2026-10-08 16:45:45.009',0,NULL,NULL),(29,'BK-M6BY9EUDH',NULL,'TOUR','CONFIRMED',NULL,NULL,NULL,38,112,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Ăn chay 1 suất.','2026-10-18','2026-10-20',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-03 00:00:00.000',NULL,0,0,NULL,'2026-10-08 16:45:45.020','2026-10-08 16:45:45.020',0,NULL,NULL),(30,'BK-27BBG5N7X',NULL,'TOUR','COMPLETED',NULL,NULL,NULL,39,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456',NULL,'2026-10-23','2026-10-23',3,2,0,7800000,2340000,5460000,'COD',NULL,'2026-10-03 00:00:00.000',NULL,0,0,NULL,'2026-10-08 16:45:45.031','2026-10-08 16:45:45.031',0,NULL,NULL),(31,'BK-5YKJWUVDT',NULL,'TOUR','CANCELLED',NULL,NULL,NULL,38,112,3,'Trần Thu Hà','ha.tran@gmail.com','0912345678','Bận việc đột xuất.','2026-10-18','2026-10-20',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-03 00:00:00.000',NULL,0,0,NULL,'2026-10-08 16:45:45.042','2026-10-08 16:45:45.042',0,NULL,'2026-10-06 00:00:00.000'),(32,'BK-WFV9H5DN4','dec58ab7d7f9fb6bd366cea633274ef3632f8eaa823bf811c14bed255d60e339','HOMESTAY','COMPLETED',NULL,38,80,NULL,NULL,NULL,'Lê Văn Khách','khachvanglai@example.com','0988777666',NULL,'2026-09-23','2026-09-25',2,2,0,1700000,510000,1190000,'COD',NULL,'2026-08-24 00:00:00.000',NULL,0,0,NULL,'2026-10-08 16:45:45.053','2026-10-08 16:45:45.053',0,NULL,NULL),(33,'BK-NJB3QUZCT','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','HOMESTAY','PENDING_DEPOSIT',NULL,39,83,NULL,NULL,NULL,'Phạm Thu Trang','guest.track@example.com','0977555444','Đặt hộ bạn.','2026-10-18','2026-10-20',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-08 17:00:45.061','2026-10-08 16:45:45.062','2026-10-08 16:45:45.062',0,NULL,NULL);
/*!40000 ALTER TABLE `Booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CancellationPolicy`
--

DROP TABLE IF EXISTS `CancellationPolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CancellationPolicy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `isRefundable` tinyint(1) NOT NULL DEFAULT '1',
  `freeHours` int NOT NULL DEFAULT '24',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CancellationPolicy`
--

LOCK TABLES `CancellationPolicy` WRITE;
/*!40000 ALTER TABLE `CancellationPolicy` DISABLE KEYS */;
INSERT INTO `CancellationPolicy` VALUES (1,'Linh hoạt tiêu chuẩn',1,24,'2026-10-05 04:43:05.829','2026-10-05 04:43:05.829'),(2,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:53:11.058','2026-10-06 13:53:11.058'),(3,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:59:38.411','2026-10-06 13:59:38.411'),(4,'Linh hoạt tiêu chuẩn',1,24,'2026-10-07 09:28:10.465','2026-10-07 09:28:10.465'),(5,'Linh hoạt tiêu chuẩn',1,24,'2026-10-07 09:59:38.015','2026-10-07 09:59:38.015'),(6,'Linh hoạt tiêu chuẩn',1,24,'2026-10-08 16:45:43.414','2026-10-08 16:45:43.414');
/*!40000 ALTER TABLE `CancellationPolicy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Category`
--

DROP TABLE IF EXISTS `Category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('HOMESTAY','TOUR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kind` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  `parentId` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Category_slug_key` (`slug`),
  KEY `Category_parentId_idx` (`parentId`),
  KEY `Category_type_idx` (`type`),
  CONSTRAINT `Category_parentId_fkey` FOREIGN KEY (`parentId`) REFERENCES `Category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Category`
--

LOCK TABLES `Category` WRITE;
/*!40000 ALTER TABLE `Category` DISABLE KEYS */;
/*!40000 ALTER TABLE `Category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DiscountCode`
--

DROP TABLE IF EXISTS `DiscountCode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DiscountCode` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` int NOT NULL,
  `minOrderValue` int NOT NULL DEFAULT '0',
  `scope` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL',
  `productId` int DEFAULT NULL,
  `propertyId` int DEFAULT NULL,
  `tourId` int DEFAULT NULL,
  `audience` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL',
  `startAt` datetime(3) DEFAULT NULL,
  `endAt` datetime(3) DEFAULT NULL,
  `maxUses` int DEFAULT NULL,
  `usedCount` int NOT NULL DEFAULT '0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `DiscountCode_code_key` (`code`),
  KEY `DiscountCode_productId_idx` (`productId`),
  KEY `DiscountCode_propertyId_fkey` (`propertyId`),
  KEY `DiscountCode_tourId_fkey` (`tourId`),
  CONSTRAINT `DiscountCode_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `DiscountCode_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `DiscountCode_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DiscountCode`
--

LOCK TABLES `DiscountCode` WRITE;
/*!40000 ALTER TABLE `DiscountCode` DISABLE KEYS */;
INSERT INTO `DiscountCode` VALUES (11,'STAYTOUR10','PERCENT',10,500000,'ALL',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-08 16:45:44.445'),(12,'HE2026','FIXED',150000,1000000,'HOMESTAY',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-08 16:45:44.445');
/*!40000 ALTER TABLE `DiscountCode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmailVerificationToken`
--

DROP TABLE IF EXISTS `EmailVerificationToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EmailVerificationToken` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `tokenHash` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `usedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `EmailVerificationToken_tokenHash_key` (`tokenHash`),
  KEY `EmailVerificationToken_userId_idx` (`userId`),
  CONSTRAINT `EmailVerificationToken_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmailVerificationToken`
--

LOCK TABLES `EmailVerificationToken` WRITE;
/*!40000 ALTER TABLE `EmailVerificationToken` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmailVerificationToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Favorite`
--

DROP TABLE IF EXISTS `Favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Favorite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `productId` int DEFAULT NULL,
  `propertyId` int DEFAULT NULL,
  `tourId` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Favorite_userId_productId_key` (`userId`,`productId`),
  UNIQUE KEY `Favorite_userId_propertyId_key` (`userId`,`propertyId`),
  UNIQUE KEY `Favorite_userId_tourId_key` (`userId`,`tourId`),
  KEY `Favorite_userId_idx` (`userId`),
  KEY `Favorite_productId_fkey` (`productId`),
  KEY `Favorite_propertyId_fkey` (`propertyId`),
  KEY `Favorite_tourId_fkey` (`tourId`),
  CONSTRAINT `Favorite_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Favorite_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Favorite_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Favorite_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Favorite`
--

LOCK TABLES `Favorite` WRITE;
/*!40000 ALTER TABLE `Favorite` DISABLE KEYS */;
INSERT INTO `Favorite` VALUES (10,2,NULL,38,NULL,'2026-10-08 16:45:45.094'),(11,2,NULL,NULL,38,'2026-10-08 16:45:45.096'),(12,3,NULL,40,NULL,'2026-10-08 16:45:45.099');
/*!40000 ALTER TABLE `Favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HomestayAvailability`
--

DROP TABLE IF EXISTS `HomestayAvailability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `HomestayAvailability` (
  `id` int NOT NULL AUTO_INCREMENT,
  `productId` int NOT NULL,
  `date` date NOT NULL,
  `totalRooms` int NOT NULL,
  `bookedRooms` int NOT NULL DEFAULT '0',
  `priceOverride` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `HomestayAvailability_productId_date_key` (`productId`,`date`),
  KEY `HomestayAvailability_productId_idx` (`productId`),
  CONSTRAINT `HomestayAvailability_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=721 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HomestayAvailability`
--

LOCK TABLES `HomestayAvailability` WRITE;
/*!40000 ALTER TABLE `HomestayAvailability` DISABLE KEYS */;
INSERT INTO `HomestayAvailability` VALUES (541,31,'2026-10-06',5,3,NULL),(542,31,'2026-10-07',5,1,NULL),(543,31,'2026-10-08',5,1,NULL),(544,31,'2026-10-09',5,5,NULL),(545,31,'2026-10-10',5,5,NULL),(546,31,'2026-10-11',5,3,NULL),(547,31,'2026-10-12',5,1,NULL),(548,31,'2026-10-13',5,1,NULL),(549,31,'2026-10-14',5,1,NULL),(550,31,'2026-10-15',5,1,NULL),(551,31,'2026-10-16',5,3,NULL),(552,31,'2026-10-17',5,1,NULL),(553,31,'2026-10-18',5,1,NULL),(554,31,'2026-10-19',5,1,NULL),(555,31,'2026-10-20',5,1,NULL),(556,31,'2026-10-21',5,3,NULL),(557,31,'2026-10-22',5,1,NULL),(558,31,'2026-10-23',5,1,NULL),(559,31,'2026-10-24',5,1,NULL),(560,31,'2026-10-25',5,1,NULL),(561,31,'2026-10-26',5,3,NULL),(562,31,'2026-10-27',5,1,NULL),(563,31,'2026-10-28',5,1,NULL),(564,31,'2026-10-29',5,1,NULL),(565,31,'2026-10-30',5,1,NULL),(566,31,'2026-10-31',5,3,NULL),(567,31,'2026-11-01',5,1,NULL),(568,31,'2026-11-02',5,1,NULL),(569,31,'2026-11-03',5,1,NULL),(570,31,'2026-11-04',5,1,NULL),(571,32,'2026-10-06',5,3,NULL),(572,32,'2026-10-07',5,1,NULL),(573,32,'2026-10-08',5,1,NULL),(574,32,'2026-10-09',5,5,NULL),(575,32,'2026-10-10',5,5,NULL),(576,32,'2026-10-11',5,3,NULL),(577,32,'2026-10-12',5,1,NULL),(578,32,'2026-10-13',5,1,NULL),(579,32,'2026-10-14',5,1,NULL),(580,32,'2026-10-15',5,1,NULL),(581,32,'2026-10-16',5,3,NULL),(582,32,'2026-10-17',5,1,NULL),(583,32,'2026-10-18',5,1,NULL),(584,32,'2026-10-19',5,1,NULL),(585,32,'2026-10-20',5,1,NULL),(586,32,'2026-10-21',5,3,NULL),(587,32,'2026-10-22',5,1,NULL),(588,32,'2026-10-23',5,1,NULL),(589,32,'2026-10-24',5,1,NULL),(590,32,'2026-10-25',5,1,NULL),(591,32,'2026-10-26',5,3,NULL),(592,32,'2026-10-27',5,1,NULL),(593,32,'2026-10-28',5,1,NULL),(594,32,'2026-10-29',5,1,NULL),(595,32,'2026-10-30',5,1,NULL),(596,32,'2026-10-31',5,3,NULL),(597,32,'2026-11-01',5,1,NULL),(598,32,'2026-11-02',5,1,NULL),(599,32,'2026-11-03',5,1,NULL),(600,32,'2026-11-04',5,1,NULL),(601,33,'2026-10-06',5,3,NULL),(602,33,'2026-10-07',5,1,NULL),(603,33,'2026-10-08',5,1,NULL),(604,33,'2026-10-09',5,5,NULL),(605,33,'2026-10-10',5,5,NULL),(606,33,'2026-10-11',5,3,NULL),(607,33,'2026-10-12',5,1,NULL),(608,33,'2026-10-13',5,1,NULL),(609,33,'2026-10-14',5,1,NULL),(610,33,'2026-10-15',5,1,NULL),(611,33,'2026-10-16',5,3,NULL),(612,33,'2026-10-17',5,1,NULL),(613,33,'2026-10-18',5,1,NULL),(614,33,'2026-10-19',5,1,NULL),(615,33,'2026-10-20',5,1,NULL),(616,33,'2026-10-21',5,3,NULL),(617,33,'2026-10-22',5,1,NULL),(618,33,'2026-10-23',5,1,NULL),(619,33,'2026-10-24',5,1,NULL),(620,33,'2026-10-25',5,1,NULL),(621,33,'2026-10-26',5,3,NULL),(622,33,'2026-10-27',5,1,NULL),(623,33,'2026-10-28',5,1,NULL),(624,33,'2026-10-29',5,1,NULL),(625,33,'2026-10-30',5,1,NULL),(626,33,'2026-10-31',5,3,NULL),(627,33,'2026-11-01',5,1,NULL),(628,33,'2026-11-02',5,1,NULL),(629,33,'2026-11-03',5,1,NULL),(630,33,'2026-11-04',5,1,NULL),(631,34,'2026-10-06',5,3,NULL),(632,34,'2026-10-07',5,1,NULL),(633,34,'2026-10-08',5,1,NULL),(634,34,'2026-10-09',5,5,NULL),(635,34,'2026-10-10',5,5,NULL),(636,34,'2026-10-11',5,3,NULL),(637,34,'2026-10-12',5,1,NULL),(638,34,'2026-10-13',5,1,NULL),(639,34,'2026-10-14',5,1,NULL),(640,34,'2026-10-15',5,1,NULL),(641,34,'2026-10-16',5,3,NULL),(642,34,'2026-10-17',5,1,NULL),(643,34,'2026-10-18',5,1,NULL),(644,34,'2026-10-19',5,1,NULL),(645,34,'2026-10-20',5,1,NULL),(646,34,'2026-10-21',5,3,NULL),(647,34,'2026-10-22',5,1,NULL),(648,34,'2026-10-23',5,1,NULL),(649,34,'2026-10-24',5,1,NULL),(650,34,'2026-10-25',5,1,NULL),(651,34,'2026-10-26',5,3,NULL),(652,34,'2026-10-27',5,1,NULL),(653,34,'2026-10-28',5,1,NULL),(654,34,'2026-10-29',5,1,NULL),(655,34,'2026-10-30',5,1,NULL),(656,34,'2026-10-31',5,3,NULL),(657,34,'2026-11-01',5,1,NULL),(658,34,'2026-11-02',5,1,NULL),(659,34,'2026-11-03',5,1,NULL),(660,34,'2026-11-04',5,1,NULL),(661,35,'2026-10-06',5,3,NULL),(662,35,'2026-10-07',5,1,NULL),(663,35,'2026-10-08',5,1,NULL),(664,35,'2026-10-09',5,5,NULL),(665,35,'2026-10-10',5,5,NULL),(666,35,'2026-10-11',5,3,NULL),(667,35,'2026-10-12',5,1,NULL),(668,35,'2026-10-13',5,1,NULL),(669,35,'2026-10-14',5,1,NULL),(670,35,'2026-10-15',5,1,NULL),(671,35,'2026-10-16',5,3,NULL),(672,35,'2026-10-17',5,1,NULL),(673,35,'2026-10-18',5,1,NULL),(674,35,'2026-10-19',5,1,NULL),(675,35,'2026-10-20',5,1,NULL),(676,35,'2026-10-21',5,3,NULL),(677,35,'2026-10-22',5,1,NULL),(678,35,'2026-10-23',5,1,NULL),(679,35,'2026-10-24',5,1,NULL),(680,35,'2026-10-25',5,1,NULL),(681,35,'2026-10-26',5,3,NULL),(682,35,'2026-10-27',5,1,NULL),(683,35,'2026-10-28',5,1,NULL),(684,35,'2026-10-29',5,1,NULL),(685,35,'2026-10-30',5,1,NULL),(686,35,'2026-10-31',5,3,NULL),(687,35,'2026-11-01',5,1,NULL),(688,35,'2026-11-02',5,1,NULL),(689,35,'2026-11-03',5,1,NULL),(690,35,'2026-11-04',5,1,NULL),(691,36,'2026-10-06',5,3,NULL),(692,36,'2026-10-07',5,1,NULL),(693,36,'2026-10-08',5,1,NULL),(694,36,'2026-10-09',5,5,NULL),(695,36,'2026-10-10',5,5,NULL),(696,36,'2026-10-11',5,3,NULL),(697,36,'2026-10-12',5,1,NULL),(698,36,'2026-10-13',5,1,NULL),(699,36,'2026-10-14',5,1,NULL),(700,36,'2026-10-15',5,1,NULL),(701,36,'2026-10-16',5,3,NULL),(702,36,'2026-10-17',5,1,NULL),(703,36,'2026-10-18',5,1,NULL),(704,36,'2026-10-19',5,1,NULL),(705,36,'2026-10-20',5,1,NULL),(706,36,'2026-10-21',5,3,NULL),(707,36,'2026-10-22',5,1,NULL),(708,36,'2026-10-23',5,1,NULL),(709,36,'2026-10-24',5,1,NULL),(710,36,'2026-10-25',5,1,NULL),(711,36,'2026-10-26',5,3,NULL),(712,36,'2026-10-27',5,1,NULL),(713,36,'2026-10-28',5,1,NULL),(714,36,'2026-10-29',5,1,NULL),(715,36,'2026-10-30',5,1,NULL),(716,36,'2026-10-31',5,3,NULL),(717,36,'2026-11-01',5,1,NULL),(718,36,'2026-11-02',5,1,NULL),(719,36,'2026-11-03',5,1,NULL),(720,36,'2026-11-04',5,1,NULL);
/*!40000 ALTER TABLE `HomestayAvailability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `InfoArticle`
--

DROP TABLE IF EXISTS `InfoArticle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `InfoArticle` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` enum('ABOUT','POLICY','GUIDE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `excerpt` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `InfoArticle_slug_key` (`slug`),
  KEY `InfoArticle_category_idx` (`category`),
  KEY `InfoArticle_published_idx` (`published`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InfoArticle`
--

LOCK TABLES `InfoArticle` WRITE;
/*!40000 ALTER TABLE `InfoArticle` DISABLE KEYS */;
INSERT INTO `InfoArticle` VALUES (21,'gioi-thieu','Thông tin người bán','ABOUT','Về StayTour','StayTour là nền tảng đặt homestay và tour du lịch nội địa.',1,1,'2026-10-08 16:45:44.447','2026-10-08 16:45:44.447'),(22,'dieu-kien-giao-dich','Điều kiện giao dịch chung','POLICY','Điều khoản','Các điều kiện và điều khoản giao dịch chung khi sử dụng StayTour.',1,2,'2026-10-08 16:45:44.447','2026-10-08 16:45:44.447'),(23,'chinh-sach-doi-tra-huy','Chính sách đổi – trả – hủy','POLICY','Hủy & hoàn tiền','Chính sách hủy đặt chỗ và hoàn tiền theo từng mốc thời gian.',1,3,'2026-10-08 16:45:44.447','2026-10-08 16:45:44.447'),(24,'bao-mat-du-lieu','Bảo vệ dữ liệu cá nhân','POLICY','Bảo mật','Cam kết bảo vệ dữ liệu cá nhân của khách hàng.',1,4,'2026-10-08 16:45:44.447','2026-10-08 16:45:44.447');
/*!40000 ALTER TABLE `InfoArticle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LoginAttempt`
--

DROP TABLE IF EXISTS `LoginAttempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LoginAttempt` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `LoginAttempt_email_idx` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LoginAttempt`
--

LOCK TABLES `LoginAttempt` WRITE;
/*!40000 ALTER TABLE `LoginAttempt` DISABLE KEYS */;
INSERT INTO `LoginAttempt` VALUES (1,'khachhang@staytour.vn','172.18.0.1',1,'2026-10-05 05:21:23.493'),(2,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:14.362'),(3,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:26.227'),(4,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:35.732'),(5,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:45.791'),(6,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:02:03.594'),(7,'khachhang@gmail.com','172.18.0.4',1,'2026-10-07 09:14:23.585'),(8,'khachhang@gmail.com','172.18.0.4',1,'2026-10-07 09:14:23.705');
/*!40000 ALTER TABLE `LoginAttempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LookupAttempt`
--

DROP TABLE IF EXISTS `LookupAttempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LookupAttempt` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `LookupAttempt_code_idx` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LookupAttempt`
--

LOCK TABLES `LookupAttempt` WRITE;
/*!40000 ALTER TABLE `LookupAttempt` DISABLE KEYS */;
INSERT INTO `LookupAttempt` VALUES (1,'BK-DKJ9F8QPE','172.18.0.1',1,'2026-10-06 14:01:45.872');
/*!40000 ALTER TABLE `LookupAttempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PasswordResetToken`
--

DROP TABLE IF EXISTS `PasswordResetToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PasswordResetToken` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `tokenHash` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `usedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `PasswordResetToken_tokenHash_key` (`tokenHash`),
  KEY `PasswordResetToken_userId_idx` (`userId`),
  CONSTRAINT `PasswordResetToken_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PasswordResetToken`
--

LOCK TABLES `PasswordResetToken` WRITE;
/*!40000 ALTER TABLE `PasswordResetToken` DISABLE KEYS */;
/*!40000 ALTER TABLE `PasswordResetToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payment`
--

DROP TABLE IF EXISTS `Payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `method` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` int NOT NULL,
  `status` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `transactionId` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Payment_bookingId_idx` (`bookingId`),
  CONSTRAINT `Payment_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment`
--

LOCK TABLES `Payment` WRITE;
/*!40000 ALTER TABLE `Payment` DISABLE KEYS */;
INSERT INTO `Payment` VALUES (20,26,'VNPAY',510000,'SUCCESS','VNP1791477944980','2026-10-08 16:45:44.987'),(21,28,'VNPAY',660000,'SUCCESS','VNP1791477940008','2026-10-08 16:45:45.013'),(22,29,'VNPAY',1500000,'SUCCESS','VNP1791477936018','2026-10-08 16:45:45.025'),(23,30,'COD',2340000,'SUCCESS',NULL,'2026-10-08 16:45:45.035'),(24,31,'VNPAY',1500000,'SUCCESS','VNP1791477933040','2026-10-08 16:45:45.045'),(25,32,'COD',510000,'SUCCESS',NULL,'2026-10-08 16:45:45.057');
/*!40000 ALTER TABLE `Payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PolicyMilestone`
--

DROP TABLE IF EXISTS `PolicyMilestone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PolicyMilestone` (
  `id` int NOT NULL AUTO_INCREMENT,
  `policyId` int NOT NULL,
  `daysBefore` int NOT NULL,
  `refundRate` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `PolicyMilestone_policyId_idx` (`policyId`),
  CONSTRAINT `PolicyMilestone_policyId_fkey` FOREIGN KEY (`policyId`) REFERENCES `CancellationPolicy` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PolicyMilestone`
--

LOCK TABLES `PolicyMilestone` WRITE;
/*!40000 ALTER TABLE `PolicyMilestone` DISABLE KEYS */;
INSERT INTO `PolicyMilestone` VALUES (1,1,7,100),(2,1,3,50),(3,2,7,100),(4,2,3,50),(5,3,7,100),(6,3,3,50),(7,4,7,100),(8,4,3,50),(9,5,7,100),(10,5,3,50),(11,6,7,100),(12,6,3,50);
/*!40000 ALTER TABLE `PolicyMilestone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('HOMESTAY','TOUR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('VISIBLE','HIDDEN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VISIBLE',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `location` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` int NOT NULL,
  `rating` double NOT NULL DEFAULT '0',
  `thumbnail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `amenities` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `durationDays` int DEFAULT NULL,
  `priceChild` int DEFAULT NULL,
  `cancellationPolicy` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancellationPolicyId` int DEFAULT NULL,
  `itinerary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `included` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `excluded` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `categoryId` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Product_slug_key` (`slug`),
  KEY `Product_type_idx` (`type`),
  KEY `Product_status_idx` (`status`),
  KEY `Product_categoryId_idx` (`categoryId`),
  KEY `Product_isFeatured_idx` (`isFeatured`),
  KEY `Product_cancellationPolicyId_fkey` (`cancellationPolicyId`),
  CONSTRAINT `Product_cancellationPolicyId_fkey` FOREIGN KEY (`cancellationPolicyId`) REFERENCES `CancellationPolicy` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Product_categoryId_fkey` FOREIGN KEY (`categoryId`) REFERENCES `Category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
INSERT INTO `Product` VALUES (31,'Pine Hill Homestay','pine-hill-homestay','HOMESTAY','VISIBLE','Homestay view đồi thông, không gian yên tĩnh gần trung tâm Đà Lạt.','Đà Lạt',850000,4.5,'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=70',1,'Wifi,Bếp,Chỗ đậu xe,View đồi',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-06 13:59:20.337','2026-10-06 13:59:20.424'),(32,'Sunny Villa Đà Lạt','sunny-villa-da-lat','HOMESTAY','VISIBLE','Villa nguyên căn 3 phòng ngủ, có bếp và sân vườn.','Đà Lạt',1500000,5,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=70',1,'Wifi,Bếp,Hồ bơi,Chỗ đậu xe,BBQ',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-06 13:59:20.346','2026-10-06 13:59:20.430'),(33,'Cozy Corner Đà Lạt','cozy-corner-da-lat','HOMESTAY','VISIBLE','Phòng đôi ấm cúng ngay trung tâm, đi bộ ra chợ đêm.','Đà Lạt',550000,4.5,'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=70',0,'Wifi,Máy sưởi',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-06 13:59:20.351','2026-10-06 13:59:20.351'),(34,'Sea Breeze Mỹ Khê','sea-breeze-my-khe','HOMESTAY','VISIBLE','Homestay cách biển Mỹ Khê 200m, ban công đón nắng.','Đà Nẵng',950000,4.7,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=70',1,'Wifi,Máy lạnh,View biển,Ban công',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-06 13:59:20.356','2026-10-06 13:59:20.356'),(35,'Ocean View Studio','ocean-view-studio','HOMESTAY','VISIBLE','Studio tầng cao nhìn ra biển, đầy đủ tiện nghi.','Đà Nẵng',1200000,4.6,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=70',0,'Wifi,Máy lạnh,Hồ bơi,View biển',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-06 13:59:20.360','2026-10-06 13:59:20.360'),(36,'Hidden Homestay (ẩn)','hidden-homestay','HOMESTAY','HIDDEN','Sản phẩm đang ẩn – KHÔNG được xuất hiện ở trang chủ/danh mục/tìm kiếm.','Đà Lạt',700000,4,'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=800&q=70',1,'Wifi',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-06 13:59:20.365','2026-10-06 13:59:20.365'),(37,'Chinh phục Fansipan 3N2Đ','tour-fansipan-3n2d','TOUR','VISIBLE','Trekking Tây Bắc, chinh phục nóc nhà Đông Dương.','Sa Pa, Lào Cai',3200000,5,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=70',1,NULL,3,2240000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nNgày 3: Tự do khám phá và trở về.',NULL,NULL,NULL,'2026-10-06 13:59:20.371','2026-10-06 13:59:20.441'),(38,'Săn mây Tà Xùa 3N2Đ','tour-ta-xua-3n2d','TOUR','VISIBLE','Săn mây, cắm trại giữa sống lưng khủng long Tà Xùa.','Sơn La',2500000,4.7,'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?auto=format&fit=crop&w=800&q=70',0,NULL,3,1750000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nNgày 3: Tự do khám phá và trở về.',NULL,NULL,NULL,'2026-10-06 13:59:20.376','2026-10-06 13:59:20.376'),(39,'Cù Lao Chàm 1 ngày','tour-cu-lao-cham','TOUR','VISIBLE','Lặn ngắm san hô, khám phá đảo Cù Lao Chàm.','Hội An, Quảng Nam',750000,4.6,'https://images.unsplash.com/photo-1505228395891-9a51e7e86bf6?auto=format&fit=crop&w=800&q=70',1,NULL,1,525000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nBuổi chiều: Trở về, kết thúc chương trình.',NULL,NULL,NULL,'2026-10-06 13:59:20.379','2026-10-06 13:59:20.379'),(40,'Lý Sơn 2N1Đ','tour-ly-son-2n1d','TOUR','VISIBLE','Đảo tiền tiêu Lý Sơn, cánh đồng tỏi và biển xanh.','Quảng Ngãi',1800000,4.5,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=70',0,NULL,2,1260000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nBuổi chiều: Trở về, kết thúc chương trình.',NULL,NULL,NULL,'2026-10-06 13:59:20.384','2026-10-06 13:59:20.384');
/*!40000 ALTER TABLE `Product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductImage`
--

DROP TABLE IF EXISTS `ProductImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductImage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `productId` int NOT NULL,
  `url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `ProductImage_productId_idx` (`productId`),
  CONSTRAINT `ProductImage_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductImage`
--

LOCK TABLES `ProductImage` WRITE;
/*!40000 ALTER TABLE `ProductImage` DISABLE KEYS */;
INSERT INTO `ProductImage` VALUES (91,31,'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=70',0),(92,31,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(93,31,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(94,32,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=70',0),(95,32,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(96,32,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(97,33,'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=70',0),(98,33,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(99,33,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(100,34,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=70',0),(101,34,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(102,34,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(103,35,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=70',0),(104,35,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(105,35,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(106,36,'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=800&q=70',0),(107,36,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(108,36,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(109,37,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=70',0),(110,37,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(111,37,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(112,38,'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?auto=format&fit=crop&w=800&q=70',0),(113,38,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(114,38,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(115,39,'https://images.unsplash.com/photo-1505228395891-9a51e7e86bf6?auto=format&fit=crop&w=800&q=70',0),(116,39,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(117,39,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(118,40,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=70',0),(119,40,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(120,40,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2);
/*!40000 ALTER TABLE `ProductImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Promotion`
--

DROP TABLE IF EXISTS `Promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Promotion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Promotion_active_idx` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
INSERT INTO `Promotion` VALUES (11,'Giảm 20% đặt homestay dịp lễ','Áp dụng cho đơn đặt trước 7 ngày.','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,'2026-10-08 16:45:44.442'),(12,'Tour Tây Bắc mùa săn mây','Ưu đãi nhóm từ 4 khách trở lên.','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,'2026-10-08 16:45:44.442');
/*!40000 ALTER TABLE `Promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Property`
--

DROP TABLE IF EXISTS `Property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Property` (
  `id` int NOT NULL AUTO_INCREMENT,
  `propertyCode` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `propertyType` enum('HOMESTAY','HOTEL','VILLA','APARTMENT','RESORT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HOMESTAY',
  `starRating` int DEFAULT NULL,
  `shortDescription` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `provinceId` int DEFAULT NULL,
  `areaId` int DEFAULT NULL,
  `address` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `checkInTime` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checkOutTime` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `basePrice` int NOT NULL,
  `depositRate` int DEFAULT NULL,
  `cancellationPolicyId` int DEFAULT NULL,
  `avgRating` double NOT NULL DEFAULT '0',
  `reviewCount` int NOT NULL DEFAULT '0',
  `contactPhone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contactEmail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('DRAFT','VISIBLE','HIDDEN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `thumbnail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `metaTitle` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metaDescription` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdById` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Property_propertyCode_key` (`propertyCode`),
  UNIQUE KEY `Property_slug_key` (`slug`),
  KEY `Property_status_idx` (`status`),
  KEY `Property_provinceId_idx` (`provinceId`),
  KEY `Property_areaId_idx` (`areaId`),
  KEY `Property_isFeatured_idx` (`isFeatured`),
  KEY `Property_cancellationPolicyId_fkey` (`cancellationPolicyId`),
  KEY `Property_createdById_fkey` (`createdById`),
  CONSTRAINT `Property_areaId_fkey` FOREIGN KEY (`areaId`) REFERENCES `Category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Property_cancellationPolicyId_fkey` FOREIGN KEY (`cancellationPolicyId`) REFERENCES `CancellationPolicy` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Property_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `Admin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Property_provinceId_fkey` FOREIGN KEY (`provinceId`) REFERENCES `Category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Property`
--

LOCK TABLES `Property` WRITE;
/*!40000 ALTER TABLE `Property` DISABLE KEYS */;
INSERT INTO `Property` VALUES (38,'HS001','Pine Hill Homestay','pine-hill-homestay','HOMESTAY',NULL,'Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.','Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.',NULL,NULL,'Đà Lạt, Lâm Đồng',NULL,NULL,'14:00','12:00',850000,30,6,4.5,2,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.427','2026-10-08 16:45:45.105'),(39,'HS002','Biển Ngọc Villa','bien-ngoc-villa','HOMESTAY',NULL,'Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.','Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.',NULL,NULL,'Mỹ Khê, Đà Nẵng',NULL,NULL,'14:00','12:00',1600000,30,6,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.483','2026-10-08 16:45:45.111'),(40,'HS003','Sông Trăng Riverside','song-trang-riverside','HOMESTAY',NULL,'Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.','Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.',NULL,NULL,'Hội An, Quảng Nam',NULL,NULL,'14:00','12:00',1100000,30,6,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.516','2026-10-08 16:45:45.120'),(41,'HS004','Nhà Của Rừng','nha-cua-rung-sapa','HOMESTAY',NULL,'Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.','Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.',NULL,NULL,'Sa Pa, Lào Cai',NULL,NULL,'14:00','12:00',700000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.549','2026-10-08 16:45:43.549'),(42,'HS005','Mộc Châu Mộc Homestay','moc-chau-moc-homestay','HOMESTAY',NULL,'Nhà sàn giữa đồi chè Mộc Châu, săn mây và ngắm hoa mận.','Nhà sàn giữa đồi chè Mộc Châu, săn mây và ngắm hoa mận.',NULL,NULL,'Mộc Châu, Sơn La',NULL,NULL,'14:00','12:00',650000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.577','2026-10-08 16:45:43.577'),(43,'HS006','Tam Cốc Garden Retreat','tam-coc-garden-retreat','HOMESTAY',NULL,'Khu nghỉ sinh thái giữa núi đá Tam Cốc – Tràng An.','Khu nghỉ sinh thái giữa núi đá Tam Cốc – Tràng An.',NULL,NULL,'Ninh Bình',NULL,NULL,'14:00','12:00',1250000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.605','2026-10-08 16:45:43.605'),(44,'HS007','Sao Biển Phú Quốc','sao-bien-phu-quoc','HOMESTAY',NULL,'Homestay sát Bãi Sao, cát trắng nước trong, hoàng hôn tuyệt đẹp.','Homestay sát Bãi Sao, cát trắng nước trong, hoàng hôn tuyệt đẹp.',NULL,NULL,'Phú Quốc, Kiên Giang',NULL,NULL,'14:00','12:00',1400000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.631','2026-10-08 16:45:43.631'),(45,'HS008','Phố Cổ Hà Nội Boutique','pho-co-ha-noi-boutique','HOMESTAY',NULL,'Căn hộ ấm cúng giữa phố cổ, đi bộ ra Hồ Gươm 5 phút.','Căn hộ ấm cúng giữa phố cổ, đi bộ ra Hồ Gươm 5 phút.',NULL,NULL,'Hoàn Kiếm, Hà Nội',NULL,NULL,'14:00','12:00',900000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.662','2026-10-08 16:45:43.662'),(46,'HS009','Cát Bà Sunrise Bungalow','cat-ba-sunrise-bungalow','HOMESTAY',NULL,'Bungalow nhìn ra vịnh Lan Hạ, chèo kayak và tắm biển.','Bungalow nhìn ra vịnh Lan Hạ, chèo kayak và tắm biển.',NULL,NULL,'Cát Bà, Hải Phòng',NULL,NULL,'14:00','12:00',800000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.693','2026-10-08 16:45:43.693'),(47,'HS010','An Nhiên Farmstay Bảo Lộc','an-nhien-farmstay-bao-loc','HOMESTAY',NULL,'Farmstay giữa đồi chè và thác nước, trải nghiệm hái trà.','Farmstay giữa đồi chè và thác nước, trải nghiệm hái trà.',NULL,NULL,'Bảo Lộc, Lâm Đồng',NULL,NULL,'14:00','12:00',950000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.725','2026-10-08 16:45:43.725'),(48,'HS011','Biển Xanh Vũng Tàu','bien-xanh-vung-tau','HOMESTAY',NULL,'Căn hộ view biển Bãi Sau, hồ bơi vô cực, gần phố hải sản.','Căn hộ view biển Bãi Sau, hồ bơi vô cực, gần phố hải sản.',NULL,NULL,'Bãi Sau, Vũng Tàu',NULL,NULL,'14:00','12:00',1050000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.751','2026-10-08 16:45:43.751'),(49,'HS012','Tuyền Lâm Lake House','tuyen-lam-lake-house','HOMESTAY',NULL,'Nhà gỗ bên hồ Tuyền Lâm, sương mù lãng mạn, chèo SUP buổi sáng.','Nhà gỗ bên hồ Tuyền Lâm, sương mù lãng mạn, chèo SUP buổi sáng.',NULL,NULL,'Hồ Tuyền Lâm, Đà Lạt',NULL,NULL,'14:00','12:00',1300000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.779','2026-10-08 16:45:43.779'),(50,'HS013','Hạ Long Bay Bungalow','ha-long-bay-bungalow','HOMESTAY',NULL,'Bungalow nhìn ra vịnh Hạ Long, gần cảng tàu tham quan.','Bungalow nhìn ra vịnh Hạ Long, gần cảng tàu tham quan.',NULL,NULL,'Hạ Long, Quảng Ninh',NULL,NULL,'14:00','12:00',1500000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.807','2026-10-08 16:45:43.807'),(51,'HS014','Nhà Vườn Cà Phê Buôn Ma Thuột','nha-vuon-ca-phe-buon-ma-thuot','HOMESTAY',NULL,'Homestay giữa vườn cà phê, trải nghiệm rang xay và cưỡi voi.','Homestay giữa vườn cà phê, trải nghiệm rang xay và cưỡi voi.',NULL,NULL,'Buôn Ma Thuột, Đắk Lắk',NULL,NULL,'14:00','12:00',600000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.836','2026-10-08 16:45:43.836'),(52,'HS015','Mây Núi Cấm An Giang','may-nui-cam-an-giang','HOMESTAY',NULL,'Homestay trên Núi Cấm, săn mây miền Tây, ngắm đồng lúa Bảy Núi.','Homestay trên Núi Cấm, săn mây miền Tây, ngắm đồng lúa Bảy Núi.',NULL,NULL,'Núi Cấm, An Giang',NULL,NULL,'14:00','12:00',550000,30,6,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.865','2026-10-08 16:45:43.865');
/*!40000 ALTER TABLE `Property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PropertyAmenity`
--

DROP TABLE IF EXISTS `PropertyAmenity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PropertyAmenity` (
  `propertyId` int NOT NULL,
  `amenityId` int NOT NULL,
  PRIMARY KEY (`propertyId`,`amenityId`),
  KEY `PropertyAmenity_amenityId_idx` (`amenityId`),
  CONSTRAINT `PropertyAmenity_amenityId_fkey` FOREIGN KEY (`amenityId`) REFERENCES `Amenity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `PropertyAmenity_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PropertyAmenity`
--

LOCK TABLES `PropertyAmenity` WRITE;
/*!40000 ALTER TABLE `PropertyAmenity` DISABLE KEYS */;
/*!40000 ALTER TABLE `PropertyAmenity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PropertyImage`
--

DROP TABLE IF EXISTS `PropertyImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PropertyImage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `propertyId` int NOT NULL,
  `url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isCover` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `PropertyImage_propertyId_idx` (`propertyId`),
  CONSTRAINT `PropertyImage_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PropertyImage`
--

LOCK TABLES `PropertyImage` WRITE;
/*!40000 ALTER TABLE `PropertyImage` DISABLE KEYS */;
INSERT INTO `PropertyImage` VALUES (76,38,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(77,38,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(78,38,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(79,38,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(80,38,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(81,39,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(82,39,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(83,39,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(84,39,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(85,39,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(86,40,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(87,40,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(88,40,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(89,40,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(90,40,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(91,41,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(92,41,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(93,41,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(94,41,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(95,41,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(96,42,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(97,42,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(98,42,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(99,42,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(100,42,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(101,43,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(102,43,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(103,43,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(104,43,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(105,43,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(106,44,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(107,44,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(108,44,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(109,44,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(110,44,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(111,45,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(112,45,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(113,45,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(114,45,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(115,45,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(116,46,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(117,46,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(118,46,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(119,46,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(120,46,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(121,47,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(122,47,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(123,47,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(124,47,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(125,47,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(126,48,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(127,48,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(128,48,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(129,48,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(130,48,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(131,49,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(132,49,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(133,49,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(134,49,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(135,49,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(136,50,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(137,50,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(138,50,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(139,50,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(140,50,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(141,51,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(142,51,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(143,51,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(144,51,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(145,51,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(146,52,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(147,52,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(148,52,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(149,52,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(150,52,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4);
/*!40000 ALTER TABLE `PropertyImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PropertyPolicy`
--

DROP TABLE IF EXISTS `PropertyPolicy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PropertyPolicy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `propertyId` int NOT NULL,
  `type` enum('HOUSE_RULE','NOTE','FAQ') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HOUSE_RULE',
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sortOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `PropertyPolicy_propertyId_idx` (`propertyId`),
  CONSTRAINT `PropertyPolicy_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PropertyPolicy`
--

LOCK TABLES `PropertyPolicy` WRITE;
/*!40000 ALTER TABLE `PropertyPolicy` DISABLE KEYS */;
/*!40000 ALTER TABLE `PropertyPolicy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RefundRequest`
--

DROP TABLE IF EXISTS `RefundRequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RefundRequest` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `amount` int NOT NULL,
  `ratio` int NOT NULL,
  `status` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `RefundRequest_bookingId_idx` (`bookingId`),
  CONSTRAINT `RefundRequest_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RefundRequest`
--

LOCK TABLES `RefundRequest` WRITE;
/*!40000 ALTER TABLE `RefundRequest` DISABLE KEYS */;
INSERT INTO `RefundRequest` VALUES (4,31,750000,50,'PENDING','2026-10-08 16:45:45.048');
/*!40000 ALTER TABLE `RefundRequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Review`
--

DROP TABLE IF EXISTS `Review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Review` (
  `id` int NOT NULL AUTO_INCREMENT,
  `productType` enum('HOMESTAY','TOUR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HOMESTAY',
  `productId` int DEFAULT NULL,
  `propertyId` int DEFAULT NULL,
  `tourId` int DEFAULT NULL,
  `bookingId` int DEFAULT NULL,
  `authorName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` int NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `approved` tinyint(1) NOT NULL DEFAULT '0',
  `rejected` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `Review_bookingId_key` (`bookingId`),
  KEY `Review_productId_idx` (`productId`),
  KEY `Review_propertyId_idx` (`propertyId`),
  KEY `Review_tourId_idx` (`tourId`),
  KEY `Review_approved_idx` (`approved`),
  CONSTRAINT `Review_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Review_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Review_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Review_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
INSERT INTO `Review` VALUES (49,'HOMESTAY',NULL,40,NULL,28,'Nguyễn Minh Anh',5,'Homestay tuyệt vời, view đẹp, chủ nhà thân thiện. Sẽ quay lại!',1,0,'2026-09-21 00:00:00.000'),(50,'TOUR',NULL,NULL,39,30,'Nguyễn Minh Anh',4,'Lịch trình ổn, hướng dẫn viên nhiệt tình. Xe hơi đông.',0,0,'2026-10-07 00:00:00.000'),(51,'HOMESTAY',NULL,38,NULL,NULL,'Hoàng Thị Mai',5,'Sạch sẽ, gần trung tâm, nhân viên dễ thương.',1,0,'2026-09-22 00:00:00.000'),(52,'HOMESTAY',NULL,38,NULL,NULL,'Đỗ Quang Huy',4,'Phòng đẹp, buổi sáng hơi ồn một chút.',1,0,'2026-09-15 00:00:00.000'),(53,'HOMESTAY',NULL,39,NULL,NULL,'Vũ Thị Lan',5,'Không gian yên tĩnh, bữa sáng ngon.',1,0,'2026-09-14 00:00:00.000'),(54,'TOUR',NULL,NULL,38,NULL,'Nguyễn Văn Tú',5,'Cảnh đẹp mê hồn, tổ chức chuyên nghiệp.',1,0,'2026-09-19 00:00:00.000'),(55,'TOUR',NULL,NULL,38,NULL,'Trịnh Bảo',4,'Đáng tiền, nên mang thêm áo ấm.',1,0,'2026-09-25 00:00:00.000'),(56,'TOUR',NULL,NULL,39,NULL,'Lý Thu Hằng',5,'Chuyến đi đáng nhớ, hướng dẫn viên vui tính.',1,0,'2026-09-14 00:00:00.000');
/*!40000 ALTER TABLE `Review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReviewImage`
--

DROP TABLE IF EXISTS `ReviewImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReviewImage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reviewId` int NOT NULL,
  `url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sortOrder` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `ReviewImage_reviewId_idx` (`reviewId`),
  CONSTRAINT `ReviewImage_reviewId_fkey` FOREIGN KEY (`reviewId`) REFERENCES `Review` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewImage`
--

LOCK TABLES `ReviewImage` WRITE;
/*!40000 ALTER TABLE `ReviewImage` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReviewImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReviewToken`
--

DROP TABLE IF EXISTS `ReviewToken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ReviewToken` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bookingId` int NOT NULL,
  `tokenHash` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `usedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ReviewToken_bookingId_key` (`bookingId`),
  UNIQUE KEY `ReviewToken_tokenHash_key` (`tokenHash`),
  CONSTRAINT `ReviewToken_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewToken`
--

LOCK TABLES `ReviewToken` WRITE;
/*!40000 ALTER TABLE `ReviewToken` DISABLE KEYS */;
INSERT INTO `ReviewToken` VALUES (4,32,'8570344517b05be52ca1d6f4ad07bd3da068561912a822608c02b8d3fbdd54a2','2026-11-07 00:00:00.000',NULL,'2026-10-08 16:45:45.059');
/*!40000 ALTER TABLE `ReviewToken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RoomImage`
--

DROP TABLE IF EXISTS `RoomImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RoomImage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `roomTypeId` int NOT NULL,
  `url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isCover` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `RoomImage_roomTypeId_idx` (`roomTypeId`),
  CONSTRAINT `RoomImage_roomTypeId_fkey` FOREIGN KEY (`roomTypeId`) REFERENCES `RoomType` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomImage`
--

LOCK TABLES `RoomImage` WRITE;
/*!40000 ALTER TABLE `RoomImage` DISABLE KEYS */;
INSERT INTO `RoomImage` VALUES (94,80,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(95,80,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(96,80,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(97,81,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(98,81,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(99,81,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(100,82,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(101,82,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(102,82,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(103,83,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(104,83,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(105,83,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(106,84,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(107,84,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(108,84,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(109,85,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(110,85,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(111,85,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(112,86,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(113,86,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(114,86,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(115,87,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(116,87,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(117,87,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(118,88,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(119,88,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(120,88,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(121,89,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(122,89,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(123,89,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(124,90,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(125,90,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(126,90,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(127,91,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(128,91,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(129,91,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(130,92,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(131,92,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(132,92,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(133,93,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(134,93,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(135,93,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(136,94,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(137,94,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(138,94,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(139,95,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(140,95,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(141,95,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(142,96,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(143,96,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(144,96,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(145,97,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(146,97,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(147,97,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(148,98,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(149,98,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(150,98,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(151,99,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(152,99,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(153,99,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(154,100,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(155,100,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(156,100,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(157,101,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(158,101,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(159,101,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(160,102,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(161,102,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(162,102,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(163,103,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(164,103,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(165,103,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(166,104,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(167,104,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(168,104,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(169,105,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(170,105,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(171,105,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(172,106,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(173,106,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(174,106,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(175,107,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(176,107,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(177,107,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(178,108,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(179,108,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(180,108,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(181,109,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(182,109,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(183,109,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(184,110,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(185,110,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(186,110,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2);
/*!40000 ALTER TABLE `RoomImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RoomInventory`
--

DROP TABLE IF EXISTS `RoomInventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RoomInventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `roomTypeId` int NOT NULL,
  `date` date NOT NULL,
  `totalRooms` int NOT NULL,
  `bookedRooms` int NOT NULL DEFAULT '0',
  `heldRooms` int NOT NULL DEFAULT '0',
  `priceOverride` int DEFAULT NULL,
  `isBlocked` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `RoomInventory_roomTypeId_date_key` (`roomTypeId`,`date`),
  KEY `RoomInventory_roomTypeId_idx` (`roomTypeId`),
  CONSTRAINT `RoomInventory_roomTypeId_fkey` FOREIGN KEY (`roomTypeId`) REFERENCES `RoomType` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomInventory`
--

LOCK TABLES `RoomInventory` WRITE;
/*!40000 ALTER TABLE `RoomInventory` DISABLE KEYS */;
INSERT INTO `RoomInventory` VALUES (9481,80,'2026-10-09',6,0,0,NULL,0),(9482,80,'2026-10-10',6,0,0,NULL,0),(9483,80,'2026-10-11',6,0,0,NULL,0),(9484,80,'2026-10-12',6,0,0,NULL,0),(9485,80,'2026-10-13',6,0,0,NULL,0),(9486,80,'2026-10-14',6,0,0,NULL,0),(9487,80,'2026-10-15',6,0,0,NULL,0),(9488,80,'2026-10-16',6,0,0,NULL,0),(9489,80,'2026-10-17',6,0,0,NULL,0),(9490,80,'2026-10-18',6,0,0,NULL,0),(9491,80,'2026-10-19',6,0,0,NULL,0),(9492,80,'2026-10-20',6,0,0,NULL,0),(9493,80,'2026-10-21',6,0,0,NULL,0),(9494,80,'2026-10-22',6,0,0,NULL,0),(9495,80,'2026-10-23',6,0,0,NULL,0),(9496,80,'2026-10-24',6,0,0,NULL,0),(9497,80,'2026-10-25',6,0,0,NULL,0),(9498,80,'2026-10-26',6,0,0,NULL,0),(9499,80,'2026-10-27',6,0,0,NULL,0),(9500,80,'2026-10-28',6,1,0,NULL,0),(9501,80,'2026-10-29',6,1,0,NULL,0),(9502,80,'2026-10-30',6,0,0,NULL,0),(9503,80,'2026-10-31',6,0,0,NULL,0),(9504,80,'2026-11-01',6,0,0,NULL,0),(9505,80,'2026-11-02',6,0,0,NULL,0),(9506,80,'2026-11-03',6,0,0,NULL,0),(9507,80,'2026-11-04',6,0,0,NULL,0),(9508,80,'2026-11-05',6,0,0,NULL,0),(9509,80,'2026-11-06',6,0,0,NULL,0),(9510,80,'2026-11-07',6,0,0,NULL,0),(9511,80,'2026-11-08',6,0,0,NULL,0),(9512,80,'2026-11-09',6,0,0,NULL,0),(9513,80,'2026-11-10',6,0,0,NULL,0),(9514,80,'2026-11-11',6,0,0,NULL,0),(9515,80,'2026-11-12',6,0,0,NULL,0),(9516,80,'2026-11-13',6,0,0,NULL,0),(9517,80,'2026-11-14',6,0,0,NULL,0),(9518,80,'2026-11-15',6,0,0,NULL,0),(9519,80,'2026-11-16',6,0,0,NULL,0),(9520,80,'2026-11-17',6,0,0,NULL,0),(9521,80,'2026-11-18',6,0,0,NULL,0),(9522,80,'2026-11-19',6,0,0,NULL,0),(9523,80,'2026-11-20',6,0,0,NULL,0),(9524,80,'2026-11-21',6,0,0,NULL,0),(9525,80,'2026-11-22',6,0,0,NULL,0),(9526,80,'2026-11-23',6,0,0,NULL,0),(9527,80,'2026-11-24',6,0,0,NULL,0),(9528,80,'2026-11-25',6,0,0,NULL,0),(9529,80,'2026-11-26',6,0,0,NULL,0),(9530,80,'2026-11-27',6,0,0,NULL,0),(9531,80,'2026-11-28',6,0,0,NULL,0),(9532,80,'2026-11-29',6,0,0,NULL,0),(9533,80,'2026-11-30',6,0,0,NULL,0),(9534,80,'2026-12-01',6,0,0,NULL,0),(9535,80,'2026-12-02',6,0,0,NULL,0),(9536,80,'2026-12-03',6,0,0,NULL,0),(9537,80,'2026-12-04',6,0,0,NULL,0),(9538,80,'2026-12-05',6,0,0,NULL,0),(9539,80,'2026-12-06',6,0,0,NULL,0),(9540,80,'2026-12-07',6,0,0,NULL,0),(9541,80,'2026-12-08',6,0,0,NULL,0),(9542,80,'2026-12-09',6,0,0,NULL,0),(9543,80,'2026-12-10',6,0,0,NULL,0),(9544,80,'2026-12-11',6,0,0,NULL,0),(9545,80,'2026-12-12',6,0,0,NULL,0),(9546,80,'2026-12-13',6,0,0,NULL,0),(9547,80,'2026-12-14',6,0,0,NULL,0),(9548,80,'2026-12-15',6,0,0,NULL,0),(9549,80,'2026-12-16',6,0,0,NULL,0),(9550,80,'2026-12-17',6,0,0,NULL,0),(9551,80,'2026-12-18',6,0,0,NULL,0),(9552,80,'2026-12-19',6,0,0,NULL,0),(9553,80,'2026-12-20',6,0,0,NULL,0),(9554,80,'2026-12-21',6,0,0,NULL,0),(9555,80,'2026-12-22',6,0,0,NULL,0),(9556,80,'2026-12-23',6,0,0,NULL,0),(9557,80,'2026-12-24',6,0,0,NULL,0),(9558,80,'2026-12-25',6,0,0,NULL,0),(9559,80,'2026-12-26',6,0,0,NULL,0),(9560,80,'2026-12-27',6,0,0,NULL,0),(9561,80,'2026-12-28',6,0,0,NULL,0),(9562,80,'2026-12-29',6,0,0,NULL,0),(9563,80,'2026-12-30',6,0,0,NULL,0),(9564,80,'2026-12-31',6,0,0,NULL,0),(9565,80,'2027-01-01',6,0,0,NULL,0),(9566,80,'2027-01-02',6,0,0,NULL,0),(9567,80,'2027-01-03',6,0,0,NULL,0),(9568,80,'2027-01-04',6,0,0,NULL,0),(9569,80,'2027-01-05',6,0,0,NULL,0),(9570,80,'2027-01-06',6,0,0,NULL,0),(9571,80,'2027-01-07',6,0,0,NULL,0),(9572,80,'2027-01-08',6,0,0,NULL,0),(9573,80,'2027-01-09',6,0,0,NULL,0),(9574,80,'2027-01-10',6,0,0,NULL,0),(9575,80,'2027-01-11',6,0,0,NULL,0),(9576,80,'2027-01-12',6,0,0,NULL,0),(9577,80,'2027-01-13',6,0,0,NULL,0),(9578,80,'2027-01-14',6,0,0,NULL,0),(9579,80,'2027-01-15',6,0,0,NULL,0),(9580,80,'2027-01-16',6,0,0,NULL,0),(9581,80,'2027-01-17',6,0,0,NULL,0),(9582,80,'2027-01-18',6,0,0,NULL,0),(9583,80,'2027-01-19',6,0,0,NULL,0),(9584,80,'2027-01-20',6,0,0,NULL,0),(9585,80,'2027-01-21',6,0,0,NULL,0),(9586,80,'2027-01-22',6,0,0,NULL,0),(9587,80,'2027-01-23',6,0,0,NULL,0),(9588,80,'2027-01-24',6,0,0,NULL,0),(9589,80,'2027-01-25',6,0,0,NULL,0),(9590,80,'2027-01-26',6,0,0,NULL,0),(9591,80,'2027-01-27',6,0,0,NULL,0),(9592,80,'2027-01-28',6,0,0,NULL,0),(9593,80,'2027-01-29',6,0,0,NULL,0),(9594,80,'2027-01-30',6,0,0,NULL,0),(9595,80,'2027-01-31',6,0,0,NULL,0),(9596,80,'2027-02-01',6,0,0,NULL,0),(9597,80,'2027-02-02',6,0,0,NULL,0),(9598,80,'2027-02-03',6,0,0,NULL,0),(9599,80,'2027-02-04',6,0,0,NULL,0),(9600,80,'2027-02-05',6,0,0,NULL,0),(9601,81,'2026-10-09',4,0,0,NULL,0),(9602,81,'2026-10-10',4,0,0,NULL,0),(9603,81,'2026-10-11',4,0,0,NULL,0),(9604,81,'2026-10-12',4,0,0,NULL,0),(9605,81,'2026-10-13',4,0,0,NULL,0),(9606,81,'2026-10-14',4,0,0,NULL,0),(9607,81,'2026-10-15',4,0,0,NULL,0),(9608,81,'2026-10-16',4,0,0,NULL,0),(9609,81,'2026-10-17',4,0,0,NULL,0),(9610,81,'2026-10-18',4,0,0,NULL,0),(9611,81,'2026-10-19',4,0,0,NULL,0),(9612,81,'2026-10-20',4,0,0,NULL,0),(9613,81,'2026-10-21',4,0,0,NULL,0),(9614,81,'2026-10-22',4,0,0,NULL,0),(9615,81,'2026-10-23',4,0,0,NULL,0),(9616,81,'2026-10-24',4,0,0,NULL,0),(9617,81,'2026-10-25',4,0,0,NULL,0),(9618,81,'2026-10-26',4,0,0,NULL,0),(9619,81,'2026-10-27',4,0,0,NULL,0),(9620,81,'2026-10-28',4,0,0,NULL,0),(9621,81,'2026-10-29',4,0,0,NULL,0),(9622,81,'2026-10-30',4,0,0,NULL,0),(9623,81,'2026-10-31',4,0,0,NULL,0),(9624,81,'2026-11-01',4,0,0,NULL,0),(9625,81,'2026-11-02',4,0,0,NULL,0),(9626,81,'2026-11-03',4,0,0,NULL,0),(9627,81,'2026-11-04',4,0,0,NULL,0),(9628,81,'2026-11-05',4,0,0,NULL,0),(9629,81,'2026-11-06',4,0,0,NULL,0),(9630,81,'2026-11-07',4,0,0,NULL,0),(9631,81,'2026-11-08',4,0,0,NULL,0),(9632,81,'2026-11-09',4,0,0,NULL,0),(9633,81,'2026-11-10',4,0,0,NULL,0),(9634,81,'2026-11-11',4,0,0,NULL,0),(9635,81,'2026-11-12',4,0,0,NULL,0),(9636,81,'2026-11-13',4,0,0,NULL,0),(9637,81,'2026-11-14',4,0,0,NULL,0),(9638,81,'2026-11-15',4,0,0,NULL,0),(9639,81,'2026-11-16',4,0,0,NULL,0),(9640,81,'2026-11-17',4,0,0,NULL,0),(9641,81,'2026-11-18',4,0,0,NULL,0),(9642,81,'2026-11-19',4,0,0,NULL,0),(9643,81,'2026-11-20',4,0,0,NULL,0),(9644,81,'2026-11-21',4,0,0,NULL,0),(9645,81,'2026-11-22',4,0,0,NULL,0),(9646,81,'2026-11-23',4,0,0,NULL,0),(9647,81,'2026-11-24',4,0,0,NULL,0),(9648,81,'2026-11-25',4,0,0,NULL,0),(9649,81,'2026-11-26',4,0,0,NULL,0),(9650,81,'2026-11-27',4,0,0,NULL,0),(9651,81,'2026-11-28',4,0,0,NULL,0),(9652,81,'2026-11-29',4,0,0,NULL,0),(9653,81,'2026-11-30',4,0,0,NULL,0),(9654,81,'2026-12-01',4,0,0,NULL,0),(9655,81,'2026-12-02',4,0,0,NULL,0),(9656,81,'2026-12-03',4,0,0,NULL,0),(9657,81,'2026-12-04',4,0,0,NULL,0),(9658,81,'2026-12-05',4,0,0,NULL,0),(9659,81,'2026-12-06',4,0,0,NULL,0),(9660,81,'2026-12-07',4,0,0,NULL,0),(9661,81,'2026-12-08',4,0,0,NULL,0),(9662,81,'2026-12-09',4,0,0,NULL,0),(9663,81,'2026-12-10',4,0,0,NULL,0),(9664,81,'2026-12-11',4,0,0,NULL,0),(9665,81,'2026-12-12',4,0,0,NULL,0),(9666,81,'2026-12-13',4,0,0,NULL,0),(9667,81,'2026-12-14',4,0,0,NULL,0),(9668,81,'2026-12-15',4,0,0,NULL,0),(9669,81,'2026-12-16',4,0,0,NULL,0),(9670,81,'2026-12-17',4,0,0,NULL,0),(9671,81,'2026-12-18',4,0,0,NULL,0),(9672,81,'2026-12-19',4,0,0,NULL,0),(9673,81,'2026-12-20',4,0,0,NULL,0),(9674,81,'2026-12-21',4,0,0,NULL,0),(9675,81,'2026-12-22',4,0,0,NULL,0),(9676,81,'2026-12-23',4,0,0,NULL,0),(9677,81,'2026-12-24',4,0,0,NULL,0),(9678,81,'2026-12-25',4,0,0,NULL,0),(9679,81,'2026-12-26',4,0,0,NULL,0),(9680,81,'2026-12-27',4,0,0,NULL,0),(9681,81,'2026-12-28',4,0,0,NULL,0),(9682,81,'2026-12-29',4,0,0,NULL,0),(9683,81,'2026-12-30',4,0,0,NULL,0),(9684,81,'2026-12-31',4,0,0,NULL,0),(9685,81,'2027-01-01',4,0,0,NULL,0),(9686,81,'2027-01-02',4,0,0,NULL,0),(9687,81,'2027-01-03',4,0,0,NULL,0),(9688,81,'2027-01-04',4,0,0,NULL,0),(9689,81,'2027-01-05',4,0,0,NULL,0),(9690,81,'2027-01-06',4,0,0,NULL,0),(9691,81,'2027-01-07',4,0,0,NULL,0),(9692,81,'2027-01-08',4,0,0,NULL,0),(9693,81,'2027-01-09',4,0,0,NULL,0),(9694,81,'2027-01-10',4,0,0,NULL,0),(9695,81,'2027-01-11',4,0,0,NULL,0),(9696,81,'2027-01-12',4,0,0,NULL,0),(9697,81,'2027-01-13',4,0,0,NULL,0),(9698,81,'2027-01-14',4,0,0,NULL,0),(9699,81,'2027-01-15',4,0,0,NULL,0),(9700,81,'2027-01-16',4,0,0,NULL,0),(9701,81,'2027-01-17',4,0,0,NULL,0),(9702,81,'2027-01-18',4,0,0,NULL,0),(9703,81,'2027-01-19',4,0,0,NULL,0),(9704,81,'2027-01-20',4,0,0,NULL,0),(9705,81,'2027-01-21',4,0,0,NULL,0),(9706,81,'2027-01-22',4,0,0,NULL,0),(9707,81,'2027-01-23',4,0,0,NULL,0),(9708,81,'2027-01-24',4,0,0,NULL,0),(9709,81,'2027-01-25',4,0,0,NULL,0),(9710,81,'2027-01-26',4,0,0,NULL,0),(9711,81,'2027-01-27',4,0,0,NULL,0),(9712,81,'2027-01-28',4,0,0,NULL,0),(9713,81,'2027-01-29',4,0,0,NULL,0),(9714,81,'2027-01-30',4,0,0,NULL,0),(9715,81,'2027-01-31',4,0,0,NULL,0),(9716,81,'2027-02-01',4,0,0,NULL,0),(9717,81,'2027-02-02',4,0,0,NULL,0),(9718,81,'2027-02-03',4,0,0,NULL,0),(9719,81,'2027-02-04',4,0,0,NULL,0),(9720,81,'2027-02-05',4,0,0,NULL,0),(9721,82,'2026-10-09',2,0,0,NULL,0),(9722,82,'2026-10-10',2,0,0,NULL,0),(9723,82,'2026-10-11',2,0,0,NULL,0),(9724,82,'2026-10-12',2,0,0,NULL,0),(9725,82,'2026-10-13',2,0,0,NULL,0),(9726,82,'2026-10-14',2,0,0,NULL,0),(9727,82,'2026-10-15',2,0,0,NULL,0),(9728,82,'2026-10-16',2,0,0,NULL,0),(9729,82,'2026-10-17',2,0,0,NULL,0),(9730,82,'2026-10-18',2,0,0,NULL,0),(9731,82,'2026-10-19',2,0,0,NULL,0),(9732,82,'2026-10-20',2,0,0,NULL,0),(9733,82,'2026-10-21',2,0,0,NULL,0),(9734,82,'2026-10-22',2,0,0,NULL,0),(9735,82,'2026-10-23',2,0,0,NULL,0),(9736,82,'2026-10-24',2,0,0,NULL,0),(9737,82,'2026-10-25',2,0,0,NULL,0),(9738,82,'2026-10-26',2,0,0,NULL,0),(9739,82,'2026-10-27',2,0,0,NULL,0),(9740,82,'2026-10-28',2,0,0,NULL,0),(9741,82,'2026-10-29',2,0,0,NULL,0),(9742,82,'2026-10-30',2,0,0,NULL,0),(9743,82,'2026-10-31',2,0,0,NULL,0),(9744,82,'2026-11-01',2,0,0,NULL,0),(9745,82,'2026-11-02',2,0,0,NULL,0),(9746,82,'2026-11-03',2,0,0,NULL,0),(9747,82,'2026-11-04',2,0,0,NULL,0),(9748,82,'2026-11-05',2,0,0,NULL,0),(9749,82,'2026-11-06',2,0,0,NULL,0),(9750,82,'2026-11-07',2,0,0,NULL,0),(9751,82,'2026-11-08',2,0,0,NULL,0),(9752,82,'2026-11-09',2,0,0,NULL,0),(9753,82,'2026-11-10',2,0,0,NULL,0),(9754,82,'2026-11-11',2,0,0,NULL,0),(9755,82,'2026-11-12',2,0,0,NULL,0),(9756,82,'2026-11-13',2,0,0,NULL,0),(9757,82,'2026-11-14',2,0,0,NULL,0),(9758,82,'2026-11-15',2,0,0,NULL,0),(9759,82,'2026-11-16',2,0,0,NULL,0),(9760,82,'2026-11-17',2,0,0,NULL,0),(9761,82,'2026-11-18',2,0,0,NULL,0),(9762,82,'2026-11-19',2,0,0,NULL,0),(9763,82,'2026-11-20',2,0,0,NULL,0),(9764,82,'2026-11-21',2,0,0,NULL,0),(9765,82,'2026-11-22',2,0,0,NULL,0),(9766,82,'2026-11-23',2,0,0,NULL,0),(9767,82,'2026-11-24',2,0,0,NULL,0),(9768,82,'2026-11-25',2,0,0,NULL,0),(9769,82,'2026-11-26',2,0,0,NULL,0),(9770,82,'2026-11-27',2,0,0,NULL,0),(9771,82,'2026-11-28',2,0,0,NULL,0),(9772,82,'2026-11-29',2,0,0,NULL,0),(9773,82,'2026-11-30',2,0,0,NULL,0),(9774,82,'2026-12-01',2,0,0,NULL,0),(9775,82,'2026-12-02',2,0,0,NULL,0),(9776,82,'2026-12-03',2,0,0,NULL,0),(9777,82,'2026-12-04',2,0,0,NULL,0),(9778,82,'2026-12-05',2,0,0,NULL,0),(9779,82,'2026-12-06',2,0,0,NULL,0),(9780,82,'2026-12-07',2,0,0,NULL,0),(9781,82,'2026-12-08',2,0,0,NULL,0),(9782,82,'2026-12-09',2,0,0,NULL,0),(9783,82,'2026-12-10',2,0,0,NULL,0),(9784,82,'2026-12-11',2,0,0,NULL,0),(9785,82,'2026-12-12',2,0,0,NULL,0),(9786,82,'2026-12-13',2,0,0,NULL,0),(9787,82,'2026-12-14',2,0,0,NULL,0),(9788,82,'2026-12-15',2,0,0,NULL,0),(9789,82,'2026-12-16',2,0,0,NULL,0),(9790,82,'2026-12-17',2,0,0,NULL,0),(9791,82,'2026-12-18',2,0,0,NULL,0),(9792,82,'2026-12-19',2,0,0,NULL,0),(9793,82,'2026-12-20',2,0,0,NULL,0),(9794,82,'2026-12-21',2,0,0,NULL,0),(9795,82,'2026-12-22',2,0,0,NULL,0),(9796,82,'2026-12-23',2,0,0,NULL,0),(9797,82,'2026-12-24',2,0,0,NULL,0),(9798,82,'2026-12-25',2,0,0,NULL,0),(9799,82,'2026-12-26',2,0,0,NULL,0),(9800,82,'2026-12-27',2,0,0,NULL,0),(9801,82,'2026-12-28',2,0,0,NULL,0),(9802,82,'2026-12-29',2,0,0,NULL,0),(9803,82,'2026-12-30',2,0,0,NULL,0),(9804,82,'2026-12-31',2,0,0,NULL,0),(9805,82,'2027-01-01',2,0,0,NULL,0),(9806,82,'2027-01-02',2,0,0,NULL,0),(9807,82,'2027-01-03',2,0,0,NULL,0),(9808,82,'2027-01-04',2,0,0,NULL,0),(9809,82,'2027-01-05',2,0,0,NULL,0),(9810,82,'2027-01-06',2,0,0,NULL,0),(9811,82,'2027-01-07',2,0,0,NULL,0),(9812,82,'2027-01-08',2,0,0,NULL,0),(9813,82,'2027-01-09',2,0,0,NULL,0),(9814,82,'2027-01-10',2,0,0,NULL,0),(9815,82,'2027-01-11',2,0,0,NULL,0),(9816,82,'2027-01-12',2,0,0,NULL,0),(9817,82,'2027-01-13',2,0,0,NULL,0),(9818,82,'2027-01-14',2,0,0,NULL,0),(9819,82,'2027-01-15',2,0,0,NULL,0),(9820,82,'2027-01-16',2,0,0,NULL,0),(9821,82,'2027-01-17',2,0,0,NULL,0),(9822,82,'2027-01-18',2,0,0,NULL,0),(9823,82,'2027-01-19',2,0,0,NULL,0),(9824,82,'2027-01-20',2,0,0,NULL,0),(9825,82,'2027-01-21',2,0,0,NULL,0),(9826,82,'2027-01-22',2,0,0,NULL,0),(9827,82,'2027-01-23',2,0,0,NULL,0),(9828,82,'2027-01-24',2,0,0,NULL,0),(9829,82,'2027-01-25',2,0,0,NULL,0),(9830,82,'2027-01-26',2,0,0,NULL,0),(9831,82,'2027-01-27',2,0,0,NULL,0),(9832,82,'2027-01-28',2,0,0,NULL,0),(9833,82,'2027-01-29',2,0,0,NULL,0),(9834,82,'2027-01-30',2,0,0,NULL,0),(9835,82,'2027-01-31',2,0,0,NULL,0),(9836,82,'2027-02-01',2,0,0,NULL,0),(9837,82,'2027-02-02',2,0,0,NULL,0),(9838,82,'2027-02-03',2,0,0,NULL,0),(9839,82,'2027-02-04',2,0,0,NULL,0),(9840,82,'2027-02-05',2,0,0,NULL,0),(9841,83,'2026-10-09',5,0,0,NULL,0),(9842,83,'2026-10-10',5,0,0,NULL,0),(9843,83,'2026-10-11',5,0,0,NULL,0),(9844,83,'2026-10-12',5,0,0,NULL,0),(9845,83,'2026-10-13',5,0,0,NULL,0),(9846,83,'2026-10-14',5,0,0,NULL,0),(9847,83,'2026-10-15',5,0,0,NULL,0),(9848,83,'2026-10-16',5,0,0,NULL,0),(9849,83,'2026-10-17',5,0,0,NULL,0),(9850,83,'2026-10-18',5,1,0,NULL,0),(9851,83,'2026-10-19',5,1,0,NULL,0),(9852,83,'2026-10-20',5,0,0,NULL,0),(9853,83,'2026-10-21',5,0,0,NULL,0),(9854,83,'2026-10-22',5,0,0,NULL,0),(9855,83,'2026-10-23',5,0,0,NULL,0),(9856,83,'2026-10-24',5,0,0,NULL,0),(9857,83,'2026-10-25',5,0,0,NULL,0),(9858,83,'2026-10-26',5,0,0,NULL,0),(9859,83,'2026-10-27',5,0,0,NULL,0),(9860,83,'2026-10-28',5,0,0,NULL,0),(9861,83,'2026-10-29',5,0,0,NULL,0),(9862,83,'2026-10-30',5,0,0,NULL,0),(9863,83,'2026-10-31',5,0,0,NULL,0),(9864,83,'2026-11-01',5,0,0,NULL,0),(9865,83,'2026-11-02',5,0,0,NULL,0),(9866,83,'2026-11-03',5,0,0,NULL,0),(9867,83,'2026-11-04',5,0,0,NULL,0),(9868,83,'2026-11-05',5,0,0,NULL,0),(9869,83,'2026-11-06',5,0,0,NULL,0),(9870,83,'2026-11-07',5,0,0,NULL,0),(9871,83,'2026-11-08',5,0,0,NULL,0),(9872,83,'2026-11-09',5,0,0,NULL,0),(9873,83,'2026-11-10',5,0,0,NULL,0),(9874,83,'2026-11-11',5,0,0,NULL,0),(9875,83,'2026-11-12',5,1,0,NULL,0),(9876,83,'2026-11-13',5,1,0,NULL,0),(9877,83,'2026-11-14',5,0,0,NULL,0),(9878,83,'2026-11-15',5,0,0,NULL,0),(9879,83,'2026-11-16',5,0,0,NULL,0),(9880,83,'2026-11-17',5,0,0,NULL,0),(9881,83,'2026-11-18',5,0,0,NULL,0),(9882,83,'2026-11-19',5,0,0,NULL,0),(9883,83,'2026-11-20',5,0,0,NULL,0),(9884,83,'2026-11-21',5,0,0,NULL,0),(9885,83,'2026-11-22',5,0,0,NULL,0),(9886,83,'2026-11-23',5,0,0,NULL,0),(9887,83,'2026-11-24',5,0,0,NULL,0),(9888,83,'2026-11-25',5,0,0,NULL,0),(9889,83,'2026-11-26',5,0,0,NULL,0),(9890,83,'2026-11-27',5,0,0,NULL,0),(9891,83,'2026-11-28',5,0,0,NULL,0),(9892,83,'2026-11-29',5,0,0,NULL,0),(9893,83,'2026-11-30',5,0,0,NULL,0),(9894,83,'2026-12-01',5,0,0,NULL,0),(9895,83,'2026-12-02',5,0,0,NULL,0),(9896,83,'2026-12-03',5,0,0,NULL,0),(9897,83,'2026-12-04',5,0,0,NULL,0),(9898,83,'2026-12-05',5,0,0,NULL,0),(9899,83,'2026-12-06',5,0,0,NULL,0),(9900,83,'2026-12-07',5,0,0,NULL,0),(9901,83,'2026-12-08',5,0,0,NULL,0),(9902,83,'2026-12-09',5,0,0,NULL,0),(9903,83,'2026-12-10',5,0,0,NULL,0),(9904,83,'2026-12-11',5,0,0,NULL,0),(9905,83,'2026-12-12',5,0,0,NULL,0),(9906,83,'2026-12-13',5,0,0,NULL,0),(9907,83,'2026-12-14',5,0,0,NULL,0),(9908,83,'2026-12-15',5,0,0,NULL,0),(9909,83,'2026-12-16',5,0,0,NULL,0),(9910,83,'2026-12-17',5,0,0,NULL,0),(9911,83,'2026-12-18',5,0,0,NULL,0),(9912,83,'2026-12-19',5,0,0,NULL,0),(9913,83,'2026-12-20',5,0,0,NULL,0),(9914,83,'2026-12-21',5,0,0,NULL,0),(9915,83,'2026-12-22',5,0,0,NULL,0),(9916,83,'2026-12-23',5,0,0,NULL,0),(9917,83,'2026-12-24',5,0,0,NULL,0),(9918,83,'2026-12-25',5,0,0,NULL,0),(9919,83,'2026-12-26',5,0,0,NULL,0),(9920,83,'2026-12-27',5,0,0,NULL,0),(9921,83,'2026-12-28',5,0,0,NULL,0),(9922,83,'2026-12-29',5,0,0,NULL,0),(9923,83,'2026-12-30',5,0,0,NULL,0),(9924,83,'2026-12-31',5,0,0,NULL,0),(9925,83,'2027-01-01',5,0,0,NULL,0),(9926,83,'2027-01-02',5,0,0,NULL,0),(9927,83,'2027-01-03',5,0,0,NULL,0),(9928,83,'2027-01-04',5,0,0,NULL,0),(9929,83,'2027-01-05',5,0,0,NULL,0),(9930,83,'2027-01-06',5,0,0,NULL,0),(9931,83,'2027-01-07',5,0,0,NULL,0),(9932,83,'2027-01-08',5,0,0,NULL,0),(9933,83,'2027-01-09',5,0,0,NULL,0),(9934,83,'2027-01-10',5,0,0,NULL,0),(9935,83,'2027-01-11',5,0,0,NULL,0),(9936,83,'2027-01-12',5,0,0,NULL,0),(9937,83,'2027-01-13',5,0,0,NULL,0),(9938,83,'2027-01-14',5,0,0,NULL,0),(9939,83,'2027-01-15',5,0,0,NULL,0),(9940,83,'2027-01-16',5,0,0,NULL,0),(9941,83,'2027-01-17',5,0,0,NULL,0),(9942,83,'2027-01-18',5,0,0,NULL,0),(9943,83,'2027-01-19',5,0,0,NULL,0),(9944,83,'2027-01-20',5,0,0,NULL,0),(9945,83,'2027-01-21',5,0,0,NULL,0),(9946,83,'2027-01-22',5,0,0,NULL,0),(9947,83,'2027-01-23',5,0,0,NULL,0),(9948,83,'2027-01-24',5,0,0,NULL,0),(9949,83,'2027-01-25',5,0,0,NULL,0),(9950,83,'2027-01-26',5,0,0,NULL,0),(9951,83,'2027-01-27',5,0,0,NULL,0),(9952,83,'2027-01-28',5,0,0,NULL,0),(9953,83,'2027-01-29',5,0,0,NULL,0),(9954,83,'2027-01-30',5,0,0,NULL,0),(9955,83,'2027-01-31',5,0,0,NULL,0),(9956,83,'2027-02-01',5,0,0,NULL,0),(9957,83,'2027-02-02',5,0,0,NULL,0),(9958,83,'2027-02-03',5,0,0,NULL,0),(9959,83,'2027-02-04',5,0,0,NULL,0),(9960,83,'2027-02-05',5,0,0,NULL,0),(9961,84,'2026-10-09',3,0,0,NULL,0),(9962,84,'2026-10-10',3,0,0,NULL,0),(9963,84,'2026-10-11',3,0,0,NULL,0),(9964,84,'2026-10-12',3,0,0,NULL,0),(9965,84,'2026-10-13',3,0,0,NULL,0),(9966,84,'2026-10-14',3,0,0,NULL,0),(9967,84,'2026-10-15',3,0,0,NULL,0),(9968,84,'2026-10-16',3,0,0,NULL,0),(9969,84,'2026-10-17',3,0,0,NULL,0),(9970,84,'2026-10-18',3,0,0,NULL,0),(9971,84,'2026-10-19',3,0,0,NULL,0),(9972,84,'2026-10-20',3,0,0,NULL,0),(9973,84,'2026-10-21',3,0,0,NULL,0),(9974,84,'2026-10-22',3,0,0,NULL,0),(9975,84,'2026-10-23',3,0,0,NULL,0),(9976,84,'2026-10-24',3,0,0,NULL,0),(9977,84,'2026-10-25',3,0,0,NULL,0),(9978,84,'2026-10-26',3,0,0,NULL,0),(9979,84,'2026-10-27',3,0,0,NULL,0),(9980,84,'2026-10-28',3,0,0,NULL,0),(9981,84,'2026-10-29',3,0,0,NULL,0),(9982,84,'2026-10-30',3,0,0,NULL,0),(9983,84,'2026-10-31',3,0,0,NULL,0),(9984,84,'2026-11-01',3,0,0,NULL,0),(9985,84,'2026-11-02',3,0,0,NULL,0),(9986,84,'2026-11-03',3,0,0,NULL,0),(9987,84,'2026-11-04',3,0,0,NULL,0),(9988,84,'2026-11-05',3,0,0,NULL,0),(9989,84,'2026-11-06',3,0,0,NULL,0),(9990,84,'2026-11-07',3,0,0,NULL,0),(9991,84,'2026-11-08',3,0,0,NULL,0),(9992,84,'2026-11-09',3,0,0,NULL,0),(9993,84,'2026-11-10',3,0,0,NULL,0),(9994,84,'2026-11-11',3,0,0,NULL,0),(9995,84,'2026-11-12',3,0,0,NULL,0),(9996,84,'2026-11-13',3,0,0,NULL,0),(9997,84,'2026-11-14',3,0,0,NULL,0),(9998,84,'2026-11-15',3,0,0,NULL,0),(9999,84,'2026-11-16',3,0,0,NULL,0),(10000,84,'2026-11-17',3,0,0,NULL,0),(10001,84,'2026-11-18',3,0,0,NULL,0),(10002,84,'2026-11-19',3,0,0,NULL,0),(10003,84,'2026-11-20',3,0,0,NULL,0),(10004,84,'2026-11-21',3,0,0,NULL,0),(10005,84,'2026-11-22',3,0,0,NULL,0),(10006,84,'2026-11-23',3,0,0,NULL,0),(10007,84,'2026-11-24',3,0,0,NULL,0),(10008,84,'2026-11-25',3,0,0,NULL,0),(10009,84,'2026-11-26',3,0,0,NULL,0),(10010,84,'2026-11-27',3,0,0,NULL,0),(10011,84,'2026-11-28',3,0,0,NULL,0),(10012,84,'2026-11-29',3,0,0,NULL,0),(10013,84,'2026-11-30',3,0,0,NULL,0),(10014,84,'2026-12-01',3,0,0,NULL,0),(10015,84,'2026-12-02',3,0,0,NULL,0),(10016,84,'2026-12-03',3,0,0,NULL,0),(10017,84,'2026-12-04',3,0,0,NULL,0),(10018,84,'2026-12-05',3,0,0,NULL,0),(10019,84,'2026-12-06',3,0,0,NULL,0),(10020,84,'2026-12-07',3,0,0,NULL,0),(10021,84,'2026-12-08',3,0,0,NULL,0),(10022,84,'2026-12-09',3,0,0,NULL,0),(10023,84,'2026-12-10',3,0,0,NULL,0),(10024,84,'2026-12-11',3,0,0,NULL,0),(10025,84,'2026-12-12',3,0,0,NULL,0),(10026,84,'2026-12-13',3,0,0,NULL,0),(10027,84,'2026-12-14',3,0,0,NULL,0),(10028,84,'2026-12-15',3,0,0,NULL,0),(10029,84,'2026-12-16',3,0,0,NULL,0),(10030,84,'2026-12-17',3,0,0,NULL,0),(10031,84,'2026-12-18',3,0,0,NULL,0),(10032,84,'2026-12-19',3,0,0,NULL,0),(10033,84,'2026-12-20',3,0,0,NULL,0),(10034,84,'2026-12-21',3,0,0,NULL,0),(10035,84,'2026-12-22',3,0,0,NULL,0),(10036,84,'2026-12-23',3,0,0,NULL,0),(10037,84,'2026-12-24',3,0,0,NULL,0),(10038,84,'2026-12-25',3,0,0,NULL,0),(10039,84,'2026-12-26',3,0,0,NULL,0),(10040,84,'2026-12-27',3,0,0,NULL,0),(10041,84,'2026-12-28',3,0,0,NULL,0),(10042,84,'2026-12-29',3,0,0,NULL,0),(10043,84,'2026-12-30',3,0,0,NULL,0),(10044,84,'2026-12-31',3,0,0,NULL,0),(10045,84,'2027-01-01',3,0,0,NULL,0),(10046,84,'2027-01-02',3,0,0,NULL,0),(10047,84,'2027-01-03',3,0,0,NULL,0),(10048,84,'2027-01-04',3,0,0,NULL,0),(10049,84,'2027-01-05',3,0,0,NULL,0),(10050,84,'2027-01-06',3,0,0,NULL,0),(10051,84,'2027-01-07',3,0,0,NULL,0),(10052,84,'2027-01-08',3,0,0,NULL,0),(10053,84,'2027-01-09',3,0,0,NULL,0),(10054,84,'2027-01-10',3,0,0,NULL,0),(10055,84,'2027-01-11',3,0,0,NULL,0),(10056,84,'2027-01-12',3,0,0,NULL,0),(10057,84,'2027-01-13',3,0,0,NULL,0),(10058,84,'2027-01-14',3,0,0,NULL,0),(10059,84,'2027-01-15',3,0,0,NULL,0),(10060,84,'2027-01-16',3,0,0,NULL,0),(10061,84,'2027-01-17',3,0,0,NULL,0),(10062,84,'2027-01-18',3,0,0,NULL,0),(10063,84,'2027-01-19',3,0,0,NULL,0),(10064,84,'2027-01-20',3,0,0,NULL,0),(10065,84,'2027-01-21',3,0,0,NULL,0),(10066,84,'2027-01-22',3,0,0,NULL,0),(10067,84,'2027-01-23',3,0,0,NULL,0),(10068,84,'2027-01-24',3,0,0,NULL,0),(10069,84,'2027-01-25',3,0,0,NULL,0),(10070,84,'2027-01-26',3,0,0,NULL,0),(10071,84,'2027-01-27',3,0,0,NULL,0),(10072,84,'2027-01-28',3,0,0,NULL,0),(10073,84,'2027-01-29',3,0,0,NULL,0),(10074,84,'2027-01-30',3,0,0,NULL,0),(10075,84,'2027-01-31',3,0,0,NULL,0),(10076,84,'2027-02-01',3,0,0,NULL,0),(10077,84,'2027-02-02',3,0,0,NULL,0),(10078,84,'2027-02-03',3,0,0,NULL,0),(10079,84,'2027-02-04',3,0,0,NULL,0),(10080,84,'2027-02-05',3,0,0,NULL,0),(10081,85,'2026-10-09',6,0,0,NULL,0),(10082,85,'2026-10-10',6,0,0,NULL,0),(10083,85,'2026-10-11',6,0,0,NULL,0),(10084,85,'2026-10-12',6,0,0,NULL,0),(10085,85,'2026-10-13',6,0,0,NULL,0),(10086,85,'2026-10-14',6,0,0,NULL,0),(10087,85,'2026-10-15',6,0,0,NULL,0),(10088,85,'2026-10-16',6,0,0,NULL,0),(10089,85,'2026-10-17',6,0,0,NULL,0),(10090,85,'2026-10-18',6,0,0,NULL,0),(10091,85,'2026-10-19',6,0,0,NULL,0),(10092,85,'2026-10-20',6,0,0,NULL,0),(10093,85,'2026-10-21',6,0,0,NULL,0),(10094,85,'2026-10-22',6,0,0,NULL,0),(10095,85,'2026-10-23',6,0,0,NULL,0),(10096,85,'2026-10-24',6,0,0,NULL,0),(10097,85,'2026-10-25',6,0,0,NULL,0),(10098,85,'2026-10-26',6,0,0,NULL,0),(10099,85,'2026-10-27',6,0,0,NULL,0),(10100,85,'2026-10-28',6,0,0,NULL,0),(10101,85,'2026-10-29',6,0,0,NULL,0),(10102,85,'2026-10-30',6,0,0,NULL,0),(10103,85,'2026-10-31',6,0,0,NULL,0),(10104,85,'2026-11-01',6,0,0,NULL,0),(10105,85,'2026-11-02',6,0,0,NULL,0),(10106,85,'2026-11-03',6,0,0,NULL,0),(10107,85,'2026-11-04',6,0,0,NULL,0),(10108,85,'2026-11-05',6,0,0,NULL,0),(10109,85,'2026-11-06',6,0,0,NULL,0),(10110,85,'2026-11-07',6,0,0,NULL,0),(10111,85,'2026-11-08',6,0,0,NULL,0),(10112,85,'2026-11-09',6,0,0,NULL,0),(10113,85,'2026-11-10',6,0,0,NULL,0),(10114,85,'2026-11-11',6,0,0,NULL,0),(10115,85,'2026-11-12',6,0,0,NULL,0),(10116,85,'2026-11-13',6,0,0,NULL,0),(10117,85,'2026-11-14',6,0,0,NULL,0),(10118,85,'2026-11-15',6,0,0,NULL,0),(10119,85,'2026-11-16',6,0,0,NULL,0),(10120,85,'2026-11-17',6,0,0,NULL,0),(10121,85,'2026-11-18',6,0,0,NULL,0),(10122,85,'2026-11-19',6,0,0,NULL,0),(10123,85,'2026-11-20',6,0,0,NULL,0),(10124,85,'2026-11-21',6,0,0,NULL,0),(10125,85,'2026-11-22',6,0,0,NULL,0),(10126,85,'2026-11-23',6,0,0,NULL,0),(10127,85,'2026-11-24',6,0,0,NULL,0),(10128,85,'2026-11-25',6,0,0,NULL,0),(10129,85,'2026-11-26',6,0,0,NULL,0),(10130,85,'2026-11-27',6,0,0,NULL,0),(10131,85,'2026-11-28',6,0,0,NULL,0),(10132,85,'2026-11-29',6,0,0,NULL,0),(10133,85,'2026-11-30',6,0,0,NULL,0),(10134,85,'2026-12-01',6,0,0,NULL,0),(10135,85,'2026-12-02',6,0,0,NULL,0),(10136,85,'2026-12-03',6,0,0,NULL,0),(10137,85,'2026-12-04',6,0,0,NULL,0),(10138,85,'2026-12-05',6,0,0,NULL,0),(10139,85,'2026-12-06',6,0,0,NULL,0),(10140,85,'2026-12-07',6,0,0,NULL,0),(10141,85,'2026-12-08',6,0,0,NULL,0),(10142,85,'2026-12-09',6,0,0,NULL,0),(10143,85,'2026-12-10',6,0,0,NULL,0),(10144,85,'2026-12-11',6,0,0,NULL,0),(10145,85,'2026-12-12',6,0,0,NULL,0),(10146,85,'2026-12-13',6,0,0,NULL,0),(10147,85,'2026-12-14',6,0,0,NULL,0),(10148,85,'2026-12-15',6,0,0,NULL,0),(10149,85,'2026-12-16',6,0,0,NULL,0),(10150,85,'2026-12-17',6,0,0,NULL,0),(10151,85,'2026-12-18',6,0,0,NULL,0),(10152,85,'2026-12-19',6,0,0,NULL,0),(10153,85,'2026-12-20',6,0,0,NULL,0),(10154,85,'2026-12-21',6,0,0,NULL,0),(10155,85,'2026-12-22',6,0,0,NULL,0),(10156,85,'2026-12-23',6,0,0,NULL,0),(10157,85,'2026-12-24',6,0,0,NULL,0),(10158,85,'2026-12-25',6,0,0,NULL,0),(10159,85,'2026-12-26',6,0,0,NULL,0),(10160,85,'2026-12-27',6,0,0,NULL,0),(10161,85,'2026-12-28',6,0,0,NULL,0),(10162,85,'2026-12-29',6,0,0,NULL,0),(10163,85,'2026-12-30',6,0,0,NULL,0),(10164,85,'2026-12-31',6,0,0,NULL,0),(10165,85,'2027-01-01',6,0,0,NULL,0),(10166,85,'2027-01-02',6,0,0,NULL,0),(10167,85,'2027-01-03',6,0,0,NULL,0),(10168,85,'2027-01-04',6,0,0,NULL,0),(10169,85,'2027-01-05',6,0,0,NULL,0),(10170,85,'2027-01-06',6,0,0,NULL,0),(10171,85,'2027-01-07',6,0,0,NULL,0),(10172,85,'2027-01-08',6,0,0,NULL,0),(10173,85,'2027-01-09',6,0,0,NULL,0),(10174,85,'2027-01-10',6,0,0,NULL,0),(10175,85,'2027-01-11',6,0,0,NULL,0),(10176,85,'2027-01-12',6,0,0,NULL,0),(10177,85,'2027-01-13',6,0,0,NULL,0),(10178,85,'2027-01-14',6,0,0,NULL,0),(10179,85,'2027-01-15',6,0,0,NULL,0),(10180,85,'2027-01-16',6,0,0,NULL,0),(10181,85,'2027-01-17',6,0,0,NULL,0),(10182,85,'2027-01-18',6,0,0,NULL,0),(10183,85,'2027-01-19',6,0,0,NULL,0),(10184,85,'2027-01-20',6,0,0,NULL,0),(10185,85,'2027-01-21',6,0,0,NULL,0),(10186,85,'2027-01-22',6,0,0,NULL,0),(10187,85,'2027-01-23',6,0,0,NULL,0),(10188,85,'2027-01-24',6,0,0,NULL,0),(10189,85,'2027-01-25',6,0,0,NULL,0),(10190,85,'2027-01-26',6,0,0,NULL,0),(10191,85,'2027-01-27',6,0,0,NULL,0),(10192,85,'2027-01-28',6,0,0,NULL,0),(10193,85,'2027-01-29',6,0,0,NULL,0),(10194,85,'2027-01-30',6,0,0,NULL,0),(10195,85,'2027-01-31',6,0,0,NULL,0),(10196,85,'2027-02-01',6,0,0,NULL,0),(10197,85,'2027-02-02',6,0,0,NULL,0),(10198,85,'2027-02-03',6,0,0,NULL,0),(10199,85,'2027-02-04',6,0,0,NULL,0),(10200,85,'2027-02-05',6,0,0,NULL,0),(10201,86,'2026-10-09',3,0,0,NULL,0),(10202,86,'2026-10-10',3,0,0,NULL,0),(10203,86,'2026-10-11',3,0,0,NULL,0),(10204,86,'2026-10-12',3,0,0,NULL,0),(10205,86,'2026-10-13',3,0,0,NULL,0),(10206,86,'2026-10-14',3,0,0,NULL,0),(10207,86,'2026-10-15',3,0,0,NULL,0),(10208,86,'2026-10-16',3,0,0,NULL,0),(10209,86,'2026-10-17',3,0,0,NULL,0),(10210,86,'2026-10-18',3,0,0,NULL,0),(10211,86,'2026-10-19',3,0,0,NULL,0),(10212,86,'2026-10-20',3,0,0,NULL,0),(10213,86,'2026-10-21',3,0,0,NULL,0),(10214,86,'2026-10-22',3,0,0,NULL,0),(10215,86,'2026-10-23',3,0,0,NULL,0),(10216,86,'2026-10-24',3,0,0,NULL,0),(10217,86,'2026-10-25',3,0,0,NULL,0),(10218,86,'2026-10-26',3,0,0,NULL,0),(10219,86,'2026-10-27',3,0,0,NULL,0),(10220,86,'2026-10-28',3,0,0,NULL,0),(10221,86,'2026-10-29',3,0,0,NULL,0),(10222,86,'2026-10-30',3,0,0,NULL,0),(10223,86,'2026-10-31',3,0,0,NULL,0),(10224,86,'2026-11-01',3,0,0,NULL,0),(10225,86,'2026-11-02',3,0,0,NULL,0),(10226,86,'2026-11-03',3,0,0,NULL,0),(10227,86,'2026-11-04',3,0,0,NULL,0),(10228,86,'2026-11-05',3,0,0,NULL,0),(10229,86,'2026-11-06',3,0,0,NULL,0),(10230,86,'2026-11-07',3,0,0,NULL,0),(10231,86,'2026-11-08',3,0,0,NULL,0),(10232,86,'2026-11-09',3,0,0,NULL,0),(10233,86,'2026-11-10',3,0,0,NULL,0),(10234,86,'2026-11-11',3,0,0,NULL,0),(10235,86,'2026-11-12',3,0,0,NULL,0),(10236,86,'2026-11-13',3,0,0,NULL,0),(10237,86,'2026-11-14',3,0,0,NULL,0),(10238,86,'2026-11-15',3,0,0,NULL,0),(10239,86,'2026-11-16',3,0,0,NULL,0),(10240,86,'2026-11-17',3,0,0,NULL,0),(10241,86,'2026-11-18',3,0,0,NULL,0),(10242,86,'2026-11-19',3,0,0,NULL,0),(10243,86,'2026-11-20',3,0,0,NULL,0),(10244,86,'2026-11-21',3,0,0,NULL,0),(10245,86,'2026-11-22',3,0,0,NULL,0),(10246,86,'2026-11-23',3,0,0,NULL,0),(10247,86,'2026-11-24',3,0,0,NULL,0),(10248,86,'2026-11-25',3,0,0,NULL,0),(10249,86,'2026-11-26',3,0,0,NULL,0),(10250,86,'2026-11-27',3,0,0,NULL,0),(10251,86,'2026-11-28',3,0,0,NULL,0),(10252,86,'2026-11-29',3,0,0,NULL,0),(10253,86,'2026-11-30',3,0,0,NULL,0),(10254,86,'2026-12-01',3,0,0,NULL,0),(10255,86,'2026-12-02',3,0,0,NULL,0),(10256,86,'2026-12-03',3,0,0,NULL,0),(10257,86,'2026-12-04',3,0,0,NULL,0),(10258,86,'2026-12-05',3,0,0,NULL,0),(10259,86,'2026-12-06',3,0,0,NULL,0),(10260,86,'2026-12-07',3,0,0,NULL,0),(10261,86,'2026-12-08',3,0,0,NULL,0),(10262,86,'2026-12-09',3,0,0,NULL,0),(10263,86,'2026-12-10',3,0,0,NULL,0),(10264,86,'2026-12-11',3,0,0,NULL,0),(10265,86,'2026-12-12',3,0,0,NULL,0),(10266,86,'2026-12-13',3,0,0,NULL,0),(10267,86,'2026-12-14',3,0,0,NULL,0),(10268,86,'2026-12-15',3,0,0,NULL,0),(10269,86,'2026-12-16',3,0,0,NULL,0),(10270,86,'2026-12-17',3,0,0,NULL,0),(10271,86,'2026-12-18',3,0,0,NULL,0),(10272,86,'2026-12-19',3,0,0,NULL,0),(10273,86,'2026-12-20',3,0,0,NULL,0),(10274,86,'2026-12-21',3,0,0,NULL,0),(10275,86,'2026-12-22',3,0,0,NULL,0),(10276,86,'2026-12-23',3,0,0,NULL,0),(10277,86,'2026-12-24',3,0,0,NULL,0),(10278,86,'2026-12-25',3,0,0,NULL,0),(10279,86,'2026-12-26',3,0,0,NULL,0),(10280,86,'2026-12-27',3,0,0,NULL,0),(10281,86,'2026-12-28',3,0,0,NULL,0),(10282,86,'2026-12-29',3,0,0,NULL,0),(10283,86,'2026-12-30',3,0,0,NULL,0),(10284,86,'2026-12-31',3,0,0,NULL,0),(10285,86,'2027-01-01',3,0,0,NULL,0),(10286,86,'2027-01-02',3,0,0,NULL,0),(10287,86,'2027-01-03',3,0,0,NULL,0),(10288,86,'2027-01-04',3,0,0,NULL,0),(10289,86,'2027-01-05',3,0,0,NULL,0),(10290,86,'2027-01-06',3,0,0,NULL,0),(10291,86,'2027-01-07',3,0,0,NULL,0),(10292,86,'2027-01-08',3,0,0,NULL,0),(10293,86,'2027-01-09',3,0,0,NULL,0),(10294,86,'2027-01-10',3,0,0,NULL,0),(10295,86,'2027-01-11',3,0,0,NULL,0),(10296,86,'2027-01-12',3,0,0,NULL,0),(10297,86,'2027-01-13',3,0,0,NULL,0),(10298,86,'2027-01-14',3,0,0,NULL,0),(10299,86,'2027-01-15',3,0,0,NULL,0),(10300,86,'2027-01-16',3,0,0,NULL,0),(10301,86,'2027-01-17',3,0,0,NULL,0),(10302,86,'2027-01-18',3,0,0,NULL,0),(10303,86,'2027-01-19',3,0,0,NULL,0),(10304,86,'2027-01-20',3,0,0,NULL,0),(10305,86,'2027-01-21',3,0,0,NULL,0),(10306,86,'2027-01-22',3,0,0,NULL,0),(10307,86,'2027-01-23',3,0,0,NULL,0),(10308,86,'2027-01-24',3,0,0,NULL,0),(10309,86,'2027-01-25',3,0,0,NULL,0),(10310,86,'2027-01-26',3,0,0,NULL,0),(10311,86,'2027-01-27',3,0,0,NULL,0),(10312,86,'2027-01-28',3,0,0,NULL,0),(10313,86,'2027-01-29',3,0,0,NULL,0),(10314,86,'2027-01-30',3,0,0,NULL,0),(10315,86,'2027-01-31',3,0,0,NULL,0),(10316,86,'2027-02-01',3,0,0,NULL,0),(10317,86,'2027-02-02',3,0,0,NULL,0),(10318,86,'2027-02-03',3,0,0,NULL,0),(10319,86,'2027-02-04',3,0,0,NULL,0),(10320,86,'2027-02-05',3,0,0,NULL,0),(10321,87,'2026-10-09',10,0,0,NULL,0),(10322,87,'2026-10-10',10,0,0,NULL,0),(10323,87,'2026-10-11',10,0,0,NULL,0),(10324,87,'2026-10-12',10,0,0,NULL,0),(10325,87,'2026-10-13',10,0,0,NULL,0),(10326,87,'2026-10-14',10,0,0,NULL,0),(10327,87,'2026-10-15',10,0,0,NULL,0),(10328,87,'2026-10-16',10,0,0,NULL,0),(10329,87,'2026-10-17',10,0,0,NULL,0),(10330,87,'2026-10-18',10,0,0,NULL,0),(10331,87,'2026-10-19',10,0,0,NULL,0),(10332,87,'2026-10-20',10,0,0,NULL,0),(10333,87,'2026-10-21',10,0,0,NULL,0),(10334,87,'2026-10-22',10,0,0,NULL,0),(10335,87,'2026-10-23',10,0,0,NULL,0),(10336,87,'2026-10-24',10,0,0,NULL,0),(10337,87,'2026-10-25',10,0,0,NULL,0),(10338,87,'2026-10-26',10,0,0,NULL,0),(10339,87,'2026-10-27',10,0,0,NULL,0),(10340,87,'2026-10-28',10,0,0,NULL,0),(10341,87,'2026-10-29',10,0,0,NULL,0),(10342,87,'2026-10-30',10,0,0,NULL,0),(10343,87,'2026-10-31',10,0,0,NULL,0),(10344,87,'2026-11-01',10,0,0,NULL,0),(10345,87,'2026-11-02',10,0,0,NULL,0),(10346,87,'2026-11-03',10,0,0,NULL,0),(10347,87,'2026-11-04',10,0,0,NULL,0),(10348,87,'2026-11-05',10,0,0,NULL,0),(10349,87,'2026-11-06',10,0,0,NULL,0),(10350,87,'2026-11-07',10,0,0,NULL,0),(10351,87,'2026-11-08',10,0,0,NULL,0),(10352,87,'2026-11-09',10,0,0,NULL,0),(10353,87,'2026-11-10',10,0,0,NULL,0),(10354,87,'2026-11-11',10,0,0,NULL,0),(10355,87,'2026-11-12',10,0,0,NULL,0),(10356,87,'2026-11-13',10,0,0,NULL,0),(10357,87,'2026-11-14',10,0,0,NULL,0),(10358,87,'2026-11-15',10,0,0,NULL,0),(10359,87,'2026-11-16',10,0,0,NULL,0),(10360,87,'2026-11-17',10,0,0,NULL,0),(10361,87,'2026-11-18',10,0,0,NULL,0),(10362,87,'2026-11-19',10,0,0,NULL,0),(10363,87,'2026-11-20',10,0,0,NULL,0),(10364,87,'2026-11-21',10,0,0,NULL,0),(10365,87,'2026-11-22',10,0,0,NULL,0),(10366,87,'2026-11-23',10,0,0,NULL,0),(10367,87,'2026-11-24',10,0,0,NULL,0),(10368,87,'2026-11-25',10,0,0,NULL,0),(10369,87,'2026-11-26',10,0,0,NULL,0),(10370,87,'2026-11-27',10,0,0,NULL,0),(10371,87,'2026-11-28',10,0,0,NULL,0),(10372,87,'2026-11-29',10,0,0,NULL,0),(10373,87,'2026-11-30',10,0,0,NULL,0),(10374,87,'2026-12-01',10,0,0,NULL,0),(10375,87,'2026-12-02',10,0,0,NULL,0),(10376,87,'2026-12-03',10,0,0,NULL,0),(10377,87,'2026-12-04',10,0,0,NULL,0),(10378,87,'2026-12-05',10,0,0,NULL,0),(10379,87,'2026-12-06',10,0,0,NULL,0),(10380,87,'2026-12-07',10,0,0,NULL,0),(10381,87,'2026-12-08',10,0,0,NULL,0),(10382,87,'2026-12-09',10,0,0,NULL,0),(10383,87,'2026-12-10',10,0,0,NULL,0),(10384,87,'2026-12-11',10,0,0,NULL,0),(10385,87,'2026-12-12',10,0,0,NULL,0),(10386,87,'2026-12-13',10,0,0,NULL,0),(10387,87,'2026-12-14',10,0,0,NULL,0),(10388,87,'2026-12-15',10,0,0,NULL,0),(10389,87,'2026-12-16',10,0,0,NULL,0),(10390,87,'2026-12-17',10,0,0,NULL,0),(10391,87,'2026-12-18',10,0,0,NULL,0),(10392,87,'2026-12-19',10,0,0,NULL,0),(10393,87,'2026-12-20',10,0,0,NULL,0),(10394,87,'2026-12-21',10,0,0,NULL,0),(10395,87,'2026-12-22',10,0,0,NULL,0),(10396,87,'2026-12-23',10,0,0,NULL,0),(10397,87,'2026-12-24',10,0,0,NULL,0),(10398,87,'2026-12-25',10,0,0,NULL,0),(10399,87,'2026-12-26',10,0,0,NULL,0),(10400,87,'2026-12-27',10,0,0,NULL,0),(10401,87,'2026-12-28',10,0,0,NULL,0),(10402,87,'2026-12-29',10,0,0,NULL,0),(10403,87,'2026-12-30',10,0,0,NULL,0),(10404,87,'2026-12-31',10,0,0,NULL,0),(10405,87,'2027-01-01',10,0,0,NULL,0),(10406,87,'2027-01-02',10,0,0,NULL,0),(10407,87,'2027-01-03',10,0,0,NULL,0),(10408,87,'2027-01-04',10,0,0,NULL,0),(10409,87,'2027-01-05',10,0,0,NULL,0),(10410,87,'2027-01-06',10,0,0,NULL,0),(10411,87,'2027-01-07',10,0,0,NULL,0),(10412,87,'2027-01-08',10,0,0,NULL,0),(10413,87,'2027-01-09',10,0,0,NULL,0),(10414,87,'2027-01-10',10,0,0,NULL,0),(10415,87,'2027-01-11',10,0,0,NULL,0),(10416,87,'2027-01-12',10,0,0,NULL,0),(10417,87,'2027-01-13',10,0,0,NULL,0),(10418,87,'2027-01-14',10,0,0,NULL,0),(10419,87,'2027-01-15',10,0,0,NULL,0),(10420,87,'2027-01-16',10,0,0,NULL,0),(10421,87,'2027-01-17',10,0,0,NULL,0),(10422,87,'2027-01-18',10,0,0,NULL,0),(10423,87,'2027-01-19',10,0,0,NULL,0),(10424,87,'2027-01-20',10,0,0,NULL,0),(10425,87,'2027-01-21',10,0,0,NULL,0),(10426,87,'2027-01-22',10,0,0,NULL,0),(10427,87,'2027-01-23',10,0,0,NULL,0),(10428,87,'2027-01-24',10,0,0,NULL,0),(10429,87,'2027-01-25',10,0,0,NULL,0),(10430,87,'2027-01-26',10,0,0,NULL,0),(10431,87,'2027-01-27',10,0,0,NULL,0),(10432,87,'2027-01-28',10,0,0,NULL,0),(10433,87,'2027-01-29',10,0,0,NULL,0),(10434,87,'2027-01-30',10,0,0,NULL,0),(10435,87,'2027-01-31',10,0,0,NULL,0),(10436,87,'2027-02-01',10,0,0,NULL,0),(10437,87,'2027-02-02',10,0,0,NULL,0),(10438,87,'2027-02-03',10,0,0,NULL,0),(10439,87,'2027-02-04',10,0,0,NULL,0),(10440,87,'2027-02-05',10,0,0,NULL,0),(10441,88,'2026-10-09',4,0,0,NULL,0),(10442,88,'2026-10-10',4,0,0,NULL,0),(10443,88,'2026-10-11',4,0,0,NULL,0),(10444,88,'2026-10-12',4,0,0,NULL,0),(10445,88,'2026-10-13',4,0,0,NULL,0),(10446,88,'2026-10-14',4,0,0,NULL,0),(10447,88,'2026-10-15',4,0,0,NULL,0),(10448,88,'2026-10-16',4,0,0,NULL,0),(10449,88,'2026-10-17',4,0,0,NULL,0),(10450,88,'2026-10-18',4,0,0,NULL,0),(10451,88,'2026-10-19',4,0,0,NULL,0),(10452,88,'2026-10-20',4,0,0,NULL,0),(10453,88,'2026-10-21',4,0,0,NULL,0),(10454,88,'2026-10-22',4,0,0,NULL,0),(10455,88,'2026-10-23',4,0,0,NULL,0),(10456,88,'2026-10-24',4,0,0,NULL,0),(10457,88,'2026-10-25',4,0,0,NULL,0),(10458,88,'2026-10-26',4,0,0,NULL,0),(10459,88,'2026-10-27',4,0,0,NULL,0),(10460,88,'2026-10-28',4,0,0,NULL,0),(10461,88,'2026-10-29',4,0,0,NULL,0),(10462,88,'2026-10-30',4,0,0,NULL,0),(10463,88,'2026-10-31',4,0,0,NULL,0),(10464,88,'2026-11-01',4,0,0,NULL,0),(10465,88,'2026-11-02',4,0,0,NULL,0),(10466,88,'2026-11-03',4,0,0,NULL,0),(10467,88,'2026-11-04',4,0,0,NULL,0),(10468,88,'2026-11-05',4,0,0,NULL,0),(10469,88,'2026-11-06',4,0,0,NULL,0),(10470,88,'2026-11-07',4,0,0,NULL,0),(10471,88,'2026-11-08',4,0,0,NULL,0),(10472,88,'2026-11-09',4,0,0,NULL,0),(10473,88,'2026-11-10',4,0,0,NULL,0),(10474,88,'2026-11-11',4,0,0,NULL,0),(10475,88,'2026-11-12',4,0,0,NULL,0),(10476,88,'2026-11-13',4,0,0,NULL,0),(10477,88,'2026-11-14',4,0,0,NULL,0),(10478,88,'2026-11-15',4,0,0,NULL,0),(10479,88,'2026-11-16',4,0,0,NULL,0),(10480,88,'2026-11-17',4,0,0,NULL,0),(10481,88,'2026-11-18',4,0,0,NULL,0),(10482,88,'2026-11-19',4,0,0,NULL,0),(10483,88,'2026-11-20',4,0,0,NULL,0),(10484,88,'2026-11-21',4,0,0,NULL,0),(10485,88,'2026-11-22',4,0,0,NULL,0),(10486,88,'2026-11-23',4,0,0,NULL,0),(10487,88,'2026-11-24',4,0,0,NULL,0),(10488,88,'2026-11-25',4,0,0,NULL,0),(10489,88,'2026-11-26',4,0,0,NULL,0),(10490,88,'2026-11-27',4,0,0,NULL,0),(10491,88,'2026-11-28',4,0,0,NULL,0),(10492,88,'2026-11-29',4,0,0,NULL,0),(10493,88,'2026-11-30',4,0,0,NULL,0),(10494,88,'2026-12-01',4,0,0,NULL,0),(10495,88,'2026-12-02',4,0,0,NULL,0),(10496,88,'2026-12-03',4,0,0,NULL,0),(10497,88,'2026-12-04',4,0,0,NULL,0),(10498,88,'2026-12-05',4,0,0,NULL,0),(10499,88,'2026-12-06',4,0,0,NULL,0),(10500,88,'2026-12-07',4,0,0,NULL,0),(10501,88,'2026-12-08',4,0,0,NULL,0),(10502,88,'2026-12-09',4,0,0,NULL,0),(10503,88,'2026-12-10',4,0,0,NULL,0),(10504,88,'2026-12-11',4,0,0,NULL,0),(10505,88,'2026-12-12',4,0,0,NULL,0),(10506,88,'2026-12-13',4,0,0,NULL,0),(10507,88,'2026-12-14',4,0,0,NULL,0),(10508,88,'2026-12-15',4,0,0,NULL,0),(10509,88,'2026-12-16',4,0,0,NULL,0),(10510,88,'2026-12-17',4,0,0,NULL,0),(10511,88,'2026-12-18',4,0,0,NULL,0),(10512,88,'2026-12-19',4,0,0,NULL,0),(10513,88,'2026-12-20',4,0,0,NULL,0),(10514,88,'2026-12-21',4,0,0,NULL,0),(10515,88,'2026-12-22',4,0,0,NULL,0),(10516,88,'2026-12-23',4,0,0,NULL,0),(10517,88,'2026-12-24',4,0,0,NULL,0),(10518,88,'2026-12-25',4,0,0,NULL,0),(10519,88,'2026-12-26',4,0,0,NULL,0),(10520,88,'2026-12-27',4,0,0,NULL,0),(10521,88,'2026-12-28',4,0,0,NULL,0),(10522,88,'2026-12-29',4,0,0,NULL,0),(10523,88,'2026-12-30',4,0,0,NULL,0),(10524,88,'2026-12-31',4,0,0,NULL,0),(10525,88,'2027-01-01',4,0,0,NULL,0),(10526,88,'2027-01-02',4,0,0,NULL,0),(10527,88,'2027-01-03',4,0,0,NULL,0),(10528,88,'2027-01-04',4,0,0,NULL,0),(10529,88,'2027-01-05',4,0,0,NULL,0),(10530,88,'2027-01-06',4,0,0,NULL,0),(10531,88,'2027-01-07',4,0,0,NULL,0),(10532,88,'2027-01-08',4,0,0,NULL,0),(10533,88,'2027-01-09',4,0,0,NULL,0),(10534,88,'2027-01-10',4,0,0,NULL,0),(10535,88,'2027-01-11',4,0,0,NULL,0),(10536,88,'2027-01-12',4,0,0,NULL,0),(10537,88,'2027-01-13',4,0,0,NULL,0),(10538,88,'2027-01-14',4,0,0,NULL,0),(10539,88,'2027-01-15',4,0,0,NULL,0),(10540,88,'2027-01-16',4,0,0,NULL,0),(10541,88,'2027-01-17',4,0,0,NULL,0),(10542,88,'2027-01-18',4,0,0,NULL,0),(10543,88,'2027-01-19',4,0,0,NULL,0),(10544,88,'2027-01-20',4,0,0,NULL,0),(10545,88,'2027-01-21',4,0,0,NULL,0),(10546,88,'2027-01-22',4,0,0,NULL,0),(10547,88,'2027-01-23',4,0,0,NULL,0),(10548,88,'2027-01-24',4,0,0,NULL,0),(10549,88,'2027-01-25',4,0,0,NULL,0),(10550,88,'2027-01-26',4,0,0,NULL,0),(10551,88,'2027-01-27',4,0,0,NULL,0),(10552,88,'2027-01-28',4,0,0,NULL,0),(10553,88,'2027-01-29',4,0,0,NULL,0),(10554,88,'2027-01-30',4,0,0,NULL,0),(10555,88,'2027-01-31',4,0,0,NULL,0),(10556,88,'2027-02-01',4,0,0,NULL,0),(10557,88,'2027-02-02',4,0,0,NULL,0),(10558,88,'2027-02-03',4,0,0,NULL,0),(10559,88,'2027-02-04',4,0,0,NULL,0),(10560,88,'2027-02-05',4,0,0,NULL,0),(10561,89,'2026-10-09',4,0,0,NULL,0),(10562,89,'2026-10-10',4,0,0,NULL,0),(10563,89,'2026-10-11',4,0,0,NULL,0),(10564,89,'2026-10-12',4,0,0,NULL,0),(10565,89,'2026-10-13',4,0,0,NULL,0),(10566,89,'2026-10-14',4,0,0,NULL,0),(10567,89,'2026-10-15',4,0,0,NULL,0),(10568,89,'2026-10-16',4,0,0,NULL,0),(10569,89,'2026-10-17',4,0,0,NULL,0),(10570,89,'2026-10-18',4,0,0,NULL,0),(10571,89,'2026-10-19',4,0,0,NULL,0),(10572,89,'2026-10-20',4,0,0,NULL,0),(10573,89,'2026-10-21',4,0,0,NULL,0),(10574,89,'2026-10-22',4,0,0,NULL,0),(10575,89,'2026-10-23',4,0,0,NULL,0),(10576,89,'2026-10-24',4,0,0,NULL,0),(10577,89,'2026-10-25',4,0,0,NULL,0),(10578,89,'2026-10-26',4,0,0,NULL,0),(10579,89,'2026-10-27',4,0,0,NULL,0),(10580,89,'2026-10-28',4,0,0,NULL,0),(10581,89,'2026-10-29',4,0,0,NULL,0),(10582,89,'2026-10-30',4,0,0,NULL,0),(10583,89,'2026-10-31',4,0,0,NULL,0),(10584,89,'2026-11-01',4,0,0,NULL,0),(10585,89,'2026-11-02',4,0,0,NULL,0),(10586,89,'2026-11-03',4,0,0,NULL,0),(10587,89,'2026-11-04',4,0,0,NULL,0),(10588,89,'2026-11-05',4,0,0,NULL,0),(10589,89,'2026-11-06',4,0,0,NULL,0),(10590,89,'2026-11-07',4,0,0,NULL,0),(10591,89,'2026-11-08',4,0,0,NULL,0),(10592,89,'2026-11-09',4,0,0,NULL,0),(10593,89,'2026-11-10',4,0,0,NULL,0),(10594,89,'2026-11-11',4,0,0,NULL,0),(10595,89,'2026-11-12',4,0,0,NULL,0),(10596,89,'2026-11-13',4,0,0,NULL,0),(10597,89,'2026-11-14',4,0,0,NULL,0),(10598,89,'2026-11-15',4,0,0,NULL,0),(10599,89,'2026-11-16',4,0,0,NULL,0),(10600,89,'2026-11-17',4,0,0,NULL,0),(10601,89,'2026-11-18',4,0,0,NULL,0),(10602,89,'2026-11-19',4,0,0,NULL,0),(10603,89,'2026-11-20',4,0,0,NULL,0),(10604,89,'2026-11-21',4,0,0,NULL,0),(10605,89,'2026-11-22',4,0,0,NULL,0),(10606,89,'2026-11-23',4,0,0,NULL,0),(10607,89,'2026-11-24',4,0,0,NULL,0),(10608,89,'2026-11-25',4,0,0,NULL,0),(10609,89,'2026-11-26',4,0,0,NULL,0),(10610,89,'2026-11-27',4,0,0,NULL,0),(10611,89,'2026-11-28',4,0,0,NULL,0),(10612,89,'2026-11-29',4,0,0,NULL,0),(10613,89,'2026-11-30',4,0,0,NULL,0),(10614,89,'2026-12-01',4,0,0,NULL,0),(10615,89,'2026-12-02',4,0,0,NULL,0),(10616,89,'2026-12-03',4,0,0,NULL,0),(10617,89,'2026-12-04',4,0,0,NULL,0),(10618,89,'2026-12-05',4,0,0,NULL,0),(10619,89,'2026-12-06',4,0,0,NULL,0),(10620,89,'2026-12-07',4,0,0,NULL,0),(10621,89,'2026-12-08',4,0,0,NULL,0),(10622,89,'2026-12-09',4,0,0,NULL,0),(10623,89,'2026-12-10',4,0,0,NULL,0),(10624,89,'2026-12-11',4,0,0,NULL,0),(10625,89,'2026-12-12',4,0,0,NULL,0),(10626,89,'2026-12-13',4,0,0,NULL,0),(10627,89,'2026-12-14',4,0,0,NULL,0),(10628,89,'2026-12-15',4,0,0,NULL,0),(10629,89,'2026-12-16',4,0,0,NULL,0),(10630,89,'2026-12-17',4,0,0,NULL,0),(10631,89,'2026-12-18',4,0,0,NULL,0),(10632,89,'2026-12-19',4,0,0,NULL,0),(10633,89,'2026-12-20',4,0,0,NULL,0),(10634,89,'2026-12-21',4,0,0,NULL,0),(10635,89,'2026-12-22',4,0,0,NULL,0),(10636,89,'2026-12-23',4,0,0,NULL,0),(10637,89,'2026-12-24',4,0,0,NULL,0),(10638,89,'2026-12-25',4,0,0,NULL,0),(10639,89,'2026-12-26',4,0,0,NULL,0),(10640,89,'2026-12-27',4,0,0,NULL,0),(10641,89,'2026-12-28',4,0,0,NULL,0),(10642,89,'2026-12-29',4,0,0,NULL,0),(10643,89,'2026-12-30',4,0,0,NULL,0),(10644,89,'2026-12-31',4,0,0,NULL,0),(10645,89,'2027-01-01',4,0,0,NULL,0),(10646,89,'2027-01-02',4,0,0,NULL,0),(10647,89,'2027-01-03',4,0,0,NULL,0),(10648,89,'2027-01-04',4,0,0,NULL,0),(10649,89,'2027-01-05',4,0,0,NULL,0),(10650,89,'2027-01-06',4,0,0,NULL,0),(10651,89,'2027-01-07',4,0,0,NULL,0),(10652,89,'2027-01-08',4,0,0,NULL,0),(10653,89,'2027-01-09',4,0,0,NULL,0),(10654,89,'2027-01-10',4,0,0,NULL,0),(10655,89,'2027-01-11',4,0,0,NULL,0),(10656,89,'2027-01-12',4,0,0,NULL,0),(10657,89,'2027-01-13',4,0,0,NULL,0),(10658,89,'2027-01-14',4,0,0,NULL,0),(10659,89,'2027-01-15',4,0,0,NULL,0),(10660,89,'2027-01-16',4,0,0,NULL,0),(10661,89,'2027-01-17',4,0,0,NULL,0),(10662,89,'2027-01-18',4,0,0,NULL,0),(10663,89,'2027-01-19',4,0,0,NULL,0),(10664,89,'2027-01-20',4,0,0,NULL,0),(10665,89,'2027-01-21',4,0,0,NULL,0),(10666,89,'2027-01-22',4,0,0,NULL,0),(10667,89,'2027-01-23',4,0,0,NULL,0),(10668,89,'2027-01-24',4,0,0,NULL,0),(10669,89,'2027-01-25',4,0,0,NULL,0),(10670,89,'2027-01-26',4,0,0,NULL,0),(10671,89,'2027-01-27',4,0,0,NULL,0),(10672,89,'2027-01-28',4,0,0,NULL,0),(10673,89,'2027-01-29',4,0,0,NULL,0),(10674,89,'2027-01-30',4,0,0,NULL,0),(10675,89,'2027-01-31',4,0,0,NULL,0),(10676,89,'2027-02-01',4,0,0,NULL,0),(10677,89,'2027-02-02',4,0,0,NULL,0),(10678,89,'2027-02-03',4,0,0,NULL,0),(10679,89,'2027-02-04',4,0,0,NULL,0),(10680,89,'2027-02-05',4,0,0,NULL,0),(10681,90,'2026-10-09',3,0,0,NULL,0),(10682,90,'2026-10-10',3,0,0,NULL,0),(10683,90,'2026-10-11',3,0,0,NULL,0),(10684,90,'2026-10-12',3,0,0,NULL,0),(10685,90,'2026-10-13',3,0,0,NULL,0),(10686,90,'2026-10-14',3,0,0,NULL,0),(10687,90,'2026-10-15',3,0,0,NULL,0),(10688,90,'2026-10-16',3,0,0,NULL,0),(10689,90,'2026-10-17',3,0,0,NULL,0),(10690,90,'2026-10-18',3,0,0,NULL,0),(10691,90,'2026-10-19',3,0,0,NULL,0),(10692,90,'2026-10-20',3,0,0,NULL,0),(10693,90,'2026-10-21',3,0,0,NULL,0),(10694,90,'2026-10-22',3,0,0,NULL,0),(10695,90,'2026-10-23',3,0,0,NULL,0),(10696,90,'2026-10-24',3,0,0,NULL,0),(10697,90,'2026-10-25',3,0,0,NULL,0),(10698,90,'2026-10-26',3,0,0,NULL,0),(10699,90,'2026-10-27',3,0,0,NULL,0),(10700,90,'2026-10-28',3,0,0,NULL,0),(10701,90,'2026-10-29',3,0,0,NULL,0),(10702,90,'2026-10-30',3,0,0,NULL,0),(10703,90,'2026-10-31',3,0,0,NULL,0),(10704,90,'2026-11-01',3,0,0,NULL,0),(10705,90,'2026-11-02',3,0,0,NULL,0),(10706,90,'2026-11-03',3,0,0,NULL,0),(10707,90,'2026-11-04',3,0,0,NULL,0),(10708,90,'2026-11-05',3,0,0,NULL,0),(10709,90,'2026-11-06',3,0,0,NULL,0),(10710,90,'2026-11-07',3,0,0,NULL,0),(10711,90,'2026-11-08',3,0,0,NULL,0),(10712,90,'2026-11-09',3,0,0,NULL,0),(10713,90,'2026-11-10',3,0,0,NULL,0),(10714,90,'2026-11-11',3,0,0,NULL,0),(10715,90,'2026-11-12',3,0,0,NULL,0),(10716,90,'2026-11-13',3,0,0,NULL,0),(10717,90,'2026-11-14',3,0,0,NULL,0),(10718,90,'2026-11-15',3,0,0,NULL,0),(10719,90,'2026-11-16',3,0,0,NULL,0),(10720,90,'2026-11-17',3,0,0,NULL,0),(10721,90,'2026-11-18',3,0,0,NULL,0),(10722,90,'2026-11-19',3,0,0,NULL,0),(10723,90,'2026-11-20',3,0,0,NULL,0),(10724,90,'2026-11-21',3,0,0,NULL,0),(10725,90,'2026-11-22',3,0,0,NULL,0),(10726,90,'2026-11-23',3,0,0,NULL,0),(10727,90,'2026-11-24',3,0,0,NULL,0),(10728,90,'2026-11-25',3,0,0,NULL,0),(10729,90,'2026-11-26',3,0,0,NULL,0),(10730,90,'2026-11-27',3,0,0,NULL,0),(10731,90,'2026-11-28',3,0,0,NULL,0),(10732,90,'2026-11-29',3,0,0,NULL,0),(10733,90,'2026-11-30',3,0,0,NULL,0),(10734,90,'2026-12-01',3,0,0,NULL,0),(10735,90,'2026-12-02',3,0,0,NULL,0),(10736,90,'2026-12-03',3,0,0,NULL,0),(10737,90,'2026-12-04',3,0,0,NULL,0),(10738,90,'2026-12-05',3,0,0,NULL,0),(10739,90,'2026-12-06',3,0,0,NULL,0),(10740,90,'2026-12-07',3,0,0,NULL,0),(10741,90,'2026-12-08',3,0,0,NULL,0),(10742,90,'2026-12-09',3,0,0,NULL,0),(10743,90,'2026-12-10',3,0,0,NULL,0),(10744,90,'2026-12-11',3,0,0,NULL,0),(10745,90,'2026-12-12',3,0,0,NULL,0),(10746,90,'2026-12-13',3,0,0,NULL,0),(10747,90,'2026-12-14',3,0,0,NULL,0),(10748,90,'2026-12-15',3,0,0,NULL,0),(10749,90,'2026-12-16',3,0,0,NULL,0),(10750,90,'2026-12-17',3,0,0,NULL,0),(10751,90,'2026-12-18',3,0,0,NULL,0),(10752,90,'2026-12-19',3,0,0,NULL,0),(10753,90,'2026-12-20',3,0,0,NULL,0),(10754,90,'2026-12-21',3,0,0,NULL,0),(10755,90,'2026-12-22',3,0,0,NULL,0),(10756,90,'2026-12-23',3,0,0,NULL,0),(10757,90,'2026-12-24',3,0,0,NULL,0),(10758,90,'2026-12-25',3,0,0,NULL,0),(10759,90,'2026-12-26',3,0,0,NULL,0),(10760,90,'2026-12-27',3,0,0,NULL,0),(10761,90,'2026-12-28',3,0,0,NULL,0),(10762,90,'2026-12-29',3,0,0,NULL,0),(10763,90,'2026-12-30',3,0,0,NULL,0),(10764,90,'2026-12-31',3,0,0,NULL,0),(10765,90,'2027-01-01',3,0,0,NULL,0),(10766,90,'2027-01-02',3,0,0,NULL,0),(10767,90,'2027-01-03',3,0,0,NULL,0),(10768,90,'2027-01-04',3,0,0,NULL,0),(10769,90,'2027-01-05',3,0,0,NULL,0),(10770,90,'2027-01-06',3,0,0,NULL,0),(10771,90,'2027-01-07',3,0,0,NULL,0),(10772,90,'2027-01-08',3,0,0,NULL,0),(10773,90,'2027-01-09',3,0,0,NULL,0),(10774,90,'2027-01-10',3,0,0,NULL,0),(10775,90,'2027-01-11',3,0,0,NULL,0),(10776,90,'2027-01-12',3,0,0,NULL,0),(10777,90,'2027-01-13',3,0,0,NULL,0),(10778,90,'2027-01-14',3,0,0,NULL,0),(10779,90,'2027-01-15',3,0,0,NULL,0),(10780,90,'2027-01-16',3,0,0,NULL,0),(10781,90,'2027-01-17',3,0,0,NULL,0),(10782,90,'2027-01-18',3,0,0,NULL,0),(10783,90,'2027-01-19',3,0,0,NULL,0),(10784,90,'2027-01-20',3,0,0,NULL,0),(10785,90,'2027-01-21',3,0,0,NULL,0),(10786,90,'2027-01-22',3,0,0,NULL,0),(10787,90,'2027-01-23',3,0,0,NULL,0),(10788,90,'2027-01-24',3,0,0,NULL,0),(10789,90,'2027-01-25',3,0,0,NULL,0),(10790,90,'2027-01-26',3,0,0,NULL,0),(10791,90,'2027-01-27',3,0,0,NULL,0),(10792,90,'2027-01-28',3,0,0,NULL,0),(10793,90,'2027-01-29',3,0,0,NULL,0),(10794,90,'2027-01-30',3,0,0,NULL,0),(10795,90,'2027-01-31',3,0,0,NULL,0),(10796,90,'2027-02-01',3,0,0,NULL,0),(10797,90,'2027-02-02',3,0,0,NULL,0),(10798,90,'2027-02-03',3,0,0,NULL,0),(10799,90,'2027-02-04',3,0,0,NULL,0),(10800,90,'2027-02-05',3,0,0,NULL,0),(10801,91,'2026-10-09',5,0,0,NULL,0),(10802,91,'2026-10-10',5,0,0,NULL,0),(10803,91,'2026-10-11',5,0,0,NULL,0),(10804,91,'2026-10-12',5,0,0,NULL,0),(10805,91,'2026-10-13',5,0,0,NULL,0),(10806,91,'2026-10-14',5,0,0,NULL,0),(10807,91,'2026-10-15',5,0,0,NULL,0),(10808,91,'2026-10-16',5,0,0,NULL,0),(10809,91,'2026-10-17',5,0,0,NULL,0),(10810,91,'2026-10-18',5,0,0,NULL,0),(10811,91,'2026-10-19',5,0,0,NULL,0),(10812,91,'2026-10-20',5,0,0,NULL,0),(10813,91,'2026-10-21',5,0,0,NULL,0),(10814,91,'2026-10-22',5,0,0,NULL,0),(10815,91,'2026-10-23',5,0,0,NULL,0),(10816,91,'2026-10-24',5,0,0,NULL,0),(10817,91,'2026-10-25',5,0,0,NULL,0),(10818,91,'2026-10-26',5,0,0,NULL,0),(10819,91,'2026-10-27',5,0,0,NULL,0),(10820,91,'2026-10-28',5,0,0,NULL,0),(10821,91,'2026-10-29',5,0,0,NULL,0),(10822,91,'2026-10-30',5,0,0,NULL,0),(10823,91,'2026-10-31',5,0,0,NULL,0),(10824,91,'2026-11-01',5,0,0,NULL,0),(10825,91,'2026-11-02',5,0,0,NULL,0),(10826,91,'2026-11-03',5,0,0,NULL,0),(10827,91,'2026-11-04',5,0,0,NULL,0),(10828,91,'2026-11-05',5,0,0,NULL,0),(10829,91,'2026-11-06',5,0,0,NULL,0),(10830,91,'2026-11-07',5,0,0,NULL,0),(10831,91,'2026-11-08',5,0,0,NULL,0),(10832,91,'2026-11-09',5,0,0,NULL,0),(10833,91,'2026-11-10',5,0,0,NULL,0),(10834,91,'2026-11-11',5,0,0,NULL,0),(10835,91,'2026-11-12',5,0,0,NULL,0),(10836,91,'2026-11-13',5,0,0,NULL,0),(10837,91,'2026-11-14',5,0,0,NULL,0),(10838,91,'2026-11-15',5,0,0,NULL,0),(10839,91,'2026-11-16',5,0,0,NULL,0),(10840,91,'2026-11-17',5,0,0,NULL,0),(10841,91,'2026-11-18',5,0,0,NULL,0),(10842,91,'2026-11-19',5,0,0,NULL,0),(10843,91,'2026-11-20',5,0,0,NULL,0),(10844,91,'2026-11-21',5,0,0,NULL,0),(10845,91,'2026-11-22',5,0,0,NULL,0),(10846,91,'2026-11-23',5,0,0,NULL,0),(10847,91,'2026-11-24',5,0,0,NULL,0),(10848,91,'2026-11-25',5,0,0,NULL,0),(10849,91,'2026-11-26',5,0,0,NULL,0),(10850,91,'2026-11-27',5,0,0,NULL,0),(10851,91,'2026-11-28',5,0,0,NULL,0),(10852,91,'2026-11-29',5,0,0,NULL,0),(10853,91,'2026-11-30',5,0,0,NULL,0),(10854,91,'2026-12-01',5,0,0,NULL,0),(10855,91,'2026-12-02',5,0,0,NULL,0),(10856,91,'2026-12-03',5,0,0,NULL,0),(10857,91,'2026-12-04',5,0,0,NULL,0),(10858,91,'2026-12-05',5,0,0,NULL,0),(10859,91,'2026-12-06',5,0,0,NULL,0),(10860,91,'2026-12-07',5,0,0,NULL,0),(10861,91,'2026-12-08',5,0,0,NULL,0),(10862,91,'2026-12-09',5,0,0,NULL,0),(10863,91,'2026-12-10',5,0,0,NULL,0),(10864,91,'2026-12-11',5,0,0,NULL,0),(10865,91,'2026-12-12',5,0,0,NULL,0),(10866,91,'2026-12-13',5,0,0,NULL,0),(10867,91,'2026-12-14',5,0,0,NULL,0),(10868,91,'2026-12-15',5,0,0,NULL,0),(10869,91,'2026-12-16',5,0,0,NULL,0),(10870,91,'2026-12-17',5,0,0,NULL,0),(10871,91,'2026-12-18',5,0,0,NULL,0),(10872,91,'2026-12-19',5,0,0,NULL,0),(10873,91,'2026-12-20',5,0,0,NULL,0),(10874,91,'2026-12-21',5,0,0,NULL,0),(10875,91,'2026-12-22',5,0,0,NULL,0),(10876,91,'2026-12-23',5,0,0,NULL,0),(10877,91,'2026-12-24',5,0,0,NULL,0),(10878,91,'2026-12-25',5,0,0,NULL,0),(10879,91,'2026-12-26',5,0,0,NULL,0),(10880,91,'2026-12-27',5,0,0,NULL,0),(10881,91,'2026-12-28',5,0,0,NULL,0),(10882,91,'2026-12-29',5,0,0,NULL,0),(10883,91,'2026-12-30',5,0,0,NULL,0),(10884,91,'2026-12-31',5,0,0,NULL,0),(10885,91,'2027-01-01',5,0,0,NULL,0),(10886,91,'2027-01-02',5,0,0,NULL,0),(10887,91,'2027-01-03',5,0,0,NULL,0),(10888,91,'2027-01-04',5,0,0,NULL,0),(10889,91,'2027-01-05',5,0,0,NULL,0),(10890,91,'2027-01-06',5,0,0,NULL,0),(10891,91,'2027-01-07',5,0,0,NULL,0),(10892,91,'2027-01-08',5,0,0,NULL,0),(10893,91,'2027-01-09',5,0,0,NULL,0),(10894,91,'2027-01-10',5,0,0,NULL,0),(10895,91,'2027-01-11',5,0,0,NULL,0),(10896,91,'2027-01-12',5,0,0,NULL,0),(10897,91,'2027-01-13',5,0,0,NULL,0),(10898,91,'2027-01-14',5,0,0,NULL,0),(10899,91,'2027-01-15',5,0,0,NULL,0),(10900,91,'2027-01-16',5,0,0,NULL,0),(10901,91,'2027-01-17',5,0,0,NULL,0),(10902,91,'2027-01-18',5,0,0,NULL,0),(10903,91,'2027-01-19',5,0,0,NULL,0),(10904,91,'2027-01-20',5,0,0,NULL,0),(10905,91,'2027-01-21',5,0,0,NULL,0),(10906,91,'2027-01-22',5,0,0,NULL,0),(10907,91,'2027-01-23',5,0,0,NULL,0),(10908,91,'2027-01-24',5,0,0,NULL,0),(10909,91,'2027-01-25',5,0,0,NULL,0),(10910,91,'2027-01-26',5,0,0,NULL,0),(10911,91,'2027-01-27',5,0,0,NULL,0),(10912,91,'2027-01-28',5,0,0,NULL,0),(10913,91,'2027-01-29',5,0,0,NULL,0),(10914,91,'2027-01-30',5,0,0,NULL,0),(10915,91,'2027-01-31',5,0,0,NULL,0),(10916,91,'2027-02-01',5,0,0,NULL,0),(10917,91,'2027-02-02',5,0,0,NULL,0),(10918,91,'2027-02-03',5,0,0,NULL,0),(10919,91,'2027-02-04',5,0,0,NULL,0),(10920,91,'2027-02-05',5,0,0,NULL,0),(10921,92,'2026-10-09',2,0,0,NULL,0),(10922,92,'2026-10-10',2,0,0,NULL,0),(10923,92,'2026-10-11',2,0,0,NULL,0),(10924,92,'2026-10-12',2,0,0,NULL,0),(10925,92,'2026-10-13',2,0,0,NULL,0),(10926,92,'2026-10-14',2,0,0,NULL,0),(10927,92,'2026-10-15',2,0,0,NULL,0),(10928,92,'2026-10-16',2,0,0,NULL,0),(10929,92,'2026-10-17',2,0,0,NULL,0),(10930,92,'2026-10-18',2,0,0,NULL,0),(10931,92,'2026-10-19',2,0,0,NULL,0),(10932,92,'2026-10-20',2,0,0,NULL,0),(10933,92,'2026-10-21',2,0,0,NULL,0),(10934,92,'2026-10-22',2,0,0,NULL,0),(10935,92,'2026-10-23',2,0,0,NULL,0),(10936,92,'2026-10-24',2,0,0,NULL,0),(10937,92,'2026-10-25',2,0,0,NULL,0),(10938,92,'2026-10-26',2,0,0,NULL,0),(10939,92,'2026-10-27',2,0,0,NULL,0),(10940,92,'2026-10-28',2,0,0,NULL,0),(10941,92,'2026-10-29',2,0,0,NULL,0),(10942,92,'2026-10-30',2,0,0,NULL,0),(10943,92,'2026-10-31',2,0,0,NULL,0),(10944,92,'2026-11-01',2,0,0,NULL,0),(10945,92,'2026-11-02',2,0,0,NULL,0),(10946,92,'2026-11-03',2,0,0,NULL,0),(10947,92,'2026-11-04',2,0,0,NULL,0),(10948,92,'2026-11-05',2,0,0,NULL,0),(10949,92,'2026-11-06',2,0,0,NULL,0),(10950,92,'2026-11-07',2,0,0,NULL,0),(10951,92,'2026-11-08',2,0,0,NULL,0),(10952,92,'2026-11-09',2,0,0,NULL,0),(10953,92,'2026-11-10',2,0,0,NULL,0),(10954,92,'2026-11-11',2,0,0,NULL,0),(10955,92,'2026-11-12',2,0,0,NULL,0),(10956,92,'2026-11-13',2,0,0,NULL,0),(10957,92,'2026-11-14',2,0,0,NULL,0),(10958,92,'2026-11-15',2,0,0,NULL,0),(10959,92,'2026-11-16',2,0,0,NULL,0),(10960,92,'2026-11-17',2,0,0,NULL,0),(10961,92,'2026-11-18',2,0,0,NULL,0),(10962,92,'2026-11-19',2,0,0,NULL,0),(10963,92,'2026-11-20',2,0,0,NULL,0),(10964,92,'2026-11-21',2,0,0,NULL,0),(10965,92,'2026-11-22',2,0,0,NULL,0),(10966,92,'2026-11-23',2,0,0,NULL,0),(10967,92,'2026-11-24',2,0,0,NULL,0),(10968,92,'2026-11-25',2,0,0,NULL,0),(10969,92,'2026-11-26',2,0,0,NULL,0),(10970,92,'2026-11-27',2,0,0,NULL,0),(10971,92,'2026-11-28',2,0,0,NULL,0),(10972,92,'2026-11-29',2,0,0,NULL,0),(10973,92,'2026-11-30',2,0,0,NULL,0),(10974,92,'2026-12-01',2,0,0,NULL,0),(10975,92,'2026-12-02',2,0,0,NULL,0),(10976,92,'2026-12-03',2,0,0,NULL,0),(10977,92,'2026-12-04',2,0,0,NULL,0),(10978,92,'2026-12-05',2,0,0,NULL,0),(10979,92,'2026-12-06',2,0,0,NULL,0),(10980,92,'2026-12-07',2,0,0,NULL,0),(10981,92,'2026-12-08',2,0,0,NULL,0),(10982,92,'2026-12-09',2,0,0,NULL,0),(10983,92,'2026-12-10',2,0,0,NULL,0),(10984,92,'2026-12-11',2,0,0,NULL,0),(10985,92,'2026-12-12',2,0,0,NULL,0),(10986,92,'2026-12-13',2,0,0,NULL,0),(10987,92,'2026-12-14',2,0,0,NULL,0),(10988,92,'2026-12-15',2,0,0,NULL,0),(10989,92,'2026-12-16',2,0,0,NULL,0),(10990,92,'2026-12-17',2,0,0,NULL,0),(10991,92,'2026-12-18',2,0,0,NULL,0),(10992,92,'2026-12-19',2,0,0,NULL,0),(10993,92,'2026-12-20',2,0,0,NULL,0),(10994,92,'2026-12-21',2,0,0,NULL,0),(10995,92,'2026-12-22',2,0,0,NULL,0),(10996,92,'2026-12-23',2,0,0,NULL,0),(10997,92,'2026-12-24',2,0,0,NULL,0),(10998,92,'2026-12-25',2,0,0,NULL,0),(10999,92,'2026-12-26',2,0,0,NULL,0),(11000,92,'2026-12-27',2,0,0,NULL,0),(11001,92,'2026-12-28',2,0,0,NULL,0),(11002,92,'2026-12-29',2,0,0,NULL,0),(11003,92,'2026-12-30',2,0,0,NULL,0),(11004,92,'2026-12-31',2,0,0,NULL,0),(11005,92,'2027-01-01',2,0,0,NULL,0),(11006,92,'2027-01-02',2,0,0,NULL,0),(11007,92,'2027-01-03',2,0,0,NULL,0),(11008,92,'2027-01-04',2,0,0,NULL,0),(11009,92,'2027-01-05',2,0,0,NULL,0),(11010,92,'2027-01-06',2,0,0,NULL,0),(11011,92,'2027-01-07',2,0,0,NULL,0),(11012,92,'2027-01-08',2,0,0,NULL,0),(11013,92,'2027-01-09',2,0,0,NULL,0),(11014,92,'2027-01-10',2,0,0,NULL,0),(11015,92,'2027-01-11',2,0,0,NULL,0),(11016,92,'2027-01-12',2,0,0,NULL,0),(11017,92,'2027-01-13',2,0,0,NULL,0),(11018,92,'2027-01-14',2,0,0,NULL,0),(11019,92,'2027-01-15',2,0,0,NULL,0),(11020,92,'2027-01-16',2,0,0,NULL,0),(11021,92,'2027-01-17',2,0,0,NULL,0),(11022,92,'2027-01-18',2,0,0,NULL,0),(11023,92,'2027-01-19',2,0,0,NULL,0),(11024,92,'2027-01-20',2,0,0,NULL,0),(11025,92,'2027-01-21',2,0,0,NULL,0),(11026,92,'2027-01-22',2,0,0,NULL,0),(11027,92,'2027-01-23',2,0,0,NULL,0),(11028,92,'2027-01-24',2,0,0,NULL,0),(11029,92,'2027-01-25',2,0,0,NULL,0),(11030,92,'2027-01-26',2,0,0,NULL,0),(11031,92,'2027-01-27',2,0,0,NULL,0),(11032,92,'2027-01-28',2,0,0,NULL,0),(11033,92,'2027-01-29',2,0,0,NULL,0),(11034,92,'2027-01-30',2,0,0,NULL,0),(11035,92,'2027-01-31',2,0,0,NULL,0),(11036,92,'2027-02-01',2,0,0,NULL,0),(11037,92,'2027-02-02',2,0,0,NULL,0),(11038,92,'2027-02-03',2,0,0,NULL,0),(11039,92,'2027-02-04',2,0,0,NULL,0),(11040,92,'2027-02-05',2,0,0,NULL,0),(11041,93,'2026-10-09',6,0,0,NULL,0),(11042,93,'2026-10-10',6,0,0,NULL,0),(11043,93,'2026-10-11',6,0,0,NULL,0),(11044,93,'2026-10-12',6,0,0,NULL,0),(11045,93,'2026-10-13',6,0,0,NULL,0),(11046,93,'2026-10-14',6,0,0,NULL,0),(11047,93,'2026-10-15',6,0,0,NULL,0),(11048,93,'2026-10-16',6,0,0,NULL,0),(11049,93,'2026-10-17',6,0,0,NULL,0),(11050,93,'2026-10-18',6,0,0,NULL,0),(11051,93,'2026-10-19',6,0,0,NULL,0),(11052,93,'2026-10-20',6,0,0,NULL,0),(11053,93,'2026-10-21',6,0,0,NULL,0),(11054,93,'2026-10-22',6,0,0,NULL,0),(11055,93,'2026-10-23',6,0,0,NULL,0),(11056,93,'2026-10-24',6,0,0,NULL,0),(11057,93,'2026-10-25',6,0,0,NULL,0),(11058,93,'2026-10-26',6,0,0,NULL,0),(11059,93,'2026-10-27',6,0,0,NULL,0),(11060,93,'2026-10-28',6,0,0,NULL,0),(11061,93,'2026-10-29',6,0,0,NULL,0),(11062,93,'2026-10-30',6,0,0,NULL,0),(11063,93,'2026-10-31',6,0,0,NULL,0),(11064,93,'2026-11-01',6,0,0,NULL,0),(11065,93,'2026-11-02',6,0,0,NULL,0),(11066,93,'2026-11-03',6,0,0,NULL,0),(11067,93,'2026-11-04',6,0,0,NULL,0),(11068,93,'2026-11-05',6,0,0,NULL,0),(11069,93,'2026-11-06',6,0,0,NULL,0),(11070,93,'2026-11-07',6,0,0,NULL,0),(11071,93,'2026-11-08',6,0,0,NULL,0),(11072,93,'2026-11-09',6,0,0,NULL,0),(11073,93,'2026-11-10',6,0,0,NULL,0),(11074,93,'2026-11-11',6,0,0,NULL,0),(11075,93,'2026-11-12',6,0,0,NULL,0),(11076,93,'2026-11-13',6,0,0,NULL,0),(11077,93,'2026-11-14',6,0,0,NULL,0),(11078,93,'2026-11-15',6,0,0,NULL,0),(11079,93,'2026-11-16',6,0,0,NULL,0),(11080,93,'2026-11-17',6,0,0,NULL,0),(11081,93,'2026-11-18',6,0,0,NULL,0),(11082,93,'2026-11-19',6,0,0,NULL,0),(11083,93,'2026-11-20',6,0,0,NULL,0),(11084,93,'2026-11-21',6,0,0,NULL,0),(11085,93,'2026-11-22',6,0,0,NULL,0),(11086,93,'2026-11-23',6,0,0,NULL,0),(11087,93,'2026-11-24',6,0,0,NULL,0),(11088,93,'2026-11-25',6,0,0,NULL,0),(11089,93,'2026-11-26',6,0,0,NULL,0),(11090,93,'2026-11-27',6,0,0,NULL,0),(11091,93,'2026-11-28',6,0,0,NULL,0),(11092,93,'2026-11-29',6,0,0,NULL,0),(11093,93,'2026-11-30',6,0,0,NULL,0),(11094,93,'2026-12-01',6,0,0,NULL,0),(11095,93,'2026-12-02',6,0,0,NULL,0),(11096,93,'2026-12-03',6,0,0,NULL,0),(11097,93,'2026-12-04',6,0,0,NULL,0),(11098,93,'2026-12-05',6,0,0,NULL,0),(11099,93,'2026-12-06',6,0,0,NULL,0),(11100,93,'2026-12-07',6,0,0,NULL,0),(11101,93,'2026-12-08',6,0,0,NULL,0),(11102,93,'2026-12-09',6,0,0,NULL,0),(11103,93,'2026-12-10',6,0,0,NULL,0),(11104,93,'2026-12-11',6,0,0,NULL,0),(11105,93,'2026-12-12',6,0,0,NULL,0),(11106,93,'2026-12-13',6,0,0,NULL,0),(11107,93,'2026-12-14',6,0,0,NULL,0),(11108,93,'2026-12-15',6,0,0,NULL,0),(11109,93,'2026-12-16',6,0,0,NULL,0),(11110,93,'2026-12-17',6,0,0,NULL,0),(11111,93,'2026-12-18',6,0,0,NULL,0),(11112,93,'2026-12-19',6,0,0,NULL,0),(11113,93,'2026-12-20',6,0,0,NULL,0),(11114,93,'2026-12-21',6,0,0,NULL,0),(11115,93,'2026-12-22',6,0,0,NULL,0),(11116,93,'2026-12-23',6,0,0,NULL,0),(11117,93,'2026-12-24',6,0,0,NULL,0),(11118,93,'2026-12-25',6,0,0,NULL,0),(11119,93,'2026-12-26',6,0,0,NULL,0),(11120,93,'2026-12-27',6,0,0,NULL,0),(11121,93,'2026-12-28',6,0,0,NULL,0),(11122,93,'2026-12-29',6,0,0,NULL,0),(11123,93,'2026-12-30',6,0,0,NULL,0),(11124,93,'2026-12-31',6,0,0,NULL,0),(11125,93,'2027-01-01',6,0,0,NULL,0),(11126,93,'2027-01-02',6,0,0,NULL,0),(11127,93,'2027-01-03',6,0,0,NULL,0),(11128,93,'2027-01-04',6,0,0,NULL,0),(11129,93,'2027-01-05',6,0,0,NULL,0),(11130,93,'2027-01-06',6,0,0,NULL,0),(11131,93,'2027-01-07',6,0,0,NULL,0),(11132,93,'2027-01-08',6,0,0,NULL,0),(11133,93,'2027-01-09',6,0,0,NULL,0),(11134,93,'2027-01-10',6,0,0,NULL,0),(11135,93,'2027-01-11',6,0,0,NULL,0),(11136,93,'2027-01-12',6,0,0,NULL,0),(11137,93,'2027-01-13',6,0,0,NULL,0),(11138,93,'2027-01-14',6,0,0,NULL,0),(11139,93,'2027-01-15',6,0,0,NULL,0),(11140,93,'2027-01-16',6,0,0,NULL,0),(11141,93,'2027-01-17',6,0,0,NULL,0),(11142,93,'2027-01-18',6,0,0,NULL,0),(11143,93,'2027-01-19',6,0,0,NULL,0),(11144,93,'2027-01-20',6,0,0,NULL,0),(11145,93,'2027-01-21',6,0,0,NULL,0),(11146,93,'2027-01-22',6,0,0,NULL,0),(11147,93,'2027-01-23',6,0,0,NULL,0),(11148,93,'2027-01-24',6,0,0,NULL,0),(11149,93,'2027-01-25',6,0,0,NULL,0),(11150,93,'2027-01-26',6,0,0,NULL,0),(11151,93,'2027-01-27',6,0,0,NULL,0),(11152,93,'2027-01-28',6,0,0,NULL,0),(11153,93,'2027-01-29',6,0,0,NULL,0),(11154,93,'2027-01-30',6,0,0,NULL,0),(11155,93,'2027-01-31',6,0,0,NULL,0),(11156,93,'2027-02-01',6,0,0,NULL,0),(11157,93,'2027-02-02',6,0,0,NULL,0),(11158,93,'2027-02-03',6,0,0,NULL,0),(11159,93,'2027-02-04',6,0,0,NULL,0),(11160,93,'2027-02-05',6,0,0,NULL,0),(11161,94,'2026-10-09',4,0,0,NULL,0),(11162,94,'2026-10-10',4,0,0,NULL,0),(11163,94,'2026-10-11',4,0,0,NULL,0),(11164,94,'2026-10-12',4,0,0,NULL,0),(11165,94,'2026-10-13',4,0,0,NULL,0),(11166,94,'2026-10-14',4,0,0,NULL,0),(11167,94,'2026-10-15',4,0,0,NULL,0),(11168,94,'2026-10-16',4,0,0,NULL,0),(11169,94,'2026-10-17',4,0,0,NULL,0),(11170,94,'2026-10-18',4,0,0,NULL,0),(11171,94,'2026-10-19',4,0,0,NULL,0),(11172,94,'2026-10-20',4,0,0,NULL,0),(11173,94,'2026-10-21',4,0,0,NULL,0),(11174,94,'2026-10-22',4,0,0,NULL,0),(11175,94,'2026-10-23',4,0,0,NULL,0),(11176,94,'2026-10-24',4,0,0,NULL,0),(11177,94,'2026-10-25',4,0,0,NULL,0),(11178,94,'2026-10-26',4,0,0,NULL,0),(11179,94,'2026-10-27',4,0,0,NULL,0),(11180,94,'2026-10-28',4,0,0,NULL,0),(11181,94,'2026-10-29',4,0,0,NULL,0),(11182,94,'2026-10-30',4,0,0,NULL,0),(11183,94,'2026-10-31',4,0,0,NULL,0),(11184,94,'2026-11-01',4,0,0,NULL,0),(11185,94,'2026-11-02',4,0,0,NULL,0),(11186,94,'2026-11-03',4,0,0,NULL,0),(11187,94,'2026-11-04',4,0,0,NULL,0),(11188,94,'2026-11-05',4,0,0,NULL,0),(11189,94,'2026-11-06',4,0,0,NULL,0),(11190,94,'2026-11-07',4,0,0,NULL,0),(11191,94,'2026-11-08',4,0,0,NULL,0),(11192,94,'2026-11-09',4,0,0,NULL,0),(11193,94,'2026-11-10',4,0,0,NULL,0),(11194,94,'2026-11-11',4,0,0,NULL,0),(11195,94,'2026-11-12',4,0,0,NULL,0),(11196,94,'2026-11-13',4,0,0,NULL,0),(11197,94,'2026-11-14',4,0,0,NULL,0),(11198,94,'2026-11-15',4,0,0,NULL,0),(11199,94,'2026-11-16',4,0,0,NULL,0),(11200,94,'2026-11-17',4,0,0,NULL,0),(11201,94,'2026-11-18',4,0,0,NULL,0),(11202,94,'2026-11-19',4,0,0,NULL,0),(11203,94,'2026-11-20',4,0,0,NULL,0),(11204,94,'2026-11-21',4,0,0,NULL,0),(11205,94,'2026-11-22',4,0,0,NULL,0),(11206,94,'2026-11-23',4,0,0,NULL,0),(11207,94,'2026-11-24',4,0,0,NULL,0),(11208,94,'2026-11-25',4,0,0,NULL,0),(11209,94,'2026-11-26',4,0,0,NULL,0),(11210,94,'2026-11-27',4,0,0,NULL,0),(11211,94,'2026-11-28',4,0,0,NULL,0),(11212,94,'2026-11-29',4,0,0,NULL,0),(11213,94,'2026-11-30',4,0,0,NULL,0),(11214,94,'2026-12-01',4,0,0,NULL,0),(11215,94,'2026-12-02',4,0,0,NULL,0),(11216,94,'2026-12-03',4,0,0,NULL,0),(11217,94,'2026-12-04',4,0,0,NULL,0),(11218,94,'2026-12-05',4,0,0,NULL,0),(11219,94,'2026-12-06',4,0,0,NULL,0),(11220,94,'2026-12-07',4,0,0,NULL,0),(11221,94,'2026-12-08',4,0,0,NULL,0),(11222,94,'2026-12-09',4,0,0,NULL,0),(11223,94,'2026-12-10',4,0,0,NULL,0),(11224,94,'2026-12-11',4,0,0,NULL,0),(11225,94,'2026-12-12',4,0,0,NULL,0),(11226,94,'2026-12-13',4,0,0,NULL,0),(11227,94,'2026-12-14',4,0,0,NULL,0),(11228,94,'2026-12-15',4,0,0,NULL,0),(11229,94,'2026-12-16',4,0,0,NULL,0),(11230,94,'2026-12-17',4,0,0,NULL,0),(11231,94,'2026-12-18',4,0,0,NULL,0),(11232,94,'2026-12-19',4,0,0,NULL,0),(11233,94,'2026-12-20',4,0,0,NULL,0),(11234,94,'2026-12-21',4,0,0,NULL,0),(11235,94,'2026-12-22',4,0,0,NULL,0),(11236,94,'2026-12-23',4,0,0,NULL,0),(11237,94,'2026-12-24',4,0,0,NULL,0),(11238,94,'2026-12-25',4,0,0,NULL,0),(11239,94,'2026-12-26',4,0,0,NULL,0),(11240,94,'2026-12-27',4,0,0,NULL,0),(11241,94,'2026-12-28',4,0,0,NULL,0),(11242,94,'2026-12-29',4,0,0,NULL,0),(11243,94,'2026-12-30',4,0,0,NULL,0),(11244,94,'2026-12-31',4,0,0,NULL,0),(11245,94,'2027-01-01',4,0,0,NULL,0),(11246,94,'2027-01-02',4,0,0,NULL,0),(11247,94,'2027-01-03',4,0,0,NULL,0),(11248,94,'2027-01-04',4,0,0,NULL,0),(11249,94,'2027-01-05',4,0,0,NULL,0),(11250,94,'2027-01-06',4,0,0,NULL,0),(11251,94,'2027-01-07',4,0,0,NULL,0),(11252,94,'2027-01-08',4,0,0,NULL,0),(11253,94,'2027-01-09',4,0,0,NULL,0),(11254,94,'2027-01-10',4,0,0,NULL,0),(11255,94,'2027-01-11',4,0,0,NULL,0),(11256,94,'2027-01-12',4,0,0,NULL,0),(11257,94,'2027-01-13',4,0,0,NULL,0),(11258,94,'2027-01-14',4,0,0,NULL,0),(11259,94,'2027-01-15',4,0,0,NULL,0),(11260,94,'2027-01-16',4,0,0,NULL,0),(11261,94,'2027-01-17',4,0,0,NULL,0),(11262,94,'2027-01-18',4,0,0,NULL,0),(11263,94,'2027-01-19',4,0,0,NULL,0),(11264,94,'2027-01-20',4,0,0,NULL,0),(11265,94,'2027-01-21',4,0,0,NULL,0),(11266,94,'2027-01-22',4,0,0,NULL,0),(11267,94,'2027-01-23',4,0,0,NULL,0),(11268,94,'2027-01-24',4,0,0,NULL,0),(11269,94,'2027-01-25',4,0,0,NULL,0),(11270,94,'2027-01-26',4,0,0,NULL,0),(11271,94,'2027-01-27',4,0,0,NULL,0),(11272,94,'2027-01-28',4,0,0,NULL,0),(11273,94,'2027-01-29',4,0,0,NULL,0),(11274,94,'2027-01-30',4,0,0,NULL,0),(11275,94,'2027-01-31',4,0,0,NULL,0),(11276,94,'2027-02-01',4,0,0,NULL,0),(11277,94,'2027-02-02',4,0,0,NULL,0),(11278,94,'2027-02-03',4,0,0,NULL,0),(11279,94,'2027-02-04',4,0,0,NULL,0),(11280,94,'2027-02-05',4,0,0,NULL,0),(11281,95,'2026-10-09',5,0,0,NULL,0),(11282,95,'2026-10-10',5,0,0,NULL,0),(11283,95,'2026-10-11',5,0,0,NULL,0),(11284,95,'2026-10-12',5,0,0,NULL,0),(11285,95,'2026-10-13',5,0,0,NULL,0),(11286,95,'2026-10-14',5,0,0,NULL,0),(11287,95,'2026-10-15',5,0,0,NULL,0),(11288,95,'2026-10-16',5,0,0,NULL,0),(11289,95,'2026-10-17',5,0,0,NULL,0),(11290,95,'2026-10-18',5,0,0,NULL,0),(11291,95,'2026-10-19',5,0,0,NULL,0),(11292,95,'2026-10-20',5,0,0,NULL,0),(11293,95,'2026-10-21',5,0,0,NULL,0),(11294,95,'2026-10-22',5,0,0,NULL,0),(11295,95,'2026-10-23',5,0,0,NULL,0),(11296,95,'2026-10-24',5,0,0,NULL,0),(11297,95,'2026-10-25',5,0,0,NULL,0),(11298,95,'2026-10-26',5,0,0,NULL,0),(11299,95,'2026-10-27',5,0,0,NULL,0),(11300,95,'2026-10-28',5,0,0,NULL,0),(11301,95,'2026-10-29',5,0,0,NULL,0),(11302,95,'2026-10-30',5,0,0,NULL,0),(11303,95,'2026-10-31',5,0,0,NULL,0),(11304,95,'2026-11-01',5,0,0,NULL,0),(11305,95,'2026-11-02',5,0,0,NULL,0),(11306,95,'2026-11-03',5,0,0,NULL,0),(11307,95,'2026-11-04',5,0,0,NULL,0),(11308,95,'2026-11-05',5,0,0,NULL,0),(11309,95,'2026-11-06',5,0,0,NULL,0),(11310,95,'2026-11-07',5,0,0,NULL,0),(11311,95,'2026-11-08',5,0,0,NULL,0),(11312,95,'2026-11-09',5,0,0,NULL,0),(11313,95,'2026-11-10',5,0,0,NULL,0),(11314,95,'2026-11-11',5,0,0,NULL,0),(11315,95,'2026-11-12',5,0,0,NULL,0),(11316,95,'2026-11-13',5,0,0,NULL,0),(11317,95,'2026-11-14',5,0,0,NULL,0),(11318,95,'2026-11-15',5,0,0,NULL,0),(11319,95,'2026-11-16',5,0,0,NULL,0),(11320,95,'2026-11-17',5,0,0,NULL,0),(11321,95,'2026-11-18',5,0,0,NULL,0),(11322,95,'2026-11-19',5,0,0,NULL,0),(11323,95,'2026-11-20',5,0,0,NULL,0),(11324,95,'2026-11-21',5,0,0,NULL,0),(11325,95,'2026-11-22',5,0,0,NULL,0),(11326,95,'2026-11-23',5,0,0,NULL,0),(11327,95,'2026-11-24',5,0,0,NULL,0),(11328,95,'2026-11-25',5,0,0,NULL,0),(11329,95,'2026-11-26',5,0,0,NULL,0),(11330,95,'2026-11-27',5,0,0,NULL,0),(11331,95,'2026-11-28',5,0,0,NULL,0),(11332,95,'2026-11-29',5,0,0,NULL,0),(11333,95,'2026-11-30',5,0,0,NULL,0),(11334,95,'2026-12-01',5,0,0,NULL,0),(11335,95,'2026-12-02',5,0,0,NULL,0),(11336,95,'2026-12-03',5,0,0,NULL,0),(11337,95,'2026-12-04',5,0,0,NULL,0),(11338,95,'2026-12-05',5,0,0,NULL,0),(11339,95,'2026-12-06',5,0,0,NULL,0),(11340,95,'2026-12-07',5,0,0,NULL,0),(11341,95,'2026-12-08',5,0,0,NULL,0),(11342,95,'2026-12-09',5,0,0,NULL,0),(11343,95,'2026-12-10',5,0,0,NULL,0),(11344,95,'2026-12-11',5,0,0,NULL,0),(11345,95,'2026-12-12',5,0,0,NULL,0),(11346,95,'2026-12-13',5,0,0,NULL,0),(11347,95,'2026-12-14',5,0,0,NULL,0),(11348,95,'2026-12-15',5,0,0,NULL,0),(11349,95,'2026-12-16',5,0,0,NULL,0),(11350,95,'2026-12-17',5,0,0,NULL,0),(11351,95,'2026-12-18',5,0,0,NULL,0),(11352,95,'2026-12-19',5,0,0,NULL,0),(11353,95,'2026-12-20',5,0,0,NULL,0),(11354,95,'2026-12-21',5,0,0,NULL,0),(11355,95,'2026-12-22',5,0,0,NULL,0),(11356,95,'2026-12-23',5,0,0,NULL,0),(11357,95,'2026-12-24',5,0,0,NULL,0),(11358,95,'2026-12-25',5,0,0,NULL,0),(11359,95,'2026-12-26',5,0,0,NULL,0),(11360,95,'2026-12-27',5,0,0,NULL,0),(11361,95,'2026-12-28',5,0,0,NULL,0),(11362,95,'2026-12-29',5,0,0,NULL,0),(11363,95,'2026-12-30',5,0,0,NULL,0),(11364,95,'2026-12-31',5,0,0,NULL,0),(11365,95,'2027-01-01',5,0,0,NULL,0),(11366,95,'2027-01-02',5,0,0,NULL,0),(11367,95,'2027-01-03',5,0,0,NULL,0),(11368,95,'2027-01-04',5,0,0,NULL,0),(11369,95,'2027-01-05',5,0,0,NULL,0),(11370,95,'2027-01-06',5,0,0,NULL,0),(11371,95,'2027-01-07',5,0,0,NULL,0),(11372,95,'2027-01-08',5,0,0,NULL,0),(11373,95,'2027-01-09',5,0,0,NULL,0),(11374,95,'2027-01-10',5,0,0,NULL,0),(11375,95,'2027-01-11',5,0,0,NULL,0),(11376,95,'2027-01-12',5,0,0,NULL,0),(11377,95,'2027-01-13',5,0,0,NULL,0),(11378,95,'2027-01-14',5,0,0,NULL,0),(11379,95,'2027-01-15',5,0,0,NULL,0),(11380,95,'2027-01-16',5,0,0,NULL,0),(11381,95,'2027-01-17',5,0,0,NULL,0),(11382,95,'2027-01-18',5,0,0,NULL,0),(11383,95,'2027-01-19',5,0,0,NULL,0),(11384,95,'2027-01-20',5,0,0,NULL,0),(11385,95,'2027-01-21',5,0,0,NULL,0),(11386,95,'2027-01-22',5,0,0,NULL,0),(11387,95,'2027-01-23',5,0,0,NULL,0),(11388,95,'2027-01-24',5,0,0,NULL,0),(11389,95,'2027-01-25',5,0,0,NULL,0),(11390,95,'2027-01-26',5,0,0,NULL,0),(11391,95,'2027-01-27',5,0,0,NULL,0),(11392,95,'2027-01-28',5,0,0,NULL,0),(11393,95,'2027-01-29',5,0,0,NULL,0),(11394,95,'2027-01-30',5,0,0,NULL,0),(11395,95,'2027-01-31',5,0,0,NULL,0),(11396,95,'2027-02-01',5,0,0,NULL,0),(11397,95,'2027-02-02',5,0,0,NULL,0),(11398,95,'2027-02-03',5,0,0,NULL,0),(11399,95,'2027-02-04',5,0,0,NULL,0),(11400,95,'2027-02-05',5,0,0,NULL,0),(11401,96,'2026-10-09',3,0,0,NULL,0),(11402,96,'2026-10-10',3,0,0,NULL,0),(11403,96,'2026-10-11',3,0,0,NULL,0),(11404,96,'2026-10-12',3,0,0,NULL,0),(11405,96,'2026-10-13',3,0,0,NULL,0),(11406,96,'2026-10-14',3,0,0,NULL,0),(11407,96,'2026-10-15',3,0,0,NULL,0),(11408,96,'2026-10-16',3,0,0,NULL,0),(11409,96,'2026-10-17',3,0,0,NULL,0),(11410,96,'2026-10-18',3,0,0,NULL,0),(11411,96,'2026-10-19',3,0,0,NULL,0),(11412,96,'2026-10-20',3,0,0,NULL,0),(11413,96,'2026-10-21',3,0,0,NULL,0),(11414,96,'2026-10-22',3,0,0,NULL,0),(11415,96,'2026-10-23',3,0,0,NULL,0),(11416,96,'2026-10-24',3,0,0,NULL,0),(11417,96,'2026-10-25',3,0,0,NULL,0),(11418,96,'2026-10-26',3,0,0,NULL,0),(11419,96,'2026-10-27',3,0,0,NULL,0),(11420,96,'2026-10-28',3,0,0,NULL,0),(11421,96,'2026-10-29',3,0,0,NULL,0),(11422,96,'2026-10-30',3,0,0,NULL,0),(11423,96,'2026-10-31',3,0,0,NULL,0),(11424,96,'2026-11-01',3,0,0,NULL,0),(11425,96,'2026-11-02',3,0,0,NULL,0),(11426,96,'2026-11-03',3,0,0,NULL,0),(11427,96,'2026-11-04',3,0,0,NULL,0),(11428,96,'2026-11-05',3,0,0,NULL,0),(11429,96,'2026-11-06',3,0,0,NULL,0),(11430,96,'2026-11-07',3,0,0,NULL,0),(11431,96,'2026-11-08',3,0,0,NULL,0),(11432,96,'2026-11-09',3,0,0,NULL,0),(11433,96,'2026-11-10',3,0,0,NULL,0),(11434,96,'2026-11-11',3,0,0,NULL,0),(11435,96,'2026-11-12',3,0,0,NULL,0),(11436,96,'2026-11-13',3,0,0,NULL,0),(11437,96,'2026-11-14',3,0,0,NULL,0),(11438,96,'2026-11-15',3,0,0,NULL,0),(11439,96,'2026-11-16',3,0,0,NULL,0),(11440,96,'2026-11-17',3,0,0,NULL,0),(11441,96,'2026-11-18',3,0,0,NULL,0),(11442,96,'2026-11-19',3,0,0,NULL,0),(11443,96,'2026-11-20',3,0,0,NULL,0),(11444,96,'2026-11-21',3,0,0,NULL,0),(11445,96,'2026-11-22',3,0,0,NULL,0),(11446,96,'2026-11-23',3,0,0,NULL,0),(11447,96,'2026-11-24',3,0,0,NULL,0),(11448,96,'2026-11-25',3,0,0,NULL,0),(11449,96,'2026-11-26',3,0,0,NULL,0),(11450,96,'2026-11-27',3,0,0,NULL,0),(11451,96,'2026-11-28',3,0,0,NULL,0),(11452,96,'2026-11-29',3,0,0,NULL,0),(11453,96,'2026-11-30',3,0,0,NULL,0),(11454,96,'2026-12-01',3,0,0,NULL,0),(11455,96,'2026-12-02',3,0,0,NULL,0),(11456,96,'2026-12-03',3,0,0,NULL,0),(11457,96,'2026-12-04',3,0,0,NULL,0),(11458,96,'2026-12-05',3,0,0,NULL,0),(11459,96,'2026-12-06',3,0,0,NULL,0),(11460,96,'2026-12-07',3,0,0,NULL,0),(11461,96,'2026-12-08',3,0,0,NULL,0),(11462,96,'2026-12-09',3,0,0,NULL,0),(11463,96,'2026-12-10',3,0,0,NULL,0),(11464,96,'2026-12-11',3,0,0,NULL,0),(11465,96,'2026-12-12',3,0,0,NULL,0),(11466,96,'2026-12-13',3,0,0,NULL,0),(11467,96,'2026-12-14',3,0,0,NULL,0),(11468,96,'2026-12-15',3,0,0,NULL,0),(11469,96,'2026-12-16',3,0,0,NULL,0),(11470,96,'2026-12-17',3,0,0,NULL,0),(11471,96,'2026-12-18',3,0,0,NULL,0),(11472,96,'2026-12-19',3,0,0,NULL,0),(11473,96,'2026-12-20',3,0,0,NULL,0),(11474,96,'2026-12-21',3,0,0,NULL,0),(11475,96,'2026-12-22',3,0,0,NULL,0),(11476,96,'2026-12-23',3,0,0,NULL,0),(11477,96,'2026-12-24',3,0,0,NULL,0),(11478,96,'2026-12-25',3,0,0,NULL,0),(11479,96,'2026-12-26',3,0,0,NULL,0),(11480,96,'2026-12-27',3,0,0,NULL,0),(11481,96,'2026-12-28',3,0,0,NULL,0),(11482,96,'2026-12-29',3,0,0,NULL,0),(11483,96,'2026-12-30',3,0,0,NULL,0),(11484,96,'2026-12-31',3,0,0,NULL,0),(11485,96,'2027-01-01',3,0,0,NULL,0),(11486,96,'2027-01-02',3,0,0,NULL,0),(11487,96,'2027-01-03',3,0,0,NULL,0),(11488,96,'2027-01-04',3,0,0,NULL,0),(11489,96,'2027-01-05',3,0,0,NULL,0),(11490,96,'2027-01-06',3,0,0,NULL,0),(11491,96,'2027-01-07',3,0,0,NULL,0),(11492,96,'2027-01-08',3,0,0,NULL,0),(11493,96,'2027-01-09',3,0,0,NULL,0),(11494,96,'2027-01-10',3,0,0,NULL,0),(11495,96,'2027-01-11',3,0,0,NULL,0),(11496,96,'2027-01-12',3,0,0,NULL,0),(11497,96,'2027-01-13',3,0,0,NULL,0),(11498,96,'2027-01-14',3,0,0,NULL,0),(11499,96,'2027-01-15',3,0,0,NULL,0),(11500,96,'2027-01-16',3,0,0,NULL,0),(11501,96,'2027-01-17',3,0,0,NULL,0),(11502,96,'2027-01-18',3,0,0,NULL,0),(11503,96,'2027-01-19',3,0,0,NULL,0),(11504,96,'2027-01-20',3,0,0,NULL,0),(11505,96,'2027-01-21',3,0,0,NULL,0),(11506,96,'2027-01-22',3,0,0,NULL,0),(11507,96,'2027-01-23',3,0,0,NULL,0),(11508,96,'2027-01-24',3,0,0,NULL,0),(11509,96,'2027-01-25',3,0,0,NULL,0),(11510,96,'2027-01-26',3,0,0,NULL,0),(11511,96,'2027-01-27',3,0,0,NULL,0),(11512,96,'2027-01-28',3,0,0,NULL,0),(11513,96,'2027-01-29',3,0,0,NULL,0),(11514,96,'2027-01-30',3,0,0,NULL,0),(11515,96,'2027-01-31',3,0,0,NULL,0),(11516,96,'2027-02-01',3,0,0,NULL,0),(11517,96,'2027-02-02',3,0,0,NULL,0),(11518,96,'2027-02-03',3,0,0,NULL,0),(11519,96,'2027-02-04',3,0,0,NULL,0),(11520,96,'2027-02-05',3,0,0,NULL,0),(11521,97,'2026-10-09',8,0,0,NULL,0),(11522,97,'2026-10-10',8,0,0,NULL,0),(11523,97,'2026-10-11',8,0,0,NULL,0),(11524,97,'2026-10-12',8,0,0,NULL,0),(11525,97,'2026-10-13',8,0,0,NULL,0),(11526,97,'2026-10-14',8,0,0,NULL,0),(11527,97,'2026-10-15',8,0,0,NULL,0),(11528,97,'2026-10-16',8,0,0,NULL,0),(11529,97,'2026-10-17',8,0,0,NULL,0),(11530,97,'2026-10-18',8,0,0,NULL,0),(11531,97,'2026-10-19',8,0,0,NULL,0),(11532,97,'2026-10-20',8,0,0,NULL,0),(11533,97,'2026-10-21',8,0,0,NULL,0),(11534,97,'2026-10-22',8,0,0,NULL,0),(11535,97,'2026-10-23',8,0,0,NULL,0),(11536,97,'2026-10-24',8,0,0,NULL,0),(11537,97,'2026-10-25',8,0,0,NULL,0),(11538,97,'2026-10-26',8,0,0,NULL,0),(11539,97,'2026-10-27',8,0,0,NULL,0),(11540,97,'2026-10-28',8,0,0,NULL,0),(11541,97,'2026-10-29',8,0,0,NULL,0),(11542,97,'2026-10-30',8,0,0,NULL,0),(11543,97,'2026-10-31',8,0,0,NULL,0),(11544,97,'2026-11-01',8,0,0,NULL,0),(11545,97,'2026-11-02',8,0,0,NULL,0),(11546,97,'2026-11-03',8,0,0,NULL,0),(11547,97,'2026-11-04',8,0,0,NULL,0),(11548,97,'2026-11-05',8,0,0,NULL,0),(11549,97,'2026-11-06',8,0,0,NULL,0),(11550,97,'2026-11-07',8,0,0,NULL,0),(11551,97,'2026-11-08',8,0,0,NULL,0),(11552,97,'2026-11-09',8,0,0,NULL,0),(11553,97,'2026-11-10',8,0,0,NULL,0),(11554,97,'2026-11-11',8,0,0,NULL,0),(11555,97,'2026-11-12',8,0,0,NULL,0),(11556,97,'2026-11-13',8,0,0,NULL,0),(11557,97,'2026-11-14',8,0,0,NULL,0),(11558,97,'2026-11-15',8,0,0,NULL,0),(11559,97,'2026-11-16',8,0,0,NULL,0),(11560,97,'2026-11-17',8,0,0,NULL,0),(11561,97,'2026-11-18',8,0,0,NULL,0),(11562,97,'2026-11-19',8,0,0,NULL,0),(11563,97,'2026-11-20',8,0,0,NULL,0),(11564,97,'2026-11-21',8,0,0,NULL,0),(11565,97,'2026-11-22',8,0,0,NULL,0),(11566,97,'2026-11-23',8,0,0,NULL,0),(11567,97,'2026-11-24',8,0,0,NULL,0),(11568,97,'2026-11-25',8,0,0,NULL,0),(11569,97,'2026-11-26',8,0,0,NULL,0),(11570,97,'2026-11-27',8,0,0,NULL,0),(11571,97,'2026-11-28',8,0,0,NULL,0),(11572,97,'2026-11-29',8,0,0,NULL,0),(11573,97,'2026-11-30',8,0,0,NULL,0),(11574,97,'2026-12-01',8,0,0,NULL,0),(11575,97,'2026-12-02',8,0,0,NULL,0),(11576,97,'2026-12-03',8,0,0,NULL,0),(11577,97,'2026-12-04',8,0,0,NULL,0),(11578,97,'2026-12-05',8,0,0,NULL,0),(11579,97,'2026-12-06',8,0,0,NULL,0),(11580,97,'2026-12-07',8,0,0,NULL,0),(11581,97,'2026-12-08',8,0,0,NULL,0),(11582,97,'2026-12-09',8,0,0,NULL,0),(11583,97,'2026-12-10',8,0,0,NULL,0),(11584,97,'2026-12-11',8,0,0,NULL,0),(11585,97,'2026-12-12',8,0,0,NULL,0),(11586,97,'2026-12-13',8,0,0,NULL,0),(11587,97,'2026-12-14',8,0,0,NULL,0),(11588,97,'2026-12-15',8,0,0,NULL,0),(11589,97,'2026-12-16',8,0,0,NULL,0),(11590,97,'2026-12-17',8,0,0,NULL,0),(11591,97,'2026-12-18',8,0,0,NULL,0),(11592,97,'2026-12-19',8,0,0,NULL,0),(11593,97,'2026-12-20',8,0,0,NULL,0),(11594,97,'2026-12-21',8,0,0,NULL,0),(11595,97,'2026-12-22',8,0,0,NULL,0),(11596,97,'2026-12-23',8,0,0,NULL,0),(11597,97,'2026-12-24',8,0,0,NULL,0),(11598,97,'2026-12-25',8,0,0,NULL,0),(11599,97,'2026-12-26',8,0,0,NULL,0),(11600,97,'2026-12-27',8,0,0,NULL,0),(11601,97,'2026-12-28',8,0,0,NULL,0),(11602,97,'2026-12-29',8,0,0,NULL,0),(11603,97,'2026-12-30',8,0,0,NULL,0),(11604,97,'2026-12-31',8,0,0,NULL,0),(11605,97,'2027-01-01',8,0,0,NULL,0),(11606,97,'2027-01-02',8,0,0,NULL,0),(11607,97,'2027-01-03',8,0,0,NULL,0),(11608,97,'2027-01-04',8,0,0,NULL,0),(11609,97,'2027-01-05',8,0,0,NULL,0),(11610,97,'2027-01-06',8,0,0,NULL,0),(11611,97,'2027-01-07',8,0,0,NULL,0),(11612,97,'2027-01-08',8,0,0,NULL,0),(11613,97,'2027-01-09',8,0,0,NULL,0),(11614,97,'2027-01-10',8,0,0,NULL,0),(11615,97,'2027-01-11',8,0,0,NULL,0),(11616,97,'2027-01-12',8,0,0,NULL,0),(11617,97,'2027-01-13',8,0,0,NULL,0),(11618,97,'2027-01-14',8,0,0,NULL,0),(11619,97,'2027-01-15',8,0,0,NULL,0),(11620,97,'2027-01-16',8,0,0,NULL,0),(11621,97,'2027-01-17',8,0,0,NULL,0),(11622,97,'2027-01-18',8,0,0,NULL,0),(11623,97,'2027-01-19',8,0,0,NULL,0),(11624,97,'2027-01-20',8,0,0,NULL,0),(11625,97,'2027-01-21',8,0,0,NULL,0),(11626,97,'2027-01-22',8,0,0,NULL,0),(11627,97,'2027-01-23',8,0,0,NULL,0),(11628,97,'2027-01-24',8,0,0,NULL,0),(11629,97,'2027-01-25',8,0,0,NULL,0),(11630,97,'2027-01-26',8,0,0,NULL,0),(11631,97,'2027-01-27',8,0,0,NULL,0),(11632,97,'2027-01-28',8,0,0,NULL,0),(11633,97,'2027-01-29',8,0,0,NULL,0),(11634,97,'2027-01-30',8,0,0,NULL,0),(11635,97,'2027-01-31',8,0,0,NULL,0),(11636,97,'2027-02-01',8,0,0,NULL,0),(11637,97,'2027-02-02',8,0,0,NULL,0),(11638,97,'2027-02-03',8,0,0,NULL,0),(11639,97,'2027-02-04',8,0,0,NULL,0),(11640,97,'2027-02-05',8,0,0,NULL,0),(11641,98,'2026-10-09',4,0,0,NULL,0),(11642,98,'2026-10-10',4,0,0,NULL,0),(11643,98,'2026-10-11',4,0,0,NULL,0),(11644,98,'2026-10-12',4,0,0,NULL,0),(11645,98,'2026-10-13',4,0,0,NULL,0),(11646,98,'2026-10-14',4,0,0,NULL,0),(11647,98,'2026-10-15',4,0,0,NULL,0),(11648,98,'2026-10-16',4,0,0,NULL,0),(11649,98,'2026-10-17',4,0,0,NULL,0),(11650,98,'2026-10-18',4,0,0,NULL,0),(11651,98,'2026-10-19',4,0,0,NULL,0),(11652,98,'2026-10-20',4,0,0,NULL,0),(11653,98,'2026-10-21',4,0,0,NULL,0),(11654,98,'2026-10-22',4,0,0,NULL,0),(11655,98,'2026-10-23',4,0,0,NULL,0),(11656,98,'2026-10-24',4,0,0,NULL,0),(11657,98,'2026-10-25',4,0,0,NULL,0),(11658,98,'2026-10-26',4,0,0,NULL,0),(11659,98,'2026-10-27',4,0,0,NULL,0),(11660,98,'2026-10-28',4,0,0,NULL,0),(11661,98,'2026-10-29',4,0,0,NULL,0),(11662,98,'2026-10-30',4,0,0,NULL,0),(11663,98,'2026-10-31',4,0,0,NULL,0),(11664,98,'2026-11-01',4,0,0,NULL,0),(11665,98,'2026-11-02',4,0,0,NULL,0),(11666,98,'2026-11-03',4,0,0,NULL,0),(11667,98,'2026-11-04',4,0,0,NULL,0),(11668,98,'2026-11-05',4,0,0,NULL,0),(11669,98,'2026-11-06',4,0,0,NULL,0),(11670,98,'2026-11-07',4,0,0,NULL,0),(11671,98,'2026-11-08',4,0,0,NULL,0),(11672,98,'2026-11-09',4,0,0,NULL,0),(11673,98,'2026-11-10',4,0,0,NULL,0),(11674,98,'2026-11-11',4,0,0,NULL,0),(11675,98,'2026-11-12',4,0,0,NULL,0),(11676,98,'2026-11-13',4,0,0,NULL,0),(11677,98,'2026-11-14',4,0,0,NULL,0),(11678,98,'2026-11-15',4,0,0,NULL,0),(11679,98,'2026-11-16',4,0,0,NULL,0),(11680,98,'2026-11-17',4,0,0,NULL,0),(11681,98,'2026-11-18',4,0,0,NULL,0),(11682,98,'2026-11-19',4,0,0,NULL,0),(11683,98,'2026-11-20',4,0,0,NULL,0),(11684,98,'2026-11-21',4,0,0,NULL,0),(11685,98,'2026-11-22',4,0,0,NULL,0),(11686,98,'2026-11-23',4,0,0,NULL,0),(11687,98,'2026-11-24',4,0,0,NULL,0),(11688,98,'2026-11-25',4,0,0,NULL,0),(11689,98,'2026-11-26',4,0,0,NULL,0),(11690,98,'2026-11-27',4,0,0,NULL,0),(11691,98,'2026-11-28',4,0,0,NULL,0),(11692,98,'2026-11-29',4,0,0,NULL,0),(11693,98,'2026-11-30',4,0,0,NULL,0),(11694,98,'2026-12-01',4,0,0,NULL,0),(11695,98,'2026-12-02',4,0,0,NULL,0),(11696,98,'2026-12-03',4,0,0,NULL,0),(11697,98,'2026-12-04',4,0,0,NULL,0),(11698,98,'2026-12-05',4,0,0,NULL,0),(11699,98,'2026-12-06',4,0,0,NULL,0),(11700,98,'2026-12-07',4,0,0,NULL,0),(11701,98,'2026-12-08',4,0,0,NULL,0),(11702,98,'2026-12-09',4,0,0,NULL,0),(11703,98,'2026-12-10',4,0,0,NULL,0),(11704,98,'2026-12-11',4,0,0,NULL,0),(11705,98,'2026-12-12',4,0,0,NULL,0),(11706,98,'2026-12-13',4,0,0,NULL,0),(11707,98,'2026-12-14',4,0,0,NULL,0),(11708,98,'2026-12-15',4,0,0,NULL,0),(11709,98,'2026-12-16',4,0,0,NULL,0),(11710,98,'2026-12-17',4,0,0,NULL,0),(11711,98,'2026-12-18',4,0,0,NULL,0),(11712,98,'2026-12-19',4,0,0,NULL,0),(11713,98,'2026-12-20',4,0,0,NULL,0),(11714,98,'2026-12-21',4,0,0,NULL,0),(11715,98,'2026-12-22',4,0,0,NULL,0),(11716,98,'2026-12-23',4,0,0,NULL,0),(11717,98,'2026-12-24',4,0,0,NULL,0),(11718,98,'2026-12-25',4,0,0,NULL,0),(11719,98,'2026-12-26',4,0,0,NULL,0),(11720,98,'2026-12-27',4,0,0,NULL,0),(11721,98,'2026-12-28',4,0,0,NULL,0),(11722,98,'2026-12-29',4,0,0,NULL,0),(11723,98,'2026-12-30',4,0,0,NULL,0),(11724,98,'2026-12-31',4,0,0,NULL,0),(11725,98,'2027-01-01',4,0,0,NULL,0),(11726,98,'2027-01-02',4,0,0,NULL,0),(11727,98,'2027-01-03',4,0,0,NULL,0),(11728,98,'2027-01-04',4,0,0,NULL,0),(11729,98,'2027-01-05',4,0,0,NULL,0),(11730,98,'2027-01-06',4,0,0,NULL,0),(11731,98,'2027-01-07',4,0,0,NULL,0),(11732,98,'2027-01-08',4,0,0,NULL,0),(11733,98,'2027-01-09',4,0,0,NULL,0),(11734,98,'2027-01-10',4,0,0,NULL,0),(11735,98,'2027-01-11',4,0,0,NULL,0),(11736,98,'2027-01-12',4,0,0,NULL,0),(11737,98,'2027-01-13',4,0,0,NULL,0),(11738,98,'2027-01-14',4,0,0,NULL,0),(11739,98,'2027-01-15',4,0,0,NULL,0),(11740,98,'2027-01-16',4,0,0,NULL,0),(11741,98,'2027-01-17',4,0,0,NULL,0),(11742,98,'2027-01-18',4,0,0,NULL,0),(11743,98,'2027-01-19',4,0,0,NULL,0),(11744,98,'2027-01-20',4,0,0,NULL,0),(11745,98,'2027-01-21',4,0,0,NULL,0),(11746,98,'2027-01-22',4,0,0,NULL,0),(11747,98,'2027-01-23',4,0,0,NULL,0),(11748,98,'2027-01-24',4,0,0,NULL,0),(11749,98,'2027-01-25',4,0,0,NULL,0),(11750,98,'2027-01-26',4,0,0,NULL,0),(11751,98,'2027-01-27',4,0,0,NULL,0),(11752,98,'2027-01-28',4,0,0,NULL,0),(11753,98,'2027-01-29',4,0,0,NULL,0),(11754,98,'2027-01-30',4,0,0,NULL,0),(11755,98,'2027-01-31',4,0,0,NULL,0),(11756,98,'2027-02-01',4,0,0,NULL,0),(11757,98,'2027-02-02',4,0,0,NULL,0),(11758,98,'2027-02-03',4,0,0,NULL,0),(11759,98,'2027-02-04',4,0,0,NULL,0),(11760,98,'2027-02-05',4,0,0,NULL,0),(11761,99,'2026-10-09',5,0,0,NULL,0),(11762,99,'2026-10-10',5,0,0,NULL,0),(11763,99,'2026-10-11',5,0,0,NULL,0),(11764,99,'2026-10-12',5,0,0,NULL,0),(11765,99,'2026-10-13',5,0,0,NULL,0),(11766,99,'2026-10-14',5,0,0,NULL,0),(11767,99,'2026-10-15',5,0,0,NULL,0),(11768,99,'2026-10-16',5,0,0,NULL,0),(11769,99,'2026-10-17',5,0,0,NULL,0),(11770,99,'2026-10-18',5,0,0,NULL,0),(11771,99,'2026-10-19',5,0,0,NULL,0),(11772,99,'2026-10-20',5,0,0,NULL,0),(11773,99,'2026-10-21',5,0,0,NULL,0),(11774,99,'2026-10-22',5,0,0,NULL,0),(11775,99,'2026-10-23',5,0,0,NULL,0),(11776,99,'2026-10-24',5,0,0,NULL,0),(11777,99,'2026-10-25',5,0,0,NULL,0),(11778,99,'2026-10-26',5,0,0,NULL,0),(11779,99,'2026-10-27',5,0,0,NULL,0),(11780,99,'2026-10-28',5,0,0,NULL,0),(11781,99,'2026-10-29',5,0,0,NULL,0),(11782,99,'2026-10-30',5,0,0,NULL,0),(11783,99,'2026-10-31',5,0,0,NULL,0),(11784,99,'2026-11-01',5,0,0,NULL,0),(11785,99,'2026-11-02',5,0,0,NULL,0),(11786,99,'2026-11-03',5,0,0,NULL,0),(11787,99,'2026-11-04',5,0,0,NULL,0),(11788,99,'2026-11-05',5,0,0,NULL,0),(11789,99,'2026-11-06',5,0,0,NULL,0),(11790,99,'2026-11-07',5,0,0,NULL,0),(11791,99,'2026-11-08',5,0,0,NULL,0),(11792,99,'2026-11-09',5,0,0,NULL,0),(11793,99,'2026-11-10',5,0,0,NULL,0),(11794,99,'2026-11-11',5,0,0,NULL,0),(11795,99,'2026-11-12',5,0,0,NULL,0),(11796,99,'2026-11-13',5,0,0,NULL,0),(11797,99,'2026-11-14',5,0,0,NULL,0),(11798,99,'2026-11-15',5,0,0,NULL,0),(11799,99,'2026-11-16',5,0,0,NULL,0),(11800,99,'2026-11-17',5,0,0,NULL,0),(11801,99,'2026-11-18',5,0,0,NULL,0),(11802,99,'2026-11-19',5,0,0,NULL,0),(11803,99,'2026-11-20',5,0,0,NULL,0),(11804,99,'2026-11-21',5,0,0,NULL,0),(11805,99,'2026-11-22',5,0,0,NULL,0),(11806,99,'2026-11-23',5,0,0,NULL,0),(11807,99,'2026-11-24',5,0,0,NULL,0),(11808,99,'2026-11-25',5,0,0,NULL,0),(11809,99,'2026-11-26',5,0,0,NULL,0),(11810,99,'2026-11-27',5,0,0,NULL,0),(11811,99,'2026-11-28',5,0,0,NULL,0),(11812,99,'2026-11-29',5,0,0,NULL,0),(11813,99,'2026-11-30',5,0,0,NULL,0),(11814,99,'2026-12-01',5,0,0,NULL,0),(11815,99,'2026-12-02',5,0,0,NULL,0),(11816,99,'2026-12-03',5,0,0,NULL,0),(11817,99,'2026-12-04',5,0,0,NULL,0),(11818,99,'2026-12-05',5,0,0,NULL,0),(11819,99,'2026-12-06',5,0,0,NULL,0),(11820,99,'2026-12-07',5,0,0,NULL,0),(11821,99,'2026-12-08',5,0,0,NULL,0),(11822,99,'2026-12-09',5,0,0,NULL,0),(11823,99,'2026-12-10',5,0,0,NULL,0),(11824,99,'2026-12-11',5,0,0,NULL,0),(11825,99,'2026-12-12',5,0,0,NULL,0),(11826,99,'2026-12-13',5,0,0,NULL,0),(11827,99,'2026-12-14',5,0,0,NULL,0),(11828,99,'2026-12-15',5,0,0,NULL,0),(11829,99,'2026-12-16',5,0,0,NULL,0),(11830,99,'2026-12-17',5,0,0,NULL,0),(11831,99,'2026-12-18',5,0,0,NULL,0),(11832,99,'2026-12-19',5,0,0,NULL,0),(11833,99,'2026-12-20',5,0,0,NULL,0),(11834,99,'2026-12-21',5,0,0,NULL,0),(11835,99,'2026-12-22',5,0,0,NULL,0),(11836,99,'2026-12-23',5,0,0,NULL,0),(11837,99,'2026-12-24',5,0,0,NULL,0),(11838,99,'2026-12-25',5,0,0,NULL,0),(11839,99,'2026-12-26',5,0,0,NULL,0),(11840,99,'2026-12-27',5,0,0,NULL,0),(11841,99,'2026-12-28',5,0,0,NULL,0),(11842,99,'2026-12-29',5,0,0,NULL,0),(11843,99,'2026-12-30',5,0,0,NULL,0),(11844,99,'2026-12-31',5,0,0,NULL,0),(11845,99,'2027-01-01',5,0,0,NULL,0),(11846,99,'2027-01-02',5,0,0,NULL,0),(11847,99,'2027-01-03',5,0,0,NULL,0),(11848,99,'2027-01-04',5,0,0,NULL,0),(11849,99,'2027-01-05',5,0,0,NULL,0),(11850,99,'2027-01-06',5,0,0,NULL,0),(11851,99,'2027-01-07',5,0,0,NULL,0),(11852,99,'2027-01-08',5,0,0,NULL,0),(11853,99,'2027-01-09',5,0,0,NULL,0),(11854,99,'2027-01-10',5,0,0,NULL,0),(11855,99,'2027-01-11',5,0,0,NULL,0),(11856,99,'2027-01-12',5,0,0,NULL,0),(11857,99,'2027-01-13',5,0,0,NULL,0),(11858,99,'2027-01-14',5,0,0,NULL,0),(11859,99,'2027-01-15',5,0,0,NULL,0),(11860,99,'2027-01-16',5,0,0,NULL,0),(11861,99,'2027-01-17',5,0,0,NULL,0),(11862,99,'2027-01-18',5,0,0,NULL,0),(11863,99,'2027-01-19',5,0,0,NULL,0),(11864,99,'2027-01-20',5,0,0,NULL,0),(11865,99,'2027-01-21',5,0,0,NULL,0),(11866,99,'2027-01-22',5,0,0,NULL,0),(11867,99,'2027-01-23',5,0,0,NULL,0),(11868,99,'2027-01-24',5,0,0,NULL,0),(11869,99,'2027-01-25',5,0,0,NULL,0),(11870,99,'2027-01-26',5,0,0,NULL,0),(11871,99,'2027-01-27',5,0,0,NULL,0),(11872,99,'2027-01-28',5,0,0,NULL,0),(11873,99,'2027-01-29',5,0,0,NULL,0),(11874,99,'2027-01-30',5,0,0,NULL,0),(11875,99,'2027-01-31',5,0,0,NULL,0),(11876,99,'2027-02-01',5,0,0,NULL,0),(11877,99,'2027-02-02',5,0,0,NULL,0),(11878,99,'2027-02-03',5,0,0,NULL,0),(11879,99,'2027-02-04',5,0,0,NULL,0),(11880,99,'2027-02-05',5,0,0,NULL,0),(11881,100,'2026-10-09',2,0,0,NULL,0),(11882,100,'2026-10-10',2,0,0,NULL,0),(11883,100,'2026-10-11',2,0,0,NULL,0),(11884,100,'2026-10-12',2,0,0,NULL,0),(11885,100,'2026-10-13',2,0,0,NULL,0),(11886,100,'2026-10-14',2,0,0,NULL,0),(11887,100,'2026-10-15',2,0,0,NULL,0),(11888,100,'2026-10-16',2,0,0,NULL,0),(11889,100,'2026-10-17',2,0,0,NULL,0),(11890,100,'2026-10-18',2,0,0,NULL,0),(11891,100,'2026-10-19',2,0,0,NULL,0),(11892,100,'2026-10-20',2,0,0,NULL,0),(11893,100,'2026-10-21',2,0,0,NULL,0),(11894,100,'2026-10-22',2,0,0,NULL,0),(11895,100,'2026-10-23',2,0,0,NULL,0),(11896,100,'2026-10-24',2,0,0,NULL,0),(11897,100,'2026-10-25',2,0,0,NULL,0),(11898,100,'2026-10-26',2,0,0,NULL,0),(11899,100,'2026-10-27',2,0,0,NULL,0),(11900,100,'2026-10-28',2,0,0,NULL,0),(11901,100,'2026-10-29',2,0,0,NULL,0),(11902,100,'2026-10-30',2,0,0,NULL,0),(11903,100,'2026-10-31',2,0,0,NULL,0),(11904,100,'2026-11-01',2,0,0,NULL,0),(11905,100,'2026-11-02',2,0,0,NULL,0),(11906,100,'2026-11-03',2,0,0,NULL,0),(11907,100,'2026-11-04',2,0,0,NULL,0),(11908,100,'2026-11-05',2,0,0,NULL,0),(11909,100,'2026-11-06',2,0,0,NULL,0),(11910,100,'2026-11-07',2,0,0,NULL,0),(11911,100,'2026-11-08',2,0,0,NULL,0),(11912,100,'2026-11-09',2,0,0,NULL,0),(11913,100,'2026-11-10',2,0,0,NULL,0),(11914,100,'2026-11-11',2,0,0,NULL,0),(11915,100,'2026-11-12',2,0,0,NULL,0),(11916,100,'2026-11-13',2,0,0,NULL,0),(11917,100,'2026-11-14',2,0,0,NULL,0),(11918,100,'2026-11-15',2,0,0,NULL,0),(11919,100,'2026-11-16',2,0,0,NULL,0),(11920,100,'2026-11-17',2,0,0,NULL,0),(11921,100,'2026-11-18',2,0,0,NULL,0),(11922,100,'2026-11-19',2,0,0,NULL,0),(11923,100,'2026-11-20',2,0,0,NULL,0),(11924,100,'2026-11-21',2,0,0,NULL,0),(11925,100,'2026-11-22',2,0,0,NULL,0),(11926,100,'2026-11-23',2,0,0,NULL,0),(11927,100,'2026-11-24',2,0,0,NULL,0),(11928,100,'2026-11-25',2,0,0,NULL,0),(11929,100,'2026-11-26',2,0,0,NULL,0),(11930,100,'2026-11-27',2,0,0,NULL,0),(11931,100,'2026-11-28',2,0,0,NULL,0),(11932,100,'2026-11-29',2,0,0,NULL,0),(11933,100,'2026-11-30',2,0,0,NULL,0),(11934,100,'2026-12-01',2,0,0,NULL,0),(11935,100,'2026-12-02',2,0,0,NULL,0),(11936,100,'2026-12-03',2,0,0,NULL,0),(11937,100,'2026-12-04',2,0,0,NULL,0),(11938,100,'2026-12-05',2,0,0,NULL,0),(11939,100,'2026-12-06',2,0,0,NULL,0),(11940,100,'2026-12-07',2,0,0,NULL,0),(11941,100,'2026-12-08',2,0,0,NULL,0),(11942,100,'2026-12-09',2,0,0,NULL,0),(11943,100,'2026-12-10',2,0,0,NULL,0),(11944,100,'2026-12-11',2,0,0,NULL,0),(11945,100,'2026-12-12',2,0,0,NULL,0),(11946,100,'2026-12-13',2,0,0,NULL,0),(11947,100,'2026-12-14',2,0,0,NULL,0),(11948,100,'2026-12-15',2,0,0,NULL,0),(11949,100,'2026-12-16',2,0,0,NULL,0),(11950,100,'2026-12-17',2,0,0,NULL,0),(11951,100,'2026-12-18',2,0,0,NULL,0),(11952,100,'2026-12-19',2,0,0,NULL,0),(11953,100,'2026-12-20',2,0,0,NULL,0),(11954,100,'2026-12-21',2,0,0,NULL,0),(11955,100,'2026-12-22',2,0,0,NULL,0),(11956,100,'2026-12-23',2,0,0,NULL,0),(11957,100,'2026-12-24',2,0,0,NULL,0),(11958,100,'2026-12-25',2,0,0,NULL,0),(11959,100,'2026-12-26',2,0,0,NULL,0),(11960,100,'2026-12-27',2,0,0,NULL,0),(11961,100,'2026-12-28',2,0,0,NULL,0),(11962,100,'2026-12-29',2,0,0,NULL,0),(11963,100,'2026-12-30',2,0,0,NULL,0),(11964,100,'2026-12-31',2,0,0,NULL,0),(11965,100,'2027-01-01',2,0,0,NULL,0),(11966,100,'2027-01-02',2,0,0,NULL,0),(11967,100,'2027-01-03',2,0,0,NULL,0),(11968,100,'2027-01-04',2,0,0,NULL,0),(11969,100,'2027-01-05',2,0,0,NULL,0),(11970,100,'2027-01-06',2,0,0,NULL,0),(11971,100,'2027-01-07',2,0,0,NULL,0),(11972,100,'2027-01-08',2,0,0,NULL,0),(11973,100,'2027-01-09',2,0,0,NULL,0),(11974,100,'2027-01-10',2,0,0,NULL,0),(11975,100,'2027-01-11',2,0,0,NULL,0),(11976,100,'2027-01-12',2,0,0,NULL,0),(11977,100,'2027-01-13',2,0,0,NULL,0),(11978,100,'2027-01-14',2,0,0,NULL,0),(11979,100,'2027-01-15',2,0,0,NULL,0),(11980,100,'2027-01-16',2,0,0,NULL,0),(11981,100,'2027-01-17',2,0,0,NULL,0),(11982,100,'2027-01-18',2,0,0,NULL,0),(11983,100,'2027-01-19',2,0,0,NULL,0),(11984,100,'2027-01-20',2,0,0,NULL,0),(11985,100,'2027-01-21',2,0,0,NULL,0),(11986,100,'2027-01-22',2,0,0,NULL,0),(11987,100,'2027-01-23',2,0,0,NULL,0),(11988,100,'2027-01-24',2,0,0,NULL,0),(11989,100,'2027-01-25',2,0,0,NULL,0),(11990,100,'2027-01-26',2,0,0,NULL,0),(11991,100,'2027-01-27',2,0,0,NULL,0),(11992,100,'2027-01-28',2,0,0,NULL,0),(11993,100,'2027-01-29',2,0,0,NULL,0),(11994,100,'2027-01-30',2,0,0,NULL,0),(11995,100,'2027-01-31',2,0,0,NULL,0),(11996,100,'2027-02-01',2,0,0,NULL,0),(11997,100,'2027-02-02',2,0,0,NULL,0),(11998,100,'2027-02-03',2,0,0,NULL,0),(11999,100,'2027-02-04',2,0,0,NULL,0),(12000,100,'2027-02-05',2,0,0,NULL,0),(12001,101,'2026-10-09',6,0,0,NULL,0),(12002,101,'2026-10-10',6,0,0,NULL,0),(12003,101,'2026-10-11',6,0,0,NULL,0),(12004,101,'2026-10-12',6,0,0,NULL,0),(12005,101,'2026-10-13',6,0,0,NULL,0),(12006,101,'2026-10-14',6,0,0,NULL,0),(12007,101,'2026-10-15',6,0,0,NULL,0),(12008,101,'2026-10-16',6,0,0,NULL,0),(12009,101,'2026-10-17',6,0,0,NULL,0),(12010,101,'2026-10-18',6,0,0,NULL,0),(12011,101,'2026-10-19',6,0,0,NULL,0),(12012,101,'2026-10-20',6,0,0,NULL,0),(12013,101,'2026-10-21',6,0,0,NULL,0),(12014,101,'2026-10-22',6,0,0,NULL,0),(12015,101,'2026-10-23',6,0,0,NULL,0),(12016,101,'2026-10-24',6,0,0,NULL,0),(12017,101,'2026-10-25',6,0,0,NULL,0),(12018,101,'2026-10-26',6,0,0,NULL,0),(12019,101,'2026-10-27',6,0,0,NULL,0),(12020,101,'2026-10-28',6,0,0,NULL,0),(12021,101,'2026-10-29',6,0,0,NULL,0),(12022,101,'2026-10-30',6,0,0,NULL,0),(12023,101,'2026-10-31',6,0,0,NULL,0),(12024,101,'2026-11-01',6,0,0,NULL,0),(12025,101,'2026-11-02',6,0,0,NULL,0),(12026,101,'2026-11-03',6,0,0,NULL,0),(12027,101,'2026-11-04',6,0,0,NULL,0),(12028,101,'2026-11-05',6,0,0,NULL,0),(12029,101,'2026-11-06',6,0,0,NULL,0),(12030,101,'2026-11-07',6,0,0,NULL,0),(12031,101,'2026-11-08',6,0,0,NULL,0),(12032,101,'2026-11-09',6,0,0,NULL,0),(12033,101,'2026-11-10',6,0,0,NULL,0),(12034,101,'2026-11-11',6,0,0,NULL,0),(12035,101,'2026-11-12',6,0,0,NULL,0),(12036,101,'2026-11-13',6,0,0,NULL,0),(12037,101,'2026-11-14',6,0,0,NULL,0),(12038,101,'2026-11-15',6,0,0,NULL,0),(12039,101,'2026-11-16',6,0,0,NULL,0),(12040,101,'2026-11-17',6,0,0,NULL,0),(12041,101,'2026-11-18',6,0,0,NULL,0),(12042,101,'2026-11-19',6,0,0,NULL,0),(12043,101,'2026-11-20',6,0,0,NULL,0),(12044,101,'2026-11-21',6,0,0,NULL,0),(12045,101,'2026-11-22',6,0,0,NULL,0),(12046,101,'2026-11-23',6,0,0,NULL,0),(12047,101,'2026-11-24',6,0,0,NULL,0),(12048,101,'2026-11-25',6,0,0,NULL,0),(12049,101,'2026-11-26',6,0,0,NULL,0),(12050,101,'2026-11-27',6,0,0,NULL,0),(12051,101,'2026-11-28',6,0,0,NULL,0),(12052,101,'2026-11-29',6,0,0,NULL,0),(12053,101,'2026-11-30',6,0,0,NULL,0),(12054,101,'2026-12-01',6,0,0,NULL,0),(12055,101,'2026-12-02',6,0,0,NULL,0),(12056,101,'2026-12-03',6,0,0,NULL,0),(12057,101,'2026-12-04',6,0,0,NULL,0),(12058,101,'2026-12-05',6,0,0,NULL,0),(12059,101,'2026-12-06',6,0,0,NULL,0),(12060,101,'2026-12-07',6,0,0,NULL,0),(12061,101,'2026-12-08',6,0,0,NULL,0),(12062,101,'2026-12-09',6,0,0,NULL,0),(12063,101,'2026-12-10',6,0,0,NULL,0),(12064,101,'2026-12-11',6,0,0,NULL,0),(12065,101,'2026-12-12',6,0,0,NULL,0),(12066,101,'2026-12-13',6,0,0,NULL,0),(12067,101,'2026-12-14',6,0,0,NULL,0),(12068,101,'2026-12-15',6,0,0,NULL,0),(12069,101,'2026-12-16',6,0,0,NULL,0),(12070,101,'2026-12-17',6,0,0,NULL,0),(12071,101,'2026-12-18',6,0,0,NULL,0),(12072,101,'2026-12-19',6,0,0,NULL,0),(12073,101,'2026-12-20',6,0,0,NULL,0),(12074,101,'2026-12-21',6,0,0,NULL,0),(12075,101,'2026-12-22',6,0,0,NULL,0),(12076,101,'2026-12-23',6,0,0,NULL,0),(12077,101,'2026-12-24',6,0,0,NULL,0),(12078,101,'2026-12-25',6,0,0,NULL,0),(12079,101,'2026-12-26',6,0,0,NULL,0),(12080,101,'2026-12-27',6,0,0,NULL,0),(12081,101,'2026-12-28',6,0,0,NULL,0),(12082,101,'2026-12-29',6,0,0,NULL,0),(12083,101,'2026-12-30',6,0,0,NULL,0),(12084,101,'2026-12-31',6,0,0,NULL,0),(12085,101,'2027-01-01',6,0,0,NULL,0),(12086,101,'2027-01-02',6,0,0,NULL,0),(12087,101,'2027-01-03',6,0,0,NULL,0),(12088,101,'2027-01-04',6,0,0,NULL,0),(12089,101,'2027-01-05',6,0,0,NULL,0),(12090,101,'2027-01-06',6,0,0,NULL,0),(12091,101,'2027-01-07',6,0,0,NULL,0),(12092,101,'2027-01-08',6,0,0,NULL,0),(12093,101,'2027-01-09',6,0,0,NULL,0),(12094,101,'2027-01-10',6,0,0,NULL,0),(12095,101,'2027-01-11',6,0,0,NULL,0),(12096,101,'2027-01-12',6,0,0,NULL,0),(12097,101,'2027-01-13',6,0,0,NULL,0),(12098,101,'2027-01-14',6,0,0,NULL,0),(12099,101,'2027-01-15',6,0,0,NULL,0),(12100,101,'2027-01-16',6,0,0,NULL,0),(12101,101,'2027-01-17',6,0,0,NULL,0),(12102,101,'2027-01-18',6,0,0,NULL,0),(12103,101,'2027-01-19',6,0,0,NULL,0),(12104,101,'2027-01-20',6,0,0,NULL,0),(12105,101,'2027-01-21',6,0,0,NULL,0),(12106,101,'2027-01-22',6,0,0,NULL,0),(12107,101,'2027-01-23',6,0,0,NULL,0),(12108,101,'2027-01-24',6,0,0,NULL,0),(12109,101,'2027-01-25',6,0,0,NULL,0),(12110,101,'2027-01-26',6,0,0,NULL,0),(12111,101,'2027-01-27',6,0,0,NULL,0),(12112,101,'2027-01-28',6,0,0,NULL,0),(12113,101,'2027-01-29',6,0,0,NULL,0),(12114,101,'2027-01-30',6,0,0,NULL,0),(12115,101,'2027-01-31',6,0,0,NULL,0),(12116,101,'2027-02-01',6,0,0,NULL,0),(12117,101,'2027-02-02',6,0,0,NULL,0),(12118,101,'2027-02-03',6,0,0,NULL,0),(12119,101,'2027-02-04',6,0,0,NULL,0),(12120,101,'2027-02-05',6,0,0,NULL,0),(12121,102,'2026-10-09',3,0,0,NULL,0),(12122,102,'2026-10-10',3,0,0,NULL,0),(12123,102,'2026-10-11',3,0,0,NULL,0),(12124,102,'2026-10-12',3,0,0,NULL,0),(12125,102,'2026-10-13',3,0,0,NULL,0),(12126,102,'2026-10-14',3,0,0,NULL,0),(12127,102,'2026-10-15',3,0,0,NULL,0),(12128,102,'2026-10-16',3,0,0,NULL,0),(12129,102,'2026-10-17',3,0,0,NULL,0),(12130,102,'2026-10-18',3,0,0,NULL,0),(12131,102,'2026-10-19',3,0,0,NULL,0),(12132,102,'2026-10-20',3,0,0,NULL,0),(12133,102,'2026-10-21',3,0,0,NULL,0),(12134,102,'2026-10-22',3,0,0,NULL,0),(12135,102,'2026-10-23',3,0,0,NULL,0),(12136,102,'2026-10-24',3,0,0,NULL,0),(12137,102,'2026-10-25',3,0,0,NULL,0),(12138,102,'2026-10-26',3,0,0,NULL,0),(12139,102,'2026-10-27',3,0,0,NULL,0),(12140,102,'2026-10-28',3,0,0,NULL,0),(12141,102,'2026-10-29',3,0,0,NULL,0),(12142,102,'2026-10-30',3,0,0,NULL,0),(12143,102,'2026-10-31',3,0,0,NULL,0),(12144,102,'2026-11-01',3,0,0,NULL,0),(12145,102,'2026-11-02',3,0,0,NULL,0),(12146,102,'2026-11-03',3,0,0,NULL,0),(12147,102,'2026-11-04',3,0,0,NULL,0),(12148,102,'2026-11-05',3,0,0,NULL,0),(12149,102,'2026-11-06',3,0,0,NULL,0),(12150,102,'2026-11-07',3,0,0,NULL,0),(12151,102,'2026-11-08',3,0,0,NULL,0),(12152,102,'2026-11-09',3,0,0,NULL,0),(12153,102,'2026-11-10',3,0,0,NULL,0),(12154,102,'2026-11-11',3,0,0,NULL,0),(12155,102,'2026-11-12',3,0,0,NULL,0),(12156,102,'2026-11-13',3,0,0,NULL,0),(12157,102,'2026-11-14',3,0,0,NULL,0),(12158,102,'2026-11-15',3,0,0,NULL,0),(12159,102,'2026-11-16',3,0,0,NULL,0),(12160,102,'2026-11-17',3,0,0,NULL,0),(12161,102,'2026-11-18',3,0,0,NULL,0),(12162,102,'2026-11-19',3,0,0,NULL,0),(12163,102,'2026-11-20',3,0,0,NULL,0),(12164,102,'2026-11-21',3,0,0,NULL,0),(12165,102,'2026-11-22',3,0,0,NULL,0),(12166,102,'2026-11-23',3,0,0,NULL,0),(12167,102,'2026-11-24',3,0,0,NULL,0),(12168,102,'2026-11-25',3,0,0,NULL,0),(12169,102,'2026-11-26',3,0,0,NULL,0),(12170,102,'2026-11-27',3,0,0,NULL,0),(12171,102,'2026-11-28',3,0,0,NULL,0),(12172,102,'2026-11-29',3,0,0,NULL,0),(12173,102,'2026-11-30',3,0,0,NULL,0),(12174,102,'2026-12-01',3,0,0,NULL,0),(12175,102,'2026-12-02',3,0,0,NULL,0),(12176,102,'2026-12-03',3,0,0,NULL,0),(12177,102,'2026-12-04',3,0,0,NULL,0),(12178,102,'2026-12-05',3,0,0,NULL,0),(12179,102,'2026-12-06',3,0,0,NULL,0),(12180,102,'2026-12-07',3,0,0,NULL,0),(12181,102,'2026-12-08',3,0,0,NULL,0),(12182,102,'2026-12-09',3,0,0,NULL,0),(12183,102,'2026-12-10',3,0,0,NULL,0),(12184,102,'2026-12-11',3,0,0,NULL,0),(12185,102,'2026-12-12',3,0,0,NULL,0),(12186,102,'2026-12-13',3,0,0,NULL,0),(12187,102,'2026-12-14',3,0,0,NULL,0),(12188,102,'2026-12-15',3,0,0,NULL,0),(12189,102,'2026-12-16',3,0,0,NULL,0),(12190,102,'2026-12-17',3,0,0,NULL,0),(12191,102,'2026-12-18',3,0,0,NULL,0),(12192,102,'2026-12-19',3,0,0,NULL,0),(12193,102,'2026-12-20',3,0,0,NULL,0),(12194,102,'2026-12-21',3,0,0,NULL,0),(12195,102,'2026-12-22',3,0,0,NULL,0),(12196,102,'2026-12-23',3,0,0,NULL,0),(12197,102,'2026-12-24',3,0,0,NULL,0),(12198,102,'2026-12-25',3,0,0,NULL,0),(12199,102,'2026-12-26',3,0,0,NULL,0),(12200,102,'2026-12-27',3,0,0,NULL,0),(12201,102,'2026-12-28',3,0,0,NULL,0),(12202,102,'2026-12-29',3,0,0,NULL,0),(12203,102,'2026-12-30',3,0,0,NULL,0),(12204,102,'2026-12-31',3,0,0,NULL,0),(12205,102,'2027-01-01',3,0,0,NULL,0),(12206,102,'2027-01-02',3,0,0,NULL,0),(12207,102,'2027-01-03',3,0,0,NULL,0),(12208,102,'2027-01-04',3,0,0,NULL,0),(12209,102,'2027-01-05',3,0,0,NULL,0),(12210,102,'2027-01-06',3,0,0,NULL,0),(12211,102,'2027-01-07',3,0,0,NULL,0),(12212,102,'2027-01-08',3,0,0,NULL,0),(12213,102,'2027-01-09',3,0,0,NULL,0),(12214,102,'2027-01-10',3,0,0,NULL,0),(12215,102,'2027-01-11',3,0,0,NULL,0),(12216,102,'2027-01-12',3,0,0,NULL,0),(12217,102,'2027-01-13',3,0,0,NULL,0),(12218,102,'2027-01-14',3,0,0,NULL,0),(12219,102,'2027-01-15',3,0,0,NULL,0),(12220,102,'2027-01-16',3,0,0,NULL,0),(12221,102,'2027-01-17',3,0,0,NULL,0),(12222,102,'2027-01-18',3,0,0,NULL,0),(12223,102,'2027-01-19',3,0,0,NULL,0),(12224,102,'2027-01-20',3,0,0,NULL,0),(12225,102,'2027-01-21',3,0,0,NULL,0),(12226,102,'2027-01-22',3,0,0,NULL,0),(12227,102,'2027-01-23',3,0,0,NULL,0),(12228,102,'2027-01-24',3,0,0,NULL,0),(12229,102,'2027-01-25',3,0,0,NULL,0),(12230,102,'2027-01-26',3,0,0,NULL,0),(12231,102,'2027-01-27',3,0,0,NULL,0),(12232,102,'2027-01-28',3,0,0,NULL,0),(12233,102,'2027-01-29',3,0,0,NULL,0),(12234,102,'2027-01-30',3,0,0,NULL,0),(12235,102,'2027-01-31',3,0,0,NULL,0),(12236,102,'2027-02-01',3,0,0,NULL,0),(12237,102,'2027-02-02',3,0,0,NULL,0),(12238,102,'2027-02-03',3,0,0,NULL,0),(12239,102,'2027-02-04',3,0,0,NULL,0),(12240,102,'2027-02-05',3,0,0,NULL,0),(12241,103,'2026-10-09',5,0,0,NULL,0),(12242,103,'2026-10-10',5,0,0,NULL,0),(12243,103,'2026-10-11',5,0,0,NULL,0),(12244,103,'2026-10-12',5,0,0,NULL,0),(12245,103,'2026-10-13',5,0,0,NULL,0),(12246,103,'2026-10-14',5,0,0,NULL,0),(12247,103,'2026-10-15',5,0,0,NULL,0),(12248,103,'2026-10-16',5,0,0,NULL,0),(12249,103,'2026-10-17',5,0,0,NULL,0),(12250,103,'2026-10-18',5,0,0,NULL,0),(12251,103,'2026-10-19',5,0,0,NULL,0),(12252,103,'2026-10-20',5,0,0,NULL,0),(12253,103,'2026-10-21',5,0,0,NULL,0),(12254,103,'2026-10-22',5,0,0,NULL,0),(12255,103,'2026-10-23',5,0,0,NULL,0),(12256,103,'2026-10-24',5,0,0,NULL,0),(12257,103,'2026-10-25',5,0,0,NULL,0),(12258,103,'2026-10-26',5,0,0,NULL,0),(12259,103,'2026-10-27',5,0,0,NULL,0),(12260,103,'2026-10-28',5,0,0,NULL,0),(12261,103,'2026-10-29',5,0,0,NULL,0),(12262,103,'2026-10-30',5,0,0,NULL,0),(12263,103,'2026-10-31',5,0,0,NULL,0),(12264,103,'2026-11-01',5,0,0,NULL,0),(12265,103,'2026-11-02',5,0,0,NULL,0),(12266,103,'2026-11-03',5,0,0,NULL,0),(12267,103,'2026-11-04',5,0,0,NULL,0),(12268,103,'2026-11-05',5,0,0,NULL,0),(12269,103,'2026-11-06',5,0,0,NULL,0),(12270,103,'2026-11-07',5,0,0,NULL,0),(12271,103,'2026-11-08',5,0,0,NULL,0),(12272,103,'2026-11-09',5,0,0,NULL,0),(12273,103,'2026-11-10',5,0,0,NULL,0),(12274,103,'2026-11-11',5,0,0,NULL,0),(12275,103,'2026-11-12',5,0,0,NULL,0),(12276,103,'2026-11-13',5,0,0,NULL,0),(12277,103,'2026-11-14',5,0,0,NULL,0),(12278,103,'2026-11-15',5,0,0,NULL,0),(12279,103,'2026-11-16',5,0,0,NULL,0),(12280,103,'2026-11-17',5,0,0,NULL,0),(12281,103,'2026-11-18',5,0,0,NULL,0),(12282,103,'2026-11-19',5,0,0,NULL,0),(12283,103,'2026-11-20',5,0,0,NULL,0),(12284,103,'2026-11-21',5,0,0,NULL,0),(12285,103,'2026-11-22',5,0,0,NULL,0),(12286,103,'2026-11-23',5,0,0,NULL,0),(12287,103,'2026-11-24',5,0,0,NULL,0),(12288,103,'2026-11-25',5,0,0,NULL,0),(12289,103,'2026-11-26',5,0,0,NULL,0),(12290,103,'2026-11-27',5,0,0,NULL,0),(12291,103,'2026-11-28',5,0,0,NULL,0),(12292,103,'2026-11-29',5,0,0,NULL,0),(12293,103,'2026-11-30',5,0,0,NULL,0),(12294,103,'2026-12-01',5,0,0,NULL,0),(12295,103,'2026-12-02',5,0,0,NULL,0),(12296,103,'2026-12-03',5,0,0,NULL,0),(12297,103,'2026-12-04',5,0,0,NULL,0),(12298,103,'2026-12-05',5,0,0,NULL,0),(12299,103,'2026-12-06',5,0,0,NULL,0),(12300,103,'2026-12-07',5,0,0,NULL,0),(12301,103,'2026-12-08',5,0,0,NULL,0),(12302,103,'2026-12-09',5,0,0,NULL,0),(12303,103,'2026-12-10',5,0,0,NULL,0),(12304,103,'2026-12-11',5,0,0,NULL,0),(12305,103,'2026-12-12',5,0,0,NULL,0),(12306,103,'2026-12-13',5,0,0,NULL,0),(12307,103,'2026-12-14',5,0,0,NULL,0),(12308,103,'2026-12-15',5,0,0,NULL,0),(12309,103,'2026-12-16',5,0,0,NULL,0),(12310,103,'2026-12-17',5,0,0,NULL,0),(12311,103,'2026-12-18',5,0,0,NULL,0),(12312,103,'2026-12-19',5,0,0,NULL,0),(12313,103,'2026-12-20',5,0,0,NULL,0),(12314,103,'2026-12-21',5,0,0,NULL,0),(12315,103,'2026-12-22',5,0,0,NULL,0),(12316,103,'2026-12-23',5,0,0,NULL,0),(12317,103,'2026-12-24',5,0,0,NULL,0),(12318,103,'2026-12-25',5,0,0,NULL,0),(12319,103,'2026-12-26',5,0,0,NULL,0),(12320,103,'2026-12-27',5,0,0,NULL,0),(12321,103,'2026-12-28',5,0,0,NULL,0),(12322,103,'2026-12-29',5,0,0,NULL,0),(12323,103,'2026-12-30',5,0,0,NULL,0),(12324,103,'2026-12-31',5,0,0,NULL,0),(12325,103,'2027-01-01',5,0,0,NULL,0),(12326,103,'2027-01-02',5,0,0,NULL,0),(12327,103,'2027-01-03',5,0,0,NULL,0),(12328,103,'2027-01-04',5,0,0,NULL,0),(12329,103,'2027-01-05',5,0,0,NULL,0),(12330,103,'2027-01-06',5,0,0,NULL,0),(12331,103,'2027-01-07',5,0,0,NULL,0),(12332,103,'2027-01-08',5,0,0,NULL,0),(12333,103,'2027-01-09',5,0,0,NULL,0),(12334,103,'2027-01-10',5,0,0,NULL,0),(12335,103,'2027-01-11',5,0,0,NULL,0),(12336,103,'2027-01-12',5,0,0,NULL,0),(12337,103,'2027-01-13',5,0,0,NULL,0),(12338,103,'2027-01-14',5,0,0,NULL,0),(12339,103,'2027-01-15',5,0,0,NULL,0),(12340,103,'2027-01-16',5,0,0,NULL,0),(12341,103,'2027-01-17',5,0,0,NULL,0),(12342,103,'2027-01-18',5,0,0,NULL,0),(12343,103,'2027-01-19',5,0,0,NULL,0),(12344,103,'2027-01-20',5,0,0,NULL,0),(12345,103,'2027-01-21',5,0,0,NULL,0),(12346,103,'2027-01-22',5,0,0,NULL,0),(12347,103,'2027-01-23',5,0,0,NULL,0),(12348,103,'2027-01-24',5,0,0,NULL,0),(12349,103,'2027-01-25',5,0,0,NULL,0),(12350,103,'2027-01-26',5,0,0,NULL,0),(12351,103,'2027-01-27',5,0,0,NULL,0),(12352,103,'2027-01-28',5,0,0,NULL,0),(12353,103,'2027-01-29',5,0,0,NULL,0),(12354,103,'2027-01-30',5,0,0,NULL,0),(12355,103,'2027-01-31',5,0,0,NULL,0),(12356,103,'2027-02-01',5,0,0,NULL,0),(12357,103,'2027-02-02',5,0,0,NULL,0),(12358,103,'2027-02-03',5,0,0,NULL,0),(12359,103,'2027-02-04',5,0,0,NULL,0),(12360,103,'2027-02-05',5,0,0,NULL,0),(12361,104,'2026-10-09',2,0,0,NULL,0),(12362,104,'2026-10-10',2,0,0,NULL,0),(12363,104,'2026-10-11',2,0,0,NULL,0),(12364,104,'2026-10-12',2,0,0,NULL,0),(12365,104,'2026-10-13',2,0,0,NULL,0),(12366,104,'2026-10-14',2,0,0,NULL,0),(12367,104,'2026-10-15',2,0,0,NULL,0),(12368,104,'2026-10-16',2,0,0,NULL,0),(12369,104,'2026-10-17',2,0,0,NULL,0),(12370,104,'2026-10-18',2,0,0,NULL,0),(12371,104,'2026-10-19',2,0,0,NULL,0),(12372,104,'2026-10-20',2,0,0,NULL,0),(12373,104,'2026-10-21',2,0,0,NULL,0),(12374,104,'2026-10-22',2,0,0,NULL,0),(12375,104,'2026-10-23',2,0,0,NULL,0),(12376,104,'2026-10-24',2,0,0,NULL,0),(12377,104,'2026-10-25',2,0,0,NULL,0),(12378,104,'2026-10-26',2,0,0,NULL,0),(12379,104,'2026-10-27',2,0,0,NULL,0),(12380,104,'2026-10-28',2,0,0,NULL,0),(12381,104,'2026-10-29',2,0,0,NULL,0),(12382,104,'2026-10-30',2,0,0,NULL,0),(12383,104,'2026-10-31',2,0,0,NULL,0),(12384,104,'2026-11-01',2,0,0,NULL,0),(12385,104,'2026-11-02',2,0,0,NULL,0),(12386,104,'2026-11-03',2,0,0,NULL,0),(12387,104,'2026-11-04',2,0,0,NULL,0),(12388,104,'2026-11-05',2,0,0,NULL,0),(12389,104,'2026-11-06',2,0,0,NULL,0),(12390,104,'2026-11-07',2,0,0,NULL,0),(12391,104,'2026-11-08',2,0,0,NULL,0),(12392,104,'2026-11-09',2,0,0,NULL,0),(12393,104,'2026-11-10',2,0,0,NULL,0),(12394,104,'2026-11-11',2,0,0,NULL,0),(12395,104,'2026-11-12',2,0,0,NULL,0),(12396,104,'2026-11-13',2,0,0,NULL,0),(12397,104,'2026-11-14',2,0,0,NULL,0),(12398,104,'2026-11-15',2,0,0,NULL,0),(12399,104,'2026-11-16',2,0,0,NULL,0),(12400,104,'2026-11-17',2,0,0,NULL,0),(12401,104,'2026-11-18',2,0,0,NULL,0),(12402,104,'2026-11-19',2,0,0,NULL,0),(12403,104,'2026-11-20',2,0,0,NULL,0),(12404,104,'2026-11-21',2,0,0,NULL,0),(12405,104,'2026-11-22',2,0,0,NULL,0),(12406,104,'2026-11-23',2,0,0,NULL,0),(12407,104,'2026-11-24',2,0,0,NULL,0),(12408,104,'2026-11-25',2,0,0,NULL,0),(12409,104,'2026-11-26',2,0,0,NULL,0),(12410,104,'2026-11-27',2,0,0,NULL,0),(12411,104,'2026-11-28',2,0,0,NULL,0),(12412,104,'2026-11-29',2,0,0,NULL,0),(12413,104,'2026-11-30',2,0,0,NULL,0),(12414,104,'2026-12-01',2,0,0,NULL,0),(12415,104,'2026-12-02',2,0,0,NULL,0),(12416,104,'2026-12-03',2,0,0,NULL,0),(12417,104,'2026-12-04',2,0,0,NULL,0),(12418,104,'2026-12-05',2,0,0,NULL,0),(12419,104,'2026-12-06',2,0,0,NULL,0),(12420,104,'2026-12-07',2,0,0,NULL,0),(12421,104,'2026-12-08',2,0,0,NULL,0),(12422,104,'2026-12-09',2,0,0,NULL,0),(12423,104,'2026-12-10',2,0,0,NULL,0),(12424,104,'2026-12-11',2,0,0,NULL,0),(12425,104,'2026-12-12',2,0,0,NULL,0),(12426,104,'2026-12-13',2,0,0,NULL,0),(12427,104,'2026-12-14',2,0,0,NULL,0),(12428,104,'2026-12-15',2,0,0,NULL,0),(12429,104,'2026-12-16',2,0,0,NULL,0),(12430,104,'2026-12-17',2,0,0,NULL,0),(12431,104,'2026-12-18',2,0,0,NULL,0),(12432,104,'2026-12-19',2,0,0,NULL,0),(12433,104,'2026-12-20',2,0,0,NULL,0),(12434,104,'2026-12-21',2,0,0,NULL,0),(12435,104,'2026-12-22',2,0,0,NULL,0),(12436,104,'2026-12-23',2,0,0,NULL,0),(12437,104,'2026-12-24',2,0,0,NULL,0),(12438,104,'2026-12-25',2,0,0,NULL,0),(12439,104,'2026-12-26',2,0,0,NULL,0),(12440,104,'2026-12-27',2,0,0,NULL,0),(12441,104,'2026-12-28',2,0,0,NULL,0),(12442,104,'2026-12-29',2,0,0,NULL,0),(12443,104,'2026-12-30',2,0,0,NULL,0),(12444,104,'2026-12-31',2,0,0,NULL,0),(12445,104,'2027-01-01',2,0,0,NULL,0),(12446,104,'2027-01-02',2,0,0,NULL,0),(12447,104,'2027-01-03',2,0,0,NULL,0),(12448,104,'2027-01-04',2,0,0,NULL,0),(12449,104,'2027-01-05',2,0,0,NULL,0),(12450,104,'2027-01-06',2,0,0,NULL,0),(12451,104,'2027-01-07',2,0,0,NULL,0),(12452,104,'2027-01-08',2,0,0,NULL,0),(12453,104,'2027-01-09',2,0,0,NULL,0),(12454,104,'2027-01-10',2,0,0,NULL,0),(12455,104,'2027-01-11',2,0,0,NULL,0),(12456,104,'2027-01-12',2,0,0,NULL,0),(12457,104,'2027-01-13',2,0,0,NULL,0),(12458,104,'2027-01-14',2,0,0,NULL,0),(12459,104,'2027-01-15',2,0,0,NULL,0),(12460,104,'2027-01-16',2,0,0,NULL,0),(12461,104,'2027-01-17',2,0,0,NULL,0),(12462,104,'2027-01-18',2,0,0,NULL,0),(12463,104,'2027-01-19',2,0,0,NULL,0),(12464,104,'2027-01-20',2,0,0,NULL,0),(12465,104,'2027-01-21',2,0,0,NULL,0),(12466,104,'2027-01-22',2,0,0,NULL,0),(12467,104,'2027-01-23',2,0,0,NULL,0),(12468,104,'2027-01-24',2,0,0,NULL,0),(12469,104,'2027-01-25',2,0,0,NULL,0),(12470,104,'2027-01-26',2,0,0,NULL,0),(12471,104,'2027-01-27',2,0,0,NULL,0),(12472,104,'2027-01-28',2,0,0,NULL,0),(12473,104,'2027-01-29',2,0,0,NULL,0),(12474,104,'2027-01-30',2,0,0,NULL,0),(12475,104,'2027-01-31',2,0,0,NULL,0),(12476,104,'2027-02-01',2,0,0,NULL,0),(12477,104,'2027-02-02',2,0,0,NULL,0),(12478,104,'2027-02-03',2,0,0,NULL,0),(12479,104,'2027-02-04',2,0,0,NULL,0),(12480,104,'2027-02-05',2,0,0,NULL,0),(12481,105,'2026-10-09',6,0,0,NULL,0),(12482,105,'2026-10-10',6,0,0,NULL,0),(12483,105,'2026-10-11',6,0,0,NULL,0),(12484,105,'2026-10-12',6,0,0,NULL,0),(12485,105,'2026-10-13',6,0,0,NULL,0),(12486,105,'2026-10-14',6,0,0,NULL,0),(12487,105,'2026-10-15',6,0,0,NULL,0),(12488,105,'2026-10-16',6,0,0,NULL,0),(12489,105,'2026-10-17',6,0,0,NULL,0),(12490,105,'2026-10-18',6,0,0,NULL,0),(12491,105,'2026-10-19',6,0,0,NULL,0),(12492,105,'2026-10-20',6,0,0,NULL,0),(12493,105,'2026-10-21',6,0,0,NULL,0),(12494,105,'2026-10-22',6,0,0,NULL,0),(12495,105,'2026-10-23',6,0,0,NULL,0),(12496,105,'2026-10-24',6,0,0,NULL,0),(12497,105,'2026-10-25',6,0,0,NULL,0),(12498,105,'2026-10-26',6,0,0,NULL,0),(12499,105,'2026-10-27',6,0,0,NULL,0),(12500,105,'2026-10-28',6,0,0,NULL,0),(12501,105,'2026-10-29',6,0,0,NULL,0),(12502,105,'2026-10-30',6,0,0,NULL,0),(12503,105,'2026-10-31',6,0,0,NULL,0),(12504,105,'2026-11-01',6,0,0,NULL,0),(12505,105,'2026-11-02',6,0,0,NULL,0),(12506,105,'2026-11-03',6,0,0,NULL,0),(12507,105,'2026-11-04',6,0,0,NULL,0),(12508,105,'2026-11-05',6,0,0,NULL,0),(12509,105,'2026-11-06',6,0,0,NULL,0),(12510,105,'2026-11-07',6,0,0,NULL,0),(12511,105,'2026-11-08',6,0,0,NULL,0),(12512,105,'2026-11-09',6,0,0,NULL,0),(12513,105,'2026-11-10',6,0,0,NULL,0),(12514,105,'2026-11-11',6,0,0,NULL,0),(12515,105,'2026-11-12',6,0,0,NULL,0),(12516,105,'2026-11-13',6,0,0,NULL,0),(12517,105,'2026-11-14',6,0,0,NULL,0),(12518,105,'2026-11-15',6,0,0,NULL,0),(12519,105,'2026-11-16',6,0,0,NULL,0),(12520,105,'2026-11-17',6,0,0,NULL,0),(12521,105,'2026-11-18',6,0,0,NULL,0),(12522,105,'2026-11-19',6,0,0,NULL,0),(12523,105,'2026-11-20',6,0,0,NULL,0),(12524,105,'2026-11-21',6,0,0,NULL,0),(12525,105,'2026-11-22',6,0,0,NULL,0),(12526,105,'2026-11-23',6,0,0,NULL,0),(12527,105,'2026-11-24',6,0,0,NULL,0),(12528,105,'2026-11-25',6,0,0,NULL,0),(12529,105,'2026-11-26',6,0,0,NULL,0),(12530,105,'2026-11-27',6,0,0,NULL,0),(12531,105,'2026-11-28',6,0,0,NULL,0),(12532,105,'2026-11-29',6,0,0,NULL,0),(12533,105,'2026-11-30',6,0,0,NULL,0),(12534,105,'2026-12-01',6,0,0,NULL,0),(12535,105,'2026-12-02',6,0,0,NULL,0),(12536,105,'2026-12-03',6,0,0,NULL,0),(12537,105,'2026-12-04',6,0,0,NULL,0),(12538,105,'2026-12-05',6,0,0,NULL,0),(12539,105,'2026-12-06',6,0,0,NULL,0),(12540,105,'2026-12-07',6,0,0,NULL,0),(12541,105,'2026-12-08',6,0,0,NULL,0),(12542,105,'2026-12-09',6,0,0,NULL,0),(12543,105,'2026-12-10',6,0,0,NULL,0),(12544,105,'2026-12-11',6,0,0,NULL,0),(12545,105,'2026-12-12',6,0,0,NULL,0),(12546,105,'2026-12-13',6,0,0,NULL,0),(12547,105,'2026-12-14',6,0,0,NULL,0),(12548,105,'2026-12-15',6,0,0,NULL,0),(12549,105,'2026-12-16',6,0,0,NULL,0),(12550,105,'2026-12-17',6,0,0,NULL,0),(12551,105,'2026-12-18',6,0,0,NULL,0),(12552,105,'2026-12-19',6,0,0,NULL,0),(12553,105,'2026-12-20',6,0,0,NULL,0),(12554,105,'2026-12-21',6,0,0,NULL,0),(12555,105,'2026-12-22',6,0,0,NULL,0),(12556,105,'2026-12-23',6,0,0,NULL,0),(12557,105,'2026-12-24',6,0,0,NULL,0),(12558,105,'2026-12-25',6,0,0,NULL,0),(12559,105,'2026-12-26',6,0,0,NULL,0),(12560,105,'2026-12-27',6,0,0,NULL,0),(12561,105,'2026-12-28',6,0,0,NULL,0),(12562,105,'2026-12-29',6,0,0,NULL,0),(12563,105,'2026-12-30',6,0,0,NULL,0),(12564,105,'2026-12-31',6,0,0,NULL,0),(12565,105,'2027-01-01',6,0,0,NULL,0),(12566,105,'2027-01-02',6,0,0,NULL,0),(12567,105,'2027-01-03',6,0,0,NULL,0),(12568,105,'2027-01-04',6,0,0,NULL,0),(12569,105,'2027-01-05',6,0,0,NULL,0),(12570,105,'2027-01-06',6,0,0,NULL,0),(12571,105,'2027-01-07',6,0,0,NULL,0),(12572,105,'2027-01-08',6,0,0,NULL,0),(12573,105,'2027-01-09',6,0,0,NULL,0),(12574,105,'2027-01-10',6,0,0,NULL,0),(12575,105,'2027-01-11',6,0,0,NULL,0),(12576,105,'2027-01-12',6,0,0,NULL,0),(12577,105,'2027-01-13',6,0,0,NULL,0),(12578,105,'2027-01-14',6,0,0,NULL,0),(12579,105,'2027-01-15',6,0,0,NULL,0),(12580,105,'2027-01-16',6,0,0,NULL,0),(12581,105,'2027-01-17',6,0,0,NULL,0),(12582,105,'2027-01-18',6,0,0,NULL,0),(12583,105,'2027-01-19',6,0,0,NULL,0),(12584,105,'2027-01-20',6,0,0,NULL,0),(12585,105,'2027-01-21',6,0,0,NULL,0),(12586,105,'2027-01-22',6,0,0,NULL,0),(12587,105,'2027-01-23',6,0,0,NULL,0),(12588,105,'2027-01-24',6,0,0,NULL,0),(12589,105,'2027-01-25',6,0,0,NULL,0),(12590,105,'2027-01-26',6,0,0,NULL,0),(12591,105,'2027-01-27',6,0,0,NULL,0),(12592,105,'2027-01-28',6,0,0,NULL,0),(12593,105,'2027-01-29',6,0,0,NULL,0),(12594,105,'2027-01-30',6,0,0,NULL,0),(12595,105,'2027-01-31',6,0,0,NULL,0),(12596,105,'2027-02-01',6,0,0,NULL,0),(12597,105,'2027-02-02',6,0,0,NULL,0),(12598,105,'2027-02-03',6,0,0,NULL,0),(12599,105,'2027-02-04',6,0,0,NULL,0),(12600,105,'2027-02-05',6,0,0,NULL,0),(12601,106,'2026-10-09',2,0,0,NULL,0),(12602,106,'2026-10-10',2,0,0,NULL,0),(12603,106,'2026-10-11',2,0,0,NULL,0),(12604,106,'2026-10-12',2,0,0,NULL,0),(12605,106,'2026-10-13',2,0,0,NULL,0),(12606,106,'2026-10-14',2,0,0,NULL,0),(12607,106,'2026-10-15',2,0,0,NULL,0),(12608,106,'2026-10-16',2,0,0,NULL,0),(12609,106,'2026-10-17',2,0,0,NULL,0),(12610,106,'2026-10-18',2,0,0,NULL,0),(12611,106,'2026-10-19',2,0,0,NULL,0),(12612,106,'2026-10-20',2,0,0,NULL,0),(12613,106,'2026-10-21',2,0,0,NULL,0),(12614,106,'2026-10-22',2,0,0,NULL,0),(12615,106,'2026-10-23',2,0,0,NULL,0),(12616,106,'2026-10-24',2,0,0,NULL,0),(12617,106,'2026-10-25',2,0,0,NULL,0),(12618,106,'2026-10-26',2,0,0,NULL,0),(12619,106,'2026-10-27',2,0,0,NULL,0),(12620,106,'2026-10-28',2,0,0,NULL,0),(12621,106,'2026-10-29',2,0,0,NULL,0),(12622,106,'2026-10-30',2,0,0,NULL,0),(12623,106,'2026-10-31',2,0,0,NULL,0),(12624,106,'2026-11-01',2,0,0,NULL,0),(12625,106,'2026-11-02',2,0,0,NULL,0),(12626,106,'2026-11-03',2,0,0,NULL,0),(12627,106,'2026-11-04',2,0,0,NULL,0),(12628,106,'2026-11-05',2,0,0,NULL,0),(12629,106,'2026-11-06',2,0,0,NULL,0),(12630,106,'2026-11-07',2,0,0,NULL,0),(12631,106,'2026-11-08',2,0,0,NULL,0),(12632,106,'2026-11-09',2,0,0,NULL,0),(12633,106,'2026-11-10',2,0,0,NULL,0),(12634,106,'2026-11-11',2,0,0,NULL,0),(12635,106,'2026-11-12',2,0,0,NULL,0),(12636,106,'2026-11-13',2,0,0,NULL,0),(12637,106,'2026-11-14',2,0,0,NULL,0),(12638,106,'2026-11-15',2,0,0,NULL,0),(12639,106,'2026-11-16',2,0,0,NULL,0),(12640,106,'2026-11-17',2,0,0,NULL,0),(12641,106,'2026-11-18',2,0,0,NULL,0),(12642,106,'2026-11-19',2,0,0,NULL,0),(12643,106,'2026-11-20',2,0,0,NULL,0),(12644,106,'2026-11-21',2,0,0,NULL,0),(12645,106,'2026-11-22',2,0,0,NULL,0),(12646,106,'2026-11-23',2,0,0,NULL,0),(12647,106,'2026-11-24',2,0,0,NULL,0),(12648,106,'2026-11-25',2,0,0,NULL,0),(12649,106,'2026-11-26',2,0,0,NULL,0),(12650,106,'2026-11-27',2,0,0,NULL,0),(12651,106,'2026-11-28',2,0,0,NULL,0),(12652,106,'2026-11-29',2,0,0,NULL,0),(12653,106,'2026-11-30',2,0,0,NULL,0),(12654,106,'2026-12-01',2,0,0,NULL,0),(12655,106,'2026-12-02',2,0,0,NULL,0),(12656,106,'2026-12-03',2,0,0,NULL,0),(12657,106,'2026-12-04',2,0,0,NULL,0),(12658,106,'2026-12-05',2,0,0,NULL,0),(12659,106,'2026-12-06',2,0,0,NULL,0),(12660,106,'2026-12-07',2,0,0,NULL,0),(12661,106,'2026-12-08',2,0,0,NULL,0),(12662,106,'2026-12-09',2,0,0,NULL,0),(12663,106,'2026-12-10',2,0,0,NULL,0),(12664,106,'2026-12-11',2,0,0,NULL,0),(12665,106,'2026-12-12',2,0,0,NULL,0),(12666,106,'2026-12-13',2,0,0,NULL,0),(12667,106,'2026-12-14',2,0,0,NULL,0),(12668,106,'2026-12-15',2,0,0,NULL,0),(12669,106,'2026-12-16',2,0,0,NULL,0),(12670,106,'2026-12-17',2,0,0,NULL,0),(12671,106,'2026-12-18',2,0,0,NULL,0),(12672,106,'2026-12-19',2,0,0,NULL,0),(12673,106,'2026-12-20',2,0,0,NULL,0),(12674,106,'2026-12-21',2,0,0,NULL,0),(12675,106,'2026-12-22',2,0,0,NULL,0),(12676,106,'2026-12-23',2,0,0,NULL,0),(12677,106,'2026-12-24',2,0,0,NULL,0),(12678,106,'2026-12-25',2,0,0,NULL,0),(12679,106,'2026-12-26',2,0,0,NULL,0),(12680,106,'2026-12-27',2,0,0,NULL,0),(12681,106,'2026-12-28',2,0,0,NULL,0),(12682,106,'2026-12-29',2,0,0,NULL,0),(12683,106,'2026-12-30',2,0,0,NULL,0),(12684,106,'2026-12-31',2,0,0,NULL,0),(12685,106,'2027-01-01',2,0,0,NULL,0),(12686,106,'2027-01-02',2,0,0,NULL,0),(12687,106,'2027-01-03',2,0,0,NULL,0),(12688,106,'2027-01-04',2,0,0,NULL,0),(12689,106,'2027-01-05',2,0,0,NULL,0),(12690,106,'2027-01-06',2,0,0,NULL,0),(12691,106,'2027-01-07',2,0,0,NULL,0),(12692,106,'2027-01-08',2,0,0,NULL,0),(12693,106,'2027-01-09',2,0,0,NULL,0),(12694,106,'2027-01-10',2,0,0,NULL,0),(12695,106,'2027-01-11',2,0,0,NULL,0),(12696,106,'2027-01-12',2,0,0,NULL,0),(12697,106,'2027-01-13',2,0,0,NULL,0),(12698,106,'2027-01-14',2,0,0,NULL,0),(12699,106,'2027-01-15',2,0,0,NULL,0),(12700,106,'2027-01-16',2,0,0,NULL,0),(12701,106,'2027-01-17',2,0,0,NULL,0),(12702,106,'2027-01-18',2,0,0,NULL,0),(12703,106,'2027-01-19',2,0,0,NULL,0),(12704,106,'2027-01-20',2,0,0,NULL,0),(12705,106,'2027-01-21',2,0,0,NULL,0),(12706,106,'2027-01-22',2,0,0,NULL,0),(12707,106,'2027-01-23',2,0,0,NULL,0),(12708,106,'2027-01-24',2,0,0,NULL,0),(12709,106,'2027-01-25',2,0,0,NULL,0),(12710,106,'2027-01-26',2,0,0,NULL,0),(12711,106,'2027-01-27',2,0,0,NULL,0),(12712,106,'2027-01-28',2,0,0,NULL,0),(12713,106,'2027-01-29',2,0,0,NULL,0),(12714,106,'2027-01-30',2,0,0,NULL,0),(12715,106,'2027-01-31',2,0,0,NULL,0),(12716,106,'2027-02-01',2,0,0,NULL,0),(12717,106,'2027-02-02',2,0,0,NULL,0),(12718,106,'2027-02-03',2,0,0,NULL,0),(12719,106,'2027-02-04',2,0,0,NULL,0),(12720,106,'2027-02-05',2,0,0,NULL,0),(12721,107,'2026-10-09',5,0,0,NULL,0),(12722,107,'2026-10-10',5,0,0,NULL,0),(12723,107,'2026-10-11',5,0,0,NULL,0),(12724,107,'2026-10-12',5,0,0,NULL,0),(12725,107,'2026-10-13',5,0,0,NULL,0),(12726,107,'2026-10-14',5,0,0,NULL,0),(12727,107,'2026-10-15',5,0,0,NULL,0),(12728,107,'2026-10-16',5,0,0,NULL,0),(12729,107,'2026-10-17',5,0,0,NULL,0),(12730,107,'2026-10-18',5,0,0,NULL,0),(12731,107,'2026-10-19',5,0,0,NULL,0),(12732,107,'2026-10-20',5,0,0,NULL,0),(12733,107,'2026-10-21',5,0,0,NULL,0),(12734,107,'2026-10-22',5,0,0,NULL,0),(12735,107,'2026-10-23',5,0,0,NULL,0),(12736,107,'2026-10-24',5,0,0,NULL,0),(12737,107,'2026-10-25',5,0,0,NULL,0),(12738,107,'2026-10-26',5,0,0,NULL,0),(12739,107,'2026-10-27',5,0,0,NULL,0),(12740,107,'2026-10-28',5,0,0,NULL,0),(12741,107,'2026-10-29',5,0,0,NULL,0),(12742,107,'2026-10-30',5,0,0,NULL,0),(12743,107,'2026-10-31',5,0,0,NULL,0),(12744,107,'2026-11-01',5,0,0,NULL,0),(12745,107,'2026-11-02',5,0,0,NULL,0),(12746,107,'2026-11-03',5,0,0,NULL,0),(12747,107,'2026-11-04',5,0,0,NULL,0),(12748,107,'2026-11-05',5,0,0,NULL,0),(12749,107,'2026-11-06',5,0,0,NULL,0),(12750,107,'2026-11-07',5,0,0,NULL,0),(12751,107,'2026-11-08',5,0,0,NULL,0),(12752,107,'2026-11-09',5,0,0,NULL,0),(12753,107,'2026-11-10',5,0,0,NULL,0),(12754,107,'2026-11-11',5,0,0,NULL,0),(12755,107,'2026-11-12',5,0,0,NULL,0),(12756,107,'2026-11-13',5,0,0,NULL,0),(12757,107,'2026-11-14',5,0,0,NULL,0),(12758,107,'2026-11-15',5,0,0,NULL,0),(12759,107,'2026-11-16',5,0,0,NULL,0),(12760,107,'2026-11-17',5,0,0,NULL,0),(12761,107,'2026-11-18',5,0,0,NULL,0),(12762,107,'2026-11-19',5,0,0,NULL,0),(12763,107,'2026-11-20',5,0,0,NULL,0),(12764,107,'2026-11-21',5,0,0,NULL,0),(12765,107,'2026-11-22',5,0,0,NULL,0),(12766,107,'2026-11-23',5,0,0,NULL,0),(12767,107,'2026-11-24',5,0,0,NULL,0),(12768,107,'2026-11-25',5,0,0,NULL,0),(12769,107,'2026-11-26',5,0,0,NULL,0),(12770,107,'2026-11-27',5,0,0,NULL,0),(12771,107,'2026-11-28',5,0,0,NULL,0),(12772,107,'2026-11-29',5,0,0,NULL,0),(12773,107,'2026-11-30',5,0,0,NULL,0),(12774,107,'2026-12-01',5,0,0,NULL,0),(12775,107,'2026-12-02',5,0,0,NULL,0),(12776,107,'2026-12-03',5,0,0,NULL,0),(12777,107,'2026-12-04',5,0,0,NULL,0),(12778,107,'2026-12-05',5,0,0,NULL,0),(12779,107,'2026-12-06',5,0,0,NULL,0),(12780,107,'2026-12-07',5,0,0,NULL,0),(12781,107,'2026-12-08',5,0,0,NULL,0),(12782,107,'2026-12-09',5,0,0,NULL,0),(12783,107,'2026-12-10',5,0,0,NULL,0),(12784,107,'2026-12-11',5,0,0,NULL,0),(12785,107,'2026-12-12',5,0,0,NULL,0),(12786,107,'2026-12-13',5,0,0,NULL,0),(12787,107,'2026-12-14',5,0,0,NULL,0),(12788,107,'2026-12-15',5,0,0,NULL,0),(12789,107,'2026-12-16',5,0,0,NULL,0),(12790,107,'2026-12-17',5,0,0,NULL,0),(12791,107,'2026-12-18',5,0,0,NULL,0),(12792,107,'2026-12-19',5,0,0,NULL,0),(12793,107,'2026-12-20',5,0,0,NULL,0),(12794,107,'2026-12-21',5,0,0,NULL,0),(12795,107,'2026-12-22',5,0,0,NULL,0),(12796,107,'2026-12-23',5,0,0,NULL,0),(12797,107,'2026-12-24',5,0,0,NULL,0),(12798,107,'2026-12-25',5,0,0,NULL,0),(12799,107,'2026-12-26',5,0,0,NULL,0),(12800,107,'2026-12-27',5,0,0,NULL,0),(12801,107,'2026-12-28',5,0,0,NULL,0),(12802,107,'2026-12-29',5,0,0,NULL,0),(12803,107,'2026-12-30',5,0,0,NULL,0),(12804,107,'2026-12-31',5,0,0,NULL,0),(12805,107,'2027-01-01',5,0,0,NULL,0),(12806,107,'2027-01-02',5,0,0,NULL,0),(12807,107,'2027-01-03',5,0,0,NULL,0),(12808,107,'2027-01-04',5,0,0,NULL,0),(12809,107,'2027-01-05',5,0,0,NULL,0),(12810,107,'2027-01-06',5,0,0,NULL,0),(12811,107,'2027-01-07',5,0,0,NULL,0),(12812,107,'2027-01-08',5,0,0,NULL,0),(12813,107,'2027-01-09',5,0,0,NULL,0),(12814,107,'2027-01-10',5,0,0,NULL,0),(12815,107,'2027-01-11',5,0,0,NULL,0),(12816,107,'2027-01-12',5,0,0,NULL,0),(12817,107,'2027-01-13',5,0,0,NULL,0),(12818,107,'2027-01-14',5,0,0,NULL,0),(12819,107,'2027-01-15',5,0,0,NULL,0),(12820,107,'2027-01-16',5,0,0,NULL,0),(12821,107,'2027-01-17',5,0,0,NULL,0),(12822,107,'2027-01-18',5,0,0,NULL,0),(12823,107,'2027-01-19',5,0,0,NULL,0),(12824,107,'2027-01-20',5,0,0,NULL,0),(12825,107,'2027-01-21',5,0,0,NULL,0),(12826,107,'2027-01-22',5,0,0,NULL,0),(12827,107,'2027-01-23',5,0,0,NULL,0),(12828,107,'2027-01-24',5,0,0,NULL,0),(12829,107,'2027-01-25',5,0,0,NULL,0),(12830,107,'2027-01-26',5,0,0,NULL,0),(12831,107,'2027-01-27',5,0,0,NULL,0),(12832,107,'2027-01-28',5,0,0,NULL,0),(12833,107,'2027-01-29',5,0,0,NULL,0),(12834,107,'2027-01-30',5,0,0,NULL,0),(12835,107,'2027-01-31',5,0,0,NULL,0),(12836,107,'2027-02-01',5,0,0,NULL,0),(12837,107,'2027-02-02',5,0,0,NULL,0),(12838,107,'2027-02-03',5,0,0,NULL,0),(12839,107,'2027-02-04',5,0,0,NULL,0),(12840,107,'2027-02-05',5,0,0,NULL,0),(12841,108,'2026-10-09',3,0,0,NULL,0),(12842,108,'2026-10-10',3,0,0,NULL,0),(12843,108,'2026-10-11',3,0,0,NULL,0),(12844,108,'2026-10-12',3,0,0,NULL,0),(12845,108,'2026-10-13',3,0,0,NULL,0),(12846,108,'2026-10-14',3,0,0,NULL,0),(12847,108,'2026-10-15',3,0,0,NULL,0),(12848,108,'2026-10-16',3,0,0,NULL,0),(12849,108,'2026-10-17',3,0,0,NULL,0),(12850,108,'2026-10-18',3,0,0,NULL,0),(12851,108,'2026-10-19',3,0,0,NULL,0),(12852,108,'2026-10-20',3,0,0,NULL,0),(12853,108,'2026-10-21',3,0,0,NULL,0),(12854,108,'2026-10-22',3,0,0,NULL,0),(12855,108,'2026-10-23',3,0,0,NULL,0),(12856,108,'2026-10-24',3,0,0,NULL,0),(12857,108,'2026-10-25',3,0,0,NULL,0),(12858,108,'2026-10-26',3,0,0,NULL,0),(12859,108,'2026-10-27',3,0,0,NULL,0),(12860,108,'2026-10-28',3,0,0,NULL,0),(12861,108,'2026-10-29',3,0,0,NULL,0),(12862,108,'2026-10-30',3,0,0,NULL,0),(12863,108,'2026-10-31',3,0,0,NULL,0),(12864,108,'2026-11-01',3,0,0,NULL,0),(12865,108,'2026-11-02',3,0,0,NULL,0),(12866,108,'2026-11-03',3,0,0,NULL,0),(12867,108,'2026-11-04',3,0,0,NULL,0),(12868,108,'2026-11-05',3,0,0,NULL,0),(12869,108,'2026-11-06',3,0,0,NULL,0),(12870,108,'2026-11-07',3,0,0,NULL,0),(12871,108,'2026-11-08',3,0,0,NULL,0),(12872,108,'2026-11-09',3,0,0,NULL,0),(12873,108,'2026-11-10',3,0,0,NULL,0),(12874,108,'2026-11-11',3,0,0,NULL,0),(12875,108,'2026-11-12',3,0,0,NULL,0),(12876,108,'2026-11-13',3,0,0,NULL,0),(12877,108,'2026-11-14',3,0,0,NULL,0),(12878,108,'2026-11-15',3,0,0,NULL,0),(12879,108,'2026-11-16',3,0,0,NULL,0),(12880,108,'2026-11-17',3,0,0,NULL,0),(12881,108,'2026-11-18',3,0,0,NULL,0),(12882,108,'2026-11-19',3,0,0,NULL,0),(12883,108,'2026-11-20',3,0,0,NULL,0),(12884,108,'2026-11-21',3,0,0,NULL,0),(12885,108,'2026-11-22',3,0,0,NULL,0),(12886,108,'2026-11-23',3,0,0,NULL,0),(12887,108,'2026-11-24',3,0,0,NULL,0),(12888,108,'2026-11-25',3,0,0,NULL,0),(12889,108,'2026-11-26',3,0,0,NULL,0),(12890,108,'2026-11-27',3,0,0,NULL,0),(12891,108,'2026-11-28',3,0,0,NULL,0),(12892,108,'2026-11-29',3,0,0,NULL,0),(12893,108,'2026-11-30',3,0,0,NULL,0),(12894,108,'2026-12-01',3,0,0,NULL,0),(12895,108,'2026-12-02',3,0,0,NULL,0),(12896,108,'2026-12-03',3,0,0,NULL,0),(12897,108,'2026-12-04',3,0,0,NULL,0),(12898,108,'2026-12-05',3,0,0,NULL,0),(12899,108,'2026-12-06',3,0,0,NULL,0),(12900,108,'2026-12-07',3,0,0,NULL,0),(12901,108,'2026-12-08',3,0,0,NULL,0),(12902,108,'2026-12-09',3,0,0,NULL,0),(12903,108,'2026-12-10',3,0,0,NULL,0),(12904,108,'2026-12-11',3,0,0,NULL,0),(12905,108,'2026-12-12',3,0,0,NULL,0),(12906,108,'2026-12-13',3,0,0,NULL,0),(12907,108,'2026-12-14',3,0,0,NULL,0),(12908,108,'2026-12-15',3,0,0,NULL,0),(12909,108,'2026-12-16',3,0,0,NULL,0),(12910,108,'2026-12-17',3,0,0,NULL,0),(12911,108,'2026-12-18',3,0,0,NULL,0),(12912,108,'2026-12-19',3,0,0,NULL,0),(12913,108,'2026-12-20',3,0,0,NULL,0),(12914,108,'2026-12-21',3,0,0,NULL,0),(12915,108,'2026-12-22',3,0,0,NULL,0),(12916,108,'2026-12-23',3,0,0,NULL,0),(12917,108,'2026-12-24',3,0,0,NULL,0),(12918,108,'2026-12-25',3,0,0,NULL,0),(12919,108,'2026-12-26',3,0,0,NULL,0),(12920,108,'2026-12-27',3,0,0,NULL,0),(12921,108,'2026-12-28',3,0,0,NULL,0),(12922,108,'2026-12-29',3,0,0,NULL,0),(12923,108,'2026-12-30',3,0,0,NULL,0),(12924,108,'2026-12-31',3,0,0,NULL,0),(12925,108,'2027-01-01',3,0,0,NULL,0),(12926,108,'2027-01-02',3,0,0,NULL,0),(12927,108,'2027-01-03',3,0,0,NULL,0),(12928,108,'2027-01-04',3,0,0,NULL,0),(12929,108,'2027-01-05',3,0,0,NULL,0),(12930,108,'2027-01-06',3,0,0,NULL,0),(12931,108,'2027-01-07',3,0,0,NULL,0),(12932,108,'2027-01-08',3,0,0,NULL,0),(12933,108,'2027-01-09',3,0,0,NULL,0),(12934,108,'2027-01-10',3,0,0,NULL,0),(12935,108,'2027-01-11',3,0,0,NULL,0),(12936,108,'2027-01-12',3,0,0,NULL,0),(12937,108,'2027-01-13',3,0,0,NULL,0),(12938,108,'2027-01-14',3,0,0,NULL,0),(12939,108,'2027-01-15',3,0,0,NULL,0),(12940,108,'2027-01-16',3,0,0,NULL,0),(12941,108,'2027-01-17',3,0,0,NULL,0),(12942,108,'2027-01-18',3,0,0,NULL,0),(12943,108,'2027-01-19',3,0,0,NULL,0),(12944,108,'2027-01-20',3,0,0,NULL,0),(12945,108,'2027-01-21',3,0,0,NULL,0),(12946,108,'2027-01-22',3,0,0,NULL,0),(12947,108,'2027-01-23',3,0,0,NULL,0),(12948,108,'2027-01-24',3,0,0,NULL,0),(12949,108,'2027-01-25',3,0,0,NULL,0),(12950,108,'2027-01-26',3,0,0,NULL,0),(12951,108,'2027-01-27',3,0,0,NULL,0),(12952,108,'2027-01-28',3,0,0,NULL,0),(12953,108,'2027-01-29',3,0,0,NULL,0),(12954,108,'2027-01-30',3,0,0,NULL,0),(12955,108,'2027-01-31',3,0,0,NULL,0),(12956,108,'2027-02-01',3,0,0,NULL,0),(12957,108,'2027-02-02',3,0,0,NULL,0),(12958,108,'2027-02-03',3,0,0,NULL,0),(12959,108,'2027-02-04',3,0,0,NULL,0),(12960,108,'2027-02-05',3,0,0,NULL,0),(12961,109,'2026-10-09',4,0,0,NULL,0),(12962,109,'2026-10-10',4,0,0,NULL,0),(12963,109,'2026-10-11',4,0,0,NULL,0),(12964,109,'2026-10-12',4,0,0,NULL,0),(12965,109,'2026-10-13',4,0,0,NULL,0),(12966,109,'2026-10-14',4,0,0,NULL,0),(12967,109,'2026-10-15',4,0,0,NULL,0),(12968,109,'2026-10-16',4,0,0,NULL,0),(12969,109,'2026-10-17',4,0,0,NULL,0),(12970,109,'2026-10-18',4,0,0,NULL,0),(12971,109,'2026-10-19',4,0,0,NULL,0),(12972,109,'2026-10-20',4,0,0,NULL,0),(12973,109,'2026-10-21',4,0,0,NULL,0),(12974,109,'2026-10-22',4,0,0,NULL,0),(12975,109,'2026-10-23',4,0,0,NULL,0),(12976,109,'2026-10-24',4,0,0,NULL,0),(12977,109,'2026-10-25',4,0,0,NULL,0),(12978,109,'2026-10-26',4,0,0,NULL,0),(12979,109,'2026-10-27',4,0,0,NULL,0),(12980,109,'2026-10-28',4,0,0,NULL,0),(12981,109,'2026-10-29',4,0,0,NULL,0),(12982,109,'2026-10-30',4,0,0,NULL,0),(12983,109,'2026-10-31',4,0,0,NULL,0),(12984,109,'2026-11-01',4,0,0,NULL,0),(12985,109,'2026-11-02',4,0,0,NULL,0),(12986,109,'2026-11-03',4,0,0,NULL,0),(12987,109,'2026-11-04',4,0,0,NULL,0),(12988,109,'2026-11-05',4,0,0,NULL,0),(12989,109,'2026-11-06',4,0,0,NULL,0),(12990,109,'2026-11-07',4,0,0,NULL,0),(12991,109,'2026-11-08',4,0,0,NULL,0),(12992,109,'2026-11-09',4,0,0,NULL,0),(12993,109,'2026-11-10',4,0,0,NULL,0),(12994,109,'2026-11-11',4,0,0,NULL,0),(12995,109,'2026-11-12',4,0,0,NULL,0),(12996,109,'2026-11-13',4,0,0,NULL,0),(12997,109,'2026-11-14',4,0,0,NULL,0),(12998,109,'2026-11-15',4,0,0,NULL,0),(12999,109,'2026-11-16',4,0,0,NULL,0),(13000,109,'2026-11-17',4,0,0,NULL,0),(13001,109,'2026-11-18',4,0,0,NULL,0),(13002,109,'2026-11-19',4,0,0,NULL,0),(13003,109,'2026-11-20',4,0,0,NULL,0),(13004,109,'2026-11-21',4,0,0,NULL,0),(13005,109,'2026-11-22',4,0,0,NULL,0),(13006,109,'2026-11-23',4,0,0,NULL,0),(13007,109,'2026-11-24',4,0,0,NULL,0),(13008,109,'2026-11-25',4,0,0,NULL,0),(13009,109,'2026-11-26',4,0,0,NULL,0),(13010,109,'2026-11-27',4,0,0,NULL,0),(13011,109,'2026-11-28',4,0,0,NULL,0),(13012,109,'2026-11-29',4,0,0,NULL,0),(13013,109,'2026-11-30',4,0,0,NULL,0),(13014,109,'2026-12-01',4,0,0,NULL,0),(13015,109,'2026-12-02',4,0,0,NULL,0),(13016,109,'2026-12-03',4,0,0,NULL,0),(13017,109,'2026-12-04',4,0,0,NULL,0),(13018,109,'2026-12-05',4,0,0,NULL,0),(13019,109,'2026-12-06',4,0,0,NULL,0),(13020,109,'2026-12-07',4,0,0,NULL,0),(13021,109,'2026-12-08',4,0,0,NULL,0),(13022,109,'2026-12-09',4,0,0,NULL,0),(13023,109,'2026-12-10',4,0,0,NULL,0),(13024,109,'2026-12-11',4,0,0,NULL,0),(13025,109,'2026-12-12',4,0,0,NULL,0),(13026,109,'2026-12-13',4,0,0,NULL,0),(13027,109,'2026-12-14',4,0,0,NULL,0),(13028,109,'2026-12-15',4,0,0,NULL,0),(13029,109,'2026-12-16',4,0,0,NULL,0),(13030,109,'2026-12-17',4,0,0,NULL,0),(13031,109,'2026-12-18',4,0,0,NULL,0),(13032,109,'2026-12-19',4,0,0,NULL,0),(13033,109,'2026-12-20',4,0,0,NULL,0),(13034,109,'2026-12-21',4,0,0,NULL,0),(13035,109,'2026-12-22',4,0,0,NULL,0),(13036,109,'2026-12-23',4,0,0,NULL,0),(13037,109,'2026-12-24',4,0,0,NULL,0),(13038,109,'2026-12-25',4,0,0,NULL,0),(13039,109,'2026-12-26',4,0,0,NULL,0),(13040,109,'2026-12-27',4,0,0,NULL,0),(13041,109,'2026-12-28',4,0,0,NULL,0),(13042,109,'2026-12-29',4,0,0,NULL,0),(13043,109,'2026-12-30',4,0,0,NULL,0),(13044,109,'2026-12-31',4,0,0,NULL,0),(13045,109,'2027-01-01',4,0,0,NULL,0),(13046,109,'2027-01-02',4,0,0,NULL,0),(13047,109,'2027-01-03',4,0,0,NULL,0),(13048,109,'2027-01-04',4,0,0,NULL,0),(13049,109,'2027-01-05',4,0,0,NULL,0),(13050,109,'2027-01-06',4,0,0,NULL,0),(13051,109,'2027-01-07',4,0,0,NULL,0),(13052,109,'2027-01-08',4,0,0,NULL,0),(13053,109,'2027-01-09',4,0,0,NULL,0),(13054,109,'2027-01-10',4,0,0,NULL,0),(13055,109,'2027-01-11',4,0,0,NULL,0),(13056,109,'2027-01-12',4,0,0,NULL,0),(13057,109,'2027-01-13',4,0,0,NULL,0),(13058,109,'2027-01-14',4,0,0,NULL,0),(13059,109,'2027-01-15',4,0,0,NULL,0),(13060,109,'2027-01-16',4,0,0,NULL,0),(13061,109,'2027-01-17',4,0,0,NULL,0),(13062,109,'2027-01-18',4,0,0,NULL,0),(13063,109,'2027-01-19',4,0,0,NULL,0),(13064,109,'2027-01-20',4,0,0,NULL,0),(13065,109,'2027-01-21',4,0,0,NULL,0),(13066,109,'2027-01-22',4,0,0,NULL,0),(13067,109,'2027-01-23',4,0,0,NULL,0),(13068,109,'2027-01-24',4,0,0,NULL,0),(13069,109,'2027-01-25',4,0,0,NULL,0),(13070,109,'2027-01-26',4,0,0,NULL,0),(13071,109,'2027-01-27',4,0,0,NULL,0),(13072,109,'2027-01-28',4,0,0,NULL,0),(13073,109,'2027-01-29',4,0,0,NULL,0),(13074,109,'2027-01-30',4,0,0,NULL,0),(13075,109,'2027-01-31',4,0,0,NULL,0),(13076,109,'2027-02-01',4,0,0,NULL,0),(13077,109,'2027-02-02',4,0,0,NULL,0),(13078,109,'2027-02-03',4,0,0,NULL,0),(13079,109,'2027-02-04',4,0,0,NULL,0),(13080,109,'2027-02-05',4,0,0,NULL,0),(13081,110,'2026-10-09',3,0,0,NULL,0),(13082,110,'2026-10-10',3,0,0,NULL,0),(13083,110,'2026-10-11',3,0,0,NULL,0),(13084,110,'2026-10-12',3,0,0,NULL,0),(13085,110,'2026-10-13',3,0,0,NULL,0),(13086,110,'2026-10-14',3,0,0,NULL,0),(13087,110,'2026-10-15',3,0,0,NULL,0),(13088,110,'2026-10-16',3,0,0,NULL,0),(13089,110,'2026-10-17',3,0,0,NULL,0),(13090,110,'2026-10-18',3,0,0,NULL,0),(13091,110,'2026-10-19',3,0,0,NULL,0),(13092,110,'2026-10-20',3,0,0,NULL,0),(13093,110,'2026-10-21',3,0,0,NULL,0),(13094,110,'2026-10-22',3,0,0,NULL,0),(13095,110,'2026-10-23',3,0,0,NULL,0),(13096,110,'2026-10-24',3,0,0,NULL,0),(13097,110,'2026-10-25',3,0,0,NULL,0),(13098,110,'2026-10-26',3,0,0,NULL,0),(13099,110,'2026-10-27',3,0,0,NULL,0),(13100,110,'2026-10-28',3,0,0,NULL,0),(13101,110,'2026-10-29',3,0,0,NULL,0),(13102,110,'2026-10-30',3,0,0,NULL,0),(13103,110,'2026-10-31',3,0,0,NULL,0),(13104,110,'2026-11-01',3,0,0,NULL,0),(13105,110,'2026-11-02',3,0,0,NULL,0),(13106,110,'2026-11-03',3,0,0,NULL,0),(13107,110,'2026-11-04',3,0,0,NULL,0),(13108,110,'2026-11-05',3,0,0,NULL,0),(13109,110,'2026-11-06',3,0,0,NULL,0),(13110,110,'2026-11-07',3,0,0,NULL,0),(13111,110,'2026-11-08',3,0,0,NULL,0),(13112,110,'2026-11-09',3,0,0,NULL,0),(13113,110,'2026-11-10',3,0,0,NULL,0),(13114,110,'2026-11-11',3,0,0,NULL,0),(13115,110,'2026-11-12',3,0,0,NULL,0),(13116,110,'2026-11-13',3,0,0,NULL,0),(13117,110,'2026-11-14',3,0,0,NULL,0),(13118,110,'2026-11-15',3,0,0,NULL,0),(13119,110,'2026-11-16',3,0,0,NULL,0),(13120,110,'2026-11-17',3,0,0,NULL,0),(13121,110,'2026-11-18',3,0,0,NULL,0),(13122,110,'2026-11-19',3,0,0,NULL,0),(13123,110,'2026-11-20',3,0,0,NULL,0),(13124,110,'2026-11-21',3,0,0,NULL,0),(13125,110,'2026-11-22',3,0,0,NULL,0),(13126,110,'2026-11-23',3,0,0,NULL,0),(13127,110,'2026-11-24',3,0,0,NULL,0),(13128,110,'2026-11-25',3,0,0,NULL,0),(13129,110,'2026-11-26',3,0,0,NULL,0),(13130,110,'2026-11-27',3,0,0,NULL,0),(13131,110,'2026-11-28',3,0,0,NULL,0),(13132,110,'2026-11-29',3,0,0,NULL,0),(13133,110,'2026-11-30',3,0,0,NULL,0),(13134,110,'2026-12-01',3,0,0,NULL,0),(13135,110,'2026-12-02',3,0,0,NULL,0),(13136,110,'2026-12-03',3,0,0,NULL,0),(13137,110,'2026-12-04',3,0,0,NULL,0),(13138,110,'2026-12-05',3,0,0,NULL,0),(13139,110,'2026-12-06',3,0,0,NULL,0),(13140,110,'2026-12-07',3,0,0,NULL,0),(13141,110,'2026-12-08',3,0,0,NULL,0),(13142,110,'2026-12-09',3,0,0,NULL,0),(13143,110,'2026-12-10',3,0,0,NULL,0),(13144,110,'2026-12-11',3,0,0,NULL,0),(13145,110,'2026-12-12',3,0,0,NULL,0),(13146,110,'2026-12-13',3,0,0,NULL,0),(13147,110,'2026-12-14',3,0,0,NULL,0),(13148,110,'2026-12-15',3,0,0,NULL,0),(13149,110,'2026-12-16',3,0,0,NULL,0),(13150,110,'2026-12-17',3,0,0,NULL,0),(13151,110,'2026-12-18',3,0,0,NULL,0),(13152,110,'2026-12-19',3,0,0,NULL,0),(13153,110,'2026-12-20',3,0,0,NULL,0),(13154,110,'2026-12-21',3,0,0,NULL,0),(13155,110,'2026-12-22',3,0,0,NULL,0),(13156,110,'2026-12-23',3,0,0,NULL,0),(13157,110,'2026-12-24',3,0,0,NULL,0),(13158,110,'2026-12-25',3,0,0,NULL,0),(13159,110,'2026-12-26',3,0,0,NULL,0),(13160,110,'2026-12-27',3,0,0,NULL,0),(13161,110,'2026-12-28',3,0,0,NULL,0),(13162,110,'2026-12-29',3,0,0,NULL,0),(13163,110,'2026-12-30',3,0,0,NULL,0),(13164,110,'2026-12-31',3,0,0,NULL,0),(13165,110,'2027-01-01',3,0,0,NULL,0),(13166,110,'2027-01-02',3,0,0,NULL,0),(13167,110,'2027-01-03',3,0,0,NULL,0),(13168,110,'2027-01-04',3,0,0,NULL,0),(13169,110,'2027-01-05',3,0,0,NULL,0),(13170,110,'2027-01-06',3,0,0,NULL,0),(13171,110,'2027-01-07',3,0,0,NULL,0),(13172,110,'2027-01-08',3,0,0,NULL,0),(13173,110,'2027-01-09',3,0,0,NULL,0),(13174,110,'2027-01-10',3,0,0,NULL,0),(13175,110,'2027-01-11',3,0,0,NULL,0),(13176,110,'2027-01-12',3,0,0,NULL,0),(13177,110,'2027-01-13',3,0,0,NULL,0),(13178,110,'2027-01-14',3,0,0,NULL,0),(13179,110,'2027-01-15',3,0,0,NULL,0),(13180,110,'2027-01-16',3,0,0,NULL,0),(13181,110,'2027-01-17',3,0,0,NULL,0),(13182,110,'2027-01-18',3,0,0,NULL,0),(13183,110,'2027-01-19',3,0,0,NULL,0),(13184,110,'2027-01-20',3,0,0,NULL,0),(13185,110,'2027-01-21',3,0,0,NULL,0),(13186,110,'2027-01-22',3,0,0,NULL,0),(13187,110,'2027-01-23',3,0,0,NULL,0),(13188,110,'2027-01-24',3,0,0,NULL,0),(13189,110,'2027-01-25',3,0,0,NULL,0),(13190,110,'2027-01-26',3,0,0,NULL,0),(13191,110,'2027-01-27',3,0,0,NULL,0),(13192,110,'2027-01-28',3,0,0,NULL,0),(13193,110,'2027-01-29',3,0,0,NULL,0),(13194,110,'2027-01-30',3,0,0,NULL,0),(13195,110,'2027-01-31',3,0,0,NULL,0),(13196,110,'2027-02-01',3,0,0,NULL,0),(13197,110,'2027-02-02',3,0,0,NULL,0),(13198,110,'2027-02-03',3,0,0,NULL,0),(13199,110,'2027-02-04',3,0,0,NULL,0),(13200,110,'2027-02-05',3,0,0,NULL,0);
/*!40000 ALTER TABLE `RoomInventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RoomType`
--

DROP TABLE IF EXISTS `RoomType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RoomType` (
  `id` int NOT NULL AUTO_INCREMENT,
  `propertyId` int NOT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `roomSize` int DEFAULT NULL,
  `bedType` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maxOccupancy` int NOT NULL DEFAULT '2',
  `totalRooms` int NOT NULL DEFAULT '1',
  `breakfastIncluded` tinyint(1) NOT NULL DEFAULT '0',
  `smokingAllowed` tinyint(1) NOT NULL DEFAULT '0',
  `basePricePerNight` int NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `RoomType_propertyId_idx` (`propertyId`),
  CONSTRAINT `RoomType_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomType`
--

LOCK TABLES `RoomType` WRITE;
/*!40000 ALTER TABLE `RoomType` DISABLE KEYS */;
INSERT INTO `RoomType` VALUES (80,38,'Phòng tiêu chuẩn',28,'1 giường đôi',2,6,1,0,850000,'Gọn gàng, ban công nhỏ nhìn ra vườn.'),(81,38,'Phòng Deluxe',28,'1 giường lớn',2,4,1,0,1250000,'Rộng rãi, cửa kính lớn view đồi thông.'),(82,38,'Phòng Family',28,'2 giường đôi',4,2,1,0,1800000,'Phù hợp gia đình 4 người.'),(83,39,'Phòng hướng biển',28,'1 giường lớn',2,5,1,0,1600000,'Ban công nhìn thẳng ra biển.'),(84,39,'Suite gia đình',28,'2 giường lớn',4,3,1,0,2600000,'Không gian rộng, bếp mini.'),(85,40,'Phòng vườn',28,'1 giường đôi',2,6,1,0,1100000,'Yên tĩnh, nhìn ra vườn.'),(86,40,'Phòng view sông',28,'1 giường lớn',2,3,1,0,1600000,'Ban công nhìn ra sông Hoài.'),(87,41,'Giường tầng (Dorm)',28,'Giường tầng',1,10,1,0,350000,'Tiết kiệm cho khách đi phượt.'),(88,41,'Cabin gỗ',28,'1 giường đôi',2,4,1,0,1200000,'Riêng tư, lò sưởi ấm áp.'),(89,42,'Phòng cộng đồng',28,'4 giường đơn',4,4,1,0,650000,'Ấm cúng cho nhóm bạn.'),(90,42,'Nhà sàn riêng',28,'1 giường lớn',2,3,1,0,1150000,'View đồi chè, bếp lửa.'),(91,43,'Bungalow vườn',28,'1 giường đôi',2,5,1,0,1250000,'Yên bình giữa vườn xanh.'),(92,43,'Villa núi đá',28,'2 giường lớn',4,2,1,0,2200000,'Hồ bơi riêng, view núi đá.'),(93,44,'Phòng vườn nhiệt đới',28,'1 giường đôi',2,6,1,0,1400000,'Gần biển, nhiều cây xanh.'),(94,44,'Bungalow hướng biển',28,'1 giường lớn',2,4,1,0,2300000,'Ngắm hoàng hôn ngay hiên.'),(95,45,'Phòng Studio',28,'1 giường đôi',2,5,1,0,900000,'Gọn gàng, trung tâm phố cổ.'),(96,45,'Căn hộ 1 phòng ngủ',28,'1 giường lớn',3,3,1,0,1500000,'Bếp riêng, ban công nhìn phố.'),(97,46,'Phòng tiêu chuẩn',28,'1 giường đôi',2,8,1,0,800000,'Tiện nghi, gần bến tàu.'),(98,46,'Bungalow view vịnh',28,'1 giường lớn',2,4,1,0,1600000,'Nhìn thẳng ra vịnh Lan Hạ.'),(99,47,'Lều glamping',28,'1 giường đôi',2,5,1,0,950000,'Cắm trại tiện nghi giữa đồi chè.'),(100,47,'Nhà gỗ view thác',28,'2 giường đôi',4,2,1,0,1900000,'Gia đình, nghe tiếng thác.'),(101,48,'Phòng hướng biển',28,'1 giường lớn',2,6,1,0,1050000,'Ban công nhìn ra biển, đón bình minh.'),(102,48,'Căn hộ 2 phòng ngủ',28,'2 giường lớn',4,3,1,0,1950000,'Rộng rãi cho nhóm/gia đình.'),(103,49,'Cabin ven hồ',28,'1 giường đôi',2,5,1,0,1300000,'View hồ, lò sưởi.'),(104,49,'Villa gỗ 2 phòng',28,'2 giường đôi',4,2,1,0,2400000,'Bếp riêng, hiên ngắm hồ.'),(105,50,'Phòng view vịnh',28,'1 giường lớn',2,6,1,0,1500000,'Nhìn thẳng ra vịnh di sản.'),(106,50,'Suite gia đình',28,'2 giường lớn',4,2,1,0,2700000,'Phòng khách riêng, bồn tắm.'),(107,51,'Phòng nhà dài Ê-đê',28,'2 giường đơn',2,5,1,0,600000,'Đậm bản sắc Tây Nguyên.'),(108,51,'Bungalow vườn',28,'1 giường đôi',2,3,1,0,1000000,'Yên tĩnh giữa vườn cà phê.'),(109,52,'Phòng tập thể',28,'4 giường đơn',4,4,1,0,550000,'Phù hợp nhóm bạn trẻ.'),(110,52,'Phòng đôi view núi',28,'1 giường đôi',2,3,1,0,900000,'Ban công ngắm bình minh trên mây.');
/*!40000 ALTER TABLE `RoomType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SystemConfig`
--

DROP TABLE IF EXISTS `SystemConfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SystemConfig` (
  `id` int NOT NULL DEFAULT '1',
  `depositRatePercent` int NOT NULL DEFAULT '30',
  `cancelFreeHours` int NOT NULL DEFAULT '24',
  `cancelTier1Days` int NOT NULL DEFAULT '7',
  `cancelTier1Ratio` int NOT NULL DEFAULT '100',
  `cancelTier2Days` int NOT NULL DEFAULT '3',
  `cancelTier2Ratio` int NOT NULL DEFAULT '50',
  `sellerName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'StayTour',
  `sellerAddress` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sellerPhone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sellerEmail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `siteNotice` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SystemConfig`
--

LOCK TABLES `SystemConfig` WRITE;
/*!40000 ALTER TABLE `SystemConfig` DISABLE KEYS */;
INSERT INTO `SystemConfig` VALUES (1,30,24,7,100,3,50,'StayTour',NULL,NULL,NULL,NULL,'2026-10-05 05:22:48.914');
/*!40000 ALTER TABLE `SystemConfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tour`
--

DROP TABLE IF EXISTS `Tour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tour` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tourCode` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `shortDescription` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `highlights` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `regionId` int DEFAULT NULL,
  `themeId` int DEFAULT NULL,
  `durationDays` int NOT NULL DEFAULT '1',
  `durationNights` int NOT NULL DEFAULT '0',
  `departurePoint` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destination` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meetingPoint` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `minPax` int NOT NULL DEFAULT '1',
  `maxPax` int NOT NULL DEFAULT '30',
  `guideLanguage` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `basePrice` int NOT NULL,
  `depositRate` int DEFAULT NULL,
  `cancellationPolicyId` int DEFAULT NULL,
  `avgRating` double NOT NULL DEFAULT '0',
  `reviewCount` int NOT NULL DEFAULT '0',
  `status` enum('DRAFT','VISIBLE','HIDDEN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `thumbnail` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `metaTitle` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metaDescription` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdById` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Tour_tourCode_key` (`tourCode`),
  UNIQUE KEY `Tour_slug_key` (`slug`),
  KEY `Tour_status_idx` (`status`),
  KEY `Tour_regionId_idx` (`regionId`),
  KEY `Tour_themeId_idx` (`themeId`),
  KEY `Tour_isFeatured_idx` (`isFeatured`),
  KEY `Tour_cancellationPolicyId_fkey` (`cancellationPolicyId`),
  KEY `Tour_createdById_fkey` (`createdById`),
  CONSTRAINT `Tour_cancellationPolicyId_fkey` FOREIGN KEY (`cancellationPolicyId`) REFERENCES `CancellationPolicy` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Tour_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `Admin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Tour_regionId_fkey` FOREIGN KEY (`regionId`) REFERENCES `Category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Tour_themeId_fkey` FOREIGN KEY (`themeId`) REFERENCES `Category` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tour`
--

LOCK TABLES `Tour` WRITE;
/*!40000 ALTER TABLE `Tour` DISABLE KEYS */;
INSERT INTO `Tour` VALUES (38,'TR001','Săn mây Tà Xùa 3N2Đ','san-may-ta-xua-3n2d','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.',NULL,NULL,NULL,3,2,'Hà Nội','Tà Xùa, Sơn La',NULL,1,25,NULL,2500000,30,6,4.5,2,'VISIBLE','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.895','2026-10-08 16:45:45.146'),(39,'TR002','Khám phá Hà Giang 4N3Đ','kham-pha-ha-giang-4n3d','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.',NULL,NULL,NULL,4,3,'Hà Nội','Hà Giang',NULL,1,25,NULL,3900000,30,6,5,1,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.917','2026-10-08 16:45:45.152'),(40,'TR003','Lý Sơn – Đảo tiên 2N1Đ','ly-son-dao-tien-2n1d','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.',NULL,NULL,NULL,2,1,'Đà Nẵng','Lý Sơn, Quảng Ngãi',NULL,1,25,NULL,1800000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.936','2026-10-08 16:45:43.936'),(41,'TR004','Kỳ Co – Eo Gió 1 ngày','ky-co-eo-gio-1-ngay','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.',NULL,NULL,NULL,1,0,'Quy Nhơn','Quy Nhơn, Bình Định',NULL,1,25,NULL,650000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.954','2026-10-08 16:45:43.954'),(42,'TR005','Phú Quốc – Thiên đường biển đảo 3N2Đ','phu-quoc-thien-duong-bien-dao-3n2d','Cáp treo Hòn Thơm, câu cá, lặn ngắm san hô và hoàng hôn Bãi Sao.','Cáp treo Hòn Thơm, câu cá, lặn ngắm san hô và hoàng hôn Bãi Sao.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Phú Quốc, Kiên Giang',NULL,1,25,NULL,3200000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.977','2026-10-08 16:45:43.977'),(43,'TR006','Tràng An – Bái Đính – Hang Múa 1 ngày','trang-an-bai-dinh-hang-mua-1-ngay','Du thuyền Tràng An, chùa Bái Đính và leo Hang Múa ngắm toàn cảnh.','Du thuyền Tràng An, chùa Bái Đính và leo Hang Múa ngắm toàn cảnh.',NULL,NULL,NULL,1,0,'Hà Nội','Ninh Bình',NULL,1,25,NULL,850000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:43.997','2026-10-08 16:45:43.997'),(44,'TR007','Mộc Châu mùa hoa 2N1Đ','moc-chau-mua-hoa-2n1d','Đồi chè trái tim, thác Dải Yếm, rừng thông bản Áng, vườn hoa.','Đồi chè trái tim, thác Dải Yếm, rừng thông bản Áng, vườn hoa.',NULL,NULL,NULL,2,1,'Hà Nội','Mộc Châu, Sơn La',NULL,1,25,NULL,1650000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.019','2026-10-08 16:45:44.019'),(45,'TR008','Huế – Hành trình di sản 2N1Đ','hue-hanh-trinh-di-san-2n1d','Đại Nội, lăng tẩm, chùa Thiên Mụ và thuyền rồng sông Hương.','Đại Nội, lăng tẩm, chùa Thiên Mụ và thuyền rồng sông Hương.',NULL,NULL,NULL,2,1,'Đà Nẵng','Huế, Thừa Thiên Huế',NULL,1,25,NULL,1950000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.042','2026-10-08 16:45:44.042'),(46,'TR009','Nha Trang – Tour 4 đảo 3N2Đ','nha-trang-tour-4-dao-3n2d','Khám phá 4 đảo, lặn biển, tắm bùn khoáng và VinWonders.','Khám phá 4 đảo, lặn biển, tắm bùn khoáng và VinWonders.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Nha Trang, Khánh Hòa',NULL,1,25,NULL,2800000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.063','2026-10-08 16:45:44.063'),(47,'TR010','Miền Tây – Chợ nổi Cái Răng 2N1Đ','mien-tay-cho-noi-cai-rang-2n1d','Chợ nổi Cái Răng, vườn trái cây, lò hủ tiếu và đờn ca tài tử.','Chợ nổi Cái Răng, vườn trái cây, lò hủ tiếu và đờn ca tài tử.',NULL,NULL,NULL,2,1,'TP. Hồ Chí Minh','Cần Thơ',NULL,1,25,NULL,1500000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.085','2026-10-08 16:45:44.085'),(48,'TR011','Đà Lạt – Thành phố ngàn hoa 3N2Đ','da-lat-thanh-pho-ngan-hoa-3n2d','Đồi chè Cầu Đất, Langbiang, thác Datanla và chợ đêm Đà Lạt.','Đồi chè Cầu Đất, Langbiang, thác Datanla và chợ đêm Đà Lạt.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Đà Lạt, Lâm Đồng',NULL,1,25,NULL,2400000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.107','2026-10-08 16:45:44.107'),(49,'TR012','Sa Pa – Chinh phục Fansipan 2N1Đ','sa-pa-chinh-phuc-fansipan-2n1d','Cáp treo Fansipan, bản Cát Cát, ruộng bậc thang và chợ vùng cao.','Cáp treo Fansipan, bản Cát Cát, ruộng bậc thang và chợ vùng cao.',NULL,NULL,NULL,2,1,'Hà Nội','Sa Pa, Lào Cai',NULL,1,25,NULL,2100000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.131','2026-10-08 16:45:44.131'),(50,'TR013','Côn Đảo – Hành trình tâm linh 3N2Đ','con-dao-hanh-trinh-tam-linh-3n2d','Viếng nghĩa trang Hàng Dương, lặn ngắm san hô và bãi Đầm Trầu.','Viếng nghĩa trang Hàng Dương, lặn ngắm san hô và bãi Đầm Trầu.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Côn Đảo, Bà Rịa – Vũng Tàu',NULL,1,25,NULL,4200000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.153','2026-10-08 16:45:44.153'),(51,'TR014','Quy Nhơn – Phú Yên biển xanh 3N2Đ','quy-nhon-phu-yen-bien-xanh-3n2d','Kỳ Co, Eo Gió, Gành Đá Đĩa và đầm Ô Loan thơ mộng.','Kỳ Co, Eo Gió, Gành Đá Đĩa và đầm Ô Loan thơ mộng.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Quy Nhơn – Phú Yên',NULL,1,25,NULL,2950000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.180','2026-10-08 16:45:44.180'),(52,'TR015','Hạ Long – Du thuyền vịnh Lan Hạ 2N1Đ','ha-long-du-thuyen-lan-ha-2n1d','Ngủ đêm trên du thuyền, chèo kayak hang Luồn, tắm biển đảo Ti Tốp.','Ngủ đêm trên du thuyền, chèo kayak hang Luồn, tắm biển đảo Ti Tốp.',NULL,NULL,NULL,2,1,'Hà Nội','Hạ Long – Lan Hạ',NULL,1,25,NULL,3600000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.206','2026-10-08 16:45:44.206'),(53,'TR016','Mù Cang Chải – Mùa vàng ruộng bậc thang 2N1Đ','mu-cang-chai-mua-vang-2n1d','Đồi Mâm Xôi, đèo Khau Phạ và mùa lúa chín vàng rực Tây Bắc.','Đồi Mâm Xôi, đèo Khau Phạ và mùa lúa chín vàng rực Tây Bắc.',NULL,NULL,NULL,2,1,'Hà Nội','Mù Cang Chải, Yên Bái',NULL,1,25,NULL,1750000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.227','2026-10-08 16:45:44.227'),(54,'TR017','Cao Bằng – Thác Bản Giốc & hang Pác Bó 3N2Đ','cao-bang-ban-gioc-pac-bo-3n2d','Thác Bản Giốc hùng vĩ, động Ngườm Ngao, suối Lê Nin – hang Pác Bó.','Thác Bản Giốc hùng vĩ, động Ngườm Ngao, suối Lê Nin – hang Pác Bó.',NULL,NULL,NULL,3,2,'Hà Nội','Cao Bằng',NULL,1,25,NULL,3100000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.249','2026-10-08 16:45:44.249'),(55,'TR018','Đà Nẵng – Bà Nà Hills – Hội An 3N2Đ','da-nang-ba-na-hoi-an-3n2d','Cầu Vàng Bà Nà, bán đảo Sơn Trà, phố cổ Hội An lung linh đèn lồng.','Cầu Vàng Bà Nà, bán đảo Sơn Trà, phố cổ Hội An lung linh đèn lồng.',NULL,NULL,NULL,3,2,'Hà Nội','Đà Nẵng – Hội An',NULL,1,25,NULL,2650000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.269','2026-10-08 16:45:44.269'),(56,'TR019','Tây Nguyên – Pleiku & Buôn Ma Thuột 3N2Đ','tay-nguyen-pleiku-bmt-3n2d','Biển Hồ Pleiku, thác Dray Nur, vườn cà phê và văn hóa cồng chiêng.','Biển Hồ Pleiku, thác Dray Nur, vườn cà phê và văn hóa cồng chiêng.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Gia Lai – Đắk Lắk',NULL,1,25,NULL,2550000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.289','2026-10-08 16:45:44.289'),(57,'TR020','Măng Đen – Đà Lạt thu nhỏ 2N1Đ','mang-den-2n1d','Rừng thông Măng Đen, thác Pa Sỹ, hồ Đắk Ke và chùa Khánh Lâm.','Rừng thông Măng Đen, thác Pa Sỹ, hồ Đắk Ke và chùa Khánh Lâm.',NULL,NULL,NULL,2,1,'Đà Nẵng','Măng Đen, Kon Tum',NULL,1,25,NULL,1600000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.309','2026-10-08 16:45:44.309'),(58,'TR021','Đảo Nam Du – Thiên đường hoang sơ 3N2Đ','dao-nam-du-3n2d','Lặn ngắm san hô, câu cá, bãi Mến hoang sơ và hải sản tươi rói.','Lặn ngắm san hô, câu cá, bãi Mến hoang sơ và hải sản tươi rói.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Nam Du, Kiên Giang',NULL,1,25,NULL,2900000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.329','2026-10-08 16:45:44.329'),(59,'TR022','Hà Nội – City Tour & Foodtour 1 ngày','ha-noi-city-foodtour-1-ngay','Văn Miếu, Hồ Gươm, phố cổ và thưởng thức đặc sản ẩm thực Hà thành.','Văn Miếu, Hồ Gươm, phố cổ và thưởng thức đặc sản ẩm thực Hà thành.',NULL,NULL,NULL,1,0,'Hà Nội','Hà Nội',NULL,1,25,NULL,750000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.352','2026-10-08 16:45:44.352'),(60,'TR023','Ninh Bình – Tam Chúc – Chùa Hương 2N1Đ','ninh-binh-tam-chuc-chua-huong-2n1d','Chùa Tam Chúc lớn nhất thế giới, Tràng An và hành hương chùa Hương.','Chùa Tam Chúc lớn nhất thế giới, Tràng An và hành hương chùa Hương.',NULL,NULL,NULL,2,1,'Hà Nội','Ninh Bình – Hà Nam',NULL,1,25,NULL,1450000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.373','2026-10-08 16:45:44.373'),(61,'TR024','Phong Nha – Kẻ Bàng khám phá hang động 2N1Đ','phong-nha-ke-bang-2n1d','Động Phong Nha, động Thiên Đường và sông Chày – Hang Tối mạo hiểm.','Động Phong Nha, động Thiên Đường và sông Chày – Hang Tối mạo hiểm.',NULL,NULL,NULL,2,1,'Đà Nẵng','Quảng Bình',NULL,1,25,NULL,2350000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.394','2026-10-08 16:45:44.394'),(62,'TR025','Đảo Bình Ba – Đảo tôm hùm 2N1Đ','dao-binh-ba-2n1d','Lặn biển ngắm san hô, bãi Chướng – bãi Nồm và thưởng thức tôm hùm.','Lặn biển ngắm san hô, bãi Chướng – bãi Nồm và thưởng thức tôm hùm.',NULL,NULL,NULL,2,1,'TP. Hồ Chí Minh','Bình Ba, Khánh Hòa',NULL,1,25,NULL,1850000,30,6,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-08 16:45:44.415','2026-10-08 16:45:44.415');
/*!40000 ALTER TABLE `Tour` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TourDeparture`
--

DROP TABLE IF EXISTS `TourDeparture`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TourDeparture` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tourId` int NOT NULL,
  `departureDate` date NOT NULL,
  `returnDate` date DEFAULT NULL,
  `totalSlots` int NOT NULL,
  `bookedSlots` int NOT NULL DEFAULT '0',
  `heldSlots` int NOT NULL DEFAULT '0',
  `status` enum('OPEN','CLOSED','FULL','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  `guideName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `TourDeparture_tourId_idx` (`tourId`),
  CONSTRAINT `TourDeparture_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourDeparture`
--

LOCK TABLES `TourDeparture` WRITE;
/*!40000 ALTER TABLE `TourDeparture` DISABLE KEYS */;
INSERT INTO `TourDeparture` VALUES (112,38,'2026-10-18','2026-10-20',20,2,0,'OPEN',NULL),(113,38,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(114,38,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(115,39,'2026-10-18','2026-10-21',20,0,0,'OPEN',NULL),(116,39,'2026-11-01','2026-11-04',20,0,0,'OPEN',NULL),(117,39,'2026-11-17','2026-11-20',20,0,0,'OPEN',NULL),(118,40,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(119,40,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(120,40,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(121,41,'2026-10-18','2026-10-18',20,0,0,'OPEN',NULL),(122,41,'2026-11-01','2026-11-01',20,0,0,'OPEN',NULL),(123,41,'2026-11-17','2026-11-17',20,0,0,'OPEN',NULL),(124,42,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(125,42,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(126,42,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(127,43,'2026-10-18','2026-10-18',20,0,0,'OPEN',NULL),(128,43,'2026-11-01','2026-11-01',20,0,0,'OPEN',NULL),(129,43,'2026-11-17','2026-11-17',20,0,0,'OPEN',NULL),(130,44,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(131,44,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(132,44,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(133,45,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(134,45,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(135,45,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(136,46,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(137,46,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(138,46,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(139,47,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(140,47,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(141,47,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(142,48,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(143,48,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(144,48,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(145,49,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(146,49,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(147,49,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(148,50,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(149,50,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(150,50,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(151,51,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(152,51,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(153,51,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(154,52,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(155,52,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(156,52,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(157,53,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(158,53,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(159,53,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(160,54,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(161,54,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(162,54,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(163,55,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(164,55,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(165,55,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(166,56,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(167,56,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(168,56,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(169,57,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(170,57,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(171,57,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(172,58,'2026-10-18','2026-10-20',20,0,0,'OPEN',NULL),(173,58,'2026-11-01','2026-11-03',20,0,0,'OPEN',NULL),(174,58,'2026-11-17','2026-11-19',20,0,0,'OPEN',NULL),(175,59,'2026-10-18','2026-10-18',20,0,0,'OPEN',NULL),(176,59,'2026-11-01','2026-11-01',20,0,0,'OPEN',NULL),(177,59,'2026-11-17','2026-11-17',20,0,0,'OPEN',NULL),(178,60,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(179,60,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(180,60,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(181,61,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(182,61,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(183,61,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL),(184,62,'2026-10-18','2026-10-19',20,0,0,'OPEN',NULL),(185,62,'2026-11-01','2026-11-02',20,0,0,'OPEN',NULL),(186,62,'2026-11-17','2026-11-18',20,0,0,'OPEN',NULL);
/*!40000 ALTER TABLE `TourDeparture` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TourImage`
--

DROP TABLE IF EXISTS `TourImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TourImage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tourId` int NOT NULL,
  `url` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isCover` tinyint(1) NOT NULL DEFAULT '0',
  `sortOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `TourImage_tourId_idx` (`tourId`),
  CONSTRAINT `TourImage_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourImage`
--

LOCK TABLES `TourImage` WRITE;
/*!40000 ALTER TABLE `TourImage` DISABLE KEYS */;
INSERT INTO `TourImage` VALUES (76,38,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(77,38,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(78,38,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(79,38,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(80,38,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(81,39,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(82,39,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(83,39,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(84,39,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(85,39,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(86,40,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(87,40,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(88,40,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(89,40,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(90,40,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(91,41,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(92,41,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(93,41,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(94,41,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(95,41,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(96,42,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(97,42,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(98,42,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(99,42,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(100,42,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(101,43,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(102,43,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(103,43,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(104,43,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(105,43,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(106,44,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(107,44,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(108,44,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(109,44,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(110,44,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(111,45,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(112,45,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(113,45,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(114,45,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(115,45,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(116,46,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(117,46,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(118,46,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(119,46,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(120,46,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(121,47,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(122,47,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(123,47,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(124,47,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(125,47,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(126,48,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(127,48,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(128,48,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(129,48,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(130,48,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(131,49,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(132,49,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(133,49,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(134,49,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(135,49,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(136,50,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(137,50,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(138,50,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(139,50,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(140,50,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(141,51,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(142,51,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(143,51,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(144,51,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(145,51,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(146,52,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(147,52,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(148,52,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(149,52,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(150,52,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(151,53,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(152,53,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(153,53,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(154,53,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(155,53,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(156,54,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(157,54,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(158,54,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(159,54,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(160,54,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(161,55,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(162,55,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(163,55,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(164,55,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(165,55,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(166,56,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(167,56,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(168,56,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(169,56,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(170,56,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(171,57,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(172,57,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(173,57,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(174,57,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(175,57,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(176,58,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(177,58,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(178,58,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(179,58,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(180,58,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(181,59,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(182,59,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(183,59,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(184,59,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(185,59,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(186,60,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(187,60,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(188,60,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(189,60,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(190,60,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(191,61,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(192,61,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(193,61,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(194,61,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(195,61,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(196,62,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(197,62,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(198,62,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(199,62,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(200,62,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4);
/*!40000 ALTER TABLE `TourImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TourInclusion`
--

DROP TABLE IF EXISTS `TourInclusion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TourInclusion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tourId` int NOT NULL,
  `type` enum('INCLUDED','EXCLUDED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemText` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sortOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `TourInclusion_tourId_idx` (`tourId`),
  CONSTRAINT `TourInclusion_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourInclusion`
--

LOCK TABLES `TourInclusion` WRITE;
/*!40000 ALTER TABLE `TourInclusion` DISABLE KEYS */;
/*!40000 ALTER TABLE `TourInclusion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TourItinerary`
--

DROP TABLE IF EXISTS `TourItinerary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TourItinerary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tourId` int NOT NULL,
  `dayNumber` int NOT NULL,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `meals` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accommodation` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `TourItinerary_tourId_idx` (`tourId`),
  CONSTRAINT `TourItinerary_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourItinerary`
--

LOCK TABLES `TourItinerary` WRITE;
/*!40000 ALTER TABLE `TourItinerary` DISABLE KEYS */;
/*!40000 ALTER TABLE `TourItinerary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TourNote`
--

DROP TABLE IF EXISTS `TourNote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TourNote` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tourId` int NOT NULL,
  `type` enum('TERM','FAQ','REDEMPTION') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sortOrder` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `TourNote_tourId_idx` (`tourId`),
  CONSTRAINT `TourNote_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourNote`
--

LOCK TABLES `TourNote` WRITE;
/*!40000 ALTER TABLE `TourNote` DISABLE KEYS */;
/*!40000 ALTER TABLE `TourNote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TourPrice`
--

DROP TABLE IF EXISTS `TourPrice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TourPrice` (
  `id` int NOT NULL AUTO_INCREMENT,
  `departureId` int NOT NULL,
  `paxType` enum('ADULT','CHILD','INFANT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int NOT NULL,
  `description` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requiresProof` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `TourPrice_departureId_paxType_key` (`departureId`,`paxType`),
  KEY `TourPrice_departureId_idx` (`departureId`),
  CONSTRAINT `TourPrice_departureId_fkey` FOREIGN KEY (`departureId`) REFERENCES `TourDeparture` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=373 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourPrice`
--

LOCK TABLES `TourPrice` WRITE;
/*!40000 ALTER TABLE `TourPrice` DISABLE KEYS */;
INSERT INTO `TourPrice` VALUES (223,112,'ADULT',2500000,'Người lớn',0),(224,112,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(225,113,'ADULT',2500000,'Người lớn',0),(226,113,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(227,114,'ADULT',2500000,'Người lớn',0),(228,114,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(229,115,'ADULT',3900000,'Người lớn',0),(230,115,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(231,116,'ADULT',3900000,'Người lớn',0),(232,116,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(233,117,'ADULT',3900000,'Người lớn',0),(234,117,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(235,118,'ADULT',1800000,'Người lớn',0),(236,118,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(237,119,'ADULT',1800000,'Người lớn',0),(238,119,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(239,120,'ADULT',1800000,'Người lớn',0),(240,120,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(241,121,'ADULT',650000,'Người lớn',0),(242,121,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(243,122,'ADULT',650000,'Người lớn',0),(244,122,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(245,123,'ADULT',650000,'Người lớn',0),(246,123,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(247,124,'ADULT',3200000,'Người lớn',0),(248,124,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(249,125,'ADULT',3200000,'Người lớn',0),(250,125,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(251,126,'ADULT',3200000,'Người lớn',0),(252,126,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(253,127,'ADULT',850000,'Người lớn',0),(254,127,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(255,128,'ADULT',850000,'Người lớn',0),(256,128,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(257,129,'ADULT',850000,'Người lớn',0),(258,129,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(259,130,'ADULT',1650000,'Người lớn',0),(260,130,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(261,131,'ADULT',1650000,'Người lớn',0),(262,131,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(263,132,'ADULT',1650000,'Người lớn',0),(264,132,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(265,133,'ADULT',1950000,'Người lớn',0),(266,133,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(267,134,'ADULT',1950000,'Người lớn',0),(268,134,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(269,135,'ADULT',1950000,'Người lớn',0),(270,135,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(271,136,'ADULT',2800000,'Người lớn',0),(272,136,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(273,137,'ADULT',2800000,'Người lớn',0),(274,137,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(275,138,'ADULT',2800000,'Người lớn',0),(276,138,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(277,139,'ADULT',1500000,'Người lớn',0),(278,139,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(279,140,'ADULT',1500000,'Người lớn',0),(280,140,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(281,141,'ADULT',1500000,'Người lớn',0),(282,141,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(283,142,'ADULT',2400000,'Người lớn',0),(284,142,'CHILD',1680000,'Trẻ em 5–11 tuổi',0),(285,143,'ADULT',2400000,'Người lớn',0),(286,143,'CHILD',1680000,'Trẻ em 5–11 tuổi',0),(287,144,'ADULT',2400000,'Người lớn',0),(288,144,'CHILD',1680000,'Trẻ em 5–11 tuổi',0),(289,145,'ADULT',2100000,'Người lớn',0),(290,145,'CHILD',1470000,'Trẻ em 5–11 tuổi',0),(291,146,'ADULT',2100000,'Người lớn',0),(292,146,'CHILD',1470000,'Trẻ em 5–11 tuổi',0),(293,147,'ADULT',2100000,'Người lớn',0),(294,147,'CHILD',1470000,'Trẻ em 5–11 tuổi',0),(295,148,'ADULT',4200000,'Người lớn',0),(296,148,'CHILD',2940000,'Trẻ em 5–11 tuổi',0),(297,149,'ADULT',4200000,'Người lớn',0),(298,149,'CHILD',2940000,'Trẻ em 5–11 tuổi',0),(299,150,'ADULT',4200000,'Người lớn',0),(300,150,'CHILD',2940000,'Trẻ em 5–11 tuổi',0),(301,151,'ADULT',2950000,'Người lớn',0),(302,151,'CHILD',2065000,'Trẻ em 5–11 tuổi',0),(303,152,'ADULT',2950000,'Người lớn',0),(304,152,'CHILD',2065000,'Trẻ em 5–11 tuổi',0),(305,153,'ADULT',2950000,'Người lớn',0),(306,153,'CHILD',2065000,'Trẻ em 5–11 tuổi',0),(307,154,'ADULT',3600000,'Người lớn',0),(308,154,'CHILD',2520000,'Trẻ em 5–11 tuổi',0),(309,155,'ADULT',3600000,'Người lớn',0),(310,155,'CHILD',2520000,'Trẻ em 5–11 tuổi',0),(311,156,'ADULT',3600000,'Người lớn',0),(312,156,'CHILD',2520000,'Trẻ em 5–11 tuổi',0),(313,157,'ADULT',1750000,'Người lớn',0),(314,157,'CHILD',1225000,'Trẻ em 5–11 tuổi',0),(315,158,'ADULT',1750000,'Người lớn',0),(316,158,'CHILD',1225000,'Trẻ em 5–11 tuổi',0),(317,159,'ADULT',1750000,'Người lớn',0),(318,159,'CHILD',1225000,'Trẻ em 5–11 tuổi',0),(319,160,'ADULT',3100000,'Người lớn',0),(320,160,'CHILD',2170000,'Trẻ em 5–11 tuổi',0),(321,161,'ADULT',3100000,'Người lớn',0),(322,161,'CHILD',2170000,'Trẻ em 5–11 tuổi',0),(323,162,'ADULT',3100000,'Người lớn',0),(324,162,'CHILD',2170000,'Trẻ em 5–11 tuổi',0),(325,163,'ADULT',2650000,'Người lớn',0),(326,163,'CHILD',1855000,'Trẻ em 5–11 tuổi',0),(327,164,'ADULT',2650000,'Người lớn',0),(328,164,'CHILD',1855000,'Trẻ em 5–11 tuổi',0),(329,165,'ADULT',2650000,'Người lớn',0),(330,165,'CHILD',1855000,'Trẻ em 5–11 tuổi',0),(331,166,'ADULT',2550000,'Người lớn',0),(332,166,'CHILD',1785000,'Trẻ em 5–11 tuổi',0),(333,167,'ADULT',2550000,'Người lớn',0),(334,167,'CHILD',1785000,'Trẻ em 5–11 tuổi',0),(335,168,'ADULT',2550000,'Người lớn',0),(336,168,'CHILD',1785000,'Trẻ em 5–11 tuổi',0),(337,169,'ADULT',1600000,'Người lớn',0),(338,169,'CHILD',1120000,'Trẻ em 5–11 tuổi',0),(339,170,'ADULT',1600000,'Người lớn',0),(340,170,'CHILD',1120000,'Trẻ em 5–11 tuổi',0),(341,171,'ADULT',1600000,'Người lớn',0),(342,171,'CHILD',1120000,'Trẻ em 5–11 tuổi',0),(343,172,'ADULT',2900000,'Người lớn',0),(344,172,'CHILD',2030000,'Trẻ em 5–11 tuổi',0),(345,173,'ADULT',2900000,'Người lớn',0),(346,173,'CHILD',2030000,'Trẻ em 5–11 tuổi',0),(347,174,'ADULT',2900000,'Người lớn',0),(348,174,'CHILD',2030000,'Trẻ em 5–11 tuổi',0),(349,175,'ADULT',750000,'Người lớn',0),(350,175,'CHILD',525000,'Trẻ em 5–11 tuổi',0),(351,176,'ADULT',750000,'Người lớn',0),(352,176,'CHILD',525000,'Trẻ em 5–11 tuổi',0),(353,177,'ADULT',750000,'Người lớn',0),(354,177,'CHILD',525000,'Trẻ em 5–11 tuổi',0),(355,178,'ADULT',1450000,'Người lớn',0),(356,178,'CHILD',1015000,'Trẻ em 5–11 tuổi',0),(357,179,'ADULT',1450000,'Người lớn',0),(358,179,'CHILD',1015000,'Trẻ em 5–11 tuổi',0),(359,180,'ADULT',1450000,'Người lớn',0),(360,180,'CHILD',1015000,'Trẻ em 5–11 tuổi',0),(361,181,'ADULT',2350000,'Người lớn',0),(362,181,'CHILD',1645000,'Trẻ em 5–11 tuổi',0),(363,182,'ADULT',2350000,'Người lớn',0),(364,182,'CHILD',1645000,'Trẻ em 5–11 tuổi',0),(365,183,'ADULT',2350000,'Người lớn',0),(366,183,'CHILD',1645000,'Trẻ em 5–11 tuổi',0),(367,184,'ADULT',1850000,'Người lớn',0),(368,184,'CHILD',1295000,'Trẻ em 5–11 tuổi',0),(369,185,'ADULT',1850000,'Người lớn',0),(370,185,'CHILD',1295000,'Trẻ em 5–11 tuổi',0),(371,186,'ADULT',1850000,'Người lớn',0),(372,186,'CHILD',1295000,'Trẻ em 5–11 tuổi',0);
/*!40000 ALTER TABLE `TourPrice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TravelGuide`
--

DROP TABLE IF EXISTS `TravelGuide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TravelGuide` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `authorName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coverImage` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `excerpt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `locationName` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `publishedAt` datetime(3) DEFAULT NULL,
  `status` enum('DRAFT','VISIBLE','HIDDEN') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `createdById` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `TravelGuide_slug_key` (`slug`),
  KEY `TravelGuide_status_idx` (`status`),
  KEY `TravelGuide_publishedAt_idx` (`publishedAt`),
  KEY `TravelGuide_createdById_fkey` (`createdById`),
  CONSTRAINT `TravelGuide_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `Admin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TravelGuide`
--

LOCK TABLES `TravelGuide` WRITE;
/*!40000 ALTER TABLE `TravelGuide` DISABLE KEYS */;
INSERT INTO `TravelGuide` VALUES (6,'Kinh nghiệm du lịch Đà Lạt 3 ngày 2 đêm','kinh-nghiem-du-lich-da-lat-3n2d','Ban biên tập StayTour','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70','Gợi ý lịch trình Đà Lạt tiết kiệm cho nhóm bạn.','Ngày 1: khám phá trung tâm, chợ đêm Đà Lạt.\nNgày 2: đồi chè Cầu Đất, săn mây.\nNgày 3: vườn hoa, mua đặc sản về làm quà.','Đà Lạt, Lâm Đồng',NULL,NULL,'2026-10-08 16:45:44.450','VISIBLE',NULL,'2026-10-08 16:45:44.451','2026-10-08 16:45:44.451');
/*!40000 ALTER TABLE `TravelGuide` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TravelGuideTour`
--

DROP TABLE IF EXISTS `TravelGuideTour`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TravelGuideTour` (
  `guideId` int NOT NULL,
  `tourId` int NOT NULL,
  PRIMARY KEY (`guideId`,`tourId`),
  KEY `TravelGuideTour_tourId_idx` (`tourId`),
  CONSTRAINT `TravelGuideTour_guideId_fkey` FOREIGN KEY (`guideId`) REFERENCES `TravelGuide` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `TravelGuideTour_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TravelGuideTour`
--

LOCK TABLES `TravelGuideTour` WRITE;
/*!40000 ALTER TABLE `TravelGuideTour` DISABLE KEYS */;
/*!40000 ALTER TABLE `TravelGuideTour` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dateOfBirth` datetime(3) DEFAULT NULL,
  `gender` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nationality` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idNumber` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `googleId` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emailVerified` tinyint(1) NOT NULL DEFAULT '0',
  `acceptedTerms` tinyint(1) NOT NULL DEFAULT '0',
  `failedLoginAttempts` int NOT NULL DEFAULT '0',
  `lockedUntil` datetime(3) DEFAULT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `User_email_key` (`email`),
  UNIQUE KEY `User_googleId_key` (`googleId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (2,'khachhang@gmail.com','$2a$10$L2sMTJ1ZWngipKnClOCmRulkZcyJjWKscvf2mlR2CRWMnxEPSRZdm','Nguyễn Minh Anh','0905123456','12 Nguyễn Trãi, Thanh Xuân','1998-04-12 00:00:00.000','FEMALE','Việt Nam','001198000123','Hà Nội',NULL,NULL,1,1,0,NULL,0,'2026-10-06 14:00:55.092','2026-10-07 09:14:23.699'),(3,'ha.tran@gmail.com','$2a$10$L2sMTJ1ZWngipKnClOCmRulkZcyJjWKscvf2mlR2CRWMnxEPSRZdm','Trần Thu Hà','0912345678','45 Lê Lợi, Quận 1','1995-09-02 00:00:00.000','FEMALE','Việt Nam','079095000456','TP. Hồ Chí Minh',NULL,NULL,1,1,0,NULL,0,'2026-10-06 14:00:55.104','2026-10-06 14:00:55.104');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-08 16:45:57
