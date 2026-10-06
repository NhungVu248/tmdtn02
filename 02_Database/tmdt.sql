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
  `username` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('SUPER_ADMIN','MANAGER') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MANAGER',
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
INSERT INTO `Admin` VALUES (1,'admin','$2a$10$TNqWyAn3ZBcRjgeMOlkLMO.zRMqetPD4GFdhSS/ov6YD9I//3OnfW','Quản trị viên','SUPER_ADMIN',1,0,NULL,'2026-10-05 04:43:06.106','2026-10-06 14:01:45.978');
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
  `action` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `entityType` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entityId` int DEFAULT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci,
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
  `username` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `adminId` int DEFAULT NULL,
  `ip` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `reason` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `AdminLoginAttempt_username_idx` (`username`),
  KEY `AdminLoginAttempt_adminId_idx` (`adminId`),
  CONSTRAINT `AdminLoginAttempt_adminId_fkey` FOREIGN KEY (`adminId`) REFERENCES `Admin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AdminLoginAttempt`
--

LOCK TABLES `AdminLoginAttempt` WRITE;
/*!40000 ALTER TABLE `AdminLoginAttempt` DISABLE KEYS */;
INSERT INTO `AdminLoginAttempt` VALUES (1,'admin',NULL,'172.18.0.1',0,'not_found','2026-10-05 04:40:03.386'),(2,'admin',1,'172.18.0.1',1,NULL,'2026-10-05 04:43:15.218'),(3,'admin',1,'172.18.0.1',1,NULL,'2026-10-05 05:21:23.670'),(4,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 13:53:20.622'),(5,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 13:53:51.558'),(6,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 13:53:58.927'),(7,'admin',1,'172.18.0.1',1,NULL,'2026-10-06 14:01:45.989');
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
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scope` enum('GENERAL','ROOM') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GENERAL',
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
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Area_slug_key` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Area`
--

