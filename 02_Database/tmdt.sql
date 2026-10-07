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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Area`
--

LOCK TABLES `Area` WRITE;
/*!40000 ALTER TABLE `Area` DISABLE KEYS */;
INSERT INTO `Area` VALUES (17,'Đà Lạt','da-lat','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1),(18,'Đà Nẵng','da-nang','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',2),(19,'Hội An','hoi-an','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',3),(20,'Sa Pa','sa-pa','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',4);
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Booking`
--

LOCK TABLES `Booking` WRITE;
/*!40000 ALTER TABLE `Booking` DISABLE KEYS */;
INSERT INTO `Booking` VALUES (18,'BK-SSFE8FRD7',NULL,'HOMESTAY','DEPOSITED',NULL,23,49,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Nhận phòng muộn ~21h. Xin phòng tầng cao, yên tĩnh.','2026-10-27','2026-10-29',2,2,0,1700000,510000,1190000,'VNPAY',NULL,'2026-09-27 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:59:47.664','2026-10-07 09:59:47.664',0,NULL,NULL),(19,'BK-EK2UHFDCU',NULL,'HOMESTAY','PENDING_DEPOSIT',NULL,24,52,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Cần thêm 1 giường phụ cho trẻ em.','2026-11-11','2026-11-13',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-07 10:14:47.680','2026-10-07 09:59:47.681','2026-10-07 09:59:47.681',0,NULL,NULL),(20,'BK-YT3K36QJ6',NULL,'HOMESTAY','COMPLETED',NULL,25,54,NULL,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Kỳ nghỉ gia đình.','2026-09-17','2026-09-19',2,2,0,2200000,660000,1540000,'VNPAY',NULL,'2026-08-18 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:59:47.691','2026-10-07 09:59:47.691',0,NULL,NULL),(21,'BK-EYJP6Q9AC',NULL,'TOUR','CONFIRMED',NULL,NULL,NULL,23,67,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456','Ăn chay 1 suất.','2026-10-17','2026-10-19',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-02 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:59:47.700','2026-10-07 09:59:47.700',0,NULL,NULL),(22,'BK-MXVG2BBV2',NULL,'TOUR','COMPLETED',NULL,NULL,NULL,24,NULL,2,'Nguyễn Minh Anh','khachhang@gmail.com','0905123456',NULL,'2026-10-22','2026-10-22',3,2,0,7800000,2340000,5460000,'COD',NULL,'2026-10-02 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:59:47.711','2026-10-07 09:59:47.711',0,NULL,NULL),(23,'BK-6BUMSMK6E',NULL,'TOUR','CANCELLED',NULL,NULL,NULL,23,67,3,'Trần Thu Hà','ha.tran@gmail.com','0912345678','Bận việc đột xuất.','2026-10-17','2026-10-19',2,2,0,5000000,1500000,3500000,'VNPAY',NULL,'2026-10-02 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:59:47.720','2026-10-07 09:59:47.720',0,NULL,'2026-10-05 00:00:00.000'),(24,'BK-4DLJZ45JL','dec58ab7d7f9fb6bd366cea633274ef3632f8eaa823bf811c14bed255d60e339','HOMESTAY','COMPLETED',NULL,23,49,NULL,NULL,NULL,'Lê Văn Khách','khachvanglai@example.com','0988777666',NULL,'2026-09-22','2026-09-24',2,2,0,1700000,510000,1190000,'COD',NULL,'2026-08-23 00:00:00.000',NULL,0,0,NULL,'2026-10-07 09:59:47.728','2026-10-07 09:59:47.728',0,NULL,NULL),(25,'BK-S5RVV7PC2','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','HOMESTAY','PENDING_DEPOSIT',NULL,24,52,NULL,NULL,NULL,'Phạm Thu Trang','guest.track@example.com','0977555444','Đặt hộ bạn.','2026-10-17','2026-10-19',2,2,0,3200000,960000,2240000,NULL,NULL,NULL,NULL,0,0,'2026-10-07 10:14:47.739','2026-10-07 09:59:47.740','2026-10-07 09:59:47.740',0,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CancellationPolicy`
--

LOCK TABLES `CancellationPolicy` WRITE;
/*!40000 ALTER TABLE `CancellationPolicy` DISABLE KEYS */;
INSERT INTO `CancellationPolicy` VALUES (1,'Linh hoạt tiêu chuẩn',1,24,'2026-10-05 04:43:05.829','2026-10-05 04:43:05.829'),(2,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:53:11.058','2026-10-06 13:53:11.058'),(3,'Linh hoạt tiêu chuẩn',1,24,'2026-10-06 13:59:38.411','2026-10-06 13:59:38.411'),(4,'Linh hoạt tiêu chuẩn',1,24,'2026-10-07 09:28:10.465','2026-10-07 09:28:10.465'),(5,'Linh hoạt tiêu chuẩn',1,24,'2026-10-07 09:59:38.015','2026-10-07 09:59:38.015');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DiscountCode`
--

LOCK TABLES `DiscountCode` WRITE;
/*!40000 ALTER TABLE `DiscountCode` DISABLE KEYS */;
INSERT INTO `DiscountCode` VALUES (9,'STAYTOUR10','PERCENT',10,500000,'ALL',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-07 09:59:38.698'),(10,'HE2026','FIXED',150000,1000000,'HOMESTAY',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-07 09:59:38.698');
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Favorite`
--

LOCK TABLES `Favorite` WRITE;
/*!40000 ALTER TABLE `Favorite` DISABLE KEYS */;
INSERT INTO `Favorite` VALUES (7,2,NULL,23,NULL,'2026-10-07 09:59:47.774'),(8,2,NULL,NULL,23,'2026-10-07 09:59:47.778'),(9,3,NULL,25,NULL,'2026-10-07 09:59:47.781');
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InfoArticle`
--

LOCK TABLES `InfoArticle` WRITE;
/*!40000 ALTER TABLE `InfoArticle` DISABLE KEYS */;
INSERT INTO `InfoArticle` VALUES (17,'gioi-thieu','Thông tin người bán','ABOUT','Về StayTour','StayTour là nền tảng đặt homestay và tour du lịch nội địa.',1,1,'2026-10-07 09:59:38.702','2026-10-07 09:59:38.702'),(18,'dieu-kien-giao-dich','Điều kiện giao dịch chung','POLICY','Điều khoản','Các điều kiện và điều khoản giao dịch chung khi sử dụng StayTour.',1,2,'2026-10-07 09:59:38.702','2026-10-07 09:59:38.702'),(19,'chinh-sach-doi-tra-huy','Chính sách đổi – trả – hủy','POLICY','Hủy & hoàn tiền','Chính sách hủy đặt chỗ và hoàn tiền theo từng mốc thời gian.',1,3,'2026-10-07 09:59:38.702','2026-10-07 09:59:38.702'),(20,'bao-mat-du-lieu','Bảo vệ dữ liệu cá nhân','POLICY','Bảo mật','Cam kết bảo vệ dữ liệu cá nhân của khách hàng.',1,4,'2026-10-07 09:59:38.702','2026-10-07 09:59:38.702');
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment`
--

LOCK TABLES `Payment` WRITE;
/*!40000 ALTER TABLE `Payment` DISABLE KEYS */;
INSERT INTO `Payment` VALUES (14,18,'VNPAY',510000,'SUCCESS','VNP1791367187662','2026-10-07 09:59:47.669'),(15,20,'VNPAY',660000,'SUCCESS','VNP1791367182689','2026-10-07 09:59:47.694'),(16,21,'VNPAY',1500000,'SUCCESS','VNP1791367178699','2026-10-07 09:59:47.704'),(17,22,'COD',2340000,'SUCCESS',NULL,'2026-10-07 09:59:47.714'),(18,23,'VNPAY',1500000,'SUCCESS','VNP1791367175719','2026-10-07 09:59:47.723'),(19,24,'COD',510000,'SUCCESS',NULL,'2026-10-07 09:59:47.732');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PolicyMilestone`
--

LOCK TABLES `PolicyMilestone` WRITE;
/*!40000 ALTER TABLE `PolicyMilestone` DISABLE KEYS */;
INSERT INTO `PolicyMilestone` VALUES (1,1,7,100),(2,1,3,50),(3,2,7,100),(4,2,3,50),(5,3,7,100),(6,3,3,50),(7,4,7,100),(8,4,3,50),(9,5,7,100),(10,5,3,50);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
INSERT INTO `Promotion` VALUES (9,'Giảm 20% đặt homestay dịp lễ','Áp dụng cho đơn đặt trước 7 ngày.','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,'2026-10-07 09:59:38.696'),(10,'Tour Tây Bắc mùa săn mây','Ưu đãi nhóm từ 4 khách trở lên.','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,'2026-10-07 09:59:38.696');
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Property`
--

LOCK TABLES `Property` WRITE;
/*!40000 ALTER TABLE `Property` DISABLE KEYS */;
INSERT INTO `Property` VALUES (23,'HS001','Pine Hill Homestay','pine-hill-homestay','HOMESTAY',NULL,'Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.','Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.',NULL,NULL,'Đà Lạt, Lâm Đồng',NULL,NULL,'14:00','12:00',850000,30,5,4.5,2,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.023','2026-10-07 09:59:47.786'),(24,'HS002','Biển Ngọc Villa','bien-ngoc-villa','HOMESTAY',NULL,'Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.','Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.',NULL,NULL,'Mỹ Khê, Đà Nẵng',NULL,NULL,'14:00','12:00',1600000,30,5,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.068','2026-10-07 09:59:47.791'),(25,'HS003','Sông Trăng Riverside','song-trang-riverside','HOMESTAY',NULL,'Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.','Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.',NULL,NULL,'Hội An, Quảng Nam',NULL,NULL,'14:00','12:00',1100000,30,5,5,1,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.092','2026-10-07 09:59:47.795'),(26,'HS004','Nhà Của Rừng','nha-cua-rung-sapa','HOMESTAY',NULL,'Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.','Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.',NULL,NULL,'Sa Pa, Lào Cai',NULL,NULL,'14:00','12:00',700000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.117','2026-10-07 09:59:38.117'),(27,'HS005','Mộc Châu Mộc Homestay','moc-chau-moc-homestay','HOMESTAY',NULL,'Nhà sàn giữa đồi chè Mộc Châu, săn mây và ngắm hoa mận.','Nhà sàn giữa đồi chè Mộc Châu, săn mây và ngắm hoa mận.',NULL,NULL,'Mộc Châu, Sơn La',NULL,NULL,'14:00','12:00',650000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.141','2026-10-07 09:59:38.141'),(28,'HS006','Tam Cốc Garden Retreat','tam-coc-garden-retreat','HOMESTAY',NULL,'Khu nghỉ sinh thái giữa núi đá Tam Cốc – Tràng An.','Khu nghỉ sinh thái giữa núi đá Tam Cốc – Tràng An.',NULL,NULL,'Ninh Bình',NULL,NULL,'14:00','12:00',1250000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.165','2026-10-07 09:59:38.165'),(29,'HS007','Sao Biển Phú Quốc','sao-bien-phu-quoc','HOMESTAY',NULL,'Homestay sát Bãi Sao, cát trắng nước trong, hoàng hôn tuyệt đẹp.','Homestay sát Bãi Sao, cát trắng nước trong, hoàng hôn tuyệt đẹp.',NULL,NULL,'Phú Quốc, Kiên Giang',NULL,NULL,'14:00','12:00',1400000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.187','2026-10-07 09:59:38.187'),(30,'HS008','Phố Cổ Hà Nội Boutique','pho-co-ha-noi-boutique','HOMESTAY',NULL,'Căn hộ ấm cúng giữa phố cổ, đi bộ ra Hồ Gươm 5 phút.','Căn hộ ấm cúng giữa phố cổ, đi bộ ra Hồ Gươm 5 phút.',NULL,NULL,'Hoàn Kiếm, Hà Nội',NULL,NULL,'14:00','12:00',900000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.210','2026-10-07 09:59:38.210'),(31,'HS009','Cát Bà Sunrise Bungalow','cat-ba-sunrise-bungalow','HOMESTAY',NULL,'Bungalow nhìn ra vịnh Lan Hạ, chèo kayak và tắm biển.','Bungalow nhìn ra vịnh Lan Hạ, chèo kayak và tắm biển.',NULL,NULL,'Cát Bà, Hải Phòng',NULL,NULL,'14:00','12:00',800000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.232','2026-10-07 09:59:38.232'),(32,'HS010','An Nhiên Farmstay Bảo Lộc','an-nhien-farmstay-bao-loc','HOMESTAY',NULL,'Farmstay giữa đồi chè và thác nước, trải nghiệm hái trà.','Farmstay giữa đồi chè và thác nước, trải nghiệm hái trà.',NULL,NULL,'Bảo Lộc, Lâm Đồng',NULL,NULL,'14:00','12:00',950000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.254','2026-10-07 09:59:38.254'),(33,'HS011','Biển Xanh Vũng Tàu','bien-xanh-vung-tau','HOMESTAY',NULL,'Căn hộ view biển Bãi Sau, hồ bơi vô cực, gần phố hải sản.','Căn hộ view biển Bãi Sau, hồ bơi vô cực, gần phố hải sản.',NULL,NULL,'Bãi Sau, Vũng Tàu',NULL,NULL,'14:00','12:00',1050000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.288','2026-10-07 09:59:38.288'),(34,'HS012','Tuyền Lâm Lake House','tuyen-lam-lake-house','HOMESTAY',NULL,'Nhà gỗ bên hồ Tuyền Lâm, sương mù lãng mạn, chèo SUP buổi sáng.','Nhà gỗ bên hồ Tuyền Lâm, sương mù lãng mạn, chèo SUP buổi sáng.',NULL,NULL,'Hồ Tuyền Lâm, Đà Lạt',NULL,NULL,'14:00','12:00',1300000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.312','2026-10-07 09:59:38.312'),(35,'HS013','Hạ Long Bay Bungalow','ha-long-bay-bungalow','HOMESTAY',NULL,'Bungalow nhìn ra vịnh Hạ Long, gần cảng tàu tham quan.','Bungalow nhìn ra vịnh Hạ Long, gần cảng tàu tham quan.',NULL,NULL,'Hạ Long, Quảng Ninh',NULL,NULL,'14:00','12:00',1500000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.339','2026-10-07 09:59:38.339'),(36,'HS014','Nhà Vườn Cà Phê Buôn Ma Thuột','nha-vuon-ca-phe-buon-ma-thuot','HOMESTAY',NULL,'Homestay giữa vườn cà phê, trải nghiệm rang xay và cưỡi voi.','Homestay giữa vườn cà phê, trải nghiệm rang xay và cưỡi voi.',NULL,NULL,'Buôn Ma Thuột, Đắk Lắk',NULL,NULL,'14:00','12:00',600000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.367','2026-10-07 09:59:38.367'),(37,'HS015','Mây Núi Cấm An Giang','may-nui-cam-an-giang','HOMESTAY',NULL,'Homestay trên Núi Cấm, săn mây miền Tây, ngắm đồng lúa Bảy Núi.','Homestay trên Núi Cấm, săn mây miền Tây, ngắm đồng lúa Bảy Núi.',NULL,NULL,'Núi Cấm, An Giang',NULL,NULL,'14:00','12:00',550000,30,5,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.393','2026-10-07 09:59:38.393');
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
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PropertyImage`
--

LOCK TABLES `PropertyImage` WRITE;
/*!40000 ALTER TABLE `PropertyImage` DISABLE KEYS */;
INSERT INTO `PropertyImage` VALUES (1,23,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(2,23,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(3,23,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(4,23,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(5,23,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(6,24,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(7,24,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(8,24,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(9,24,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(10,24,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(11,25,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(12,25,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(13,25,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(14,25,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(15,25,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(16,26,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(17,26,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(18,26,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(19,26,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(20,26,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(21,27,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(22,27,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(23,27,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(24,27,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(25,27,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(26,28,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(27,28,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(28,28,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(29,28,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(30,28,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(31,29,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(32,29,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(33,29,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(34,29,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(35,29,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(36,30,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(37,30,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(38,30,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(39,30,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(40,30,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(41,31,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(42,31,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(43,31,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(44,31,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(45,31,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(46,32,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(47,32,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(48,32,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(49,32,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(50,32,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(51,33,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(52,33,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(53,33,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(54,33,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(55,33,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(56,34,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(57,34,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(58,34,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(59,34,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(60,34,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(61,35,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(62,35,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(63,35,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(64,35,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(65,35,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(66,36,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(67,36,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(68,36,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(69,36,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(70,36,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(71,37,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(72,37,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(73,37,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(74,37,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(75,37,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RefundRequest`
--

LOCK TABLES `RefundRequest` WRITE;
/*!40000 ALTER TABLE `RefundRequest` DISABLE KEYS */;
INSERT INTO `RefundRequest` VALUES (3,23,750000,50,'PENDING','2026-10-07 09:59:47.725');
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
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
INSERT INTO `Review` VALUES (41,'HOMESTAY',NULL,25,NULL,20,'Nguyễn Minh Anh',5,'Homestay tuyệt vời, view đẹp, chủ nhà thân thiện. Sẽ quay lại!',1,0,'2026-09-20 00:00:00.000'),(42,'TOUR',NULL,NULL,24,22,'Nguyễn Minh Anh',4,'Lịch trình ổn, hướng dẫn viên nhiệt tình. Xe hơi đông.',0,0,'2026-10-06 00:00:00.000'),(43,'HOMESTAY',NULL,23,NULL,NULL,'Hoàng Thị Mai',5,'Sạch sẽ, gần trung tâm, nhân viên dễ thương.',1,0,'2026-09-21 00:00:00.000'),(44,'HOMESTAY',NULL,23,NULL,NULL,'Đỗ Quang Huy',4,'Phòng đẹp, buổi sáng hơi ồn một chút.',1,0,'2026-09-14 00:00:00.000'),(45,'HOMESTAY',NULL,24,NULL,NULL,'Vũ Thị Lan',5,'Không gian yên tĩnh, bữa sáng ngon.',1,0,'2026-09-23 00:00:00.000'),(46,'TOUR',NULL,NULL,23,NULL,'Nguyễn Văn Tú',5,'Cảnh đẹp mê hồn, tổ chức chuyên nghiệp.',1,0,'2026-09-17 00:00:00.000'),(47,'TOUR',NULL,NULL,23,NULL,'Trịnh Bảo',4,'Đáng tiền, nên mang thêm áo ấm.',1,0,'2026-09-21 00:00:00.000'),(48,'TOUR',NULL,NULL,24,NULL,'Lý Thu Hằng',5,'Chuyến đi đáng nhớ, hướng dẫn viên vui tính.',1,0,'2026-09-23 00:00:00.000');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewToken`
--

LOCK TABLES `ReviewToken` WRITE;
/*!40000 ALTER TABLE `ReviewToken` DISABLE KEYS */;
INSERT INTO `ReviewToken` VALUES (3,24,'88bf715c5780d7f94483983eda56d503252af82c256a1b3a89bfcce4b926cf43','2026-11-06 00:00:00.000',NULL,'2026-10-07 09:59:47.737');
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
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomImage`
--

LOCK TABLES `RoomImage` WRITE;
/*!40000 ALTER TABLE `RoomImage` DISABLE KEYS */;
INSERT INTO `RoomImage` VALUES (1,49,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(2,49,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(3,49,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(4,50,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(5,50,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(6,50,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(7,51,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(8,51,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(9,51,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(10,52,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(11,52,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(12,52,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(13,53,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(14,53,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(15,53,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(16,54,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(17,54,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(18,54,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(19,55,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(20,55,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(21,55,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(22,56,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(23,56,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(24,56,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(25,57,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(26,57,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(27,57,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(28,58,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(29,58,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(30,58,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(31,59,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(32,59,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(33,59,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(34,60,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(35,60,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(36,60,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(37,61,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(38,61,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(39,61,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(40,62,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(41,62,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(42,62,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(43,63,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(44,63,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(45,63,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(46,64,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(47,64,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(48,64,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(49,65,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(50,65,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(51,65,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(52,66,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(53,66,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(54,66,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(55,67,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(56,67,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(57,67,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(58,68,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(59,68,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(60,68,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(61,69,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(62,69,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(63,69,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(64,70,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(65,70,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(66,70,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(67,71,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(68,71,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(69,71,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(70,72,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(71,72,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(72,72,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(73,73,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(74,73,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(75,73,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(76,74,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(77,74,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(78,74,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(79,75,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(80,75,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(81,75,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(82,76,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(83,76,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(84,76,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(85,77,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(86,77,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(87,77,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(88,78,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(89,78,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(90,78,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(91,79,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(92,79,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(93,79,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=9481 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomInventory`
--

LOCK TABLES `RoomInventory` WRITE;
/*!40000 ALTER TABLE `RoomInventory` DISABLE KEYS */;
INSERT INTO `RoomInventory` VALUES (5761,49,'2026-10-08',6,0,0,NULL,0),(5762,49,'2026-10-09',6,0,0,NULL,0),(5763,49,'2026-10-10',6,0,0,NULL,0),(5764,49,'2026-10-11',6,0,0,NULL,0),(5765,49,'2026-10-12',6,0,0,NULL,0),(5766,49,'2026-10-13',6,0,0,NULL,0),(5767,49,'2026-10-14',6,0,0,NULL,0),(5768,49,'2026-10-15',6,0,0,NULL,0),(5769,49,'2026-10-16',6,0,0,NULL,0),(5770,49,'2026-10-17',6,0,0,NULL,0),(5771,49,'2026-10-18',6,0,0,NULL,0),(5772,49,'2026-10-19',6,0,0,NULL,0),(5773,49,'2026-10-20',6,0,0,NULL,0),(5774,49,'2026-10-21',6,0,0,NULL,0),(5775,49,'2026-10-22',6,0,0,NULL,0),(5776,49,'2026-10-23',6,0,0,NULL,0),(5777,49,'2026-10-24',6,0,0,NULL,0),(5778,49,'2026-10-25',6,0,0,NULL,0),(5779,49,'2026-10-26',6,0,0,NULL,0),(5780,49,'2026-10-27',6,1,0,NULL,0),(5781,49,'2026-10-28',6,1,0,NULL,0),(5782,49,'2026-10-29',6,0,0,NULL,0),(5783,49,'2026-10-30',6,0,0,NULL,0),(5784,49,'2026-10-31',6,0,0,NULL,0),(5785,49,'2026-11-01',6,0,0,NULL,0),(5786,49,'2026-11-02',6,0,0,NULL,0),(5787,49,'2026-11-03',6,0,0,NULL,0),(5788,49,'2026-11-04',6,0,0,NULL,0),(5789,49,'2026-11-05',6,0,0,NULL,0),(5790,49,'2026-11-06',6,0,0,NULL,0),(5791,49,'2026-11-07',6,0,0,NULL,0),(5792,49,'2026-11-08',6,0,0,NULL,0),(5793,49,'2026-11-09',6,0,0,NULL,0),(5794,49,'2026-11-10',6,0,0,NULL,0),(5795,49,'2026-11-11',6,0,0,NULL,0),(5796,49,'2026-11-12',6,0,0,NULL,0),(5797,49,'2026-11-13',6,0,0,NULL,0),(5798,49,'2026-11-14',6,0,0,NULL,0),(5799,49,'2026-11-15',6,0,0,NULL,0),(5800,49,'2026-11-16',6,0,0,NULL,0),(5801,49,'2026-11-17',6,0,0,NULL,0),(5802,49,'2026-11-18',6,0,0,NULL,0),(5803,49,'2026-11-19',6,0,0,NULL,0),(5804,49,'2026-11-20',6,0,0,NULL,0),(5805,49,'2026-11-21',6,0,0,NULL,0),(5806,49,'2026-11-22',6,0,0,NULL,0),(5807,49,'2026-11-23',6,0,0,NULL,0),(5808,49,'2026-11-24',6,0,0,NULL,0),(5809,49,'2026-11-25',6,0,0,NULL,0),(5810,49,'2026-11-26',6,0,0,NULL,0),(5811,49,'2026-11-27',6,0,0,NULL,0),(5812,49,'2026-11-28',6,0,0,NULL,0),(5813,49,'2026-11-29',6,0,0,NULL,0),(5814,49,'2026-11-30',6,0,0,NULL,0),(5815,49,'2026-12-01',6,0,0,NULL,0),(5816,49,'2026-12-02',6,0,0,NULL,0),(5817,49,'2026-12-03',6,0,0,NULL,0),(5818,49,'2026-12-04',6,0,0,NULL,0),(5819,49,'2026-12-05',6,0,0,NULL,0),(5820,49,'2026-12-06',6,0,0,NULL,0),(5821,49,'2026-12-07',6,0,0,NULL,0),(5822,49,'2026-12-08',6,0,0,NULL,0),(5823,49,'2026-12-09',6,0,0,NULL,0),(5824,49,'2026-12-10',6,0,0,NULL,0),(5825,49,'2026-12-11',6,0,0,NULL,0),(5826,49,'2026-12-12',6,0,0,NULL,0),(5827,49,'2026-12-13',6,0,0,NULL,0),(5828,49,'2026-12-14',6,0,0,NULL,0),(5829,49,'2026-12-15',6,0,0,NULL,0),(5830,49,'2026-12-16',6,0,0,NULL,0),(5831,49,'2026-12-17',6,0,0,NULL,0),(5832,49,'2026-12-18',6,0,0,NULL,0),(5833,49,'2026-12-19',6,0,0,NULL,0),(5834,49,'2026-12-20',6,0,0,NULL,0),(5835,49,'2026-12-21',6,0,0,NULL,0),(5836,49,'2026-12-22',6,0,0,NULL,0),(5837,49,'2026-12-23',6,0,0,NULL,0),(5838,49,'2026-12-24',6,0,0,NULL,0),(5839,49,'2026-12-25',6,0,0,NULL,0),(5840,49,'2026-12-26',6,0,0,NULL,0),(5841,49,'2026-12-27',6,0,0,NULL,0),(5842,49,'2026-12-28',6,0,0,NULL,0),(5843,49,'2026-12-29',6,0,0,NULL,0),(5844,49,'2026-12-30',6,0,0,NULL,0),(5845,49,'2026-12-31',6,0,0,NULL,0),(5846,49,'2027-01-01',6,0,0,NULL,0),(5847,49,'2027-01-02',6,0,0,NULL,0),(5848,49,'2027-01-03',6,0,0,NULL,0),(5849,49,'2027-01-04',6,0,0,NULL,0),(5850,49,'2027-01-05',6,0,0,NULL,0),(5851,49,'2027-01-06',6,0,0,NULL,0),(5852,49,'2027-01-07',6,0,0,NULL,0),(5853,49,'2027-01-08',6,0,0,NULL,0),(5854,49,'2027-01-09',6,0,0,NULL,0),(5855,49,'2027-01-10',6,0,0,NULL,0),(5856,49,'2027-01-11',6,0,0,NULL,0),(5857,49,'2027-01-12',6,0,0,NULL,0),(5858,49,'2027-01-13',6,0,0,NULL,0),(5859,49,'2027-01-14',6,0,0,NULL,0),(5860,49,'2027-01-15',6,0,0,NULL,0),(5861,49,'2027-01-16',6,0,0,NULL,0),(5862,49,'2027-01-17',6,0,0,NULL,0),(5863,49,'2027-01-18',6,0,0,NULL,0),(5864,49,'2027-01-19',6,0,0,NULL,0),(5865,49,'2027-01-20',6,0,0,NULL,0),(5866,49,'2027-01-21',6,0,0,NULL,0),(5867,49,'2027-01-22',6,0,0,NULL,0),(5868,49,'2027-01-23',6,0,0,NULL,0),(5869,49,'2027-01-24',6,0,0,NULL,0),(5870,49,'2027-01-25',6,0,0,NULL,0),(5871,49,'2027-01-26',6,0,0,NULL,0),(5872,49,'2027-01-27',6,0,0,NULL,0),(5873,49,'2027-01-28',6,0,0,NULL,0),(5874,49,'2027-01-29',6,0,0,NULL,0),(5875,49,'2027-01-30',6,0,0,NULL,0),(5876,49,'2027-01-31',6,0,0,NULL,0),(5877,49,'2027-02-01',6,0,0,NULL,0),(5878,49,'2027-02-02',6,0,0,NULL,0),(5879,49,'2027-02-03',6,0,0,NULL,0),(5880,49,'2027-02-04',6,0,0,NULL,0),(5881,50,'2026-10-08',4,0,0,NULL,0),(5882,50,'2026-10-09',4,0,0,NULL,0),(5883,50,'2026-10-10',4,0,0,NULL,0),(5884,50,'2026-10-11',4,0,0,NULL,0),(5885,50,'2026-10-12',4,0,0,NULL,0),(5886,50,'2026-10-13',4,0,0,NULL,0),(5887,50,'2026-10-14',4,0,0,NULL,0),(5888,50,'2026-10-15',4,0,0,NULL,0),(5889,50,'2026-10-16',4,0,0,NULL,0),(5890,50,'2026-10-17',4,0,0,NULL,0),(5891,50,'2026-10-18',4,0,0,NULL,0),(5892,50,'2026-10-19',4,0,0,NULL,0),(5893,50,'2026-10-20',4,0,0,NULL,0),(5894,50,'2026-10-21',4,0,0,NULL,0),(5895,50,'2026-10-22',4,0,0,NULL,0),(5896,50,'2026-10-23',4,0,0,NULL,0),(5897,50,'2026-10-24',4,0,0,NULL,0),(5898,50,'2026-10-25',4,0,0,NULL,0),(5899,50,'2026-10-26',4,0,0,NULL,0),(5900,50,'2026-10-27',4,0,0,NULL,0),(5901,50,'2026-10-28',4,0,0,NULL,0),(5902,50,'2026-10-29',4,0,0,NULL,0),(5903,50,'2026-10-30',4,0,0,NULL,0),(5904,50,'2026-10-31',4,0,0,NULL,0),(5905,50,'2026-11-01',4,0,0,NULL,0),(5906,50,'2026-11-02',4,0,0,NULL,0),(5907,50,'2026-11-03',4,0,0,NULL,0),(5908,50,'2026-11-04',4,0,0,NULL,0),(5909,50,'2026-11-05',4,0,0,NULL,0),(5910,50,'2026-11-06',4,0,0,NULL,0),(5911,50,'2026-11-07',4,0,0,NULL,0),(5912,50,'2026-11-08',4,0,0,NULL,0),(5913,50,'2026-11-09',4,0,0,NULL,0),(5914,50,'2026-11-10',4,0,0,NULL,0),(5915,50,'2026-11-11',4,0,0,NULL,0),(5916,50,'2026-11-12',4,0,0,NULL,0),(5917,50,'2026-11-13',4,0,0,NULL,0),(5918,50,'2026-11-14',4,0,0,NULL,0),(5919,50,'2026-11-15',4,0,0,NULL,0),(5920,50,'2026-11-16',4,0,0,NULL,0),(5921,50,'2026-11-17',4,0,0,NULL,0),(5922,50,'2026-11-18',4,0,0,NULL,0),(5923,50,'2026-11-19',4,0,0,NULL,0),(5924,50,'2026-11-20',4,0,0,NULL,0),(5925,50,'2026-11-21',4,0,0,NULL,0),(5926,50,'2026-11-22',4,0,0,NULL,0),(5927,50,'2026-11-23',4,0,0,NULL,0),(5928,50,'2026-11-24',4,0,0,NULL,0),(5929,50,'2026-11-25',4,0,0,NULL,0),(5930,50,'2026-11-26',4,0,0,NULL,0),(5931,50,'2026-11-27',4,0,0,NULL,0),(5932,50,'2026-11-28',4,0,0,NULL,0),(5933,50,'2026-11-29',4,0,0,NULL,0),(5934,50,'2026-11-30',4,0,0,NULL,0),(5935,50,'2026-12-01',4,0,0,NULL,0),(5936,50,'2026-12-02',4,0,0,NULL,0),(5937,50,'2026-12-03',4,0,0,NULL,0),(5938,50,'2026-12-04',4,0,0,NULL,0),(5939,50,'2026-12-05',4,0,0,NULL,0),(5940,50,'2026-12-06',4,0,0,NULL,0),(5941,50,'2026-12-07',4,0,0,NULL,0),(5942,50,'2026-12-08',4,0,0,NULL,0),(5943,50,'2026-12-09',4,0,0,NULL,0),(5944,50,'2026-12-10',4,0,0,NULL,0),(5945,50,'2026-12-11',4,0,0,NULL,0),(5946,50,'2026-12-12',4,0,0,NULL,0),(5947,50,'2026-12-13',4,0,0,NULL,0),(5948,50,'2026-12-14',4,0,0,NULL,0),(5949,50,'2026-12-15',4,0,0,NULL,0),(5950,50,'2026-12-16',4,0,0,NULL,0),(5951,50,'2026-12-17',4,0,0,NULL,0),(5952,50,'2026-12-18',4,0,0,NULL,0),(5953,50,'2026-12-19',4,0,0,NULL,0),(5954,50,'2026-12-20',4,0,0,NULL,0),(5955,50,'2026-12-21',4,0,0,NULL,0),(5956,50,'2026-12-22',4,0,0,NULL,0),(5957,50,'2026-12-23',4,0,0,NULL,0),(5958,50,'2026-12-24',4,0,0,NULL,0),(5959,50,'2026-12-25',4,0,0,NULL,0),(5960,50,'2026-12-26',4,0,0,NULL,0),(5961,50,'2026-12-27',4,0,0,NULL,0),(5962,50,'2026-12-28',4,0,0,NULL,0),(5963,50,'2026-12-29',4,0,0,NULL,0),(5964,50,'2026-12-30',4,0,0,NULL,0),(5965,50,'2026-12-31',4,0,0,NULL,0),(5966,50,'2027-01-01',4,0,0,NULL,0),(5967,50,'2027-01-02',4,0,0,NULL,0),(5968,50,'2027-01-03',4,0,0,NULL,0),(5969,50,'2027-01-04',4,0,0,NULL,0),(5970,50,'2027-01-05',4,0,0,NULL,0),(5971,50,'2027-01-06',4,0,0,NULL,0),(5972,50,'2027-01-07',4,0,0,NULL,0),(5973,50,'2027-01-08',4,0,0,NULL,0),(5974,50,'2027-01-09',4,0,0,NULL,0),(5975,50,'2027-01-10',4,0,0,NULL,0),(5976,50,'2027-01-11',4,0,0,NULL,0),(5977,50,'2027-01-12',4,0,0,NULL,0),(5978,50,'2027-01-13',4,0,0,NULL,0),(5979,50,'2027-01-14',4,0,0,NULL,0),(5980,50,'2027-01-15',4,0,0,NULL,0),(5981,50,'2027-01-16',4,0,0,NULL,0),(5982,50,'2027-01-17',4,0,0,NULL,0),(5983,50,'2027-01-18',4,0,0,NULL,0),(5984,50,'2027-01-19',4,0,0,NULL,0),(5985,50,'2027-01-20',4,0,0,NULL,0),(5986,50,'2027-01-21',4,0,0,NULL,0),(5987,50,'2027-01-22',4,0,0,NULL,0),(5988,50,'2027-01-23',4,0,0,NULL,0),(5989,50,'2027-01-24',4,0,0,NULL,0),(5990,50,'2027-01-25',4,0,0,NULL,0),(5991,50,'2027-01-26',4,0,0,NULL,0),(5992,50,'2027-01-27',4,0,0,NULL,0),(5993,50,'2027-01-28',4,0,0,NULL,0),(5994,50,'2027-01-29',4,0,0,NULL,0),(5995,50,'2027-01-30',4,0,0,NULL,0),(5996,50,'2027-01-31',4,0,0,NULL,0),(5997,50,'2027-02-01',4,0,0,NULL,0),(5998,50,'2027-02-02',4,0,0,NULL,0),(5999,50,'2027-02-03',4,0,0,NULL,0),(6000,50,'2027-02-04',4,0,0,NULL,0),(6001,51,'2026-10-08',2,0,0,NULL,0),(6002,51,'2026-10-09',2,0,0,NULL,0),(6003,51,'2026-10-10',2,0,0,NULL,0),(6004,51,'2026-10-11',2,0,0,NULL,0),(6005,51,'2026-10-12',2,0,0,NULL,0),(6006,51,'2026-10-13',2,0,0,NULL,0),(6007,51,'2026-10-14',2,0,0,NULL,0),(6008,51,'2026-10-15',2,0,0,NULL,0),(6009,51,'2026-10-16',2,0,0,NULL,0),(6010,51,'2026-10-17',2,0,0,NULL,0),(6011,51,'2026-10-18',2,0,0,NULL,0),(6012,51,'2026-10-19',2,0,0,NULL,0),(6013,51,'2026-10-20',2,0,0,NULL,0),(6014,51,'2026-10-21',2,0,0,NULL,0),(6015,51,'2026-10-22',2,0,0,NULL,0),(6016,51,'2026-10-23',2,0,0,NULL,0),(6017,51,'2026-10-24',2,0,0,NULL,0),(6018,51,'2026-10-25',2,0,0,NULL,0),(6019,51,'2026-10-26',2,0,0,NULL,0),(6020,51,'2026-10-27',2,0,0,NULL,0),(6021,51,'2026-10-28',2,0,0,NULL,0),(6022,51,'2026-10-29',2,0,0,NULL,0),(6023,51,'2026-10-30',2,0,0,NULL,0),(6024,51,'2026-10-31',2,0,0,NULL,0),(6025,51,'2026-11-01',2,0,0,NULL,0),(6026,51,'2026-11-02',2,0,0,NULL,0),(6027,51,'2026-11-03',2,0,0,NULL,0),(6028,51,'2026-11-04',2,0,0,NULL,0),(6029,51,'2026-11-05',2,0,0,NULL,0),(6030,51,'2026-11-06',2,0,0,NULL,0),(6031,51,'2026-11-07',2,0,0,NULL,0),(6032,51,'2026-11-08',2,0,0,NULL,0),(6033,51,'2026-11-09',2,0,0,NULL,0),(6034,51,'2026-11-10',2,0,0,NULL,0),(6035,51,'2026-11-11',2,0,0,NULL,0),(6036,51,'2026-11-12',2,0,0,NULL,0),(6037,51,'2026-11-13',2,0,0,NULL,0),(6038,51,'2026-11-14',2,0,0,NULL,0),(6039,51,'2026-11-15',2,0,0,NULL,0),(6040,51,'2026-11-16',2,0,0,NULL,0),(6041,51,'2026-11-17',2,0,0,NULL,0),(6042,51,'2026-11-18',2,0,0,NULL,0),(6043,51,'2026-11-19',2,0,0,NULL,0),(6044,51,'2026-11-20',2,0,0,NULL,0),(6045,51,'2026-11-21',2,0,0,NULL,0),(6046,51,'2026-11-22',2,0,0,NULL,0),(6047,51,'2026-11-23',2,0,0,NULL,0),(6048,51,'2026-11-24',2,0,0,NULL,0),(6049,51,'2026-11-25',2,0,0,NULL,0),(6050,51,'2026-11-26',2,0,0,NULL,0),(6051,51,'2026-11-27',2,0,0,NULL,0),(6052,51,'2026-11-28',2,0,0,NULL,0),(6053,51,'2026-11-29',2,0,0,NULL,0),(6054,51,'2026-11-30',2,0,0,NULL,0),(6055,51,'2026-12-01',2,0,0,NULL,0),(6056,51,'2026-12-02',2,0,0,NULL,0),(6057,51,'2026-12-03',2,0,0,NULL,0),(6058,51,'2026-12-04',2,0,0,NULL,0),(6059,51,'2026-12-05',2,0,0,NULL,0),(6060,51,'2026-12-06',2,0,0,NULL,0),(6061,51,'2026-12-07',2,0,0,NULL,0),(6062,51,'2026-12-08',2,0,0,NULL,0),(6063,51,'2026-12-09',2,0,0,NULL,0),(6064,51,'2026-12-10',2,0,0,NULL,0),(6065,51,'2026-12-11',2,0,0,NULL,0),(6066,51,'2026-12-12',2,0,0,NULL,0),(6067,51,'2026-12-13',2,0,0,NULL,0),(6068,51,'2026-12-14',2,0,0,NULL,0),(6069,51,'2026-12-15',2,0,0,NULL,0),(6070,51,'2026-12-16',2,0,0,NULL,0),(6071,51,'2026-12-17',2,0,0,NULL,0),(6072,51,'2026-12-18',2,0,0,NULL,0),(6073,51,'2026-12-19',2,0,0,NULL,0),(6074,51,'2026-12-20',2,0,0,NULL,0),(6075,51,'2026-12-21',2,0,0,NULL,0),(6076,51,'2026-12-22',2,0,0,NULL,0),(6077,51,'2026-12-23',2,0,0,NULL,0),(6078,51,'2026-12-24',2,0,0,NULL,0),(6079,51,'2026-12-25',2,0,0,NULL,0),(6080,51,'2026-12-26',2,0,0,NULL,0),(6081,51,'2026-12-27',2,0,0,NULL,0),(6082,51,'2026-12-28',2,0,0,NULL,0),(6083,51,'2026-12-29',2,0,0,NULL,0),(6084,51,'2026-12-30',2,0,0,NULL,0),(6085,51,'2026-12-31',2,0,0,NULL,0),(6086,51,'2027-01-01',2,0,0,NULL,0),(6087,51,'2027-01-02',2,0,0,NULL,0),(6088,51,'2027-01-03',2,0,0,NULL,0),(6089,51,'2027-01-04',2,0,0,NULL,0),(6090,51,'2027-01-05',2,0,0,NULL,0),(6091,51,'2027-01-06',2,0,0,NULL,0),(6092,51,'2027-01-07',2,0,0,NULL,0),(6093,51,'2027-01-08',2,0,0,NULL,0),(6094,51,'2027-01-09',2,0,0,NULL,0),(6095,51,'2027-01-10',2,0,0,NULL,0),(6096,51,'2027-01-11',2,0,0,NULL,0),(6097,51,'2027-01-12',2,0,0,NULL,0),(6098,51,'2027-01-13',2,0,0,NULL,0),(6099,51,'2027-01-14',2,0,0,NULL,0),(6100,51,'2027-01-15',2,0,0,NULL,0),(6101,51,'2027-01-16',2,0,0,NULL,0),(6102,51,'2027-01-17',2,0,0,NULL,0),(6103,51,'2027-01-18',2,0,0,NULL,0),(6104,51,'2027-01-19',2,0,0,NULL,0),(6105,51,'2027-01-20',2,0,0,NULL,0),(6106,51,'2027-01-21',2,0,0,NULL,0),(6107,51,'2027-01-22',2,0,0,NULL,0),(6108,51,'2027-01-23',2,0,0,NULL,0),(6109,51,'2027-01-24',2,0,0,NULL,0),(6110,51,'2027-01-25',2,0,0,NULL,0),(6111,51,'2027-01-26',2,0,0,NULL,0),(6112,51,'2027-01-27',2,0,0,NULL,0),(6113,51,'2027-01-28',2,0,0,NULL,0),(6114,51,'2027-01-29',2,0,0,NULL,0),(6115,51,'2027-01-30',2,0,0,NULL,0),(6116,51,'2027-01-31',2,0,0,NULL,0),(6117,51,'2027-02-01',2,0,0,NULL,0),(6118,51,'2027-02-02',2,0,0,NULL,0),(6119,51,'2027-02-03',2,0,0,NULL,0),(6120,51,'2027-02-04',2,0,0,NULL,0),(6121,52,'2026-10-08',5,0,0,NULL,0),(6122,52,'2026-10-09',5,0,0,NULL,0),(6123,52,'2026-10-10',5,0,0,NULL,0),(6124,52,'2026-10-11',5,0,0,NULL,0),(6125,52,'2026-10-12',5,0,0,NULL,0),(6126,52,'2026-10-13',5,0,0,NULL,0),(6127,52,'2026-10-14',5,0,0,NULL,0),(6128,52,'2026-10-15',5,0,0,NULL,0),(6129,52,'2026-10-16',5,0,0,NULL,0),(6130,52,'2026-10-17',5,1,0,NULL,0),(6131,52,'2026-10-18',5,1,0,NULL,0),(6132,52,'2026-10-19',5,0,0,NULL,0),(6133,52,'2026-10-20',5,0,0,NULL,0),(6134,52,'2026-10-21',5,0,0,NULL,0),(6135,52,'2026-10-22',5,0,0,NULL,0),(6136,52,'2026-10-23',5,0,0,NULL,0),(6137,52,'2026-10-24',5,0,0,NULL,0),(6138,52,'2026-10-25',5,0,0,NULL,0),(6139,52,'2026-10-26',5,0,0,NULL,0),(6140,52,'2026-10-27',5,0,0,NULL,0),(6141,52,'2026-10-28',5,0,0,NULL,0),(6142,52,'2026-10-29',5,0,0,NULL,0),(6143,52,'2026-10-30',5,0,0,NULL,0),(6144,52,'2026-10-31',5,0,0,NULL,0),(6145,52,'2026-11-01',5,0,0,NULL,0),(6146,52,'2026-11-02',5,0,0,NULL,0),(6147,52,'2026-11-03',5,0,0,NULL,0),(6148,52,'2026-11-04',5,0,0,NULL,0),(6149,52,'2026-11-05',5,0,0,NULL,0),(6150,52,'2026-11-06',5,0,0,NULL,0),(6151,52,'2026-11-07',5,0,0,NULL,0),(6152,52,'2026-11-08',5,0,0,NULL,0),(6153,52,'2026-11-09',5,0,0,NULL,0),(6154,52,'2026-11-10',5,0,0,NULL,0),(6155,52,'2026-11-11',5,1,0,NULL,0),(6156,52,'2026-11-12',5,1,0,NULL,0),(6157,52,'2026-11-13',5,0,0,NULL,0),(6158,52,'2026-11-14',5,0,0,NULL,0),(6159,52,'2026-11-15',5,0,0,NULL,0),(6160,52,'2026-11-16',5,0,0,NULL,0),(6161,52,'2026-11-17',5,0,0,NULL,0),(6162,52,'2026-11-18',5,0,0,NULL,0),(6163,52,'2026-11-19',5,0,0,NULL,0),(6164,52,'2026-11-20',5,0,0,NULL,0),(6165,52,'2026-11-21',5,0,0,NULL,0),(6166,52,'2026-11-22',5,0,0,NULL,0),(6167,52,'2026-11-23',5,0,0,NULL,0),(6168,52,'2026-11-24',5,0,0,NULL,0),(6169,52,'2026-11-25',5,0,0,NULL,0),(6170,52,'2026-11-26',5,0,0,NULL,0),(6171,52,'2026-11-27',5,0,0,NULL,0),(6172,52,'2026-11-28',5,0,0,NULL,0),(6173,52,'2026-11-29',5,0,0,NULL,0),(6174,52,'2026-11-30',5,0,0,NULL,0),(6175,52,'2026-12-01',5,0,0,NULL,0),(6176,52,'2026-12-02',5,0,0,NULL,0),(6177,52,'2026-12-03',5,0,0,NULL,0),(6178,52,'2026-12-04',5,0,0,NULL,0),(6179,52,'2026-12-05',5,0,0,NULL,0),(6180,52,'2026-12-06',5,0,0,NULL,0),(6181,52,'2026-12-07',5,0,0,NULL,0),(6182,52,'2026-12-08',5,0,0,NULL,0),(6183,52,'2026-12-09',5,0,0,NULL,0),(6184,52,'2026-12-10',5,0,0,NULL,0),(6185,52,'2026-12-11',5,0,0,NULL,0),(6186,52,'2026-12-12',5,0,0,NULL,0),(6187,52,'2026-12-13',5,0,0,NULL,0),(6188,52,'2026-12-14',5,0,0,NULL,0),(6189,52,'2026-12-15',5,0,0,NULL,0),(6190,52,'2026-12-16',5,0,0,NULL,0),(6191,52,'2026-12-17',5,0,0,NULL,0),(6192,52,'2026-12-18',5,0,0,NULL,0),(6193,52,'2026-12-19',5,0,0,NULL,0),(6194,52,'2026-12-20',5,0,0,NULL,0),(6195,52,'2026-12-21',5,0,0,NULL,0),(6196,52,'2026-12-22',5,0,0,NULL,0),(6197,52,'2026-12-23',5,0,0,NULL,0),(6198,52,'2026-12-24',5,0,0,NULL,0),(6199,52,'2026-12-25',5,0,0,NULL,0),(6200,52,'2026-12-26',5,0,0,NULL,0),(6201,52,'2026-12-27',5,0,0,NULL,0),(6202,52,'2026-12-28',5,0,0,NULL,0),(6203,52,'2026-12-29',5,0,0,NULL,0),(6204,52,'2026-12-30',5,0,0,NULL,0),(6205,52,'2026-12-31',5,0,0,NULL,0),(6206,52,'2027-01-01',5,0,0,NULL,0),(6207,52,'2027-01-02',5,0,0,NULL,0),(6208,52,'2027-01-03',5,0,0,NULL,0),(6209,52,'2027-01-04',5,0,0,NULL,0),(6210,52,'2027-01-05',5,0,0,NULL,0),(6211,52,'2027-01-06',5,0,0,NULL,0),(6212,52,'2027-01-07',5,0,0,NULL,0),(6213,52,'2027-01-08',5,0,0,NULL,0),(6214,52,'2027-01-09',5,0,0,NULL,0),(6215,52,'2027-01-10',5,0,0,NULL,0),(6216,52,'2027-01-11',5,0,0,NULL,0),(6217,52,'2027-01-12',5,0,0,NULL,0),(6218,52,'2027-01-13',5,0,0,NULL,0),(6219,52,'2027-01-14',5,0,0,NULL,0),(6220,52,'2027-01-15',5,0,0,NULL,0),(6221,52,'2027-01-16',5,0,0,NULL,0),(6222,52,'2027-01-17',5,0,0,NULL,0),(6223,52,'2027-01-18',5,0,0,NULL,0),(6224,52,'2027-01-19',5,0,0,NULL,0),(6225,52,'2027-01-20',5,0,0,NULL,0),(6226,52,'2027-01-21',5,0,0,NULL,0),(6227,52,'2027-01-22',5,0,0,NULL,0),(6228,52,'2027-01-23',5,0,0,NULL,0),(6229,52,'2027-01-24',5,0,0,NULL,0),(6230,52,'2027-01-25',5,0,0,NULL,0),(6231,52,'2027-01-26',5,0,0,NULL,0),(6232,52,'2027-01-27',5,0,0,NULL,0),(6233,52,'2027-01-28',5,0,0,NULL,0),(6234,52,'2027-01-29',5,0,0,NULL,0),(6235,52,'2027-01-30',5,0,0,NULL,0),(6236,52,'2027-01-31',5,0,0,NULL,0),(6237,52,'2027-02-01',5,0,0,NULL,0),(6238,52,'2027-02-02',5,0,0,NULL,0),(6239,52,'2027-02-03',5,0,0,NULL,0),(6240,52,'2027-02-04',5,0,0,NULL,0),(6241,53,'2026-10-08',3,0,0,NULL,0),(6242,53,'2026-10-09',3,0,0,NULL,0),(6243,53,'2026-10-10',3,0,0,NULL,0),(6244,53,'2026-10-11',3,0,0,NULL,0),(6245,53,'2026-10-12',3,0,0,NULL,0),(6246,53,'2026-10-13',3,0,0,NULL,0),(6247,53,'2026-10-14',3,0,0,NULL,0),(6248,53,'2026-10-15',3,0,0,NULL,0),(6249,53,'2026-10-16',3,0,0,NULL,0),(6250,53,'2026-10-17',3,0,0,NULL,0),(6251,53,'2026-10-18',3,0,0,NULL,0),(6252,53,'2026-10-19',3,0,0,NULL,0),(6253,53,'2026-10-20',3,0,0,NULL,0),(6254,53,'2026-10-21',3,0,0,NULL,0),(6255,53,'2026-10-22',3,0,0,NULL,0),(6256,53,'2026-10-23',3,0,0,NULL,0),(6257,53,'2026-10-24',3,0,0,NULL,0),(6258,53,'2026-10-25',3,0,0,NULL,0),(6259,53,'2026-10-26',3,0,0,NULL,0),(6260,53,'2026-10-27',3,0,0,NULL,0),(6261,53,'2026-10-28',3,0,0,NULL,0),(6262,53,'2026-10-29',3,0,0,NULL,0),(6263,53,'2026-10-30',3,0,0,NULL,0),(6264,53,'2026-10-31',3,0,0,NULL,0),(6265,53,'2026-11-01',3,0,0,NULL,0),(6266,53,'2026-11-02',3,0,0,NULL,0),(6267,53,'2026-11-03',3,0,0,NULL,0),(6268,53,'2026-11-04',3,0,0,NULL,0),(6269,53,'2026-11-05',3,0,0,NULL,0),(6270,53,'2026-11-06',3,0,0,NULL,0),(6271,53,'2026-11-07',3,0,0,NULL,0),(6272,53,'2026-11-08',3,0,0,NULL,0),(6273,53,'2026-11-09',3,0,0,NULL,0),(6274,53,'2026-11-10',3,0,0,NULL,0),(6275,53,'2026-11-11',3,0,0,NULL,0),(6276,53,'2026-11-12',3,0,0,NULL,0),(6277,53,'2026-11-13',3,0,0,NULL,0),(6278,53,'2026-11-14',3,0,0,NULL,0),(6279,53,'2026-11-15',3,0,0,NULL,0),(6280,53,'2026-11-16',3,0,0,NULL,0),(6281,53,'2026-11-17',3,0,0,NULL,0),(6282,53,'2026-11-18',3,0,0,NULL,0),(6283,53,'2026-11-19',3,0,0,NULL,0),(6284,53,'2026-11-20',3,0,0,NULL,0),(6285,53,'2026-11-21',3,0,0,NULL,0),(6286,53,'2026-11-22',3,0,0,NULL,0),(6287,53,'2026-11-23',3,0,0,NULL,0),(6288,53,'2026-11-24',3,0,0,NULL,0),(6289,53,'2026-11-25',3,0,0,NULL,0),(6290,53,'2026-11-26',3,0,0,NULL,0),(6291,53,'2026-11-27',3,0,0,NULL,0),(6292,53,'2026-11-28',3,0,0,NULL,0),(6293,53,'2026-11-29',3,0,0,NULL,0),(6294,53,'2026-11-30',3,0,0,NULL,0),(6295,53,'2026-12-01',3,0,0,NULL,0),(6296,53,'2026-12-02',3,0,0,NULL,0),(6297,53,'2026-12-03',3,0,0,NULL,0),(6298,53,'2026-12-04',3,0,0,NULL,0),(6299,53,'2026-12-05',3,0,0,NULL,0),(6300,53,'2026-12-06',3,0,0,NULL,0),(6301,53,'2026-12-07',3,0,0,NULL,0),(6302,53,'2026-12-08',3,0,0,NULL,0),(6303,53,'2026-12-09',3,0,0,NULL,0),(6304,53,'2026-12-10',3,0,0,NULL,0),(6305,53,'2026-12-11',3,0,0,NULL,0),(6306,53,'2026-12-12',3,0,0,NULL,0),(6307,53,'2026-12-13',3,0,0,NULL,0),(6308,53,'2026-12-14',3,0,0,NULL,0),(6309,53,'2026-12-15',3,0,0,NULL,0),(6310,53,'2026-12-16',3,0,0,NULL,0),(6311,53,'2026-12-17',3,0,0,NULL,0),(6312,53,'2026-12-18',3,0,0,NULL,0),(6313,53,'2026-12-19',3,0,0,NULL,0),(6314,53,'2026-12-20',3,0,0,NULL,0),(6315,53,'2026-12-21',3,0,0,NULL,0),(6316,53,'2026-12-22',3,0,0,NULL,0),(6317,53,'2026-12-23',3,0,0,NULL,0),(6318,53,'2026-12-24',3,0,0,NULL,0),(6319,53,'2026-12-25',3,0,0,NULL,0),(6320,53,'2026-12-26',3,0,0,NULL,0),(6321,53,'2026-12-27',3,0,0,NULL,0),(6322,53,'2026-12-28',3,0,0,NULL,0),(6323,53,'2026-12-29',3,0,0,NULL,0),(6324,53,'2026-12-30',3,0,0,NULL,0),(6325,53,'2026-12-31',3,0,0,NULL,0),(6326,53,'2027-01-01',3,0,0,NULL,0),(6327,53,'2027-01-02',3,0,0,NULL,0),(6328,53,'2027-01-03',3,0,0,NULL,0),(6329,53,'2027-01-04',3,0,0,NULL,0),(6330,53,'2027-01-05',3,0,0,NULL,0),(6331,53,'2027-01-06',3,0,0,NULL,0),(6332,53,'2027-01-07',3,0,0,NULL,0),(6333,53,'2027-01-08',3,0,0,NULL,0),(6334,53,'2027-01-09',3,0,0,NULL,0),(6335,53,'2027-01-10',3,0,0,NULL,0),(6336,53,'2027-01-11',3,0,0,NULL,0),(6337,53,'2027-01-12',3,0,0,NULL,0),(6338,53,'2027-01-13',3,0,0,NULL,0),(6339,53,'2027-01-14',3,0,0,NULL,0),(6340,53,'2027-01-15',3,0,0,NULL,0),(6341,53,'2027-01-16',3,0,0,NULL,0),(6342,53,'2027-01-17',3,0,0,NULL,0),(6343,53,'2027-01-18',3,0,0,NULL,0),(6344,53,'2027-01-19',3,0,0,NULL,0),(6345,53,'2027-01-20',3,0,0,NULL,0),(6346,53,'2027-01-21',3,0,0,NULL,0),(6347,53,'2027-01-22',3,0,0,NULL,0),(6348,53,'2027-01-23',3,0,0,NULL,0),(6349,53,'2027-01-24',3,0,0,NULL,0),(6350,53,'2027-01-25',3,0,0,NULL,0),(6351,53,'2027-01-26',3,0,0,NULL,0),(6352,53,'2027-01-27',3,0,0,NULL,0),(6353,53,'2027-01-28',3,0,0,NULL,0),(6354,53,'2027-01-29',3,0,0,NULL,0),(6355,53,'2027-01-30',3,0,0,NULL,0),(6356,53,'2027-01-31',3,0,0,NULL,0),(6357,53,'2027-02-01',3,0,0,NULL,0),(6358,53,'2027-02-02',3,0,0,NULL,0),(6359,53,'2027-02-03',3,0,0,NULL,0),(6360,53,'2027-02-04',3,0,0,NULL,0),(6361,54,'2026-10-08',6,0,0,NULL,0),(6362,54,'2026-10-09',6,0,0,NULL,0),(6363,54,'2026-10-10',6,0,0,NULL,0),(6364,54,'2026-10-11',6,0,0,NULL,0),(6365,54,'2026-10-12',6,0,0,NULL,0),(6366,54,'2026-10-13',6,0,0,NULL,0),(6367,54,'2026-10-14',6,0,0,NULL,0),(6368,54,'2026-10-15',6,0,0,NULL,0),(6369,54,'2026-10-16',6,0,0,NULL,0),(6370,54,'2026-10-17',6,0,0,NULL,0),(6371,54,'2026-10-18',6,0,0,NULL,0),(6372,54,'2026-10-19',6,0,0,NULL,0),(6373,54,'2026-10-20',6,0,0,NULL,0),(6374,54,'2026-10-21',6,0,0,NULL,0),(6375,54,'2026-10-22',6,0,0,NULL,0),(6376,54,'2026-10-23',6,0,0,NULL,0),(6377,54,'2026-10-24',6,0,0,NULL,0),(6378,54,'2026-10-25',6,0,0,NULL,0),(6379,54,'2026-10-26',6,0,0,NULL,0),(6380,54,'2026-10-27',6,0,0,NULL,0),(6381,54,'2026-10-28',6,0,0,NULL,0),(6382,54,'2026-10-29',6,0,0,NULL,0),(6383,54,'2026-10-30',6,0,0,NULL,0),(6384,54,'2026-10-31',6,0,0,NULL,0),(6385,54,'2026-11-01',6,0,0,NULL,0),(6386,54,'2026-11-02',6,0,0,NULL,0),(6387,54,'2026-11-03',6,0,0,NULL,0),(6388,54,'2026-11-04',6,0,0,NULL,0),(6389,54,'2026-11-05',6,0,0,NULL,0),(6390,54,'2026-11-06',6,0,0,NULL,0),(6391,54,'2026-11-07',6,0,0,NULL,0),(6392,54,'2026-11-08',6,0,0,NULL,0),(6393,54,'2026-11-09',6,0,0,NULL,0),(6394,54,'2026-11-10',6,0,0,NULL,0),(6395,54,'2026-11-11',6,0,0,NULL,0),(6396,54,'2026-11-12',6,0,0,NULL,0),(6397,54,'2026-11-13',6,0,0,NULL,0),(6398,54,'2026-11-14',6,0,0,NULL,0),(6399,54,'2026-11-15',6,0,0,NULL,0),(6400,54,'2026-11-16',6,0,0,NULL,0),(6401,54,'2026-11-17',6,0,0,NULL,0),(6402,54,'2026-11-18',6,0,0,NULL,0),(6403,54,'2026-11-19',6,0,0,NULL,0),(6404,54,'2026-11-20',6,0,0,NULL,0),(6405,54,'2026-11-21',6,0,0,NULL,0),(6406,54,'2026-11-22',6,0,0,NULL,0),(6407,54,'2026-11-23',6,0,0,NULL,0),(6408,54,'2026-11-24',6,0,0,NULL,0),(6409,54,'2026-11-25',6,0,0,NULL,0),(6410,54,'2026-11-26',6,0,0,NULL,0),(6411,54,'2026-11-27',6,0,0,NULL,0),(6412,54,'2026-11-28',6,0,0,NULL,0),(6413,54,'2026-11-29',6,0,0,NULL,0),(6414,54,'2026-11-30',6,0,0,NULL,0),(6415,54,'2026-12-01',6,0,0,NULL,0),(6416,54,'2026-12-02',6,0,0,NULL,0),(6417,54,'2026-12-03',6,0,0,NULL,0),(6418,54,'2026-12-04',6,0,0,NULL,0),(6419,54,'2026-12-05',6,0,0,NULL,0),(6420,54,'2026-12-06',6,0,0,NULL,0),(6421,54,'2026-12-07',6,0,0,NULL,0),(6422,54,'2026-12-08',6,0,0,NULL,0),(6423,54,'2026-12-09',6,0,0,NULL,0),(6424,54,'2026-12-10',6,0,0,NULL,0),(6425,54,'2026-12-11',6,0,0,NULL,0),(6426,54,'2026-12-12',6,0,0,NULL,0),(6427,54,'2026-12-13',6,0,0,NULL,0),(6428,54,'2026-12-14',6,0,0,NULL,0),(6429,54,'2026-12-15',6,0,0,NULL,0),(6430,54,'2026-12-16',6,0,0,NULL,0),(6431,54,'2026-12-17',6,0,0,NULL,0),(6432,54,'2026-12-18',6,0,0,NULL,0),(6433,54,'2026-12-19',6,0,0,NULL,0),(6434,54,'2026-12-20',6,0,0,NULL,0),(6435,54,'2026-12-21',6,0,0,NULL,0),(6436,54,'2026-12-22',6,0,0,NULL,0),(6437,54,'2026-12-23',6,0,0,NULL,0),(6438,54,'2026-12-24',6,0,0,NULL,0),(6439,54,'2026-12-25',6,0,0,NULL,0),(6440,54,'2026-12-26',6,0,0,NULL,0),(6441,54,'2026-12-27',6,0,0,NULL,0),(6442,54,'2026-12-28',6,0,0,NULL,0),(6443,54,'2026-12-29',6,0,0,NULL,0),(6444,54,'2026-12-30',6,0,0,NULL,0),(6445,54,'2026-12-31',6,0,0,NULL,0),(6446,54,'2027-01-01',6,0,0,NULL,0),(6447,54,'2027-01-02',6,0,0,NULL,0),(6448,54,'2027-01-03',6,0,0,NULL,0),(6449,54,'2027-01-04',6,0,0,NULL,0),(6450,54,'2027-01-05',6,0,0,NULL,0),(6451,54,'2027-01-06',6,0,0,NULL,0),(6452,54,'2027-01-07',6,0,0,NULL,0),(6453,54,'2027-01-08',6,0,0,NULL,0),(6454,54,'2027-01-09',6,0,0,NULL,0),(6455,54,'2027-01-10',6,0,0,NULL,0),(6456,54,'2027-01-11',6,0,0,NULL,0),(6457,54,'2027-01-12',6,0,0,NULL,0),(6458,54,'2027-01-13',6,0,0,NULL,0),(6459,54,'2027-01-14',6,0,0,NULL,0),(6460,54,'2027-01-15',6,0,0,NULL,0),(6461,54,'2027-01-16',6,0,0,NULL,0),(6462,54,'2027-01-17',6,0,0,NULL,0),(6463,54,'2027-01-18',6,0,0,NULL,0),(6464,54,'2027-01-19',6,0,0,NULL,0),(6465,54,'2027-01-20',6,0,0,NULL,0),(6466,54,'2027-01-21',6,0,0,NULL,0),(6467,54,'2027-01-22',6,0,0,NULL,0),(6468,54,'2027-01-23',6,0,0,NULL,0),(6469,54,'2027-01-24',6,0,0,NULL,0),(6470,54,'2027-01-25',6,0,0,NULL,0),(6471,54,'2027-01-26',6,0,0,NULL,0),(6472,54,'2027-01-27',6,0,0,NULL,0),(6473,54,'2027-01-28',6,0,0,NULL,0),(6474,54,'2027-01-29',6,0,0,NULL,0),(6475,54,'2027-01-30',6,0,0,NULL,0),(6476,54,'2027-01-31',6,0,0,NULL,0),(6477,54,'2027-02-01',6,0,0,NULL,0),(6478,54,'2027-02-02',6,0,0,NULL,0),(6479,54,'2027-02-03',6,0,0,NULL,0),(6480,54,'2027-02-04',6,0,0,NULL,0),(6481,55,'2026-10-08',3,0,0,NULL,0),(6482,55,'2026-10-09',3,0,0,NULL,0),(6483,55,'2026-10-10',3,0,0,NULL,0),(6484,55,'2026-10-11',3,0,0,NULL,0),(6485,55,'2026-10-12',3,0,0,NULL,0),(6486,55,'2026-10-13',3,0,0,NULL,0),(6487,55,'2026-10-14',3,0,0,NULL,0),(6488,55,'2026-10-15',3,0,0,NULL,0),(6489,55,'2026-10-16',3,0,0,NULL,0),(6490,55,'2026-10-17',3,0,0,NULL,0),(6491,55,'2026-10-18',3,0,0,NULL,0),(6492,55,'2026-10-19',3,0,0,NULL,0),(6493,55,'2026-10-20',3,0,0,NULL,0),(6494,55,'2026-10-21',3,0,0,NULL,0),(6495,55,'2026-10-22',3,0,0,NULL,0),(6496,55,'2026-10-23',3,0,0,NULL,0),(6497,55,'2026-10-24',3,0,0,NULL,0),(6498,55,'2026-10-25',3,0,0,NULL,0),(6499,55,'2026-10-26',3,0,0,NULL,0),(6500,55,'2026-10-27',3,0,0,NULL,0),(6501,55,'2026-10-28',3,0,0,NULL,0),(6502,55,'2026-10-29',3,0,0,NULL,0),(6503,55,'2026-10-30',3,0,0,NULL,0),(6504,55,'2026-10-31',3,0,0,NULL,0),(6505,55,'2026-11-01',3,0,0,NULL,0),(6506,55,'2026-11-02',3,0,0,NULL,0),(6507,55,'2026-11-03',3,0,0,NULL,0),(6508,55,'2026-11-04',3,0,0,NULL,0),(6509,55,'2026-11-05',3,0,0,NULL,0),(6510,55,'2026-11-06',3,0,0,NULL,0),(6511,55,'2026-11-07',3,0,0,NULL,0),(6512,55,'2026-11-08',3,0,0,NULL,0),(6513,55,'2026-11-09',3,0,0,NULL,0),(6514,55,'2026-11-10',3,0,0,NULL,0),(6515,55,'2026-11-11',3,0,0,NULL,0),(6516,55,'2026-11-12',3,0,0,NULL,0),(6517,55,'2026-11-13',3,0,0,NULL,0),(6518,55,'2026-11-14',3,0,0,NULL,0),(6519,55,'2026-11-15',3,0,0,NULL,0),(6520,55,'2026-11-16',3,0,0,NULL,0),(6521,55,'2026-11-17',3,0,0,NULL,0),(6522,55,'2026-11-18',3,0,0,NULL,0),(6523,55,'2026-11-19',3,0,0,NULL,0),(6524,55,'2026-11-20',3,0,0,NULL,0),(6525,55,'2026-11-21',3,0,0,NULL,0),(6526,55,'2026-11-22',3,0,0,NULL,0),(6527,55,'2026-11-23',3,0,0,NULL,0),(6528,55,'2026-11-24',3,0,0,NULL,0),(6529,55,'2026-11-25',3,0,0,NULL,0),(6530,55,'2026-11-26',3,0,0,NULL,0),(6531,55,'2026-11-27',3,0,0,NULL,0),(6532,55,'2026-11-28',3,0,0,NULL,0),(6533,55,'2026-11-29',3,0,0,NULL,0),(6534,55,'2026-11-30',3,0,0,NULL,0),(6535,55,'2026-12-01',3,0,0,NULL,0),(6536,55,'2026-12-02',3,0,0,NULL,0),(6537,55,'2026-12-03',3,0,0,NULL,0),(6538,55,'2026-12-04',3,0,0,NULL,0),(6539,55,'2026-12-05',3,0,0,NULL,0),(6540,55,'2026-12-06',3,0,0,NULL,0),(6541,55,'2026-12-07',3,0,0,NULL,0),(6542,55,'2026-12-08',3,0,0,NULL,0),(6543,55,'2026-12-09',3,0,0,NULL,0),(6544,55,'2026-12-10',3,0,0,NULL,0),(6545,55,'2026-12-11',3,0,0,NULL,0),(6546,55,'2026-12-12',3,0,0,NULL,0),(6547,55,'2026-12-13',3,0,0,NULL,0),(6548,55,'2026-12-14',3,0,0,NULL,0),(6549,55,'2026-12-15',3,0,0,NULL,0),(6550,55,'2026-12-16',3,0,0,NULL,0),(6551,55,'2026-12-17',3,0,0,NULL,0),(6552,55,'2026-12-18',3,0,0,NULL,0),(6553,55,'2026-12-19',3,0,0,NULL,0),(6554,55,'2026-12-20',3,0,0,NULL,0),(6555,55,'2026-12-21',3,0,0,NULL,0),(6556,55,'2026-12-22',3,0,0,NULL,0),(6557,55,'2026-12-23',3,0,0,NULL,0),(6558,55,'2026-12-24',3,0,0,NULL,0),(6559,55,'2026-12-25',3,0,0,NULL,0),(6560,55,'2026-12-26',3,0,0,NULL,0),(6561,55,'2026-12-27',3,0,0,NULL,0),(6562,55,'2026-12-28',3,0,0,NULL,0),(6563,55,'2026-12-29',3,0,0,NULL,0),(6564,55,'2026-12-30',3,0,0,NULL,0),(6565,55,'2026-12-31',3,0,0,NULL,0),(6566,55,'2027-01-01',3,0,0,NULL,0),(6567,55,'2027-01-02',3,0,0,NULL,0),(6568,55,'2027-01-03',3,0,0,NULL,0),(6569,55,'2027-01-04',3,0,0,NULL,0),(6570,55,'2027-01-05',3,0,0,NULL,0),(6571,55,'2027-01-06',3,0,0,NULL,0),(6572,55,'2027-01-07',3,0,0,NULL,0),(6573,55,'2027-01-08',3,0,0,NULL,0),(6574,55,'2027-01-09',3,0,0,NULL,0),(6575,55,'2027-01-10',3,0,0,NULL,0),(6576,55,'2027-01-11',3,0,0,NULL,0),(6577,55,'2027-01-12',3,0,0,NULL,0),(6578,55,'2027-01-13',3,0,0,NULL,0),(6579,55,'2027-01-14',3,0,0,NULL,0),(6580,55,'2027-01-15',3,0,0,NULL,0),(6581,55,'2027-01-16',3,0,0,NULL,0),(6582,55,'2027-01-17',3,0,0,NULL,0),(6583,55,'2027-01-18',3,0,0,NULL,0),(6584,55,'2027-01-19',3,0,0,NULL,0),(6585,55,'2027-01-20',3,0,0,NULL,0),(6586,55,'2027-01-21',3,0,0,NULL,0),(6587,55,'2027-01-22',3,0,0,NULL,0),(6588,55,'2027-01-23',3,0,0,NULL,0),(6589,55,'2027-01-24',3,0,0,NULL,0),(6590,55,'2027-01-25',3,0,0,NULL,0),(6591,55,'2027-01-26',3,0,0,NULL,0),(6592,55,'2027-01-27',3,0,0,NULL,0),(6593,55,'2027-01-28',3,0,0,NULL,0),(6594,55,'2027-01-29',3,0,0,NULL,0),(6595,55,'2027-01-30',3,0,0,NULL,0),(6596,55,'2027-01-31',3,0,0,NULL,0),(6597,55,'2027-02-01',3,0,0,NULL,0),(6598,55,'2027-02-02',3,0,0,NULL,0),(6599,55,'2027-02-03',3,0,0,NULL,0),(6600,55,'2027-02-04',3,0,0,NULL,0),(6601,56,'2026-10-08',10,0,0,NULL,0),(6602,56,'2026-10-09',10,0,0,NULL,0),(6603,56,'2026-10-10',10,0,0,NULL,0),(6604,56,'2026-10-11',10,0,0,NULL,0),(6605,56,'2026-10-12',10,0,0,NULL,0),(6606,56,'2026-10-13',10,0,0,NULL,0),(6607,56,'2026-10-14',10,0,0,NULL,0),(6608,56,'2026-10-15',10,0,0,NULL,0),(6609,56,'2026-10-16',10,0,0,NULL,0),(6610,56,'2026-10-17',10,0,0,NULL,0),(6611,56,'2026-10-18',10,0,0,NULL,0),(6612,56,'2026-10-19',10,0,0,NULL,0),(6613,56,'2026-10-20',10,0,0,NULL,0),(6614,56,'2026-10-21',10,0,0,NULL,0),(6615,56,'2026-10-22',10,0,0,NULL,0),(6616,56,'2026-10-23',10,0,0,NULL,0),(6617,56,'2026-10-24',10,0,0,NULL,0),(6618,56,'2026-10-25',10,0,0,NULL,0),(6619,56,'2026-10-26',10,0,0,NULL,0),(6620,56,'2026-10-27',10,0,0,NULL,0),(6621,56,'2026-10-28',10,0,0,NULL,0),(6622,56,'2026-10-29',10,0,0,NULL,0),(6623,56,'2026-10-30',10,0,0,NULL,0),(6624,56,'2026-10-31',10,0,0,NULL,0),(6625,56,'2026-11-01',10,0,0,NULL,0),(6626,56,'2026-11-02',10,0,0,NULL,0),(6627,56,'2026-11-03',10,0,0,NULL,0),(6628,56,'2026-11-04',10,0,0,NULL,0),(6629,56,'2026-11-05',10,0,0,NULL,0),(6630,56,'2026-11-06',10,0,0,NULL,0),(6631,56,'2026-11-07',10,0,0,NULL,0),(6632,56,'2026-11-08',10,0,0,NULL,0),(6633,56,'2026-11-09',10,0,0,NULL,0),(6634,56,'2026-11-10',10,0,0,NULL,0),(6635,56,'2026-11-11',10,0,0,NULL,0),(6636,56,'2026-11-12',10,0,0,NULL,0),(6637,56,'2026-11-13',10,0,0,NULL,0),(6638,56,'2026-11-14',10,0,0,NULL,0),(6639,56,'2026-11-15',10,0,0,NULL,0),(6640,56,'2026-11-16',10,0,0,NULL,0),(6641,56,'2026-11-17',10,0,0,NULL,0),(6642,56,'2026-11-18',10,0,0,NULL,0),(6643,56,'2026-11-19',10,0,0,NULL,0),(6644,56,'2026-11-20',10,0,0,NULL,0),(6645,56,'2026-11-21',10,0,0,NULL,0),(6646,56,'2026-11-22',10,0,0,NULL,0),(6647,56,'2026-11-23',10,0,0,NULL,0),(6648,56,'2026-11-24',10,0,0,NULL,0),(6649,56,'2026-11-25',10,0,0,NULL,0),(6650,56,'2026-11-26',10,0,0,NULL,0),(6651,56,'2026-11-27',10,0,0,NULL,0),(6652,56,'2026-11-28',10,0,0,NULL,0),(6653,56,'2026-11-29',10,0,0,NULL,0),(6654,56,'2026-11-30',10,0,0,NULL,0),(6655,56,'2026-12-01',10,0,0,NULL,0),(6656,56,'2026-12-02',10,0,0,NULL,0),(6657,56,'2026-12-03',10,0,0,NULL,0),(6658,56,'2026-12-04',10,0,0,NULL,0),(6659,56,'2026-12-05',10,0,0,NULL,0),(6660,56,'2026-12-06',10,0,0,NULL,0),(6661,56,'2026-12-07',10,0,0,NULL,0),(6662,56,'2026-12-08',10,0,0,NULL,0),(6663,56,'2026-12-09',10,0,0,NULL,0),(6664,56,'2026-12-10',10,0,0,NULL,0),(6665,56,'2026-12-11',10,0,0,NULL,0),(6666,56,'2026-12-12',10,0,0,NULL,0),(6667,56,'2026-12-13',10,0,0,NULL,0),(6668,56,'2026-12-14',10,0,0,NULL,0),(6669,56,'2026-12-15',10,0,0,NULL,0),(6670,56,'2026-12-16',10,0,0,NULL,0),(6671,56,'2026-12-17',10,0,0,NULL,0),(6672,56,'2026-12-18',10,0,0,NULL,0),(6673,56,'2026-12-19',10,0,0,NULL,0),(6674,56,'2026-12-20',10,0,0,NULL,0),(6675,56,'2026-12-21',10,0,0,NULL,0),(6676,56,'2026-12-22',10,0,0,NULL,0),(6677,56,'2026-12-23',10,0,0,NULL,0),(6678,56,'2026-12-24',10,0,0,NULL,0),(6679,56,'2026-12-25',10,0,0,NULL,0),(6680,56,'2026-12-26',10,0,0,NULL,0),(6681,56,'2026-12-27',10,0,0,NULL,0),(6682,56,'2026-12-28',10,0,0,NULL,0),(6683,56,'2026-12-29',10,0,0,NULL,0),(6684,56,'2026-12-30',10,0,0,NULL,0),(6685,56,'2026-12-31',10,0,0,NULL,0),(6686,56,'2027-01-01',10,0,0,NULL,0),(6687,56,'2027-01-02',10,0,0,NULL,0),(6688,56,'2027-01-03',10,0,0,NULL,0),(6689,56,'2027-01-04',10,0,0,NULL,0),(6690,56,'2027-01-05',10,0,0,NULL,0),(6691,56,'2027-01-06',10,0,0,NULL,0),(6692,56,'2027-01-07',10,0,0,NULL,0),(6693,56,'2027-01-08',10,0,0,NULL,0),(6694,56,'2027-01-09',10,0,0,NULL,0),(6695,56,'2027-01-10',10,0,0,NULL,0),(6696,56,'2027-01-11',10,0,0,NULL,0),(6697,56,'2027-01-12',10,0,0,NULL,0),(6698,56,'2027-01-13',10,0,0,NULL,0),(6699,56,'2027-01-14',10,0,0,NULL,0),(6700,56,'2027-01-15',10,0,0,NULL,0),(6701,56,'2027-01-16',10,0,0,NULL,0),(6702,56,'2027-01-17',10,0,0,NULL,0),(6703,56,'2027-01-18',10,0,0,NULL,0),(6704,56,'2027-01-19',10,0,0,NULL,0),(6705,56,'2027-01-20',10,0,0,NULL,0),(6706,56,'2027-01-21',10,0,0,NULL,0),(6707,56,'2027-01-22',10,0,0,NULL,0),(6708,56,'2027-01-23',10,0,0,NULL,0),(6709,56,'2027-01-24',10,0,0,NULL,0),(6710,56,'2027-01-25',10,0,0,NULL,0),(6711,56,'2027-01-26',10,0,0,NULL,0),(6712,56,'2027-01-27',10,0,0,NULL,0),(6713,56,'2027-01-28',10,0,0,NULL,0),(6714,56,'2027-01-29',10,0,0,NULL,0),(6715,56,'2027-01-30',10,0,0,NULL,0),(6716,56,'2027-01-31',10,0,0,NULL,0),(6717,56,'2027-02-01',10,0,0,NULL,0),(6718,56,'2027-02-02',10,0,0,NULL,0),(6719,56,'2027-02-03',10,0,0,NULL,0),(6720,56,'2027-02-04',10,0,0,NULL,0),(6721,57,'2026-10-08',4,0,0,NULL,0),(6722,57,'2026-10-09',4,0,0,NULL,0),(6723,57,'2026-10-10',4,0,0,NULL,0),(6724,57,'2026-10-11',4,0,0,NULL,0),(6725,57,'2026-10-12',4,0,0,NULL,0),(6726,57,'2026-10-13',4,0,0,NULL,0),(6727,57,'2026-10-14',4,0,0,NULL,0),(6728,57,'2026-10-15',4,0,0,NULL,0),(6729,57,'2026-10-16',4,0,0,NULL,0),(6730,57,'2026-10-17',4,0,0,NULL,0),(6731,57,'2026-10-18',4,0,0,NULL,0),(6732,57,'2026-10-19',4,0,0,NULL,0),(6733,57,'2026-10-20',4,0,0,NULL,0),(6734,57,'2026-10-21',4,0,0,NULL,0),(6735,57,'2026-10-22',4,0,0,NULL,0),(6736,57,'2026-10-23',4,0,0,NULL,0),(6737,57,'2026-10-24',4,0,0,NULL,0),(6738,57,'2026-10-25',4,0,0,NULL,0),(6739,57,'2026-10-26',4,0,0,NULL,0),(6740,57,'2026-10-27',4,0,0,NULL,0),(6741,57,'2026-10-28',4,0,0,NULL,0),(6742,57,'2026-10-29',4,0,0,NULL,0),(6743,57,'2026-10-30',4,0,0,NULL,0),(6744,57,'2026-10-31',4,0,0,NULL,0),(6745,57,'2026-11-01',4,0,0,NULL,0),(6746,57,'2026-11-02',4,0,0,NULL,0),(6747,57,'2026-11-03',4,0,0,NULL,0),(6748,57,'2026-11-04',4,0,0,NULL,0),(6749,57,'2026-11-05',4,0,0,NULL,0),(6750,57,'2026-11-06',4,0,0,NULL,0),(6751,57,'2026-11-07',4,0,0,NULL,0),(6752,57,'2026-11-08',4,0,0,NULL,0),(6753,57,'2026-11-09',4,0,0,NULL,0),(6754,57,'2026-11-10',4,0,0,NULL,0),(6755,57,'2026-11-11',4,0,0,NULL,0),(6756,57,'2026-11-12',4,0,0,NULL,0),(6757,57,'2026-11-13',4,0,0,NULL,0),(6758,57,'2026-11-14',4,0,0,NULL,0),(6759,57,'2026-11-15',4,0,0,NULL,0),(6760,57,'2026-11-16',4,0,0,NULL,0),(6761,57,'2026-11-17',4,0,0,NULL,0),(6762,57,'2026-11-18',4,0,0,NULL,0),(6763,57,'2026-11-19',4,0,0,NULL,0),(6764,57,'2026-11-20',4,0,0,NULL,0),(6765,57,'2026-11-21',4,0,0,NULL,0),(6766,57,'2026-11-22',4,0,0,NULL,0),(6767,57,'2026-11-23',4,0,0,NULL,0),(6768,57,'2026-11-24',4,0,0,NULL,0),(6769,57,'2026-11-25',4,0,0,NULL,0),(6770,57,'2026-11-26',4,0,0,NULL,0),(6771,57,'2026-11-27',4,0,0,NULL,0),(6772,57,'2026-11-28',4,0,0,NULL,0),(6773,57,'2026-11-29',4,0,0,NULL,0),(6774,57,'2026-11-30',4,0,0,NULL,0),(6775,57,'2026-12-01',4,0,0,NULL,0),(6776,57,'2026-12-02',4,0,0,NULL,0),(6777,57,'2026-12-03',4,0,0,NULL,0),(6778,57,'2026-12-04',4,0,0,NULL,0),(6779,57,'2026-12-05',4,0,0,NULL,0),(6780,57,'2026-12-06',4,0,0,NULL,0),(6781,57,'2026-12-07',4,0,0,NULL,0),(6782,57,'2026-12-08',4,0,0,NULL,0),(6783,57,'2026-12-09',4,0,0,NULL,0),(6784,57,'2026-12-10',4,0,0,NULL,0),(6785,57,'2026-12-11',4,0,0,NULL,0),(6786,57,'2026-12-12',4,0,0,NULL,0),(6787,57,'2026-12-13',4,0,0,NULL,0),(6788,57,'2026-12-14',4,0,0,NULL,0),(6789,57,'2026-12-15',4,0,0,NULL,0),(6790,57,'2026-12-16',4,0,0,NULL,0),(6791,57,'2026-12-17',4,0,0,NULL,0),(6792,57,'2026-12-18',4,0,0,NULL,0),(6793,57,'2026-12-19',4,0,0,NULL,0),(6794,57,'2026-12-20',4,0,0,NULL,0),(6795,57,'2026-12-21',4,0,0,NULL,0),(6796,57,'2026-12-22',4,0,0,NULL,0),(6797,57,'2026-12-23',4,0,0,NULL,0),(6798,57,'2026-12-24',4,0,0,NULL,0),(6799,57,'2026-12-25',4,0,0,NULL,0),(6800,57,'2026-12-26',4,0,0,NULL,0),(6801,57,'2026-12-27',4,0,0,NULL,0),(6802,57,'2026-12-28',4,0,0,NULL,0),(6803,57,'2026-12-29',4,0,0,NULL,0),(6804,57,'2026-12-30',4,0,0,NULL,0),(6805,57,'2026-12-31',4,0,0,NULL,0),(6806,57,'2027-01-01',4,0,0,NULL,0),(6807,57,'2027-01-02',4,0,0,NULL,0),(6808,57,'2027-01-03',4,0,0,NULL,0),(6809,57,'2027-01-04',4,0,0,NULL,0),(6810,57,'2027-01-05',4,0,0,NULL,0),(6811,57,'2027-01-06',4,0,0,NULL,0),(6812,57,'2027-01-07',4,0,0,NULL,0),(6813,57,'2027-01-08',4,0,0,NULL,0),(6814,57,'2027-01-09',4,0,0,NULL,0),(6815,57,'2027-01-10',4,0,0,NULL,0),(6816,57,'2027-01-11',4,0,0,NULL,0),(6817,57,'2027-01-12',4,0,0,NULL,0),(6818,57,'2027-01-13',4,0,0,NULL,0),(6819,57,'2027-01-14',4,0,0,NULL,0),(6820,57,'2027-01-15',4,0,0,NULL,0),(6821,57,'2027-01-16',4,0,0,NULL,0),(6822,57,'2027-01-17',4,0,0,NULL,0),(6823,57,'2027-01-18',4,0,0,NULL,0),(6824,57,'2027-01-19',4,0,0,NULL,0),(6825,57,'2027-01-20',4,0,0,NULL,0),(6826,57,'2027-01-21',4,0,0,NULL,0),(6827,57,'2027-01-22',4,0,0,NULL,0),(6828,57,'2027-01-23',4,0,0,NULL,0),(6829,57,'2027-01-24',4,0,0,NULL,0),(6830,57,'2027-01-25',4,0,0,NULL,0),(6831,57,'2027-01-26',4,0,0,NULL,0),(6832,57,'2027-01-27',4,0,0,NULL,0),(6833,57,'2027-01-28',4,0,0,NULL,0),(6834,57,'2027-01-29',4,0,0,NULL,0),(6835,57,'2027-01-30',4,0,0,NULL,0),(6836,57,'2027-01-31',4,0,0,NULL,0),(6837,57,'2027-02-01',4,0,0,NULL,0),(6838,57,'2027-02-02',4,0,0,NULL,0),(6839,57,'2027-02-03',4,0,0,NULL,0),(6840,57,'2027-02-04',4,0,0,NULL,0),(6841,58,'2026-10-08',4,0,0,NULL,0),(6842,58,'2026-10-09',4,0,0,NULL,0),(6843,58,'2026-10-10',4,0,0,NULL,0),(6844,58,'2026-10-11',4,0,0,NULL,0),(6845,58,'2026-10-12',4,0,0,NULL,0),(6846,58,'2026-10-13',4,0,0,NULL,0),(6847,58,'2026-10-14',4,0,0,NULL,0),(6848,58,'2026-10-15',4,0,0,NULL,0),(6849,58,'2026-10-16',4,0,0,NULL,0),(6850,58,'2026-10-17',4,0,0,NULL,0),(6851,58,'2026-10-18',4,0,0,NULL,0),(6852,58,'2026-10-19',4,0,0,NULL,0),(6853,58,'2026-10-20',4,0,0,NULL,0),(6854,58,'2026-10-21',4,0,0,NULL,0),(6855,58,'2026-10-22',4,0,0,NULL,0),(6856,58,'2026-10-23',4,0,0,NULL,0),(6857,58,'2026-10-24',4,0,0,NULL,0),(6858,58,'2026-10-25',4,0,0,NULL,0),(6859,58,'2026-10-26',4,0,0,NULL,0),(6860,58,'2026-10-27',4,0,0,NULL,0),(6861,58,'2026-10-28',4,0,0,NULL,0),(6862,58,'2026-10-29',4,0,0,NULL,0),(6863,58,'2026-10-30',4,0,0,NULL,0),(6864,58,'2026-10-31',4,0,0,NULL,0),(6865,58,'2026-11-01',4,0,0,NULL,0),(6866,58,'2026-11-02',4,0,0,NULL,0),(6867,58,'2026-11-03',4,0,0,NULL,0),(6868,58,'2026-11-04',4,0,0,NULL,0),(6869,58,'2026-11-05',4,0,0,NULL,0),(6870,58,'2026-11-06',4,0,0,NULL,0),(6871,58,'2026-11-07',4,0,0,NULL,0),(6872,58,'2026-11-08',4,0,0,NULL,0),(6873,58,'2026-11-09',4,0,0,NULL,0),(6874,58,'2026-11-10',4,0,0,NULL,0),(6875,58,'2026-11-11',4,0,0,NULL,0),(6876,58,'2026-11-12',4,0,0,NULL,0),(6877,58,'2026-11-13',4,0,0,NULL,0),(6878,58,'2026-11-14',4,0,0,NULL,0),(6879,58,'2026-11-15',4,0,0,NULL,0),(6880,58,'2026-11-16',4,0,0,NULL,0),(6881,58,'2026-11-17',4,0,0,NULL,0),(6882,58,'2026-11-18',4,0,0,NULL,0),(6883,58,'2026-11-19',4,0,0,NULL,0),(6884,58,'2026-11-20',4,0,0,NULL,0),(6885,58,'2026-11-21',4,0,0,NULL,0),(6886,58,'2026-11-22',4,0,0,NULL,0),(6887,58,'2026-11-23',4,0,0,NULL,0),(6888,58,'2026-11-24',4,0,0,NULL,0),(6889,58,'2026-11-25',4,0,0,NULL,0),(6890,58,'2026-11-26',4,0,0,NULL,0),(6891,58,'2026-11-27',4,0,0,NULL,0),(6892,58,'2026-11-28',4,0,0,NULL,0),(6893,58,'2026-11-29',4,0,0,NULL,0),(6894,58,'2026-11-30',4,0,0,NULL,0),(6895,58,'2026-12-01',4,0,0,NULL,0),(6896,58,'2026-12-02',4,0,0,NULL,0),(6897,58,'2026-12-03',4,0,0,NULL,0),(6898,58,'2026-12-04',4,0,0,NULL,0),(6899,58,'2026-12-05',4,0,0,NULL,0),(6900,58,'2026-12-06',4,0,0,NULL,0),(6901,58,'2026-12-07',4,0,0,NULL,0),(6902,58,'2026-12-08',4,0,0,NULL,0),(6903,58,'2026-12-09',4,0,0,NULL,0),(6904,58,'2026-12-10',4,0,0,NULL,0),(6905,58,'2026-12-11',4,0,0,NULL,0),(6906,58,'2026-12-12',4,0,0,NULL,0),(6907,58,'2026-12-13',4,0,0,NULL,0),(6908,58,'2026-12-14',4,0,0,NULL,0),(6909,58,'2026-12-15',4,0,0,NULL,0),(6910,58,'2026-12-16',4,0,0,NULL,0),(6911,58,'2026-12-17',4,0,0,NULL,0),(6912,58,'2026-12-18',4,0,0,NULL,0),(6913,58,'2026-12-19',4,0,0,NULL,0),(6914,58,'2026-12-20',4,0,0,NULL,0),(6915,58,'2026-12-21',4,0,0,NULL,0),(6916,58,'2026-12-22',4,0,0,NULL,0),(6917,58,'2026-12-23',4,0,0,NULL,0),(6918,58,'2026-12-24',4,0,0,NULL,0),(6919,58,'2026-12-25',4,0,0,NULL,0),(6920,58,'2026-12-26',4,0,0,NULL,0),(6921,58,'2026-12-27',4,0,0,NULL,0),(6922,58,'2026-12-28',4,0,0,NULL,0),(6923,58,'2026-12-29',4,0,0,NULL,0),(6924,58,'2026-12-30',4,0,0,NULL,0),(6925,58,'2026-12-31',4,0,0,NULL,0),(6926,58,'2027-01-01',4,0,0,NULL,0),(6927,58,'2027-01-02',4,0,0,NULL,0),(6928,58,'2027-01-03',4,0,0,NULL,0),(6929,58,'2027-01-04',4,0,0,NULL,0),(6930,58,'2027-01-05',4,0,0,NULL,0),(6931,58,'2027-01-06',4,0,0,NULL,0),(6932,58,'2027-01-07',4,0,0,NULL,0),(6933,58,'2027-01-08',4,0,0,NULL,0),(6934,58,'2027-01-09',4,0,0,NULL,0),(6935,58,'2027-01-10',4,0,0,NULL,0),(6936,58,'2027-01-11',4,0,0,NULL,0),(6937,58,'2027-01-12',4,0,0,NULL,0),(6938,58,'2027-01-13',4,0,0,NULL,0),(6939,58,'2027-01-14',4,0,0,NULL,0),(6940,58,'2027-01-15',4,0,0,NULL,0),(6941,58,'2027-01-16',4,0,0,NULL,0),(6942,58,'2027-01-17',4,0,0,NULL,0),(6943,58,'2027-01-18',4,0,0,NULL,0),(6944,58,'2027-01-19',4,0,0,NULL,0),(6945,58,'2027-01-20',4,0,0,NULL,0),(6946,58,'2027-01-21',4,0,0,NULL,0),(6947,58,'2027-01-22',4,0,0,NULL,0),(6948,58,'2027-01-23',4,0,0,NULL,0),(6949,58,'2027-01-24',4,0,0,NULL,0),(6950,58,'2027-01-25',4,0,0,NULL,0),(6951,58,'2027-01-26',4,0,0,NULL,0),(6952,58,'2027-01-27',4,0,0,NULL,0),(6953,58,'2027-01-28',4,0,0,NULL,0),(6954,58,'2027-01-29',4,0,0,NULL,0),(6955,58,'2027-01-30',4,0,0,NULL,0),(6956,58,'2027-01-31',4,0,0,NULL,0),(6957,58,'2027-02-01',4,0,0,NULL,0),(6958,58,'2027-02-02',4,0,0,NULL,0),(6959,58,'2027-02-03',4,0,0,NULL,0),(6960,58,'2027-02-04',4,0,0,NULL,0),(6961,59,'2026-10-08',3,0,0,NULL,0),(6962,59,'2026-10-09',3,0,0,NULL,0),(6963,59,'2026-10-10',3,0,0,NULL,0),(6964,59,'2026-10-11',3,0,0,NULL,0),(6965,59,'2026-10-12',3,0,0,NULL,0),(6966,59,'2026-10-13',3,0,0,NULL,0),(6967,59,'2026-10-14',3,0,0,NULL,0),(6968,59,'2026-10-15',3,0,0,NULL,0),(6969,59,'2026-10-16',3,0,0,NULL,0),(6970,59,'2026-10-17',3,0,0,NULL,0),(6971,59,'2026-10-18',3,0,0,NULL,0),(6972,59,'2026-10-19',3,0,0,NULL,0),(6973,59,'2026-10-20',3,0,0,NULL,0),(6974,59,'2026-10-21',3,0,0,NULL,0),(6975,59,'2026-10-22',3,0,0,NULL,0),(6976,59,'2026-10-23',3,0,0,NULL,0),(6977,59,'2026-10-24',3,0,0,NULL,0),(6978,59,'2026-10-25',3,0,0,NULL,0),(6979,59,'2026-10-26',3,0,0,NULL,0),(6980,59,'2026-10-27',3,0,0,NULL,0),(6981,59,'2026-10-28',3,0,0,NULL,0),(6982,59,'2026-10-29',3,0,0,NULL,0),(6983,59,'2026-10-30',3,0,0,NULL,0),(6984,59,'2026-10-31',3,0,0,NULL,0),(6985,59,'2026-11-01',3,0,0,NULL,0),(6986,59,'2026-11-02',3,0,0,NULL,0),(6987,59,'2026-11-03',3,0,0,NULL,0),(6988,59,'2026-11-04',3,0,0,NULL,0),(6989,59,'2026-11-05',3,0,0,NULL,0),(6990,59,'2026-11-06',3,0,0,NULL,0),(6991,59,'2026-11-07',3,0,0,NULL,0),(6992,59,'2026-11-08',3,0,0,NULL,0),(6993,59,'2026-11-09',3,0,0,NULL,0),(6994,59,'2026-11-10',3,0,0,NULL,0),(6995,59,'2026-11-11',3,0,0,NULL,0),(6996,59,'2026-11-12',3,0,0,NULL,0),(6997,59,'2026-11-13',3,0,0,NULL,0),(6998,59,'2026-11-14',3,0,0,NULL,0),(6999,59,'2026-11-15',3,0,0,NULL,0),(7000,59,'2026-11-16',3,0,0,NULL,0),(7001,59,'2026-11-17',3,0,0,NULL,0),(7002,59,'2026-11-18',3,0,0,NULL,0),(7003,59,'2026-11-19',3,0,0,NULL,0),(7004,59,'2026-11-20',3,0,0,NULL,0),(7005,59,'2026-11-21',3,0,0,NULL,0),(7006,59,'2026-11-22',3,0,0,NULL,0),(7007,59,'2026-11-23',3,0,0,NULL,0),(7008,59,'2026-11-24',3,0,0,NULL,0),(7009,59,'2026-11-25',3,0,0,NULL,0),(7010,59,'2026-11-26',3,0,0,NULL,0),(7011,59,'2026-11-27',3,0,0,NULL,0),(7012,59,'2026-11-28',3,0,0,NULL,0),(7013,59,'2026-11-29',3,0,0,NULL,0),(7014,59,'2026-11-30',3,0,0,NULL,0),(7015,59,'2026-12-01',3,0,0,NULL,0),(7016,59,'2026-12-02',3,0,0,NULL,0),(7017,59,'2026-12-03',3,0,0,NULL,0),(7018,59,'2026-12-04',3,0,0,NULL,0),(7019,59,'2026-12-05',3,0,0,NULL,0),(7020,59,'2026-12-06',3,0,0,NULL,0),(7021,59,'2026-12-07',3,0,0,NULL,0),(7022,59,'2026-12-08',3,0,0,NULL,0),(7023,59,'2026-12-09',3,0,0,NULL,0),(7024,59,'2026-12-10',3,0,0,NULL,0),(7025,59,'2026-12-11',3,0,0,NULL,0),(7026,59,'2026-12-12',3,0,0,NULL,0),(7027,59,'2026-12-13',3,0,0,NULL,0),(7028,59,'2026-12-14',3,0,0,NULL,0),(7029,59,'2026-12-15',3,0,0,NULL,0),(7030,59,'2026-12-16',3,0,0,NULL,0),(7031,59,'2026-12-17',3,0,0,NULL,0),(7032,59,'2026-12-18',3,0,0,NULL,0),(7033,59,'2026-12-19',3,0,0,NULL,0),(7034,59,'2026-12-20',3,0,0,NULL,0),(7035,59,'2026-12-21',3,0,0,NULL,0),(7036,59,'2026-12-22',3,0,0,NULL,0),(7037,59,'2026-12-23',3,0,0,NULL,0),(7038,59,'2026-12-24',3,0,0,NULL,0),(7039,59,'2026-12-25',3,0,0,NULL,0),(7040,59,'2026-12-26',3,0,0,NULL,0),(7041,59,'2026-12-27',3,0,0,NULL,0),(7042,59,'2026-12-28',3,0,0,NULL,0),(7043,59,'2026-12-29',3,0,0,NULL,0),(7044,59,'2026-12-30',3,0,0,NULL,0),(7045,59,'2026-12-31',3,0,0,NULL,0),(7046,59,'2027-01-01',3,0,0,NULL,0),(7047,59,'2027-01-02',3,0,0,NULL,0),(7048,59,'2027-01-03',3,0,0,NULL,0),(7049,59,'2027-01-04',3,0,0,NULL,0),(7050,59,'2027-01-05',3,0,0,NULL,0),(7051,59,'2027-01-06',3,0,0,NULL,0),(7052,59,'2027-01-07',3,0,0,NULL,0),(7053,59,'2027-01-08',3,0,0,NULL,0),(7054,59,'2027-01-09',3,0,0,NULL,0),(7055,59,'2027-01-10',3,0,0,NULL,0),(7056,59,'2027-01-11',3,0,0,NULL,0),(7057,59,'2027-01-12',3,0,0,NULL,0),(7058,59,'2027-01-13',3,0,0,NULL,0),(7059,59,'2027-01-14',3,0,0,NULL,0),(7060,59,'2027-01-15',3,0,0,NULL,0),(7061,59,'2027-01-16',3,0,0,NULL,0),(7062,59,'2027-01-17',3,0,0,NULL,0),(7063,59,'2027-01-18',3,0,0,NULL,0),(7064,59,'2027-01-19',3,0,0,NULL,0),(7065,59,'2027-01-20',3,0,0,NULL,0),(7066,59,'2027-01-21',3,0,0,NULL,0),(7067,59,'2027-01-22',3,0,0,NULL,0),(7068,59,'2027-01-23',3,0,0,NULL,0),(7069,59,'2027-01-24',3,0,0,NULL,0),(7070,59,'2027-01-25',3,0,0,NULL,0),(7071,59,'2027-01-26',3,0,0,NULL,0),(7072,59,'2027-01-27',3,0,0,NULL,0),(7073,59,'2027-01-28',3,0,0,NULL,0),(7074,59,'2027-01-29',3,0,0,NULL,0),(7075,59,'2027-01-30',3,0,0,NULL,0),(7076,59,'2027-01-31',3,0,0,NULL,0),(7077,59,'2027-02-01',3,0,0,NULL,0),(7078,59,'2027-02-02',3,0,0,NULL,0),(7079,59,'2027-02-03',3,0,0,NULL,0),(7080,59,'2027-02-04',3,0,0,NULL,0),(7081,60,'2026-10-08',5,0,0,NULL,0),(7082,60,'2026-10-09',5,0,0,NULL,0),(7083,60,'2026-10-10',5,0,0,NULL,0),(7084,60,'2026-10-11',5,0,0,NULL,0),(7085,60,'2026-10-12',5,0,0,NULL,0),(7086,60,'2026-10-13',5,0,0,NULL,0),(7087,60,'2026-10-14',5,0,0,NULL,0),(7088,60,'2026-10-15',5,0,0,NULL,0),(7089,60,'2026-10-16',5,0,0,NULL,0),(7090,60,'2026-10-17',5,0,0,NULL,0),(7091,60,'2026-10-18',5,0,0,NULL,0),(7092,60,'2026-10-19',5,0,0,NULL,0),(7093,60,'2026-10-20',5,0,0,NULL,0),(7094,60,'2026-10-21',5,0,0,NULL,0),(7095,60,'2026-10-22',5,0,0,NULL,0),(7096,60,'2026-10-23',5,0,0,NULL,0),(7097,60,'2026-10-24',5,0,0,NULL,0),(7098,60,'2026-10-25',5,0,0,NULL,0),(7099,60,'2026-10-26',5,0,0,NULL,0),(7100,60,'2026-10-27',5,0,0,NULL,0),(7101,60,'2026-10-28',5,0,0,NULL,0),(7102,60,'2026-10-29',5,0,0,NULL,0),(7103,60,'2026-10-30',5,0,0,NULL,0),(7104,60,'2026-10-31',5,0,0,NULL,0),(7105,60,'2026-11-01',5,0,0,NULL,0),(7106,60,'2026-11-02',5,0,0,NULL,0),(7107,60,'2026-11-03',5,0,0,NULL,0),(7108,60,'2026-11-04',5,0,0,NULL,0),(7109,60,'2026-11-05',5,0,0,NULL,0),(7110,60,'2026-11-06',5,0,0,NULL,0),(7111,60,'2026-11-07',5,0,0,NULL,0),(7112,60,'2026-11-08',5,0,0,NULL,0),(7113,60,'2026-11-09',5,0,0,NULL,0),(7114,60,'2026-11-10',5,0,0,NULL,0),(7115,60,'2026-11-11',5,0,0,NULL,0),(7116,60,'2026-11-12',5,0,0,NULL,0),(7117,60,'2026-11-13',5,0,0,NULL,0),(7118,60,'2026-11-14',5,0,0,NULL,0),(7119,60,'2026-11-15',5,0,0,NULL,0),(7120,60,'2026-11-16',5,0,0,NULL,0),(7121,60,'2026-11-17',5,0,0,NULL,0),(7122,60,'2026-11-18',5,0,0,NULL,0),(7123,60,'2026-11-19',5,0,0,NULL,0),(7124,60,'2026-11-20',5,0,0,NULL,0),(7125,60,'2026-11-21',5,0,0,NULL,0),(7126,60,'2026-11-22',5,0,0,NULL,0),(7127,60,'2026-11-23',5,0,0,NULL,0),(7128,60,'2026-11-24',5,0,0,NULL,0),(7129,60,'2026-11-25',5,0,0,NULL,0),(7130,60,'2026-11-26',5,0,0,NULL,0),(7131,60,'2026-11-27',5,0,0,NULL,0),(7132,60,'2026-11-28',5,0,0,NULL,0),(7133,60,'2026-11-29',5,0,0,NULL,0),(7134,60,'2026-11-30',5,0,0,NULL,0),(7135,60,'2026-12-01',5,0,0,NULL,0),(7136,60,'2026-12-02',5,0,0,NULL,0),(7137,60,'2026-12-03',5,0,0,NULL,0),(7138,60,'2026-12-04',5,0,0,NULL,0),(7139,60,'2026-12-05',5,0,0,NULL,0),(7140,60,'2026-12-06',5,0,0,NULL,0),(7141,60,'2026-12-07',5,0,0,NULL,0),(7142,60,'2026-12-08',5,0,0,NULL,0),(7143,60,'2026-12-09',5,0,0,NULL,0),(7144,60,'2026-12-10',5,0,0,NULL,0),(7145,60,'2026-12-11',5,0,0,NULL,0),(7146,60,'2026-12-12',5,0,0,NULL,0),(7147,60,'2026-12-13',5,0,0,NULL,0),(7148,60,'2026-12-14',5,0,0,NULL,0),(7149,60,'2026-12-15',5,0,0,NULL,0),(7150,60,'2026-12-16',5,0,0,NULL,0),(7151,60,'2026-12-17',5,0,0,NULL,0),(7152,60,'2026-12-18',5,0,0,NULL,0),(7153,60,'2026-12-19',5,0,0,NULL,0),(7154,60,'2026-12-20',5,0,0,NULL,0),(7155,60,'2026-12-21',5,0,0,NULL,0),(7156,60,'2026-12-22',5,0,0,NULL,0),(7157,60,'2026-12-23',5,0,0,NULL,0),(7158,60,'2026-12-24',5,0,0,NULL,0),(7159,60,'2026-12-25',5,0,0,NULL,0),(7160,60,'2026-12-26',5,0,0,NULL,0),(7161,60,'2026-12-27',5,0,0,NULL,0),(7162,60,'2026-12-28',5,0,0,NULL,0),(7163,60,'2026-12-29',5,0,0,NULL,0),(7164,60,'2026-12-30',5,0,0,NULL,0),(7165,60,'2026-12-31',5,0,0,NULL,0),(7166,60,'2027-01-01',5,0,0,NULL,0),(7167,60,'2027-01-02',5,0,0,NULL,0),(7168,60,'2027-01-03',5,0,0,NULL,0),(7169,60,'2027-01-04',5,0,0,NULL,0),(7170,60,'2027-01-05',5,0,0,NULL,0),(7171,60,'2027-01-06',5,0,0,NULL,0),(7172,60,'2027-01-07',5,0,0,NULL,0),(7173,60,'2027-01-08',5,0,0,NULL,0),(7174,60,'2027-01-09',5,0,0,NULL,0),(7175,60,'2027-01-10',5,0,0,NULL,0),(7176,60,'2027-01-11',5,0,0,NULL,0),(7177,60,'2027-01-12',5,0,0,NULL,0),(7178,60,'2027-01-13',5,0,0,NULL,0),(7179,60,'2027-01-14',5,0,0,NULL,0),(7180,60,'2027-01-15',5,0,0,NULL,0),(7181,60,'2027-01-16',5,0,0,NULL,0),(7182,60,'2027-01-17',5,0,0,NULL,0),(7183,60,'2027-01-18',5,0,0,NULL,0),(7184,60,'2027-01-19',5,0,0,NULL,0),(7185,60,'2027-01-20',5,0,0,NULL,0),(7186,60,'2027-01-21',5,0,0,NULL,0),(7187,60,'2027-01-22',5,0,0,NULL,0),(7188,60,'2027-01-23',5,0,0,NULL,0),(7189,60,'2027-01-24',5,0,0,NULL,0),(7190,60,'2027-01-25',5,0,0,NULL,0),(7191,60,'2027-01-26',5,0,0,NULL,0),(7192,60,'2027-01-27',5,0,0,NULL,0),(7193,60,'2027-01-28',5,0,0,NULL,0),(7194,60,'2027-01-29',5,0,0,NULL,0),(7195,60,'2027-01-30',5,0,0,NULL,0),(7196,60,'2027-01-31',5,0,0,NULL,0),(7197,60,'2027-02-01',5,0,0,NULL,0),(7198,60,'2027-02-02',5,0,0,NULL,0),(7199,60,'2027-02-03',5,0,0,NULL,0),(7200,60,'2027-02-04',5,0,0,NULL,0),(7201,61,'2026-10-08',2,0,0,NULL,0),(7202,61,'2026-10-09',2,0,0,NULL,0),(7203,61,'2026-10-10',2,0,0,NULL,0),(7204,61,'2026-10-11',2,0,0,NULL,0),(7205,61,'2026-10-12',2,0,0,NULL,0),(7206,61,'2026-10-13',2,0,0,NULL,0),(7207,61,'2026-10-14',2,0,0,NULL,0),(7208,61,'2026-10-15',2,0,0,NULL,0),(7209,61,'2026-10-16',2,0,0,NULL,0),(7210,61,'2026-10-17',2,0,0,NULL,0),(7211,61,'2026-10-18',2,0,0,NULL,0),(7212,61,'2026-10-19',2,0,0,NULL,0),(7213,61,'2026-10-20',2,0,0,NULL,0),(7214,61,'2026-10-21',2,0,0,NULL,0),(7215,61,'2026-10-22',2,0,0,NULL,0),(7216,61,'2026-10-23',2,0,0,NULL,0),(7217,61,'2026-10-24',2,0,0,NULL,0),(7218,61,'2026-10-25',2,0,0,NULL,0),(7219,61,'2026-10-26',2,0,0,NULL,0),(7220,61,'2026-10-27',2,0,0,NULL,0),(7221,61,'2026-10-28',2,0,0,NULL,0),(7222,61,'2026-10-29',2,0,0,NULL,0),(7223,61,'2026-10-30',2,0,0,NULL,0),(7224,61,'2026-10-31',2,0,0,NULL,0),(7225,61,'2026-11-01',2,0,0,NULL,0),(7226,61,'2026-11-02',2,0,0,NULL,0),(7227,61,'2026-11-03',2,0,0,NULL,0),(7228,61,'2026-11-04',2,0,0,NULL,0),(7229,61,'2026-11-05',2,0,0,NULL,0),(7230,61,'2026-11-06',2,0,0,NULL,0),(7231,61,'2026-11-07',2,0,0,NULL,0),(7232,61,'2026-11-08',2,0,0,NULL,0),(7233,61,'2026-11-09',2,0,0,NULL,0),(7234,61,'2026-11-10',2,0,0,NULL,0),(7235,61,'2026-11-11',2,0,0,NULL,0),(7236,61,'2026-11-12',2,0,0,NULL,0),(7237,61,'2026-11-13',2,0,0,NULL,0),(7238,61,'2026-11-14',2,0,0,NULL,0),(7239,61,'2026-11-15',2,0,0,NULL,0),(7240,61,'2026-11-16',2,0,0,NULL,0),(7241,61,'2026-11-17',2,0,0,NULL,0),(7242,61,'2026-11-18',2,0,0,NULL,0),(7243,61,'2026-11-19',2,0,0,NULL,0),(7244,61,'2026-11-20',2,0,0,NULL,0),(7245,61,'2026-11-21',2,0,0,NULL,0),(7246,61,'2026-11-22',2,0,0,NULL,0),(7247,61,'2026-11-23',2,0,0,NULL,0),(7248,61,'2026-11-24',2,0,0,NULL,0),(7249,61,'2026-11-25',2,0,0,NULL,0),(7250,61,'2026-11-26',2,0,0,NULL,0),(7251,61,'2026-11-27',2,0,0,NULL,0),(7252,61,'2026-11-28',2,0,0,NULL,0),(7253,61,'2026-11-29',2,0,0,NULL,0),(7254,61,'2026-11-30',2,0,0,NULL,0),(7255,61,'2026-12-01',2,0,0,NULL,0),(7256,61,'2026-12-02',2,0,0,NULL,0),(7257,61,'2026-12-03',2,0,0,NULL,0),(7258,61,'2026-12-04',2,0,0,NULL,0),(7259,61,'2026-12-05',2,0,0,NULL,0),(7260,61,'2026-12-06',2,0,0,NULL,0),(7261,61,'2026-12-07',2,0,0,NULL,0),(7262,61,'2026-12-08',2,0,0,NULL,0),(7263,61,'2026-12-09',2,0,0,NULL,0),(7264,61,'2026-12-10',2,0,0,NULL,0),(7265,61,'2026-12-11',2,0,0,NULL,0),(7266,61,'2026-12-12',2,0,0,NULL,0),(7267,61,'2026-12-13',2,0,0,NULL,0),(7268,61,'2026-12-14',2,0,0,NULL,0),(7269,61,'2026-12-15',2,0,0,NULL,0),(7270,61,'2026-12-16',2,0,0,NULL,0),(7271,61,'2026-12-17',2,0,0,NULL,0),(7272,61,'2026-12-18',2,0,0,NULL,0),(7273,61,'2026-12-19',2,0,0,NULL,0),(7274,61,'2026-12-20',2,0,0,NULL,0),(7275,61,'2026-12-21',2,0,0,NULL,0),(7276,61,'2026-12-22',2,0,0,NULL,0),(7277,61,'2026-12-23',2,0,0,NULL,0),(7278,61,'2026-12-24',2,0,0,NULL,0),(7279,61,'2026-12-25',2,0,0,NULL,0),(7280,61,'2026-12-26',2,0,0,NULL,0),(7281,61,'2026-12-27',2,0,0,NULL,0),(7282,61,'2026-12-28',2,0,0,NULL,0),(7283,61,'2026-12-29',2,0,0,NULL,0),(7284,61,'2026-12-30',2,0,0,NULL,0),(7285,61,'2026-12-31',2,0,0,NULL,0),(7286,61,'2027-01-01',2,0,0,NULL,0),(7287,61,'2027-01-02',2,0,0,NULL,0),(7288,61,'2027-01-03',2,0,0,NULL,0),(7289,61,'2027-01-04',2,0,0,NULL,0),(7290,61,'2027-01-05',2,0,0,NULL,0),(7291,61,'2027-01-06',2,0,0,NULL,0),(7292,61,'2027-01-07',2,0,0,NULL,0),(7293,61,'2027-01-08',2,0,0,NULL,0),(7294,61,'2027-01-09',2,0,0,NULL,0),(7295,61,'2027-01-10',2,0,0,NULL,0),(7296,61,'2027-01-11',2,0,0,NULL,0),(7297,61,'2027-01-12',2,0,0,NULL,0),(7298,61,'2027-01-13',2,0,0,NULL,0),(7299,61,'2027-01-14',2,0,0,NULL,0),(7300,61,'2027-01-15',2,0,0,NULL,0),(7301,61,'2027-01-16',2,0,0,NULL,0),(7302,61,'2027-01-17',2,0,0,NULL,0),(7303,61,'2027-01-18',2,0,0,NULL,0),(7304,61,'2027-01-19',2,0,0,NULL,0),(7305,61,'2027-01-20',2,0,0,NULL,0),(7306,61,'2027-01-21',2,0,0,NULL,0),(7307,61,'2027-01-22',2,0,0,NULL,0),(7308,61,'2027-01-23',2,0,0,NULL,0),(7309,61,'2027-01-24',2,0,0,NULL,0),(7310,61,'2027-01-25',2,0,0,NULL,0),(7311,61,'2027-01-26',2,0,0,NULL,0),(7312,61,'2027-01-27',2,0,0,NULL,0),(7313,61,'2027-01-28',2,0,0,NULL,0),(7314,61,'2027-01-29',2,0,0,NULL,0),(7315,61,'2027-01-30',2,0,0,NULL,0),(7316,61,'2027-01-31',2,0,0,NULL,0),(7317,61,'2027-02-01',2,0,0,NULL,0),(7318,61,'2027-02-02',2,0,0,NULL,0),(7319,61,'2027-02-03',2,0,0,NULL,0),(7320,61,'2027-02-04',2,0,0,NULL,0),(7321,62,'2026-10-08',6,0,0,NULL,0),(7322,62,'2026-10-09',6,0,0,NULL,0),(7323,62,'2026-10-10',6,0,0,NULL,0),(7324,62,'2026-10-11',6,0,0,NULL,0),(7325,62,'2026-10-12',6,0,0,NULL,0),(7326,62,'2026-10-13',6,0,0,NULL,0),(7327,62,'2026-10-14',6,0,0,NULL,0),(7328,62,'2026-10-15',6,0,0,NULL,0),(7329,62,'2026-10-16',6,0,0,NULL,0),(7330,62,'2026-10-17',6,0,0,NULL,0),(7331,62,'2026-10-18',6,0,0,NULL,0),(7332,62,'2026-10-19',6,0,0,NULL,0),(7333,62,'2026-10-20',6,0,0,NULL,0),(7334,62,'2026-10-21',6,0,0,NULL,0),(7335,62,'2026-10-22',6,0,0,NULL,0),(7336,62,'2026-10-23',6,0,0,NULL,0),(7337,62,'2026-10-24',6,0,0,NULL,0),(7338,62,'2026-10-25',6,0,0,NULL,0),(7339,62,'2026-10-26',6,0,0,NULL,0),(7340,62,'2026-10-27',6,0,0,NULL,0),(7341,62,'2026-10-28',6,0,0,NULL,0),(7342,62,'2026-10-29',6,0,0,NULL,0),(7343,62,'2026-10-30',6,0,0,NULL,0),(7344,62,'2026-10-31',6,0,0,NULL,0),(7345,62,'2026-11-01',6,0,0,NULL,0),(7346,62,'2026-11-02',6,0,0,NULL,0),(7347,62,'2026-11-03',6,0,0,NULL,0),(7348,62,'2026-11-04',6,0,0,NULL,0),(7349,62,'2026-11-05',6,0,0,NULL,0),(7350,62,'2026-11-06',6,0,0,NULL,0),(7351,62,'2026-11-07',6,0,0,NULL,0),(7352,62,'2026-11-08',6,0,0,NULL,0),(7353,62,'2026-11-09',6,0,0,NULL,0),(7354,62,'2026-11-10',6,0,0,NULL,0),(7355,62,'2026-11-11',6,0,0,NULL,0),(7356,62,'2026-11-12',6,0,0,NULL,0),(7357,62,'2026-11-13',6,0,0,NULL,0),(7358,62,'2026-11-14',6,0,0,NULL,0),(7359,62,'2026-11-15',6,0,0,NULL,0),(7360,62,'2026-11-16',6,0,0,NULL,0),(7361,62,'2026-11-17',6,0,0,NULL,0),(7362,62,'2026-11-18',6,0,0,NULL,0),(7363,62,'2026-11-19',6,0,0,NULL,0),(7364,62,'2026-11-20',6,0,0,NULL,0),(7365,62,'2026-11-21',6,0,0,NULL,0),(7366,62,'2026-11-22',6,0,0,NULL,0),(7367,62,'2026-11-23',6,0,0,NULL,0),(7368,62,'2026-11-24',6,0,0,NULL,0),(7369,62,'2026-11-25',6,0,0,NULL,0),(7370,62,'2026-11-26',6,0,0,NULL,0),(7371,62,'2026-11-27',6,0,0,NULL,0),(7372,62,'2026-11-28',6,0,0,NULL,0),(7373,62,'2026-11-29',6,0,0,NULL,0),(7374,62,'2026-11-30',6,0,0,NULL,0),(7375,62,'2026-12-01',6,0,0,NULL,0),(7376,62,'2026-12-02',6,0,0,NULL,0),(7377,62,'2026-12-03',6,0,0,NULL,0),(7378,62,'2026-12-04',6,0,0,NULL,0),(7379,62,'2026-12-05',6,0,0,NULL,0),(7380,62,'2026-12-06',6,0,0,NULL,0),(7381,62,'2026-12-07',6,0,0,NULL,0),(7382,62,'2026-12-08',6,0,0,NULL,0),(7383,62,'2026-12-09',6,0,0,NULL,0),(7384,62,'2026-12-10',6,0,0,NULL,0),(7385,62,'2026-12-11',6,0,0,NULL,0),(7386,62,'2026-12-12',6,0,0,NULL,0),(7387,62,'2026-12-13',6,0,0,NULL,0),(7388,62,'2026-12-14',6,0,0,NULL,0),(7389,62,'2026-12-15',6,0,0,NULL,0),(7390,62,'2026-12-16',6,0,0,NULL,0),(7391,62,'2026-12-17',6,0,0,NULL,0),(7392,62,'2026-12-18',6,0,0,NULL,0),(7393,62,'2026-12-19',6,0,0,NULL,0),(7394,62,'2026-12-20',6,0,0,NULL,0),(7395,62,'2026-12-21',6,0,0,NULL,0),(7396,62,'2026-12-22',6,0,0,NULL,0),(7397,62,'2026-12-23',6,0,0,NULL,0),(7398,62,'2026-12-24',6,0,0,NULL,0),(7399,62,'2026-12-25',6,0,0,NULL,0),(7400,62,'2026-12-26',6,0,0,NULL,0),(7401,62,'2026-12-27',6,0,0,NULL,0),(7402,62,'2026-12-28',6,0,0,NULL,0),(7403,62,'2026-12-29',6,0,0,NULL,0),(7404,62,'2026-12-30',6,0,0,NULL,0),(7405,62,'2026-12-31',6,0,0,NULL,0),(7406,62,'2027-01-01',6,0,0,NULL,0),(7407,62,'2027-01-02',6,0,0,NULL,0),(7408,62,'2027-01-03',6,0,0,NULL,0),(7409,62,'2027-01-04',6,0,0,NULL,0),(7410,62,'2027-01-05',6,0,0,NULL,0),(7411,62,'2027-01-06',6,0,0,NULL,0),(7412,62,'2027-01-07',6,0,0,NULL,0),(7413,62,'2027-01-08',6,0,0,NULL,0),(7414,62,'2027-01-09',6,0,0,NULL,0),(7415,62,'2027-01-10',6,0,0,NULL,0),(7416,62,'2027-01-11',6,0,0,NULL,0),(7417,62,'2027-01-12',6,0,0,NULL,0),(7418,62,'2027-01-13',6,0,0,NULL,0),(7419,62,'2027-01-14',6,0,0,NULL,0),(7420,62,'2027-01-15',6,0,0,NULL,0),(7421,62,'2027-01-16',6,0,0,NULL,0),(7422,62,'2027-01-17',6,0,0,NULL,0),(7423,62,'2027-01-18',6,0,0,NULL,0),(7424,62,'2027-01-19',6,0,0,NULL,0),(7425,62,'2027-01-20',6,0,0,NULL,0),(7426,62,'2027-01-21',6,0,0,NULL,0),(7427,62,'2027-01-22',6,0,0,NULL,0),(7428,62,'2027-01-23',6,0,0,NULL,0),(7429,62,'2027-01-24',6,0,0,NULL,0),(7430,62,'2027-01-25',6,0,0,NULL,0),(7431,62,'2027-01-26',6,0,0,NULL,0),(7432,62,'2027-01-27',6,0,0,NULL,0),(7433,62,'2027-01-28',6,0,0,NULL,0),(7434,62,'2027-01-29',6,0,0,NULL,0),(7435,62,'2027-01-30',6,0,0,NULL,0),(7436,62,'2027-01-31',6,0,0,NULL,0),(7437,62,'2027-02-01',6,0,0,NULL,0),(7438,62,'2027-02-02',6,0,0,NULL,0),(7439,62,'2027-02-03',6,0,0,NULL,0),(7440,62,'2027-02-04',6,0,0,NULL,0),(7441,63,'2026-10-08',4,0,0,NULL,0),(7442,63,'2026-10-09',4,0,0,NULL,0),(7443,63,'2026-10-10',4,0,0,NULL,0),(7444,63,'2026-10-11',4,0,0,NULL,0),(7445,63,'2026-10-12',4,0,0,NULL,0),(7446,63,'2026-10-13',4,0,0,NULL,0),(7447,63,'2026-10-14',4,0,0,NULL,0),(7448,63,'2026-10-15',4,0,0,NULL,0),(7449,63,'2026-10-16',4,0,0,NULL,0),(7450,63,'2026-10-17',4,0,0,NULL,0),(7451,63,'2026-10-18',4,0,0,NULL,0),(7452,63,'2026-10-19',4,0,0,NULL,0),(7453,63,'2026-10-20',4,0,0,NULL,0),(7454,63,'2026-10-21',4,0,0,NULL,0),(7455,63,'2026-10-22',4,0,0,NULL,0),(7456,63,'2026-10-23',4,0,0,NULL,0),(7457,63,'2026-10-24',4,0,0,NULL,0),(7458,63,'2026-10-25',4,0,0,NULL,0),(7459,63,'2026-10-26',4,0,0,NULL,0),(7460,63,'2026-10-27',4,0,0,NULL,0),(7461,63,'2026-10-28',4,0,0,NULL,0),(7462,63,'2026-10-29',4,0,0,NULL,0),(7463,63,'2026-10-30',4,0,0,NULL,0),(7464,63,'2026-10-31',4,0,0,NULL,0),(7465,63,'2026-11-01',4,0,0,NULL,0),(7466,63,'2026-11-02',4,0,0,NULL,0),(7467,63,'2026-11-03',4,0,0,NULL,0),(7468,63,'2026-11-04',4,0,0,NULL,0),(7469,63,'2026-11-05',4,0,0,NULL,0),(7470,63,'2026-11-06',4,0,0,NULL,0),(7471,63,'2026-11-07',4,0,0,NULL,0),(7472,63,'2026-11-08',4,0,0,NULL,0),(7473,63,'2026-11-09',4,0,0,NULL,0),(7474,63,'2026-11-10',4,0,0,NULL,0),(7475,63,'2026-11-11',4,0,0,NULL,0),(7476,63,'2026-11-12',4,0,0,NULL,0),(7477,63,'2026-11-13',4,0,0,NULL,0),(7478,63,'2026-11-14',4,0,0,NULL,0),(7479,63,'2026-11-15',4,0,0,NULL,0),(7480,63,'2026-11-16',4,0,0,NULL,0),(7481,63,'2026-11-17',4,0,0,NULL,0),(7482,63,'2026-11-18',4,0,0,NULL,0),(7483,63,'2026-11-19',4,0,0,NULL,0),(7484,63,'2026-11-20',4,0,0,NULL,0),(7485,63,'2026-11-21',4,0,0,NULL,0),(7486,63,'2026-11-22',4,0,0,NULL,0),(7487,63,'2026-11-23',4,0,0,NULL,0),(7488,63,'2026-11-24',4,0,0,NULL,0),(7489,63,'2026-11-25',4,0,0,NULL,0),(7490,63,'2026-11-26',4,0,0,NULL,0),(7491,63,'2026-11-27',4,0,0,NULL,0),(7492,63,'2026-11-28',4,0,0,NULL,0),(7493,63,'2026-11-29',4,0,0,NULL,0),(7494,63,'2026-11-30',4,0,0,NULL,0),(7495,63,'2026-12-01',4,0,0,NULL,0),(7496,63,'2026-12-02',4,0,0,NULL,0),(7497,63,'2026-12-03',4,0,0,NULL,0),(7498,63,'2026-12-04',4,0,0,NULL,0),(7499,63,'2026-12-05',4,0,0,NULL,0),(7500,63,'2026-12-06',4,0,0,NULL,0),(7501,63,'2026-12-07',4,0,0,NULL,0),(7502,63,'2026-12-08',4,0,0,NULL,0),(7503,63,'2026-12-09',4,0,0,NULL,0),(7504,63,'2026-12-10',4,0,0,NULL,0),(7505,63,'2026-12-11',4,0,0,NULL,0),(7506,63,'2026-12-12',4,0,0,NULL,0),(7507,63,'2026-12-13',4,0,0,NULL,0),(7508,63,'2026-12-14',4,0,0,NULL,0),(7509,63,'2026-12-15',4,0,0,NULL,0),(7510,63,'2026-12-16',4,0,0,NULL,0),(7511,63,'2026-12-17',4,0,0,NULL,0),(7512,63,'2026-12-18',4,0,0,NULL,0),(7513,63,'2026-12-19',4,0,0,NULL,0),(7514,63,'2026-12-20',4,0,0,NULL,0),(7515,63,'2026-12-21',4,0,0,NULL,0),(7516,63,'2026-12-22',4,0,0,NULL,0),(7517,63,'2026-12-23',4,0,0,NULL,0),(7518,63,'2026-12-24',4,0,0,NULL,0),(7519,63,'2026-12-25',4,0,0,NULL,0),(7520,63,'2026-12-26',4,0,0,NULL,0),(7521,63,'2026-12-27',4,0,0,NULL,0),(7522,63,'2026-12-28',4,0,0,NULL,0),(7523,63,'2026-12-29',4,0,0,NULL,0),(7524,63,'2026-12-30',4,0,0,NULL,0),(7525,63,'2026-12-31',4,0,0,NULL,0),(7526,63,'2027-01-01',4,0,0,NULL,0),(7527,63,'2027-01-02',4,0,0,NULL,0),(7528,63,'2027-01-03',4,0,0,NULL,0),(7529,63,'2027-01-04',4,0,0,NULL,0),(7530,63,'2027-01-05',4,0,0,NULL,0),(7531,63,'2027-01-06',4,0,0,NULL,0),(7532,63,'2027-01-07',4,0,0,NULL,0),(7533,63,'2027-01-08',4,0,0,NULL,0),(7534,63,'2027-01-09',4,0,0,NULL,0),(7535,63,'2027-01-10',4,0,0,NULL,0),(7536,63,'2027-01-11',4,0,0,NULL,0),(7537,63,'2027-01-12',4,0,0,NULL,0),(7538,63,'2027-01-13',4,0,0,NULL,0),(7539,63,'2027-01-14',4,0,0,NULL,0),(7540,63,'2027-01-15',4,0,0,NULL,0),(7541,63,'2027-01-16',4,0,0,NULL,0),(7542,63,'2027-01-17',4,0,0,NULL,0),(7543,63,'2027-01-18',4,0,0,NULL,0),(7544,63,'2027-01-19',4,0,0,NULL,0),(7545,63,'2027-01-20',4,0,0,NULL,0),(7546,63,'2027-01-21',4,0,0,NULL,0),(7547,63,'2027-01-22',4,0,0,NULL,0),(7548,63,'2027-01-23',4,0,0,NULL,0),(7549,63,'2027-01-24',4,0,0,NULL,0),(7550,63,'2027-01-25',4,0,0,NULL,0),(7551,63,'2027-01-26',4,0,0,NULL,0),(7552,63,'2027-01-27',4,0,0,NULL,0),(7553,63,'2027-01-28',4,0,0,NULL,0),(7554,63,'2027-01-29',4,0,0,NULL,0),(7555,63,'2027-01-30',4,0,0,NULL,0),(7556,63,'2027-01-31',4,0,0,NULL,0),(7557,63,'2027-02-01',4,0,0,NULL,0),(7558,63,'2027-02-02',4,0,0,NULL,0),(7559,63,'2027-02-03',4,0,0,NULL,0),(7560,63,'2027-02-04',4,0,0,NULL,0),(7561,64,'2026-10-08',5,0,0,NULL,0),(7562,64,'2026-10-09',5,0,0,NULL,0),(7563,64,'2026-10-10',5,0,0,NULL,0),(7564,64,'2026-10-11',5,0,0,NULL,0),(7565,64,'2026-10-12',5,0,0,NULL,0),(7566,64,'2026-10-13',5,0,0,NULL,0),(7567,64,'2026-10-14',5,0,0,NULL,0),(7568,64,'2026-10-15',5,0,0,NULL,0),(7569,64,'2026-10-16',5,0,0,NULL,0),(7570,64,'2026-10-17',5,0,0,NULL,0),(7571,64,'2026-10-18',5,0,0,NULL,0),(7572,64,'2026-10-19',5,0,0,NULL,0),(7573,64,'2026-10-20',5,0,0,NULL,0),(7574,64,'2026-10-21',5,0,0,NULL,0),(7575,64,'2026-10-22',5,0,0,NULL,0),(7576,64,'2026-10-23',5,0,0,NULL,0),(7577,64,'2026-10-24',5,0,0,NULL,0),(7578,64,'2026-10-25',5,0,0,NULL,0),(7579,64,'2026-10-26',5,0,0,NULL,0),(7580,64,'2026-10-27',5,0,0,NULL,0),(7581,64,'2026-10-28',5,0,0,NULL,0),(7582,64,'2026-10-29',5,0,0,NULL,0),(7583,64,'2026-10-30',5,0,0,NULL,0),(7584,64,'2026-10-31',5,0,0,NULL,0),(7585,64,'2026-11-01',5,0,0,NULL,0),(7586,64,'2026-11-02',5,0,0,NULL,0),(7587,64,'2026-11-03',5,0,0,NULL,0),(7588,64,'2026-11-04',5,0,0,NULL,0),(7589,64,'2026-11-05',5,0,0,NULL,0),(7590,64,'2026-11-06',5,0,0,NULL,0),(7591,64,'2026-11-07',5,0,0,NULL,0),(7592,64,'2026-11-08',5,0,0,NULL,0),(7593,64,'2026-11-09',5,0,0,NULL,0),(7594,64,'2026-11-10',5,0,0,NULL,0),(7595,64,'2026-11-11',5,0,0,NULL,0),(7596,64,'2026-11-12',5,0,0,NULL,0),(7597,64,'2026-11-13',5,0,0,NULL,0),(7598,64,'2026-11-14',5,0,0,NULL,0),(7599,64,'2026-11-15',5,0,0,NULL,0),(7600,64,'2026-11-16',5,0,0,NULL,0),(7601,64,'2026-11-17',5,0,0,NULL,0),(7602,64,'2026-11-18',5,0,0,NULL,0),(7603,64,'2026-11-19',5,0,0,NULL,0),(7604,64,'2026-11-20',5,0,0,NULL,0),(7605,64,'2026-11-21',5,0,0,NULL,0),(7606,64,'2026-11-22',5,0,0,NULL,0),(7607,64,'2026-11-23',5,0,0,NULL,0),(7608,64,'2026-11-24',5,0,0,NULL,0),(7609,64,'2026-11-25',5,0,0,NULL,0),(7610,64,'2026-11-26',5,0,0,NULL,0),(7611,64,'2026-11-27',5,0,0,NULL,0),(7612,64,'2026-11-28',5,0,0,NULL,0),(7613,64,'2026-11-29',5,0,0,NULL,0),(7614,64,'2026-11-30',5,0,0,NULL,0),(7615,64,'2026-12-01',5,0,0,NULL,0),(7616,64,'2026-12-02',5,0,0,NULL,0),(7617,64,'2026-12-03',5,0,0,NULL,0),(7618,64,'2026-12-04',5,0,0,NULL,0),(7619,64,'2026-12-05',5,0,0,NULL,0),(7620,64,'2026-12-06',5,0,0,NULL,0),(7621,64,'2026-12-07',5,0,0,NULL,0),(7622,64,'2026-12-08',5,0,0,NULL,0),(7623,64,'2026-12-09',5,0,0,NULL,0),(7624,64,'2026-12-10',5,0,0,NULL,0),(7625,64,'2026-12-11',5,0,0,NULL,0),(7626,64,'2026-12-12',5,0,0,NULL,0),(7627,64,'2026-12-13',5,0,0,NULL,0),(7628,64,'2026-12-14',5,0,0,NULL,0),(7629,64,'2026-12-15',5,0,0,NULL,0),(7630,64,'2026-12-16',5,0,0,NULL,0),(7631,64,'2026-12-17',5,0,0,NULL,0),(7632,64,'2026-12-18',5,0,0,NULL,0),(7633,64,'2026-12-19',5,0,0,NULL,0),(7634,64,'2026-12-20',5,0,0,NULL,0),(7635,64,'2026-12-21',5,0,0,NULL,0),(7636,64,'2026-12-22',5,0,0,NULL,0),(7637,64,'2026-12-23',5,0,0,NULL,0),(7638,64,'2026-12-24',5,0,0,NULL,0),(7639,64,'2026-12-25',5,0,0,NULL,0),(7640,64,'2026-12-26',5,0,0,NULL,0),(7641,64,'2026-12-27',5,0,0,NULL,0),(7642,64,'2026-12-28',5,0,0,NULL,0),(7643,64,'2026-12-29',5,0,0,NULL,0),(7644,64,'2026-12-30',5,0,0,NULL,0),(7645,64,'2026-12-31',5,0,0,NULL,0),(7646,64,'2027-01-01',5,0,0,NULL,0),(7647,64,'2027-01-02',5,0,0,NULL,0),(7648,64,'2027-01-03',5,0,0,NULL,0),(7649,64,'2027-01-04',5,0,0,NULL,0),(7650,64,'2027-01-05',5,0,0,NULL,0),(7651,64,'2027-01-06',5,0,0,NULL,0),(7652,64,'2027-01-07',5,0,0,NULL,0),(7653,64,'2027-01-08',5,0,0,NULL,0),(7654,64,'2027-01-09',5,0,0,NULL,0),(7655,64,'2027-01-10',5,0,0,NULL,0),(7656,64,'2027-01-11',5,0,0,NULL,0),(7657,64,'2027-01-12',5,0,0,NULL,0),(7658,64,'2027-01-13',5,0,0,NULL,0),(7659,64,'2027-01-14',5,0,0,NULL,0),(7660,64,'2027-01-15',5,0,0,NULL,0),(7661,64,'2027-01-16',5,0,0,NULL,0),(7662,64,'2027-01-17',5,0,0,NULL,0),(7663,64,'2027-01-18',5,0,0,NULL,0),(7664,64,'2027-01-19',5,0,0,NULL,0),(7665,64,'2027-01-20',5,0,0,NULL,0),(7666,64,'2027-01-21',5,0,0,NULL,0),(7667,64,'2027-01-22',5,0,0,NULL,0),(7668,64,'2027-01-23',5,0,0,NULL,0),(7669,64,'2027-01-24',5,0,0,NULL,0),(7670,64,'2027-01-25',5,0,0,NULL,0),(7671,64,'2027-01-26',5,0,0,NULL,0),(7672,64,'2027-01-27',5,0,0,NULL,0),(7673,64,'2027-01-28',5,0,0,NULL,0),(7674,64,'2027-01-29',5,0,0,NULL,0),(7675,64,'2027-01-30',5,0,0,NULL,0),(7676,64,'2027-01-31',5,0,0,NULL,0),(7677,64,'2027-02-01',5,0,0,NULL,0),(7678,64,'2027-02-02',5,0,0,NULL,0),(7679,64,'2027-02-03',5,0,0,NULL,0),(7680,64,'2027-02-04',5,0,0,NULL,0),(7681,65,'2026-10-08',3,0,0,NULL,0),(7682,65,'2026-10-09',3,0,0,NULL,0),(7683,65,'2026-10-10',3,0,0,NULL,0),(7684,65,'2026-10-11',3,0,0,NULL,0),(7685,65,'2026-10-12',3,0,0,NULL,0),(7686,65,'2026-10-13',3,0,0,NULL,0),(7687,65,'2026-10-14',3,0,0,NULL,0),(7688,65,'2026-10-15',3,0,0,NULL,0),(7689,65,'2026-10-16',3,0,0,NULL,0),(7690,65,'2026-10-17',3,0,0,NULL,0),(7691,65,'2026-10-18',3,0,0,NULL,0),(7692,65,'2026-10-19',3,0,0,NULL,0),(7693,65,'2026-10-20',3,0,0,NULL,0),(7694,65,'2026-10-21',3,0,0,NULL,0),(7695,65,'2026-10-22',3,0,0,NULL,0),(7696,65,'2026-10-23',3,0,0,NULL,0),(7697,65,'2026-10-24',3,0,0,NULL,0),(7698,65,'2026-10-25',3,0,0,NULL,0),(7699,65,'2026-10-26',3,0,0,NULL,0),(7700,65,'2026-10-27',3,0,0,NULL,0),(7701,65,'2026-10-28',3,0,0,NULL,0),(7702,65,'2026-10-29',3,0,0,NULL,0),(7703,65,'2026-10-30',3,0,0,NULL,0),(7704,65,'2026-10-31',3,0,0,NULL,0),(7705,65,'2026-11-01',3,0,0,NULL,0),(7706,65,'2026-11-02',3,0,0,NULL,0),(7707,65,'2026-11-03',3,0,0,NULL,0),(7708,65,'2026-11-04',3,0,0,NULL,0),(7709,65,'2026-11-05',3,0,0,NULL,0),(7710,65,'2026-11-06',3,0,0,NULL,0),(7711,65,'2026-11-07',3,0,0,NULL,0),(7712,65,'2026-11-08',3,0,0,NULL,0),(7713,65,'2026-11-09',3,0,0,NULL,0),(7714,65,'2026-11-10',3,0,0,NULL,0),(7715,65,'2026-11-11',3,0,0,NULL,0),(7716,65,'2026-11-12',3,0,0,NULL,0),(7717,65,'2026-11-13',3,0,0,NULL,0),(7718,65,'2026-11-14',3,0,0,NULL,0),(7719,65,'2026-11-15',3,0,0,NULL,0),(7720,65,'2026-11-16',3,0,0,NULL,0),(7721,65,'2026-11-17',3,0,0,NULL,0),(7722,65,'2026-11-18',3,0,0,NULL,0),(7723,65,'2026-11-19',3,0,0,NULL,0),(7724,65,'2026-11-20',3,0,0,NULL,0),(7725,65,'2026-11-21',3,0,0,NULL,0),(7726,65,'2026-11-22',3,0,0,NULL,0),(7727,65,'2026-11-23',3,0,0,NULL,0),(7728,65,'2026-11-24',3,0,0,NULL,0),(7729,65,'2026-11-25',3,0,0,NULL,0),(7730,65,'2026-11-26',3,0,0,NULL,0),(7731,65,'2026-11-27',3,0,0,NULL,0),(7732,65,'2026-11-28',3,0,0,NULL,0),(7733,65,'2026-11-29',3,0,0,NULL,0),(7734,65,'2026-11-30',3,0,0,NULL,0),(7735,65,'2026-12-01',3,0,0,NULL,0),(7736,65,'2026-12-02',3,0,0,NULL,0),(7737,65,'2026-12-03',3,0,0,NULL,0),(7738,65,'2026-12-04',3,0,0,NULL,0),(7739,65,'2026-12-05',3,0,0,NULL,0),(7740,65,'2026-12-06',3,0,0,NULL,0),(7741,65,'2026-12-07',3,0,0,NULL,0),(7742,65,'2026-12-08',3,0,0,NULL,0),(7743,65,'2026-12-09',3,0,0,NULL,0),(7744,65,'2026-12-10',3,0,0,NULL,0),(7745,65,'2026-12-11',3,0,0,NULL,0),(7746,65,'2026-12-12',3,0,0,NULL,0),(7747,65,'2026-12-13',3,0,0,NULL,0),(7748,65,'2026-12-14',3,0,0,NULL,0),(7749,65,'2026-12-15',3,0,0,NULL,0),(7750,65,'2026-12-16',3,0,0,NULL,0),(7751,65,'2026-12-17',3,0,0,NULL,0),(7752,65,'2026-12-18',3,0,0,NULL,0),(7753,65,'2026-12-19',3,0,0,NULL,0),(7754,65,'2026-12-20',3,0,0,NULL,0),(7755,65,'2026-12-21',3,0,0,NULL,0),(7756,65,'2026-12-22',3,0,0,NULL,0),(7757,65,'2026-12-23',3,0,0,NULL,0),(7758,65,'2026-12-24',3,0,0,NULL,0),(7759,65,'2026-12-25',3,0,0,NULL,0),(7760,65,'2026-12-26',3,0,0,NULL,0),(7761,65,'2026-12-27',3,0,0,NULL,0),(7762,65,'2026-12-28',3,0,0,NULL,0),(7763,65,'2026-12-29',3,0,0,NULL,0),(7764,65,'2026-12-30',3,0,0,NULL,0),(7765,65,'2026-12-31',3,0,0,NULL,0),(7766,65,'2027-01-01',3,0,0,NULL,0),(7767,65,'2027-01-02',3,0,0,NULL,0),(7768,65,'2027-01-03',3,0,0,NULL,0),(7769,65,'2027-01-04',3,0,0,NULL,0),(7770,65,'2027-01-05',3,0,0,NULL,0),(7771,65,'2027-01-06',3,0,0,NULL,0),(7772,65,'2027-01-07',3,0,0,NULL,0),(7773,65,'2027-01-08',3,0,0,NULL,0),(7774,65,'2027-01-09',3,0,0,NULL,0),(7775,65,'2027-01-10',3,0,0,NULL,0),(7776,65,'2027-01-11',3,0,0,NULL,0),(7777,65,'2027-01-12',3,0,0,NULL,0),(7778,65,'2027-01-13',3,0,0,NULL,0),(7779,65,'2027-01-14',3,0,0,NULL,0),(7780,65,'2027-01-15',3,0,0,NULL,0),(7781,65,'2027-01-16',3,0,0,NULL,0),(7782,65,'2027-01-17',3,0,0,NULL,0),(7783,65,'2027-01-18',3,0,0,NULL,0),(7784,65,'2027-01-19',3,0,0,NULL,0),(7785,65,'2027-01-20',3,0,0,NULL,0),(7786,65,'2027-01-21',3,0,0,NULL,0),(7787,65,'2027-01-22',3,0,0,NULL,0),(7788,65,'2027-01-23',3,0,0,NULL,0),(7789,65,'2027-01-24',3,0,0,NULL,0),(7790,65,'2027-01-25',3,0,0,NULL,0),(7791,65,'2027-01-26',3,0,0,NULL,0),(7792,65,'2027-01-27',3,0,0,NULL,0),(7793,65,'2027-01-28',3,0,0,NULL,0),(7794,65,'2027-01-29',3,0,0,NULL,0),(7795,65,'2027-01-30',3,0,0,NULL,0),(7796,65,'2027-01-31',3,0,0,NULL,0),(7797,65,'2027-02-01',3,0,0,NULL,0),(7798,65,'2027-02-02',3,0,0,NULL,0),(7799,65,'2027-02-03',3,0,0,NULL,0),(7800,65,'2027-02-04',3,0,0,NULL,0),(7801,66,'2026-10-08',8,0,0,NULL,0),(7802,66,'2026-10-09',8,0,0,NULL,0),(7803,66,'2026-10-10',8,0,0,NULL,0),(7804,66,'2026-10-11',8,0,0,NULL,0),(7805,66,'2026-10-12',8,0,0,NULL,0),(7806,66,'2026-10-13',8,0,0,NULL,0),(7807,66,'2026-10-14',8,0,0,NULL,0),(7808,66,'2026-10-15',8,0,0,NULL,0),(7809,66,'2026-10-16',8,0,0,NULL,0),(7810,66,'2026-10-17',8,0,0,NULL,0),(7811,66,'2026-10-18',8,0,0,NULL,0),(7812,66,'2026-10-19',8,0,0,NULL,0),(7813,66,'2026-10-20',8,0,0,NULL,0),(7814,66,'2026-10-21',8,0,0,NULL,0),(7815,66,'2026-10-22',8,0,0,NULL,0),(7816,66,'2026-10-23',8,0,0,NULL,0),(7817,66,'2026-10-24',8,0,0,NULL,0),(7818,66,'2026-10-25',8,0,0,NULL,0),(7819,66,'2026-10-26',8,0,0,NULL,0),(7820,66,'2026-10-27',8,0,0,NULL,0),(7821,66,'2026-10-28',8,0,0,NULL,0),(7822,66,'2026-10-29',8,0,0,NULL,0),(7823,66,'2026-10-30',8,0,0,NULL,0),(7824,66,'2026-10-31',8,0,0,NULL,0),(7825,66,'2026-11-01',8,0,0,NULL,0),(7826,66,'2026-11-02',8,0,0,NULL,0),(7827,66,'2026-11-03',8,0,0,NULL,0),(7828,66,'2026-11-04',8,0,0,NULL,0),(7829,66,'2026-11-05',8,0,0,NULL,0),(7830,66,'2026-11-06',8,0,0,NULL,0),(7831,66,'2026-11-07',8,0,0,NULL,0),(7832,66,'2026-11-08',8,0,0,NULL,0),(7833,66,'2026-11-09',8,0,0,NULL,0),(7834,66,'2026-11-10',8,0,0,NULL,0),(7835,66,'2026-11-11',8,0,0,NULL,0),(7836,66,'2026-11-12',8,0,0,NULL,0),(7837,66,'2026-11-13',8,0,0,NULL,0),(7838,66,'2026-11-14',8,0,0,NULL,0),(7839,66,'2026-11-15',8,0,0,NULL,0),(7840,66,'2026-11-16',8,0,0,NULL,0),(7841,66,'2026-11-17',8,0,0,NULL,0),(7842,66,'2026-11-18',8,0,0,NULL,0),(7843,66,'2026-11-19',8,0,0,NULL,0),(7844,66,'2026-11-20',8,0,0,NULL,0),(7845,66,'2026-11-21',8,0,0,NULL,0),(7846,66,'2026-11-22',8,0,0,NULL,0),(7847,66,'2026-11-23',8,0,0,NULL,0),(7848,66,'2026-11-24',8,0,0,NULL,0),(7849,66,'2026-11-25',8,0,0,NULL,0),(7850,66,'2026-11-26',8,0,0,NULL,0),(7851,66,'2026-11-27',8,0,0,NULL,0),(7852,66,'2026-11-28',8,0,0,NULL,0),(7853,66,'2026-11-29',8,0,0,NULL,0),(7854,66,'2026-11-30',8,0,0,NULL,0),(7855,66,'2026-12-01',8,0,0,NULL,0),(7856,66,'2026-12-02',8,0,0,NULL,0),(7857,66,'2026-12-03',8,0,0,NULL,0),(7858,66,'2026-12-04',8,0,0,NULL,0),(7859,66,'2026-12-05',8,0,0,NULL,0),(7860,66,'2026-12-06',8,0,0,NULL,0),(7861,66,'2026-12-07',8,0,0,NULL,0),(7862,66,'2026-12-08',8,0,0,NULL,0),(7863,66,'2026-12-09',8,0,0,NULL,0),(7864,66,'2026-12-10',8,0,0,NULL,0),(7865,66,'2026-12-11',8,0,0,NULL,0),(7866,66,'2026-12-12',8,0,0,NULL,0),(7867,66,'2026-12-13',8,0,0,NULL,0),(7868,66,'2026-12-14',8,0,0,NULL,0),(7869,66,'2026-12-15',8,0,0,NULL,0),(7870,66,'2026-12-16',8,0,0,NULL,0),(7871,66,'2026-12-17',8,0,0,NULL,0),(7872,66,'2026-12-18',8,0,0,NULL,0),(7873,66,'2026-12-19',8,0,0,NULL,0),(7874,66,'2026-12-20',8,0,0,NULL,0),(7875,66,'2026-12-21',8,0,0,NULL,0),(7876,66,'2026-12-22',8,0,0,NULL,0),(7877,66,'2026-12-23',8,0,0,NULL,0),(7878,66,'2026-12-24',8,0,0,NULL,0),(7879,66,'2026-12-25',8,0,0,NULL,0),(7880,66,'2026-12-26',8,0,0,NULL,0),(7881,66,'2026-12-27',8,0,0,NULL,0),(7882,66,'2026-12-28',8,0,0,NULL,0),(7883,66,'2026-12-29',8,0,0,NULL,0),(7884,66,'2026-12-30',8,0,0,NULL,0),(7885,66,'2026-12-31',8,0,0,NULL,0),(7886,66,'2027-01-01',8,0,0,NULL,0),(7887,66,'2027-01-02',8,0,0,NULL,0),(7888,66,'2027-01-03',8,0,0,NULL,0),(7889,66,'2027-01-04',8,0,0,NULL,0),(7890,66,'2027-01-05',8,0,0,NULL,0),(7891,66,'2027-01-06',8,0,0,NULL,0),(7892,66,'2027-01-07',8,0,0,NULL,0),(7893,66,'2027-01-08',8,0,0,NULL,0),(7894,66,'2027-01-09',8,0,0,NULL,0),(7895,66,'2027-01-10',8,0,0,NULL,0),(7896,66,'2027-01-11',8,0,0,NULL,0),(7897,66,'2027-01-12',8,0,0,NULL,0),(7898,66,'2027-01-13',8,0,0,NULL,0),(7899,66,'2027-01-14',8,0,0,NULL,0),(7900,66,'2027-01-15',8,0,0,NULL,0),(7901,66,'2027-01-16',8,0,0,NULL,0),(7902,66,'2027-01-17',8,0,0,NULL,0),(7903,66,'2027-01-18',8,0,0,NULL,0),(7904,66,'2027-01-19',8,0,0,NULL,0),(7905,66,'2027-01-20',8,0,0,NULL,0),(7906,66,'2027-01-21',8,0,0,NULL,0),(7907,66,'2027-01-22',8,0,0,NULL,0),(7908,66,'2027-01-23',8,0,0,NULL,0),(7909,66,'2027-01-24',8,0,0,NULL,0),(7910,66,'2027-01-25',8,0,0,NULL,0),(7911,66,'2027-01-26',8,0,0,NULL,0),(7912,66,'2027-01-27',8,0,0,NULL,0),(7913,66,'2027-01-28',8,0,0,NULL,0),(7914,66,'2027-01-29',8,0,0,NULL,0),(7915,66,'2027-01-30',8,0,0,NULL,0),(7916,66,'2027-01-31',8,0,0,NULL,0),(7917,66,'2027-02-01',8,0,0,NULL,0),(7918,66,'2027-02-02',8,0,0,NULL,0),(7919,66,'2027-02-03',8,0,0,NULL,0),(7920,66,'2027-02-04',8,0,0,NULL,0),(7921,67,'2026-10-08',4,0,0,NULL,0),(7922,67,'2026-10-09',4,0,0,NULL,0),(7923,67,'2026-10-10',4,0,0,NULL,0),(7924,67,'2026-10-11',4,0,0,NULL,0),(7925,67,'2026-10-12',4,0,0,NULL,0),(7926,67,'2026-10-13',4,0,0,NULL,0),(7927,67,'2026-10-14',4,0,0,NULL,0),(7928,67,'2026-10-15',4,0,0,NULL,0),(7929,67,'2026-10-16',4,0,0,NULL,0),(7930,67,'2026-10-17',4,0,0,NULL,0),(7931,67,'2026-10-18',4,0,0,NULL,0),(7932,67,'2026-10-19',4,0,0,NULL,0),(7933,67,'2026-10-20',4,0,0,NULL,0),(7934,67,'2026-10-21',4,0,0,NULL,0),(7935,67,'2026-10-22',4,0,0,NULL,0),(7936,67,'2026-10-23',4,0,0,NULL,0),(7937,67,'2026-10-24',4,0,0,NULL,0),(7938,67,'2026-10-25',4,0,0,NULL,0),(7939,67,'2026-10-26',4,0,0,NULL,0),(7940,67,'2026-10-27',4,0,0,NULL,0),(7941,67,'2026-10-28',4,0,0,NULL,0),(7942,67,'2026-10-29',4,0,0,NULL,0),(7943,67,'2026-10-30',4,0,0,NULL,0),(7944,67,'2026-10-31',4,0,0,NULL,0),(7945,67,'2026-11-01',4,0,0,NULL,0),(7946,67,'2026-11-02',4,0,0,NULL,0),(7947,67,'2026-11-03',4,0,0,NULL,0),(7948,67,'2026-11-04',4,0,0,NULL,0),(7949,67,'2026-11-05',4,0,0,NULL,0),(7950,67,'2026-11-06',4,0,0,NULL,0),(7951,67,'2026-11-07',4,0,0,NULL,0),(7952,67,'2026-11-08',4,0,0,NULL,0),(7953,67,'2026-11-09',4,0,0,NULL,0),(7954,67,'2026-11-10',4,0,0,NULL,0),(7955,67,'2026-11-11',4,0,0,NULL,0),(7956,67,'2026-11-12',4,0,0,NULL,0),(7957,67,'2026-11-13',4,0,0,NULL,0),(7958,67,'2026-11-14',4,0,0,NULL,0),(7959,67,'2026-11-15',4,0,0,NULL,0),(7960,67,'2026-11-16',4,0,0,NULL,0),(7961,67,'2026-11-17',4,0,0,NULL,0),(7962,67,'2026-11-18',4,0,0,NULL,0),(7963,67,'2026-11-19',4,0,0,NULL,0),(7964,67,'2026-11-20',4,0,0,NULL,0),(7965,67,'2026-11-21',4,0,0,NULL,0),(7966,67,'2026-11-22',4,0,0,NULL,0),(7967,67,'2026-11-23',4,0,0,NULL,0),(7968,67,'2026-11-24',4,0,0,NULL,0),(7969,67,'2026-11-25',4,0,0,NULL,0),(7970,67,'2026-11-26',4,0,0,NULL,0),(7971,67,'2026-11-27',4,0,0,NULL,0),(7972,67,'2026-11-28',4,0,0,NULL,0),(7973,67,'2026-11-29',4,0,0,NULL,0),(7974,67,'2026-11-30',4,0,0,NULL,0),(7975,67,'2026-12-01',4,0,0,NULL,0),(7976,67,'2026-12-02',4,0,0,NULL,0),(7977,67,'2026-12-03',4,0,0,NULL,0),(7978,67,'2026-12-04',4,0,0,NULL,0),(7979,67,'2026-12-05',4,0,0,NULL,0),(7980,67,'2026-12-06',4,0,0,NULL,0),(7981,67,'2026-12-07',4,0,0,NULL,0),(7982,67,'2026-12-08',4,0,0,NULL,0),(7983,67,'2026-12-09',4,0,0,NULL,0),(7984,67,'2026-12-10',4,0,0,NULL,0),(7985,67,'2026-12-11',4,0,0,NULL,0),(7986,67,'2026-12-12',4,0,0,NULL,0),(7987,67,'2026-12-13',4,0,0,NULL,0),(7988,67,'2026-12-14',4,0,0,NULL,0),(7989,67,'2026-12-15',4,0,0,NULL,0),(7990,67,'2026-12-16',4,0,0,NULL,0),(7991,67,'2026-12-17',4,0,0,NULL,0),(7992,67,'2026-12-18',4,0,0,NULL,0),(7993,67,'2026-12-19',4,0,0,NULL,0),(7994,67,'2026-12-20',4,0,0,NULL,0),(7995,67,'2026-12-21',4,0,0,NULL,0),(7996,67,'2026-12-22',4,0,0,NULL,0),(7997,67,'2026-12-23',4,0,0,NULL,0),(7998,67,'2026-12-24',4,0,0,NULL,0),(7999,67,'2026-12-25',4,0,0,NULL,0),(8000,67,'2026-12-26',4,0,0,NULL,0),(8001,67,'2026-12-27',4,0,0,NULL,0),(8002,67,'2026-12-28',4,0,0,NULL,0),(8003,67,'2026-12-29',4,0,0,NULL,0),(8004,67,'2026-12-30',4,0,0,NULL,0),(8005,67,'2026-12-31',4,0,0,NULL,0),(8006,67,'2027-01-01',4,0,0,NULL,0),(8007,67,'2027-01-02',4,0,0,NULL,0),(8008,67,'2027-01-03',4,0,0,NULL,0),(8009,67,'2027-01-04',4,0,0,NULL,0),(8010,67,'2027-01-05',4,0,0,NULL,0),(8011,67,'2027-01-06',4,0,0,NULL,0),(8012,67,'2027-01-07',4,0,0,NULL,0),(8013,67,'2027-01-08',4,0,0,NULL,0),(8014,67,'2027-01-09',4,0,0,NULL,0),(8015,67,'2027-01-10',4,0,0,NULL,0),(8016,67,'2027-01-11',4,0,0,NULL,0),(8017,67,'2027-01-12',4,0,0,NULL,0),(8018,67,'2027-01-13',4,0,0,NULL,0),(8019,67,'2027-01-14',4,0,0,NULL,0),(8020,67,'2027-01-15',4,0,0,NULL,0),(8021,67,'2027-01-16',4,0,0,NULL,0),(8022,67,'2027-01-17',4,0,0,NULL,0),(8023,67,'2027-01-18',4,0,0,NULL,0),(8024,67,'2027-01-19',4,0,0,NULL,0),(8025,67,'2027-01-20',4,0,0,NULL,0),(8026,67,'2027-01-21',4,0,0,NULL,0),(8027,67,'2027-01-22',4,0,0,NULL,0),(8028,67,'2027-01-23',4,0,0,NULL,0),(8029,67,'2027-01-24',4,0,0,NULL,0),(8030,67,'2027-01-25',4,0,0,NULL,0),(8031,67,'2027-01-26',4,0,0,NULL,0),(8032,67,'2027-01-27',4,0,0,NULL,0),(8033,67,'2027-01-28',4,0,0,NULL,0),(8034,67,'2027-01-29',4,0,0,NULL,0),(8035,67,'2027-01-30',4,0,0,NULL,0),(8036,67,'2027-01-31',4,0,0,NULL,0),(8037,67,'2027-02-01',4,0,0,NULL,0),(8038,67,'2027-02-02',4,0,0,NULL,0),(8039,67,'2027-02-03',4,0,0,NULL,0),(8040,67,'2027-02-04',4,0,0,NULL,0),(8041,68,'2026-10-08',5,0,0,NULL,0),(8042,68,'2026-10-09',5,0,0,NULL,0),(8043,68,'2026-10-10',5,0,0,NULL,0),(8044,68,'2026-10-11',5,0,0,NULL,0),(8045,68,'2026-10-12',5,0,0,NULL,0),(8046,68,'2026-10-13',5,0,0,NULL,0),(8047,68,'2026-10-14',5,0,0,NULL,0),(8048,68,'2026-10-15',5,0,0,NULL,0),(8049,68,'2026-10-16',5,0,0,NULL,0),(8050,68,'2026-10-17',5,0,0,NULL,0),(8051,68,'2026-10-18',5,0,0,NULL,0),(8052,68,'2026-10-19',5,0,0,NULL,0),(8053,68,'2026-10-20',5,0,0,NULL,0),(8054,68,'2026-10-21',5,0,0,NULL,0),(8055,68,'2026-10-22',5,0,0,NULL,0),(8056,68,'2026-10-23',5,0,0,NULL,0),(8057,68,'2026-10-24',5,0,0,NULL,0),(8058,68,'2026-10-25',5,0,0,NULL,0),(8059,68,'2026-10-26',5,0,0,NULL,0),(8060,68,'2026-10-27',5,0,0,NULL,0),(8061,68,'2026-10-28',5,0,0,NULL,0),(8062,68,'2026-10-29',5,0,0,NULL,0),(8063,68,'2026-10-30',5,0,0,NULL,0),(8064,68,'2026-10-31',5,0,0,NULL,0),(8065,68,'2026-11-01',5,0,0,NULL,0),(8066,68,'2026-11-02',5,0,0,NULL,0),(8067,68,'2026-11-03',5,0,0,NULL,0),(8068,68,'2026-11-04',5,0,0,NULL,0),(8069,68,'2026-11-05',5,0,0,NULL,0),(8070,68,'2026-11-06',5,0,0,NULL,0),(8071,68,'2026-11-07',5,0,0,NULL,0),(8072,68,'2026-11-08',5,0,0,NULL,0),(8073,68,'2026-11-09',5,0,0,NULL,0),(8074,68,'2026-11-10',5,0,0,NULL,0),(8075,68,'2026-11-11',5,0,0,NULL,0),(8076,68,'2026-11-12',5,0,0,NULL,0),(8077,68,'2026-11-13',5,0,0,NULL,0),(8078,68,'2026-11-14',5,0,0,NULL,0),(8079,68,'2026-11-15',5,0,0,NULL,0),(8080,68,'2026-11-16',5,0,0,NULL,0),(8081,68,'2026-11-17',5,0,0,NULL,0),(8082,68,'2026-11-18',5,0,0,NULL,0),(8083,68,'2026-11-19',5,0,0,NULL,0),(8084,68,'2026-11-20',5,0,0,NULL,0),(8085,68,'2026-11-21',5,0,0,NULL,0),(8086,68,'2026-11-22',5,0,0,NULL,0),(8087,68,'2026-11-23',5,0,0,NULL,0),(8088,68,'2026-11-24',5,0,0,NULL,0),(8089,68,'2026-11-25',5,0,0,NULL,0),(8090,68,'2026-11-26',5,0,0,NULL,0),(8091,68,'2026-11-27',5,0,0,NULL,0),(8092,68,'2026-11-28',5,0,0,NULL,0),(8093,68,'2026-11-29',5,0,0,NULL,0),(8094,68,'2026-11-30',5,0,0,NULL,0),(8095,68,'2026-12-01',5,0,0,NULL,0),(8096,68,'2026-12-02',5,0,0,NULL,0),(8097,68,'2026-12-03',5,0,0,NULL,0),(8098,68,'2026-12-04',5,0,0,NULL,0),(8099,68,'2026-12-05',5,0,0,NULL,0),(8100,68,'2026-12-06',5,0,0,NULL,0),(8101,68,'2026-12-07',5,0,0,NULL,0),(8102,68,'2026-12-08',5,0,0,NULL,0),(8103,68,'2026-12-09',5,0,0,NULL,0),(8104,68,'2026-12-10',5,0,0,NULL,0),(8105,68,'2026-12-11',5,0,0,NULL,0),(8106,68,'2026-12-12',5,0,0,NULL,0),(8107,68,'2026-12-13',5,0,0,NULL,0),(8108,68,'2026-12-14',5,0,0,NULL,0),(8109,68,'2026-12-15',5,0,0,NULL,0),(8110,68,'2026-12-16',5,0,0,NULL,0),(8111,68,'2026-12-17',5,0,0,NULL,0),(8112,68,'2026-12-18',5,0,0,NULL,0),(8113,68,'2026-12-19',5,0,0,NULL,0),(8114,68,'2026-12-20',5,0,0,NULL,0),(8115,68,'2026-12-21',5,0,0,NULL,0),(8116,68,'2026-12-22',5,0,0,NULL,0),(8117,68,'2026-12-23',5,0,0,NULL,0),(8118,68,'2026-12-24',5,0,0,NULL,0),(8119,68,'2026-12-25',5,0,0,NULL,0),(8120,68,'2026-12-26',5,0,0,NULL,0),(8121,68,'2026-12-27',5,0,0,NULL,0),(8122,68,'2026-12-28',5,0,0,NULL,0),(8123,68,'2026-12-29',5,0,0,NULL,0),(8124,68,'2026-12-30',5,0,0,NULL,0),(8125,68,'2026-12-31',5,0,0,NULL,0),(8126,68,'2027-01-01',5,0,0,NULL,0),(8127,68,'2027-01-02',5,0,0,NULL,0),(8128,68,'2027-01-03',5,0,0,NULL,0),(8129,68,'2027-01-04',5,0,0,NULL,0),(8130,68,'2027-01-05',5,0,0,NULL,0),(8131,68,'2027-01-06',5,0,0,NULL,0),(8132,68,'2027-01-07',5,0,0,NULL,0),(8133,68,'2027-01-08',5,0,0,NULL,0),(8134,68,'2027-01-09',5,0,0,NULL,0),(8135,68,'2027-01-10',5,0,0,NULL,0),(8136,68,'2027-01-11',5,0,0,NULL,0),(8137,68,'2027-01-12',5,0,0,NULL,0),(8138,68,'2027-01-13',5,0,0,NULL,0),(8139,68,'2027-01-14',5,0,0,NULL,0),(8140,68,'2027-01-15',5,0,0,NULL,0),(8141,68,'2027-01-16',5,0,0,NULL,0),(8142,68,'2027-01-17',5,0,0,NULL,0),(8143,68,'2027-01-18',5,0,0,NULL,0),(8144,68,'2027-01-19',5,0,0,NULL,0),(8145,68,'2027-01-20',5,0,0,NULL,0),(8146,68,'2027-01-21',5,0,0,NULL,0),(8147,68,'2027-01-22',5,0,0,NULL,0),(8148,68,'2027-01-23',5,0,0,NULL,0),(8149,68,'2027-01-24',5,0,0,NULL,0),(8150,68,'2027-01-25',5,0,0,NULL,0),(8151,68,'2027-01-26',5,0,0,NULL,0),(8152,68,'2027-01-27',5,0,0,NULL,0),(8153,68,'2027-01-28',5,0,0,NULL,0),(8154,68,'2027-01-29',5,0,0,NULL,0),(8155,68,'2027-01-30',5,0,0,NULL,0),(8156,68,'2027-01-31',5,0,0,NULL,0),(8157,68,'2027-02-01',5,0,0,NULL,0),(8158,68,'2027-02-02',5,0,0,NULL,0),(8159,68,'2027-02-03',5,0,0,NULL,0),(8160,68,'2027-02-04',5,0,0,NULL,0),(8161,69,'2026-10-08',2,0,0,NULL,0),(8162,69,'2026-10-09',2,0,0,NULL,0),(8163,69,'2026-10-10',2,0,0,NULL,0),(8164,69,'2026-10-11',2,0,0,NULL,0),(8165,69,'2026-10-12',2,0,0,NULL,0),(8166,69,'2026-10-13',2,0,0,NULL,0),(8167,69,'2026-10-14',2,0,0,NULL,0),(8168,69,'2026-10-15',2,0,0,NULL,0),(8169,69,'2026-10-16',2,0,0,NULL,0),(8170,69,'2026-10-17',2,0,0,NULL,0),(8171,69,'2026-10-18',2,0,0,NULL,0),(8172,69,'2026-10-19',2,0,0,NULL,0),(8173,69,'2026-10-20',2,0,0,NULL,0),(8174,69,'2026-10-21',2,0,0,NULL,0),(8175,69,'2026-10-22',2,0,0,NULL,0),(8176,69,'2026-10-23',2,0,0,NULL,0),(8177,69,'2026-10-24',2,0,0,NULL,0),(8178,69,'2026-10-25',2,0,0,NULL,0),(8179,69,'2026-10-26',2,0,0,NULL,0),(8180,69,'2026-10-27',2,0,0,NULL,0),(8181,69,'2026-10-28',2,0,0,NULL,0),(8182,69,'2026-10-29',2,0,0,NULL,0),(8183,69,'2026-10-30',2,0,0,NULL,0),(8184,69,'2026-10-31',2,0,0,NULL,0),(8185,69,'2026-11-01',2,0,0,NULL,0),(8186,69,'2026-11-02',2,0,0,NULL,0),(8187,69,'2026-11-03',2,0,0,NULL,0),(8188,69,'2026-11-04',2,0,0,NULL,0),(8189,69,'2026-11-05',2,0,0,NULL,0),(8190,69,'2026-11-06',2,0,0,NULL,0),(8191,69,'2026-11-07',2,0,0,NULL,0),(8192,69,'2026-11-08',2,0,0,NULL,0),(8193,69,'2026-11-09',2,0,0,NULL,0),(8194,69,'2026-11-10',2,0,0,NULL,0),(8195,69,'2026-11-11',2,0,0,NULL,0),(8196,69,'2026-11-12',2,0,0,NULL,0),(8197,69,'2026-11-13',2,0,0,NULL,0),(8198,69,'2026-11-14',2,0,0,NULL,0),(8199,69,'2026-11-15',2,0,0,NULL,0),(8200,69,'2026-11-16',2,0,0,NULL,0),(8201,69,'2026-11-17',2,0,0,NULL,0),(8202,69,'2026-11-18',2,0,0,NULL,0),(8203,69,'2026-11-19',2,0,0,NULL,0),(8204,69,'2026-11-20',2,0,0,NULL,0),(8205,69,'2026-11-21',2,0,0,NULL,0),(8206,69,'2026-11-22',2,0,0,NULL,0),(8207,69,'2026-11-23',2,0,0,NULL,0),(8208,69,'2026-11-24',2,0,0,NULL,0),(8209,69,'2026-11-25',2,0,0,NULL,0),(8210,69,'2026-11-26',2,0,0,NULL,0),(8211,69,'2026-11-27',2,0,0,NULL,0),(8212,69,'2026-11-28',2,0,0,NULL,0),(8213,69,'2026-11-29',2,0,0,NULL,0),(8214,69,'2026-11-30',2,0,0,NULL,0),(8215,69,'2026-12-01',2,0,0,NULL,0),(8216,69,'2026-12-02',2,0,0,NULL,0),(8217,69,'2026-12-03',2,0,0,NULL,0),(8218,69,'2026-12-04',2,0,0,NULL,0),(8219,69,'2026-12-05',2,0,0,NULL,0),(8220,69,'2026-12-06',2,0,0,NULL,0),(8221,69,'2026-12-07',2,0,0,NULL,0),(8222,69,'2026-12-08',2,0,0,NULL,0),(8223,69,'2026-12-09',2,0,0,NULL,0),(8224,69,'2026-12-10',2,0,0,NULL,0),(8225,69,'2026-12-11',2,0,0,NULL,0),(8226,69,'2026-12-12',2,0,0,NULL,0),(8227,69,'2026-12-13',2,0,0,NULL,0),(8228,69,'2026-12-14',2,0,0,NULL,0),(8229,69,'2026-12-15',2,0,0,NULL,0),(8230,69,'2026-12-16',2,0,0,NULL,0),(8231,69,'2026-12-17',2,0,0,NULL,0),(8232,69,'2026-12-18',2,0,0,NULL,0),(8233,69,'2026-12-19',2,0,0,NULL,0),(8234,69,'2026-12-20',2,0,0,NULL,0),(8235,69,'2026-12-21',2,0,0,NULL,0),(8236,69,'2026-12-22',2,0,0,NULL,0),(8237,69,'2026-12-23',2,0,0,NULL,0),(8238,69,'2026-12-24',2,0,0,NULL,0),(8239,69,'2026-12-25',2,0,0,NULL,0),(8240,69,'2026-12-26',2,0,0,NULL,0),(8241,69,'2026-12-27',2,0,0,NULL,0),(8242,69,'2026-12-28',2,0,0,NULL,0),(8243,69,'2026-12-29',2,0,0,NULL,0),(8244,69,'2026-12-30',2,0,0,NULL,0),(8245,69,'2026-12-31',2,0,0,NULL,0),(8246,69,'2027-01-01',2,0,0,NULL,0),(8247,69,'2027-01-02',2,0,0,NULL,0),(8248,69,'2027-01-03',2,0,0,NULL,0),(8249,69,'2027-01-04',2,0,0,NULL,0),(8250,69,'2027-01-05',2,0,0,NULL,0),(8251,69,'2027-01-06',2,0,0,NULL,0),(8252,69,'2027-01-07',2,0,0,NULL,0),(8253,69,'2027-01-08',2,0,0,NULL,0),(8254,69,'2027-01-09',2,0,0,NULL,0),(8255,69,'2027-01-10',2,0,0,NULL,0),(8256,69,'2027-01-11',2,0,0,NULL,0),(8257,69,'2027-01-12',2,0,0,NULL,0),(8258,69,'2027-01-13',2,0,0,NULL,0),(8259,69,'2027-01-14',2,0,0,NULL,0),(8260,69,'2027-01-15',2,0,0,NULL,0),(8261,69,'2027-01-16',2,0,0,NULL,0),(8262,69,'2027-01-17',2,0,0,NULL,0),(8263,69,'2027-01-18',2,0,0,NULL,0),(8264,69,'2027-01-19',2,0,0,NULL,0),(8265,69,'2027-01-20',2,0,0,NULL,0),(8266,69,'2027-01-21',2,0,0,NULL,0),(8267,69,'2027-01-22',2,0,0,NULL,0),(8268,69,'2027-01-23',2,0,0,NULL,0),(8269,69,'2027-01-24',2,0,0,NULL,0),(8270,69,'2027-01-25',2,0,0,NULL,0),(8271,69,'2027-01-26',2,0,0,NULL,0),(8272,69,'2027-01-27',2,0,0,NULL,0),(8273,69,'2027-01-28',2,0,0,NULL,0),(8274,69,'2027-01-29',2,0,0,NULL,0),(8275,69,'2027-01-30',2,0,0,NULL,0),(8276,69,'2027-01-31',2,0,0,NULL,0),(8277,69,'2027-02-01',2,0,0,NULL,0),(8278,69,'2027-02-02',2,0,0,NULL,0),(8279,69,'2027-02-03',2,0,0,NULL,0),(8280,69,'2027-02-04',2,0,0,NULL,0),(8281,70,'2026-10-08',6,0,0,NULL,0),(8282,70,'2026-10-09',6,0,0,NULL,0),(8283,70,'2026-10-10',6,0,0,NULL,0),(8284,70,'2026-10-11',6,0,0,NULL,0),(8285,70,'2026-10-12',6,0,0,NULL,0),(8286,70,'2026-10-13',6,0,0,NULL,0),(8287,70,'2026-10-14',6,0,0,NULL,0),(8288,70,'2026-10-15',6,0,0,NULL,0),(8289,70,'2026-10-16',6,0,0,NULL,0),(8290,70,'2026-10-17',6,0,0,NULL,0),(8291,70,'2026-10-18',6,0,0,NULL,0),(8292,70,'2026-10-19',6,0,0,NULL,0),(8293,70,'2026-10-20',6,0,0,NULL,0),(8294,70,'2026-10-21',6,0,0,NULL,0),(8295,70,'2026-10-22',6,0,0,NULL,0),(8296,70,'2026-10-23',6,0,0,NULL,0),(8297,70,'2026-10-24',6,0,0,NULL,0),(8298,70,'2026-10-25',6,0,0,NULL,0),(8299,70,'2026-10-26',6,0,0,NULL,0),(8300,70,'2026-10-27',6,0,0,NULL,0),(8301,70,'2026-10-28',6,0,0,NULL,0),(8302,70,'2026-10-29',6,0,0,NULL,0),(8303,70,'2026-10-30',6,0,0,NULL,0),(8304,70,'2026-10-31',6,0,0,NULL,0),(8305,70,'2026-11-01',6,0,0,NULL,0),(8306,70,'2026-11-02',6,0,0,NULL,0),(8307,70,'2026-11-03',6,0,0,NULL,0),(8308,70,'2026-11-04',6,0,0,NULL,0),(8309,70,'2026-11-05',6,0,0,NULL,0),(8310,70,'2026-11-06',6,0,0,NULL,0),(8311,70,'2026-11-07',6,0,0,NULL,0),(8312,70,'2026-11-08',6,0,0,NULL,0),(8313,70,'2026-11-09',6,0,0,NULL,0),(8314,70,'2026-11-10',6,0,0,NULL,0),(8315,70,'2026-11-11',6,0,0,NULL,0),(8316,70,'2026-11-12',6,0,0,NULL,0),(8317,70,'2026-11-13',6,0,0,NULL,0),(8318,70,'2026-11-14',6,0,0,NULL,0),(8319,70,'2026-11-15',6,0,0,NULL,0),(8320,70,'2026-11-16',6,0,0,NULL,0),(8321,70,'2026-11-17',6,0,0,NULL,0),(8322,70,'2026-11-18',6,0,0,NULL,0),(8323,70,'2026-11-19',6,0,0,NULL,0),(8324,70,'2026-11-20',6,0,0,NULL,0),(8325,70,'2026-11-21',6,0,0,NULL,0),(8326,70,'2026-11-22',6,0,0,NULL,0),(8327,70,'2026-11-23',6,0,0,NULL,0),(8328,70,'2026-11-24',6,0,0,NULL,0),(8329,70,'2026-11-25',6,0,0,NULL,0),(8330,70,'2026-11-26',6,0,0,NULL,0),(8331,70,'2026-11-27',6,0,0,NULL,0),(8332,70,'2026-11-28',6,0,0,NULL,0),(8333,70,'2026-11-29',6,0,0,NULL,0),(8334,70,'2026-11-30',6,0,0,NULL,0),(8335,70,'2026-12-01',6,0,0,NULL,0),(8336,70,'2026-12-02',6,0,0,NULL,0),(8337,70,'2026-12-03',6,0,0,NULL,0),(8338,70,'2026-12-04',6,0,0,NULL,0),(8339,70,'2026-12-05',6,0,0,NULL,0),(8340,70,'2026-12-06',6,0,0,NULL,0),(8341,70,'2026-12-07',6,0,0,NULL,0),(8342,70,'2026-12-08',6,0,0,NULL,0),(8343,70,'2026-12-09',6,0,0,NULL,0),(8344,70,'2026-12-10',6,0,0,NULL,0),(8345,70,'2026-12-11',6,0,0,NULL,0),(8346,70,'2026-12-12',6,0,0,NULL,0),(8347,70,'2026-12-13',6,0,0,NULL,0),(8348,70,'2026-12-14',6,0,0,NULL,0),(8349,70,'2026-12-15',6,0,0,NULL,0),(8350,70,'2026-12-16',6,0,0,NULL,0),(8351,70,'2026-12-17',6,0,0,NULL,0),(8352,70,'2026-12-18',6,0,0,NULL,0),(8353,70,'2026-12-19',6,0,0,NULL,0),(8354,70,'2026-12-20',6,0,0,NULL,0),(8355,70,'2026-12-21',6,0,0,NULL,0),(8356,70,'2026-12-22',6,0,0,NULL,0),(8357,70,'2026-12-23',6,0,0,NULL,0),(8358,70,'2026-12-24',6,0,0,NULL,0),(8359,70,'2026-12-25',6,0,0,NULL,0),(8360,70,'2026-12-26',6,0,0,NULL,0),(8361,70,'2026-12-27',6,0,0,NULL,0),(8362,70,'2026-12-28',6,0,0,NULL,0),(8363,70,'2026-12-29',6,0,0,NULL,0),(8364,70,'2026-12-30',6,0,0,NULL,0),(8365,70,'2026-12-31',6,0,0,NULL,0),(8366,70,'2027-01-01',6,0,0,NULL,0),(8367,70,'2027-01-02',6,0,0,NULL,0),(8368,70,'2027-01-03',6,0,0,NULL,0),(8369,70,'2027-01-04',6,0,0,NULL,0),(8370,70,'2027-01-05',6,0,0,NULL,0),(8371,70,'2027-01-06',6,0,0,NULL,0),(8372,70,'2027-01-07',6,0,0,NULL,0),(8373,70,'2027-01-08',6,0,0,NULL,0),(8374,70,'2027-01-09',6,0,0,NULL,0),(8375,70,'2027-01-10',6,0,0,NULL,0),(8376,70,'2027-01-11',6,0,0,NULL,0),(8377,70,'2027-01-12',6,0,0,NULL,0),(8378,70,'2027-01-13',6,0,0,NULL,0),(8379,70,'2027-01-14',6,0,0,NULL,0),(8380,70,'2027-01-15',6,0,0,NULL,0),(8381,70,'2027-01-16',6,0,0,NULL,0),(8382,70,'2027-01-17',6,0,0,NULL,0),(8383,70,'2027-01-18',6,0,0,NULL,0),(8384,70,'2027-01-19',6,0,0,NULL,0),(8385,70,'2027-01-20',6,0,0,NULL,0),(8386,70,'2027-01-21',6,0,0,NULL,0),(8387,70,'2027-01-22',6,0,0,NULL,0),(8388,70,'2027-01-23',6,0,0,NULL,0),(8389,70,'2027-01-24',6,0,0,NULL,0),(8390,70,'2027-01-25',6,0,0,NULL,0),(8391,70,'2027-01-26',6,0,0,NULL,0),(8392,70,'2027-01-27',6,0,0,NULL,0),(8393,70,'2027-01-28',6,0,0,NULL,0),(8394,70,'2027-01-29',6,0,0,NULL,0),(8395,70,'2027-01-30',6,0,0,NULL,0),(8396,70,'2027-01-31',6,0,0,NULL,0),(8397,70,'2027-02-01',6,0,0,NULL,0),(8398,70,'2027-02-02',6,0,0,NULL,0),(8399,70,'2027-02-03',6,0,0,NULL,0),(8400,70,'2027-02-04',6,0,0,NULL,0),(8401,71,'2026-10-08',3,0,0,NULL,0),(8402,71,'2026-10-09',3,0,0,NULL,0),(8403,71,'2026-10-10',3,0,0,NULL,0),(8404,71,'2026-10-11',3,0,0,NULL,0),(8405,71,'2026-10-12',3,0,0,NULL,0),(8406,71,'2026-10-13',3,0,0,NULL,0),(8407,71,'2026-10-14',3,0,0,NULL,0),(8408,71,'2026-10-15',3,0,0,NULL,0),(8409,71,'2026-10-16',3,0,0,NULL,0),(8410,71,'2026-10-17',3,0,0,NULL,0),(8411,71,'2026-10-18',3,0,0,NULL,0),(8412,71,'2026-10-19',3,0,0,NULL,0),(8413,71,'2026-10-20',3,0,0,NULL,0),(8414,71,'2026-10-21',3,0,0,NULL,0),(8415,71,'2026-10-22',3,0,0,NULL,0),(8416,71,'2026-10-23',3,0,0,NULL,0),(8417,71,'2026-10-24',3,0,0,NULL,0),(8418,71,'2026-10-25',3,0,0,NULL,0),(8419,71,'2026-10-26',3,0,0,NULL,0),(8420,71,'2026-10-27',3,0,0,NULL,0),(8421,71,'2026-10-28',3,0,0,NULL,0),(8422,71,'2026-10-29',3,0,0,NULL,0),(8423,71,'2026-10-30',3,0,0,NULL,0),(8424,71,'2026-10-31',3,0,0,NULL,0),(8425,71,'2026-11-01',3,0,0,NULL,0),(8426,71,'2026-11-02',3,0,0,NULL,0),(8427,71,'2026-11-03',3,0,0,NULL,0),(8428,71,'2026-11-04',3,0,0,NULL,0),(8429,71,'2026-11-05',3,0,0,NULL,0),(8430,71,'2026-11-06',3,0,0,NULL,0),(8431,71,'2026-11-07',3,0,0,NULL,0),(8432,71,'2026-11-08',3,0,0,NULL,0),(8433,71,'2026-11-09',3,0,0,NULL,0),(8434,71,'2026-11-10',3,0,0,NULL,0),(8435,71,'2026-11-11',3,0,0,NULL,0),(8436,71,'2026-11-12',3,0,0,NULL,0),(8437,71,'2026-11-13',3,0,0,NULL,0),(8438,71,'2026-11-14',3,0,0,NULL,0),(8439,71,'2026-11-15',3,0,0,NULL,0),(8440,71,'2026-11-16',3,0,0,NULL,0),(8441,71,'2026-11-17',3,0,0,NULL,0),(8442,71,'2026-11-18',3,0,0,NULL,0),(8443,71,'2026-11-19',3,0,0,NULL,0),(8444,71,'2026-11-20',3,0,0,NULL,0),(8445,71,'2026-11-21',3,0,0,NULL,0),(8446,71,'2026-11-22',3,0,0,NULL,0),(8447,71,'2026-11-23',3,0,0,NULL,0),(8448,71,'2026-11-24',3,0,0,NULL,0),(8449,71,'2026-11-25',3,0,0,NULL,0),(8450,71,'2026-11-26',3,0,0,NULL,0),(8451,71,'2026-11-27',3,0,0,NULL,0),(8452,71,'2026-11-28',3,0,0,NULL,0),(8453,71,'2026-11-29',3,0,0,NULL,0),(8454,71,'2026-11-30',3,0,0,NULL,0),(8455,71,'2026-12-01',3,0,0,NULL,0),(8456,71,'2026-12-02',3,0,0,NULL,0),(8457,71,'2026-12-03',3,0,0,NULL,0),(8458,71,'2026-12-04',3,0,0,NULL,0),(8459,71,'2026-12-05',3,0,0,NULL,0),(8460,71,'2026-12-06',3,0,0,NULL,0),(8461,71,'2026-12-07',3,0,0,NULL,0),(8462,71,'2026-12-08',3,0,0,NULL,0),(8463,71,'2026-12-09',3,0,0,NULL,0),(8464,71,'2026-12-10',3,0,0,NULL,0),(8465,71,'2026-12-11',3,0,0,NULL,0),(8466,71,'2026-12-12',3,0,0,NULL,0),(8467,71,'2026-12-13',3,0,0,NULL,0),(8468,71,'2026-12-14',3,0,0,NULL,0),(8469,71,'2026-12-15',3,0,0,NULL,0),(8470,71,'2026-12-16',3,0,0,NULL,0),(8471,71,'2026-12-17',3,0,0,NULL,0),(8472,71,'2026-12-18',3,0,0,NULL,0),(8473,71,'2026-12-19',3,0,0,NULL,0),(8474,71,'2026-12-20',3,0,0,NULL,0),(8475,71,'2026-12-21',3,0,0,NULL,0),(8476,71,'2026-12-22',3,0,0,NULL,0),(8477,71,'2026-12-23',3,0,0,NULL,0),(8478,71,'2026-12-24',3,0,0,NULL,0),(8479,71,'2026-12-25',3,0,0,NULL,0),(8480,71,'2026-12-26',3,0,0,NULL,0),(8481,71,'2026-12-27',3,0,0,NULL,0),(8482,71,'2026-12-28',3,0,0,NULL,0),(8483,71,'2026-12-29',3,0,0,NULL,0),(8484,71,'2026-12-30',3,0,0,NULL,0),(8485,71,'2026-12-31',3,0,0,NULL,0),(8486,71,'2027-01-01',3,0,0,NULL,0),(8487,71,'2027-01-02',3,0,0,NULL,0),(8488,71,'2027-01-03',3,0,0,NULL,0),(8489,71,'2027-01-04',3,0,0,NULL,0),(8490,71,'2027-01-05',3,0,0,NULL,0),(8491,71,'2027-01-06',3,0,0,NULL,0),(8492,71,'2027-01-07',3,0,0,NULL,0),(8493,71,'2027-01-08',3,0,0,NULL,0),(8494,71,'2027-01-09',3,0,0,NULL,0),(8495,71,'2027-01-10',3,0,0,NULL,0),(8496,71,'2027-01-11',3,0,0,NULL,0),(8497,71,'2027-01-12',3,0,0,NULL,0),(8498,71,'2027-01-13',3,0,0,NULL,0),(8499,71,'2027-01-14',3,0,0,NULL,0),(8500,71,'2027-01-15',3,0,0,NULL,0),(8501,71,'2027-01-16',3,0,0,NULL,0),(8502,71,'2027-01-17',3,0,0,NULL,0),(8503,71,'2027-01-18',3,0,0,NULL,0),(8504,71,'2027-01-19',3,0,0,NULL,0),(8505,71,'2027-01-20',3,0,0,NULL,0),(8506,71,'2027-01-21',3,0,0,NULL,0),(8507,71,'2027-01-22',3,0,0,NULL,0),(8508,71,'2027-01-23',3,0,0,NULL,0),(8509,71,'2027-01-24',3,0,0,NULL,0),(8510,71,'2027-01-25',3,0,0,NULL,0),(8511,71,'2027-01-26',3,0,0,NULL,0),(8512,71,'2027-01-27',3,0,0,NULL,0),(8513,71,'2027-01-28',3,0,0,NULL,0),(8514,71,'2027-01-29',3,0,0,NULL,0),(8515,71,'2027-01-30',3,0,0,NULL,0),(8516,71,'2027-01-31',3,0,0,NULL,0),(8517,71,'2027-02-01',3,0,0,NULL,0),(8518,71,'2027-02-02',3,0,0,NULL,0),(8519,71,'2027-02-03',3,0,0,NULL,0),(8520,71,'2027-02-04',3,0,0,NULL,0),(8521,72,'2026-10-08',5,0,0,NULL,0),(8522,72,'2026-10-09',5,0,0,NULL,0),(8523,72,'2026-10-10',5,0,0,NULL,0),(8524,72,'2026-10-11',5,0,0,NULL,0),(8525,72,'2026-10-12',5,0,0,NULL,0),(8526,72,'2026-10-13',5,0,0,NULL,0),(8527,72,'2026-10-14',5,0,0,NULL,0),(8528,72,'2026-10-15',5,0,0,NULL,0),(8529,72,'2026-10-16',5,0,0,NULL,0),(8530,72,'2026-10-17',5,0,0,NULL,0),(8531,72,'2026-10-18',5,0,0,NULL,0),(8532,72,'2026-10-19',5,0,0,NULL,0),(8533,72,'2026-10-20',5,0,0,NULL,0),(8534,72,'2026-10-21',5,0,0,NULL,0),(8535,72,'2026-10-22',5,0,0,NULL,0),(8536,72,'2026-10-23',5,0,0,NULL,0),(8537,72,'2026-10-24',5,0,0,NULL,0),(8538,72,'2026-10-25',5,0,0,NULL,0),(8539,72,'2026-10-26',5,0,0,NULL,0),(8540,72,'2026-10-27',5,0,0,NULL,0),(8541,72,'2026-10-28',5,0,0,NULL,0),(8542,72,'2026-10-29',5,0,0,NULL,0),(8543,72,'2026-10-30',5,0,0,NULL,0),(8544,72,'2026-10-31',5,0,0,NULL,0),(8545,72,'2026-11-01',5,0,0,NULL,0),(8546,72,'2026-11-02',5,0,0,NULL,0),(8547,72,'2026-11-03',5,0,0,NULL,0),(8548,72,'2026-11-04',5,0,0,NULL,0),(8549,72,'2026-11-05',5,0,0,NULL,0),(8550,72,'2026-11-06',5,0,0,NULL,0),(8551,72,'2026-11-07',5,0,0,NULL,0),(8552,72,'2026-11-08',5,0,0,NULL,0),(8553,72,'2026-11-09',5,0,0,NULL,0),(8554,72,'2026-11-10',5,0,0,NULL,0),(8555,72,'2026-11-11',5,0,0,NULL,0),(8556,72,'2026-11-12',5,0,0,NULL,0),(8557,72,'2026-11-13',5,0,0,NULL,0),(8558,72,'2026-11-14',5,0,0,NULL,0),(8559,72,'2026-11-15',5,0,0,NULL,0),(8560,72,'2026-11-16',5,0,0,NULL,0),(8561,72,'2026-11-17',5,0,0,NULL,0),(8562,72,'2026-11-18',5,0,0,NULL,0),(8563,72,'2026-11-19',5,0,0,NULL,0),(8564,72,'2026-11-20',5,0,0,NULL,0),(8565,72,'2026-11-21',5,0,0,NULL,0),(8566,72,'2026-11-22',5,0,0,NULL,0),(8567,72,'2026-11-23',5,0,0,NULL,0),(8568,72,'2026-11-24',5,0,0,NULL,0),(8569,72,'2026-11-25',5,0,0,NULL,0),(8570,72,'2026-11-26',5,0,0,NULL,0),(8571,72,'2026-11-27',5,0,0,NULL,0),(8572,72,'2026-11-28',5,0,0,NULL,0),(8573,72,'2026-11-29',5,0,0,NULL,0),(8574,72,'2026-11-30',5,0,0,NULL,0),(8575,72,'2026-12-01',5,0,0,NULL,0),(8576,72,'2026-12-02',5,0,0,NULL,0),(8577,72,'2026-12-03',5,0,0,NULL,0),(8578,72,'2026-12-04',5,0,0,NULL,0),(8579,72,'2026-12-05',5,0,0,NULL,0),(8580,72,'2026-12-06',5,0,0,NULL,0),(8581,72,'2026-12-07',5,0,0,NULL,0),(8582,72,'2026-12-08',5,0,0,NULL,0),(8583,72,'2026-12-09',5,0,0,NULL,0),(8584,72,'2026-12-10',5,0,0,NULL,0),(8585,72,'2026-12-11',5,0,0,NULL,0),(8586,72,'2026-12-12',5,0,0,NULL,0),(8587,72,'2026-12-13',5,0,0,NULL,0),(8588,72,'2026-12-14',5,0,0,NULL,0),(8589,72,'2026-12-15',5,0,0,NULL,0),(8590,72,'2026-12-16',5,0,0,NULL,0),(8591,72,'2026-12-17',5,0,0,NULL,0),(8592,72,'2026-12-18',5,0,0,NULL,0),(8593,72,'2026-12-19',5,0,0,NULL,0),(8594,72,'2026-12-20',5,0,0,NULL,0),(8595,72,'2026-12-21',5,0,0,NULL,0),(8596,72,'2026-12-22',5,0,0,NULL,0),(8597,72,'2026-12-23',5,0,0,NULL,0),(8598,72,'2026-12-24',5,0,0,NULL,0),(8599,72,'2026-12-25',5,0,0,NULL,0),(8600,72,'2026-12-26',5,0,0,NULL,0),(8601,72,'2026-12-27',5,0,0,NULL,0),(8602,72,'2026-12-28',5,0,0,NULL,0),(8603,72,'2026-12-29',5,0,0,NULL,0),(8604,72,'2026-12-30',5,0,0,NULL,0),(8605,72,'2026-12-31',5,0,0,NULL,0),(8606,72,'2027-01-01',5,0,0,NULL,0),(8607,72,'2027-01-02',5,0,0,NULL,0),(8608,72,'2027-01-03',5,0,0,NULL,0),(8609,72,'2027-01-04',5,0,0,NULL,0),(8610,72,'2027-01-05',5,0,0,NULL,0),(8611,72,'2027-01-06',5,0,0,NULL,0),(8612,72,'2027-01-07',5,0,0,NULL,0),(8613,72,'2027-01-08',5,0,0,NULL,0),(8614,72,'2027-01-09',5,0,0,NULL,0),(8615,72,'2027-01-10',5,0,0,NULL,0),(8616,72,'2027-01-11',5,0,0,NULL,0),(8617,72,'2027-01-12',5,0,0,NULL,0),(8618,72,'2027-01-13',5,0,0,NULL,0),(8619,72,'2027-01-14',5,0,0,NULL,0),(8620,72,'2027-01-15',5,0,0,NULL,0),(8621,72,'2027-01-16',5,0,0,NULL,0),(8622,72,'2027-01-17',5,0,0,NULL,0),(8623,72,'2027-01-18',5,0,0,NULL,0),(8624,72,'2027-01-19',5,0,0,NULL,0),(8625,72,'2027-01-20',5,0,0,NULL,0),(8626,72,'2027-01-21',5,0,0,NULL,0),(8627,72,'2027-01-22',5,0,0,NULL,0),(8628,72,'2027-01-23',5,0,0,NULL,0),(8629,72,'2027-01-24',5,0,0,NULL,0),(8630,72,'2027-01-25',5,0,0,NULL,0),(8631,72,'2027-01-26',5,0,0,NULL,0),(8632,72,'2027-01-27',5,0,0,NULL,0),(8633,72,'2027-01-28',5,0,0,NULL,0),(8634,72,'2027-01-29',5,0,0,NULL,0),(8635,72,'2027-01-30',5,0,0,NULL,0),(8636,72,'2027-01-31',5,0,0,NULL,0),(8637,72,'2027-02-01',5,0,0,NULL,0),(8638,72,'2027-02-02',5,0,0,NULL,0),(8639,72,'2027-02-03',5,0,0,NULL,0),(8640,72,'2027-02-04',5,0,0,NULL,0),(8641,73,'2026-10-08',2,0,0,NULL,0),(8642,73,'2026-10-09',2,0,0,NULL,0),(8643,73,'2026-10-10',2,0,0,NULL,0),(8644,73,'2026-10-11',2,0,0,NULL,0),(8645,73,'2026-10-12',2,0,0,NULL,0),(8646,73,'2026-10-13',2,0,0,NULL,0),(8647,73,'2026-10-14',2,0,0,NULL,0),(8648,73,'2026-10-15',2,0,0,NULL,0),(8649,73,'2026-10-16',2,0,0,NULL,0),(8650,73,'2026-10-17',2,0,0,NULL,0),(8651,73,'2026-10-18',2,0,0,NULL,0),(8652,73,'2026-10-19',2,0,0,NULL,0),(8653,73,'2026-10-20',2,0,0,NULL,0),(8654,73,'2026-10-21',2,0,0,NULL,0),(8655,73,'2026-10-22',2,0,0,NULL,0),(8656,73,'2026-10-23',2,0,0,NULL,0),(8657,73,'2026-10-24',2,0,0,NULL,0),(8658,73,'2026-10-25',2,0,0,NULL,0),(8659,73,'2026-10-26',2,0,0,NULL,0),(8660,73,'2026-10-27',2,0,0,NULL,0),(8661,73,'2026-10-28',2,0,0,NULL,0),(8662,73,'2026-10-29',2,0,0,NULL,0),(8663,73,'2026-10-30',2,0,0,NULL,0),(8664,73,'2026-10-31',2,0,0,NULL,0),(8665,73,'2026-11-01',2,0,0,NULL,0),(8666,73,'2026-11-02',2,0,0,NULL,0),(8667,73,'2026-11-03',2,0,0,NULL,0),(8668,73,'2026-11-04',2,0,0,NULL,0),(8669,73,'2026-11-05',2,0,0,NULL,0),(8670,73,'2026-11-06',2,0,0,NULL,0),(8671,73,'2026-11-07',2,0,0,NULL,0),(8672,73,'2026-11-08',2,0,0,NULL,0),(8673,73,'2026-11-09',2,0,0,NULL,0),(8674,73,'2026-11-10',2,0,0,NULL,0),(8675,73,'2026-11-11',2,0,0,NULL,0),(8676,73,'2026-11-12',2,0,0,NULL,0),(8677,73,'2026-11-13',2,0,0,NULL,0),(8678,73,'2026-11-14',2,0,0,NULL,0),(8679,73,'2026-11-15',2,0,0,NULL,0),(8680,73,'2026-11-16',2,0,0,NULL,0),(8681,73,'2026-11-17',2,0,0,NULL,0),(8682,73,'2026-11-18',2,0,0,NULL,0),(8683,73,'2026-11-19',2,0,0,NULL,0),(8684,73,'2026-11-20',2,0,0,NULL,0),(8685,73,'2026-11-21',2,0,0,NULL,0),(8686,73,'2026-11-22',2,0,0,NULL,0),(8687,73,'2026-11-23',2,0,0,NULL,0),(8688,73,'2026-11-24',2,0,0,NULL,0),(8689,73,'2026-11-25',2,0,0,NULL,0),(8690,73,'2026-11-26',2,0,0,NULL,0),(8691,73,'2026-11-27',2,0,0,NULL,0),(8692,73,'2026-11-28',2,0,0,NULL,0),(8693,73,'2026-11-29',2,0,0,NULL,0),(8694,73,'2026-11-30',2,0,0,NULL,0),(8695,73,'2026-12-01',2,0,0,NULL,0),(8696,73,'2026-12-02',2,0,0,NULL,0),(8697,73,'2026-12-03',2,0,0,NULL,0),(8698,73,'2026-12-04',2,0,0,NULL,0),(8699,73,'2026-12-05',2,0,0,NULL,0),(8700,73,'2026-12-06',2,0,0,NULL,0),(8701,73,'2026-12-07',2,0,0,NULL,0),(8702,73,'2026-12-08',2,0,0,NULL,0),(8703,73,'2026-12-09',2,0,0,NULL,0),(8704,73,'2026-12-10',2,0,0,NULL,0),(8705,73,'2026-12-11',2,0,0,NULL,0),(8706,73,'2026-12-12',2,0,0,NULL,0),(8707,73,'2026-12-13',2,0,0,NULL,0),(8708,73,'2026-12-14',2,0,0,NULL,0),(8709,73,'2026-12-15',2,0,0,NULL,0),(8710,73,'2026-12-16',2,0,0,NULL,0),(8711,73,'2026-12-17',2,0,0,NULL,0),(8712,73,'2026-12-18',2,0,0,NULL,0),(8713,73,'2026-12-19',2,0,0,NULL,0),(8714,73,'2026-12-20',2,0,0,NULL,0),(8715,73,'2026-12-21',2,0,0,NULL,0),(8716,73,'2026-12-22',2,0,0,NULL,0),(8717,73,'2026-12-23',2,0,0,NULL,0),(8718,73,'2026-12-24',2,0,0,NULL,0),(8719,73,'2026-12-25',2,0,0,NULL,0),(8720,73,'2026-12-26',2,0,0,NULL,0),(8721,73,'2026-12-27',2,0,0,NULL,0),(8722,73,'2026-12-28',2,0,0,NULL,0),(8723,73,'2026-12-29',2,0,0,NULL,0),(8724,73,'2026-12-30',2,0,0,NULL,0),(8725,73,'2026-12-31',2,0,0,NULL,0),(8726,73,'2027-01-01',2,0,0,NULL,0),(8727,73,'2027-01-02',2,0,0,NULL,0),(8728,73,'2027-01-03',2,0,0,NULL,0),(8729,73,'2027-01-04',2,0,0,NULL,0),(8730,73,'2027-01-05',2,0,0,NULL,0),(8731,73,'2027-01-06',2,0,0,NULL,0),(8732,73,'2027-01-07',2,0,0,NULL,0),(8733,73,'2027-01-08',2,0,0,NULL,0),(8734,73,'2027-01-09',2,0,0,NULL,0),(8735,73,'2027-01-10',2,0,0,NULL,0),(8736,73,'2027-01-11',2,0,0,NULL,0),(8737,73,'2027-01-12',2,0,0,NULL,0),(8738,73,'2027-01-13',2,0,0,NULL,0),(8739,73,'2027-01-14',2,0,0,NULL,0),(8740,73,'2027-01-15',2,0,0,NULL,0),(8741,73,'2027-01-16',2,0,0,NULL,0),(8742,73,'2027-01-17',2,0,0,NULL,0),(8743,73,'2027-01-18',2,0,0,NULL,0),(8744,73,'2027-01-19',2,0,0,NULL,0),(8745,73,'2027-01-20',2,0,0,NULL,0),(8746,73,'2027-01-21',2,0,0,NULL,0),(8747,73,'2027-01-22',2,0,0,NULL,0),(8748,73,'2027-01-23',2,0,0,NULL,0),(8749,73,'2027-01-24',2,0,0,NULL,0),(8750,73,'2027-01-25',2,0,0,NULL,0),(8751,73,'2027-01-26',2,0,0,NULL,0),(8752,73,'2027-01-27',2,0,0,NULL,0),(8753,73,'2027-01-28',2,0,0,NULL,0),(8754,73,'2027-01-29',2,0,0,NULL,0),(8755,73,'2027-01-30',2,0,0,NULL,0),(8756,73,'2027-01-31',2,0,0,NULL,0),(8757,73,'2027-02-01',2,0,0,NULL,0),(8758,73,'2027-02-02',2,0,0,NULL,0),(8759,73,'2027-02-03',2,0,0,NULL,0),(8760,73,'2027-02-04',2,0,0,NULL,0),(8761,74,'2026-10-08',6,0,0,NULL,0),(8762,74,'2026-10-09',6,0,0,NULL,0),(8763,74,'2026-10-10',6,0,0,NULL,0),(8764,74,'2026-10-11',6,0,0,NULL,0),(8765,74,'2026-10-12',6,0,0,NULL,0),(8766,74,'2026-10-13',6,0,0,NULL,0),(8767,74,'2026-10-14',6,0,0,NULL,0),(8768,74,'2026-10-15',6,0,0,NULL,0),(8769,74,'2026-10-16',6,0,0,NULL,0),(8770,74,'2026-10-17',6,0,0,NULL,0),(8771,74,'2026-10-18',6,0,0,NULL,0),(8772,74,'2026-10-19',6,0,0,NULL,0),(8773,74,'2026-10-20',6,0,0,NULL,0),(8774,74,'2026-10-21',6,0,0,NULL,0),(8775,74,'2026-10-22',6,0,0,NULL,0),(8776,74,'2026-10-23',6,0,0,NULL,0),(8777,74,'2026-10-24',6,0,0,NULL,0),(8778,74,'2026-10-25',6,0,0,NULL,0),(8779,74,'2026-10-26',6,0,0,NULL,0),(8780,74,'2026-10-27',6,0,0,NULL,0),(8781,74,'2026-10-28',6,0,0,NULL,0),(8782,74,'2026-10-29',6,0,0,NULL,0),(8783,74,'2026-10-30',6,0,0,NULL,0),(8784,74,'2026-10-31',6,0,0,NULL,0),(8785,74,'2026-11-01',6,0,0,NULL,0),(8786,74,'2026-11-02',6,0,0,NULL,0),(8787,74,'2026-11-03',6,0,0,NULL,0),(8788,74,'2026-11-04',6,0,0,NULL,0),(8789,74,'2026-11-05',6,0,0,NULL,0),(8790,74,'2026-11-06',6,0,0,NULL,0),(8791,74,'2026-11-07',6,0,0,NULL,0),(8792,74,'2026-11-08',6,0,0,NULL,0),(8793,74,'2026-11-09',6,0,0,NULL,0),(8794,74,'2026-11-10',6,0,0,NULL,0),(8795,74,'2026-11-11',6,0,0,NULL,0),(8796,74,'2026-11-12',6,0,0,NULL,0),(8797,74,'2026-11-13',6,0,0,NULL,0),(8798,74,'2026-11-14',6,0,0,NULL,0),(8799,74,'2026-11-15',6,0,0,NULL,0),(8800,74,'2026-11-16',6,0,0,NULL,0),(8801,74,'2026-11-17',6,0,0,NULL,0),(8802,74,'2026-11-18',6,0,0,NULL,0),(8803,74,'2026-11-19',6,0,0,NULL,0),(8804,74,'2026-11-20',6,0,0,NULL,0),(8805,74,'2026-11-21',6,0,0,NULL,0),(8806,74,'2026-11-22',6,0,0,NULL,0),(8807,74,'2026-11-23',6,0,0,NULL,0),(8808,74,'2026-11-24',6,0,0,NULL,0),(8809,74,'2026-11-25',6,0,0,NULL,0),(8810,74,'2026-11-26',6,0,0,NULL,0),(8811,74,'2026-11-27',6,0,0,NULL,0),(8812,74,'2026-11-28',6,0,0,NULL,0),(8813,74,'2026-11-29',6,0,0,NULL,0),(8814,74,'2026-11-30',6,0,0,NULL,0),(8815,74,'2026-12-01',6,0,0,NULL,0),(8816,74,'2026-12-02',6,0,0,NULL,0),(8817,74,'2026-12-03',6,0,0,NULL,0),(8818,74,'2026-12-04',6,0,0,NULL,0),(8819,74,'2026-12-05',6,0,0,NULL,0),(8820,74,'2026-12-06',6,0,0,NULL,0),(8821,74,'2026-12-07',6,0,0,NULL,0),(8822,74,'2026-12-08',6,0,0,NULL,0),(8823,74,'2026-12-09',6,0,0,NULL,0),(8824,74,'2026-12-10',6,0,0,NULL,0),(8825,74,'2026-12-11',6,0,0,NULL,0),(8826,74,'2026-12-12',6,0,0,NULL,0),(8827,74,'2026-12-13',6,0,0,NULL,0),(8828,74,'2026-12-14',6,0,0,NULL,0),(8829,74,'2026-12-15',6,0,0,NULL,0),(8830,74,'2026-12-16',6,0,0,NULL,0),(8831,74,'2026-12-17',6,0,0,NULL,0),(8832,74,'2026-12-18',6,0,0,NULL,0),(8833,74,'2026-12-19',6,0,0,NULL,0),(8834,74,'2026-12-20',6,0,0,NULL,0),(8835,74,'2026-12-21',6,0,0,NULL,0),(8836,74,'2026-12-22',6,0,0,NULL,0),(8837,74,'2026-12-23',6,0,0,NULL,0),(8838,74,'2026-12-24',6,0,0,NULL,0),(8839,74,'2026-12-25',6,0,0,NULL,0),(8840,74,'2026-12-26',6,0,0,NULL,0),(8841,74,'2026-12-27',6,0,0,NULL,0),(8842,74,'2026-12-28',6,0,0,NULL,0),(8843,74,'2026-12-29',6,0,0,NULL,0),(8844,74,'2026-12-30',6,0,0,NULL,0),(8845,74,'2026-12-31',6,0,0,NULL,0),(8846,74,'2027-01-01',6,0,0,NULL,0),(8847,74,'2027-01-02',6,0,0,NULL,0),(8848,74,'2027-01-03',6,0,0,NULL,0),(8849,74,'2027-01-04',6,0,0,NULL,0),(8850,74,'2027-01-05',6,0,0,NULL,0),(8851,74,'2027-01-06',6,0,0,NULL,0),(8852,74,'2027-01-07',6,0,0,NULL,0),(8853,74,'2027-01-08',6,0,0,NULL,0),(8854,74,'2027-01-09',6,0,0,NULL,0),(8855,74,'2027-01-10',6,0,0,NULL,0),(8856,74,'2027-01-11',6,0,0,NULL,0),(8857,74,'2027-01-12',6,0,0,NULL,0),(8858,74,'2027-01-13',6,0,0,NULL,0),(8859,74,'2027-01-14',6,0,0,NULL,0),(8860,74,'2027-01-15',6,0,0,NULL,0),(8861,74,'2027-01-16',6,0,0,NULL,0),(8862,74,'2027-01-17',6,0,0,NULL,0),(8863,74,'2027-01-18',6,0,0,NULL,0),(8864,74,'2027-01-19',6,0,0,NULL,0),(8865,74,'2027-01-20',6,0,0,NULL,0),(8866,74,'2027-01-21',6,0,0,NULL,0),(8867,74,'2027-01-22',6,0,0,NULL,0),(8868,74,'2027-01-23',6,0,0,NULL,0),(8869,74,'2027-01-24',6,0,0,NULL,0),(8870,74,'2027-01-25',6,0,0,NULL,0),(8871,74,'2027-01-26',6,0,0,NULL,0),(8872,74,'2027-01-27',6,0,0,NULL,0),(8873,74,'2027-01-28',6,0,0,NULL,0),(8874,74,'2027-01-29',6,0,0,NULL,0),(8875,74,'2027-01-30',6,0,0,NULL,0),(8876,74,'2027-01-31',6,0,0,NULL,0),(8877,74,'2027-02-01',6,0,0,NULL,0),(8878,74,'2027-02-02',6,0,0,NULL,0),(8879,74,'2027-02-03',6,0,0,NULL,0),(8880,74,'2027-02-04',6,0,0,NULL,0),(8881,75,'2026-10-08',2,0,0,NULL,0),(8882,75,'2026-10-09',2,0,0,NULL,0),(8883,75,'2026-10-10',2,0,0,NULL,0),(8884,75,'2026-10-11',2,0,0,NULL,0),(8885,75,'2026-10-12',2,0,0,NULL,0),(8886,75,'2026-10-13',2,0,0,NULL,0),(8887,75,'2026-10-14',2,0,0,NULL,0),(8888,75,'2026-10-15',2,0,0,NULL,0),(8889,75,'2026-10-16',2,0,0,NULL,0),(8890,75,'2026-10-17',2,0,0,NULL,0),(8891,75,'2026-10-18',2,0,0,NULL,0),(8892,75,'2026-10-19',2,0,0,NULL,0),(8893,75,'2026-10-20',2,0,0,NULL,0),(8894,75,'2026-10-21',2,0,0,NULL,0),(8895,75,'2026-10-22',2,0,0,NULL,0),(8896,75,'2026-10-23',2,0,0,NULL,0),(8897,75,'2026-10-24',2,0,0,NULL,0),(8898,75,'2026-10-25',2,0,0,NULL,0),(8899,75,'2026-10-26',2,0,0,NULL,0),(8900,75,'2026-10-27',2,0,0,NULL,0),(8901,75,'2026-10-28',2,0,0,NULL,0),(8902,75,'2026-10-29',2,0,0,NULL,0),(8903,75,'2026-10-30',2,0,0,NULL,0),(8904,75,'2026-10-31',2,0,0,NULL,0),(8905,75,'2026-11-01',2,0,0,NULL,0),(8906,75,'2026-11-02',2,0,0,NULL,0),(8907,75,'2026-11-03',2,0,0,NULL,0),(8908,75,'2026-11-04',2,0,0,NULL,0),(8909,75,'2026-11-05',2,0,0,NULL,0),(8910,75,'2026-11-06',2,0,0,NULL,0),(8911,75,'2026-11-07',2,0,0,NULL,0),(8912,75,'2026-11-08',2,0,0,NULL,0),(8913,75,'2026-11-09',2,0,0,NULL,0),(8914,75,'2026-11-10',2,0,0,NULL,0),(8915,75,'2026-11-11',2,0,0,NULL,0),(8916,75,'2026-11-12',2,0,0,NULL,0),(8917,75,'2026-11-13',2,0,0,NULL,0),(8918,75,'2026-11-14',2,0,0,NULL,0),(8919,75,'2026-11-15',2,0,0,NULL,0),(8920,75,'2026-11-16',2,0,0,NULL,0),(8921,75,'2026-11-17',2,0,0,NULL,0),(8922,75,'2026-11-18',2,0,0,NULL,0),(8923,75,'2026-11-19',2,0,0,NULL,0),(8924,75,'2026-11-20',2,0,0,NULL,0),(8925,75,'2026-11-21',2,0,0,NULL,0),(8926,75,'2026-11-22',2,0,0,NULL,0),(8927,75,'2026-11-23',2,0,0,NULL,0),(8928,75,'2026-11-24',2,0,0,NULL,0),(8929,75,'2026-11-25',2,0,0,NULL,0),(8930,75,'2026-11-26',2,0,0,NULL,0),(8931,75,'2026-11-27',2,0,0,NULL,0),(8932,75,'2026-11-28',2,0,0,NULL,0),(8933,75,'2026-11-29',2,0,0,NULL,0),(8934,75,'2026-11-30',2,0,0,NULL,0),(8935,75,'2026-12-01',2,0,0,NULL,0),(8936,75,'2026-12-02',2,0,0,NULL,0),(8937,75,'2026-12-03',2,0,0,NULL,0),(8938,75,'2026-12-04',2,0,0,NULL,0),(8939,75,'2026-12-05',2,0,0,NULL,0),(8940,75,'2026-12-06',2,0,0,NULL,0),(8941,75,'2026-12-07',2,0,0,NULL,0),(8942,75,'2026-12-08',2,0,0,NULL,0),(8943,75,'2026-12-09',2,0,0,NULL,0),(8944,75,'2026-12-10',2,0,0,NULL,0),(8945,75,'2026-12-11',2,0,0,NULL,0),(8946,75,'2026-12-12',2,0,0,NULL,0),(8947,75,'2026-12-13',2,0,0,NULL,0),(8948,75,'2026-12-14',2,0,0,NULL,0),(8949,75,'2026-12-15',2,0,0,NULL,0),(8950,75,'2026-12-16',2,0,0,NULL,0),(8951,75,'2026-12-17',2,0,0,NULL,0),(8952,75,'2026-12-18',2,0,0,NULL,0),(8953,75,'2026-12-19',2,0,0,NULL,0),(8954,75,'2026-12-20',2,0,0,NULL,0),(8955,75,'2026-12-21',2,0,0,NULL,0),(8956,75,'2026-12-22',2,0,0,NULL,0),(8957,75,'2026-12-23',2,0,0,NULL,0),(8958,75,'2026-12-24',2,0,0,NULL,0),(8959,75,'2026-12-25',2,0,0,NULL,0),(8960,75,'2026-12-26',2,0,0,NULL,0),(8961,75,'2026-12-27',2,0,0,NULL,0),(8962,75,'2026-12-28',2,0,0,NULL,0),(8963,75,'2026-12-29',2,0,0,NULL,0),(8964,75,'2026-12-30',2,0,0,NULL,0),(8965,75,'2026-12-31',2,0,0,NULL,0),(8966,75,'2027-01-01',2,0,0,NULL,0),(8967,75,'2027-01-02',2,0,0,NULL,0),(8968,75,'2027-01-03',2,0,0,NULL,0),(8969,75,'2027-01-04',2,0,0,NULL,0),(8970,75,'2027-01-05',2,0,0,NULL,0),(8971,75,'2027-01-06',2,0,0,NULL,0),(8972,75,'2027-01-07',2,0,0,NULL,0),(8973,75,'2027-01-08',2,0,0,NULL,0),(8974,75,'2027-01-09',2,0,0,NULL,0),(8975,75,'2027-01-10',2,0,0,NULL,0),(8976,75,'2027-01-11',2,0,0,NULL,0),(8977,75,'2027-01-12',2,0,0,NULL,0),(8978,75,'2027-01-13',2,0,0,NULL,0),(8979,75,'2027-01-14',2,0,0,NULL,0),(8980,75,'2027-01-15',2,0,0,NULL,0),(8981,75,'2027-01-16',2,0,0,NULL,0),(8982,75,'2027-01-17',2,0,0,NULL,0),(8983,75,'2027-01-18',2,0,0,NULL,0),(8984,75,'2027-01-19',2,0,0,NULL,0),(8985,75,'2027-01-20',2,0,0,NULL,0),(8986,75,'2027-01-21',2,0,0,NULL,0),(8987,75,'2027-01-22',2,0,0,NULL,0),(8988,75,'2027-01-23',2,0,0,NULL,0),(8989,75,'2027-01-24',2,0,0,NULL,0),(8990,75,'2027-01-25',2,0,0,NULL,0),(8991,75,'2027-01-26',2,0,0,NULL,0),(8992,75,'2027-01-27',2,0,0,NULL,0),(8993,75,'2027-01-28',2,0,0,NULL,0),(8994,75,'2027-01-29',2,0,0,NULL,0),(8995,75,'2027-01-30',2,0,0,NULL,0),(8996,75,'2027-01-31',2,0,0,NULL,0),(8997,75,'2027-02-01',2,0,0,NULL,0),(8998,75,'2027-02-02',2,0,0,NULL,0),(8999,75,'2027-02-03',2,0,0,NULL,0),(9000,75,'2027-02-04',2,0,0,NULL,0),(9001,76,'2026-10-08',5,0,0,NULL,0),(9002,76,'2026-10-09',5,0,0,NULL,0),(9003,76,'2026-10-10',5,0,0,NULL,0),(9004,76,'2026-10-11',5,0,0,NULL,0),(9005,76,'2026-10-12',5,0,0,NULL,0),(9006,76,'2026-10-13',5,0,0,NULL,0),(9007,76,'2026-10-14',5,0,0,NULL,0),(9008,76,'2026-10-15',5,0,0,NULL,0),(9009,76,'2026-10-16',5,0,0,NULL,0),(9010,76,'2026-10-17',5,0,0,NULL,0),(9011,76,'2026-10-18',5,0,0,NULL,0),(9012,76,'2026-10-19',5,0,0,NULL,0),(9013,76,'2026-10-20',5,0,0,NULL,0),(9014,76,'2026-10-21',5,0,0,NULL,0),(9015,76,'2026-10-22',5,0,0,NULL,0),(9016,76,'2026-10-23',5,0,0,NULL,0),(9017,76,'2026-10-24',5,0,0,NULL,0),(9018,76,'2026-10-25',5,0,0,NULL,0),(9019,76,'2026-10-26',5,0,0,NULL,0),(9020,76,'2026-10-27',5,0,0,NULL,0),(9021,76,'2026-10-28',5,0,0,NULL,0),(9022,76,'2026-10-29',5,0,0,NULL,0),(9023,76,'2026-10-30',5,0,0,NULL,0),(9024,76,'2026-10-31',5,0,0,NULL,0),(9025,76,'2026-11-01',5,0,0,NULL,0),(9026,76,'2026-11-02',5,0,0,NULL,0),(9027,76,'2026-11-03',5,0,0,NULL,0),(9028,76,'2026-11-04',5,0,0,NULL,0),(9029,76,'2026-11-05',5,0,0,NULL,0),(9030,76,'2026-11-06',5,0,0,NULL,0),(9031,76,'2026-11-07',5,0,0,NULL,0),(9032,76,'2026-11-08',5,0,0,NULL,0),(9033,76,'2026-11-09',5,0,0,NULL,0),(9034,76,'2026-11-10',5,0,0,NULL,0),(9035,76,'2026-11-11',5,0,0,NULL,0),(9036,76,'2026-11-12',5,0,0,NULL,0),(9037,76,'2026-11-13',5,0,0,NULL,0),(9038,76,'2026-11-14',5,0,0,NULL,0),(9039,76,'2026-11-15',5,0,0,NULL,0),(9040,76,'2026-11-16',5,0,0,NULL,0),(9041,76,'2026-11-17',5,0,0,NULL,0),(9042,76,'2026-11-18',5,0,0,NULL,0),(9043,76,'2026-11-19',5,0,0,NULL,0),(9044,76,'2026-11-20',5,0,0,NULL,0),(9045,76,'2026-11-21',5,0,0,NULL,0),(9046,76,'2026-11-22',5,0,0,NULL,0),(9047,76,'2026-11-23',5,0,0,NULL,0),(9048,76,'2026-11-24',5,0,0,NULL,0),(9049,76,'2026-11-25',5,0,0,NULL,0),(9050,76,'2026-11-26',5,0,0,NULL,0),(9051,76,'2026-11-27',5,0,0,NULL,0),(9052,76,'2026-11-28',5,0,0,NULL,0),(9053,76,'2026-11-29',5,0,0,NULL,0),(9054,76,'2026-11-30',5,0,0,NULL,0),(9055,76,'2026-12-01',5,0,0,NULL,0),(9056,76,'2026-12-02',5,0,0,NULL,0),(9057,76,'2026-12-03',5,0,0,NULL,0),(9058,76,'2026-12-04',5,0,0,NULL,0),(9059,76,'2026-12-05',5,0,0,NULL,0),(9060,76,'2026-12-06',5,0,0,NULL,0),(9061,76,'2026-12-07',5,0,0,NULL,0),(9062,76,'2026-12-08',5,0,0,NULL,0),(9063,76,'2026-12-09',5,0,0,NULL,0),(9064,76,'2026-12-10',5,0,0,NULL,0),(9065,76,'2026-12-11',5,0,0,NULL,0),(9066,76,'2026-12-12',5,0,0,NULL,0),(9067,76,'2026-12-13',5,0,0,NULL,0),(9068,76,'2026-12-14',5,0,0,NULL,0),(9069,76,'2026-12-15',5,0,0,NULL,0),(9070,76,'2026-12-16',5,0,0,NULL,0),(9071,76,'2026-12-17',5,0,0,NULL,0),(9072,76,'2026-12-18',5,0,0,NULL,0),(9073,76,'2026-12-19',5,0,0,NULL,0),(9074,76,'2026-12-20',5,0,0,NULL,0),(9075,76,'2026-12-21',5,0,0,NULL,0),(9076,76,'2026-12-22',5,0,0,NULL,0),(9077,76,'2026-12-23',5,0,0,NULL,0),(9078,76,'2026-12-24',5,0,0,NULL,0),(9079,76,'2026-12-25',5,0,0,NULL,0),(9080,76,'2026-12-26',5,0,0,NULL,0),(9081,76,'2026-12-27',5,0,0,NULL,0),(9082,76,'2026-12-28',5,0,0,NULL,0),(9083,76,'2026-12-29',5,0,0,NULL,0),(9084,76,'2026-12-30',5,0,0,NULL,0),(9085,76,'2026-12-31',5,0,0,NULL,0),(9086,76,'2027-01-01',5,0,0,NULL,0),(9087,76,'2027-01-02',5,0,0,NULL,0),(9088,76,'2027-01-03',5,0,0,NULL,0),(9089,76,'2027-01-04',5,0,0,NULL,0),(9090,76,'2027-01-05',5,0,0,NULL,0),(9091,76,'2027-01-06',5,0,0,NULL,0),(9092,76,'2027-01-07',5,0,0,NULL,0),(9093,76,'2027-01-08',5,0,0,NULL,0),(9094,76,'2027-01-09',5,0,0,NULL,0),(9095,76,'2027-01-10',5,0,0,NULL,0),(9096,76,'2027-01-11',5,0,0,NULL,0),(9097,76,'2027-01-12',5,0,0,NULL,0),(9098,76,'2027-01-13',5,0,0,NULL,0),(9099,76,'2027-01-14',5,0,0,NULL,0),(9100,76,'2027-01-15',5,0,0,NULL,0),(9101,76,'2027-01-16',5,0,0,NULL,0),(9102,76,'2027-01-17',5,0,0,NULL,0),(9103,76,'2027-01-18',5,0,0,NULL,0),(9104,76,'2027-01-19',5,0,0,NULL,0),(9105,76,'2027-01-20',5,0,0,NULL,0),(9106,76,'2027-01-21',5,0,0,NULL,0),(9107,76,'2027-01-22',5,0,0,NULL,0),(9108,76,'2027-01-23',5,0,0,NULL,0),(9109,76,'2027-01-24',5,0,0,NULL,0),(9110,76,'2027-01-25',5,0,0,NULL,0),(9111,76,'2027-01-26',5,0,0,NULL,0),(9112,76,'2027-01-27',5,0,0,NULL,0),(9113,76,'2027-01-28',5,0,0,NULL,0),(9114,76,'2027-01-29',5,0,0,NULL,0),(9115,76,'2027-01-30',5,0,0,NULL,0),(9116,76,'2027-01-31',5,0,0,NULL,0),(9117,76,'2027-02-01',5,0,0,NULL,0),(9118,76,'2027-02-02',5,0,0,NULL,0),(9119,76,'2027-02-03',5,0,0,NULL,0),(9120,76,'2027-02-04',5,0,0,NULL,0),(9121,77,'2026-10-08',3,0,0,NULL,0),(9122,77,'2026-10-09',3,0,0,NULL,0),(9123,77,'2026-10-10',3,0,0,NULL,0),(9124,77,'2026-10-11',3,0,0,NULL,0),(9125,77,'2026-10-12',3,0,0,NULL,0),(9126,77,'2026-10-13',3,0,0,NULL,0),(9127,77,'2026-10-14',3,0,0,NULL,0),(9128,77,'2026-10-15',3,0,0,NULL,0),(9129,77,'2026-10-16',3,0,0,NULL,0),(9130,77,'2026-10-17',3,0,0,NULL,0),(9131,77,'2026-10-18',3,0,0,NULL,0),(9132,77,'2026-10-19',3,0,0,NULL,0),(9133,77,'2026-10-20',3,0,0,NULL,0),(9134,77,'2026-10-21',3,0,0,NULL,0),(9135,77,'2026-10-22',3,0,0,NULL,0),(9136,77,'2026-10-23',3,0,0,NULL,0),(9137,77,'2026-10-24',3,0,0,NULL,0),(9138,77,'2026-10-25',3,0,0,NULL,0),(9139,77,'2026-10-26',3,0,0,NULL,0),(9140,77,'2026-10-27',3,0,0,NULL,0),(9141,77,'2026-10-28',3,0,0,NULL,0),(9142,77,'2026-10-29',3,0,0,NULL,0),(9143,77,'2026-10-30',3,0,0,NULL,0),(9144,77,'2026-10-31',3,0,0,NULL,0),(9145,77,'2026-11-01',3,0,0,NULL,0),(9146,77,'2026-11-02',3,0,0,NULL,0),(9147,77,'2026-11-03',3,0,0,NULL,0),(9148,77,'2026-11-04',3,0,0,NULL,0),(9149,77,'2026-11-05',3,0,0,NULL,0),(9150,77,'2026-11-06',3,0,0,NULL,0),(9151,77,'2026-11-07',3,0,0,NULL,0),(9152,77,'2026-11-08',3,0,0,NULL,0),(9153,77,'2026-11-09',3,0,0,NULL,0),(9154,77,'2026-11-10',3,0,0,NULL,0),(9155,77,'2026-11-11',3,0,0,NULL,0),(9156,77,'2026-11-12',3,0,0,NULL,0),(9157,77,'2026-11-13',3,0,0,NULL,0),(9158,77,'2026-11-14',3,0,0,NULL,0),(9159,77,'2026-11-15',3,0,0,NULL,0),(9160,77,'2026-11-16',3,0,0,NULL,0),(9161,77,'2026-11-17',3,0,0,NULL,0),(9162,77,'2026-11-18',3,0,0,NULL,0),(9163,77,'2026-11-19',3,0,0,NULL,0),(9164,77,'2026-11-20',3,0,0,NULL,0),(9165,77,'2026-11-21',3,0,0,NULL,0),(9166,77,'2026-11-22',3,0,0,NULL,0),(9167,77,'2026-11-23',3,0,0,NULL,0),(9168,77,'2026-11-24',3,0,0,NULL,0),(9169,77,'2026-11-25',3,0,0,NULL,0),(9170,77,'2026-11-26',3,0,0,NULL,0),(9171,77,'2026-11-27',3,0,0,NULL,0),(9172,77,'2026-11-28',3,0,0,NULL,0),(9173,77,'2026-11-29',3,0,0,NULL,0),(9174,77,'2026-11-30',3,0,0,NULL,0),(9175,77,'2026-12-01',3,0,0,NULL,0),(9176,77,'2026-12-02',3,0,0,NULL,0),(9177,77,'2026-12-03',3,0,0,NULL,0),(9178,77,'2026-12-04',3,0,0,NULL,0),(9179,77,'2026-12-05',3,0,0,NULL,0),(9180,77,'2026-12-06',3,0,0,NULL,0),(9181,77,'2026-12-07',3,0,0,NULL,0),(9182,77,'2026-12-08',3,0,0,NULL,0),(9183,77,'2026-12-09',3,0,0,NULL,0),(9184,77,'2026-12-10',3,0,0,NULL,0),(9185,77,'2026-12-11',3,0,0,NULL,0),(9186,77,'2026-12-12',3,0,0,NULL,0),(9187,77,'2026-12-13',3,0,0,NULL,0),(9188,77,'2026-12-14',3,0,0,NULL,0),(9189,77,'2026-12-15',3,0,0,NULL,0),(9190,77,'2026-12-16',3,0,0,NULL,0),(9191,77,'2026-12-17',3,0,0,NULL,0),(9192,77,'2026-12-18',3,0,0,NULL,0),(9193,77,'2026-12-19',3,0,0,NULL,0),(9194,77,'2026-12-20',3,0,0,NULL,0),(9195,77,'2026-12-21',3,0,0,NULL,0),(9196,77,'2026-12-22',3,0,0,NULL,0),(9197,77,'2026-12-23',3,0,0,NULL,0),(9198,77,'2026-12-24',3,0,0,NULL,0),(9199,77,'2026-12-25',3,0,0,NULL,0),(9200,77,'2026-12-26',3,0,0,NULL,0),(9201,77,'2026-12-27',3,0,0,NULL,0),(9202,77,'2026-12-28',3,0,0,NULL,0),(9203,77,'2026-12-29',3,0,0,NULL,0),(9204,77,'2026-12-30',3,0,0,NULL,0),(9205,77,'2026-12-31',3,0,0,NULL,0),(9206,77,'2027-01-01',3,0,0,NULL,0),(9207,77,'2027-01-02',3,0,0,NULL,0),(9208,77,'2027-01-03',3,0,0,NULL,0),(9209,77,'2027-01-04',3,0,0,NULL,0),(9210,77,'2027-01-05',3,0,0,NULL,0),(9211,77,'2027-01-06',3,0,0,NULL,0),(9212,77,'2027-01-07',3,0,0,NULL,0),(9213,77,'2027-01-08',3,0,0,NULL,0),(9214,77,'2027-01-09',3,0,0,NULL,0),(9215,77,'2027-01-10',3,0,0,NULL,0),(9216,77,'2027-01-11',3,0,0,NULL,0),(9217,77,'2027-01-12',3,0,0,NULL,0),(9218,77,'2027-01-13',3,0,0,NULL,0),(9219,77,'2027-01-14',3,0,0,NULL,0),(9220,77,'2027-01-15',3,0,0,NULL,0),(9221,77,'2027-01-16',3,0,0,NULL,0),(9222,77,'2027-01-17',3,0,0,NULL,0),(9223,77,'2027-01-18',3,0,0,NULL,0),(9224,77,'2027-01-19',3,0,0,NULL,0),(9225,77,'2027-01-20',3,0,0,NULL,0),(9226,77,'2027-01-21',3,0,0,NULL,0),(9227,77,'2027-01-22',3,0,0,NULL,0),(9228,77,'2027-01-23',3,0,0,NULL,0),(9229,77,'2027-01-24',3,0,0,NULL,0),(9230,77,'2027-01-25',3,0,0,NULL,0),(9231,77,'2027-01-26',3,0,0,NULL,0),(9232,77,'2027-01-27',3,0,0,NULL,0),(9233,77,'2027-01-28',3,0,0,NULL,0),(9234,77,'2027-01-29',3,0,0,NULL,0),(9235,77,'2027-01-30',3,0,0,NULL,0),(9236,77,'2027-01-31',3,0,0,NULL,0),(9237,77,'2027-02-01',3,0,0,NULL,0),(9238,77,'2027-02-02',3,0,0,NULL,0),(9239,77,'2027-02-03',3,0,0,NULL,0),(9240,77,'2027-02-04',3,0,0,NULL,0),(9241,78,'2026-10-08',4,0,0,NULL,0),(9242,78,'2026-10-09',4,0,0,NULL,0),(9243,78,'2026-10-10',4,0,0,NULL,0),(9244,78,'2026-10-11',4,0,0,NULL,0),(9245,78,'2026-10-12',4,0,0,NULL,0),(9246,78,'2026-10-13',4,0,0,NULL,0),(9247,78,'2026-10-14',4,0,0,NULL,0),(9248,78,'2026-10-15',4,0,0,NULL,0),(9249,78,'2026-10-16',4,0,0,NULL,0),(9250,78,'2026-10-17',4,0,0,NULL,0),(9251,78,'2026-10-18',4,0,0,NULL,0),(9252,78,'2026-10-19',4,0,0,NULL,0),(9253,78,'2026-10-20',4,0,0,NULL,0),(9254,78,'2026-10-21',4,0,0,NULL,0),(9255,78,'2026-10-22',4,0,0,NULL,0),(9256,78,'2026-10-23',4,0,0,NULL,0),(9257,78,'2026-10-24',4,0,0,NULL,0),(9258,78,'2026-10-25',4,0,0,NULL,0),(9259,78,'2026-10-26',4,0,0,NULL,0),(9260,78,'2026-10-27',4,0,0,NULL,0),(9261,78,'2026-10-28',4,0,0,NULL,0),(9262,78,'2026-10-29',4,0,0,NULL,0),(9263,78,'2026-10-30',4,0,0,NULL,0),(9264,78,'2026-10-31',4,0,0,NULL,0),(9265,78,'2026-11-01',4,0,0,NULL,0),(9266,78,'2026-11-02',4,0,0,NULL,0),(9267,78,'2026-11-03',4,0,0,NULL,0),(9268,78,'2026-11-04',4,0,0,NULL,0),(9269,78,'2026-11-05',4,0,0,NULL,0),(9270,78,'2026-11-06',4,0,0,NULL,0),(9271,78,'2026-11-07',4,0,0,NULL,0),(9272,78,'2026-11-08',4,0,0,NULL,0),(9273,78,'2026-11-09',4,0,0,NULL,0),(9274,78,'2026-11-10',4,0,0,NULL,0),(9275,78,'2026-11-11',4,0,0,NULL,0),(9276,78,'2026-11-12',4,0,0,NULL,0),(9277,78,'2026-11-13',4,0,0,NULL,0),(9278,78,'2026-11-14',4,0,0,NULL,0),(9279,78,'2026-11-15',4,0,0,NULL,0),(9280,78,'2026-11-16',4,0,0,NULL,0),(9281,78,'2026-11-17',4,0,0,NULL,0),(9282,78,'2026-11-18',4,0,0,NULL,0),(9283,78,'2026-11-19',4,0,0,NULL,0),(9284,78,'2026-11-20',4,0,0,NULL,0),(9285,78,'2026-11-21',4,0,0,NULL,0),(9286,78,'2026-11-22',4,0,0,NULL,0),(9287,78,'2026-11-23',4,0,0,NULL,0),(9288,78,'2026-11-24',4,0,0,NULL,0),(9289,78,'2026-11-25',4,0,0,NULL,0),(9290,78,'2026-11-26',4,0,0,NULL,0),(9291,78,'2026-11-27',4,0,0,NULL,0),(9292,78,'2026-11-28',4,0,0,NULL,0),(9293,78,'2026-11-29',4,0,0,NULL,0),(9294,78,'2026-11-30',4,0,0,NULL,0),(9295,78,'2026-12-01',4,0,0,NULL,0),(9296,78,'2026-12-02',4,0,0,NULL,0),(9297,78,'2026-12-03',4,0,0,NULL,0),(9298,78,'2026-12-04',4,0,0,NULL,0),(9299,78,'2026-12-05',4,0,0,NULL,0),(9300,78,'2026-12-06',4,0,0,NULL,0),(9301,78,'2026-12-07',4,0,0,NULL,0),(9302,78,'2026-12-08',4,0,0,NULL,0),(9303,78,'2026-12-09',4,0,0,NULL,0),(9304,78,'2026-12-10',4,0,0,NULL,0),(9305,78,'2026-12-11',4,0,0,NULL,0),(9306,78,'2026-12-12',4,0,0,NULL,0),(9307,78,'2026-12-13',4,0,0,NULL,0),(9308,78,'2026-12-14',4,0,0,NULL,0),(9309,78,'2026-12-15',4,0,0,NULL,0),(9310,78,'2026-12-16',4,0,0,NULL,0),(9311,78,'2026-12-17',4,0,0,NULL,0),(9312,78,'2026-12-18',4,0,0,NULL,0),(9313,78,'2026-12-19',4,0,0,NULL,0),(9314,78,'2026-12-20',4,0,0,NULL,0),(9315,78,'2026-12-21',4,0,0,NULL,0),(9316,78,'2026-12-22',4,0,0,NULL,0),(9317,78,'2026-12-23',4,0,0,NULL,0),(9318,78,'2026-12-24',4,0,0,NULL,0),(9319,78,'2026-12-25',4,0,0,NULL,0),(9320,78,'2026-12-26',4,0,0,NULL,0),(9321,78,'2026-12-27',4,0,0,NULL,0),(9322,78,'2026-12-28',4,0,0,NULL,0),(9323,78,'2026-12-29',4,0,0,NULL,0),(9324,78,'2026-12-30',4,0,0,NULL,0),(9325,78,'2026-12-31',4,0,0,NULL,0),(9326,78,'2027-01-01',4,0,0,NULL,0),(9327,78,'2027-01-02',4,0,0,NULL,0),(9328,78,'2027-01-03',4,0,0,NULL,0),(9329,78,'2027-01-04',4,0,0,NULL,0),(9330,78,'2027-01-05',4,0,0,NULL,0),(9331,78,'2027-01-06',4,0,0,NULL,0),(9332,78,'2027-01-07',4,0,0,NULL,0),(9333,78,'2027-01-08',4,0,0,NULL,0),(9334,78,'2027-01-09',4,0,0,NULL,0),(9335,78,'2027-01-10',4,0,0,NULL,0),(9336,78,'2027-01-11',4,0,0,NULL,0),(9337,78,'2027-01-12',4,0,0,NULL,0),(9338,78,'2027-01-13',4,0,0,NULL,0),(9339,78,'2027-01-14',4,0,0,NULL,0),(9340,78,'2027-01-15',4,0,0,NULL,0),(9341,78,'2027-01-16',4,0,0,NULL,0),(9342,78,'2027-01-17',4,0,0,NULL,0),(9343,78,'2027-01-18',4,0,0,NULL,0),(9344,78,'2027-01-19',4,0,0,NULL,0),(9345,78,'2027-01-20',4,0,0,NULL,0),(9346,78,'2027-01-21',4,0,0,NULL,0),(9347,78,'2027-01-22',4,0,0,NULL,0),(9348,78,'2027-01-23',4,0,0,NULL,0),(9349,78,'2027-01-24',4,0,0,NULL,0),(9350,78,'2027-01-25',4,0,0,NULL,0),(9351,78,'2027-01-26',4,0,0,NULL,0),(9352,78,'2027-01-27',4,0,0,NULL,0),(9353,78,'2027-01-28',4,0,0,NULL,0),(9354,78,'2027-01-29',4,0,0,NULL,0),(9355,78,'2027-01-30',4,0,0,NULL,0),(9356,78,'2027-01-31',4,0,0,NULL,0),(9357,78,'2027-02-01',4,0,0,NULL,0),(9358,78,'2027-02-02',4,0,0,NULL,0),(9359,78,'2027-02-03',4,0,0,NULL,0),(9360,78,'2027-02-04',4,0,0,NULL,0),(9361,79,'2026-10-08',3,0,0,NULL,0),(9362,79,'2026-10-09',3,0,0,NULL,0),(9363,79,'2026-10-10',3,0,0,NULL,0),(9364,79,'2026-10-11',3,0,0,NULL,0),(9365,79,'2026-10-12',3,0,0,NULL,0),(9366,79,'2026-10-13',3,0,0,NULL,0),(9367,79,'2026-10-14',3,0,0,NULL,0),(9368,79,'2026-10-15',3,0,0,NULL,0),(9369,79,'2026-10-16',3,0,0,NULL,0),(9370,79,'2026-10-17',3,0,0,NULL,0),(9371,79,'2026-10-18',3,0,0,NULL,0),(9372,79,'2026-10-19',3,0,0,NULL,0),(9373,79,'2026-10-20',3,0,0,NULL,0),(9374,79,'2026-10-21',3,0,0,NULL,0),(9375,79,'2026-10-22',3,0,0,NULL,0),(9376,79,'2026-10-23',3,0,0,NULL,0),(9377,79,'2026-10-24',3,0,0,NULL,0),(9378,79,'2026-10-25',3,0,0,NULL,0),(9379,79,'2026-10-26',3,0,0,NULL,0),(9380,79,'2026-10-27',3,0,0,NULL,0),(9381,79,'2026-10-28',3,0,0,NULL,0),(9382,79,'2026-10-29',3,0,0,NULL,0),(9383,79,'2026-10-30',3,0,0,NULL,0),(9384,79,'2026-10-31',3,0,0,NULL,0),(9385,79,'2026-11-01',3,0,0,NULL,0),(9386,79,'2026-11-02',3,0,0,NULL,0),(9387,79,'2026-11-03',3,0,0,NULL,0),(9388,79,'2026-11-04',3,0,0,NULL,0),(9389,79,'2026-11-05',3,0,0,NULL,0),(9390,79,'2026-11-06',3,0,0,NULL,0),(9391,79,'2026-11-07',3,0,0,NULL,0),(9392,79,'2026-11-08',3,0,0,NULL,0),(9393,79,'2026-11-09',3,0,0,NULL,0),(9394,79,'2026-11-10',3,0,0,NULL,0),(9395,79,'2026-11-11',3,0,0,NULL,0),(9396,79,'2026-11-12',3,0,0,NULL,0),(9397,79,'2026-11-13',3,0,0,NULL,0),(9398,79,'2026-11-14',3,0,0,NULL,0),(9399,79,'2026-11-15',3,0,0,NULL,0),(9400,79,'2026-11-16',3,0,0,NULL,0),(9401,79,'2026-11-17',3,0,0,NULL,0),(9402,79,'2026-11-18',3,0,0,NULL,0),(9403,79,'2026-11-19',3,0,0,NULL,0),(9404,79,'2026-11-20',3,0,0,NULL,0),(9405,79,'2026-11-21',3,0,0,NULL,0),(9406,79,'2026-11-22',3,0,0,NULL,0),(9407,79,'2026-11-23',3,0,0,NULL,0),(9408,79,'2026-11-24',3,0,0,NULL,0),(9409,79,'2026-11-25',3,0,0,NULL,0),(9410,79,'2026-11-26',3,0,0,NULL,0),(9411,79,'2026-11-27',3,0,0,NULL,0),(9412,79,'2026-11-28',3,0,0,NULL,0),(9413,79,'2026-11-29',3,0,0,NULL,0),(9414,79,'2026-11-30',3,0,0,NULL,0),(9415,79,'2026-12-01',3,0,0,NULL,0),(9416,79,'2026-12-02',3,0,0,NULL,0),(9417,79,'2026-12-03',3,0,0,NULL,0),(9418,79,'2026-12-04',3,0,0,NULL,0),(9419,79,'2026-12-05',3,0,0,NULL,0),(9420,79,'2026-12-06',3,0,0,NULL,0),(9421,79,'2026-12-07',3,0,0,NULL,0),(9422,79,'2026-12-08',3,0,0,NULL,0),(9423,79,'2026-12-09',3,0,0,NULL,0),(9424,79,'2026-12-10',3,0,0,NULL,0),(9425,79,'2026-12-11',3,0,0,NULL,0),(9426,79,'2026-12-12',3,0,0,NULL,0),(9427,79,'2026-12-13',3,0,0,NULL,0),(9428,79,'2026-12-14',3,0,0,NULL,0),(9429,79,'2026-12-15',3,0,0,NULL,0),(9430,79,'2026-12-16',3,0,0,NULL,0),(9431,79,'2026-12-17',3,0,0,NULL,0),(9432,79,'2026-12-18',3,0,0,NULL,0),(9433,79,'2026-12-19',3,0,0,NULL,0),(9434,79,'2026-12-20',3,0,0,NULL,0),(9435,79,'2026-12-21',3,0,0,NULL,0),(9436,79,'2026-12-22',3,0,0,NULL,0),(9437,79,'2026-12-23',3,0,0,NULL,0),(9438,79,'2026-12-24',3,0,0,NULL,0),(9439,79,'2026-12-25',3,0,0,NULL,0),(9440,79,'2026-12-26',3,0,0,NULL,0),(9441,79,'2026-12-27',3,0,0,NULL,0),(9442,79,'2026-12-28',3,0,0,NULL,0),(9443,79,'2026-12-29',3,0,0,NULL,0),(9444,79,'2026-12-30',3,0,0,NULL,0),(9445,79,'2026-12-31',3,0,0,NULL,0),(9446,79,'2027-01-01',3,0,0,NULL,0),(9447,79,'2027-01-02',3,0,0,NULL,0),(9448,79,'2027-01-03',3,0,0,NULL,0),(9449,79,'2027-01-04',3,0,0,NULL,0),(9450,79,'2027-01-05',3,0,0,NULL,0),(9451,79,'2027-01-06',3,0,0,NULL,0),(9452,79,'2027-01-07',3,0,0,NULL,0),(9453,79,'2027-01-08',3,0,0,NULL,0),(9454,79,'2027-01-09',3,0,0,NULL,0),(9455,79,'2027-01-10',3,0,0,NULL,0),(9456,79,'2027-01-11',3,0,0,NULL,0),(9457,79,'2027-01-12',3,0,0,NULL,0),(9458,79,'2027-01-13',3,0,0,NULL,0),(9459,79,'2027-01-14',3,0,0,NULL,0),(9460,79,'2027-01-15',3,0,0,NULL,0),(9461,79,'2027-01-16',3,0,0,NULL,0),(9462,79,'2027-01-17',3,0,0,NULL,0),(9463,79,'2027-01-18',3,0,0,NULL,0),(9464,79,'2027-01-19',3,0,0,NULL,0),(9465,79,'2027-01-20',3,0,0,NULL,0),(9466,79,'2027-01-21',3,0,0,NULL,0),(9467,79,'2027-01-22',3,0,0,NULL,0),(9468,79,'2027-01-23',3,0,0,NULL,0),(9469,79,'2027-01-24',3,0,0,NULL,0),(9470,79,'2027-01-25',3,0,0,NULL,0),(9471,79,'2027-01-26',3,0,0,NULL,0),(9472,79,'2027-01-27',3,0,0,NULL,0),(9473,79,'2027-01-28',3,0,0,NULL,0),(9474,79,'2027-01-29',3,0,0,NULL,0),(9475,79,'2027-01-30',3,0,0,NULL,0),(9476,79,'2027-01-31',3,0,0,NULL,0),(9477,79,'2027-02-01',3,0,0,NULL,0),(9478,79,'2027-02-02',3,0,0,NULL,0),(9479,79,'2027-02-03',3,0,0,NULL,0),(9480,79,'2027-02-04',3,0,0,NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomType`
--

LOCK TABLES `RoomType` WRITE;
/*!40000 ALTER TABLE `RoomType` DISABLE KEYS */;
INSERT INTO `RoomType` VALUES (49,23,'Phòng tiêu chuẩn',28,'1 giường đôi',2,6,1,0,850000,'Gọn gàng, ban công nhỏ nhìn ra vườn.'),(50,23,'Phòng Deluxe',28,'1 giường lớn',2,4,1,0,1250000,'Rộng rãi, cửa kính lớn view đồi thông.'),(51,23,'Phòng Family',28,'2 giường đôi',4,2,1,0,1800000,'Phù hợp gia đình 4 người.'),(52,24,'Phòng hướng biển',28,'1 giường lớn',2,5,1,0,1600000,'Ban công nhìn thẳng ra biển.'),(53,24,'Suite gia đình',28,'2 giường lớn',4,3,1,0,2600000,'Không gian rộng, bếp mini.'),(54,25,'Phòng vườn',28,'1 giường đôi',2,6,1,0,1100000,'Yên tĩnh, nhìn ra vườn.'),(55,25,'Phòng view sông',28,'1 giường lớn',2,3,1,0,1600000,'Ban công nhìn ra sông Hoài.'),(56,26,'Giường tầng (Dorm)',28,'Giường tầng',1,10,1,0,350000,'Tiết kiệm cho khách đi phượt.'),(57,26,'Cabin gỗ',28,'1 giường đôi',2,4,1,0,1200000,'Riêng tư, lò sưởi ấm áp.'),(58,27,'Phòng cộng đồng',28,'4 giường đơn',4,4,1,0,650000,'Ấm cúng cho nhóm bạn.'),(59,27,'Nhà sàn riêng',28,'1 giường lớn',2,3,1,0,1150000,'View đồi chè, bếp lửa.'),(60,28,'Bungalow vườn',28,'1 giường đôi',2,5,1,0,1250000,'Yên bình giữa vườn xanh.'),(61,28,'Villa núi đá',28,'2 giường lớn',4,2,1,0,2200000,'Hồ bơi riêng, view núi đá.'),(62,29,'Phòng vườn nhiệt đới',28,'1 giường đôi',2,6,1,0,1400000,'Gần biển, nhiều cây xanh.'),(63,29,'Bungalow hướng biển',28,'1 giường lớn',2,4,1,0,2300000,'Ngắm hoàng hôn ngay hiên.'),(64,30,'Phòng Studio',28,'1 giường đôi',2,5,1,0,900000,'Gọn gàng, trung tâm phố cổ.'),(65,30,'Căn hộ 1 phòng ngủ',28,'1 giường lớn',3,3,1,0,1500000,'Bếp riêng, ban công nhìn phố.'),(66,31,'Phòng tiêu chuẩn',28,'1 giường đôi',2,8,1,0,800000,'Tiện nghi, gần bến tàu.'),(67,31,'Bungalow view vịnh',28,'1 giường lớn',2,4,1,0,1600000,'Nhìn thẳng ra vịnh Lan Hạ.'),(68,32,'Lều glamping',28,'1 giường đôi',2,5,1,0,950000,'Cắm trại tiện nghi giữa đồi chè.'),(69,32,'Nhà gỗ view thác',28,'2 giường đôi',4,2,1,0,1900000,'Gia đình, nghe tiếng thác.'),(70,33,'Phòng hướng biển',28,'1 giường lớn',2,6,1,0,1050000,'Ban công nhìn ra biển, đón bình minh.'),(71,33,'Căn hộ 2 phòng ngủ',28,'2 giường lớn',4,3,1,0,1950000,'Rộng rãi cho nhóm/gia đình.'),(72,34,'Cabin ven hồ',28,'1 giường đôi',2,5,1,0,1300000,'View hồ, lò sưởi.'),(73,34,'Villa gỗ 2 phòng',28,'2 giường đôi',4,2,1,0,2400000,'Bếp riêng, hiên ngắm hồ.'),(74,35,'Phòng view vịnh',28,'1 giường lớn',2,6,1,0,1500000,'Nhìn thẳng ra vịnh di sản.'),(75,35,'Suite gia đình',28,'2 giường lớn',4,2,1,0,2700000,'Phòng khách riêng, bồn tắm.'),(76,36,'Phòng nhà dài Ê-đê',28,'2 giường đơn',2,5,1,0,600000,'Đậm bản sắc Tây Nguyên.'),(77,36,'Bungalow vườn',28,'1 giường đôi',2,3,1,0,1000000,'Yên tĩnh giữa vườn cà phê.'),(78,37,'Phòng tập thể',28,'4 giường đơn',4,4,1,0,550000,'Phù hợp nhóm bạn trẻ.'),(79,37,'Phòng đôi view núi',28,'1 giường đôi',2,3,1,0,900000,'Ban công ngắm bình minh trên mây.');
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
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tour`
--

LOCK TABLES `Tour` WRITE;
/*!40000 ALTER TABLE `Tour` DISABLE KEYS */;
INSERT INTO `Tour` VALUES (23,'TR001','Săn mây Tà Xùa 3N2Đ','san-may-ta-xua-3n2d','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.',NULL,NULL,NULL,3,2,'Hà Nội','Tà Xùa, Sơn La',NULL,1,25,NULL,2500000,30,5,4.5,2,'VISIBLE','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.415','2026-10-07 09:59:47.814'),(24,'TR002','Khám phá Hà Giang 4N3Đ','kham-pha-ha-giang-4n3d','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.',NULL,NULL,NULL,4,3,'Hà Nội','Hà Giang',NULL,1,25,NULL,3900000,30,5,5,1,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.437','2026-10-07 09:59:47.818'),(25,'TR003','Lý Sơn – Đảo tiên 2N1Đ','ly-son-dao-tien-2n1d','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.',NULL,NULL,NULL,2,1,'Đà Nẵng','Lý Sơn, Quảng Ngãi',NULL,1,25,NULL,1800000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.453','2026-10-07 09:59:38.453'),(26,'TR004','Kỳ Co – Eo Gió 1 ngày','ky-co-eo-gio-1-ngay','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.',NULL,NULL,NULL,1,0,'Quy Nhơn','Quy Nhơn, Bình Định',NULL,1,25,NULL,650000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.469','2026-10-07 09:59:38.469'),(27,'TR005','Phú Quốc – Thiên đường biển đảo 3N2Đ','phu-quoc-thien-duong-bien-dao-3n2d','Cáp treo Hòn Thơm, câu cá, lặn ngắm san hô và hoàng hôn Bãi Sao.','Cáp treo Hòn Thơm, câu cá, lặn ngắm san hô và hoàng hôn Bãi Sao.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Phú Quốc, Kiên Giang',NULL,1,25,NULL,3200000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.486','2026-10-07 09:59:38.486'),(28,'TR006','Tràng An – Bái Đính – Hang Múa 1 ngày','trang-an-bai-dinh-hang-mua-1-ngay','Du thuyền Tràng An, chùa Bái Đính và leo Hang Múa ngắm toàn cảnh.','Du thuyền Tràng An, chùa Bái Đính và leo Hang Múa ngắm toàn cảnh.',NULL,NULL,NULL,1,0,'Hà Nội','Ninh Bình',NULL,1,25,NULL,850000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.503','2026-10-07 09:59:38.503'),(29,'TR007','Mộc Châu mùa hoa 2N1Đ','moc-chau-mua-hoa-2n1d','Đồi chè trái tim, thác Dải Yếm, rừng thông bản Áng, vườn hoa.','Đồi chè trái tim, thác Dải Yếm, rừng thông bản Áng, vườn hoa.',NULL,NULL,NULL,2,1,'Hà Nội','Mộc Châu, Sơn La',NULL,1,25,NULL,1650000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.520','2026-10-07 09:59:38.520'),(30,'TR008','Huế – Hành trình di sản 2N1Đ','hue-hanh-trinh-di-san-2n1d','Đại Nội, lăng tẩm, chùa Thiên Mụ và thuyền rồng sông Hương.','Đại Nội, lăng tẩm, chùa Thiên Mụ và thuyền rồng sông Hương.',NULL,NULL,NULL,2,1,'Đà Nẵng','Huế, Thừa Thiên Huế',NULL,1,25,NULL,1950000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.540','2026-10-07 09:59:38.540'),(31,'TR009','Nha Trang – Tour 4 đảo 3N2Đ','nha-trang-tour-4-dao-3n2d','Khám phá 4 đảo, lặn biển, tắm bùn khoáng và VinWonders.','Khám phá 4 đảo, lặn biển, tắm bùn khoáng và VinWonders.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Nha Trang, Khánh Hòa',NULL,1,25,NULL,2800000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.561','2026-10-07 09:59:38.561'),(32,'TR010','Miền Tây – Chợ nổi Cái Răng 2N1Đ','mien-tay-cho-noi-cai-rang-2n1d','Chợ nổi Cái Răng, vườn trái cây, lò hủ tiếu và đờn ca tài tử.','Chợ nổi Cái Răng, vườn trái cây, lò hủ tiếu và đờn ca tài tử.',NULL,NULL,NULL,2,1,'TP. Hồ Chí Minh','Cần Thơ',NULL,1,25,NULL,1500000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.579','2026-10-07 09:59:38.579'),(33,'TR011','Đà Lạt – Thành phố ngàn hoa 3N2Đ','da-lat-thanh-pho-ngan-hoa-3n2d','Đồi chè Cầu Đất, Langbiang, thác Datanla và chợ đêm Đà Lạt.','Đồi chè Cầu Đất, Langbiang, thác Datanla và chợ đêm Đà Lạt.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Đà Lạt, Lâm Đồng',NULL,1,25,NULL,2400000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.601','2026-10-07 09:59:38.601'),(34,'TR012','Sa Pa – Chinh phục Fansipan 2N1Đ','sa-pa-chinh-phuc-fansipan-2n1d','Cáp treo Fansipan, bản Cát Cát, ruộng bậc thang và chợ vùng cao.','Cáp treo Fansipan, bản Cát Cát, ruộng bậc thang và chợ vùng cao.',NULL,NULL,NULL,2,1,'Hà Nội','Sa Pa, Lào Cai',NULL,1,25,NULL,2100000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.618','2026-10-07 09:59:38.618'),(35,'TR013','Côn Đảo – Hành trình tâm linh 3N2Đ','con-dao-hanh-trinh-tam-linh-3n2d','Viếng nghĩa trang Hàng Dương, lặn ngắm san hô và bãi Đầm Trầu.','Viếng nghĩa trang Hàng Dương, lặn ngắm san hô và bãi Đầm Trầu.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Côn Đảo, Bà Rịa – Vũng Tàu',NULL,1,25,NULL,4200000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.636','2026-10-07 09:59:38.636'),(36,'TR014','Quy Nhơn – Phú Yên biển xanh 3N2Đ','quy-nhon-phu-yen-bien-xanh-3n2d','Kỳ Co, Eo Gió, Gành Đá Đĩa và đầm Ô Loan thơ mộng.','Kỳ Co, Eo Gió, Gành Đá Đĩa và đầm Ô Loan thơ mộng.',NULL,NULL,NULL,3,2,'TP. Hồ Chí Minh','Quy Nhơn – Phú Yên',NULL,1,25,NULL,2950000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.654','2026-10-07 09:59:38.654'),(37,'TR015','Hạ Long – Du thuyền vịnh Lan Hạ 2N1Đ','ha-long-du-thuyen-lan-ha-2n1d','Ngủ đêm trên du thuyền, chèo kayak hang Luồn, tắm biển đảo Ti Tốp.','Ngủ đêm trên du thuyền, chèo kayak hang Luồn, tắm biển đảo Ti Tốp.',NULL,NULL,NULL,2,1,'Hà Nội','Hạ Long – Lan Hạ',NULL,1,25,NULL,3600000,30,5,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-07 09:59:38.673','2026-10-07 09:59:38.673');
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
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourDeparture`
--

LOCK TABLES `TourDeparture` WRITE;
/*!40000 ALTER TABLE `TourDeparture` DISABLE KEYS */;
INSERT INTO `TourDeparture` VALUES (67,23,'2026-10-17','2026-10-19',20,2,0,'OPEN',NULL),(68,23,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(69,23,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(70,24,'2026-10-17','2026-10-20',20,0,0,'OPEN',NULL),(71,24,'2026-10-31','2026-11-03',20,0,0,'OPEN',NULL),(72,24,'2026-11-16','2026-11-19',20,0,0,'OPEN',NULL),(73,25,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(74,25,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(75,25,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(76,26,'2026-10-17','2026-10-17',20,0,0,'OPEN',NULL),(77,26,'2026-10-31','2026-10-31',20,0,0,'OPEN',NULL),(78,26,'2026-11-16','2026-11-16',20,0,0,'OPEN',NULL),(79,27,'2026-10-17','2026-10-19',20,0,0,'OPEN',NULL),(80,27,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(81,27,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(82,28,'2026-10-17','2026-10-17',20,0,0,'OPEN',NULL),(83,28,'2026-10-31','2026-10-31',20,0,0,'OPEN',NULL),(84,28,'2026-11-16','2026-11-16',20,0,0,'OPEN',NULL),(85,29,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(86,29,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(87,29,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(88,30,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(89,30,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(90,30,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(91,31,'2026-10-17','2026-10-19',20,0,0,'OPEN',NULL),(92,31,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(93,31,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(94,32,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(95,32,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(96,32,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(97,33,'2026-10-17','2026-10-19',20,0,0,'OPEN',NULL),(98,33,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(99,33,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(100,34,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(101,34,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(102,34,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL),(103,35,'2026-10-17','2026-10-19',20,0,0,'OPEN',NULL),(104,35,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(105,35,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(106,36,'2026-10-17','2026-10-19',20,0,0,'OPEN',NULL),(107,36,'2026-10-31','2026-11-02',20,0,0,'OPEN',NULL),(108,36,'2026-11-16','2026-11-18',20,0,0,'OPEN',NULL),(109,37,'2026-10-17','2026-10-18',20,0,0,'OPEN',NULL),(110,37,'2026-10-31','2026-11-01',20,0,0,'OPEN',NULL),(111,37,'2026-11-16','2026-11-17',20,0,0,'OPEN',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourImage`
--

LOCK TABLES `TourImage` WRITE;
/*!40000 ALTER TABLE `TourImage` DISABLE KEYS */;
INSERT INTO `TourImage` VALUES (1,23,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(2,23,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(3,23,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(4,23,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(5,23,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(6,24,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(7,24,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(8,24,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(9,24,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(10,24,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(11,25,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(12,25,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(13,25,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(14,25,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(15,25,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(16,26,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(17,26,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(18,26,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(19,26,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(20,26,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(21,27,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(22,27,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(23,27,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(24,27,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(25,27,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(26,28,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(27,28,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(28,28,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(29,28,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(30,28,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(31,29,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(32,29,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(33,29,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(34,29,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(35,29,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(36,30,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(37,30,'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(38,30,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(39,30,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(40,30,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(41,31,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(42,31,'https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(43,31,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(44,31,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(45,31,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(46,32,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(47,32,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(48,32,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(49,32,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(50,32,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(51,33,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(52,33,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(53,33,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(54,33,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(55,33,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(56,34,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(57,34,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(58,34,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(59,34,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(60,34,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(61,35,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(62,35,'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(63,35,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(64,35,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(65,35,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(66,36,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(67,36,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(68,36,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(69,36,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(70,36,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4),(71,37,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',NULL,1,0),(72,37,'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',NULL,0,1),(73,37,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',NULL,0,2),(74,37,'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',NULL,0,3),(75,37,'https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',NULL,0,4);
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
) ENGINE=InnoDB AUTO_INCREMENT=223 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourPrice`
--

LOCK TABLES `TourPrice` WRITE;
/*!40000 ALTER TABLE `TourPrice` DISABLE KEYS */;
INSERT INTO `TourPrice` VALUES (133,67,'ADULT',2500000,'Người lớn',0),(134,67,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(135,68,'ADULT',2500000,'Người lớn',0),(136,68,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(137,69,'ADULT',2500000,'Người lớn',0),(138,69,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(139,70,'ADULT',3900000,'Người lớn',0),(140,70,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(141,71,'ADULT',3900000,'Người lớn',0),(142,71,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(143,72,'ADULT',3900000,'Người lớn',0),(144,72,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(145,73,'ADULT',1800000,'Người lớn',0),(146,73,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(147,74,'ADULT',1800000,'Người lớn',0),(148,74,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(149,75,'ADULT',1800000,'Người lớn',0),(150,75,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(151,76,'ADULT',650000,'Người lớn',0),(152,76,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(153,77,'ADULT',650000,'Người lớn',0),(154,77,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(155,78,'ADULT',650000,'Người lớn',0),(156,78,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(157,79,'ADULT',3200000,'Người lớn',0),(158,79,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(159,80,'ADULT',3200000,'Người lớn',0),(160,80,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(161,81,'ADULT',3200000,'Người lớn',0),(162,81,'CHILD',2240000,'Trẻ em 5–11 tuổi',0),(163,82,'ADULT',850000,'Người lớn',0),(164,82,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(165,83,'ADULT',850000,'Người lớn',0),(166,83,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(167,84,'ADULT',850000,'Người lớn',0),(168,84,'CHILD',595000,'Trẻ em 5–11 tuổi',0),(169,85,'ADULT',1650000,'Người lớn',0),(170,85,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(171,86,'ADULT',1650000,'Người lớn',0),(172,86,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(173,87,'ADULT',1650000,'Người lớn',0),(174,87,'CHILD',1155000,'Trẻ em 5–11 tuổi',0),(175,88,'ADULT',1950000,'Người lớn',0),(176,88,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(177,89,'ADULT',1950000,'Người lớn',0),(178,89,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(179,90,'ADULT',1950000,'Người lớn',0),(180,90,'CHILD',1365000,'Trẻ em 5–11 tuổi',0),(181,91,'ADULT',2800000,'Người lớn',0),(182,91,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(183,92,'ADULT',2800000,'Người lớn',0),(184,92,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(185,93,'ADULT',2800000,'Người lớn',0),(186,93,'CHILD',1960000,'Trẻ em 5–11 tuổi',0),(187,94,'ADULT',1500000,'Người lớn',0),(188,94,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(189,95,'ADULT',1500000,'Người lớn',0),(190,95,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(191,96,'ADULT',1500000,'Người lớn',0),(192,96,'CHILD',1050000,'Trẻ em 5–11 tuổi',0),(193,97,'ADULT',2400000,'Người lớn',0),(194,97,'CHILD',1680000,'Trẻ em 5–11 tuổi',0),(195,98,'ADULT',2400000,'Người lớn',0),(196,98,'CHILD',1680000,'Trẻ em 5–11 tuổi',0),(197,99,'ADULT',2400000,'Người lớn',0),(198,99,'CHILD',1680000,'Trẻ em 5–11 tuổi',0),(199,100,'ADULT',2100000,'Người lớn',0),(200,100,'CHILD',1470000,'Trẻ em 5–11 tuổi',0),(201,101,'ADULT',2100000,'Người lớn',0),(202,101,'CHILD',1470000,'Trẻ em 5–11 tuổi',0),(203,102,'ADULT',2100000,'Người lớn',0),(204,102,'CHILD',1470000,'Trẻ em 5–11 tuổi',0),(205,103,'ADULT',4200000,'Người lớn',0),(206,103,'CHILD',2940000,'Trẻ em 5–11 tuổi',0),(207,104,'ADULT',4200000,'Người lớn',0),(208,104,'CHILD',2940000,'Trẻ em 5–11 tuổi',0),(209,105,'ADULT',4200000,'Người lớn',0),(210,105,'CHILD',2940000,'Trẻ em 5–11 tuổi',0),(211,106,'ADULT',2950000,'Người lớn',0),(212,106,'CHILD',2065000,'Trẻ em 5–11 tuổi',0),(213,107,'ADULT',2950000,'Người lớn',0),(214,107,'CHILD',2065000,'Trẻ em 5–11 tuổi',0),(215,108,'ADULT',2950000,'Người lớn',0),(216,108,'CHILD',2065000,'Trẻ em 5–11 tuổi',0),(217,109,'ADULT',3600000,'Người lớn',0),(218,109,'CHILD',2520000,'Trẻ em 5–11 tuổi',0),(219,110,'ADULT',3600000,'Người lớn',0),(220,110,'CHILD',2520000,'Trẻ em 5–11 tuổi',0),(221,111,'ADULT',3600000,'Người lớn',0),(222,111,'CHILD',2520000,'Trẻ em 5–11 tuổi',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TravelGuide`
--

LOCK TABLES `TravelGuide` WRITE;
/*!40000 ALTER TABLE `TravelGuide` DISABLE KEYS */;
INSERT INTO `TravelGuide` VALUES (5,'Kinh nghiệm du lịch Đà Lạt 3 ngày 2 đêm','kinh-nghiem-du-lich-da-lat-3n2d','Ban biên tập StayTour','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70','Gợi ý lịch trình Đà Lạt tiết kiệm cho nhóm bạn.','Ngày 1: khám phá trung tâm, chợ đêm Đà Lạt.\nNgày 2: đồi chè Cầu Đất, săn mây.\nNgày 3: vườn hoa, mua đặc sản về làm quà.','Đà Lạt, Lâm Đồng',NULL,NULL,'2026-10-07 09:59:38.704','VISIBLE',NULL,'2026-10-07 09:59:38.705','2026-10-07 09:59:38.705');
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

-- Dump completed on 2026-10-07  9:59:58
