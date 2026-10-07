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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Area`
--

LOCK TABLES `Area` WRITE;
/*!40000 ALTER TABLE `Area` DISABLE KEYS */;
INSERT INTO `Area` VALUES (13,'Đà Lạt','da-lat','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1),(14,'Đà Nẵng','da-nang','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',2),(15,'Hội An','hoi-an','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',3),(16,'Sa Pa','sa-pa','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',4);
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Booking`
--

LOCK TABLES `Booking` WRITE;
/*!40000 ALTER TABLE `Booking` DISABLE KEYS */;
INSERT INTO `Booking` VALUES (10,'BK-62TBB8X92',NULL,'HOMESTAY','DEPOSITED',NULL,13,28,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Nhận phòng muộn ~21h. Xin phòng tầng cao, yên tĩnh.','2026-10-27','2026-10-29',2,2,0,1700000,510000,1190000,'VNPAY',NULL,'2026-09-27 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:28:16.451','2026-10-07 09:28:16.451',0,NULL,NULL),(11,'BK-FDN5MGW92',NULL,'HOMESTAY','PENDING_DEPOSIT',NULL,14,31,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Cần thêm 1 giường phụ cho trẻ em.','2026-11-11','2026-11-13',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-07 09:43:16.466','2026-10-07 09:28:16.467','2026-10-07 09:28:16.467',0,NULL,NULL),(12,'BK-QYFJ79XW6',NULL,'HOMESTAY','COMPLETED',NULL,15,33,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Kỳ nghỉ gia đình.','2026-09-17','2026-09-19',2,2,0,2200000,660000,1540000,'VNPAY',NULL,'2026-08-18 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:28:16.475','2026-10-07 09:28:16.475',0,NULL,NULL),(13,'BK-LQDKQRHEF',NULL,'TOUR','CONFIRMED',NULL,NULL,NULL,13,37,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Ăn chay 1 suất.','2026-10-17','2026-10-19',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-02 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:28:16.483','2026-10-07 09:28:16.483',0,NULL,NULL),(14,'BK-4JS3C8RWT',NULL,'TOUR','COMPLETED',NULL,NULL,NULL,14,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456',NULL,'2026-10-22','2026-10-22',3,2,0,7800000,2340000,5460000,'COD',NULL,'2026-10-02 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:28:16.492','2026-10-07 09:28:16.492',0,NULL,NULL),(15,'BK-4JDQ7JWUS',NULL,'TOUR','CANCELLED',NULL,NULL,NULL,13,37,3,'Trần Thu Hà','ha.tran@gmail.com','0912345678','Bận việc đột xuất.','2026-10-17','2026-10-19',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-02 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:28:16.500','2026-10-07 09:28:16.500',0,NULL,'2026-10-05 00:00:00.000'),(16,'BK-2PP9QUCAH','dec58ab7d7f9fb6bd366cea633274ef3632f8eaa823bf811c14bed255d60e339','HOMESTAY','COMPLETED',NULL,13,28,NULL,NULL,NULL,'Lê Văn Khách','khachvanglai@example.com','0988777666',NULL,'2026-09-22','2026-09-24',2,2,0,1700000,510000,1190000,'COD',NULL,'2026-08-23 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:28:16.508','2026-10-07 09:28:16.508',0,NULL,NULL),(17,'BK-VB6HTGJVQ','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','HOMESTAY','PENDING_DEPOSIT',NULL,14,31,NULL,NULL,NULL,'Phạm Thu Trang','guest.track@example.com','0977555444','Đặt hộ bạn.','2026-10-17','2026-10-19',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-07 09:43:16.516','2026-10-07 09:28:16.517','2026-10-07 09:28:16.517',0,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CancellationPolicy`
--

LOCK TABLES `CancellationPolicy` WRITE;
/*!40000 ALTER TABLE `CancellationPolicy` DISABLE KEYS */;
INSERT INTO `CancellationPolicy` VALUES (1,'Linh hoạt tiêu chuẩn',1,24,'2026-10-05 04:43:05.829','2026-10-05 04:43:05.829'),(2,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:53:11.058','2026-10-06 13:53:11.058'),(3,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:59:38.411','2026-10-06 13:59:38.411'),(4,'Linh hoạt tiêu chuẩn',1,24,'2026-10-07 09:28:10.465','2026-10-07 09:28:10.465');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DiscountCode`
--

LOCK TABLES `DiscountCode` WRITE;
/*!40000 ALTER TABLE `DiscountCode` DISABLE KEYS */;
INSERT INTO `DiscountCode` VALUES (7,'STAYTOUR10','PERCENT',10,500000,'ALL',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-07 09:28:10.932'),(8,'HE2026','FIXED',150000,1000000,'HOMESTAY',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-07 09:28:10.932');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Favorite`
--

LOCK TABLES `Favorite` WRITE;
/*!40000 ALTER TABLE `Favorite` DISABLE KEYS */;
INSERT INTO `Favorite` VALUES (4,2,NULL,13,NULL,'2026-10-07 09:28:16.537'),(5,2,NULL,NULL,13,'2026-10-07 09:28:16.540'),(6,3,NULL,15,NULL,'2026-10-07 09:28:16.544');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InfoArticle`
--

LOCK TABLES `InfoArticle` WRITE;
/*!40000 ALTER TABLE `InfoArticle` DISABLE KEYS */;
INSERT INTO `InfoArticle` VALUES (13,'gioi-thieu','Thông tin người bán','ABOUT','Về StayTour','StayTour là nền tảng đặt homestay và tour du lịch nội địa.',1,1,'2026-10-07 09:28:10.935','2026-10-07 09:28:10.935'),(14,'dieu-kien-giao-dich','Điều kiện giao dịch chung','POLICY','Điều khoản','Các điều kiện và điều khoản giao dịch chung khi sử dụng StayTour.',1,2,'2026-10-07 09:28:10.935','2026-10-07 09:28:10.935'),(15,'chinh-sach-doi-tra-huy','Chính sách đổi – trả – hủy','POLICY','Hủy & hoàn tiền','Chính sách hủy đặt chỗ và hoàn tiền theo từng mốc thời gian.',1,3,'2026-10-07 09:28:10.935','2026-10-07 09:28:10.935'),(16,'bao-mat-du-lieu','Bảo vệ dữ liệu cá nhân','POLICY','Bảo mật','Cam kết bảo vệ dữ liệu cá nhân của khách hàng.',1,4,'2026-10-07 09:28:10.935','2026-10-07 09:28:10.935');
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment`
--

LOCK TABLES `Payment` WRITE;
/*!40000 ALTER TABLE `Payment` DISABLE KEYS */;
INSERT INTO `Payment` VALUES (8,10,'VNPAY',510000,'SUCCESS','VNP1791365296449','2026-10-07 09:28:16.456'),(9,12,'VNPAY',660000,'SUCCESS','VNP1791365291474','2026-10-07 09:28:16.478'),(10,13,'VNPAY',1500000,'SUCCESS','VNP1791365287482','2026-10-07 09:28:16.486'),(11,14,'COD',2340000,'SUCCESS',NULL,'2026-10-07 09:28:16.495'),(12,15,'VNPAY',1500000,'SUCCESS','VNP1791365284499','2026-10-07 09:28:16.503'),(13,16,'COD',510000,'SUCCESS',NULL,'2026-10-07 09:28:16.511');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PolicyMilestone`
--

LOCK TABLES `PolicyMilestone` WRITE;
/*!40000 ALTER TABLE `PolicyMilestone` DISABLE KEYS */;
INSERT INTO `PolicyMilestone` VALUES (1,1,7,100),(2,1,3,50),(3,2,7,100),(4,2,3,50),(5,3,7,100),(6,3,3,50),(7,4,7,100),(8,4,3,50);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
INSERT INTO `Promotion` VALUES (7,'Giảm 20% đặt homestay dịp lễ','Áp dụng cho đơn đặt trước 7 ngày.','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,'2026-10-07 09:28:10.930'),(8,'Tour Tây Bắc mùa săn mây','Ưu đãi nhóm từ 4 khách trở lên.','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,'2026-10-07 09:28:10.930');
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Property`
--

LOCK TABLES `Property` WRITE;
/*!40000 ALTER TABLE `Property` DISABLE KEYS */;
INSERT INTO `Property` VALUES (13,'HS001','Pine Hill Homestay','pine-hill-homestay','HOMESTAY',NULL,'Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.','Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.',NULL,NULL,'Đà Lạt, Lâm Đồng',NULL,NULL,'14:00','12:00',850000,30,4,4.5,2,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.472','2026-10-07 09:28:16.549'),(14,'HS002','Biển Ngọc Villa','bien-ngoc-villa','HOMESTAY',NULL,'Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.','Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.',NULL,NULL,'Mỹ Khê, Đà Nẵng',NULL,NULL,'14:00','12:00',1600000,30,4,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.515','2026-10-07 09:28:16.554'),(15,'HS003','Sông Trăng Riverside','song-trang-riverside','HOMESTAY',NULL,'Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.','Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.',NULL,NULL,'Hội An, Quảng Nam',NULL,NULL,'14:00','12:00',1100000,30,4,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.544','2026-10-07 09:28:16.559'),(16,'HS004','Nhà Của Rừng','nha-cua-rung-sapa','HOMESTAY',NULL,'Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.','Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.',NULL,NULL,'Sa Pa, Lào Cai',NULL,NULL,'14:00','12:00',700000,30,4,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.567','2026-10-07 09:28:10.567'),(17,'HS005','Mộc Châu Mộc Homestay','moc-chau-moc-homestay','HOMESTAY',NULL,'Nhà sàn giữa đồi chè Mộc Châu, săn mây và ngắm hoa mận.','Nhà sàn giữa đồi chè Mộc Châu, săn mây và ngắm hoa mận.',NULL,NULL,'Mộc Châu, Sơn La',NULL,NULL,'14:00','12:00',650000,30,4,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.590','2026-10-07 09:28:10.590'),(18,'HS006','Tam Cốc Garden Retreat','tam-coc-garden-retreat','HOMESTAY',NULL,'Khu nghỉ sinh thái giữa núi đá Tam Cốc – Tràng An.','Khu nghỉ sinh thái giữa núi đá Tam Cốc – Tràng An.',NULL,NULL,'Ninh Bình',NULL,NULL,'14:00','12:00',1250000,30,4,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.618','2026-10-07 09:28:10.618'),(19,'HS007','Sao Biển Phú Quốc','sao-bien-phu-quoc','HOMESTAY',NULL,'Homestay sát Bãi Sao, cát trắng nước trong, hoàng hôn tuyệt đẹp.','Homestay sát Bãi Sao, cát trắng nước trong, hoàng hôn tuyệt đẹp.',NULL,NULL,'Phú Quốc, Kiên Giang',NULL,NULL,'14:00','12:00',1400000,30,4,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.641','2026-10-07 09:28:10.641'),(20,'HS008','Phố Cổ Hà Nội Boutique','pho-co-ha-noi-boutique','HOMESTAY',NULL,'Căn hộ ấm cúng giữa phố cổ, đi bộ ra Hồ Gươm 5 phút.','Căn hộ ấm cúng giữa phố cổ, đi bộ ra Hồ Gươm 5 phút.',NULL,NULL,'Hoàn Kiếm, Hà Nội',NULL,NULL,'14:00','12:00',900000,30,4,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.665','2026-10-07 09:28:10.665'),(21,'HS009','Cát Bà Sunrise Bungalow','cat-ba-sunrise-bungalow','HOMESTAY',NULL,'Bungalow nhìn ra vịnh Lan Hạ, chèo kayak và tắm biển.','Bungalow nhìn ra vịnh Lan Hạ, chèo kayak và tắm biển.',NULL,NULL,'Cát Bà, Hải Phòng',NULL,NULL,'14:00','12:00',800000,30,4,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.692','2026-10-07 09:28:10.692'),(22,'HS010','An Nhiên Farmstay Bảo Lộc','an-nhien-farmstay-bao-loc','HOMESTAY',NULL,'Farmstay giữa đồi chè và thác nước, trải nghiệm hái trà.','Farmstay giữa đồi chè và thác nước, trải nghiệm hái trà.',NULL,NULL,'Bảo Lộc, Lâm Đồng',NULL,NULL,'14:00','12:00',950000,30,4,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.722','2026-10-07 09:28:10.722');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PropertyImage`
--

LOCK TABLES `PropertyImage` WRITE;
/*!40000 ALTER TABLE `PropertyImage` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RefundRequest`
--

LOCK TABLES `RefundRequest` WRITE;
/*!40000 ALTER TABLE `RefundRequest` DISABLE KEYS */;
INSERT INTO `RefundRequest` VALUES (2,15,750000,50,'PENDING','2026-10-07 09:28:16.505');
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
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
INSERT INTO `Review` VALUES (33,'HOMESTAY',NULL,15,NULL,12,'Nguyễn Minh Anh',5,'Homestay tuyệt vời, view đẹp, chủ nhà thân thiện. Sẽ quay lại!',1,0,'2026-09-20 00:00:00.000'),(34,'TOUR',NULL,NULL,14,14,'Nguyễn Minh Anh',4,'Lịch trình ổn, hướng dẫn viên nhiệt tình. Xe hơi đông.',0,0,'2026-10-06 00:00:00.000'),(35,'HOMESTAY',NULL,13,NULL,NULL,'Hoàng Thị Mai',5,'Sạch sẽ, gần trung tâm, nhân viên dễ thương.',1,0,'2026-09-29 00:00:00.000'),(36,'HOMESTAY',NULL,13,NULL,NULL,'Đỗ Quang Huy',4,'Phòng đẹp, buổi sáng hơi ồn một chút.',1,0,'2026-09-12 00:00:00.000'),(37,'HOMESTAY',NULL,14,NULL,NULL,'Vũ Thị Lan',5,'Không gian yên tĩnh, bữa sáng ngon.',1,0,'2026-09-26 00:00:00.000'),(38,'TOUR',NULL,NULL,13,NULL,'Nguyễn Văn Tú',5,'Cảnh đẹp mê hồn, tổ chức chuyên nghiệp.',1,0,'2026-09-13 00:00:00.000'),(39,'TOUR',NULL,NULL,13,NULL,'Trịnh Bảo',4,'Đáng tiền, nên mang thêm áo ấm.',1,0,'2026-09-26 00:00:00.000'),(40,'TOUR',NULL,NULL,14,NULL,'Lý Thu Hằng',5,'Chuyến đi đáng nhớ, hướng dẫn viên vui tính.',1,0,'2026-09-19 00:00:00.000');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewToken`
--

LOCK TABLES `ReviewToken` WRITE;
/*!40000 ALTER TABLE `ReviewToken` DISABLE KEYS */;
INSERT INTO `ReviewToken` VALUES (2,16,'0672a10c5c739e73d5df687f305ecdad80c7835e49695573491954f8afe41a7f','2026-11-06 00:00:00.000',NULL,'2026-10-07 09:28:16.514');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomImage`
--

LOCK TABLES `RoomImage` WRITE;
/*!40000 ALTER TABLE `RoomImage` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=5761 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomInventory`
--

LOCK TABLES `RoomInventory` WRITE;
/*!40000 ALTER TABLE `RoomInventory` DISABLE KEYS */;
INSERT INTO `RoomInventory` VALUES (3241,28,'2026-10-08',6,0,0,NULL,0),(3242,28,'2026-10-09',6,0,0,NULL,0),(3243,28,'2026-10-10',6,0,0,NULL,0),(3244,28,'2026-10-11',6,0,0,NULL,0),(3245,28,'2026-10-12',6,0,0,NULL,0),(3246,28,'2026-10-13',6,0,0,NULL,0),(3247,28,'2026-10-14',6,0,0,NULL,0),(3248,28,'2026-10-15',6,0,0,NULL,0),(3249,28,'2026-10-16',6,0,0,NULL,0),(3250,28,'2026-10-17',6,0,0,NULL,0),(3251,28,'2026-10-18',6,0,0,NULL,0),(3252,28,'2026-10-19',6,0,0,NULL,0),(3253,28,'2026-10-20',6,0,0,NULL,0),(3254,28,'2026-10-21',6,0,0,NULL,0),(3255,28,'2026-10-22',6,0,0,NULL,0),(3256,28,'2026-10-23',6,0,0,NULL,0),(3257,28,'2026-10-24',6,0,0,NULL,0),(3258,28,'2026-10-25',6,0,0,NULL,0),(3259,28,'2026-10-26',6,0,0,NULL,0),(3260,28,'2026-10-27',6,1,0,NULL,0),(3261,28,'2026-10-28',6,1,0,NULL,0),(3262,28,'2026-10-29',6,0,0,NULL,0),(3263,28,'2026-10-30',6,0,0,NULL,0),(3264,28,'2026-10-31',6,0,0,NULL,0),(3265,28,'2026-11-01',6,0,0,NULL,0),(3266,28,'2026-11-02',6,0,0,NULL,0),(3267,28,'2026-11-03',6,0,0,NULL,0),(3268,28,'2026-11-04',6,0,0,NULL,0),(3269,28,'2026-11-05',6,0,0,NULL,0),(3270,28,'2026-11-06',6,0,0,NULL,0),(3271,28,'2026-11-07',6,0,0,NULL,0),(3272,28,'2026-11-08',6,0,0,NULL,0),(3273,28,'2026-11-09',6,0,0,NULL,0),(3274,28,'2026-11-10',6,0,0,NULL,0),(3275,28,'2026-11-11',6,0,0,NULL,0),(3276,28,'2026-11-12',6,0,0,NULL,0),(3277,28,'2026-11-13',6,0,0,NULL,0),(3278,28,'2026-11-14',6,0,0,NULL,0),(3279,28,'2026-11-15',6,0,0,NULL,0),(3280,28,'2026-11-16',6,0,0,NULL,0),(3281,28,'2026-11-17',6,0,0,NULL,0),(3282,28,'2026-11-18',6,0,0,NULL,0),(3283,28,'2026-11-19',6,0,0,NULL,0),(3284,28,'2026-11-20',6,0,0,NULL,0),(3285,28,'2026-11-21',6,0,0,NULL,0),(3286,28,'2026-11-22',6,0,0,NULL,0),(3287,28,'2026-11-23',6,0,0,NULL,0),(3288,28,'2026-11-24',6,0,0,NULL,0),(3289,28,'2026-11-25',6,0,0,NULL,0),(3290,28,'2026-11-26',6,0,0,NULL,0),(3291,28,'2026-11-27',6,0,0,NULL,0),(3292,28,'2026-11-28',6,0,0,NULL,0),(3293,28,'2026-11-29',6,0,0,NULL,0),(3294,28,'2026-11-30',6,0,0,NULL,0),(3295,28,'2026-12-01',6,0,0,NULL,0),(3296,28,'2026-12-02',6,0,0,NULL,0),(3297,28,'2026-12-03',6,0,0,NULL,0),(3298,28,'2026-12-04',6,0,0,NULL,0),(3299,28,'2026-12-05',6,0,0,NULL,0),(3300,28,'2026-12-06',6,0,0,NULL,0),(3301,28,'2026-12-07',6,0,0,NULL,0),(3302,28,'2026-12-08',6,0,0,NULL,0),(3303,28,'2026-12-09',6,0,0,NULL,0),(3304,28,'2026-12-10',6,0,0,NULL,0),(3305,28,'2026-12-11',6,0,0,NULL,0),(3306,28,'2026-12-12',6,0,0,NULL,0),(3307,28,'2026-12-13',6,0,0,NULL,0),(3308,28,'2026-12-14',6,0,0,NULL,0),(3309,28,'2026-12-15',6,0,0,NULL,0),(3310,28,'2026-12-16',6,0,0,NULL,0),(3311,28,'2026-12-17',6,0,0,NULL,0),(3312,28,'2026-12-18',6,0,0,NULL,0),(3313,28,'2026-12-19',6,0,0,NULL,0),(3314,28,'2026-12-20',6,0,0,NULL,0),(3315,28,'2026-12-21',6,0,0,NULL,0),(3316,28,'2026-12-22',6,0,0,NULL,0),(3317,28,'2026-12-23',6,0,0,NULL,0),(3318,28,'2026-12-24',6,0,0,NULL,0),(3319,28,'2026-12-25',6,0,0,NULL,0),(3320,28,'2026-12-26',6,0,0,NULL,0),(3321,28,'2026-12-27',6,0,0,NULL,0),(3322,28,'2026-12-28',6,0,0,NULL,0),(3323,28,'2026-12-29',6,0,0,NULL,0),(3324,28,'2026-12-30',6,0,0,NULL,0),(3325,28,'2026-12-31',6,0,0,NULL,0),(3326,28,'2027-01-01',6,0,0,NULL,0),(3327,28,'2027-01-02',6,0,0,NULL,0),(3328,28,'2027-01-03',6,0,0,NULL,0),(3329,28,'2027-01-04',6,0,0,NULL,0),(3330,28,'2027-01-05',6,0,0,NULL,0),(3331,28,'2027-01-06',6,0,0,NULL,0),(3332,28,'2027-01-07',6,0,0,NULL,0),(3333,28,'2027-01-08',6,0,0,NULL,0),(3334,28,'2027-01-09',6,0,0,NULL,0),(3335,28,'2027-01-10',6,0,0,NULL,0),(3336,28,'2027-01-11',6,0,0,NULL,0),(3337,28,'2027-01-12',6,0,0,NULL,0),(3338,28,'2027-01-13',6,0,0,NULL,0),(3339,28,'2027-01-14',6,0,0,NULL,0),(3340,28,'2027-01-15',6,0,0,NULL,0),(3341,28,'2027-01-16',6,0,0,NULL,0),(3342,28,'2027-01-17',6,0,0,NULL,0),(3343,28,'2027-01-18',6,0,0,NULL,0),(3344,28,'2027-01-19',6,0,0,NULL,0),(3345,28,'2027-01-20',6,0,0,NULL,0),(3346,28,'2027-01-21',6,0,0,NULL,0),(3347,28,'2027-01-22',6,0,0,NULL,0),(3348,28,'2027-01-23',6,0,0,NULL,0),(3349,28,'2027-01-24',6,0,0,NULL,0),(3350,28,'2027-01-25',6,0,0,NULL,0),(3351,28,'2027-01-26',6,0,0,NULL,0),(3352,28,'2027-01-27',6,0,0,NULL,0),(3353,28,'2027-01-28',6,0,0,NULL,0),(3354,28,'2027-01-29',6,0,0,NULL,0),(3355,28,'2027-01-30',6,0,0,NULL,0),(3356,28,'2027-01-31',6,0,0,NULL,0),(3357,28,'2027-02-01',6,0,0,NULL,0),(3358,28,'2027-02-02',6,0,0,NULL,0),(3359,28,'2027-02-03',6,0,0,NULL,0),(3360,28,'2027-02-04',6,0,0,NULL,0),(3361,29,'2026-10-08',4,0,0,NULL,0),(3362,29,'2026-10-09',4,0,0,NULL,0),(3363,29,'2026-10-10',4,0,0,NULL,0),(3364,29,'2026-10-11',4,0,0,NULL,0),(3365,29,'2026-10-12',4,0,0,NULL,0),(3366,29,'2026-10-13',4,0,0,NULL,0),(3367,29,'2026-10-14',4,0,0,NULL,0),(3368,29,'2026-10-15',4,0,0,NULL,0),(3369,29,'2026-10-16',4,0,0,NULL,0),(3370,29,'2026-10-17',4,0,0,NULL,0),(3371,29,'2026-10-18',4,0,0,NULL,0),(3372,29,'2026-10-19',4,0,0,NULL,0),(3373,29,'2026-10-20',4,0,0,NULL,0),(3374,29,'2026-10-21',4,0,0,NULL,0),(3375,29,'2026-10-22',4,0,0,NULL,0),(3376,29,'2026-10-23',4,0,0,NULL,0),(3377,29,'2026-10-24',4,0,0,NULL,0),(3378,29,'2026-10-25',4,0,0,NULL,0),(3379,29,'2026-10-26',4,0,0,NULL,0),(3380,29,'2026-10-27',4,0,0,NULL,0),(3381,29,'2026-10-28',4,0,0,NULL,0),(3382,29,'2026-10-29',4,0,0,NULL,0),(3383,29,'2026-10-30',4,0,0,NULL,0),(3384,29,'2026-10-31',4,0,0,NULL,0),(3385,29,'2026-11-01',4,0,0,NULL,0),(3386,29,'2026-11-02',4,0,0,NULL,0),(3387,29,'2026-11-03',4,0,0,NULL,0),(3388,29,'2026-11-04',4,0,0,NULL,0),(3389,29,'2026-11-05',4,0,0,NULL,0),(3390,29,'2026-11-06',4,0,0,NULL,0),(3391,29,'2026-11-07',4,0,0,NULL,0),(3392,29,'2026-11-08',4,0,0,NULL,0),(3393,29,'2026-11-09',4,0,0,NULL,0),(3394,29,'2026-11-10',4,0,0,NULL,0),(3395,29,'2026-11-11',4,0,0,NULL,0),(3396,29,'2026-11-12',4,0,0,NULL,0),(3397,29,'2026-11-13',4,0,0,NULL,0),(3398,29,'2026-11-14',4,0,0,NULL,0),(3399,29,'2026-11-15',4,0,0,NULL,0),(3400,29,'2026-11-16',4,0,0,NULL,0),(3401,29,'2026-11-17',4,0,0,NULL,0),(3402,29,'2026-11-18',4,0,0,NULL,0),(3403,29,'2026-11-19',4,0,0,NULL,0),(3404,29,'2026-11-20',4,0,0,NULL,0),(3405,29,'2026-11-21',4,0,0,NULL,0),(3406,29,'2026-11-22',4,0,0,NULL,0),(3407,29,'2026-11-23',4,0,0,NULL,0),(3408,29,'2026-11-24',4,0,0,NULL,0),(3409,29,'2026-11-25',4,0,0,NULL,0),(3410,29,'2026-11-26',4,0,0,NULL,0),(3411,29,'2026-11-27',4,0,0,NULL,0),(3412,29,'2026-11-28',4,0,0,NULL,0),(3413,29,'2026-11-29',4,0,0,NULL,0),(3414,29,'2026-11-30',4,0,0,NULL,0),(3415,29,'2026-12-01',4,0,0,NULL,0),(3416,29,'2026-12-02',4,0,0,NULL,0),(3417,29,'2026-12-03',4,0,0,NULL,0),(3418,29,'2026-12-04',4,0,0,NULL,0),(3419,29,'2026-12-05',4,0,0,NULL,0),(3420,29,'2026-12-06',4,0,0,NULL,0),(3421,29,'2026-12-07',4,0,0,NULL,0),(3422,29,'2026-12-08',4,0,0,NULL,0),(3423,29,'2026-12-09',4,0,0,NULL,0),(3424,29,'2026-12-10',4,0,0,NULL,0),(3425,29,'2026-12-11',4,0,0,NULL,0),(3426,29,'2026-12-12',4,0,0,NULL,0),(3427,29,'2026-12-13',4,0,0,NULL,0),(3428,29,'2026-12-14',4,0,0,NULL,0),(3429,29,'2026-12-15',4,0,0,NULL,0),(3430,29,'2026-12-16',4,0,0,NULL,0),(3431,29,'2026-12-17',4,0,0,NULL,0),(3432,29,'2026-12-18',4,0,0,NULL,0),(3433,29,'2026-12-19',4,0,0,NULL,0),(3434,29,'2026-12-20',4,0,0,NULL,0),(3435,29,'2026-12-21',4,0,0,NULL,0),(3436,29,'2026-12-22',4,0,0,NULL,0),(3437,29,'2026-12-23',4,0,0,NULL,0),(3438,29,'2026-12-24',4,0,0,NULL,0),(3439,29,'2026-12-25',4,0,0,NULL,0),(3440,29,'2026-12-26',4,0,0,NULL,0),(3441,29,'2026-12-27',4,0,0,NULL,0),(3442,29,'2026-12-28',4,0,0,NULL,0),(3443,29,'2026-12-29',4,0,0,NULL,0),(3444,29,'2026-12-30',4,0,0,NULL,0),(3445,29,'2026-12-31',4,0,0,NULL,0),(3446,29,'2027-01-01',4,0,0,NULL,0),(3447,29,'2027-01-02',4,0,0,NULL,0),(3448,29,'2027-01-03',4,0,0,NULL,0),(3449,29,'2027-01-04',4,0,0,NULL,0),(3450,29,'2027-01-05',4,0,0,NULL,0),(3451,29,'2027-01-06',4,0,0,NULL,0),(3452,29,'2027-01-07',4,0,0,NULL,0),(3453,29,'2027-01-08',4,0,0,NULL,0),(3454,29,'2027-01-09',4,0,0,NULL,0),(3455,29,'2027-01-10',4,0,0,NULL,0),(3456,29,'2027-01-11',4,0,0,NULL,0),(3457,29,'2027-01-12',4,0,0,NULL,0),(3458,29,'2027-01-13',4,0,0,NULL,0),(3459,29,'2027-01-14',4,0,0,NULL,0),(3460,29,'2027-01-15',4,0,0,NULL,0),(3461,29,'2027-01-16',4,0,0,NULL,0),(3462,29,'2027-01-17',4,0,0,NULL,0),(3463,29,'2027-01-18',4,0,0,NULL,0),(3464,29,'2027-01-19',4,0,0,NULL,0),(3465,29,'2027-01-20',4,0,0,NULL,0),(3466,29,'2027-01-21',4,0,0,NULL,0),(3467,29,'2027-01-22',4,0,0,NULL,0),(3468,29,'2027-01-23',4,0,0,NULL,0),(3469,29,'2027-01-24',4,0,0,NULL,0),(3470,29,'2027-01-25',4,0,0,NULL,0),(3471,29,'2027-01-26',4,0,0,NULL,0),(3472,29,'2027-01-27',4,0,0,NULL,0),(3473,29,'2027-01-28',4,0,0,NULL,0),(3474,29,'2027-01-29',4,0,0,NULL,0),(3475,29,'2027-01-30',4,0,0,NULL,0),(3476,29,'2027-01-31',4,0,0,NULL,0),(3477,29,'2027-02-01',4,0,0,NULL,0),(3478,29,'2027-02-02',4,0,0,NULL,0),(3479,29,'2027-02-03',4,0,0,NULL,0),(3480,29,'2027-02-04',4,0,0,NULL,0),(3481,30,'2026-10-08',2,0,0,NULL,0),(3482,30,'2026-10-09',2,0,0,NULL,0),(3483,30,'2026-10-10',2,0,0,NULL,0),(3484,30,'2026-10-11',2,0,0,NULL,0),(3485,30,'2026-10-12',2,0,0,NULL,0),(3486,30,'2026-10-13',2,0,0,NULL,0),(3487,30,'2026-10-14',2,0,0,NULL,0),(3488,30,'2026-10-15',2,0,0,NULL,0),(3489,30,'2026-10-16',2,0,0,NULL,0),(3490,30,'2026-10-17',2,0,0,NULL,0),(3491,30,'2026-10-18',2,0,0,NULL,0),(3492,30,'2026-10-19',2,0,0,NULL,0),(3493,30,'2026-10-20',2,0,0,NULL,0),(3494,30,'2026-10-21',2,0,0,NULL,0),(3495,30,'2026-10-22',2,0,0,NULL,0),(3496,30,'2026-10-23',2,0,0,NULL,0),(3497,30,'2026-10-24',2,0,0,NULL,0),(3498,30,'2026-10-25',2,0,0,NULL,0),(3499,30,'2026-10-26',2,0,0,NULL,0),(3500,30,'2026-10-27',2,0,0,NULL,0),(3501,30,'2026-10-28',2,0,0,NULL,0),(3502,30,'2026-10-29',2,0,0,NULL,0),(3503,30,'2026-10-30',2,0,0,NULL,0),(3504,30,'2026-10-31',2,0,0,NULL,0),(3505,30,'2026-11-01',2,0,0,NULL,0),(3506,30,'2026-11-02',2,0,0,NULL,0),(3507,30,'2026-11-03',2,0,0,NULL,0),(3508,30,'2026-11-04',2,0,0,NULL,0),(3509,30,'2026-11-05',2,0,0,NULL,0),(3510,30,'2026-11-06',2,0,0,NULL,0),(3511,30,'2026-11-07',2,0,0,NULL,0),(3512,30,'2026-11-08',2,0,0,NULL,0),(3513,30,'2026-11-09',2,0,0,NULL,0),(3514,30,'2026-11-10',2,0,0,NULL,0),(3515,30,'2026-11-11',2,0,0,NULL,0),(3516,30,'2026-11-12',2,0,0,NULL,0),(3517,30,'2026-11-13',2,0,0,NULL,0),(3518,30,'2026-11-14',2,0,0,NULL,0),(3519,30,'2026-11-15',2,0,0,NULL,0),(3520,30,'2026-11-16',2,0,0,NULL,0),(3521,30,'2026-11-17',2,0,0,NULL,0),(3522,30,'2026-11-18',2,0,0,NULL,0),(3523,30,'2026-11-19',2,0,0,NULL,0),(3524,30,'2026-11-20',2,0,0,NULL,0),(3525,30,'2026-11-21',2,0,0,NULL,0),(3526,30,'2026-11-22',2,0,0,NULL,0),(3527,30,'2026-11-23',2,0,0,NULL,0),(3528,30,'2026-11-24',2,0,0,NULL,0),(3529,30,'2026-11-25',2,0,0,NULL,0),(3530,30,'2026-11-26',2,0,0,NULL,0),(3531,30,'2026-11-27',2,0,0,NULL,0),(3532,30,'2026-11-28',2,0,0,NULL,0),(3533,30,'2026-11-29',2,0,0,NULL,0),(3534,30,'2026-11-30',2,0,0,NULL,0),(3535,30,'2026-12-01',2,0,0,NULL,0),(3536,30,'2026-12-02',2,0,0,NULL,0),(3537,30,'2026-12-03',2,0,0,NULL,0),(3538,30,'2026-12-04',2,0,0,NULL,0),(3539,30,'2026-12-05',2,0,0,NULL,0),(3540,30,'2026-12-06',2,0,0,NULL,0),(3541,30,'2026-12-07',2,0,0,NULL,0),(3542,30,'2026-12-08',2,0,0,NULL,0),(3543,30,'2026-12-09',2,0,0,NULL,0),(3544,30,'2026-12-10',2,0,0,NULL,0),(3545,30,'2026-12-11',2,0,0,NULL,0),(3546,30,'2026-12-12',2,0,0,NULL,0),(3547,30,'2026-12-13',2,0,0,NULL,0),(3548,30,'2026-12-14',2,0,0,NULL,0),(3549,30,'2026-12-15',2,0,0,NULL,0),(3550,30,'2026-12-16',2,0,0,NULL,0),(3551,30,'2026-12-17',2,0,0,NULL,0),(3552,30,'2026-12-18',2,0,0,NULL,0),(3553,30,'2026-12-19',2,0,0,NULL,0),(3554,30,'2026-12-20',2,0,0,NULL,0),(3555,30,'2026-12-21',2,0,0,NULL,0),(3556,30,'2026-12-22',2,0,0,NULL,0),(3557,30,'2026-12-23',2,0,0,NULL,0),(3558,30,'2026-12-24',2,0,0,NULL,0),(3559,30,'2026-12-25',2,0,0,NULL,0),(3560,30,'2026-12-26',2,0,0,NULL,0),(3561,30,'2026-12-27',2,0,0,NULL,0),(3562,30,'2026-12-28',2,0,0,NULL,0),(3563,30,'2026-12-29',2,0,0,NULL,0),(3564,30,'2026-12-30',2,0,0,NULL,0),(3565,30,'2026-12-31',2,0,0,NULL,0),(3566,30,'2027-01-01',2,0,0,NULL,0),(3567,30,'2027-01-02',2,0,0,NULL,0),(3568,30,'2027-01-03',2,0,0,NULL,0),(3569,30,'2027-01-04',2,0,0,NULL,0),(3570,30,'2027-01-05',2,0,0,NULL,0),(3571,30,'2027-01-06',2,0,0,NULL,0),(3572,30,'2027-01-07',2,0,0,NULL,0),(3573,30,'2027-01-08',2,0,0,NULL,0),(3574,30,'2027-01-09',2,0,0,NULL,0),(3575,30,'2027-01-10',2,0,0,NULL,0),(3576,30,'2027-01-11',2,0,0,NULL,0),(3577,30,'2027-01-12',2,0,0,NULL,0),(3578,30,'2027-01-13',2,0,0,NULL,0),(3579,30,'2027-01-14',2,0,0,NULL,0),(3580,30,'2027-01-15',2,0,0,NULL,0),(3581,30,'2027-01-16',2,0,0,NULL,0),(3582,30,'2027-01-17',2,0,0,NULL,0),(3583,30,'2027-01-18',2,0,0,NULL,0),(3584,30,'2027-01-19',2,0,0,NULL,0),(3585,30,'2027-01-20',2,0,0,NULL,0),(3586,30,'2027-01-21',2,0,0,NULL,0),(3587,30,'2027-01-22',2,0,0,NULL,0),(3588,30,'2027-01-23',2,0,0,NULL,0),(3589,30,'2027-01-24',2,0,0,NULL,0),(3590,30,'2027-01-25',2,0,0,NULL,0),(3591,30,'2027-01-26',2,0,0,NULL,0),(3592,30,'2027-01-27',2,0,0,NULL,0),(3593,30,'2027-01-28',2,0,0,NULL,0),(3594,30,'2027-01-29',2,0,0,NULL,0),(3595,30,'2027-01-30',2,0,0,NULL,0),(3596,30,'2027-01-31',2,0,0,NULL,0),(3597,30,'2027-02-01',2,0,0,NULL,0),(3598,30,'2027-02-02',2,0,0,NULL,0),(3599,30,'2027-02-03',2,0,0,NULL,0),(3600,30,'2027-02-04',2,0,0,NULL,0),(3601,31,'2026-10-08',5,0,0,NULL,0),(3602,31,'2026-10-09',5,0,0,NULL,0),(3603,31,'2026-10-10',5,0,0,NULL,0),(3604,31,'2026-10-11',5,0,0,NULL,0),(3605,31,'2026-10-12',5,0,0,NULL,0),(3606,31,'2026-10-13',5,0,0,NULL,0),(3607,31,'2026-10-14',5,0,0,NULL,0),(3608,31,'2026-10-15',5,0,0,NULL,0),(3609,31,'2026-10-16',5,0,0,NULL,0),(3610,31,'2026-10-17',5,1,0,NULL,0),(3611,31,'2026-10-18',5,1,0,NULL,0),(3612,31,'2026-10-19',5,0,0,NULL,0),(3613,31,'2026-10-20',5,0,0,NULL,0),(3614,31,'2026-10-21',5,0,0,NULL,0),(3615,31,'2026-10-22',5,0,0,NULL,0),(3616,31,'2026-10-23',5,0,0,NULL,0),(3617,31,'2026-10-24',5,0,0,NULL,0),(3618,31,'2026-10-25',5,0,0,NULL,0),(3619,31,'2026-10-26',5,0,0,NULL,0),(3620,31,'2026-10-27',5,0,0,NULL,0),(3621,31,'2026-10-28',5,0,0,NULL,0),(3622,31,'2026-10-29',5,0,0,NULL,0),(3623,31,'2026-10-30',5,0,0,NULL,0),(3624,31,'2026-10-31',5,0,0,NULL,0),(3625,31,'2026-11-01',5,0,0,NULL,0),(3626,31,'2026-11-02',5,0,0,NULL,0),(3627,31,'2026-11-03',5,0,0,NULL,0),(3628,31,'2026-11-04',5,0,0,NULL,0),(3629,31,'2026-11-05',5,0,0,NULL,0),(3630,31,'2026-11-06',5,0,0,NULL,0),(3631,31,'2026-11-07',5,0,0,NULL,0),(3632,31,'2026-11-08',5,0,0,NULL,0),(3633,31,'2026-11-09',5,0,0,NULL,0),(3634,31,'2026-11-10',5,0,0,NULL,0),(3635,31,'2026-11-11',5,1,0,NULL,0),(3636,31,'2026-11-12',5,1,0,NULL,0),(3637,31,'2026-11-13',5,0,0,NULL,0),(3638,31,'2026-11-14',5,0,0,NULL,0),(3639,31,'2026-11-15',5,0,0,NULL,0),(3640,31,'2026-11-16',5,0,0,NULL,0),(3641,31,'2026-11-17',5,0,0,NULL,0),(3642,31,'2026-11-18',5,0,0,NULL,0),(3643,31,'2026-11-19',5,0,0,NULL,0),(3644,31,'2026-11-20',5,0,0,NULL,0),(3645,31,'2026-11-21',5,0,0,NULL,0),(3646,31,'2026-11-22',5,0,0,NULL,0),(3647,31,'2026-11-23',5,0,0,NULL,0),(3648,31,'2026-11-24',5,0,0,NULL,0),(3649,31,'2026-11-25',5,0,0,NULL,0),(3650,31,'2026-11-26',5,0,0,NULL,0),(3651,31,'2026-11-27',5,0,0,NULL,0),(3652,31,'2026-11-28',5,0,0,NULL,0),(3653,31,'2026-11-29',5,0,0,NULL,0),(3654,31,'2026-11-30',5,0,0,NULL,0),(3655,31,'2026-12-01',5,0,0,NULL,0),(3656,31,'2026-12-02',5,0,0,NULL,0),(3657,31,'2026-12-03',5,0,0,NULL,0),(3658,31,'2026-12-04',5,0,0,NULL,0),(3659,31,'2026-12-05',5,0,0,NULL,0),(3660,31,'2026-12-06',5,0,0,NULL,0),(3661,31,'2026-12-07',5,0,0,NULL,0),(3662,31,'2026-12-08',5,0,0,NULL,0),(3663,31,'2026-12-09',5,0,0,NULL,0),(3664,31,'2026-12-10',5,0,0,NULL,0),(3665,31,'2026-12-11',5,0,0,NULL,0),(3666,31,'2026-12-12',5,0,0,NULL,0),(3667,31,'2026-12-13',5,0,0,NULL,0),(3668,31,'2026-12-14',5,0,0,NULL,0),(3669,31,'2026-12-15',5,0,0,NULL,0),(3670,31,'2026-12-16',5,0,0,NULL,0),(3671,31,'2026-12-17',5,0,0,NULL,0),(3672,31,'2026-12-18',5,0,0,NULL,0),(3673,31,'2026-12-19',5,0,0,NULL,0),(3674,31,'2026-12-20',5,0,0,NULL,0),(3675,31,'2026-12-21',5,0,0,NULL,0),(3676,31,'2026-12-22',5,0,0,NULL,0),(3677,31,'2026-12-23',5,0,0,NULL,0),(3678,31,'2026-12-24',5,0,0,NULL,0),(3679,31,'2026-12-25',5,0,0,NULL,0),(3680,31,'2026-12-26',5,0,0,NULL,0),(3681,31,'2026-12-27',5,0,0,NULL,0),(3682,31,'2026-12-28',5,0,0,NULL,0),(3683,31,'2026-12-29',5,0,0,NULL,0),(3684,31,'2026-12-30',5,0,0,NULL,0),(3685,31,'2026-12-31',5,0,0,NULL,0),(3686,31,'2027-01-01',5,0,0,NULL,0),(3687,31,'2027-01-02',5,0,0,NULL,0),(3688,31,'2027-01-03',5,0,0,NULL,0),(3689,31,'2027-01-04',5,0,0,NULL,0),(3690,31,'2027-01-05',5,0,0,NULL,0),(3691,31,'2027-01-06',5,0,0,NULL,0),(3692,31,'2027-01-07',5,0,0,NULL,0),(3693,31,'2027-01-08',5,0,0,NULL,0),(3694,31,'2027-01-09',5,0,0,NULL,0),(3695,31,'2027-01-10',5,0,0,NULL,0),(3696,31,'2027-01-11',5,0,0,NULL,0),(3697,31,'2027-01-12',5,0,0,NULL,0),(3698,31,'2027-01-13',5,0,0,NULL,0),(3699,31,'2027-01-14',5,0,0,NULL,0),(3700,31,'2027-01-15',5,0,0,NULL,0),(3701,31,'2027-01-16',5,0,0,NULL,0),(3702,31,'2027-01-17',5,0,0,NULL,0),(3703,31,'2027-01-18',5,0,0,NULL,0),(3704,31,'2027-01-19',5,0,0,NULL,0),(3705,31,'2027-01-20',5,0,0,NULL,0),(3706,31,'2027-01-21',5,0,0,NULL,0),(3707,31,'2027-01-22',5,0,0,NULL,0),(3708,31,'2027-01-23',5,0,0,NULL,0),(3709,31,'2027-01-24',5,0,0,NULL,0),(3710,31,'2027-01-25',5,0,0,NULL,0),(3711,31,'2027-01-26',5,0,0,NULL,0),(3712,31,'2027-01-27',5,0,0,NULL,0),(3713,31,'2027-01-28',5,0,0,NULL,0),(3714,31,'2027-01-29',5,0,0,NULL,0),(3715,31,'2027-01-30',5,0,0,NULL,0),(3716,31,'2027-01-31',5,0,0,NULL,0),(3717,31,'2027-02-01',5,0,0,NULL,0),(3718,31,'2027-02-02',5,0,0,NULL,0),(3719,31,'2027-02-03',5,0,0,NULL,0),(3720,31,'2027-02-04',5,0,0,NULL,0),(3721,32,'2026-10-08',3,0,0,NULL,0),(3722,32,'2026-10-09',3,0,0,NULL,0),(3723,32,'2026-10-10',3,0,0,NULL,0),(3724,32,'2026-10-11',3,0,0,NULL,0),(3725,32,'2026-10-12',3,0,0,NULL,0),(3726,32,'2026-10-13',3,0,0,NULL,0),(3727,32,'2026-10-14',3,0,0,NULL,0),(3728,32,'2026-10-15',3,0,0,NULL,0),(3729,32,'2026-10-16',3,0,0,NULL,0),(3730,32,'2026-10-17',3,0,0,NULL,0),(3731,32,'2026-10-18',3,0,0,NULL,0),(3732,32,'2026-10-19',3,0,0,NULL,0),(3733,32,'2026-10-20',3,0,0,NULL,0),(3734,32,'2026-10-21',3,0,0,NULL,0),(3735,32,'2026-10-22',3,0,0,NULL,0),(3736,32,'2026-10-23',3,0,0,NULL,0),(3737,32,'2026-10-24',3,0,0,NULL,0),(3738,32,'2026-10-25',3,0,0,NULL,0),(3739,32,'2026-10-26',3,0,0,NULL,0),(3740,32,'2026-10-27',3,0,0,NULL,0),(3741,32,'2026-10-28',3,0,0,NULL,0),(3742,32,'2026-10-29',3,0,0,NULL,0),(3743,32,'2026-10-30',3,0,0,NULL,0),(3744,32,'2026-10-31',3,0,0,NULL,0),(3745,32,'2026-11-01',3,0,0,NULL,0),(3746,32,'2026-11-02',3,0,0,NULL,0),(3747,32,'2026-11-03',3,0,0,NULL,0),(3748,32,'2026-11-04',3,0,0,NULL,0),(3749,32,'2026-11-05',3,0,0,NULL,0),(3750,32,'2026-11-06',3,0,0,NULL,0),(3751,32,'2026-11-07',3,0,0,NULL,0),(3752,32,'2026-11-08',3,0,0,NULL,0),(3753,32,'2026-11-09',3,0,0,NULL,0),(3754,32,'2026-11-10',3,0,0,NULL,0),(3755,32,'2026-11-11',3,0,0,NULL,0),(3756,32,'2026-11-12',3,0,0,NULL,0),(3757,32,'2026-11-13',3,0,0,NULL,0),(3758,32,'2026-11-14',3,0,0,NULL,0),(3759,32,'2026-11-15',3,0,0,NULL,0),(3760,32,'2026-11-16',3,0,0,NULL,0),(3761,32,'2026-11-17',3,0,0,NULL,0),(3762,32,'2026-11-18',3,0,0,NULL,0),(3763,32,'2026-11-19',3,0,0,NULL,0),(3764,32,'2026-11-20',3,0,0,NULL,0),(3765,32,'2026-11-21',3,0,0,NULL,0),(3766,32,'2026-11-22',3,0,0,NULL,0),(3767,32,'2026-11-23',3,0,0,NULL,0),(3768,32,'2026-11-24',3,0,0,NULL,0),(3769,32,'2026-11-25',3,0,0,NULL,0),(3770,32,'2026-11-26',3,0,0,NULL,0),(3771,32,'2026-11-27',3,0,0,NULL,0),(3772,32,'2026-11-28',3,0,0,NULL,0),(3773,32,'2026-11-29',3,0,0,NULL,0),(3774,32,'2026-11-30',3,0,0,NULL,0),(3775,32,'2026-12-01',3,0,0,NULL,0),(3776,32,'2026-12-02',3,0,0,NULL,0),(3777,32,'2026-12-03',3,0,0,NULL,0),(3778,32,'2026-12-04',3,0,0,NULL,0),(3779,32,'2026-12-05',3,0,0,NULL,0),(3780,32,'2026-12-06',3,0,0,NULL,0),(3781,32,'2026-12-07',3,0,0,NULL,0),(3782,32,'2026-12-08',3,0,0,NULL,0),(3783,32,'2026-12-09',3,0,0,NULL,0),(3784,32,'2026-12-10',3,0,0,NULL,0),(3785,32,'2026-12-11',3,0,0,NULL,0),(3786,32,'2026-12-12',3,0,0,NULL,0),(3787,32,'2026-12-13',3,0,0,NULL,0),(3788,32,'2026-12-14',3,0,0,NULL,0),(3789,32,'2026-12-15',3,0,0,NULL,0),(3790,32,'2026-12-16',3,0,0,NULL,0),(3791,32,'2026-12-17',3,0,0,NULL,0),(3792,32,'2026-12-18',3,0,0,NULL,0),(3793,32,'2026-12-19',3,0,0,NULL,0),(3794,32,'2026-12-20',3,0,0,NULL,0),(3795,32,'2026-12-21',3,0,0,NULL,0),(3796,32,'2026-12-22',3,0,0,NULL,0),(3797,32,'2026-12-23',3,0,0,NULL,0),(3798,32,'2026-12-24',3,0,0,NULL,0),(3799,32,'2026-12-25',3,0,0,NULL,0),(3800,32,'2026-12-26',3,0,0,NULL,0),(3801,32,'2026-12-27',3,0,0,NULL,0),(3802,32,'2026-12-28',3,0,0,NULL,0),(3803,32,'2026-12-29',3,0,0,NULL,0),(3804,32,'2026-12-30',3,0,0,NULL,0),(3805,32,'2026-12-31',3,0,0,NULL,0),(3806,32,'2027-01-01',3,0,0,NULL,0),(3807,32,'2027-01-02',3,0,0,NULL,0),(3808,32,'2027-01-03',3,0,0,NULL,0),(3809,32,'2027-01-04',3,0,0,NULL,0),(3810,32,'2027-01-05',3,0,0,NULL,0),(3811,32,'2027-01-06',3,0,0,NULL,0),(3812,32,'2027-01-07',3,0,0,NULL,0),(3813,32,'2027-01-08',3,0,0,NULL,0),(3814,32,'2027-01-09',3,0,0,NULL,0),(3815,32,'2027-01-10',3,0,0,NULL,0),(3816,32,'2027-01-11',3,0,0,NULL,0),(3817,32,'2027-01-12',3,0,0,NULL,0),(3818,32,'2027-01-13',3,0,0,NULL,0),(3819,32,'2027-01-14',3,0,0,NULL,0),(3820,32,'2027-01-15',3,0,0,NULL,0),(3821,32,'2027-01-16',3,0,0,NULL,0),(3822,32,'2027-01-17',3,0,0,NULL,0),(3823,32,'2027-01-18',3,0,0,NULL,0),(3824,32,'2027-01-19',3,0,0,NULL,0),(3825,32,'2027-01-20',3,0,0,NULL,0),(3826,32,'2027-01-21',3,0,0,NULL,0),(3827,32,'2027-01-22',3,0,0,NULL,0),(3828,32,'2027-01-23',3,0,0,NULL,0),(3829,32,'2027-01-24',3,0,0,NULL,0),(3830,32,'2027-01-25',3,0,0,NULL,0),(3831,32,'2027-01-26',3,0,0,NULL,0),(3832,32,'2027-01-27',3,0,0,NULL,0),(3833,32,'2027-01-28',3,0,0,NULL,0),(3834,32,'2027-01-29',3,0,0,NULL,0),(3835,32,'2027-01-30',3,0,0,NULL,0),(3836,32,'2027-01-31',3,0,0,NULL,0),(3837,32,'2027-02-01',3,0,0,NULL,0),(3838,32,'2027-02-02',3,0,0,NULL,0),(3839,32,'2027-02-03',3,0,0,NULL,0),(3840,32,'2027-02-04',3,0,0,NULL,0),(3841,33,'2026-10-08',6,0,0,NULL,0),(3842,33,'2026-10-09',6,0,0,NULL,0),(3843,33,'2026-10-10',6,0,0,NULL,0),(3844,33,'2026-10-11',6,0,0,NULL,0),(3845,33,'2026-10-12',6,0,0,NULL,0),(3846,33,'2026-10-13',6,0,0,NULL,0),(3847,33,'2026-10-14',6,0,0,NULL,0),(3848,33,'2026-10-15',6,0,0,NULL,0),(3849,33,'2026-10-16',6,0,0,NULL,0),(3850,33,'2026-10-17',6,0,0,NULL,0),(3851,33,'2026-10-18',6,0,0,NULL,0),(3852,33,'2026-10-19',6,0,0,NULL,0),(3853,33,'2026-10-20',6,0,0,NULL,0),(3854,33,'2026-10-21',6,0,0,NULL,0),(3855,33,'2026-10-22',6,0,0,NULL,0),(3856,33,'2026-10-23',6,0,0,NULL,0),(3857,33,'2026-10-24',6,0,0,NULL,0),(3858,33,'2026-10-25',6,0,0,NULL,0),(3859,33,'2026-10-26',6,0,0,NULL,0),(3860,33,'2026-10-27',6,0,0,NULL,0),(3861,33,'2026-10-28',6,0,0,NULL,0),(3862,33,'2026-10-29',6,0,0,NULL,0),(3863,33,'2026-10-30',6,0,0,NULL,0),(3864,33,'2026-10-31',6,0,0,NULL,0),(3865,33,'2026-11-01',6,0,0,NULL,0),(3866,33,'2026-11-02',6,0,0,NULL,0),(3867,33,'2026-11-03',6,0,0,NULL,0),(3868,33,'2026-11-04',6,0,0,NULL,0),(3869,33,'2026-11-05',6,0,0,NULL,0),(3870,33,'2026-11-06',6,0,0,NULL,0),(3871,33,'2026-11-07',6,0,0,NULL,0),(3872,33,'2026-11-08',6,0,0,NULL,0),(3873,33,'2026-11-09',6,0,0,NULL,0),(3874,33,'2026-11-10',6,0,0,NULL,0),(3875,33,'2026-11-11',6,0,0,NULL,0),(3876,33,'2026-11-12',6,0,0,NULL,0),(3877,33,'2026-11-13',6,0,0,NULL,0),(3878,33,'2026-11-14',6,0,0,NULL,0),(3879,33,'2026-11-15',6,0,0,NULL,0),(3880,33,'2026-11-16',6,0,0,NULL,0),(3881,33,'2026-11-17',6,0,0,NULL,0),(3882,33,'2026-11-18',6,0,0,NULL,0),(3883,33,'2026-11-19',6,0,0,NULL,0),(3884,33,'2026-11-20',6,0,0,NULL,0),(3885,33,'2026-11-21',6,0,0,NULL,0),(3886,33,'2026-11-22',6,0,0,NULL,0),(3887,33,'2026-11-23',6,0,0,NULL,0),(3888,33,'2026-11-24',6,0,0,NULL,0),(3889,33,'2026-11-25',6,0,0,NULL,0),(3890,33,'2026-11-26',6,0,0,NULL,0),(3891,33,'2026-11-27',6,0,0,NULL,0),(3892,33,'2026-11-28',6,0,0,NULL,0),(3893,33,'2026-11-29',6,0,0,NULL,0),(3894,33,'2026-11-30',6,0,0,NULL,0),(3895,33,'2026-12-01',6,0,0,NULL,0),(3896,33,'2026-12-02',6,0,0,NULL,0),(3897,33,'2026-12-03',6,0,0,NULL,0),(3898,33,'2026-12-04',6,0,0,NULL,0),(3899,33,'2026-12-05',6,0,0,NULL,0),(3900,33,'2026-12-06',6,0,0,NULL,0),(3901,33,'2026-12-07',6,0,0,NULL,0),(3902,33,'2026-12-08',6,0,0,NULL,0),(3903,33,'2026-12-09',6,0,0,NULL,0),(3904,33,'2026-12-10',6,0,0,NULL,0),(3905,33,'2026-12-11',6,0,0,NULL,0),(3906,33,'2026-12-12',6,0,0,NULL,0),(3907,33,'2026-12-13',6,0,0,NULL,0),(3908,33,'2026-12-14',6,0,0,NULL,0),(3909,33,'2026-12-15',6,0,0,NULL,0),(3910,33,'2026-12-16',6,0,0,NULL,0),(3911,33,'2026-12-17',6,0,0,NULL,0),(3912,33,'2026-12-18',6,0,0,NULL,0),(3913,33,'2026-12-19',6,0,0,NULL,0),(3914,33,'2026-12-20',6,0,0,NULL,0),(3915,33,'2026-12-21',6,0,0,NULL,0),(3916,33,'2026-12-22',6,0,0,NULL,0),(3917,33,'2026-12-23',6,0,0,NULL,0),(3918,33,'2026-12-24',6,0,0,NULL,0),(3919,33,'2026-12-25',6,0,0,NULL,0),(3920,33,'2026-12-26',6,0,0,NULL,0),(3921,33,'2026-12-27',6,0,0,NULL,0),(3922,33,'2026-12-28',6,0,0,NULL,0),(3923,33,'2026-12-29',6,0,0,NULL,0),(3924,33,'2026-12-30',6,0,0,NULL,0),(3925,33,'2026-12-31',6,0,0,NULL,0),(3926,33,'2027-01-01',6,0,0,NULL,0),(3927,33,'2027-01-02',6,0,0,NULL,0),(3928,33,'2027-01-03',6,0,0,NULL,0),(3929,33,'2027-01-04',6,0,0,NULL,0),(3930,33,'2027-01-05',6,0,0,NULL,0),(3931,33,'2027-01-06',6,0,0,NULL,0),(3932,33,'2027-01-07',6,0,0,NULL,0),(3933,33,'2027-01-08',6,0,0,NULL,0),(3934,33,'2027-01-09',6,0,0,NULL,0),(3935,33,'2027-01-10',6,0,0,NULL,0),(3936,33,'2027-01-11',6,0,0,NULL,0),(3937,33,'2027-01-12',6,0,0,NULL,0),(3938,33,'2027-01-13',6,0,0,NULL,0),(3939,33,'2027-01-14',6,0,0,NULL,0),(3940,33,'2027-01-15',6,0,0,NULL,0),(3941,33,'2027-01-16',6,0,0,NULL,0),(3942,33,'2027-01-17',6,0,0,NULL,0),(3943,33,'2027-01-18',6,0,0,NULL,0),(3944,33,'2027-01-19',6,0,0,NULL,0),(3945,33,'2027-01-20',6,0,0,NULL,0),(3946,33,'2027-01-21',6,0,0,NULL,0),(3947,33,'2027-01-22',6,0,0,NULL,0),(3948,33,'2027-01-23',6,0,0,NULL,0),(3949,33,'2027-01-24',6,0,0,NULL,0),(3950,33,'2027-01-25',6,0,0,NULL,0),(3951,33,'2027-01-26',6,0,0,NULL,0),(3952,33,'2027-01-27',6,0,0,NULL,0),(3953,33,'2027-01-28',6,0,0,NULL,0),(3954,33,'2027-01-29',6,0,0,NULL,0),(3955,33,'2027-01-30',6,0,0,NULL,0),(3956,33,'2027-01-31',6,0,0,NULL,0),(3957,33,'2027-02-01',6,0,0,NULL,0),(3958,33,'2027-02-02',6,0,0,NULL,0),(3959,33,'2027-02-03',6,0,0,NULL,0),(3960,33,'2027-02-04',6,0,0,NULL,0),(3961,34,'2026-10-08',3,0,0,NULL,0),(3962,34,'2026-10-09',3,0,0,NULL,0),(3963,34,'2026-10-10',3,0,0,NULL,0),(3964,34,'2026-10-11',3,0,0,NULL,0),(3965,34,'2026-10-12',3,0,0,NULL,0),(3966,34,'2026-10-13',3,0,0,NULL,0),(3967,34,'2026-10-14',3,0,0,NULL,0),(3968,34,'2026-10-15',3,0,0,NULL,0),(3969,34,'2026-10-16',3,0,0,NULL,0),(3970,34,'2026-10-17',3,0,0,NULL,0),(3971,34,'2026-10-18',3,0,0,NULL,0),(3972,34,'2026-10-19',3,0,0,NULL,0),(3973,34,'2026-10-20',3,0,0,NULL,0),(3974,34,'2026-10-21',3,0,0,NULL,0),(3975,34,'2026-10-22',3,0,0,NULL,0),(3976,34,'2026-10-23',3,0,0,NULL,0),(3977,34,'2026-10-24',3,0,0,NULL,0),(3978,34,'2026-10-25',3,0,0,NULL,0),(3979,34,'2026-10-26',3,0,0,NULL,0),(3980,34,'2026-10-27',3,0,0,NULL,0),(3981,34,'2026-10-28',3,0,0,NULL,0),(3982,34,'2026-10-29',3,0,0,NULL,0),(3983,34,'2026-10-30',3,0,0,NULL,0),(3984,34,'2026-10-31',3,0,0,NULL,0),(3985,34,'2026-11-01',3,0,0,NULL,0),(3986,34,'2026-11-02',3,0,0,NULL,0),(3987,34,'2026-11-03',3,0,0,NULL,0),(3988,34,'2026-11-04',3,0,0,NULL,0),(3989,34,'2026-11-05',3,0,0,NULL,0),(3990,34,'2026-11-06',3,0,0,NULL,0),(3991,34,'2026-11-07',3,0,0,NULL,0),(3992,34,'2026-11-08',3,0,0,NULL,0),(3993,34,'2026-11-09',3,0,0,NULL,0),(3994,34,'2026-11-10',3,0,0,NULL,0),(3995,34,'2026-11-11',3,0,0,NULL,0),(3996,34,'2026-11-12',3,0,0,NULL,0),(3997,34,'2026-11-13',3,0,0,NULL,0),(3998,34,'2026-11-14',3,0,0,NULL,0),(3999,34,'2026-11-15',3,0,0,NULL,0),(4000,34,'2026-11-16',3,0,0,NULL,0),(4001,34,'2026-11-17',3,0,0,NULL,0),(4002,34,'2026-11-18',3,0,0,NULL,0),(4003,34,'2026-11-19',3,0,0,NULL,0),(4004,34,'2026-11-20',3,0,0,NULL,0),(4005,34,'2026-11-21',3,0,0,NULL,0),(4006,34,'2026-11-22',3,0,0,NULL,0),(4007,34,'2026-11-23',3,0,0,NULL,0),(4008,34,'2026-11-24',3,0,0,NULL,0),(4009,34,'2026-11-25',3,0,0,NULL,0),(4010,34,'2026-11-26',3,0,0,NULL,0),(4011,34,'2026-11-27',3,0,0,NULL,0),(4012,34,'2026-11-28',3,0,0,NULL,0),(4013,34,'2026-11-29',3,0,0,NULL,0),(4014,34,'2026-11-30',3,0,0,NULL,0),(4015,34,'2026-12-01',3,0,0,NULL,0),(4016,34,'2026-12-02',3,0,0,NULL,0),(4017,34,'2026-12-03',3,0,0,NULL,0),(4018,34,'2026-12-04',3,0,0,NULL,0),(4019,34,'2026-12-05',3,0,0,NULL,0),(4020,34,'2026-12-06',3,0,0,NULL,0),(4021,34,'2026-12-07',3,0,0,NULL,0),(4022,34,'2026-12-08',3,0,0,NULL,0),(4023,34,'2026-12-09',3,0,0,NULL,0),(4024,34,'2026-12-10',3,0,0,NULL,0),(4025,34,'2026-12-11',3,0,0,NULL,0),(4026,34,'2026-12-12',3,0,0,NULL,0),(4027,34,'2026-12-13',3,0,0,NULL,0),(4028,34,'2026-12-14',3,0,0,NULL,0),(4029,34,'2026-12-15',3,0,0,NULL,0),(4030,34,'2026-12-16',3,0,0,NULL,0),(4031,34,'2026-12-17',3,0,0,NULL,0),(4032,34,'2026-12-18',3,0,0,NULL,0),(4033,34,'2026-12-19',3,0,0,NULL,0),(4034,34,'2026-12-20',3,0,0,NULL,0),(4035,34,'2026-12-21',3,0,0,NULL,0),(4036,34,'2026-12-22',3,0,0,NULL,0),(4037,34,'2026-12-23',3,0,0,NULL,0),(4038,34,'2026-12-24',3,0,0,NULL,0),(4039,34,'2026-12-25',3,0,0,NULL,0),(4040,34,'2026-12-26',3,0,0,NULL,0),(4041,34,'2026-12-27',3,0,0,NULL,0),(4042,34,'2026-12-28',3,0,0,NULL,0),(4043,34,'2026-12-29',3,0,0,NULL,0),(4044,34,'2026-12-30',3,0,0,NULL,0),(4045,34,'2026-12-31',3,0,0,NULL,0),(4046,34,'2027-01-01',3,0,0,NULL,0),(4047,34,'2027-01-02',3,0,0,NULL,0),(4048,34,'2027-01-03',3,0,0,NULL,0),(4049,34,'2027-01-04',3,0,0,NULL,0),(4050,34,'2027-01-05',3,0,0,NULL,0),(4051,34,'2027-01-06',3,0,0,NULL,0),(4052,34,'2027-01-07',3,0,0,NULL,0),(4053,34,'2027-01-08',3,0,0,NULL,0),(4054,34,'2027-01-09',3,0,0,NULL,0),(4055,34,'2027-01-10',3,0,0,NULL,0),(4056,34,'2027-01-11',3,0,0,NULL,0),(4057,34,'2027-01-12',3,0,0,NULL,0),(4058,34,'2027-01-13',3,0,0,NULL,0),(4059,34,'2027-01-14',3,0,0,NULL,0),(4060,34,'2027-01-15',3,0,0,NULL,0),(4061,34,'2027-01-16',3,0,0,NULL,0),(4062,34,'2027-01-17',3,0,0,NULL,0),(4063,34,'2027-01-18',3,0,0,NULL,0),(4064,34,'2027-01-19',3,0,0,NULL,0),(4065,34,'2027-01-20',3,0,0,NULL,0),(4066,34,'2027-01-21',3,0,0,NULL,0),(4067,34,'2027-01-22',3,0,0,NULL,0),(4068,34,'2027-01-23',3,0,0,NULL,0),(4069,34,'2027-01-24',3,0,0,NULL,0),(4070,34,'2027-01-25',3,0,0,NULL,0),(4071,34,'2027-01-26',3,0,0,NULL,0),(4072,34,'2027-01-27',3,0,0,NULL,0),(4073,34,'2027-01-28',3,0,0,NULL,0),(4074,34,'2027-01-29',3,0,0,NULL,0),(4075,34,'2027-01-30',3,0,0,NULL,0),(4076,34,'2027-01-31',3,0,0,NULL,0),(4077,34,'2027-02-01',3,0,0,NULL,0),(4078,34,'2027-02-02',3,0,0,NULL,0),(4079,34,'2027-02-03',3,0,0,NULL,0),(4080,34,'2027-02-04',3,0,0,NULL,0),(4081,35,'2026-10-08',10,0,0,NULL,0),(4082,35,'2026-10-09',10,0,0,NULL,0),(4083,35,'2026-10-10',10,0,0,NULL,0),(4084,35,'2026-10-11',10,0,0,NULL,0),(4085,35,'2026-10-12',10,0,0,NULL,0),(4086,35,'2026-10-13',10,0,0,NULL,0),(4087,35,'2026-10-14',10,0,0,NULL,0),(4088,35,'2026-10-15',10,0,0,NULL,0),(4089,35,'2026-10-16',10,0,0,NULL,0),(4090,35,'2026-10-17',10,0,0,NULL,0),(4091,35,'2026-10-18',10,0,0,NULL,0),(4092,35,'2026-10-19',10,0,0,NULL,0),(4093,35,'2026-10-20',10,0,0,NULL,0),(4094,35,'2026-10-21',10,0,0,NULL,0),(4095,35,'2026-10-22',10,0,0,NULL,0),(4096,35,'2026-10-23',10,0,0,NULL,0),(4097,35,'2026-10-24',10,0,0,NULL,0),(4098,35,'2026-10-25',10,0,0,NULL,0),(4099,35,'2026-10-26',10,0,0,NULL,0),(4100,35,'2026-10-27',10,0,0,NULL,0),(4101,35,'2026-10-28',10,0,0,NULL,0),(4102,35,'2026-10-29',10,0,0,NULL,0),(4103,35,'2026-10-30',10,0,0,NULL,0),(4104,35,'2026-10-31',10,0,0,NULL,0),(4105,35,'2026-11-01',10,0,0,NULL,0),(4106,35,'2026-11-02',10,0,0,NULL,0),(4107,35,'2026-11-03',10,0,0,NULL,0),(4108,35,'2026-11-04',10,0,0,NULL,0),(4109,35,'2026-11-05',10,0,0,NULL,0),(4110,35,'2026-11-06',10,0,0,NULL,0),(4111,35,'2026-11-07',10,0,0,NULL,0),(4112,35,'2026-11-08',10,0,0,NULL,0),(4113,35,'2026-11-09',10,0,0,NULL,0),(4114,35,'2026-11-10',10,0,0,NULL,0),(4115,35,'2026-11-11',10,0,0,NULL,0),(4116,35,'2026-11-12',10,0,0,NULL,0),(4117,35,'2026-11-13',10,0,0,NULL,0),(4118,35,'2026-11-14',10,0,0,NULL,0),(4119,35,'2026-11-15',10,0,0,NULL,0),(4120,35,'2026-11-16',10,0,0,NULL,0),(4121,35,'2026-11-17',10,0,0,NULL,0),(4122,35,'2026-11-18',10,0,0,NULL,0),(4123,35,'2026-11-19',10,0,0,NULL,0),(4124,35,'2026-11-20',10,0,0,NULL,0),(4125,35,'2026-11-21',10,0,0,NULL,0),(4126,35,'2026-11-22',10,0,0,NULL,0),(4127,35,'2026-11-23',10,0,0,NULL,0),(4128,35,'2026-11-24',10,0,0,NULL,0),(4129,35,'2026-11-25',10,0,0,NULL,0),(4130,35,'2026-11-26',10,0,0,NULL,0),(4131,35,'2026-11-27',10,0,0,NULL,0),(4132,35,'2026-11-28',10,0,0,NULL,0),(4133,35,'2026-11-29',10,0,0,NULL,0),(4134,35,'2026-11-30',10,0,0,NULL,0),(4135,35,'2026-12-01',10,0,0,NULL,0),(4136,35,'2026-12-02',10,0,0,NULL,0),(4137,35,'2026-12-03',10,0,0,NULL,0),(4138,35,'2026-12-04',10,0,0,NULL,0),(4139,35,'2026-12-05',10,0,0,NULL,0),(4140,35,'2026-12-06',10,0,0,NULL,0),(4141,35,'2026-12-07',10,0,0,NULL,0),(4142,35,'2026-12-08',10,0,0,NULL,0),(4143,35,'2026-12-09',10,0,0,NULL,0),(4144,35,'2026-12-10',10,0,0,NULL,0),(4145,35,'2026-12-11',10,0,0,NULL,0),(4146,35,'2026-12-12',10,0,0,NULL,0),(4147,35,'2026-12-13',10,0,0,NULL,0),(4148,35,'2026-12-14',10,0,0,NULL,0),(4149,35,'2026-12-15',10,0,0,NULL,0),(4150,35,'2026-12-16',10,0,0,NULL,0),(4151,35,'2026-12-17',10,0,0,NULL,0),(4152,35,'2026-12-18',10,0,0,NULL,0),(4153,35,'2026-12-19',10,0,0,NULL,0),(4154,35,'2026-12-20',10,0,0,NULL,0),(4155,35,'2026-12-21',10,0,0,NULL,0),(4156,35,'2026-12-22',10,0,0,NULL,0),(4157,35,'2026-12-23',10,0,0,NULL,0),(4158,35,'2026-12-24',10,0,0,NULL,0),(4159,35,'2026-12-25',10,0,0,NULL,0),(4160,35,'2026-12-26',10,0,0,NULL,0),(4161,35,'2026-12-27',10,0,0,NULL,0),(4162,35,'2026-12-28',10,0,0,NULL,0),(4163,35,'2026-12-29',10,0,0,NULL,0),(4164,35,'2026-12-30',10,0,0,NULL,0),(4165,35,'2026-12-31',10,0,0,NULL,0),(4166,35,'2027-01-01',10,0,0,NULL,0),(4167,35,'2027-01-02',10,0,0,NULL,0),(4168,35,'2027-01-03',10,0,0,NULL,0),(4169,35,'2027-01-04',10,0,0,NULL,0),(4170,35,'2027-01-05',10,0,0,NULL,0),(4171,35,'2027-01-06',10,0,0,NULL,0),(4172,35,'2027-01-07',10,0,0,NULL,0),(4173,35,'2027-01-08',10,0,0,NULL,0),(4174,35,'2027-01-09',10,0,0,NULL,0),(4175,35,'2027-01-10',10,0,0,NULL,0),(4176,35,'2027-01-11',10,0,0,NULL,0),(4177,35,'2027-01-12',10,0,0,NULL,0),(4178,35,'2027-01-13',10,0,0,NULL,0),(4179,35,'2027-01-14',10,0,0,NULL,0),(4180,35,'2027-01-15',10,0,0,NULL,0),(4181,35,'2027-01-16',10,0,0,NULL,0),(4182,35,'2027-01-17',10,0,0,NULL,0),(4183,35,'2027-01-18',10,0,0,NULL,0),(4184,35,'2027-01-19',10,0,0,NULL,0),(4185,35,'2027-01-20',10,0,0,NULL,0),(4186,35,'2027-01-21',10,0,0,NULL,0),(4187,35,'2027-01-22',10,0,0,NULL,0),(4188,35,'2027-01-23',10,0,0,NULL,0),(4189,35,'2027-01-24',10,0,0,NULL,0),(4190,35,'2027-01-25',10,0,0,NULL,0),(4191,35,'2027-01-26',10,0,0,NULL,0),(4192,35,'2027-01-27',10,0,0,NULL,0),(4193,35,'2027-01-28',10,0,0,NULL,0),(4194,35,'2027-01-29',10,0,0,NULL,0),(4195,35,'2027-01-30',10,0,0,NULL,0),(4196,35,'2027-01-31',10,0,0,NULL,0),(4197,35,'2027-02-01',10,0,0,NULL,0),(4198,35,'2027-02-02',10,0,0,NULL,0),(4199,35,'2027-02-03',10,0,0,NULL,0),(4200,35,'2027-02-04',10,0,0,NULL,0),(4201,36,'2026-10-08',4,0,0,NULL,0),(4202,36,'2026-10-09',4,0,0,NULL,0),(4203,36,'2026-10-10',4,0,0,NULL,0),(4204,36,'2026-10-11',4,0,0,NULL,0),(4205,36,'2026-10-12',4,0,0,NULL,0),(4206,36,'2026-10-13',4,0,0,NULL,0),(4207,36,'2026-10-14',4,0,0,NULL,0),(4208,36,'2026-10-15',4,0,0,NULL,0),(4209,36,'2026-10-16',4,0,0,NULL,0),(4210,36,'2026-10-17',4,0,0,NULL,0),(4211,36,'2026-10-18',4,0,0,NULL,0),(4212,36,'2026-10-19',4,0,0,NULL,0),(4213,36,'2026-10-20',4,0,0,NULL,0),(4214,36,'2026-10-21',4,0,0,NULL,0),(4215,36,'2026-10-22',4,0,0,NULL,0),(4216,36,'2026-10-23',4,0,0,NULL,0),(4217,36,'2026-10-24',4,0,0,NULL,0),(4218,36,'2026-10-25',4,0,0,NULL,0),(4219,36,'2026-10-26',4,0,0,NULL,0),(4220,36,'2026-10-27',4,0,0,NULL,0),(4221,36,'2026-10-28',4,0,0,NULL,0),(4222,36,'2026-10-29',4,0,0,NULL,0),(4223,36,'2026-10-30',4,0,0,NULL,0),(4224,36,'2026-10-31',4,0,0,NULL,0),(4225,36,'2026-11-01',4,0,0,NULL,0),(4226,36,'2026-11-02',4,0,0,NULL,0),(4227,36,'2026-11-03',4,0,0,NULL,0),(4228,36,'2026-11-04',4,0,0,NULL,0),(4229,36,'2026-11-05',4,0,0,NULL,0),(4230,36,'2026-11-06',4,0,0,NULL,0),(4231,36,'2026-11-07',4,0,0,NULL,0),(4232,36,'2026-11-08',4,0,0,NULL,0),(4233,36,'2026-11-09',4,0,0,NULL,0),(4234,36,'2026-11-10',4,0,0,NULL,0),(4235,36,'2026-11-11',4,0,0,NULL,0),(4236,36,'2026-11-12',4,0,0,NULL,0),(4237,36,'2026-11-13',4,0,0,NULL,0),(4238,36,'2026-11-14',4,0,0,NULL,0),(4239,36,'2026-11-15',4,0,0,NULL,0),(4240,36,'2026-11-16',4,0,0,NULL,0),(4241,36,'2026-11-17',4,0,0,NULL,0),(4242,36,'2026-11-18',4,0,0,NULL,0),(4243,36,'2026-11-19',4,0,0,NULL,0),(4244,36,'2026-11-20',4,0,0,NULL,0),(4245,36,'2026-11-21',4,0,0,NULL,0),(4246,36,'2026-11-22',4,0,0,NULL,0),(4247,36,'2026-11-23',4,0,0,NULL,0),(4248,36,'2026-11-24',4,0,0,NULL,0),(4249,36,'2026-11-25',4,0,0,NULL,0),(4250,36,'2026-11-26',4,0,0,NULL,0),(4251,36,'2026-11-27',4,0,0,NULL,0),(4252,36,'2026-11-28',4,0,0,NULL,0),(4253,36,'2026-11-29',4,0,0,NULL,0),(4254,36,'2026-11-30',4,0,0,NULL,0),(4255,36,'2026-12-01',4,0,0,NULL,0),(4256,36,'2026-12-02',4,0,0,NULL,0),(4257,36,'2026-12-03',4,0,0,NULL,0),(4258,36,'2026-12-04',4,0,0,NULL,0),(4259,36,'2026-12-05',4,0,0,NULL,0),(4260,36,'2026-12-06',4,0,0,NULL,0),(4261,36,'2026-12-07',4,0,0,NULL,0),(4262,36,'2026-12-08',4,0,0,NULL,0),(4263,36,'2026-12-09',4,0,0,NULL,0),(4264,36,'2026-12-10',4,0,0,NULL,0),(4265,36,'2026-12-11',4,0,0,NULL,0),(4266,36,'2026-12-12',4,0,0,NULL,0),(4267,36,'2026-12-13',4,0,0,NULL,0),(4268,36,'2026-12-14',4,0,0,NULL,0),(4269,36,'2026-12-15',4,0,0,NULL,0),(4270,36,'2026-12-16',4,0,0,NULL,0),(4271,36,'2026-12-17',4,0,0,NULL,0),(4272,36,'2026-12-18',4,0,0,NULL,0),(4273,36,'2026-12-19',4,0,0,NULL,0),(4274,36,'2026-12-20',4,0,0,NULL,0),(4275,36,'2026-12-21',4,0,0,NULL,0),(4276,36,'2026-12-22',4,0,0,NULL,0),(4277,36,'2026-12-23',4,0,0,NULL,0),(4278,36,'2026-12-24',4,0,0,NULL,0),(4279,36,'2026-12-25',4,0,0,NULL,0),(4280,36,'2026-12-26',4,0,0,NULL,0),(4281,36,'2026-12-27',4,0,0,NULL,0),(4282,36,'2026-12-28',4,0,0,NULL,0),(4283,36,'2026-12-29',4,0,0,NULL,0),(4284,36,'2026-12-30',4,0,0,NULL,0),(4285,36,'2026-12-31',4,0,0,NULL,0),(4286,36,'2027-01-01',4,0,0,NULL,0),(4287,36,'2027-01-02',4,0,0,NULL,0),(4288,36,'2027-01-03',4,0,0,NULL,0),(4289,36,'2027-01-04',4,0,0,NULL,0),(4290,36,'2027-01-05',4,0,0,NULL,0),(4291,36,'2027-01-06',4,0,0,NULL,0),(4292,36,'2027-01-07',4,0,0,NULL,0),(4293,36,'2027-01-08',4,0,0,NULL,0),(4294,36,'2027-01-09',4,0,0,NULL,0),(4295,36,'2027-01-10',4,0,0,NULL,0),(4296,36,'2027-01-11',4,0,0,NULL,0),(4297,36,'2027-01-12',4,0,0,NULL,0),(4298,36,'2027-01-13',4,0,0,NULL,0),(4299,36,'2027-01-14',4,0,0,NULL,0),(4300,36,'2027-01-15',4,0,0,NULL,0),(4301,36,'2027-01-16',4,0,0,NULL,0),(4302,36,'2027-01-17',4,0,0,NULL,0),(4303,36,'2027-01-18',4,0,0,NULL,0),(4304,36,'2027-01-19',4,0,0,NULL,0),(4305,36,'2027-01-20',4,0,0,NULL,0),(4306,36,'2027-01-21',4,0,0,NULL,0),(4307,36,'2027-01-22',4,0,0,NULL,0),(4308,36,'2027-01-23',4,0,0,NULL,0),(4309,36,'2027-01-24',4,0,0,NULL,0),(4310,36,'2027-01-25',4,0,0,NULL,0),(4311,36,'2027-01-26',4,0,0,NULL,0),(4312,36,'2027-01-27',4,0,0,NULL,0),(4313,36,'2027-01-28',4,0,0,NULL,0),(4314,36,'2027-01-29',4,0,0,NULL,0),(4315,36,'2027-01-30',4,0,0,NULL,0),(4316,36,'2027-01-31',4,0,0,NULL,0),(4317,36,'2027-02-01',4,0,0,NULL,0),(4318,36,'2027-02-02',4,0,0,NULL,0),(4319,36,'2027-02-03',4,0,0,NULL,0),(4320,36,'2027-02-04',4,0,0,NULL,0),(4321,37,'2026-10-08',4,0,0,NULL,0),(4322,37,'2026-10-09',4,0,0,NULL,0),(4323,37,'2026-10-10',4,0,0,NULL,0),(4324,37,'2026-10-11',4,0,0,NULL,0),(4325,37,'2026-10-12',4,0,0,NULL,0),(4326,37,'2026-10-13',4,0,0,NULL,0),(4327,37,'2026-10-14',4,0,0,NULL,0),(4328,37,'2026-10-15',4,0,0,NULL,0),(4329,37,'2026-10-16',4,0,0,NULL,0),(4330,37,'2026-10-17',4,0,0,NULL,0),(4331,37,'2026-10-18',4,0,0,NULL,0),(4332,37,'2026-10-19',4,0,0,NULL,0),(4333,37,'2026-10-20',4,0,0,NULL,0),(4334,37,'2026-10-21',4,0,0,NULL,0),(4335,37,'2026-10-22',4,0,0,NULL,0),(4336,37,'2026-10-23',4,0,0,NULL,0),(4337,37,'2026-10-24',4,0,0,NULL,0),(4338,37,'2026-10-25',4,0,0,NULL,0),(4339,37,'2026-10-26',4,0,0,NULL,0),(4340,37,'2026-10-27',4,0,0,NULL,0),(4341,37,'2026-10-28',4,0,0,NULL,0),(4342,37,'2026-10-29',4,0,0,NULL,0),(4343,37,'2026-10-30',4,0,0,NULL,0),(4344,37,'2026-10-31',4,0,0,NULL,0),(4345,37,'2026-11-01',4,0,0,NULL,0),(4346,37,'2026-11-02',4,0,0,NULL,0),(4347,37,'2026-11-03',4,0,0,NULL,0),(4348,37,'2026-11-04',4,0,0,NULL,0),(4349,37,'2026-11-05',4,0,0,NULL,0),(4350,37,'2026-11-06',4,0,0,NULL,0),(4351,37,'2026-11-07',4,0,0,NULL,0),(4352,37,'2026-11-08',4,0,0,NULL,0),(4353,37,'2026-11-09',4,0,0,NULL,0),(4354,37,'2026-11-10',4,0,0,NULL,0),(4355,37,'2026-11-11',4,0,0,NULL,0),(4356,37,'2026-11-12',4,0,0,NULL,0),(4357,37,'2026-11-13',4,0,0,NULL,0),(4358,37,'2026-11-14',4,0,0,NULL,0),(4359,37,'2026-11-15',4,0,0,NULL,0),(4360,37,'2026-11-16',4,0,0,NULL,0),(4361,37,'2026-11-17',4,0,0,NULL,0),(4362,37,'2026-11-18',4,0,0,NULL,0),(4363,37,'2026-11-19',4,0,0,NULL,0),(4364,37,'2026-11-20',4,0,0,NULL,0),(4365,37,'2026-11-21',4,0,0,NULL,0),(4366,37,'2026-11-22',4,0,0,NULL,0),(4367,37,'2026-11-23',4,0,0,NULL,0),(4368,37,'2026-11-24',4,0,0,NULL,0),(4369,37,'2026-11-25',4,0,0,NULL,0),(4370,37,'2026-11-26',4,0,0,NULL,0),(4371,37,'2026-11-27',4,0,0,NULL,0),(4372,37,'2026-11-28',4,0,0,NULL,0),(4373,37,'2026-11-29',4,0,0,NULL,0),(4374,37,'2026-11-30',4,0,0,NULL,0),(4375,37,'2026-12-01',4,0,0,NULL,0),(4376,37,'2026-12-02',4,0,0,NULL,0),(4377,37,'2026-12-03',4,0,0,NULL,0),(4378,37,'2026-12-04',4,0,0,NULL,0),(4379,37,'2026-12-05',4,0,0,NULL,0),(4380,37,'2026-12-06',4,0,0,NULL,0),(4381,37,'2026-12-07',4,0,0,NULL,0),(4382,37,'2026-12-08',4,0,0,NULL,0),(4383,37,'2026-12-09',4,0,0,NULL,0),(4384,37,'2026-12-10',4,0,0,NULL,0),(4385,37,'2026-12-11',4,0,0,NULL,0),(4386,37,'2026-12-12',4,0,0,NULL,0),(4387,37,'2026-12-13',4,0,0,NULL,0),(4388,37,'2026-12-14',4,0,0,NULL,0),(4389,37,'2026-12-15',4,0,0,NULL,0),(4390,37,'2026-12-16',4,0,0,NULL,0),(4391,37,'2026-12-17',4,0,0,NULL,0),(4392,37,'2026-12-18',4,0,0,NULL,0),(4393,37,'2026-12-19',4,0,0,NULL,0),(4394,37,'2026-12-20',4,0,0,NULL,0),(4395,37,'2026-12-21',4,0,0,NULL,0),(4396,37,'2026-12-22',4,0,0,NULL,0),(4397,37,'2026-12-23',4,0,0,NULL,0),(4398,37,'2026-12-24',4,0,0,NULL,0),(4399,37,'2026-12-25',4,0,0,NULL,0),(4400,37,'2026-12-26',4,0,0,NULL,0),(4401,37,'2026-12-27',4,0,0,NULL,0),(4402,37,'2026-12-28',4,0,0,NULL,0),(4403,37,'2026-12-29',4,0,0,NULL,0),(4404,37,'2026-12-30',4,0,0,NULL,0),(4405,37,'2026-12-31',4,0,0,NULL,0),(4406,37,'2027-01-01',4,0,0,NULL,0),(4407,37,'2027-01-02',4,0,0,NULL,0),(4408,37,'2027-01-03',4,0,0,NULL,0),(4409,37,'2027-01-04',4,0,0,NULL,0),(4410,37,'2027-01-05',4,0,0,NULL,0),(4411,37,'2027-01-06',4,0,0,NULL,0),(4412,37,'2027-01-07',4,0,0,NULL,0),(4413,37,'2027-01-08',4,0,0,NULL,0),(4414,37,'2027-01-09',4,0,0,NULL,0),(4415,37,'2027-01-10',4,0,0,NULL,0),(4416,37,'2027-01-11',4,0,0,NULL,0),(4417,37,'2027-01-12',4,0,0,NULL,0),(4418,37,'2027-01-13',4,0,0,NULL,0),(4419,37,'2027-01-14',4,0,0,NULL,0),(4420,37,'2027-01-15',4,0,0,NULL,0),(4421,37,'2027-01-16',4,0,0,NULL,0),(4422,37,'2027-01-17',4,0,0,NULL,0),(4423,37,'2027-01-18',4,0,0,NULL,0),(4424,37,'2027-01-19',4,0,0,NULL,0),(4425,37,'2027-01-20',4,0,0,NULL,0),(4426,37,'2027-01-21',4,0,0,NULL,0),(4427,37,'2027-01-22',4,0,0,NULL,0),(4428,37,'2027-01-23',4,0,0,NULL,0),(4429,37,'2027-01-24',4,0,0,NULL,0),(4430,37,'2027-01-25',4,0,0,NULL,0),(4431,37,'2027-01-26',4,0,0,NULL,0),(4432,37,'2027-01-27',4,0,0,NULL,0),(4433,37,'2027-01-28',4,0,0,NULL,0),(4434,37,'2027-01-29',4,0,0,NULL,0),(4435,37,'2027-01-30',4,0,0,NULL,0),(4436,37,'2027-01-31',4,0,0,NULL,0),(4437,37,'2027-02-01',4,0,0,NULL,0),(4438,37,'2027-02-02',4,0,0,NULL,0),(4439,37,'2027-02-03',4,0,0,NULL,0),(4440,37,'2027-02-04',4,0,0,NULL,0),(4441,38,'2026-10-08',3,0,0,NULL,0),(4442,38,'2026-10-09',3,0,0,NULL,0),(4443,38,'2026-10-10',3,0,0,NULL,0),(4444,38,'2026-10-11',3,0,0,NULL,0),(4445,38,'2026-10-12',3,0,0,NULL,0),(4446,38,'2026-10-13',3,0,0,NULL,0),(4447,38,'2026-10-14',3,0,0,NULL,0),(4448,38,'2026-10-15',3,0,0,NULL,0),(4449,38,'2026-10-16',3,0,0,NULL,0),(4450,38,'2026-10-17',3,0,0,NULL,0),(4451,38,'2026-10-18',3,0,0,NULL,0),(4452,38,'2026-10-19',3,0,0,NULL,0),(4453,38,'2026-10-20',3,0,0,NULL,0),(4454,38,'2026-10-21',3,0,0,NULL,0),(4455,38,'2026-10-22',3,0,0,NULL,0),(4456,38,'2026-10-23',3,0,0,NULL,0),(4457,38,'2026-10-24',3,0,0,NULL,0),(4458,38,'2026-10-25',3,0,0,NULL,0),(4459,38,'2026-10-26',3,0,0,NULL,0),(4460,38,'2026-10-27',3,0,0,NULL,0),(4461,38,'2026-10-28',3,0,0,NULL,0),(4462,38,'2026-10-29',3,0,0,NULL,0),(4463,38,'2026-10-30',3,0,0,NULL,0),(4464,38,'2026-10-31',3,0,0,NULL,0),(4465,38,'2026-11-01',3,0,0,NULL,0),(4466,38,'2026-11-02',3,0,0,NULL,0),(4467,38,'2026-11-03',3,0,0,NULL,0),(4468,38,'2026-11-04',3,0,0,NULL,0),(4469,38,'2026-11-05',3,0,0,NULL,0),(4470,38,'2026-11-06',3,0,0,NULL,0),(4471,38,'2026-11-07',3,0,0,NULL,0),(4472,38,'2026-11-08',3,0,0,NULL,0),(4473,38,'2026-11-09',3,0,0,NULL,0),(4474,38,'2026-11-10',3,0,0,NULL,0),(4475,38,'2026-11-11',3,0,0,NULL,0),(4476,38,'2026-11-12',3,0,0,NULL,0),(4477,38,'2026-11-13',3,0,0,NULL,0),(4478,38,'2026-11-14',3,0,0,NULL,0),(4479,38,'2026-11-15',3,0,0,NULL,0),(4480,38,'2026-11-16',3,0,0,NULL,0),(4481,38,'2026-11-17',3,0,0,NULL,0),(4482,38,'2026-11-18',3,0,0,NULL,0),(4483,38,'2026-11-19',3,0,0,NULL,0),(4484,38,'2026-11-20',3,0,0,NULL,0),(4485,38,'2026-11-21',3,0,0,NULL,0),(4486,38,'2026-11-22',3,0,0,NULL,0),(4487,38,'2026-11-23',3,0,0,NULL,0),(4488,38,'2026-11-24',3,0,0,NULL,0),(4489,38,'2026-11-25',3,0,0,NULL,0),(4490,38,'2026-11-26',3,0,0,NULL,0),(4491,38,'2026-11-27',3,0,0,NULL,0),(4492,38,'2026-11-28',3,0,0,NULL,0),(4493,38,'2026-11-29',3,0,0,NULL,0),(4494,38,'2026-11-30',3,0,0,NULL,0),(4495,38,'2026-12-01',3,0,0,NULL,0),(4496,38,'2026-12-02',3,0,0,NULL,0),(4497,38,'2026-12-03',3,0,0,NULL,0),(4498,38,'2026-12-04',3,0,0,NULL,0),(4499,38,'2026-12-05',3,0,0,NULL,0),(4500,38,'2026-12-06',3,0,0,NULL,0),(4501,38,'2026-12-07',3,0,0,NULL,0),(4502,38,'2026-12-08',3,0,0,NULL,0),(4503,38,'2026-12-09',3,0,0,NULL,0),(4504,38,'2026-12-10',3,0,0,NULL,0),(4505,38,'2026-12-11',3,0,0,NULL,0),(4506,38,'2026-12-12',3,0,0,NULL,0),(4507,38,'2026-12-13',3,0,0,NULL,0),(4508,38,'2026-12-14',3,0,0,NULL,0),(4509,38,'2026-12-15',3,0,0,NULL,0),(4510,38,'2026-12-16',3,0,0,NULL,0),(4511,38,'2026-12-17',3,0,0,NULL,0),(4512,38,'2026-12-18',3,0,0,NULL,0),(4513,38,'2026-12-19',3,0,0,NULL,0),(4514,38,'2026-12-20',3,0,0,NULL,0),(4515,38,'2026-12-21',3,0,0,NULL,0),(4516,38,'2026-12-22',3,0,0,NULL,0),(4517,38,'2026-12-23',3,0,0,NULL,0),(4518,38,'2026-12-24',3,0,0,NULL,0),(4519,38,'2026-12-25',3,0,0,NULL,0),(4520,38,'2026-12-26',3,0,0,NULL,0),(4521,38,'2026-12-27',3,0,0,NULL,0),(4522,38,'2026-12-28',3,0,0,NULL,0),(4523,38,'2026-12-29',3,0,0,NULL,0),(4524,38,'2026-12-30',3,0,0,NULL,0),(4525,38,'2026-12-31',3,0,0,NULL,0),(4526,38,'2027-01-01',3,0,0,NULL,0),(4527,38,'2027-01-02',3,0,0,NULL,0),(4528,38,'2027-01-03',3,0,0,NULL,0),(4529,38,'2027-01-04',3,0,0,NULL,0),(4530,38,'2027-01-05',3,0,0,NULL,0),(4531,38,'2027-01-06',3,0,0,NULL,0),(4532,38,'2027-01-07',3,0,0,NULL,0),(4533,38,'2027-01-08',3,0,0,NULL,0),(4534,38,'2027-01-09',3,0,0,NULL,0),(4535,38,'2027-01-10',3,0,0,NULL,0),(4536,38,'2027-01-11',3,0,0,NULL,0),(4537,38,'2027-01-12',3,0,0,NULL,0),(4538,38,'2027-01-13',3,0,0,NULL,0),(4539,38,'2027-01-14',3,0,0,NULL,0),(4540,38,'2027-01-15',3,0,0,NULL,0),(4541,38,'2027-01-16',3,0,0,NULL,0),(4542,38,'2027-01-17',3,0,0,NULL,0),(4543,38,'2027-01-18',3,0,0,NULL,0),(4544,38,'2027-01-19',3,0,0,NULL,0),(4545,38,'2027-01-20',3,0,0,NULL,0),(4546,38,'2027-01-21',3,0,0,NULL,0),(4547,38,'2027-01-22',3,0,0,NULL,0),(4548,38,'2027-01-23',3,0,0,NULL,0),(4549,38,'2027-01-24',3,0,0,NULL,0),(4550,38,'2027-01-25',3,0,0,NULL,0),(4551,38,'2027-01-26',3,0,0,NULL,0),(4552,38,'2027-01-27',3,0,0,NULL,0),(4553,38,'2027-01-28',3,0,0,NULL,0),(4554,38,'2027-01-29',3,0,0,NULL,0),(4555,38,'2027-01-30',3,0,0,NULL,0),(4556,38,'2027-01-31',3,0,0,NULL,0),(4557,38,'2027-02-01',3,0,0,NULL,0),(4558,38,'2027-02-02',3,0,0,NULL,0),(4559,38,'2027-02-03',3,0,0,NULL,0),(4560,38,'2027-02-04',3,0,0,NULL,0),(4561,39,'2026-10-08',5,0,0,NULL,0),(4562,39,'2026-10-09',5,0,0,NULL,0),(4563,39,'2026-10-10',5,0,0,NULL,0),(4564,39,'2026-10-11',5,0,0,NULL,0),(4565,39,'2026-10-12',5,0,0,NULL,0),(4566,39,'2026-10-13',5,0,0,NULL,0),(4567,39,'2026-10-14',5,0,0,NULL,0),(4568,39,'2026-10-15',5,0,0,NULL,0),(4569,39,'2026-10-16',5,0,0,NULL,0),(4570,39,'2026-10-17',5,0,0,NULL,0),(4571,39,'2026-10-18',5,0,0,NULL,0),(4572,39,'2026-10-19',5,0,0,NULL,0),(4573,39,'2026-10-20',5,0,0,NULL,0),(4574,39,'2026-10-21',5,0,0,NULL,0),(4575,39,'2026-10-22',5,0,0,NULL,0),(4576,39,'2026-10-23',5,0,0,NULL,0),(4577,39,'2026-10-24',5,0,0,NULL,0),(4578,39,'2026-10-25',5,0,0,NULL,0),(4579,39,'2026-10-26',5,0,0,NULL,0),(4580,39,'2026-10-27',5,0,0,NULL,0),(4581,39,'2026-10-28',5,0,0,NULL,0),(4582,39,'2026-10-29',5,0,0,NULL,0),(4583,39,'2026-10-30',5,0,0,NULL,0),(4584,39,'2026-10-31',5,0,0,NULL,0),(4585,39,'2026-11-01',5,0,0,NULL,0),(4586,39,'2026-11-02',5,0,0,NULL,0),(4587,39,'2026-11-03',5,0,0,NULL,0),(4588,39,'2026-11-04',5,0,0,NULL,0),(4589,39,'2026-11-05',5,0,0,NULL,0),(4590,39,'2026-11-06',5,0,0,NULL,0),(4591,39,'2026-11-07',5,0,0,NULL,0),(4592,39,'2026-11-08',5,0,0,NULL,0),(4593,39,'2026-11-09',5,0,0,NULL,0),(4594,39,'2026-11-10',5,0,0,NULL,0),(4595,39,'2026-11-11',5,0,0,NULL,0),(4596,39,'2026-11-12',5,0,0,NULL,0),(4597,39,'2026-11-13',5,0,0,NULL,0),(4598,39,'2026-11-14',5,0,0,NULL,0),(4599,39,'2026-11-15',5,0,0,NULL,0),(4600,39,'2026-11-16',5,0,0,NULL,0),(4601,39,'2026-11-17',5,0,0,NULL,0),(4602,39,'2026-11-18',5,0,0,NULL,0),(4603,39,'2026-11-19',5,0,0,NULL,0),(4604,39,'2026-11-20',5,0,0,NULL,0),(4605,39,'2026-11-21',5,0,0,NULL,0),(4606,39,'2026-11-22',5,0,0,NULL,0),(4607,39,'2026-11-23',5,0,0,NULL,0),(4608,39,'2026-11-24',5,0,0,NULL,0),(4609,39,'2026-11-25',5,0,0,NULL,0),(4610,39,'2026-11-26',5,0,0,NULL,0),(4611,39,'2026-11-27',5,0,0,NULL,0),(4612,39,'2026-11-28',5,0,0,NULL,0),(4613,39,'2026-11-29',5,0,0,NULL,0),(4614,39,'2026-11-30',5,0,0,NULL,0),(4615,39,'2026-12-01',5,0,0,NULL,0),(4616,39,'2026-12-02',5,0,0,NULL,0),(4617,39,'2026-12-03',5,0,0,NULL,0),(4618,39,'2026-12-04',5,0,0,NULL,0),(4619,39,'2026-12-05',5,0,0,NULL,0),(4620,39,'2026-12-06',5,0,0,NULL,0),(4621,39,'2026-12-07',5,0,0,NULL,0),(4622,39,'2026-12-08',5,0,0,NULL,0),(4623,39,'2026-12-09',5,0,0,NULL,0),(4624,39,'2026-12-10',5,0,0,NULL,0),(4625,39,'2026-12-11',5,0,0,NULL,0),(4626,39,'2026-12-12',5,0,0,NULL,0),(4627,39,'2026-12-13',5,0,0,NULL,0),(4628,39,'2026-12-14',5,0,0,NULL,0),(4629,39,'2026-12-15',5,0,0,NULL,0),(4630,39,'2026-12-16',5,0,0,NULL,0),(4631,39,'2026-12-17',5,0,0,NULL,0),(4632,39,'2026-12-18',5,0,0,NULL,0),(4633,39,'2026-12-19',5,0,0,NULL,0),(4634,39,'2026-12-20',5,0,0,NULL,0),(4635,39,'2026-12-21',5,0,0,NULL,0),(4636,39,'2026-12-22',5,0,0,NULL,0),(4637,39,'2026-12-23',5,0,0,NULL,0),(4638,39,'2026-12-24',5,0,0,NULL,0),(4639,39,'2026-12-25',5,0,0,NULL,0),(4640,39,'2026-12-26',5,0,0,NULL,0),(4641,39,'2026-12-27',5,0,0,NULL,0),(4642,39,'2026-12-28',5,0,0,NULL,0),(4643,39,'2026-12-29',5,0,0,NULL,0),(4644,39,'2026-12-30',5,0,0,NULL,0),(4645,39,'2026-12-31',5,0,0,NULL,0),(4646,39,'2027-01-01',5,0,0,NULL,0),(4647,39,'2027-01-02',5,0,0,NULL,0),(4648,39,'2027-01-03',5,0,0,NULL,0),(4649,39,'2027-01-04',5,0,0,NULL,0),(4650,39,'2027-01-05',5,0,0,NULL,0),(4651,39,'2027-01-06',5,0,0,NULL,0),(4652,39,'2027-01-07',5,0,0,NULL,0),(4653,39,'2027-01-08',5,0,0,NULL,0),(4654,39,'2027-01-09',5,0,0,NULL,0),(4655,39,'2027-01-10',5,0,0,NULL,0),(4656,39,'2027-01-11',5,0,0,NULL,0),(4657,39,'2027-01-12',5,0,0,NULL,0),(4658,39,'2027-01-13',5,0,0,NULL,0),(4659,39,'2027-01-14',5,0,0,NULL,0),(4660,39,'2027-01-15',5,0,0,NULL,0),(4661,39,'2027-01-16',5,0,0,NULL,0),(4662,39,'2027-01-17',5,0,0,NULL,0),(4663,39,'2027-01-18',5,0,0,NULL,0),(4664,39,'2027-01-19',5,0,0,NULL,0),(4665,39,'2027-01-20',5,0,0,NULL,0),(4666,39,'2027-01-21',5,0,0,NULL,0),(4667,39,'2027-01-22',5,0,0,NULL,0),(4668,39,'2027-01-23',5,0,0,NULL,0),(4669,39,'2027-01-24',5,0,0,NULL,0),(4670,39,'2027-01-25',5,0,0,NULL,0),(4671,39,'2027-01-26',5,0,0,NULL,0),(4672,39,'2027-01-27',5,0,0,NULL,0),(4673,39,'2027-01-28',5,0,0,NULL,0),(4674,39,'2027-01-29',5,0,0,NULL,0),(4675,39,'2027-01-30',5,0,0,NULL,0),(4676,39,'2027-01-31',5,0,0,NULL,0),(4677,39,'2027-02-01',5,0,0,NULL,0),(4678,39,'2027-02-02',5,0,0,NULL,0),(4679,39,'2027-02-03',5,0,0,NULL,0),(4680,39,'2027-02-04',5,0,0,NULL,0),(4681,40,'2026-10-08',2,0,0,NULL,0),(4682,40,'2026-10-09',2,0,0,NULL,0),(4683,40,'2026-10-10',2,0,0,NULL,0),(4684,40,'2026-10-11',2,0,0,NULL,0),(4685,40,'2026-10-12',2,0,0,NULL,0),(4686,40,'2026-10-13',2,0,0,NULL,0),(4687,40,'2026-10-14',2,0,0,NULL,0),(4688,40,'2026-10-15',2,0,0,NULL,0),(4689,40,'2026-10-16',2,0,0,NULL,0),(4690,40,'2026-10-17',2,0,0,NULL,0),(4691,40,'2026-10-18',2,0,0,NULL,0),(4692,40,'2026-10-19',2,0,0,NULL,0),(4693,40,'2026-10-20',2,0,0,NULL,0),(4694,40,'2026-10-21',2,0,0,NULL,0),(4695,40,'2026-10-22',2,0,0,NULL,0),(4696,40,'2026-10-23',2,0,0,NULL,0),(4697,40,'2026-10-24',2,0,0,NULL,0),(4698,40,'2026-10-25',2,0,0,NULL,0),(4699,40,'2026-10-26',2,0,0,NULL,0),(4700,40,'2026-10-27',2,0,0,NULL,0),(4701,40,'2026-10-28',2,0,0,NULL,0),(4702,40,'2026-10-29',2,0,0,NULL,0),(4703,40,'2026-10-30',2,0,0,NULL,0),(4704,40,'2026-10-31',2,0,0,NULL,0),(4705,40,'2026-11-01',2,0,0,NULL,0),(4706,40,'2026-11-02',2,0,0,NULL,0),(4707,40,'2026-11-03',2,0,0,NULL,0),(4708,40,'2026-11-04',2,0,0,NULL,0),(4709,40,'2026-11-05',2,0,0,NULL,0),(4710,40,'2026-11-06',2,0,0,NULL,0),(4711,40,'2026-11-07',2,0,0,NULL,0),(4712,40,'2026-11-08',2,0,0,NULL,0),(4713,40,'2026-11-09',2,0,0,NULL,0),(4714,40,'2026-11-10',2,0,0,NULL,0),(4715,40,'2026-11-11',2,0,0,NULL,0),(4716,40,'2026-11-12',2,0,0,NULL,0),(4717,40,'2026-11-13',2,0,0,NULL,0),(4718,40,'2026-11-14',2,0,0,NULL,0),(4719,40,'2026-11-15',2,0,0,NULL,0),(4720,40,'2026-11-16',2,0,0,NULL,0),(4721,40,'2026-11-17',2,0,0,NULL,0),(4722,40,'2026-11-18',2,0,0,NULL,0),(4723,40,'2026-11-19',2,0,0,NULL,0),(4724,40,'2026-11-20',2,0,0,NULL,0),(4725,40,'2026-11-21',2,0,0,NULL,0),(4726,40,'2026-11-22',2,0,0,NULL,0),(4727,40,'2026-11-23',2,0,0,NULL,0),(4728,40,'2026-11-24',2,0,0,NULL,0),(4729,40,'2026-11-25',2,0,0,NULL,0),(4730,40,'2026-11-26',2,0,0,NULL,0),(4731,40,'2026-11-27',2,0,0,NULL,0),(4732,40,'2026-11-28',2,0,0,NULL,0),(4733,40,'2026-11-29',2,0,0,NULL,0),(4734,40,'2026-11-30',2,0,0,NULL,0),(4735,40,'2026-12-01',2,0,0,NULL,0),(4736,40,'2026-12-02',2,0,0,NULL,0),(4737,40,'2026-12-03',2,0,0,NULL,0),(4738,40,'2026-12-04',2,0,0,NULL,0),(4739,40,'2026-12-05',2,0,0,NULL,0),(4740,40,'2026-12-06',2,0,0,NULL,0),(4741,40,'2026-12-07',2,0,0,NULL,0),(4742,40,'2026-12-08',2,0,0,NULL,0),(4743,40,'2026-12-09',2,0,0,NULL,0),(4744,40,'2026-12-10',2,0,0,NULL,0),(4745,40,'2026-12-11',2,0,0,NULL,0),(4746,40,'2026-12-12',2,0,0,NULL,0),(4747,40,'2026-12-13',2,0,0,NULL,0),(4748,40,'2026-12-14',2,0,0,NULL,0),(4749,40,'2026-12-15',2,0,0,NULL,0),(4750,40,'2026-12-16',2,0,0,NULL,0),(4751,40,'2026-12-17',2,0,0,NULL,0),(4752,40,'2026-12-18',2,0,0,NULL,0),(4753,40,'2026-12-19',2,0,0,NULL,0),(4754,40,'2026-12-20',2,0,0,NULL,0),(4755,40,'2026-12-21',2,0,0,NULL,0),(4756,40,'2026-12-22',2,0,0,NULL,0),(4757,40,'2026-12-23',2,0,0,NULL,0),(4758,40,'2026-12-24',2,0,0,NULL,0),(4759,40,'2026-12-25',2,0,0,NULL,0),(4760,40,'2026-12-26',2,0,0,NULL,0),(4761,40,'2026-12-27',2,0,0,NULL,0),(4762,40,'2026-12-28',2,0,0,NULL,0),(4763,40,'2026-12-29',2,0,0,NULL,0),(4764,40,'2026-12-30',2,0,0,NULL,0),(4765,40,'2026-12-31',2,0,0,NULL,0),(4766,40,'2027-01-01',2,0,0,NULL,0),(4767,40,'2027-01-02',2,0,0,NULL,0),(4768,40,'2027-01-03',2,0,0,NULL,0),(4769,40,'2027-01-04',2,0,0,NULL,0),(4770,40,'2027-01-05',2,0,0,NULL,0),(4771,40,'2027-01-06',2,0,0,NULL,0),(4772,40,'2027-01-07',2,0,0,NULL,0),(4773,40,'2027-01-08',2,0,0,NULL,0),(4774,40,'2027-01-09',2,0,0,NULL,0),(4775,40,'2027-01-10',2,0,0,NULL,0),(4776,40,'2027-01-11',2,0,0,NULL,0),(4777,40,'2027-01-12',2,0,0,NULL,0),(4778,40,'2027-01-13',2,0,0,NULL,0),(4779,40,'2027-01-14',2,0,0,NULL,0),(4780,40,'2027-01-15',2,0,0,NULL,0),(4781,40,'2027-01-16',2,0,0,NULL,0),(4782,40,'2027-01-17',2,0,0,NULL,0),(4783,40,'2027-01-18',2,0,0,NULL,0),(4784,40,'2027-01-19',2,0,0,NULL,0),(4785,40,'2027-01-20',2,0,0,NULL,0),(4786,40,'2027-01-21',2,0,0,NULL,0),(4787,40,'2027-01-22',2,0,0,NULL,0),(4788,40,'2027-01-23',2,0,0,NULL,0),(4789,40,'2027-01-24',2,0,0,NULL,0),(4790,40,'2027-01-25',2,0,0,NULL,0),(4791,40,'2027-01-26',2,0,0,NULL,0),(4792,40,'2027-01-27',2,0,0,NULL,0),(4793,40,'2027-01-28',2,0,0,NULL,0),(4794,40,'2027-01-29',2,0,0,NULL,0),(4795,40,'2027-01-30',2,0,0,NULL,0),(4796,40,'2027-01-31',2,0,0,NULL,0),(4797,40,'2027-02-01',2,0,0,NULL,0),(4798,40,'2027-02-02',2,0,0,NULL,0),(4799,40,'2027-02-03',2,0,0,NULL,0),(4800,40,'2027-02-04',2,0,0,NULL,0),(4801,41,'2026-10-08',6,0,0,NULL,0),(4802,41,'2026-10-09',6,0,0,NULL,0),(4803,41,'2026-10-10',6,0,0,NULL,0),(4804,41,'2026-10-11',6,0,0,NULL,0),(4805,41,'2026-10-12',6,0,0,NULL,0),(4806,41,'2026-10-13',6,0,0,NULL,0),(4807,41,'2026-10-14',6,0,0,NULL,0),(4808,41,'2026-10-15',6,0,0,NULL,0),(4809,41,'2026-10-16',6,0,0,NULL,0),(4810,41,'2026-10-17',6,0,0,NULL,0),(4811,41,'2026-10-18',6,0,0,NULL,0),(4812,41,'2026-10-19',6,0,0,NULL,0),(4813,41,'2026-10-20',6,0,0,NULL,0),(4814,41,'2026-10-21',6,0,0,NULL,0),(4815,41,'2026-10-22',6,0,0,NULL,0),(4816,41,'2026-10-23',6,0,0,NULL,0),(4817,41,'2026-10-24',6,0,0,NULL,0),(4818,41,'2026-10-25',6,0,0,NULL,0),(4819,41,'2026-10-26',6,0,0,NULL,0),(4820,41,'2026-10-27',6,0,0,NULL,0),(4821,41,'2026-10-28',6,0,0,NULL,0),(4822,41,'2026-10-29',6,0,0,NULL,0),(4823,41,'2026-10-30',6,0,0,NULL,0),(4824,41,'2026-10-31',6,0,0,NULL,0),(4825,41,'2026-11-01',6,0,0,NULL,0),(4826,41,'2026-11-02',6,0,0,NULL,0),(4827,41,'2026-11-03',6,0,0,NULL,0),(4828,41,'2026-11-04',6,0,0,NULL,0),(4829,41,'2026-11-05',6,0,0,NULL,0),(4830,41,'2026-11-06',6,0,0,NULL,0),(4831,41,'2026-11-07',6,0,0,NULL,0),(4832,41,'2026-11-08',6,0,0,NULL,0),(4833,41,'2026-11-09',6,0,0,NULL,0),(4834,41,'2026-11-10',6,0,0,NULL,0),(4835,41,'2026-11-11',6,0,0,NULL,0),(4836,41,'2026-11-12',6,0,0,NULL,0),(4837,41,'2026-11-13',6,0,0,NULL,0),(4838,41,'2026-11-14',6,0,0,NULL,0),(4839,41,'2026-11-15',6,0,0,NULL,0),(4840,41,'2026-11-16',6,0,0,NULL,0),(4841,41,'2026-11-17',6,0,0,NULL,0),(4842,41,'2026-11-18',6,0,0,NULL,0),(4843,41,'2026-11-19',6,0,0,NULL,0),(4844,41,'2026-11-20',6,0,0,NULL,0),(4845,41,'2026-11-21',6,0,0,NULL,0),(4846,41,'2026-11-22',6,0,0,NULL,0),(4847,41,'2026-11-23',6,0,0,NULL,0),(4848,41,'2026-11-24',6,0,0,NULL,0),(4849,41,'2026-11-25',6,0,0,NULL,0),(4850,41,'2026-11-26',6,0,0,NULL,0),(4851,41,'2026-11-27',6,0,0,NULL,0),(4852,41,'2026-11-28',6,0,0,NULL,0),(4853,41,'2026-11-29',6,0,0,NULL,0),(4854,41,'2026-11-30',6,0,0,NULL,0),(4855,41,'2026-12-01',6,0,0,NULL,0),(4856,41,'2026-12-02',6,0,0,NULL,0),(4857,41,'2026-12-03',6,0,0,NULL,0),(4858,41,'2026-12-04',6,0,0,NULL,0),(4859,41,'2026-12-05',6,0,0,NULL,0),(4860,41,'2026-12-06',6,0,0,NULL,0),(4861,41,'2026-12-07',6,0,0,NULL,0),(4862,41,'2026-12-08',6,0,0,NULL,0),(4863,41,'2026-12-09',6,0,0,NULL,0),(4864,41,'2026-12-10',6,0,0,NULL,0),(4865,41,'2026-12-11',6,0,0,NULL,0),(4866,41,'2026-12-12',6,0,0,NULL,0),(4867,41,'2026-12-13',6,0,0,NULL,0),(4868,41,'2026-12-14',6,0,0,NULL,0),(4869,41,'2026-12-15',6,0,0,NULL,0),(4870,41,'2026-12-16',6,0,0,NULL,0),(4871,41,'2026-12-17',6,0,0,NULL,0),(4872,41,'2026-12-18',6,0,0,NULL,0),(4873,41,'2026-12-19',6,0,0,NULL,0),(4874,41,'2026-12-20',6,0,0,NULL,0),(4875,41,'2026-12-21',6,0,0,NULL,0),(4876,41,'2026-12-22',6,0,0,NULL,0),(4877,41,'2026-12-23',6,0,0,NULL,0),(4878,41,'2026-12-24',6,0,0,NULL,0),(4879,41,'2026-12-25',6,0,0,NULL,0),(4880,41,'2026-12-26',6,0,0,NULL,0),(4881,41,'2026-12-27',6,0,0,NULL,0),(4882,41,'2026-12-28',6,0,0,NULL,0),(4883,41,'2026-12-29',6,0,0,NULL,0),(4884,41,'2026-12-30',6,0,0,NULL,0),(4885,41,'2026-12-31',6,0,0,NULL,0),(4886,41,'2027-01-01',6,0,0,NULL,0),(4887,41,'2027-01-02',6,0,0,NULL,0),(4888,41,'2027-01-03',6,0,0,NULL,0),(4889,41,'2027-01-04',6,0,0,NULL,0),(4890,41,'2027-01-05',6,0,0,NULL,0),(4891,41,'2027-01-06',6,0,0,NULL,0),(4892,41,'2027-01-07',6,0,0,NULL,0),(4893,41,'2027-01-08',6,0,0,NULL,0),(4894,41,'2027-01-09',6,0,0,NULL,0),(4895,41,'2027-01-10',6,0,0,NULL,0),(4896,41,'2027-01-11',6,0,0,NULL,0),(4897,41,'2027-01-12',6,0,0,NULL,0),(4898,41,'2027-01-13',6,0,0,NULL,0),(4899,41,'2027-01-14',6,0,0,NULL,0),(4900,41,'2027-01-15',6,0,0,NULL,0),(4901,41,'2027-01-16',6,0,0,NULL,0),(4902,41,'2027-01-17',6,0,0,NULL,0),(4903,41,'2027-01-18',6,0,0,NULL,0),(4904,41,'2027-01-19',6,0,0,NULL,0),(4905,41,'2027-01-20',6,0,0,NULL,0),(4906,41,'2027-01-21',6,0,0,NULL,0),(4907,41,'2027-01-22',6,0,0,NULL,0),(4908,41,'2027-01-23',6,0,0,NULL,0),(4909,41,'2027-01-24',6,0,0,NULL,0),(4910,41,'2027-01-25',6,0,0,NULL,0),(4911,41,'2027-01-26',6,0,0,NULL,0),(4912,41,'2027-01-27',6,0,0,NULL,0),(4913,41,'2027-01-28',6,0,0,NULL,0),(4914,41,'2027-01-29',6,0,0,NULL,0),(4915,41,'2027-01-30',6,0,0,NULL,0),(4916,41,'2027-01-31',6,0,0,NULL,0),(4917,41,'2027-02-01',6,0,0,NULL,0),(4918,41,'2027-02-02',6,0,0,NULL,0),(4919,41,'2027-02-03',6,0,0,NULL,0),(4920,41,'2027-02-04',6,0,0,NULL,0),(4921,42,'2026-10-08',4,0,0,NULL,0),(4922,42,'2026-10-09',4,0,0,NULL,0),(4923,42,'2026-10-10',4,0,0,NULL,0),(4924,42,'2026-10-11',4,0,0,NULL,0),(4925,42,'2026-10-12',4,0,0,NULL,0),(4926,42,'2026-10-13',4,0,0,NULL,0),(4927,42,'2026-10-14',4,0,0,NULL,0),(4928,42,'2026-10-15',4,0,0,NULL,0),(4929,42,'2026-10-16',4,0,0,NULL,0),(4930,42,'2026-10-17',4,0,0,NULL,0),(4931,42,'2026-10-18',4,0,0,NULL,0),(4932,42,'2026-10-19',4,0,0,NULL,0),(4933,42,'2026-10-20',4,0,0,NULL,0),(4934,42,'2026-10-21',4,0,0,NULL,0),(4935,42,'2026-10-22',4,0,0,NULL,0),(4936,42,'2026-10-23',4,0,0,NULL,0),(4937,42,'2026-10-24',4,0,0,NULL,0),(4938,42,'2026-10-25',4,0,0,NULL,0),(4939,42,'2026-10-26',4,0,0,NULL,0),(4940,42,'2026-10-27',4,0,0,NULL,0),(4941,42,'2026-10-28',4,0,0,NULL,0),(4942,42,'2026-10-29',4,0,0,NULL,0),(4943,42,'2026-10-30',4,0,0,NULL,0),(4944,42,'2026-10-31',4,0,0,NULL,0),(4945,42,'2026-11-01',4,0,0,NULL,0),(4946,42,'2026-11-02',4,0,0,NULL,0),(4947,42,'2026-11-03',4,0,0,NULL,0),(4948,42,'2026-11-04',4,0,0,NULL,0),(4949,42,'2026-11-05',4,0,0,NULL,0),(4950,42,'2026-11-06',4,0,0,NULL,0),(4951,42,'2026-11-07',4,0,0,NULL,0),(4952,42,'2026-11-08',4,0,0,NULL,0),(4953,42,'2026-11-09',4,0,0,NULL,0),(4954,42,'2026-11-10',4,0,0,NULL,0),(4955,42,'2026-11-11',4,0,0,NULL,0),(4956,42,'2026-11-12',4,0,0,NULL,0),(4957,42,'2026-11-13',4,0,0,NULL,0),(4958,42,'2026-11-14',4,0,0,NULL,0),(4959,42,'2026-11-15',4,0,0,NULL,0),(4960,42,'2026-11-16',4,0,0,NULL,0),(4961,42,'2026-11-17',4,0,0,NULL,0),(4962,42,'2026-11-18',4,0,0,NULL,0),(4963,42,'2026-11-19',4,0,0,NULL,0),(4964,42,'2026-11-20',4,0,0,NULL,0),(4965,42,'2026-11-21',4,0,0,NULL,0),(4966,42,'2026-11-22',4,0,0,NULL,0),(4967,42,'2026-11-23',4,0,0,NULL,0),(4968,42,'2026-11-24',4,0,0,NULL,0),(4969,42,'2026-11-25',4,0,0,NULL,0),(4970,42,'2026-11-26',4,0,0,NULL,0),(4971,42,'2026-11-27',4,0,0,NULL,0),(4972,42,'2026-11-28',4,0,0,NULL,0),(4973,42,'2026-11-29',4,0,0,NULL,0),(4974,42,'2026-11-30',4,0,0,NULL,0),(4975,42,'2026-12-01',4,0,0,NULL,0),(4976,42,'2026-12-02',4,0,0,NULL,0),(4977,42,'2026-12-03',4,0,0,NULL,0),(4978,42,'2026-12-04',4,0,0,NULL,0),(4979,42,'2026-12-05',4,0,0,NULL,0),(4980,42,'2026-12-06',4,0,0,NULL,0),(4981,42,'2026-12-07',4,0,0,NULL,0),(4982,42,'2026-12-08',4,0,0,NULL,0),(4983,42,'2026-12-09',4,0,0,NULL,0),(4984,42,'2026-12-10',4,0,0,NULL,0),(4985,42,'2026-12-11',4,0,0,NULL,0),(4986,42,'2026-12-12',4,0,0,NULL,0),(4987,42,'2026-12-13',4,0,0,NULL,0),(4988,42,'2026-12-14',4,0,0,NULL,0),(4989,42,'2026-12-15',4,0,0,NULL,0),(4990,42,'2026-12-16',4,0,0,NULL,0),(4991,42,'2026-12-17',4,0,0,NULL,0),(4992,42,'2026-12-18',4,0,0,NULL,0),(4993,42,'2026-12-19',4,0,0,NULL,0),(4994,42,'2026-12-20',4,0,0,NULL,0),(4995,42,'2026-12-21',4,0,0,NULL,0),(4996,42,'2026-12-22',4,0,0,NULL,0),(4997,42,'2026-12-23',4,0,0,NULL,0),(4998,42,'2026-12-24',4,0,0,NULL,0),(4999,42,'2026-12-25',4,0,0,NULL,0),(5000,42,'2026-12-26',4,0,0,NULL,0),(5001,42,'2026-12-27',4,0,0,NULL,0),(5002,42,'2026-12-28',4,0,0,NULL,0),(5003,42,'2026-12-29',4,0,0,NULL,0),(5004,42,'2026-12-30',4,0,0,NULL,0),(5005,42,'2026-12-31',4,0,0,NULL,0),(5006,42,'2027-01-01',4,0,0,NULL,0),(5007,42,'2027-01-02',4,0,0,NULL,0),(5008,42,'2027-01-03',4,0,0,NULL,0),(5009,42,'2027-01-04',4,0,0,NULL,0),(5010,42,'2027-01-05',4,0,0,NULL,0),(5011,42,'2027-01-06',4,0,0,NULL,0),(5012,42,'2027-01-07',4,0,0,NULL,0),(5013,42,'2027-01-08',4,0,0,NULL,0),(5014,42,'2027-01-09',4,0,0,NULL,0),(5015,42,'2027-01-10',4,0,0,NULL,0),(5016,42,'2027-01-11',4,0,0,NULL,0),(5017,42,'2027-01-12',4,0,0,NULL,0),(5018,42,'2027-01-13',4,0,0,NULL,0),(5019,42,'2027-01-14',4,0,0,NULL,0),(5020,42,'2027-01-15',4,0,0,NULL,0),(5021,42,'2027-01-16',4,0,0,NULL,0),(5022,42,'2027-01-17',4,0,0,NULL,0),(5023,42,'2027-01-18',4,0,0,NULL,0),(5024,42,'2027-01-19',4,0,0,NULL,0),(5025,42,'2027-01-20',4,0,0,NULL,0),(5026,42,'2027-01-21',4,0,0,NULL,0),(5027,42,'2027-01-22',4,0,0,NULL,0),(5028,42,'2027-01-23',4,0,0,NULL,0),(5029,42,'2027-01-24',4,0,0,NULL,0),(5030,42,'2027-01-25',4,0,0,NULL,0),(5031,42,'2027-01-26',4,0,0,NULL,0),(5032,42,'2027-01-27',4,0,0,NULL,0),(5033,42,'2027-01-28',4,0,0,NULL,0),(5034,42,'2027-01-29',4,0,0,NULL,0),(5035,42,'2027-01-30',4,0,0,NULL,0),(5036,42,'2027-01-31',4,0,0,NULL,0),(5037,42,'2027-02-01',4,0,0,NULL,0),(5038,42,'2027-02-02',4,0,0,NULL,0),(5039,42,'2027-02-03',4,0,0,NULL,0),(5040,42,'2027-02-04',4,0,0,NULL,0),(5041,43,'2026-10-08',5,0,0,NULL,0),(5042,43,'2026-10-09',5,0,0,NULL,0),(5043,43,'2026-10-10',5,0,0,NULL,0),(5044,43,'2026-10-11',5,0,0,NULL,0),(5045,43,'2026-10-12',5,0,0,NULL,0),(5046,43,'2026-10-13',5,0,0,NULL,0),(5047,43,'2026-10-14',5,0,0,NULL,0),(5048,43,'2026-10-15',5,0,0,NULL,0),(5049,43,'2026-10-16',5,0,0,NULL,0),(5050,43,'2026-10-17',5,0,0,NULL,0),(5051,43,'2026-10-18',5,0,0,NULL,0),(5052,43,'2026-10-19',5,0,0,NULL,0),(5053,43,'2026-10-20',5,0,0,NULL,0),(5054,43,'2026-10-21',5,0,0,NULL,0),(5055,43,'2026-10-22',5,0,0,NULL,0),(5056,43,'2026-10-23',5,0,0,NULL,0),(5057,43,'2026-10-24',5,0,0,NULL,0),(5058,43,'2026-10-25',5,0,0,NULL,0),(5059,43,'2026-10-26',5,0,0,NULL,0),(5060,43,'2026-10-27',5,0,0,NULL,0),(5061,43,'2026-10-28',5,0,0,NULL,0),(5062,43,'2026-10-29',5,0,0,NULL,0),(5063,43,'2026-10-30',5,0,0,NULL,0),(5064,43,'2026-10-31',5,0,0,NULL,0),(5065,43,'2026-11-01',5,0,0,NULL,0),(5066,43,'2026-11-02',5,0,0,NULL,0),(5067,43,'2026-11-03',5,0,0,NULL,0),(5068,43,'2026-11-04',5,0,0,NULL,0),(5069,43,'2026-11-05',5,0,0,NULL,0),(5070,43,'2026-11-06',5,0,0,NULL,0),(5071,43,'2026-11-07',5,0,0,NULL,0),(5072,43,'2026-11-08',5,0,0,NULL,0),(5073,43,'2026-11-09',5,0,0,NULL,0),(5074,43,'2026-11-10',5,0,0,NULL,0),(5075,43,'2026-11-11',5,0,0,NULL,0),(5076,43,'2026-11-12',5,0,0,NULL,0),(5077,43,'2026-11-13',5,0,0,NULL,0),(5078,43,'2026-11-14',5,0,0,NULL,0),(5079,43,'2026-11-15',5,0,0,NULL,0),(5080,43,'2026-11-16',5,0,0,NULL,0),(5081,43,'2026-11-17',5,0,0,NULL,0),(5082,43,'2026-11-18',5,0,0,NULL,0),(5083,43,'2026-11-19',5,0,0,NULL,0),(5084,43,'2026-11-20',5,0,0,NULL,0),(5085,43,'2026-11-21',5,0,0,NULL,0),(5086,43,'2026-11-22',5,0,0,NULL,0),(5087,43,'2026-11-23',5,0,0,NULL,0),(5088,43,'2026-11-24',5,0,0,NULL,0),(5089,43,'2026-11-25',5,0,0,NULL,0),(5090,43,'2026-11-26',5,0,0,NULL,0),(5091,43,'2026-11-27',5,0,0,NULL,0),(5092,43,'2026-11-28',5,0,0,NULL,0),(5093,43,'2026-11-29',5,0,0,NULL,0),(5094,43,'2026-11-30',5,0,0,NULL,0),(5095,43,'2026-12-01',5,0,0,NULL,0),(5096,43,'2026-12-02',5,0,0,NULL,0),(5097,43,'2026-12-03',5,0,0,NULL,0),(5098,43,'2026-12-04',5,0,0,NULL,0),(5099,43,'2026-12-05',5,0,0,NULL,0),(5100,43,'2026-12-06',5,0,0,NULL,0),(5101,43,'2026-12-07',5,0,0,NULL,0),(5102,43,'2026-12-08',5,0,0,NULL,0),(5103,43,'2026-12-09',5,0,0,NULL,0),(5104,43,'2026-12-10',5,0,0,NULL,0),(5105,43,'2026-12-11',5,0,0,NULL,0),(5106,43,'2026-12-12',5,0,0,NULL,0),(5107,43,'2026-12-13',5,0,0,NULL,0),(5108,43,'2026-12-14',5,0,0,NULL,0),(5109,43,'2026-12-15',5,0,0,NULL,0),(5110,43,'2026-12-16',5,0,0,NULL,0),(5111,43,'2026-12-17',5,0,0,NULL,0),(5112,43,'2026-12-18',5,0,0,NULL,0),(5113,43,'2026-12-19',5,0,0,NULL,0),(5114,43,'2026-12-20',5,0,0,NULL,0),(5115,43,'2026-12-21',5,0,0,NULL,0),(5116,43,'2026-12-22',5,0,0,NULL,0),(5117,43,'2026-12-23',5,0,0,NULL,0),(5118,43,'2026-12-24',5,0,0,NULL,0),(5119,43,'2026-12-25',5,0,0,NULL,0),(5120,43,'2026-12-26',5,0,0,NULL,0),(5121,43,'2026-12-27',5,0,0,NULL,0),(5122,43,'2026-12-28',5,0,0,NULL,0),(5123,43,'2026-12-29',5,0,0,NULL,0),(5124,43,'2026-12-30',5,0,0,NULL,0),(5125,43,'2026-12-31',5,0,0,NULL,0),(5126,43,'2027-01-01',5,0,0,NULL,0),(5127,43,'2027-01-02',5,0,0,NULL,0),(5128,43,'2027-01-03',5,0,0,NULL,0),(5129,43,'2027-01-04',5,0,0,NULL,0),(5130,43,'2027-01-05',5,0,0,NULL,0),(5131,43,'2027-01-06',5,0,0,NULL,0),(5132,43,'2027-01-07',5,0,0,NULL,0),(5133,43,'2027-01-08',5,0,0,NULL,0),(5134,43,'2027-01-09',5,0,0,NULL,0),(5135,43,'2027-01-10',5,0,0,NULL,0),(5136,43,'2027-01-11',5,0,0,NULL,0),(5137,43,'2027-01-12',5,0,0,NULL,0),(5138,43,'2027-01-13',5,0,0,NULL,0),(5139,43,'2027-01-14',5,0,0,NULL,0),(5140,43,'2027-01-15',5,0,0,NULL,0),(5141,43,'2027-01-16',5,0,0,NULL,0),(5142,43,'2027-01-17',5,0,0,NULL,0),(5143,43,'2027-01-18',5,0,0,NULL,0),(5144,43,'2027-01-19',5,0,0,NULL,0),(5145,43,'2027-01-20',5,0,0,NULL,0),(5146,43,'2027-01-21',5,0,0,NULL,0),(5147,43,'2027-01-22',5,0,0,NULL,0),(5148,43,'2027-01-23',5,0,0,NULL,0),(5149,43,'2027-01-24',5,0,0,NULL,0),(5150,43,'2027-01-25',5,0,0,NULL,0),(5151,43,'2027-01-26',5,0,0,NULL,0),(5152,43,'2027-01-27',5,0,0,NULL,0),(5153,43,'2027-01-28',5,0,0,NULL,0),(5154,43,'2027-01-29',5,0,0,NULL,0),(5155,43,'2027-01-30',5,0,0,NULL,0),(5156,43,'2027-01-31',5,0,0,NULL,0),(5157,43,'2027-02-01',5,0,0,NULL,0),(5158,43,'2027-02-02',5,0,0,NULL,0),(5159,43,'2027-02-03',5,0,0,NULL,0),(5160,43,'2027-02-04',5,0,0,NULL,0),(5161,44,'2026-10-08',3,0,0,NULL,0),(5162,44,'2026-10-09',3,0,0,NULL,0),(5163,44,'2026-10-10',3,0,0,NULL,0),(5164,44,'2026-10-11',3,0,0,NULL,0),(5165,44,'2026-10-12',3,0,0,NULL,0),(5166,44,'2026-10-13',3,0,0,NULL,0),(5167,44,'2026-10-14',3,0,0,NULL,0),(5168,44,'2026-10-15',3,0,0,NULL,0),(5169,44,'2026-10-16',3,0,0,NULL,0),(5170,44,'2026-10-17',3,0,0,NULL,0),(5171,44,'2026-10-18',3,0,0,NULL,0),(5172,44,'2026-10-19',3,0,0,NULL,0),(5173,44,'2026-10-20',3,0,0,NULL,0),(5174,44,'2026-10-21',3,0,0,NULL,0),(5175,44,'2026-10-22',3,0,0,NULL,0),(5176,44,'2026-10-23',3,0,0,NULL,0),(5177,44,'2026-10-24',3,0,0,NULL,0),(5178,44,'2026-10-25',3,0,0,NULL,0),(5179,44,'2026-10-26',3,0,0,NULL,0),(5180,44,'2026-10-27',3,0,0,NULL,0),(5181,44,'2026-10-28',3,0,0,NULL,0),(5182,44,'2026-10-29',3,0,0,NULL,0),(5183,44,'2026-10-30',3,0,0,NULL,0),(5184,44,'2026-10-31',3,0,0,NULL,0),(5185,44,'2026-11-01',3,0,0,NULL,0),(5186,44,'2026-11-02',3,0,0,NULL,0),(5187,44,'2026-11-03',3,0,0,NULL,0),(5188,44,'2026-11-04',3,0,0,NULL,0),(5189,44,'2026-11-05',3,0,0,NULL,0),(5190,44,'2026-11-06',3,0,0,NULL,0),(5191,44,'2026-11-07',3,0,0,NULL,0),(5192,44,'2026-11-08',3,0,0,NULL,0),(5193,44,'2026-11-09',3,0,0,NULL,0),(5194,44,'2026-11-10',3,0,0,NULL,0),(5195,44,'2026-11-11',3,0,0,NULL,0),(5196,44,'2026-11-12',3,0,0,NULL,0),(5197,44,'2026-11-13',3,0,0,NULL,0),(5198,44,'2026-11-14',3,0,0,NULL,0),(5199,44,'2026-11-15',3,0,0,NULL,0),(5200,44,'2026-11-16',3,0,0,NULL,0),(5201,44,'2026-11-17',3,0,0,NULL,0),(5202,44,'2026-11-18',3,0,0,NULL,0),(5203,44,'2026-11-19',3,0,0,NULL,0),(5204,44,'2026-11-20',3,0,0,NULL,0),(5205,44,'2026-11-21',3,0,0,NULL,0),(5206,44,'2026-11-22',3,0,0,NULL,0),(5207,44,'2026-11-23',3,0,0,NULL,0),(5208,44,'2026-11-24',3,0,0,NULL,0),(5209,44,'2026-11-25',3,0,0,NULL,0),(5210,44,'2026-11-26',3,0,0,NULL,0),(5211,44,'2026-11-27',3,0,0,NULL,0),(5212,44,'2026-11-28',3,0,0,NULL,0),(5213,44,'2026-11-29',3,0,0,NULL,0),(5214,44,'2026-11-30',3,0,0,NULL,0),(5215,44,'2026-12-01',3,0,0,NULL,0),(5216,44,'2026-12-02',3,0,0,NULL,0),(5217,44,'2026-12-03',3,0,0,NULL,0),(5218,44,'2026-12-04',3,0,0,NULL,0),(5219,44,'2026-12-05',3,0,0,NULL,0),(5220,44,'2026-12-06',3,0,0,NULL,0),(5221,44,'2026-12-07',3,0,0,NULL,0),(5222,44,'2026-12-08',3,0,0,NULL,0),(5223,44,'2026-12-09',3,0,0,NULL,0),(5224,44,'2026-12-10',3,0,0,NULL,0),(5225,44,'2026-12-11',3,0,0,NULL,0),(5226,44,'2026-12-12',3,0,0,NULL,0),(5227,44,'2026-12-13',3,0,0,NULL,0),(5228,44,'2026-12-14',3,0,0,NULL,0),(5229,44,'2026-12-15',3,0,0,NULL,0),(5230,44,'2026-12-16',3,0,0,NULL,0),(5231,44,'2026-12-17',3,0,0,NULL,0),(5232,44,'2026-12-18',3,0,0,NULL,0),(5233,44,'2026-12-19',3,0,0,NULL,0),(5234,44,'2026-12-20',3,0,0,NULL,0),(5235,44,'2026-12-21',3,0,0,NULL,0),(5236,44,'2026-12-22',3,0,0,NULL,0),(5237,44,'2026-12-23',3,0,0,NULL,0),(5238,44,'2026-12-24',3,0,0,NULL,0),(5239,44,'2026-12-25',3,0,0,NULL,0),(5240,44,'2026-12-26',3,0,0,NULL,0),(5241,44,'2026-12-27',3,0,0,NULL,0),(5242,44,'2026-12-28',3,0,0,NULL,0),(5243,44,'2026-12-29',3,0,0,NULL,0),(5244,44,'2026-12-30',3,0,0,NULL,0),(5245,44,'2026-12-31',3,0,0,NULL,0),(5246,44,'2027-01-01',3,0,0,NULL,0),(5247,44,'2027-01-02',3,0,0,NULL,0),(5248,44,'2027-01-03',3,0,0,NULL,0),(5249,44,'2027-01-04',3,0,0,NULL,0),(5250,44,'2027-01-05',3,0,0,NULL,0),(5251,44,'2027-01-06',3,0,0,NULL,0),(5252,44,'2027-01-07',3,0,0,NULL,0),(5253,44,'2027-01-08',3,0,0,NULL,0),(5254,44,'2027-01-09',3,0,0,NULL,0),(5255,44,'2027-01-10',3,0,0,NULL,0),(5256,44,'2027-01-11',3,0,0,NULL,0),(5257,44,'2027-01-12',3,0,0,NULL,0),(5258,44,'2027-01-13',3,0,0,NULL,0),(5259,44,'2027-01-14',3,0,0,NULL,0),(5260,44,'2027-01-15',3,0,0,NULL,0),(5261,44,'2027-01-16',3,0,0,NULL,0),(5262,44,'2027-01-17',3,0,0,NULL,0),(5263,44,'2027-01-18',3,0,0,NULL,0),(5264,44,'2027-01-19',3,0,0,NULL,0),(5265,44,'2027-01-20',3,0,0,NULL,0),(5266,44,'2027-01-21',3,0,0,NULL,0),(5267,44,'2027-01-22',3,0,0,NULL,0),(5268,44,'2027-01-23',3,0,0,NULL,0),(5269,44,'2027-01-24',3,0,0,NULL,0),(5270,44,'2027-01-25',3,0,0,NULL,0),(5271,44,'2027-01-26',3,0,0,NULL,0),(5272,44,'2027-01-27',3,0,0,NULL,0),(5273,44,'2027-01-28',3,0,0,NULL,0),(5274,44,'2027-01-29',3,0,0,NULL,0),(5275,44,'2027-01-30',3,0,0,NULL,0),(5276,44,'2027-01-31',3,0,0,NULL,0),(5277,44,'2027-02-01',3,0,0,NULL,0),(5278,44,'2027-02-02',3,0,0,NULL,0),(5279,44,'2027-02-03',3,0,0,NULL,0),(5280,44,'2027-02-04',3,0,0,NULL,0),(5281,45,'2026-10-08',8,0,0,NULL,0),(5282,45,'2026-10-09',8,0,0,NULL,0),(5283,45,'2026-10-10',8,0,0,NULL,0),(5284,45,'2026-10-11',8,0,0,NULL,0),(5285,45,'2026-10-12',8,0,0,NULL,0),(5286,45,'2026-10-13',8,0,0,NULL,0),(5287,45,'2026-10-14',8,0,0,NULL,0),(5288,45,'2026-10-15',8,0,0,NULL,0),(5289,45,'2026-10-16',8,0,0,NULL,0),(5290,45,'2026-10-17',8,0,0,NULL,0),(5291,45,'2026-10-18',8,0,0,NULL,0),(5292,45,'2026-10-19',8,0,0,NULL,0),(5293,45,'2026-10-20',8,0,0,NULL,0),(5294,45,'2026-10-21',8,0,0,NULL,0),(5295,45,'2026-10-22',8,0,0,NULL,0),(5296,45,'2026-10-23',8,0,0,NULL,0),(5297,45,'2026-10-24',8,0,0,NULL,0),(5298,45,'2026-10-25',8,0,0,NULL,0),(5299,45,'2026-10-26',8,0,0,NULL,0),(5300,45,'2026-10-27',8,0,0,NULL,0),(5301,45,'2026-10-28',8,0,0,NULL,0),(5302,45,'2026-10-29',8,0,0,NULL,0),(5303,45,'2026-10-30',8,0,0,NULL,0),(5304,45,'2026-10-31',8,0,0,NULL,0),(5305,45,'2026-11-01',8,0,0,NULL,0),(5306,45,'2026-11-02',8,0,0,NULL,0),(5307,45,'2026-11-03',8,0,0,NULL,0),(5308,45,'2026-11-04',8,0,0,NULL,0),(5309,45,'2026-11-05',8,0,0,NULL,0),(5310,45,'2026-11-06',8,0,0,NULL,0),(5311,45,'2026-11-07',8,0,0,NULL,0),(5312,45,'2026-11-08',8,0,0,NULL,0),(5313,45,'2026-11-09',8,0,0,NULL,0),(5314,45,'2026-11-10',8,0,0,NULL,0),(5315,45,'2026-11-11',8,0,0,NULL,0),(5316,45,'2026-11-12',8,0,0,NULL,0),(5317,45,'2026-11-13',8,0,0,NULL,0),(5318,45,'2026-11-14',8,0,0,NULL,0),(5319,45,'2026-11-15',8,0,0,NULL,0),(5320,45,'2026-11-16',8,0,0,NULL,0),(5321,45,'2026-11-17',8,0,0,NULL,0),(5322,45,'2026-11-18',8,0,0,NULL,0),(5323,45,'2026-11-19',8,0,0,NULL,0),(5324,45,'2026-11-20',8,0,0,NULL,0),(5325,45,'2026-11-21',8,0,0,NULL,0),(5326,45,'2026-11-22',8,0,0,NULL,0),(5327,45,'2026-11-23',8,0,0,NULL,0),(5328,45,'2026-11-24',8,0,0,NULL,0),(5329,45,'2026-11-25',8,0,0,NULL,0),(5330,45,'2026-11-26',8,0,0,NULL,0),(5331,45,'2026-11-27',8,0,0,NULL,0),(5332,45,'2026-11-28',8,0,0,NULL,0),(5333,45,'2026-11-29',8,0,0,NULL,0),(5334,45,'2026-11-30',8,0,0,NULL,0),(5335,45,'2026-12-01',8,0,0,NULL,0),(5336,45,'2026-12-02',8,0,0,NULL,0),(5337,45,'2026-12-03',8,0,0,NULL,0),(5338,45,'2026-12-04',8,0,0,NULL,0),(5339,45,'2026-12-05',8,0,0,NULL,0),(5340,45,'2026-12-06',8,0,0,NULL,0),(5341,45,'2026-12-07',8,0,0,NULL,0),(5342,45,'2026-12-08',8,0,0,NULL,0),(5343,45,'2026-12-09',8,0,0,NULL,0),(5344,45,'2026-12-10',8,0,0,NULL,0),(5345,45,'2026-12-11',8,0,0,NULL,0),(5346,45,'2026-12-12',8,0,0,NULL,0),(5347,45,'2026-12-13',8,0,0,NULL,0),(5348,45,'2026-12-14',8,0,0,NULL,0),(5349,45,'2026-12-15',8,0,0,NULL,0),(5350,45,'2026-12-16',8,0,0,NULL,0),(5351,45,'2026-12-17',8,0,0,NULL,0),(5352,45,'2026-12-18',8,0,0,NULL,0),(5353,45,'2026-12-19',8,0,0,NULL,0),(5354,45,'2026-12-20',8,0,0,NULL,0),(5355,45,'2026-12-21',8,0,0,NULL,0),(5356,45,'2026-12-22',8,0,0,NULL,0),(5357,45,'2026-12-23',8,0,0,NULL,0),(5358,45,'2026-12-24',8,0,0,NULL,0),(5359,45,'2026-12-25',8,0,0,NULL,0),(5360,45,'2026-12-26',8,0,0,NULL,0),(5361,45,'2026-12-27',8,0,0,NULL,0),(5362,45,'2026-12-28',8,0,0,NULL,0),(5363,45,'2026-12-29',8,0,0,NULL,0),(5364,45,'2026-12-30',8,0,0,NULL,0),(5365,45,'2026-12-31',8,0,0,NULL,0),(5366,45,'2027-01-01',8,0,0,NULL,0),(5367,45,'2027-01-02',8,0,0,NULL,0),(5368,45,'2027-01-03',8,0,0,NULL,0),(5369,45,'2027-01-04',8,0,0,NULL,0),(5370,45,'2027-01-05',8,0,0,NULL,0),(5371,45,'2027-01-06',8,0,0,NULL,0),(5372,45,'2027-01-07',8,0,0,NULL,0),(5373,45,'2027-01-08',8,0,0,NULL,0),(5374,45,'2027-01-09',8,0,0,NULL,0),(5375,45,'2027-01-10',8,0,0,NULL,0),(5376,45,'2027-01-11',8,0,0,NULL,0),(5377,45,'2027-01-12',8,0,0,NULL,0),(5378,45,'2027-01-13',8,0,0,NULL,0),(5379,45,'2027-01-14',8,0,0,NULL,0),(5380,45,'2027-01-15',8,0,0,NULL,0),(5381,45,'2027-01-16',8,0,0,NULL,0),(5382,45,'2027-01-17',8,0,0,NULL,0),(5383,45,'2027-01-18',8,0,0,NULL,0),(5384,45,'2027-01-19',8,0,0,NULL,0),(5385,45,'2027-01-20',8,0,0,NULL,0),(5386,45,'2027-01-21',8,0,0,NULL,0),(5387,45,'2027-01-22',8,0,0,NULL,0),(5388,45,'2027-01-23',8,0,0,NULL,0),(5389,45,'2027-01-24',8,0,0,NULL,0),(5390,45,'2027-01-25',8,0,0,NULL,0),(5391,45,'2027-01-26',8,0,0,NULL,0),(5392,45,'2027-01-27',8,0,0,NULL,0),(5393,45,'2027-01-28',8,0,0,NULL,0),(5394,45,'2027-01-29',8,0,0,NULL,0),(5395,45,'2027-01-30',8,0,0,NULL,0),(5396,45,'2027-01-31',8,0,0,NULL,0),(5397,45,'2027-02-01',8,0,0,NULL,0),(5398,45,'2027-02-02',8,0,0,NULL,0),(5399,45,'2027-02-03',8,0,0,NULL,0),(5400,45,'2027-02-04',8,0,0,NULL,0),(5401,46,'2026-10-08',4,0,0,NULL,0),(5402,46,'2026-10-09',4,0,0,NULL,0),(5403,46,'2026-10-10',4,0,0,NULL,0),(5404,46,'2026-10-11',4,0,0,NULL,0),(5405,46,'2026-10-12',4,0,0,NULL,0),(5406,46,'2026-10-13',4,0,0,NULL,0),(5407,46,'2026-10-14',4,0,0,NULL,0),(5408,46,'2026-10-15',4,0,0,NULL,0),(5409,46,'2026-10-16',4,0,0,NULL,0),(5410,46,'2026-10-17',4,0,0,NULL,0),(5411,46,'2026-10-18',4,0,0,NULL,0),(5412,46,'2026-10-19',4,0,0,NULL,0),(5413,46,'2026-10-20',4,0,0,NULL,0),(5414,46,'2026-10-21',4,0,0,NULL,0),(5415,46,'2026-10-22',4,0,0,NULL,0),(5416,46,'2026-10-23',4,0,0,NULL,0),(5417,46,'2026-10-24',4,0,0,NULL,0),(5418,46,'2026-10-25',4,0,0,NULL,0),(5419,46,'2026-10-26',4,0,0,NULL,0),(5420,46,'2026-10-27',4,0,0,NULL,0),(5421,46,'2026-10-28',4,0,0,NULL,0),(5422,46,'2026-10-29',4,0,0,NULL,0),(5423,46,'2026-10-30',4,0,0,NULL,0),(5424,46,'2026-10-31',4,0,0,NULL,0),(5425,46,'2026-11-01',4,0,0,NULL,0),(5426,46,'2026-11-02',4,0,0,NULL,0),(5427,46,'2026-11-03',4,0,0,NULL,0),(5428,46,'2026-11-04',4,0,0,NULL,0),(5429,46,'2026-11-05',4,0,0,NULL,0),(5430,46,'2026-11-06',4,0,0,NULL,0),(5431,46,'2026-11-07',4,0,0,NULL,0),(5432,46,'2026-11-08',4,0,0,NULL,0),(5433,46,'2026-11-09',4,0,0,NULL,0),(5434,46,'2026-11-10',4,0,0,NULL,0),(5435,46,'2026-11-11',4,0,0,NULL,0),(5436,46,'2026-11-12',4,0,0,NULL,0),(5437,46,'2026-11-13',4,0,0,NULL,0),(5438,46,'2026-11-14',4,0,0,NULL,0),(5439,46,'2026-11-15',4,0,0,NULL,0),(5440,46,'2026-11-16',4,0,0,NULL,0),(5441,46,'2026-11-17',4,0,0,NULL,0),(5442,46,'2026-11-18',4,0,0,NULL,0),(5443,46,'2026-11-19',4,0,0,NULL,0),(5444,46,'2026-11-20',4,0,0,NULL,0),(5445,46,'2026-11-21',4,0,0,NULL,0),(5446,46,'2026-11-22',4,0,0,NULL,0),(5447,46,'2026-11-23',4,0,0,NULL,0),(5448,46,'2026-11-24',4,0,0,NULL,0),(5449,46,'2026-11-25',4,0,0,NULL,0),(5450,46,'2026-11-26',4,0,0,NULL,0),(5451,46,'2026-11-27',4,0,0,NULL,0),(5452,46,'2026-11-28',4,0,0,NULL,0),(5453,46,'2026-11-29',4,0,0,NULL,0),(5454,46,'2026-11-30',4,0,0,NULL,0),(5455,46,'2026-12-01',4,0,0,NULL,0),(5456,46,'2026-12-02',4,0,0,NULL,0),(5457,46,'2026-12-03',4,0,0,NULL,0),(5458,46,'2026-12-04',4,0,0,NULL,0),(5459,46,'2026-12-05',4,0,0,NULL,0),(5460,46,'2026-12-06',4,0,0,NULL,0),(5461,46,'2026-12-07',4,0,0,NULL,0),(5462,46,'2026-12-08',4,0,0,NULL,0),(5463,46,'2026-12-09',4,0,0,NULL,0),(5464,46,'2026-12-10',4,0,0,NULL,0),(5465,46,'2026-12-11',4,0,0,NULL,0),(5466,46,'2026-12-12',4,0,0,NULL,0),(5467,46,'2026-12-13',4,0,0,NULL,0),(5468,46,'2026-12-14',4,0,0,NULL,0),(5469,46,'2026-12-15',4,0,0,NULL,0),(5470,46,'2026-12-16',4,0,0,NULL,0),(5471,46,'2026-12-17',4,0,0,NULL,0),(5472,46,'2026-12-18',4,0,0,NULL,0),(5473,46,'2026-12-19',4,0,0,NULL,0),(5474,46,'2026-12-20',4,0,0,NULL,0),(5475,46,'2026-12-21',4,0,0,NULL,0),(5476,46,'2026-12-22',4,0,0,NULL,0),(5477,46,'2026-12-23',4,0,0,NULL,0),(5478,46,'2026-12-24',4,0,0,NULL,0),(5479,46,'2026-12-25',4,0,0,NULL,0),(5480,46,'2026-12-26',4,0,0,NULL,0),(5481,46,'2026-12-27',4,0,0,NULL,0),(5482,46,'2026-12-28',4,0,0,NULL,0),(5483,46,'2026-12-29',4,0,0,NULL,0),(5484,46,'2026-12-30',4,0,0,NULL,0),(5485,46,'2026-12-31',4,0,0,NULL,0),(5486,46,'2027-01-01',4,0,0,NULL,0),(5487,46,'2027-01-02',4,0,0,NULL,0),(5488,46,'2027-01-03',4,0,0,NULL,0),(5489,46,'2027-01-04',4,0,0,NULL,0),(5490,46,'2027-01-05',4,0,0,NULL,0),(5491,46,'2027-01-06',4,0,0,NULL,0),(5492,46,'2027-01-07',4,0,0,NULL,0),(5493,46,'2027-01-08',4,0,0,NULL,0),(5494,46,'2027-01-09',4,0,0,NULL,0),(5495,46,'2027-01-10',4,0,0,NULL,0),(5496,46,'2027-01-11',4,0,0,NULL,0),(5497,46,'2027-01-12',4,0,0,NULL,0),(5498,46,'2027-01-13',4,0,0,NULL,0),(5499,46,'2027-01-14',4,0,0,NULL,0),(5500,46,'2027-01-15',4,0,0,NULL,0),(5501,46,'2027-01-16',4,0,0,NULL,0),(5502,46,'2027-01-17',4,0,0,NULL,0),(5503,46,'2027-01-18',4,0,0,NULL,0),(5504,46,'2027-01-19',4,0,0,NULL,0),(5505,46,'2027-01-20',4,0,0,NULL,0),(5506,46,'2027-01-21',4,0,0,NULL,0),(5507,46,'2027-01-22',4,0,0,NULL,0),(5508,46,'2027-01-23',4,0,0,NULL,0),(5509,46,'2027-01-24',4,0,0,NULL,0),(5510,46,'2027-01-25',4,0,0,NULL,0),(5511,46,'2027-01-26',4,0,0,NULL,0),(5512,46,'2027-01-27',4,0,0,NULL,0),(5513,46,'2027-01-28',4,0,0,NULL,0),(5514,46,'2027-01-29',4,0,0,NULL,0),(5515,46,'2027-01-30',4,0,0,NULL,0),(5516,46,'2027-01-31',4,0,0,NULL,0),(5517,46,'2027-02-01',4,0,0,NULL,0),(5518,46,'2027-02-02',4,0,0,NULL,0),(5519,46,'2027-02-03',4,0,0,NULL,0),(5520,46,'2027-02-04',4,0,0,NULL,0),(5521,47,'2026-10-08',5,0,0,NULL,0),(5522,47,'2026-10-09',5,0,0,NULL,0),(5523,47,'2026-10-10',5,0,0,NULL,0),(5524,47,'2026-10-11',5,0,0,NULL,0),(5525,47,'2026-10-12',5,0,0,NULL,0),(5526,47,'2026-10-13',5,0,0,NULL,0),(5527,47,'2026-10-14',5,0,0,NULL,0),(5528,47,'2026-10-15',5,0,0,NULL,0),(5529,47,'2026-10-16',5,0,0,NULL,0),(5530,47,'2026-10-17',5,0,0,NULL,0),(5531,47,'2026-10-18',5,0,0,NULL,0),(5532,47,'2026-10-19',5,0,0,NULL,0),(5533,47,'2026-10-20',5,0,0,NULL,0),(5534,47,'2026-10-21',5,0,0,NULL,0),(5535,47,'2026-10-22',5,0,0,NULL,0),(5536,47,'2026-10-23',5,0,0,NULL,0),(5537,47,'2026-10-24',5,0,0,NULL,0),(5538,47,'2026-10-25',5,0,0,NULL,0),(5539,47,'2026-10-26',5,0,0,NULL,0),(5540,47,'2026-10-27',5,0,0,NULL,0),(5541,47,'2026-10-28',5,0,0,NULL,0),(5542,47,'2026-10-29',5,0,0,NULL,0),(5543,47,'2026-10-30',5,0,0,NULL,0),(5544,47,'2026-10-31',5,0,0,NULL,0),(5545,47,'2026-11-01',5,0,0,NULL,0),(5546,47,'2026-11-02',5,0,0,NULL,0),(5547,47,'2026-11-03',5,0,0,NULL,0),(5548,47,'2026-11-04',5,0,0,NULL,0),(5549,47,'2026-11-05',5,0,0,NULL,0),(5550,47,'2026-11-06',5,0,0,NULL,0),(5551,47,'2026-11-07',5,0,0,NULL,0),(5552,47,'2026-11-08',5,0,0,NULL,0),(5553,47,'2026-11-09',5,0,0,NULL,0),(5554,47,'2026-11-10',5,0,0,NULL,0),(5555,47,'2026-11-11',5,0,0,NULL,0),(5556,47,'2026-11-12',5,0,0,NULL,0),(5557,47,'2026-11-13',5,0,0,NULL,0),(5558,47,'2026-11-14',5,0,0,NULL,0),(5559,47,'2026-11-15',5,0,0,NULL,0),(5560,47,'2026-11-16',5,0,0,NULL,0),(5561,47,'2026-11-17',5,0,0,NULL,0),(5562,47,'2026-11-18',5,0,0,NULL,0),(5563,47,'2026-11-19',5,0,0,NULL,0),(5564,47,'2026-11-20',5,0,0,NULL,0),(5565,47,'2026-11-21',5,0,0,NULL,0),(5566,47,'2026-11-22',5,0,0,NULL,0),(5567,47,'2026-11-23',5,0,0,NULL,0),(5568,47,'2026-11-24',5,0,0,NULL,0),(5569,47,'2026-11-25',5,0,0,NULL,0),(5570,47,'2026-11-26',5,0,0,NULL,0),(5571,47,'2026-11-27',5,0,0,NULL,0),(5572,47,'2026-11-28',5,0,0,NULL,0),(5573,47,'2026-11-29',5,0,0,NULL,0),(5574,47,'2026-11-30',5,0,0,NULL,0),(5575,47,'2026-12-01',5,0,0,NULL,0),(5576,47,'2026-12-02',5,0,0,NULL,0),(5577,47,'2026-12-03',5,0,0,NULL,0),(5578,47,'2026-12-04',5,0,0,NULL,0),(5579,47,'2026-12-05',5,0,0,NULL,0),(5580,47,'2026-12-06',5,0,0,NULL,0),(5581,47,'2026-12-07',5,0,0,NULL,0),(5582,47,'2026-12-08',5,0,0,NULL,0),(5583,47,'2026-12-09',5,0,0,NULL,0),(5584,47,'2026-12-10',5,0,0,NULL,0),(5585,47,'2026-12-11',5,0,0,NULL,0),(5586,47,'2026-12-12',5,0,0,NULL,0),(5587,47,'2026-12-13',5,0,0,NULL,0),(5588,47,'2026-12-14',5,0,0,NULL,0),(5589,47,'2026-12-15',5,0,0,NULL,0),(5590,47,'2026-12-16',5,0,0,NULL,0),(5591,47,'2026-12-17',5,0,0,NULL,0),(5592,47,'2026-12-18',5,0,0,NULL,0),(5593,47,'2026-12-19',5,0,0,NULL,0),(5594,47,'2026-12-20',5,0,0,NULL,0),(5595,47,'2026-12-21',5,0,0,NULL,0),(5596,47,'2026-12-22',5,0,0,NULL,0),(5597,47,'2026-12-23',5,0,0,NULL,0),(5598,47,'2026-12-24',5,0,0,NULL,0),(5599,47,'2026-12-25',5,0,0,NULL,0),(5600,47,'2026-12-26',5,0,0,NULL,0),(5601,47,'2026-12-27',5,0,0,NULL,0),(5602,47,'2026-12-28',5,0,0,NULL,0),(5603,47,'2026-12-29',5,0,0,NULL,0),(5604,47,'2026-12-30',5,0,0,NULL,0),(5605,47,'2026-12-31',5,0,0,NULL,0),(5606,47,'2027-01-01',5,0,0,NULL,0),(5607,47,'2027-01-02',5,0,0,NULL,0),(5608,47,'2027-01-03',5,0,0,NULL,0),(5609,47,'2027-01-04',5,0,0,NULL,0),(5610,47,'2027-01-05',5,0,0,NULL,0),(5611,47,'2027-01-06',5,0,0,NULL,0),(5612,47,'2027-01-07',5,0,0,NULL,0),(5613,47,'2027-01-08',5,0,0,NULL,0),(5614,47,'2027-01-09',5,0,0,NULL,0),(5615,47,'2027-01-10',5,0,0,NULL,0),(5616,47,'2027-01-11',5,0,0,NULL,0),(5617,47,'2027-01-12',5,0,0,NULL,0),(5618,47,'2027-01-13',5,0,0,NULL,0),(5619,47,'2027-01-14',5,0,0,NULL,0),(5620,47,'2027-01-15',5,0,0,NULL,0),(5621,47,'2027-01-16',5,0,0,NULL,0),(5622,47,'2027-01-17',5,0,0,NULL,0),(5623,47,'2027-01-18',5,0,0,NULL,0),(5624,47,'2027-01-19',5,0,0,NULL,0),(5625,47,'2027-01-20',5,0,0,NULL,0),(5626,47,'2027-01-21',5,0,0,NULL,0),(5627,47,'2027-01-22',5,0,0,NULL,0),(5628,47,'2027-01-23',5,0,0,NULL,0),(5629,47,'2027-01-24',5,0,0,NULL,0),(5630,47,'2027-01-25',5,0,0,NULL,0),(5631,47,'2027-01-26',5,0,0,NULL,0),(5632,47,'2027-01-27',5,0,0,NULL,0),(5633,47,'2027-01-28',5,0,0,NULL,0),(5634,47,'2027-01-29',5,0,0,NULL,0),(5635,47,'2027-01-30',5,0,0,NULL,0),(5636,47,'2027-01-31',5,0,0,NULL,0),(5637,47,'2027-02-01',5,0,0,NULL,0),(5638,47,'2027-02-02',5,0,0,NULL,0),(5639,47,'2027-02-03',5,0,0,NULL,0),(5640,47,'2027-02-04',5,0,0,NULL,0),(5641,48,'2026-10-08',2,0,0,NULL,0),(5642,48,'2026-10-09',2,0,0,NULL,0),(5643,48,'2026-10-10',2,0,0,NULL,0),(5644,48,'2026-10-11',2,0,0,NULL,0),(5645,48,'2026-10-12',2,0,0,NULL,0),(5646,48,'2026-10-13',2,0,0,NULL,0),(5647,48,'2026-10-14',2,0,0,NULL,0),(5648,48,'2026-10-15',2,0,0,NULL,0),(5649,48,'2026-10-16',2,0,0,NULL,0),(5650,48,'2026-10-17',2,0,0,NULL,0),(5651,48,'2026-10-18',2,0,0,NULL,0),(5652,48,'2026-10-19',2,0,0,NULL,0),(5653,48,'2026-10-20',2,0,0,NULL,0),(5654,48,'2026-10-21',2,0,0,NULL,0),(5655,48,'2026-10-22',2,0,0,NULL,0),(5656,48,'2026-10-23',2,0,0,NULL,0),(5657,48,'2026-10-24',2,0,0,NULL,0),(5658,48,'2026-10-25',2,0,0,NULL,0),(5659,48,'2026-10-26',2,0,0,NULL,0),(5660,48,'2026-10-27',2,0,0,NULL,0),(5661,48,'2026-10-28',2,0,0,NULL,0),(5662,48,'2026-10-29',2,0,0,NULL,0),(5663,48,'2026-10-30',2,0,0,NULL,0),(5664,48,'2026-10-31',2,0,0,NULL,0),(5665,48,'2026-11-01',2,0,0,NULL,0),(5666,48,'2026-11-02',2,0,0,NULL,0),(5667,48,'2026-11-03',2,0,0,NULL,0),(5668,48,'2026-11-04',2,0,0,NULL,0),(5669,48,'2026-11-05',2,0,0,NULL,0),(5670,48,'2026-11-06',2,0,0,NULL,0),(5671,48,'2026-11-07',2,0,0,NULL,0),(5672,48,'2026-11-08',2,0,0,NULL,0),(5673,48,'2026-11-09',2,0,0,NULL,0),(5674,48,'2026-11-10',2,0,0,NULL,0),(5675,48,'2026-11-11',2,0,0,NULL,0),(5676,48,'2026-11-12',2,0,0,NULL,0),(5677,48,'2026-11-13',2,0,0,NULL,0),(5678,48,'2026-11-14',2,0,0,NULL,0),(5679,48,'2026-11-15',2,0,0,NULL,0),(5680,48,'2026-11-16',2,0,0,NULL,0),(5681,48,'2026-11-17',2,0,0,NULL,0),(5682,48,'2026-11-18',2,0,0,NULL,0),(5683,48,'2026-11-19',2,0,0,NULL,0),(5684,48,'2026-11-20',2,0,0,NULL,0),(5685,48,'2026-11-21',2,0,0,NULL,0),(5686,48,'2026-11-22',2,0,0,NULL,0),(5687,48,'2026-11-23',2,0,0,NULL,0),(5688,48,'2026-11-24',2,0,0,NULL,0),(5689,48,'2026-11-25',2,0,0,NULL,0),(5690,48,'2026-11-26',2,0,0,NULL,0),(5691,48,'2026-11-27',2,0,0,NULL,0),(5692,48,'2026-11-28',2,0,0,NULL,0),(5693,48,'2026-11-29',2,0,0,NULL,0),(5694,48,'2026-11-30',2,0,0,NULL,0),(5695,48,'2026-12-01',2,0,0,NULL,0),(5696,48,'2026-12-02',2,0,0,NULL,0),(5697,48,'2026-12-03',2,0,0,NULL,0),(5698,48,'2026-12-04',2,0,0,NULL,0),(5699,48,'2026-12-05',2,0,0,NULL,0),(5700,48,'2026-12-06',2,0,0,NULL,0),(5701,48,'2026-12-07',2,0,0,NULL,0),(5702,48,'2026-12-08',2,0,0,NULL,0),(5703,48,'2026-12-09',2,0,0,NULL,0),(5704,48,'2026-12-10',2,0,0,NULL,0),(5705,48,'2026-12-11',2,0,0,NULL,0),(5706,48,'2026-12-12',2,0,0,NULL,0),(5707,48,'2026-12-13',2,0,0,NULL,0),(5708,48,'2026-12-14',2,0,0,NULL,0),(5709,48,'2026-12-15',2,0,0,NULL,0),(5710,48,'2026-12-16',2,0,0,NULL,0),(5711,48,'2026-12-17',2,0,0,NULL,0),(5712,48,'2026-12-18',2,0,0,NULL,0),(5713,48,'2026-12-19',2,0,0,NULL,0),(5714,48,'2026-12-20',2,0,0,NULL,0),(5715,48,'2026-12-21',2,0,0,NULL,0),(5716,48,'2026-12-22',2,0,0,NULL,0),(5717,48,'2026-12-23',2,0,0,NULL,0),(5718,48,'2026-12-24',2,0,0,NULL,0),(5719,48,'2026-12-25',2,0,0,NULL,0),(5720,48,'2026-12-26',2,0,0,NULL,0),(5721,48,'2026-12-27',2,0,0,NULL,0),(5722,48,'2026-12-28',2,0,0,NULL,0),(5723,48,'2026-12-29',2,0,0,NULL,0),(5724,48,'2026-12-30',2,0,0,NULL,0),(5725,48,'2026-12-31',2,0,0,NULL,0),(5726,48,'2027-01-01',2,0,0,NULL,0),(5727,48,'2027-01-02',2,0,0,NULL,0),(5728,48,'2027-01-03',2,0,0,NULL,0),(5729,48,'2027-01-04',2,0,0,NULL,0),(5730,48,'2027-01-05',2,0,0,NULL,0),(5731,48,'2027-01-06',2,0,0,NULL,0),(5732,48,'2027-01-07',2,0,0,NULL,0),(5733,48,'2027-01-08',2,0,0,NULL,0),(5734,48,'2027-01-09',2,0,0,NULL,0),(5735,48,'2027-01-10',2,0,0,NULL,0),(5736,48,'2027-01-11',2,0,0,NULL,0),(5737,48,'2027-01-12',2,0,0,NULL,0),(5738,48,'2027-01-13',2,0,0,NULL,0),(5739,48,'2027-01-14',2,0,0,NULL,0),(5740,48,'2027-01-15',2,0,0,NULL,0),(5741,48,'2027-01-16',2,0,0,NULL,0),(5742,48,'2027-01-17',2,0,0,NULL,0),(5743,48,'2027-01-18',2,0,0,NULL,0),(5744,48,'2027-01-19',2,0,0,NULL,0),(5745,48,'2027-01-20',2,0,0,NULL,0),(5746,48,'2027-01-21',2,0,0,NULL,0),(5747,48,'2027-01-22',2,0,0,NULL,0),(5748,48,'2027-01-23',2,0,0,NULL,0),(5749,48,'2027-01-24',2,0,0,NULL,0),(5750,48,'2027-01-25',2,0,0,NULL,0),(5751,48,'2027-01-26',2,0,0,NULL,0),(5752,48,'2027-01-27',2,0,0,NULL,0),(5753,48,'2027-01-28',2,0,0,NULL,0),(5754,48,'2027-01-29',2,0,0,NULL,0),(5755,48,'2027-01-30',2,0,0,NULL,0),(5756,48,'2027-01-31',2,0,0,NULL,0),(5757,48,'2027-02-01',2,0,0,NULL,0),(5758,48,'2027-02-02',2,0,0,NULL,0),(5759,48,'2027-02-03',2,0,0,NULL,0),(5760,48,'2027-02-04',2,0,0,NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomType`
--

LOCK TABLES `RoomType` WRITE;
/*!40000 ALTER TABLE `RoomType` DISABLE KEYS */;
INSERT INTO `RoomType` VALUES (28,13,'Phòng tiêu chuẩn',28,'1 giường đôi',2,6,1,0,850000,'Gọn gàng, ban công nhỏ nhìn ra vườn.'),(29,13,'Phòng Deluxe',28,'1 giường lớn',2,4,1,0,1250000,'Rộng rãi, cửa kính lớn view đồi thông.'),(30,13,'Phòng Family',28,'2 giường đôi',4,2,1,0,1800000,'Phù hợp gia đình 4 người.'),(31,14,'Phòng hướng biển',28,'1 giường lớn',2,5,1,0,1600000,'Ban công nhìn thẳng ra biển.'),(32,14,'Suite gia đình',28,'2 giường lớn',4,3,1,0,2600000,'Không gian rộng, bếp mini.'),(33,15,'Phòng vườn',28,'1 giường đôi',2,6,1,0,1100000,'Yên tĩnh, nhìn ra vườn.'),(34,15,'Phòng view sông',28,'1 giường lớn',2,3,1,0,1600000,'Ban công nhìn ra sông Hoài.'),(35,16,'Giường tầng (Dorm)',28,'Giường tầng',1,10,1,0,350000,'Tiết kiệm cho khách đi phượt.'),(36,16,'Cabin gỗ',28,'1 giường đôi',2,4,1,0,1200000,'Riêng tư, lò sưởi ấm áp.'),(37,17,'Phòng cộng đồng',28,'4 giường đơn',4,4,1,0,650000,'Ấm cúng cho nhóm bạn.'),(38,17,'Nhà sàn riêng',28,'1 giường lớn',2,3,1,0,1150000,'View đồi chè, bếp lửa.'),(39,18,'Bungalow vườn',28,'1 giường đôi',2,5,1,0,1250000,'Yên bình giữa vườn xanh.'),(40,18,'Villa núi đá',28,'2 giường lớn',4,2,1,0,2200000,'Hồ bơi riêng, view núi đá.'),(41,19,'Phòng vườn nhiệt đới',28,'1 giường đôi',2,6,1,0,1400000,'Gần biển, nhiều cây xanh.'),(42,19,'Bungalow hướng biển',28,'1 giường lớn',2,4,1,0,2300000,'Ngắm hoàng hôn ngay hiên.'),(43,20,'Phòng Studio',28,'1 giường đôi',2,5,1,0,900000,'Gọn gàng, trung tâm phố cổ.'),(44,20,'Căn hộ 1 phòng ngủ',28,'1 giường lớn',3,3,1,0,1500000,'Bếp riêng, ban công nhìn phố.'),(45,21,'Phòng tiêu chuẩn',28,'1 giường đôi',2,8,1,0,800000,'Tiện nghi, gần bến tàu.'),(46,21,'Bungalow view vịnh',28,'1 giường lớn',2,4,1,0,1600000,'Nhìn thẳng ra vịnh Lan Hạ.'),(47,22,'Lều glamping',28,'1 giường đôi',2,5,1,0,950000,'Cắm trại tiện nghi giữa đồi chè.'),(48,22,'Nhà gỗ view thác',28,'2 giường đôi',4,2,1,0,1900000,'Gia đình, nghe tiếng thác.');
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tour`
--

LOCK TABLES `Tour` WRITE;
/*!40000 ALTER TABLE `Tour` DISABLE KEYS */;
INSERT INTO `Tour` VALUES (13,'TR001','Săn mây Tà Xùa 3N2Đ','san-may-ta-xua-3n2d','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.',NULL,NULL,NULL,3,2,'Hà Nội','Tà Xùa, Sơn La',NULL,1,25,NULL,2500000,30,4,4.5,2,'VISIBLE','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.746','2026-10-07 09:28:16.570'),(14,'TR002','Khám phá Hà Giang 4N3Đ','kham-pha-ha-giang-4n3d','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.',NULL,NULL,NULL,4,3,'Hà Nội','Hà Giang',NULL,1,25,NULL,3900000,30,4,5,1,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.765','2026-10-07 09:28:16.576'),(15,'TR003','Lý Sơn – Đảo tiên 2N1Đ','ly-son-dao-tien-2n1d','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.',NULL,NULL,NULL,2,1,'Đà Nẵng','Lý Sơn, Quảng Ngãi',NULL,1,25,NULL,1800000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.783','2026-10-07 09:28:10.783'),(16,'TR004','Kỳ Co – Eo Gió 1 ngày','ky-co-eo-gio-1-ngay','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.',NULL,NULL,NULL,1,0,'Quy Nhơn','Quy Nhơn, Bình Định',NULL,1,25,NULL,650000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.799','2026-10-07 09:28:10.799'),(17,'TR005','Phú Quốc – Thiên đường biển đảo 3N2Đ','phu-quoc-thien-duong-bien-dao-3n2d','Cáp treo Hòn Thơm, câu cá, lặn ngắm san hô và hoàng hôn Bãi Sao.','Cáp treo Hòn Thơm, câu cá, lặn ngắm san hô và hoàng hôn Bãi Sao.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Phú Quốc, Kiên Giang',NULL,1,25,NULL,3200000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.815','2026-10-07 09:28:10.815'),(18,'TR006','Tràng An – Bái Đính – Hang Múa 1 ngày','trang-an-bai-dinh-hang-mua-1-ngay','Du thuyền Tràng An, chùa Bái Đính và leo Hang Múa ngắm toàn cảnh.','Du thuyền Tràng An, chùa Bái Đính và leo Hang Múa ngắm toàn cảnh.',NULL,NULL,NULL,1,0,'Hà Nội','Ninh Bình',NULL,1,25,NULL,850000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.833','2026-10-07 09:28:10.833'),(19,'TR007','Mộc Châu mùa hoa 2N1Đ','moc-chau-mua-hoa-2n1d','Đồi chè trái tim, thác Dải Yếm, rừng thông bản Áng, vườn hoa.','Đồi chè trái tim, thác Dải Yếm, rừng thông bản Áng, vườn hoa.',NULL,NULL,NULL,2,1,'Hà Nội','Mộc Châu, Sơn La',NULL,1,25,NULL,1650000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.852','2026-10-07 09:28:10.852'),(20,'TR008','Huế – Hành trình di sản 2N1Đ','hue-hanh-trinh-di-san-2n1d','Đại Nội, lăng tẩm, chùa Thiên Mụ và thuyền rồng sông Hương.','Đại Nội, lăng tẩm, chùa Thiên Mụ và thuyền rồng sông Hương.',NULL,NULL,NULL,2,1,'Đà Nẵng','Huế, Thừa Thiên Huế',NULL,1,25,NULL,1950000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.874','2026-10-07 09:28:10.874'),(21,'TR009','Nha Trang – Tour 4 đảo 3N2Đ','nha-trang-tour-4-dao-3n2d','Khám phá 4 đảo, lặn biển, tắm bùn khoáng và VinWonders.','Khám phá 4 đảo, lặn biển, tắm bùn khoáng và VinWonders.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Nha Trang, Khánh Hòa',NULL,1,25,NULL,2800000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.893','2026-10-07 09:28:10.893'),(22,'TR010','Miền Tây – Chợ nổi Cái Răng 2N1Đ','mien-tay-cho-noi-cai-rang-2n1d','Chợ nổi Cái Răng, vườn trái cây, lò hủ tiếu và đờn ca tài tử.','Chợ nổi Cái Răng, vườn trái cây, lò hủ tiếu và đờn ca tài tử.',NULL,NULL,NULL,2,1,'TP. Hồ Chí Minh','Cần Thơ',NULL,1,25,NULL,1500000,30,4,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:28:10.910','2026-10-07 09:28:10.910');
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
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourDeparture`
--

LOCK TABLES `TourDeparture` WRITE;
/*!40000 ALTER TABLE `TourDeparture` DISABLE KEYS */;
INSERT INTO `TourDeparture` VALUES (37,13,'2026-10-17','2026-10-19',20,2,0,'OPEN',NULL),(38,13,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(39,13,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(40,14,'2026-10-17','2026-10-20',20,0,0,'OPEN',NULL),(41,14,'2026-10-31','2026-11-03',20,0,0,'OPEN',NULL),(42,14,'2026-11-16','2026-11-19',20,0,0,'OPEN',NULL),(43,15,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(44,15,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(45,15,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(46,16,'2026-10-17','2026-10-17',20,0,0,'OPEN',NULL),(47,16,'2026-10-31','2026-10-31',20,0,0,'OPEN',NULL),(48,16,'2026-11-16','2026-11-16',20,0,0,'OPEN',NULL),(49,17,'2026-10-17','2026-10-19',20,0,0,'OPEN',NULL),(50,17,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(51,17,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(52,18,'2026-10-17','2026-10-17',20,0,0,'OPEN',NULL),(53,18,'2026-10-31','2026-10-31',20,0,0,'OPEN',NULL),(54,18,'2026-11-16','2026-11-16',20,0,0,'OPEN',NULL),(55,19,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(56,19,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(57,19,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(58,20,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(59,20,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(60,20,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(61,21,'2026-10-17','2026-10-19',20,0,0,'OPEN',NULL),(62,21,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(63,21,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(64,22,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(65,22,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(66,22,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourImage`
--

LOCK TABLES `TourImage` WRITE;
/*!40000 ALTER TABLE `TourImage` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=133 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourPrice`
--

LOCK TABLES `TourPrice` WRITE;
/*!40000 ALTER TABLE `TourPrice` DISABLE KEYS */;
INSERT INTO `TourPrice` VALUES (73,37,'ADULT',2500000,'Người lớn',0),(74,37,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(75,38,'ADULT',2500000,'Người lớn',0),(76,38,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(77,39,'ADULT',2500000,'Người lớn',0),(78,39,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(79,40,'ADULT',3900000,'Người lớn',0),(80,40,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(81,41,'ADULT',3900000,'Người lớn',0),(82,41,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(83,42,'ADULT',3900000,'Người lớn',0),(84,42,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(85,43,'ADULT',1800000,'Người lớn',0),(86,43,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(87,44,'ADULT',1800000,'Người lớn',0),(88,44,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(89,45,'ADULT',1800000,'Người lớn',0),(90,45,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(91,46,'ADULT',650000,'Người lớn',0),(92,46,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(93,47,'ADULT',650000,'Người lớn',0),(94,47,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(95,48,'ADULT',650000,'Người lớn',0),(96,48,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(97,49,'ADULT',3200000,'Người lớn',0),(98,49,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(99,50,'ADULT',3200000,'Người lớn',0),(100,50,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(101,51,'ADULT',3200000,'Người lớn',0),(102,51,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(103,52,'ADULT',850000,'Người lớn',0),(104,52,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(105,53,'ADULT',850000,'Người lớn',0),(106,53,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(107,54,'ADULT',850000,'Người lớn',0),(108,54,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(109,55,'ADULT',1650000,'Người lớn',0),(110,55,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(111,56,'ADULT',1650000,'Người lớn',0),(112,56,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(113,57,'ADULT',1650000,'Người lớn',0),(114,57,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(115,58,'ADULT',1950000,'Người lớn',0),(116,58,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(117,59,'ADULT',1950000,'Người lớn',0),(118,59,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(119,60,'ADULT',1950000,'Người lớn',0),(120,60,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(121,61,'ADULT',2800000,'Người lớn',0),(122,61,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(123,62,'ADULT',2800000,'Người lớn',0),(124,62,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(125,63,'ADULT',2800000,'Người lớn',0),(126,63,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(127,64,'ADULT',1500000,'Người lớn',0),(128,64,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(129,65,'ADULT',1500000,'Người lớn',0),(130,65,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(131,66,'ADULT',1500000,'Người lớn',0),(132,66,'CHILD',1050000,'Trẻ em 5–11 tuổi',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TravelGuide`
--

LOCK TABLES `TravelGuide` WRITE;
/*!40000 ALTER TABLE `TravelGuide` DISABLE KEYS */;
INSERT INTO `TravelGuide` VALUES (4,'Kinh nghiệm du lịch Đà Lạt 3 ngày 2 đêm','kinh-nghiem-du-lich-da-lat-3n2d','Ban biên tập StayTour','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70','Gợi ý lịch trình Đà Lạt tiết kiệm cho nhóm bạn.','Ngày 1: khám phá trung tâm, chợ đêm Đà Lạt.\nNgày 2: đồi chè Cầu Đất, săn mây.\nNgày 3: vườn hoa, mua đặc sản về làm quà.','Đà Lạt, Lâm Đồng',NULL,NULL,'2026-10-07 09:28:10.936','VISIBLE',NULL,'2026-10-07 09:28:10.937','2026-10-07 09:28:10.937');
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

-- Dump completed on 2026-10-07  9:28:40