LOCK TABLES `Area` WRITE;
/*!40000 ALTER TABLE `Area` DISABLE KEYS */;
INSERT INTO `Area` VALUES (9,'Đà Lạt','da-lat','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1),(10,'Đà Nẵng','da-nang','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',2),(11,'Hội An','hoi-an','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',3),(12,'Sa Pa','sa-pa','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',4);
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
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinHash` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('HOMESTAY','TOUR') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('PENDING_DEPOSIT','DEPOSITED','CONFIRMED','COMPLETED','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING_DEPOSIT',
  `productId` int DEFAULT NULL,
  `propertyId` int DEFAULT NULL,
  `roomTypeId` int DEFAULT NULL,
  `tourId` int DEFAULT NULL,
  `tourDepartureId` int DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `guestName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guestEmail` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guestPhone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `checkIn` date DEFAULT NULL,
  `checkOut` date DEFAULT NULL,
  `nights` int DEFAULT NULL,
  `guests` int NOT NULL DEFAULT '1',
  `children` int NOT NULL DEFAULT '0',
  `totalPrice` int NOT NULL,
  `depositAmount` int NOT NULL,
  `remainingAmount` int NOT NULL,
  `paymentMethod` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transactionId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `depositPaidAt` datetime(3) DEFAULT NULL,
  `discountCode` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Booking`
--

LOCK TABLES `Booking` WRITE;
/*!40000 ALTER TABLE `Booking` DISABLE KEYS */;
INSERT INTO `Booking` VALUES (2,'BK-HMKV8BQEK',NULL,'HOMESTAY','DEPOSITED',NULL,9,19,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Nhận phòng muộn ~21h. Xin phòng tầng cao, yên tĩnh.','2026-10-26','2026-10-28',2,2,0,1700000,510000,1190000,'VNPAY',NULL,'2026-09-26 00:00:00.000',NULL,0,0,NULL,'2026-10-06 14:00:55.112','2026-10-06 14:00:55.112',0,NULL,NULL),(3,'BK-CXKPF4N3C',NULL,'HOMESTAY','PENDING_DEPOSIT',NULL,10,22,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Cần thêm 1 giường phụ cho trẻ em.','2026-11-10','2026-11-12',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-06 14:15:55.136','2026-10-06 14:00:55.137','2026-10-06 14:00:55.137',0,NULL,NULL),(4,'BK-9N2AK384J',NULL,'HOMESTAY','COMPLETED',NULL,11,24,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Kỳ nghỉ gia đình.','2026-09-16','2026-09-18',2,2,0,2200000,660000,1540000,'VNPAY',NULL,'2026-08-17 00:00:00.000',NULL,0,0,NULL,'2026-10-06 14:00:55.153','2026-10-06 14:00:55.153',0,NULL,NULL),(5,'BK-CVAE5JWN9',NULL,'TOUR','CONFIRMED',NULL,NULL,NULL,9,25,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Ăn chay 1 suất.','2026-10-16','2026-10-18',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-01 00:00:00.000',NULL,0,0,NULL,'2026-10-06 14:00:55.167','2026-10-06 14:00:55.167',0,NULL,NULL),(6,'BK-QZRKWLDVE',NULL,'TOUR','COMPLETED',NULL,NULL,NULL,10,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456',NULL,'2026-09-26','2026-09-29',3,2,0,7800000,2340000,5460000,'COD',NULL,'2026-10-01 00:00:00.000',NULL,0,0,NULL,'2026-10-06 14:00:55.184','2026-10-06 14:02:22.305',0,NULL,NULL),(7,'BK-U7USS2QZQ',NULL,'TOUR','CANCELLED',NULL,NULL,NULL,9,25,3,'Trần Thu Hà','ha.tran@gmail.com','0912345678','Bận việc đột xuất.','2026-10-16','2026-10-18',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-01 00:00:00.000',NULL,0,0,NULL,'2026-10-06 14:00:55.197','2026-10-06 14:00:55.197',0,NULL,'2026-10-04 00:00:00.000'),(8,'BK-DSYCDVJMW','dec58ab7d7f9fb6bd366cea633274ef3632f8eaa823bf811c14bed255d60e339','HOMESTAY','COMPLETED',NULL,9,19,NULL,NULL,NULL,'Lê Văn Khách','khachvanglai@example.com','0988777666',NULL,'2026-09-21','2026-09-23',2,2,0,1700000,510000,1190000,'COD',NULL,'2026-08-22 00:00:00.000',NULL,0,0,NULL,'2026-10-06 14:00:55.210','2026-10-06 14:00:55.210',0,NULL,NULL),(9,'BK-DKJ9F8QPE','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','HOMESTAY','PENDING_DEPOSIT',NULL,10,22,NULL,NULL,NULL,'Phạm Thu Trang','guest.track@example.com','0977555444','Đặt hộ bạn.','2026-10-16','2026-10-18',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-06 14:15:55.221','2026-10-06 14:00:55.222','2026-10-06 14:01:45.865',0,NULL,NULL);
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
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `isRefundable` tinyint(1) NOT NULL DEFAULT '1',
  `freeHours` int NOT NULL DEFAULT '24',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CancellationPolicy`
--

LOCK TABLES `CancellationPolicy` WRITE;
/*!40000 ALTER TABLE `CancellationPolicy` DISABLE KEYS */;
INSERT INTO `CancellationPolicy` VALUES (1,'Linh hoạt tiêu chuẩn',1,24,'2026-10-05 04:43:05.829','2026-10-05 04:43:05.829'),(2,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:53:11.058','2026-10-06 13:53:11.058'),(3,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:59:38.411','2026-10-06 13:59:38.411');
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
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('HOMESTAY','TOUR') COLLATE utf8mb4_unicode_ci NOT NULL,
  `kind` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` int NOT NULL,
  `minOrderValue` int NOT NULL DEFAULT '0',
  `scope` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL',
  `productId` int DEFAULT NULL,
  `propertyId` int DEFAULT NULL,
  `tourId` int DEFAULT NULL,
  `audience` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ALL',
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DiscountCode`
--

LOCK TABLES `DiscountCode` WRITE;
/*!40000 ALTER TABLE `DiscountCode` DISABLE KEYS */;
INSERT INTO `DiscountCode` VALUES (5,'STAYTOUR10','PERCENT',10,500000,'ALL',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-06 13:59:38.687'),(6,'HE2026','FIXED',150000,1000000,'HOMESTAY',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-06 13:59:38.687');
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
  `tokenHash` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Favorite`
--

LOCK TABLES `Favorite` WRITE;
/*!40000 ALTER TABLE `Favorite` DISABLE KEYS */;
INSERT INTO `Favorite` VALUES (1,2,NULL,9,NULL,'2026-10-06 14:00:55.254'),(2,2,NULL,NULL,9,'2026-10-06 14:00:55.260'),(3,3,NULL,11,NULL,'2026-10-06 14:00:55.262');
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
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` enum('ABOUT','POLICY','GUIDE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `excerpt` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '1',
  `order` int NOT NULL DEFAULT '0',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `InfoArticle_slug_key` (`slug`),
  KEY `InfoArticle_category_idx` (`category`),
  KEY `InfoArticle_published_idx` (`published`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InfoArticle`
--

LOCK TABLES `InfoArticle` WRITE;
/*!40000 ALTER TABLE `InfoArticle` DISABLE KEYS */;
INSERT INTO `InfoArticle` VALUES (9,'gioi-thieu','Thông tin người bán','ABOUT','Về StayTour','StayTour là nền tảng đặt homestay và tour du lịch nội địa.',1,1,'2026-10-06 13:59:38.693','2026-10-06 13:59:38.693'),(10,'dieu-kien-giao-dich','Điều kiện giao dịch chung','POLICY','Điều khoản','Các điều kiện và điều khoản giao dịch chung khi sử dụng StayTour.',1,2,'2026-10-06 13:59:38.693','2026-10-06 13:59:38.693'),(11,'chinh-sach-doi-tra-huy','Chính sách đổi – trả – hủy','POLICY','Hủy & hoàn tiền','Chính sách hủy đặt chỗ và hoàn tiền theo từng mốc thời gian.',1,3,'2026-10-06 13:59:38.693','2026-10-06 13:59:38.693'),(12,'bao-mat-du-lieu','Bảo vệ dữ liệu cá nhân','POLICY','Bảo mật','Cam kết bảo vệ dữ liệu cá nhân của khách hàng.',1,4,'2026-10-06 13:59:38.693','2026-10-06 13:59:38.693');
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
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `success` tinyint(1) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `LoginAttempt_email_idx` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LoginAttempt`
--

LOCK TABLES `LoginAttempt` WRITE;
/*!40000 ALTER TABLE `LoginAttempt` DISABLE KEYS */;
INSERT INTO `LoginAttempt` VALUES (1,'khachhang@staytour.vn','172.18.0.1',1,'2026-10-05 05:21:23.493'),(2,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:14.362'),(3,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:26.227'),(4,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:35.732'),(5,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:01:45.791'),(6,'khachhang@gmail.com','172.18.0.1',1,'2026-10-06 14:02:03.594');
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
  `code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `tokenHash` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` int NOT NULL,
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transactionId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Payment_bookingId_idx` (`bookingId`),
  CONSTRAINT `Payment_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment`
--

LOCK TABLES `Payment` WRITE;
/*!40000 ALTER TABLE `Payment` DISABLE KEYS */;
INSERT INTO `Payment` VALUES (2,2,'VNPAY',510000,'SUCCESS','VNP1791295255109','2026-10-06 14:00:55.118'),(3,4,'VNPAY',660000,'SUCCESS','VNP1791295250151','2026-10-06 14:00:55.157'),(4,5,'VNPAY',1500000,'SUCCESS','VNP1791295246166','2026-10-06 14:00:55.175'),(5,6,'COD',2340000,'SUCCESS',NULL,'2026-10-06 14:00:55.189'),(6,7,'VNPAY',1500000,'SUCCESS','VNP1791295243196','2026-10-06 14:00:55.203'),(7,8,'COD',510000,'SUCCESS',NULL,'2026-10-06 14:00:55.214');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PolicyMilestone`
--

LOCK TABLES `PolicyMilestone` WRITE;
/*!40000 ALTER TABLE `PolicyMilestone` DISABLE KEYS */;
INSERT INTO `PolicyMilestone` VALUES (1,1,7,100),(2,1,3,50),(3,2,7,100),(4,2,3,50),(5,3,7,100),(6,3,3,50);
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
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('HOMESTAY','TOUR') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('VISIBLE','HIDDEN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'VISIBLE',
  `description` text COLLATE utf8mb4_unicode_ci,
  `location` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` int NOT NULL,
  `rating` double NOT NULL DEFAULT '0',
  `thumbnail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `amenities` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `durationDays` int DEFAULT NULL,
  `priceChild` int DEFAULT NULL,
  `cancellationPolicy` text COLLATE utf8mb4_unicode_ci,
  `cancellationPolicyId` int DEFAULT NULL,
  `itinerary` text COLLATE utf8mb4_unicode_ci,
  `included` text COLLATE utf8mb4_unicode_ci,
  `excluded` text COLLATE utf8mb4_unicode_ci,
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
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `Promotion_active_idx` (`active`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
INSERT INTO `Promotion` VALUES (5,'Giảm 20% đặt homestay dịp lễ','Áp dụng cho đơn đặt trước 7 ngày.','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,'2026-10-06 13:59:38.684'),(6,'Tour Tây Bắc mùa săn mây','Ưu đãi nhóm từ 4 khách trở lên.','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,'2026-10-06 13:59:38.684');
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
  `propertyCode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `propertyType` enum('HOMESTAY','HOTEL','VILLA','APARTMENT','RESORT') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HOMESTAY',
  `starRating` int DEFAULT NULL,
  `shortDescription` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `provinceId` int DEFAULT NULL,
  `areaId` int DEFAULT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `checkInTime` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checkOutTime` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `basePrice` int NOT NULL,
  `depositRate` int DEFAULT NULL,
  `cancellationPolicyId` int DEFAULT NULL,
  `avgRating` double NOT NULL DEFAULT '0',
  `reviewCount` int NOT NULL DEFAULT '0',
  `contactPhone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contactEmail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('DRAFT','VISIBLE','HIDDEN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `thumbnail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `metaTitle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metaDescription` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Property`
--

LOCK TABLES `Property` WRITE;
/*!40000 ALTER TABLE `Property` DISABLE KEYS */;
INSERT INTO `Property` VALUES (9,'HS001','Pine Hill Homestay','pine-hill-homestay','HOMESTAY',NULL,'Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.','Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.',NULL,NULL,'Đà Lạt, Lâm Đồng',NULL,NULL,'14:00','12:00',850000,30,3,4.5,2,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.420','2026-10-06 14:00:55.268'),(10,'HS002','Biển Ngọc Villa','bien-ngoc-villa','HOMESTAY',NULL,'Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.','Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.',NULL,NULL,'Mỹ Khê, Đà Nẵng',NULL,NULL,'14:00','12:00',1600000,30,3,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.469','2026-10-06 14:00:55.279'),(11,'HS003','Sông Trăng Riverside','song-trang-riverside','HOMESTAY',NULL,'Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.','Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.',NULL,NULL,'Hội An, Quảng Nam',NULL,NULL,'14:00','12:00',1100000,30,3,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.501','2026-10-06 14:00:55.284'),(12,'HS004','Nhà Của Rừng','nha-cua-rung-sapa','HOMESTAY',NULL,'Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.','Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.',NULL,NULL,'Sa Pa, Lào Cai',NULL,NULL,'14:00','12:00',700000,30,3,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.535','2026-10-06 13:59:38.535');
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
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `type` enum('HOUSE_RULE','NOTE','FAQ') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HOUSE_RULE',
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `status` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  KEY `RefundRequest_bookingId_idx` (`bookingId`),
  CONSTRAINT `RefundRequest_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RefundRequest`
--

LOCK TABLES `RefundRequest` WRITE;
/*!40000 ALTER TABLE `RefundRequest` DISABLE KEYS */;
INSERT INTO `RefundRequest` VALUES (1,7,750000,50,'PENDING','2026-10-06 14:00:55.206');
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
  `productType` enum('HOMESTAY','TOUR') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'HOMESTAY',
  `productId` int DEFAULT NULL,
  `propertyId` int DEFAULT NULL,
  `tourId` int DEFAULT NULL,
  `bookingId` int DEFAULT NULL,
  `authorName` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rating` int NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
INSERT INTO `Review` VALUES (25,'HOMESTAY',NULL,11,NULL,4,'Nguyễn Minh Anh',5,'Homestay tuyệt vời, view đẹp, chủ nhà thân thiện. Sẽ quay lại!',1,0,'2026-09-19 00:00:00.000'),(26,'TOUR',NULL,NULL,10,6,'Nguyễn Minh Anh',4,'Lịch trình ổn, hướng dẫn viên nhiệt tình. Xe hơi đông.',0,0,'2026-10-05 00:00:00.000'),(27,'HOMESTAY',NULL,9,NULL,NULL,'Hoàng Thị Mai',5,'Sạch sẽ, gần trung tâm, nhân viên dễ thương.',1,0,'2026-09-30 00:00:00.000'),(28,'HOMESTAY',NULL,9,NULL,NULL,'Đỗ Quang Huy',4,'Phòng đẹp, buổi sáng hơi ồn một chút.',1,0,'2026-10-03 00:00:00.000'),(29,'HOMESTAY',NULL,10,NULL,NULL,'Vũ Thị Lan',5,'Không gian yên tĩnh, bữa sáng ngon.',1,0,'2026-09-23 00:00:00.000'),(30,'TOUR',NULL,NULL,9,NULL,'Nguyễn Văn Tú',5,'Cảnh đẹp mê hồn, tổ chức chuyên nghiệp.',1,0,'2026-09-29 00:00:00.000'),(31,'TOUR',NULL,NULL,9,NULL,'Trịnh Bảo',4,'Đáng tiền, nên mang thêm áo ấm.',1,0,'2026-09-16 00:00:00.000'),(32,'TOUR',NULL,NULL,10,NULL,'Lý Thu Hằng',5,'Chuyến đi đáng nhớ, hướng dẫn viên vui tính.',1,0,'2026-09-28 00:00:00.000');
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
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `tokenHash` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `usedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `ReviewToken_bookingId_key` (`bookingId`),
  UNIQUE KEY `ReviewToken_tokenHash_key` (`tokenHash`),
  CONSTRAINT `ReviewToken_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewToken`
--

LOCK TABLES `ReviewToken` WRITE;
/*!40000 ALTER TABLE `ReviewToken` DISABLE KEYS */;
INSERT INTO `ReviewToken` VALUES (1,8,'e80e3ac59002fd07c9379ab7f797a10e68167703bcd5b91fa12ac044950ddf8a','2026-11-05 00:00:00.000',NULL,'2026-10-06 14:00:55.219');
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
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=3241 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomInventory`
--

LOCK TABLES `RoomInventory` WRITE;
/*!40000 ALTER TABLE `RoomInventory` DISABLE KEYS */;
INSERT INTO `RoomInventory` VALUES (2161,19,'2026-10-07',6,0,0,NULL,0),(2162,19,'2026-10-08',6,0,0,NULL,0),(2163,19,'2026-10-09',6,0,0,NULL,0),(2164,19,'2026-10-10',6,0,0,NULL,0),(2165,19,'2026-10-11',6,0,0,NULL,0),(2166,19,'2026-10-12',6,0,0,NULL,0),(2167,19,'2026-10-13',6,0,0,NULL,0),(2168,19,'2026-10-14',6,0,0,NULL,0),(2169,19,'2026-10-15',6,0,0,NULL,0),(2170,19,'2026-10-16',6,0,0,NULL,0),(2171,19,'2026-10-17',6,0,0,NULL,0),(2172,19,'2026-10-18',6,0,0,NULL,0),(2173,19,'2026-10-19',6,0,0,NULL,0),(2174,19,'2026-10-20',6,0,0,NULL,0),(2175,19,'2026-10-21',6,0,0,NULL,0),(2176,19,'2026-10-22',6,0,0,NULL,0),(2177,19,'2026-10-23',6,0,0,NULL,0),(2178,19,'2026-10-24',6,0,0,NULL,0),(2179,19,'2026-10-25',6,0,0,NULL,0),(2180,19,'2026-10-26',6,1,0,NULL,0),(2181,19,'2026-10-27',6,1,0,NULL,0),(2182,19,'2026-10-28',6,0,0,NULL,0),(2183,19,'2026-10-29',6,0,0,NULL,0),(2184,19,'2026-10-30',6,0,0,NULL,0),(2185,19,'2026-10-31',6,0,0,NULL,0),(2186,19,'2026-11-01',6,0,0,NULL,0),(2187,19,'2026-11-02',6,0,0,NULL,0),(2188,19,'2026-11-03',6,0,0,NULL,0),(2189,19,'2026-11-04',6,0,0,NULL,0),(2190,19,'2026-11-05',6,0,0,NULL,0),(2191,19,'2026-11-06',6,0,0,NULL,0),(2192,19,'2026-11-07',6,0,0,NULL,0),(2193,19,'2026-11-08',6,0,0,NULL,0),(2194,19,'2026-11-09',6,0,0,NULL,0),(2195,19,'2026-11-10',6,0,0,NULL,0),(2196,19,'2026-11-11',6,0,0,NULL,0),(2197,19,'2026-11-12',6,0,0,NULL,0),(2198,19,'2026-11-13',6,0,0,NULL,0),(2199,19,'2026-11-14',6,0,0,NULL,0),(2200,19,'2026-11-15',6,0,0,NULL,0),(2201,19,'2026-11-16',6,0,0,NULL,0),(2202,19,'2026-11-17',6,0,0,NULL,0),(2203,19,'2026-11-18',6,0,0,NULL,0),(2204,19,'2026-11-19',6,0,0,NULL,0),(2205,19,'2026-11-20',6,0,0,NULL,0),(2206,19,'2026-11-21',6,0,0,NULL,0),(2207,19,'2026-11-22',6,0,0,NULL,0),(2208,19,'2026-11-23',6,0,0,NULL,0),(2209,19,'2026-11-24',6,0,0,NULL,0),(2210,19,'2026-11-25',6,0,0,NULL,0),(2211,19,'2026-11-26',6,0,0,NULL,0),(2212,19,'2026-11-27',6,0,0,NULL,0),(2213,19,'2026-11-28',6,0,0,NULL,0),(2214,19,'2026-11-29',6,0,0,NULL,0),(2215,19,'2026-11-30',6,0,0,NULL,0),(2216,19,'2026-12-01',6,0,0,NULL,0),(2217,19,'2026-12-02',6,0,0,NULL,0),(2218,19,'2026-12-03',6,0,0,NULL,0),(2219,19,'2026-12-04',6,0,0,NULL,0),(2220,19,'2026-12-05',6,0,0,NULL,0),(2221,19,'2026-12-06',6,0,0,NULL,0),(2222,19,'2026-12-07',6,0,0,NULL,0),(2223,19,'2026-12-08',6,0,0,NULL,0),(2224,19,'2026-12-09',6,0,0,NULL,0),(2225,19,'2026-12-10',6,0,0,NULL,0),(2226,19,'2026-12-11',6,0,0,NULL,0),(2227,19,'2026-12-12',6,0,0,NULL,0),(2228,19,'2026-12-13',6,0,0,NULL,0),(2229,19,'2026-12-14',6,0,0,NULL,0),(2230,19,'2026-12-15',6,0,0,NULL,0),(2231,19,'2026-12-16',6,0,0,NULL,0),(2232,19,'2026-12-17',6,0,0,NULL,0),(2233,19,'2026-12-18',6,0,0,NULL,0),(2234,19,'2026-12-19',6,0,0,NULL,0),(2235,19,'2026-12-20',6,0,0,NULL,0),(2236,19,'2026-12-21',6,0,0,NULL,0),(2237,19,'2026-12-22',6,0,0,NULL,0),(2238,19,'2026-12-23',6,0,0,NULL,0),(2239,19,'2026-12-24',6,0,0,NULL,0),(2240,19,'2026-12-25',6,0,0,NULL,0),(2241,19,'2026-12-26',6,0,0,NULL,0),(2242,19,'2026-12-27',6,0,0,NULL,0),(2243,19,'2026-12-28',6,0,0,NULL,0),(2244,19,'2026-12-29',6,0,0,NULL,0),(2245,19,'2026-12-30',6,0,0,NULL,0),(2246,19,'2026-12-31',6,0,0,NULL,0),(2247,19,'2027-01-01',6,0,0,NULL,0),(2248,19,'2027-01-02',6,0,0,NULL,0),(2249,19,'2027-01-03',6,0,0,NULL,0),(2250,19,'2027-01-04',6,0,0,NULL,0),(2251,19,'2027-01-05',6,0,0,NULL,0),(2252,19,'2027-01-06',6,0,0,NULL,0),(2253,19,'2027-01-07',6,0,0,NULL,0),(2254,19,'2027-01-08',6,0,0,NULL,0),(2255,19,'2027-01-09',6,0,0,NULL,0),(2256,19,'2027-01-10',6,0,0,NULL,0),(2257,19,'2027-01-11',6,0,0,NULL,0),(2258,19,'2027-01-12',6,0,0,NULL,0),(2259,19,'2027-01-13',6,0,0,NULL,0),(2260,19,'2027-01-14',6,0,0,NULL,0),(2261,19,'2027-01-15',6,0,0,NULL,0),(2262,19,'2027-01-16',6,0,0,NULL,0),(2263,19,'2027-01-17',6,0,0,NULL,0),(2264,19,'2027-01-18',6,0,0,NULL,0),(2265,19,'2027-01-19',6,0,0,NULL,0),(2266,19,'2027-01-20',6,0,0,NULL,0),(2267,19,'2027-01-21',6,0,0,NULL,0),(2268,19,'2027-01-22',6,0,0,NULL,0),(2269,19,'2027-01-23',6,0,0,NULL,0),(2270,19,'2027-01-24',6,0,0,NULL,0),(2271,19,'2027-01-25',6,0,0,NULL,0),(2272,19,'2027-01-26',6,0,0,NULL,0),(2273,19,'2027-01-27',6,0,0,NULL,0),(2274,19,'2027-01-28',6,0,0,NULL,0),(2275,19,'2027-01-29',6,0,0,NULL,0),(2276,19,'2027-01-30',6,0,0,NULL,0),(2277,19,'2027-01-31',6,0,0,NULL,0),(2278,19,'2027-02-01',6,0,0,NULL,0),(2279,19,'2027-02-02',6,0,0,NULL,0),(2280,19,'2027-02-03',6,0,0,NULL,0),(2281,20,'2026-10-07',4,0,0,NULL,0),(2282,20,'2026-10-08',4,0,0,NULL,0),(2283,20,'2026-10-09',4,0,0,NULL,0),(2284,20,'2026-10-10',4,0,0,NULL,0),(2285,20,'2026-10-11',4,0,0,NULL,0),(2286,20,'2026-10-12',4,0,0,NULL,0),(2287,20,'2026-10-13',4,0,0,NULL,0),(2288,20,'2026-10-14',4,0,0,NULL,0),(2289,20,'2026-10-15',4,0,0,NULL,0),(2290,20,'2026-10-16',4,0,0,NULL,0),(2291,20,'2026-10-17',4,0,0,NULL,0),(2292,20,'2026-10-18',4,0,0,NULL,0),(2293,20,'2026-10-19',4,0,0,NULL,0),(2294,20,'2026-10-20',4,0,0,NULL,0),(2295,20,'2026-10-21',4,0,0,NULL,0),(2296,20,'2026-10-22',4,0,0,NULL,0),(2297,20,'2026-10-23',4,0,0,NULL,0),(2298,20,'2026-10-24',4,0,0,NULL,0),(2299,20,'2026-10-25',4,0,0,NULL,0),(2300,20,'2026-10-26',4,0,0,NULL,0),(2301,20,'2026-10-27',4,0,0,NULL,0),(2302,20,'2026-10-28',4,0,0,NULL,0),(2303,20,'2026-10-29',4,0,0,NULL,0),(2304,20,'2026-10-30',4,0,0,NULL,0),(2305,20,'2026-10-31',4,0,0,NULL,0),(2306,20,'2026-11-01',4,0,0,NULL,0),(2307,20,'2026-11-02',4,0,0,NULL,0),(2308,20,'2026-11-03',4,0,0,NULL,0),(2309,20,'2026-11-04',4,0,0,NULL,0),(2310,20,'2026-11-05',4,0,0,NULL,0),(2311,20,'2026-11-06',4,0,0,NULL,0),(2312,20,'2026-11-07',4,0,0,NULL,0),(2313,20,'2026-11-08',4,0,0,NULL,0),(2314,20,'2026-11-09',4,0,0,NULL,0),(2315,20,'2026-11-10',4,0,0,NULL,0),(2316,20,'2026-11-11',4,0,0,NULL,0),(2317,20,'2026-11-12',4,0,0,NULL,0),(2318,20,'2026-11-13',4,0,0,NULL,0),(2319,20,'2026-11-14',4,0,0,NULL,0),(2320,20,'2026-11-15',4,0,0,NULL,0),(2321,20,'2026-11-16',4,0,0,NULL,0),(2322,20,'2026-11-17',4,0,0,NULL,0),(2323,20,'2026-11-18',4,0,0,NULL,0),(2324,20,'2026-11-19',4,0,0,NULL,0),(2325,20,'2026-11-20',4,0,0,NULL,0),(2326,20,'2026-11-21',4,0,0,NULL,0),(2327,20,'2026-11-22',4,0,0,NULL,0),(2328,20,'2026-11-23',4,0,0,NULL,0),(2329,20,'2026-11-24',4,0,0,NULL,0),(2330,20,'2026-11-25',4,0,0,NULL,0),(2331,20,'2026-11-26',4,0,0,NULL,0),(2332,20,'2026-11-27',4,0,0,NULL,0),(2333,20,'2026-11-28',4,0,0,NULL,0),(2334,20,'2026-11-29',4,0,0,NULL,0),(2335,20,'2026-11-30',4,0,0,NULL,0),(2336,20,'2026-12-01',4,0,0,NULL,0),(2337,20,'2026-12-02',4,0,0,NULL,0),(2338,20,'2026-12-03',4,0,0,NULL,0),(2339,20,'2026-12-04',4,0,0,NULL,0),(2340,20,'2026-12-05',4,0,0,NULL,0),(2341,20,'2026-12-06',4,0,0,NULL,0),(2342,20,'2026-12-07',4,0,0,NULL,0),(2343,20,'2026-12-08',4,0,0,NULL,0),(2344,20,'2026-12-09',4,0,0,NULL,0),(2345,20,'2026-12-10',4,0,0,NULL,0),(2346,20,'2026-12-11',4,0,0,NULL,0),(2347,20,'2026-12-12',4,0,0,NULL,0),(2348,20,'2026-12-13',4,0,0,NULL,0),(2349,20,'2026-12-14',4,0,0,NULL,0),(2350,20,'2026-12-15',4,0,0,NULL,0),(2351,20,'2026-12-16',4,0,0,NULL,0),(2352,20,'2026-12-17',4,0,0,NULL,0),(2353,20,'2026-12-18',4,0,0,NULL,0),(2354,20,'2026-12-19',4,0,0,NULL,0),(2355,20,'2026-12-20',4,0,0,NULL,0),(2356,20,'2026-12-21',4,0,0,NULL,0),(2357,20,'2026-12-22',4,0,0,NULL,0),(2358,20,'2026-12-23',4,0,0,NULL,0),(2359,20,'2026-12-24',4,0,0,NULL,0),(2360,20,'2026-12-25',4,0,0,NULL,0),(2361,20,'2026-12-26',4,0,0,NULL,0),(2362,20,'2026-12-27',4,0,0,NULL,0),(2363,20,'2026-12-28',4,0,0,NULL,0),(2364,20,'2026-12-29',4,0,0,NULL,0),(2365,20,'2026-12-30',4,0,0,NULL,0),(2366,20,'2026-12-31',4,0,0,NULL,0),(2367,20,'2027-01-01',4,0,0,NULL,0),(2368,20,'2027-01-02',4,0,0,NULL,0),(2369,20,'2027-01-03',4,0,0,NULL,0),(2370,20,'2027-01-04',4,0,0,NULL,0),(2371,20,'2027-01-05',4,0,0,NULL,0),(2372,20,'2027-01-06',4,0,0,NULL,0),(2373,20,'2027-01-07',4,0,0,NULL,0),(2374,20,'2027-01-08',4,0,0,NULL,0),(2375,20,'2027-01-09',4,0,0,NULL,0),(2376,20,'2027-01-10',4,0,0,NULL,0),(2377,20,'2027-01-11',4,0,0,NULL,0),(2378,20,'2027-01-12',4,0,0,NULL,0),(2379,20,'2027-01-13',4,0,0,NULL,0),(2380,20,'2027-01-14',4,0,0,NULL,0),(2381,20,'2027-01-15',4,0,0,NULL,0),(2382,20,'2027-01-16',4,0,0,NULL,0),(2383,20,'2027-01-17',4,0,0,NULL,0),(2384,20,'2027-01-18',4,0,0,NULL,0),(2385,20,'2027-01-19',4,0,0,NULL,0),(2386,20,'2027-01-20',4,0,0,NULL,0),(2387,20,'2027-01-21',4,0,0,NULL,0),(2388,20,'2027-01-22',4,0,0,NULL,0),(2389,20,'2027-01-23',4,0,0,NULL,0),(2390,20,'2027-01-24',4,0,0,NULL,0),(2391,20,'2027-01-25',4,0,0,NULL,0),(2392,20,'2027-01-26',4,0,0,NULL,0),(2393,20,'2027-01-27',4,0,0,NULL,0),(2394,20,'2027-01-28',4,0,0,NULL,0),(2395,20,'2027-01-29',4,0,0,NULL,0),(2396,20,'2027-01-30',4,0,0,NULL,0),(2397,20,'2027-01-31',4,0,0,NULL,0),(2398,20,'2027-02-01',4,0,0,NULL,0),(2399,20,'2027-02-02',4,0,0,NULL,0),(2400,20,'2027-02-03',4,0,0,NULL,0),(2401,21,'2026-10-07',2,0,0,NULL,0),(2402,21,'2026-10-08',2,0,0,NULL,0),(2403,21,'2026-10-09',2,0,0,NULL,0),(2404,21,'2026-10-10',2,0,0,NULL,0),(2405,21,'2026-10-11',2,0,0,NULL,0),(2406,21,'2026-10-12',2,0,0,NULL,0),(2407,21,'2026-10-13',2,0,0,NULL,0),(2408,21,'2026-10-14',2,0,0,NULL,0),(2409,21,'2026-10-15',2,0,0,NULL,0),(2410,21,'2026-10-16',2,0,0,NULL,0),(2411,21,'2026-10-17',2,0,0,NULL,0),(2412,21,'2026-10-18',2,0,0,NULL,0),(2413,21,'2026-10-19',2,0,0,NULL,0),(2414,21,'2026-10-20',2,0,0,NULL,0),(2415,21,'2026-10-21',2,0,0,NULL,0),(2416,21,'2026-10-22',2,0,0,NULL,0),(2417,21,'2026-10-23',2,0,0,NULL,0),(2418,21,'2026-10-24',2,0,0,NULL,0),(2419,21,'2026-10-25',2,0,0,NULL,0),(2420,21,'2026-10-26',2,0,0,NULL,0),(2421,21,'2026-10-27',2,0,0,NULL,0),(2422,21,'2026-10-28',2,0,0,NULL,0),(2423,21,'2026-10-29',2,0,0,NULL,0),(2424,21,'2026-10-30',2,0,0,NULL,0),(2425,21,'2026-10-31',2,0,0,NULL,0),(2426,21,'2026-11-01',2,0,0,NULL,0),(2427,21,'2026-11-02',2,0,0,NULL,0),(2428,21,'2026-11-03',2,0,0,NULL,0),(2429,21,'2026-11-04',2,0,0,NULL,0),(2430,21,'2026-11-05',2,0,0,NULL,0),(2431,21,'2026-11-06',2,0,0,NULL,0),(2432,21,'2026-11-07',2,0,0,NULL,0),(2433,21,'2026-11-08',2,0,0,NULL,0),(2434,21,'2026-11-09',2,0,0,NULL,0),(2435,21,'2026-11-10',2,0,0,NULL,0),(2436,21,'2026-11-11',2,0,0,NULL,0),(2437,21,'2026-11-12',2,0,0,NULL,0),(2438,21,'2026-11-13',2,0,0,NULL,0),(2439,21,'2026-11-14',2,0,0,NULL,0),(2440,21,'2026-11-15',2,0,0,NULL,0),(2441,21,'2026-11-16',2,0,0,NULL,0),(2442,21,'2026-11-17',2,0,0,NULL,0),(2443,21,'2026-11-18',2,0,0,NULL,0),(2444,21,'2026-11-19',2,0,0,NULL,0),(2445,21,'2026-11-20',2,0,0,NULL,0),(2446,21,'2026-11-21',2,0,0,NULL,0),(2447,21,'2026-11-22',2,0,0,NULL,0),(2448,21,'2026-11-23',2,0,0,NULL,0),(2449,21,'2026-11-24',2,0,0,NULL,0),(2450,21,'2026-11-25',2,0,0,NULL,0),(2451,21,'2026-11-26',2,0,0,NULL,0),(2452,21,'2026-11-27',2,0,0,NULL,0),(2453,21,'2026-11-28',2,0,0,NULL,0),(2454,21,'2026-11-29',2,0,0,NULL,0),(2455,21,'2026-11-30',2,0,0,NULL,0),(2456,21,'2026-12-01',2,0,0,NULL,0),(2457,21,'2026-12-02',2,0,0,NULL,0),(2458,21,'2026-12-03',2,0,0,NULL,0),(2459,21,'2026-12-04',2,0,0,NULL,0),(2460,21,'2026-12-05',2,0,0,NULL,0),(2461,21,'2026-12-06',2,0,0,NULL,0),(2462,21,'2026-12-07',2,0,0,NULL,0),(2463,21,'2026-12-08',2,0,0,NULL,0),(2464,21,'2026-12-09',2,0,0,NULL,0),(2465,21,'2026-12-10',2,0,0,NULL,0),(2466,21,'2026-12-11',2,0,0,NULL,0),(2467,21,'2026-12-12',2,0,0,NULL,0),(2468,21,'2026-12-13',2,0,0,NULL,0),(2469,21,'2026-12-14',2,0,0,NULL,0),(2470,21,'2026-12-15',2,0,0,NULL,0),(2471,21,'2026-12-16',2,0,0,NULL,0),(2472,21,'2026-12-17',2,0,0,NULL,0),(2473,21,'2026-12-18',2,0,0,NULL,0),(2474,21,'2026-12-19',2,0,0,NULL,0),(2475,21,'2026-12-20',2,0,0,NULL,0),(2476,21,'2026-12-21',2,0,0,NULL,0),(2477,21,'2026-12-22',2,0,0,NULL,0),(2478,21,'2026-12-23',2,0,0,NULL,0),(2479,21,'2026-12-24',2,0,0,NULL,0),(2480,21,'2026-12-25',2,0,0,NULL,0),(2481,21,'2026-12-26',2,0,0,NULL,0),(2482,21,'2026-12-27',2,0,0,NULL,0),(2483,21,'2026-12-28',2,0,0,NULL,0),(2484,21,'2026-12-29',2,0,0,NULL,0),(2485,21,'2026-12-30',2,0,0,NULL,0),(2486,21,'2026-12-31',2,0,0,NULL,0),(2487,21,'2027-01-01',2,0,0,NULL,0),(2488,21,'2027-01-02',2,0,0,NULL,0),(2489,21,'2027-01-03',2,0,0,NULL,0),(2490,21,'2027-01-04',2,0,0,NULL,0),(2491,21,'2027-01-05',2,0,0,NULL,0),(2492,21,'2027-01-06',2,0,0,NULL,0),(2493,21,'2027-01-07',2,0,0,NULL,0),(2494,21,'2027-01-08',2,0,0,NULL,0),(2495,21,'2027-01-09',2,0,0,NULL,0),(2496,21,'2027-01-10',2,0,0,NULL,0),(2497,21,'2027-01-11',2,0,0,NULL,0),(2498,21,'2027-01-12',2,0,0,NULL,0),(2499,21,'2027-01-13',2,0,0,NULL,0),(2500,21,'2027-01-14',2,0,0,NULL,0),(2501,21,'2027-01-15',2,0,0,NULL,0),(2502,21,'2027-01-16',2,0,0,NULL,0),(2503,21,'2027-01-17',2,0,0,NULL,0),(2504,21,'2027-01-18',2,0,0,NULL,0),(2505,21,'2027-01-19',2,0,0,NULL,0),(2506,21,'2027-01-20',2,0,0,NULL,0),(2507,21,'2027-01-21',2,0,0,NULL,0),(2508,21,'2027-01-22',2,0,0,NULL,0),(2509,21,'2027-01-23',2,0,0,NULL,0),(2510,21,'2027-01-24',2,0,0,NULL,0),(2511,21,'2027-01-25',2,0,0,NULL,0),(2512,21,'2027-01-26',2,0,0,NULL,0),(2513,21,'2027-01-27',2,0,0,NULL,0),(2514,21,'2027-01-28',2,0,0,NULL,0),(2515,21,'2027-01-29',2,0,0,NULL,0),(2516,21,'2027-01-30',2,0,0,NULL,0),(2517,21,'2027-01-31',2,0,0,NULL,0),(2518,21,'2027-02-01',2,0,0,NULL,0),(2519,21,'2027-02-02',2,0,0,NULL,0),(2520,21,'2027-02-03',2,0,0,NULL,0),(2521,22,'2026-10-07',5,0,0,NULL,0),(2522,22,'2026-10-08',5,0,0,NULL,0),(2523,22,'2026-10-09',5,0,0,NULL,0),(2524,22,'2026-10-10',5,0,0,NULL,0),(2525,22,'2026-10-11',5,0,0,NULL,0),(2526,22,'2026-10-12',5,0,0,NULL,0),(2527,22,'2026-10-13',5,0,0,NULL,0),(2528,22,'2026-10-14',5,0,0,NULL,0),(2529,22,'2026-10-15',5,0,0,NULL,0),(2530,22,'2026-10-16',5,1,0,NULL,0),(2531,22,'2026-10-17',5,1,0,NULL,0),(2532,22,'2026-10-18',5,0,0,NULL,0),(2533,22,'2026-10-19',5,0,0,NULL,0),(2534,22,'2026-10-20',5,0,0,NULL,0),(2535,22,'2026-10-21',5,0,0,NULL,0),(2536,22,'2026-10-22',5,0,0,NULL,0),(2537,22,'2026-10-23',5,0,0,NULL,0),(2538,22,'2026-10-24',5,0,0,NULL,0),(2539,22,'2026-10-25',5,0,0,NULL,0),(2540,22,'2026-10-26',5,0,0,NULL,0),(2541,22,'2026-10-27',5,0,0,NULL,0),(2542,22,'2026-10-28',5,0,0,NULL,0),(2543,22,'2026-10-29',5,0,0,NULL,0),(2544,22,'2026-10-30',5,0,0,NULL,0),(2545,22,'2026-10-31',5,0,0,NULL,0),(2546,22,'2026-11-01',5,0,0,NULL,0),(2547,22,'2026-11-02',5,0,0,NULL,0),(2548,22,'2026-11-03',5,0,0,NULL,0),(2549,22,'2026-11-04',5,0,0,NULL,0),(2550,22,'2026-11-05',5,0,0,NULL,0),(2551,22,'2026-11-06',5,0,0,NULL,0),(2552,22,'2026-11-07',5,0,0,NULL,0),(2553,22,'2026-11-08',5,0,0,NULL,0),(2554,22,'2026-11-09',5,0,0,NULL,0),(2555,22,'2026-11-10',5,1,0,NULL,0),(2556,22,'2026-11-11',5,1,0,NULL,0),(2557,22,'2026-11-12',5,0,0,NULL,0),(2558,22,'2026-11-13',5,0,0,NULL,0),(2559,22,'2026-11-14',5,0,0,NULL,0),(2560,22,'2026-11-15',5,0,0,NULL,0),(2561,22,'2026-11-16',5,0,0,NULL,0),(2562,22,'2026-11-17',5,0,0,NULL,0),(2563,22,'2026-11-18',5,0,0,NULL,0),(2564,22,'2026-11-19',5,0,0,NULL,0),(2565,22,'2026-11-20',5,0,0,NULL,0),(2566,22,'2026-11-21',5,0,0,NULL,0),(2567,22,'2026-11-22',5,0,0,NULL,0),(2568,22,'2026-11-23',5,0,0,NULL,0),(2569,22,'2026-11-24',5,0,0,NULL,0),(2570,22,'2026-11-25',5,0,0,NULL,0),(2571,22,'2026-11-26',5,0,0,NULL,0),(2572,22,'2026-11-27',5,0,0,NULL,0),(2573,22,'2026-11-28',5,0,0,NULL,0),(2574,22,'2026-11-29',5,0,0,NULL,0),(2575,22,'2026-11-30',5,0,0,NULL,0),(2576,22,'2026-12-01',5,0,0,NULL,0),(2577,22,'2026-12-02',5,0,0,NULL,0),(2578,22,'2026-12-03',5,0,0,NULL,0),(2579,22,'2026-12-04',5,0,0,NULL,0),(2580,22,'2026-12-05',5,0,0,NULL,0),(2581,22,'2026-12-06',5,0,0,NULL,0),(2582,22,'2026-12-07',5,0,0,NULL,0),(2583,22,'2026-12-08',5,0,0,NULL,0),(2584,22,'2026-12-09',5,0,0,NULL,0),(2585,22,'2026-12-10',5,0,0,NULL,0),(2586,22,'2026-12-11',5,0,0,NULL,0),(2587,22,'2026-12-12',5,0,0,NULL,0),(2588,22,'2026-12-13',5,0,0,NULL,0),(2589,22,'2026-12-14',5,0,0,NULL,0),(2590,22,'2026-12-15',5,0,0,NULL,0),(2591,22,'2026-12-16',5,0,0,NULL,0),(2592,22,'2026-12-17',5,0,0,NULL,0),(2593,22,'2026-12-18',5,0,0,NULL,0),(2594,22,'2026-12-19',5,0,0,NULL,0),(2595,22,'2026-12-20',5,0,0,NULL,0),(2596,22,'2026-12-21',5,0,0,NULL,0),(2597,22,'2026-12-22',5,0,0,NULL,0),(2598,22,'2026-12-23',5,0,0,NULL,0),(2599,22,'2026-12-24',5,0,0,NULL,0),(2600,22,'2026-12-25',5,0,0,NULL,0),(2601,22,'2026-12-26',5,0,0,NULL,0),(2602,22,'2026-12-27',5,0,0,NULL,0),(2603,22,'2026-12-28',5,0,0,NULL,0),(2604,22,'2026-12-29',5,0,0,NULL,0),(2605,22,'2026-12-30',5,0,0,NULL,0),(2606,22,'2026-12-31',5,0,0,NULL,0),(2607,22,'2027-01-01',5,0,0,NULL,0),(2608,22,'2027-01-02',5,0,0,NULL,0),(2609,22,'2027-01-03',5,0,0,NULL,0),(2610,22,'2027-01-04',5,0,0,NULL,0),(2611,22,'2027-01-05',5,0,0,NULL,0),(2612,22,'2027-01-06',5,0,0,NULL,0),(2613,22,'2027-01-07',5,0,0,NULL,0),(2614,22,'2027-01-08',5,0,0,NULL,0),(2615,22,'2027-01-09',5,0,0,NULL,0),(2616,22,'2027-01-10',5,0,0,NULL,0),(2617,22,'2027-01-11',5,0,0,NULL,0),(2618,22,'2027-01-12',5,0,0,NULL,0),(2619,22,'2027-01-13',5,0,0,NULL,0),(2620,22,'2027-01-14',5,0,0,NULL,0),(2621,22,'2027-01-15',5,0,0,NULL,0),(2622,22,'2027-01-16',5,0,0,NULL,0),(2623,22,'2027-01-17',5,0,0,NULL,0),(2624,22,'2027-01-18',5,0,0,NULL,0),(2625,22,'2027-01-19',5,0,0,NULL,0),(2626,22,'2027-01-20',5,0,0,NULL,0),(2627,22,'2027-01-21',5,0,0,NULL,0),(2628,22,'2027-01-22',5,0,0,NULL,0),(2629,22,'2027-01-23',5,0,0,NULL,0),(2630,22,'2027-01-24',5,0,0,NULL,0),(2631,22,'2027-01-25',5,0,0,NULL,0),(2632,22,'2027-01-26',5,0,0,NULL,0),(2633,22,'2027-01-27',5,0,0,NULL,0),(2634,22,'2027-01-28',5,0,0,NULL,0),(2635,22,'2027-01-29',5,0,0,NULL,0),(2636,22,'2027-01-30',5,0,0,NULL,0),(2637,22,'2027-01-31',5,0,0,NULL,0),(2638,22,'2027-02-01',5,0,0,NULL,0),(2639,22,'2027-02-02',5,0,0,NULL,0),(2640,22,'2027-02-03',5,0,0,NULL,0),(2641,23,'2026-10-07',3,0,0,NULL,0),(2642,23,'2026-10-08',3,0,0,NULL,0),(2643,23,'2026-10-09',3,0,0,NULL,0),(2644,23,'2026-10-10',3,0,0,NULL,0),(2645,23,'2026-10-11',3,0,0,NULL,0),(2646,23,'2026-10-12',3,0,0,NULL,0),(2647,23,'2026-10-13',3,0,0,NULL,0),(2648,23,'2026-10-14',3,0,0,NULL,0),(2649,23,'2026-10-15',3,0,0,NULL,0),(2650,23,'2026-10-16',3,0,0,NULL,0),(2651,23,'2026-10-17',3,0,0,NULL,0),(2652,23,'2026-10-18',3,0,0,NULL,0),(2653,23,'2026-10-19',3,0,0,NULL,0),(2654,23,'2026-10-20',3,0,0,NULL,0),(2655,23,'2026-10-21',3,0,0,NULL,0),(2656,23,'2026-10-22',3,0,0,NULL,0),(2657,23,'2026-10-23',3,0,0,NULL,0),(2658,23,'2026-10-24',3,0,0,NULL,0),(2659,23,'2026-10-25',3,0,0,NULL,0),(2660,23,'2026-10-26',3,0,0,NULL,0),(2661,23,'2026-10-27',3,0,0,NULL,0),(2662,23,'2026-10-28',3,0,0,NULL,0),(2663,23,'2026-10-29',3,0,0,NULL,0),(2664,23,'2026-10-30',3,0,0,NULL,0),(2665,23,'2026-10-31',3,0,0,NULL,0),(2666,23,'2026-11-01',3,0,0,NULL,0),(2667,23,'2026-11-02',3,0,0,NULL,0),(2668,23,'2026-11-03',3,0,0,NULL,0),(2669,23,'2026-11-04',3,0,0,NULL,0),(2670,23,'2026-11-05',3,0,0,NULL,0),(2671,23,'2026-11-06',3,0,0,NULL,0),(2672,23,'2026-11-07',3,0,0,NULL,0),(2673,23,'2026-11-08',3,0,0,NULL,0),(2674,23,'2026-11-09',3,0,0,NULL,0),(2675,23,'2026-11-10',3,0,0,NULL,0),(2676,23,'2026-11-11',3,0,0,NULL,0),(2677,23,'2026-11-12',3,0,0,NULL,0),(2678,23,'2026-11-13',3,0,0,NULL,0),(2679,23,'2026-11-14',3,0,0,NULL,0),(2680,23,'2026-11-15',3,0,0,NULL,0),(2681,23,'2026-11-16',3,0,0,NULL,0),(2682,23,'2026-11-17',3,0,0,NULL,0),(2683,23,'2026-11-18',3,0,0,NULL,0),(2684,23,'2026-11-19',3,0,0,NULL,0),(2685,23,'2026-11-20',3,0,0,NULL,0),(2686,23,'2026-11-21',3,0,0,NULL,0),(2687,23,'2026-11-22',3,0,0,NULL,0),(2688,23,'2026-11-23',3,0,0,NULL,0),(2689,23,'2026-11-24',3,0,0,NULL,0),(2690,23,'2026-11-25',3,0,0,NULL,0),(2691,23,'2026-11-26',3,0,0,NULL,0),(2692,23,'2026-11-27',3,0,0,NULL,0),(2693,23,'2026-11-28',3,0,0,NULL,0),(2694,23,'2026-11-29',3,0,0,NULL,0),(2695,23,'2026-11-30',3,0,0,NULL,0),(2696,23,'2026-12-01',3,0,0,NULL,0),(2697,23,'2026-12-02',3,0,0,NULL,0),(2698,23,'2026-12-03',3,0,0,NULL,0),(2699,23,'2026-12-04',3,0,0,NULL,0),(2700,23,'2026-12-05',3,0,0,NULL,0),(2701,23,'2026-12-06',3,0,0,NULL,0),(2702,23,'2026-12-07',3,0,0,NULL,0),(2703,23,'2026-12-08',3,0,0,NULL,0),(2704,23,'2026-12-09',3,0,0,NULL,0),(2705,23,'2026-12-10',3,0,0,NULL,0),(2706,23,'2026-12-11',3,0,0,NULL,0),(2707,23,'2026-12-12',3,0,0,NULL,0),(2708,23,'2026-12-13',3,0,0,NULL,0),(2709,23,'2026-12-14',3,0,0,NULL,0),(2710,23,'2026-12-15',3,0,0,NULL,0),(2711,23,'2026-12-16',3,0,0,NULL,0),(2712,23,'2026-12-17',3,0,0,NULL,0),(2713,23,'2026-12-18',3,0,0,NULL,0),(2714,23,'2026-12-19',3,0,0,NULL,0),(2715,23,'2026-12-20',3,0,0,NULL,0),(2716,23,'2026-12-21',3,0,0,NULL,0),(2717,23,'2026-12-22',3,0,0,NULL,0),(2718,23,'2026-12-23',3,0,0,NULL,0),(2719,23,'2026-12-24',3,0,0,NULL,0),(2720,23,'2026-12-25',3,0,0,NULL,0),(2721,23,'2026-12-26',3,0,0,NULL,0),(2722,23,'2026-12-27',3,0,0,NULL,0),(2723,23,'2026-12-28',3,0,0,NULL,0),(2724,23,'2026-12-29',3,0,0,NULL,0),(2725,23,'2026-12-30',3,0,0,NULL,0),(2726,23,'2026-12-31',3,0,0,NULL,0),(2727,23,'2027-01-01',3,0,0,NULL,0),(2728,23,'2027-01-02',3,0,0,NULL,0),(2729,23,'2027-01-03',3,0,0,NULL,0),(2730,23,'2027-01-04',3,0,0,NULL,0),(2731,23,'2027-01-05',3,0,0,NULL,0),(2732,23,'2027-01-06',3,0,0,NULL,0),(2733,23,'2027-01-07',3,0,0,NULL,0),(2734,23,'2027-01-08',3,0,0,NULL,0),(2735,23,'2027-01-09',3,0,0,NULL,0),(2736,23,'2027-01-10',3,0,0,NULL,0),(2737,23,'2027-01-11',3,0,0,NULL,0),(2738,23,'2027-01-12',3,0,0,NULL,0),(2739,23,'2027-01-13',3,0,0,NULL,0),(2740,23,'2027-01-14',3,0,0,NULL,0),(2741,23,'2027-01-15',3,0,0,NULL,0),(2742,23,'2027-01-16',3,0,0,NULL,0),(2743,23,'2027-01-17',3,0,0,NULL,0),(2744,23,'2027-01-18',3,0,0,NULL,0),(2745,23,'2027-01-19',3,0,0,NULL,0),(2746,23,'2027-01-20',3,0,0,NULL,0),(2747,23,'2027-01-21',3,0,0,NULL,0),(2748,23,'2027-01-22',3,0,0,NULL,0),(2749,23,'2027-01-23',3,0,0,NULL,0),(2750,23,'2027-01-24',3,0,0,NULL,0),(2751,23,'2027-01-25',3,0,0,NULL,0),(2752,23,'2027-01-26',3,0,0,NULL,0),(2753,23,'2027-01-27',3,0,0,NULL,0),(2754,23,'2027-01-28',3,0,0,NULL,0),(2755,23,'2027-01-29',3,0,0,NULL,0),(2756,23,'2027-01-30',3,0,0,NULL,0),(2757,23,'2027-01-31',3,0,0,NULL,0),(2758,23,'2027-02-01',3,0,0,NULL,0),(2759,23,'2027-02-02',3,0,0,NULL,0),(2760,23,'2027-02-03',3,0,0,NULL,0),(2761,24,'2026-10-07',6,0,0,NULL,0),(2762,24,'2026-10-08',6,0,0,NULL,0),(2763,24,'2026-10-09',6,0,0,NULL,0),(2764,24,'2026-10-10',6,0,0,NULL,0),(2765,24,'2026-10-11',6,0,0,NULL,0),(2766,24,'2026-10-12',6,0,0,NULL,0),(2767,24,'2026-10-13',6,0,0,NULL,0),(2768,24,'2026-10-14',6,0,0,NULL,0),(2769,24,'2026-10-15',6,0,0,NULL,0),(2770,24,'2026-10-16',6,0,0,NULL,0),(2771,24,'2026-10-17',6,0,0,NULL,0),(2772,24,'2026-10-18',6,0,0,NULL,0),(2773,24,'2026-10-19',6,0,0,NULL,0),(2774,24,'2026-10-20',6,0,0,NULL,0),(2775,24,'2026-10-21',6,0,0,NULL,0),(2776,24,'2026-10-22',6,0,0,NULL,0),(2777,24,'2026-10-23',6,0,0,NULL,0),(2778,24,'2026-10-24',6,0,0,NULL,0),(2779,24,'2026-10-25',6,0,0,NULL,0),(2780,24,'2026-10-26',6,0,0,NULL,0),(2781,24,'2026-10-27',6,0,0,NULL,0),(2782,24,'2026-10-28',6,0,0,NULL,0),(2783,24,'2026-10-29',6,0,0,NULL,0),(2784,24,'2026-10-30',6,0,0,NULL,0),(2785,24,'2026-10-31',6,0,0,NULL,0),(2786,24,'2026-11-01',6,0,0,NULL,0),(2787,24,'2026-11-02',6,0,0,NULL,0),(2788,24,'2026-11-03',6,0,0,NULL,0),(2789,24,'2026-11-04',6,0,0,NULL,0),(2790,24,'2026-11-05',6,0,0,NULL,0),(2791,24,'2026-11-06',6,0,0,NULL,0),(2792,24,'2026-11-07',6,0,0,NULL,0),(2793,24,'2026-11-08',6,0,0,NULL,0),(2794,24,'2026-11-09',6,0,0,NULL,0),(2795,24,'2026-11-10',6,0,0,NULL,0),(2796,24,'2026-11-11',6,0,0,NULL,0),(2797,24,'2026-11-12',6,0,0,NULL,0),(2798,24,'2026-11-13',6,0,0,NULL,0),(2799,24,'2026-11-14',6,0,0,NULL,0),(2800,24,'2026-11-15',6,0,0,NULL,0),(2801,24,'2026-11-16',6,0,0,NULL,0),(2802,24,'2026-11-17',6,0,0,NULL,0),(2803,24,'2026-11-18',6,0,0,NULL,0),(2804,24,'2026-11-19',6,0,0,NULL,0),(2805,24,'2026-11-20',6,0,0,NULL,0),(2806,24,'2026-11-21',6,0,0,NULL,0),(2807,24,'2026-11-22',6,0,0,NULL,0),(2808,24,'2026-11-23',6,0,0,NULL,0),(2809,24,'2026-11-24',6,0,0,NULL,0),(2810,24,'2026-11-25',6,0,0,NULL,0),(2811,24,'2026-11-26',6,0,0,NULL,0),(2812,24,'2026-11-27',6,0,0,NULL,0),(2813,24,'2026-11-28',6,0,0,NULL,0),(2814,24,'2026-11-29',6,0,0,NULL,0),(2815,24,'2026-11-30',6,0,0,NULL,0),(2816,24,'2026-12-01',6,0,0,NULL,0),(2817,24,'2026-12-02',6,0,0,NULL,0),(2818,24,'2026-12-03',6,0,0,NULL,0),(2819,24,'2026-12-04',6,0,0,NULL,0),(2820,24,'2026-12-05',6,0,0,NULL,0),(2821,24,'2026-12-06',6,0,0,NULL,0),(2822,24,'2026-12-07',6,0,0,NULL,0),(2823,24,'2026-12-08',6,0,0,NULL,0),(2824,24,'2026-12-09',6,0,0,NULL,0),(2825,24,'2026-12-10',6,0,0,NULL,0),(2826,24,'2026-12-11',6,0,0,NULL,0),(2827,24,'2026-12-12',6,0,0,NULL,0),(2828,24,'2026-12-13',6,0,0,NULL,0),(2829,24,'2026-12-14',6,0,0,NULL,0),(2830,24,'2026-12-15',6,0,0,NULL,0),(2831,24,'2026-12-16',6,0,0,NULL,0),(2832,24,'2026-12-17',6,0,0,NULL,0),(2833,24,'2026-12-18',6,0,0,NULL,0),(2834,24,'2026-12-19',6,0,0,NULL,0),(2835,24,'2026-12-20',6,0,0,NULL,0),(2836,24,'2026-12-21',6,0,0,NULL,0),(2837,24,'2026-12-22',6,0,0,NULL,0),(2838,24,'2026-12-23',6,0,0,NULL,0),(2839,24,'2026-12-24',6,0,0,NULL,0),(2840,24,'2026-12-25',6,0,0,NULL,0),(2841,24,'2026-12-26',6,0,0,NULL,0),(2842,24,'2026-12-27',6,0,0,NULL,0),(2843,24,'2026-12-28',6,0,0,NULL,0),(2844,24,'2026-12-29',6,0,0,NULL,0),(2845,24,'2026-12-30',6,0,0,NULL,0),(2846,24,'2026-12-31',6,0,0,NULL,0),(2847,24,'2027-01-01',6,0,0,NULL,0),(2848,24,'2027-01-02',6,0,0,NULL,0),(2849,24,'2027-01-03',6,0,0,NULL,0),(2850,24,'2027-01-04',6,0,0,NULL,0),(2851,24,'2027-01-05',6,0,0,NULL,0),(2852,24,'2027-01-06',6,0,0,NULL,0),(2853,24,'2027-01-07',6,0,0,NULL,0),(2854,24,'2027-01-08',6,0,0,NULL,0),(2855,24,'2027-01-09',6,0,0,NULL,0),(2856,24,'2027-01-10',6,0,0,NULL,0),(2857,24,'2027-01-11',6,0,0,NULL,0),(2858,24,'2027-01-12',6,0,0,NULL,0),(2859,24,'2027-01-13',6,0,0,NULL,0),(2860,24,'2027-01-14',6,0,0,NULL,0),(2861,24,'2027-01-15',6,0,0,NULL,0),(2862,24,'2027-01-16',6,0,0,NULL,0),(2863,24,'2027-01-17',6,0,0,NULL,0),(2864,24,'2027-01-18',6,0,0,NULL,0),(2865,24,'2027-01-19',6,0,0,NULL,0),(2866,24,'2027-01-20',6,0,0,NULL,0),(2867,24,'2027-01-21',6,0,0,NULL,0),(2868,24,'2027-01-22',6,0,0,NULL,0),(2869,24,'2027-01-23',6,0,0,NULL,0),(2870,24,'2027-01-24',6,0,0,NULL,0),(2871,24,'2027-01-25',6,0,0,NULL,0),(2872,24,'2027-01-26',6,0,0,NULL,0),(2873,24,'2027-01-27',6,0,0,NULL,0),(2874,24,'2027-01-28',6,0,0,NULL,0),(2875,24,'2027-01-29',6,0,0,NULL,0),(2876,24,'2027-01-30',6,0,0,NULL,0),(2877,24,'2027-01-31',6,0,0,NULL,0),(2878,24,'2027-02-01',6,0,0,NULL,0),(2879,24,'2027-02-02',6,0,0,NULL,0),(2880,24,'2027-02-03',6,0,0,NULL,0),(2881,25,'2026-10-07',3,0,0,NULL,0),(2882,25,'2026-10-08',3,0,0,NULL,0),(2883,25,'2026-10-09',3,0,0,NULL,0),(2884,25,'2026-10-10',3,0,0,NULL,0),(2885,25,'2026-10-11',3,0,0,NULL,0),(2886,25,'2026-10-12',3,0,0,NULL,0),(2887,25,'2026-10-13',3,0,0,NULL,0),(2888,25,'2026-10-14',3,0,0,NULL,0),(2889,25,'2026-10-15',3,0,0,NULL,0),(2890,25,'2026-10-16',3,0,0,NULL,0),(2891,25,'2026-10-17',3,0,0,NULL,0),(2892,25,'2026-10-18',3,0,0,NULL,0),(2893,25,'2026-10-19',3,0,0,NULL,0),(2894,25,'2026-10-20',3,0,0,NULL,0),(2895,25,'2026-10-21',3,0,0,NULL,0),(2896,25,'2026-10-22',3,0,0,NULL,0),(2897,25,'2026-10-23',3,0,0,NULL,0),(2898,25,'2026-10-24',3,0,0,NULL,0),(2899,25,'2026-10-25',3,0,0,NULL,0),(2900,25,'2026-10-26',3,0,0,NULL,0),(2901,25,'2026-10-27',3,0,0,NULL,0),(2902,25,'2026-10-28',3,0,0,NULL,0),(2903,25,'2026-10-29',3,0,0,NULL,0),(2904,25,'2026-10-30',3,0,0,NULL,0),(2905,25,'2026-10-31',3,0,0,NULL,0),(2906,25,'2026-11-01',3,0,0,NULL,0),(2907,25,'2026-11-02',3,0,0,NULL,0),(2908,25,'2026-11-03',3,0,0,NULL,0),(2909,25,'2026-11-04',3,0,0,NULL,0),(2910,25,'2026-11-05',3,0,0,NULL,0),(2911,25,'2026-11-06',3,0,0,NULL,0),(2912,25,'2026-11-07',3,0,0,NULL,0),(2913,25,'2026-11-08',3,0,0,NULL,0),(2914,25,'2026-11-09',3,0,0,NULL,0),(2915,25,'2026-11-10',3,0,0,NULL,0),(2916,25,'2026-11-11',3,0,0,NULL,0),(2917,25,'2026-11-12',3,0,0,NULL,0),(2918,25,'2026-11-13',3,0,0,NULL,0),(2919,25,'2026-11-14',3,0,0,NULL,0),(2920,25,'2026-11-15',3,0,0,NULL,0),(2921,25,'2026-11-16',3,0,0,NULL,0),(2922,25,'2026-11-17',3,0,0,NULL,0),(2923,25,'2026-11-18',3,0,0,NULL,0),(2924,25,'2026-11-19',3,0,0,NULL,0),(2925,25,'2026-11-20',3,0,0,NULL,0),(2926,25,'2026-11-21',3,0,0,NULL,0),(2927,25,'2026-11-22',3,0,0,NULL,0),(2928,25,'2026-11-23',3,0,0,NULL,0),(2929,25,'2026-11-24',3,0,0,NULL,0),(2930,25,'2026-11-25',3,0,0,NULL,0),(2931,25,'2026-11-26',3,0,0,NULL,0),(2932,25,'2026-11-27',3,0,0,NULL,0),(2933,25,'2026-11-28',3,0,0,NULL,0),(2934,25,'2026-11-29',3,0,0,NULL,0),(2935,25,'2026-11-30',3,0,0,NULL,0),(2936,25,'2026-12-01',3,0,0,NULL,0),(2937,25,'2026-12-02',3,0,0,NULL,0),(2938,25,'2026-12-03',3,0,0,NULL,0),(2939,25,'2026-12-04',3,0,0,NULL,0),(2940,25,'2026-12-05',3,0,0,NULL,0),(2941,25,'2026-12-06',3,0,0,NULL,0),(2942,25,'2026-12-07',3,0,0,NULL,0),(2943,25,'2026-12-08',3,0,0,NULL,0),(2944,25,'2026-12-09',3,0,0,NULL,0),(2945,25,'2026-12-10',3,0,0,NULL,0),(2946,25,'2026-12-11',3,0,0,NULL,0),(2947,25,'2026-12-12',3,0,0,NULL,0),(2948,25,'2026-12-13',3,0,0,NULL,0),(2949,25,'2026-12-14',3,0,0,NULL,0),(2950,25,'2026-12-15',3,0,0,NULL,0),(2951,25,'2026-12-16',3,0,0,NULL,0),(2952,25,'2026-12-17',3,0,0,NULL,0),(2953,25,'2026-12-18',3,0,0,NULL,0),(2954,25,'2026-12-19',3,0,0,NULL,0),(2955,25,'2026-12-20',3,0,0,NULL,0),(2956,25,'2026-12-21',3,0,0,NULL,0),(2957,25,'2026-12-22',3,0,0,NULL,0),(2958,25,'2026-12-23',3,0,0,NULL,0),(2959,25,'2026-12-24',3,0,0,NULL,0),(2960,25,'2026-12-25',3,0,0,NULL,0),(2961,25,'2026-12-26',3,0,0,NULL,0),(2962,25,'2026-12-27',3,0,0,NULL,0),(2963,25,'2026-12-28',3,0,0,NULL,0),(2964,25,'2026-12-29',3,0,0,NULL,0),(2965,25,'2026-12-30',3,0,0,NULL,0),(2966,25,'2026-12-31',3,0,0,NULL,0),(2967,25,'2027-01-01',3,0,0,NULL,0),(2968,25,'2027-01-02',3,0,0,NULL,0),(2969,25,'2027-01-03',3,0,0,NULL,0),(2970,25,'2027-01-04',3,0,0,NULL,0),(2971,25,'2027-01-05',3,0,0,NULL,0),(2972,25,'2027-01-06',3,0,0,NULL,0),(2973,25,'2027-01-07',3,0,0,NULL,0),(2974,25,'2027-01-08',3,0,0,NULL,0),(2975,25,'2027-01-09',3,0,0,NULL,0),(2976,25,'2027-01-10',3,0,0,NULL,0),(2977,25,'2027-01-11',3,0,0,NULL,0),(2978,25,'2027-01-12',3,0,0,NULL,0),(2979,25,'2027-01-13',3,0,0,NULL,0),(2980,25,'2027-01-14',3,0,0,NULL,0),(2981,25,'2027-01-15',3,0,0,NULL,0),(2982,25,'2027-01-16',3,0,0,NULL,0),(2983,25,'2027-01-17',3,0,0,NULL,0),(2984,25,'2027-01-18',3,0,0,NULL,0),(2985,25,'2027-01-19',3,0,0,NULL,0),(2986,25,'2027-01-20',3,0,0,NULL,0),(2987,25,'2027-01-21',3,0,0,NULL,0),(2988,25,'2027-01-22',3,0,0,NULL,0),(2989,25,'2027-01-23',3,0,0,NULL,0),(2990,25,'2027-01-24',3,0,0,NULL,0),(2991,25,'2027-01-25',3,0,0,NULL,0),(2992,25,'2027-01-26',3,0,0,NULL,0),(2993,25,'2027-01-27',3,0,0,NULL,0),(2994,25,'2027-01-28',3,0,0,NULL,0),(2995,25,'2027-01-29',3,0,0,NULL,0),(2996,25,'2027-01-30',3,0,0,NULL,0),(2997,25,'2027-01-31',3,0,0,NULL,0),(2998,25,'2027-02-01',3,0,0,NULL,0),(2999,25,'2027-02-02',3,0,0,NULL,0),(3000,25,'2027-02-03',3,0,0,NULL,0),(3001,26,'2026-10-07',10,0,0,NULL,0),(3002,26,'2026-10-08',10,0,0,NULL,0),(3003,26,'2026-10-09',10,0,0,NULL,0),(3004,26,'2026-10-10',10,0,0,NULL,0),(3005,26,'2026-10-11',10,0,0,NULL,0),(3006,26,'2026-10-12',10,0,0,NULL,0),(3007,26,'2026-10-13',10,0,0,NULL,0),(3008,26,'2026-10-14',10,0,0,NULL,0),(3009,26,'2026-10-15',10,0,0,NULL,0),(3010,26,'2026-10-16',10,0,0,NULL,0),(3011,26,'2026-10-17',10,0,0,NULL,0),(3012,26,'2026-10-18',10,0,0,NULL,0),(3013,26,'2026-10-19',10,0,0,NULL,0),(3014,26,'2026-10-20',10,0,0,NULL,0),(3015,26,'2026-10-21',10,0,0,NULL,0),(3016,26,'2026-10-22',10,0,0,NULL,0),(3017,26,'2026-10-23',10,0,0,NULL,0),(3018,26,'2026-10-24',10,0,0,NULL,0),(3019,26,'2026-10-25',10,0,0,NULL,0),(3020,26,'2026-10-26',10,0,0,NULL,0),(3021,26,'2026-10-27',10,0,0,NULL,0),(3022,26,'2026-10-28',10,0,0,NULL,0),(3023,26,'2026-10-29',10,0,0,NULL,0),(3024,26,'2026-10-30',10,0,0,NULL,0),(3025,26,'2026-10-31',10,0,0,NULL,0),(3026,26,'2026-11-01',10,0,0,NULL,0),(3027,26,'2026-11-02',10,0,0,NULL,0),(3028,26,'2026-11-03',10,0,0,NULL,0),(3029,26,'2026-11-04',10,0,0,NULL,0),(3030,26,'2026-11-05',10,0,0,NULL,0),(3031,26,'2026-11-06',10,0,0,NULL,0),(3032,26,'2026-11-07',10,0,0,NULL,0),(3033,26,'2026-11-08',10,0,0,NULL,0),(3034,26,'2026-11-09',10,0,0,NULL,0),(3035,26,'2026-11-10',10,0,0,NULL,0),(3036,26,'2026-11-11',10,0,0,NULL,0),(3037,26,'2026-11-12',10,0,0,NULL,0),(3038,26,'2026-11-13',10,0,0,NULL,0),(3039,26,'2026-11-14',10,0,0,NULL,0),(3040,26,'2026-11-15',10,0,0,NULL,0),(3041,26,'2026-11-16',10,0,0,NULL,0),(3042,26,'2026-11-17',10,0,0,NULL,0),(3043,26,'2026-11-18',10,0,0,NULL,0),(3044,26,'2026-11-19',10,0,0,NULL,0),(3045,26,'2026-11-20',10,0,0,NULL,0),(3046,26,'2026-11-21',10,0,0,NULL,0),(3047,26,'2026-11-22',10,0,0,NULL,0),(3048,26,'2026-11-23',10,0,0,NULL,0),(3049,26,'2026-11-24',10,0,0,NULL,0),(3050,26,'2026-11-25',10,0,0,NULL,0),(3051,26,'2026-11-26',10,0,0,NULL,0),(3052,26,'2026-11-27',10,0,0,NULL,0),(3053,26,'2026-11-28',10,0,0,NULL,0),(3054,26,'2026-11-29',10,0,0,NULL,0),(3055,26,'2026-11-30',10,0,0,NULL,0),(3056,26,'2026-12-01',10,0,0,NULL,0),(3057,26,'2026-12-02',10,0,0,NULL,0),(3058,26,'2026-12-03',10,0,0,NULL,0),(3059,26,'2026-12-04',10,0,0,NULL,0),(3060,26,'2026-12-05',10,0,0,NULL,0),(3061,26,'2026-12-06',10,0,0,NULL,0),(3062,26,'2026-12-07',10,0,0,NULL,0),(3063,26,'2026-12-08',10,0,0,NULL,0),(3064,26,'2026-12-09',10,0,0,NULL,0),(3065,26,'2026-12-10',10,0,0,NULL,0),(3066,26,'2026-12-11',10,0,0,NULL,0),(3067,26,'2026-12-12',10,0,0,NULL,0),(3068,26,'2026-12-13',10,0,0,NULL,0),(3069,26,'2026-12-14',10,0,0,NULL,0),(3070,26,'2026-12-15',10,0,0,NULL,0),(3071,26,'2026-12-16',10,0,0,NULL,0),(3072,26,'2026-12-17',10,0,0,NULL,0),(3073,26,'2026-12-18',10,0,0,NULL,0),(3074,26,'2026-12-19',10,0,0,NULL,0),(3075,26,'2026-12-20',10,0,0,NULL,0),(3076,26,'2026-12-21',10,0,0,NULL,0),(3077,26,'2026-12-22',10,0,0,NULL,0),(3078,26,'2026-12-23',10,0,0,NULL,0),(3079,26,'2026-12-24',10,0,0,NULL,0),(3080,26,'2026-12-25',10,0,0,NULL,0),(3081,26,'2026-12-26',10,0,0,NULL,0),(3082,26,'2026-12-27',10,0,0,NULL,0),(3083,26,'2026-12-28',10,0,0,NULL,0),(3084,26,'2026-12-29',10,0,0,NULL,0),(3085,26,'2026-12-30',10,0,0,NULL,0),(3086,26,'2026-12-31',10,0,0,NULL,0),(3087,26,'2027-01-01',10,0,0,NULL,0),(3088,26,'2027-01-02',10,0,0,NULL,0),(3089,26,'2027-01-03',10,0,0,NULL,0),(3090,26,'2027-01-04',10,0,0,NULL,0),(3091,26,'2027-01-05',10,0,0,NULL,0),(3092,26,'2027-01-06',10,0,0,NULL,0),(3093,26,'2027-01-07',10,0,0,NULL,0),(3094,26,'2027-01-08',10,0,0,NULL,0),(3095,26,'2027-01-09',10,0,0,NULL,0),(3096,26,'2027-01-10',10,0,0,NULL,0),(3097,26,'2027-01-11',10,0,0,NULL,0),(3098,26,'2027-01-12',10,0,0,NULL,0),(3099,26,'2027-01-13',10,0,0,NULL,0),(3100,26,'2027-01-14',10,0,0,NULL,0),(3101,26,'2027-01-15',10,0,0,NULL,0),(3102,26,'2027-01-16',10,0,0,NULL,0),(3103,26,'2027-01-17',10,0,0,NULL,0),(3104,26,'2027-01-18',10,0,0,NULL,0),(3105,26,'2027-01-19',10,0,0,NULL,0),(3106,26,'2027-01-20',10,0,0,NULL,0),(3107,26,'2027-01-21',10,0,0,NULL,0),(3108,26,'2027-01-22',10,0,0,NULL,0),(3109,26,'2027-01-23',10,0,0,NULL,0),(3110,26,'2027-01-24',10,0,0,NULL,0),(3111,26,'2027-01-25',10,0,0,NULL,0),(3112,26,'2027-01-26',10,0,0,NULL,0),(3113,26,'2027-01-27',10,0,0,NULL,0),(3114,26,'2027-01-28',10,0,0,NULL,0),(3115,26,'2027-01-29',10,0,0,NULL,0),(3116,26,'2027-01-30',10,0,0,NULL,0),(3117,26,'2027-01-31',10,0,0,NULL,0),(3118,26,'2027-02-01',10,0,0,NULL,0),(3119,26,'2027-02-02',10,0,0,NULL,0),(3120,26,'2027-02-03',10,0,0,NULL,0),(3121,27,'2026-10-07',4,0,0,NULL,0),(3122,27,'2026-10-08',4,0,0,NULL,0),(3123,27,'2026-10-09',4,0,0,NULL,0),(3124,27,'2026-10-10',4,0,0,NULL,0),(3125,27,'2026-10-11',4,0,0,NULL,0),(3126,27,'2026-10-12',4,0,0,NULL,0),(3127,27,'2026-10-13',4,0,0,NULL,0),(3128,27,'2026-10-14',4,0,0,NULL,0),(3129,27,'2026-10-15',4,0,0,NULL,0),(3130,27,'2026-10-16',4,0,0,NULL,0),(3131,27,'2026-10-17',4,0,0,NULL,0),(3132,27,'2026-10-18',4,0,0,NULL,0),(3133,27,'2026-10-19',4,0,0,NULL,0),(3134,27,'2026-10-20',4,0,0,NULL,0),(3135,27,'2026-10-21',4,0,0,NULL,0),(3136,27,'2026-10-22',4,0,0,NULL,0),(3137,27,'2026-10-23',4,0,0,NULL,0),(3138,27,'2026-10-24',4,0,0,NULL,0),(3139,27,'2026-10-25',4,0,0,NULL,0),(3140,27,'2026-10-26',4,0,0,NULL,0),(3141,27,'2026-10-27',4,0,0,NULL,0),(3142,27,'2026-10-28',4,0,0,NULL,0),(3143,27,'2026-10-29',4,0,0,NULL,0),(3144,27,'2026-10-30',4,0,0,NULL,0),(3145,27,'2026-10-31',4,0,0,NULL,0),(3146,27,'2026-11-01',4,0,0,NULL,0),(3147,27,'2026-11-02',4,0,0,NULL,0),(3148,27,'2026-11-03',4,0,0,NULL,0),(3149,27,'2026-11-04',4,0,0,NULL,0),(3150,27,'2026-11-05',4,0,0,NULL,0),(3151,27,'2026-11-06',4,0,0,NULL,0),(3152,27,'2026-11-07',4,0,0,NULL,0),(3153,27,'2026-11-08',4,0,0,NULL,0),(3154,27,'2026-11-09',4,0,0,NULL,0),(3155,27,'2026-11-10',4,0,0,NULL,0),(3156,27,'2026-11-11',4,0,0,NULL,0),(3157,27,'2026-11-12',4,0,0,NULL,0),(3158,27,'2026-11-13',4,0,0,NULL,0),(3159,27,'2026-11-14',4,0,0,NULL,0),(3160,27,'2026-11-15',4,0,0,NULL,0),(3161,27,'2026-11-16',4,0,0,NULL,0),(3162,27,'2026-11-17',4,0,0,NULL,0),(3163,27,'2026-11-18',4,0,0,NULL,0),(3164,27,'2026-11-19',4,0,0,NULL,0),(3165,27,'2026-11-20',4,0,0,NULL,0),(3166,27,'2026-11-21',4,0,0,NULL,0),(3167,27,'2026-11-22',4,0,0,NULL,0),(3168,27,'2026-11-23',4,0,0,NULL,0),(3169,27,'2026-11-24',4,0,0,NULL,0),(3170,27,'2026-11-25',4,0,0,NULL,0),(3171,27,'2026-11-26',4,0,0,NULL,0),(3172,27,'2026-11-27',4,0,0,NULL,0),(3173,27,'2026-11-28',4,0,0,NULL,0),(3174,27,'2026-11-29',4,0,0,NULL,0),(3175,27,'2026-11-30',4,0,0,NULL,0),(3176,27,'2026-12-01',4,0,0,NULL,0),(3177,27,'2026-12-02',4,0,0,NULL,0),(3178,27,'2026-12-03',4,0,0,NULL,0),(3179,27,'2026-12-04',4,0,0,NULL,0),(3180,27,'2026-12-05',4,0,0,NULL,0),(3181,27,'2026-12-06',4,0,0,NULL,0),(3182,27,'2026-12-07',4,0,0,NULL,0),(3183,27,'2026-12-08',4,0,0,NULL,0),(3184,27,'2026-12-09',4,0,0,NULL,0),(3185,27,'2026-12-10',4,0,0,NULL,0),(3186,27,'2026-12-11',4,0,0,NULL,0),(3187,27,'2026-12-12',4,0,0,NULL,0),(3188,27,'2026-12-13',4,0,0,NULL,0),(3189,27,'2026-12-14',4,0,0,NULL,0),(3190,27,'2026-12-15',4,0,0,NULL,0),(3191,27,'2026-12-16',4,0,0,NULL,0),(3192,27,'2026-12-17',4,0,0,NULL,0),(3193,27,'2026-12-18',4,0,0,NULL,0),(3194,27,'2026-12-19',4,0,0,NULL,0),(3195,27,'2026-12-20',4,0,0,NULL,0),(3196,27,'2026-12-21',4,0,0,NULL,0),(3197,27,'2026-12-22',4,0,0,NULL,0),(3198,27,'2026-12-23',4,0,0,NULL,0),(3199,27,'2026-12-24',4,0,0,NULL,0),(3200,27,'2026-12-25',4,0,0,NULL,0),(3201,27,'2026-12-26',4,0,0,NULL,0),(3202,27,'2026-12-27',4,0,0,NULL,0),(3203,27,'2026-12-28',4,0,0,NULL,0),(3204,27,'2026-12-29',4,0,0,NULL,0),(3205,27,'2026-12-30',4,0,0,NULL,0),(3206,27,'2026-12-31',4,0,0,NULL,0),(3207,27,'2027-01-01',4,0,0,NULL,0),(3208,27,'2027-01-02',4,0,0,NULL,0),(3209,27,'2027-01-03',4,0,0,NULL,0),(3210,27,'2027-01-04',4,0,0,NULL,0),(3211,27,'2027-01-05',4,0,0,NULL,0),(3212,27,'2027-01-06',4,0,0,NULL,0),(3213,27,'2027-01-07',4,0,0,NULL,0),(3214,27,'2027-01-08',4,0,0,NULL,0),(3215,27,'2027-01-09',4,0,0,NULL,0),(3216,27,'2027-01-10',4,0,0,NULL,0),(3217,27,'2027-01-11',4,0,0,NULL,0),(3218,27,'2027-01-12',4,0,0,NULL,0),(3219,27,'2027-01-13',4,0,0,NULL,0),(3220,27,'2027-01-14',4,0,0,NULL,0),(3221,27,'2027-01-15',4,0,0,NULL,0),(3222,27,'2027-01-16',4,0,0,NULL,0),(3223,27,'2027-01-17',4,0,0,NULL,0),(3224,27,'2027-01-18',4,0,0,NULL,0),(3225,27,'2027-01-19',4,0,0,NULL,0),(3226,27,'2027-01-20',4,0,0,NULL,0),(3227,27,'2027-01-21',4,0,0,NULL,0),(3228,27,'2027-01-22',4,0,0,NULL,0),(3229,27,'2027-01-23',4,0,0,NULL,0),(3230,27,'2027-01-24',4,0,0,NULL,0),(3231,27,'2027-01-25',4,0,0,NULL,0),(3232,27,'2027-01-26',4,0,0,NULL,0),(3233,27,'2027-01-27',4,0,0,NULL,0),(3234,27,'2027-01-28',4,0,0,NULL,0),(3235,27,'2027-01-29',4,0,0,NULL,0),(3236,27,'2027-01-30',4,0,0,NULL,0),(3237,27,'2027-01-31',4,0,0,NULL,0),(3238,27,'2027-02-01',4,0,0,NULL,0),(3239,27,'2027-02-02',4,0,0,NULL,0),(3240,27,'2027-02-03',4,0,0,NULL,0);
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
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `roomSize` int DEFAULT NULL,
  `bedType` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `maxOccupancy` int NOT NULL DEFAULT '2',
  `totalRooms` int NOT NULL DEFAULT '1',
  `breakfastIncluded` tinyint(1) NOT NULL DEFAULT '0',
  `smokingAllowed` tinyint(1) NOT NULL DEFAULT '0',
  `basePricePerNight` int NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `RoomType_propertyId_idx` (`propertyId`),
  CONSTRAINT `RoomType_propertyId_fkey` FOREIGN KEY (`propertyId`) REFERENCES `Property` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomType`
--

LOCK TABLES `RoomType` WRITE;
/*!40000 ALTER TABLE `RoomType` DISABLE KEYS */;
INSERT INTO `RoomType` VALUES (19,9,'Phòng tiêu chuẩn',28,'1 giường đôi',2,6,1,0,850000,'Gọn gàng, ban công nhỏ nhìn ra vườn.'),(20,9,'Phòng Deluxe',28,'1 giường lớn',2,4,1,0,1250000,'Rộng rãi, cửa kính lớn view đồi thông.'),(21,9,'Phòng Family',28,'2 giường đôi',4,2,1,0,1800000,'Phù hợp gia đình 4 người.'),(22,10,'Phòng hướng biển',28,'1 giường lớn',2,5,1,0,1600000,'Ban công nhìn thẳng ra biển.'),(23,10,'Suite gia đình',28,'2 giường lớn',4,3,1,0,2600000,'Không gian rộng, bếp mini.'),(24,11,'Phòng vườn',28,'1 giường đôi',2,6,1,0,1100000,'Yên tĩnh, nhìn ra vườn.'),(25,11,'Phòng view sông',28,'1 giường lớn',2,3,1,0,1600000,'Ban công nhìn ra sông Hoài.'),(26,12,'Giường tầng (Dorm)',28,'Giường tầng',1,10,1,0,350000,'Tiết kiệm cho khách đi phượt.'),(27,12,'Cabin gỗ',28,'1 giường đôi',2,4,1,0,1200000,'Riêng tư, lò sưởi ấm áp.');
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
  `sellerName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT 'StayTour',
  `sellerAddress` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sellerPhone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sellerEmail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `siteNotice` text COLLATE utf8mb4_unicode_ci,
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
  `tourCode` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shortDescription` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `highlights` text COLLATE utf8mb4_unicode_ci,
  `regionId` int DEFAULT NULL,
  `themeId` int DEFAULT NULL,
  `durationDays` int NOT NULL DEFAULT '1',
  `durationNights` int NOT NULL DEFAULT '0',
  `departurePoint` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destination` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `meetingPoint` text COLLATE utf8mb4_unicode_ci,
  `minPax` int NOT NULL DEFAULT '1',
  `maxPax` int NOT NULL DEFAULT '30',
  `guideLanguage` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `basePrice` int NOT NULL,
  `depositRate` int DEFAULT NULL,
  `cancellationPolicyId` int DEFAULT NULL,
  `avgRating` double NOT NULL DEFAULT '0',
  `reviewCount` int NOT NULL DEFAULT '0',
  `status` enum('DRAFT','VISIBLE','HIDDEN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `thumbnail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isFeatured` tinyint(1) NOT NULL DEFAULT '0',
  `metaTitle` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `metaDescription` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tour`
--

LOCK TABLES `Tour` WRITE;
/*!40000 ALTER TABLE `Tour` DISABLE KEYS */;
INSERT INTO `Tour` VALUES (9,'TR001','Săn mây Tà Xùa 3N2Đ','san-may-ta-xua-3n2d','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.',NULL,NULL,NULL,3,2,'Hà Nội','Tà Xùa, Sơn La',NULL,1,25,NULL,2500000,30,3,4.5,2,'VISIBLE','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.567','2026-10-06 14:00:55.291'),(10,'TR002','Khám phá Hà Giang 4N3Đ','kham-pha-ha-giang-4n3d','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.',NULL,NULL,NULL,4,3,'Hà Nội','Hà Giang',NULL,1,25,NULL,3900000,30,3,5,1,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.598','2026-10-06 14:00:55.300'),(11,'TR003','Lý Sơn – Đảo tiên 2N1Đ','ly-son-dao-tien-2n1d','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.',NULL,NULL,NULL,2,1,'Đà Nẵng','Lý Sơn, Quảng Ngãi',NULL,1,25,NULL,1800000,30,3,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.624','2026-10-06 13:59:38.624'),(12,'TR004','Kỳ Co – Eo Gió 1 ngày','ky-co-eo-gio-1-ngay','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.',NULL,NULL,NULL,1,0,'Quy Nhơn','Quy Nhơn, Bình Định',NULL,1,25,NULL,650000,30,3,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-06 13:59:38.653','2026-10-06 13:59:38.653');
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
  `status` enum('OPEN','CLOSED','FULL','CANCELLED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'OPEN',
  `guideName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `TourDeparture_tourId_idx` (`tourId`),
  CONSTRAINT `TourDeparture_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourDeparture`
--

LOCK TABLES `TourDeparture` WRITE;
/*!40000 ALTER TABLE `TourDeparture` DISABLE KEYS */;
INSERT INTO `TourDeparture` VALUES (25,9,'2026-10-16','2026-10-18',20,2,0,'OPEN',NULL),(26,9,'2026-10-30','2026-11-01',20,0,0,'OPEN',NULL),(27,9,'2026-11-15','2026-11-17',20,0,0,'OPEN',NULL),(28,10,'2026-10-16','2026-10-19',20,0,0,'OPEN',NULL),(29,10,'2026-10-30','2026-11-02',20,0,0,'OPEN',NULL),(30,10,'2026-11-15','2026-11-18',20,0,0,'OPEN',NULL),(31,11,'2026-10-16','2026-10-17',20,0,0,'OPEN',NULL),(32,11,'2026-10-30','2026-10-31',20,0,0,'OPEN',NULL),(33,11,'2026-11-15','2026-11-16',20,0,0,'OPEN',NULL),(34,12,'2026-10-16','2026-10-16',20,0,0,'OPEN',NULL),(35,12,'2026-10-30','2026-10-30',20,0,0,'OPEN',NULL),(36,12,'2026-11-15','2026-11-15',20,0,0,'OPEN',NULL);
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
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `type` enum('INCLUDED','EXCLUDED') COLLATE utf8mb4_unicode_ci NOT NULL,
  `itemText` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `meals` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accommodation` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `type` enum('TERM','FAQ','REDEMPTION') COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
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
  `paxType` enum('ADULT','CHILD','INFANT') COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `requiresProof` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `TourPrice_departureId_paxType_key` (`departureId`,`paxType`),
  KEY `TourPrice_departureId_idx` (`departureId`),
  CONSTRAINT `TourPrice_departureId_fkey` FOREIGN KEY (`departureId`) REFERENCES `TourDeparture` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourPrice`
--

LOCK TABLES `TourPrice` WRITE;
/*!40000 ALTER TABLE `TourPrice` DISABLE KEYS */;
INSERT INTO `TourPrice` VALUES (49,25,'ADULT',2500000,'Người lớn',0),(50,25,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(51,26,'ADULT',2500000,'Người lớn',0),(52,26,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(53,27,'ADULT',2500000,'Người lớn',0),(54,27,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(55,28,'ADULT',3900000,'Người lớn',0),(56,28,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(57,29,'ADULT',3900000,'Người lớn',0),(58,29,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(59,30,'ADULT',3900000,'Người lớn',0),(60,30,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(61,31,'ADULT',1800000,'Người lớn',0),(62,31,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(63,32,'ADULT',1800000,'Người lớn',0),(64,32,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(65,33,'ADULT',1800000,'Người lớn',0),(66,33,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(67,34,'ADULT',650000,'Người lớn',0),(68,34,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(69,35,'ADULT',650000,'Người lớn',0),(70,35,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(71,36,'ADULT',650000,'Người lớn',0),(72,36,'CHILD',455000,'Trẻ em 5–11 tuổi',0);
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
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `authorName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `coverImage` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `excerpt` text COLLATE utf8mb4_unicode_ci,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `locationName` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `publishedAt` datetime(3) DEFAULT NULL,
  `status` enum('DRAFT','VISIBLE','HIDDEN') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DRAFT',
  `createdById` int DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `TravelGuide_slug_key` (`slug`),
  KEY `TravelGuide_status_idx` (`status`),
  KEY `TravelGuide_publishedAt_idx` (`publishedAt`),
  KEY `TravelGuide_createdById_fkey` (`createdById`),
  CONSTRAINT `TravelGuide_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `Admin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TravelGuide`
--

LOCK TABLES `TravelGuide` WRITE;
/*!40000 ALTER TABLE `TravelGuide` DISABLE KEYS */;
INSERT INTO `TravelGuide` VALUES (3,'Kinh nghiệm du lịch Đà Lạt 3 ngày 2 đêm','kinh-nghiem-du-lich-da-lat-3n2d','Ban biên tập StayTour','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70','Gợi ý lịch trình Đà Lạt tiết kiệm cho nhóm bạn.','Ngày 1: khám phá trung tâm, chợ đêm Đà Lạt.\nNgày 2: đồi chè Cầu Đất, săn mây.\nNgày 3: vườn hoa, mua đặc sản về làm quà.','Đà Lạt, Lâm Đồng',NULL,NULL,'2026-10-06 13:59:38.695','VISIBLE',NULL,'2026-10-06 13:59:38.696','2026-10-06 13:59:38.696');
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
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dateOfBirth` datetime(3) DEFAULT NULL,
  `gender` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nationality` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idNumber` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `googleId` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
INSERT INTO `User` VALUES (2,'khachhang@gmail.com','$2a$10$L2sMTJ1ZWngipKnClOCmRulkZcyJjWKscvf2mlR2CRWMnxEPSRZdm','Nguyễn Minh Anh','0905123456','12 Nguyễn Trãi, Thanh Xuân','1998-04-12 00:00:00.000','FEMALE','Việt Nam','001198000123','Hà Nội',NULL,NULL,1,1,0,NULL,0,'2026-10-06 14:00:55.092','2026-10-06 14:02:03.586'),(3,'ha.tran@gmail.com','$2a$10$L2sMTJ1ZWngipKnClOCmRulkZcyJjWKscvf2mlR2CRWMnxEPSRZdm','Trần Thu Hà','0912345678','45 Lê Lợi, Quận 1','1995-09-02 00:00:00.000','FEMALE','Việt Nam','079095000456','TP. Hồ Chí Minh',NULL,NULL,1,1,0,NULL,0,'2026-10-06 14:00:55.104','2026-10-06 14:00:55.104');
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

-- Dump completed on 2026-10-06 14:03:28
