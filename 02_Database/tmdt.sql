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
INSERT INTO `Admin` VALUES (1,'admin','$2a$10$TNqWyAn3ZBcRjgeMOlkLMO.zRMqetPD4GFdhSS/ov6YD9I//3OnfW','Quản trị viên','SUPER_ADMIN',1,0,NULL,'2026-10-05 04:43:06.106','2026-10-05 04:43:15.212');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AdminLoginAttempt`
--

LOCK TABLES `AdminLoginAttempt` WRITE;
/*!40000 ALTER TABLE `AdminLoginAttempt` DISABLE KEYS */;
INSERT INTO `AdminLoginAttempt` VALUES (1,'admin',NULL,'172.18.0.1',0,'not_found','2026-10-05 04:40:03.386'),(2,'admin',1,'172.18.0.1',1,NULL,'2026-10-05 04:43:15.218');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Area`
--

LOCK TABLES `Area` WRITE;
/*!40000 ALTER TABLE `Area` DISABLE KEYS */;
INSERT INTO `Area` VALUES (1,'Đà Lạt','da-lat','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70',1),(2,'Đà Nẵng','da-nang','https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&w=1000&q=70',2),(3,'Hội An','hoi-an','https://images.unsplash.com/photo-1535139262971-c51845709a48?auto=format&fit=crop&w=1000&q=70',3),(4,'Sa Pa','sa-pa','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',4);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Booking`
--

LOCK TABLES `Booking` WRITE;
/*!40000 ALTER TABLE `Booking` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CancellationPolicy`
--

LOCK TABLES `CancellationPolicy` WRITE;
/*!40000 ALTER TABLE `CancellationPolicy` DISABLE KEYS */;
INSERT INTO `CancellationPolicy` VALUES (1,'Linh hoạt tiêu chuẩn',1,24,'2026-10-05 04:43:05.829','2026-10-05 04:43:05.829');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DiscountCode`
--

LOCK TABLES `DiscountCode` WRITE;
/*!40000 ALTER TABLE `DiscountCode` DISABLE KEYS */;
INSERT INTO `DiscountCode` VALUES (1,'STAYTOUR10','PERCENT',10,500000,'ALL',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-05 04:43:05.997'),(2,'HE2026','FIXED',150000,1000000,'HOMESTAY',NULL,NULL,NULL,'ALL',NULL,NULL,NULL,0,1,'2026-10-05 04:43:05.997');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Favorite`
--

LOCK TABLES `Favorite` WRITE;
/*!40000 ALTER TABLE `Favorite` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=181 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HomestayAvailability`
--

LOCK TABLES `HomestayAvailability` WRITE;
/*!40000 ALTER TABLE `HomestayAvailability` DISABLE KEYS */;
INSERT INTO `HomestayAvailability` VALUES (1,1,'2026-10-05',5,3,NULL),(2,1,'2026-10-06',5,1,NULL),(3,1,'2026-10-07',5,1,NULL),(4,1,'2026-10-08',5,5,NULL),(5,1,'2026-10-09',5,5,NULL),(6,1,'2026-10-10',5,3,NULL),(7,1,'2026-10-11',5,1,NULL),(8,1,'2026-10-12',5,1,NULL),(9,1,'2026-10-13',5,1,NULL),(10,1,'2026-10-14',5,1,NULL),(11,1,'2026-10-15',5,3,NULL),(12,1,'2026-10-16',5,1,NULL),(13,1,'2026-10-17',5,1,NULL),(14,1,'2026-10-18',5,1,NULL),(15,1,'2026-10-19',5,1,NULL),(16,1,'2026-10-20',5,3,NULL),(17,1,'2026-10-21',5,1,NULL),(18,1,'2026-10-22',5,1,NULL),(19,1,'2026-10-23',5,1,NULL),(20,1,'2026-10-24',5,1,NULL),(21,1,'2026-10-25',5,3,NULL),(22,1,'2026-10-26',5,1,NULL),(23,1,'2026-10-27',5,1,NULL),(24,1,'2026-10-28',5,1,NULL),(25,1,'2026-10-29',5,1,NULL),(26,1,'2026-10-30',5,3,NULL),(27,1,'2026-10-31',5,1,NULL),(28,1,'2026-11-01',5,1,NULL),(29,1,'2026-11-02',5,1,NULL),(30,1,'2026-11-03',5,1,NULL),(31,2,'2026-10-05',5,3,NULL),(32,2,'2026-10-06',5,1,NULL),(33,2,'2026-10-07',5,1,NULL),(34,2,'2026-10-08',5,5,NULL),(35,2,'2026-10-09',5,5,NULL),(36,2,'2026-10-10',5,3,NULL),(37,2,'2026-10-11',5,1,NULL),(38,2,'2026-10-12',5,1,NULL),(39,2,'2026-10-13',5,1,NULL),(40,2,'2026-10-14',5,1,NULL),(41,2,'2026-10-15',5,3,NULL),(42,2,'2026-10-16',5,1,NULL),(43,2,'2026-10-17',5,1,NULL),(44,2,'2026-10-18',5,1,NULL),(45,2,'2026-10-19',5,1,NULL),(46,2,'2026-10-20',5,3,NULL),(47,2,'2026-10-21',5,1,NULL),(48,2,'2026-10-22',5,1,NULL),(49,2,'2026-10-23',5,1,NULL),(50,2,'2026-10-24',5,1,NULL),(51,2,'2026-10-25',5,3,NULL),(52,2,'2026-10-26',5,1,NULL),(53,2,'2026-10-27',5,1,NULL),(54,2,'2026-10-28',5,1,NULL),(55,2,'2026-10-29',5,1,NULL),(56,2,'2026-10-30',5,3,NULL),(57,2,'2026-10-31',5,1,NULL),(58,2,'2026-11-01',5,1,NULL),(59,2,'2026-11-02',5,1,NULL),(60,2,'2026-11-03',5,1,NULL),(61,3,'2026-10-05',5,3,NULL),(62,3,'2026-10-06',5,1,NULL),(63,3,'2026-10-07',5,1,NULL),(64,3,'2026-10-08',5,5,NULL),(65,3,'2026-10-09',5,5,NULL),(66,3,'2026-10-10',5,3,NULL),(67,3,'2026-10-11',5,1,NULL),(68,3,'2026-10-12',5,1,NULL),(69,3,'2026-10-13',5,1,NULL),(70,3,'2026-10-14',5,1,NULL),(71,3,'2026-10-15',5,3,NULL),(72,3,'2026-10-16',5,1,NULL),(73,3,'2026-10-17',5,1,NULL),(74,3,'2026-10-18',5,1,NULL),(75,3,'2026-10-19',5,1,NULL),(76,3,'2026-10-20',5,3,NULL),(77,3,'2026-10-21',5,1,NULL),(78,3,'2026-10-22',5,1,NULL),(79,3,'2026-10-23',5,1,NULL),(80,3,'2026-10-24',5,1,NULL),(81,3,'2026-10-25',5,3,NULL),(82,3,'2026-10-26',5,1,NULL),(83,3,'2026-10-27',5,1,NULL),(84,3,'2026-10-28',5,1,NULL),(85,3,'2026-10-29',5,1,NULL),(86,3,'2026-10-30',5,3,NULL),(87,3,'2026-10-31',5,1,NULL),(88,3,'2026-11-01',5,1,NULL),(89,3,'2026-11-02',5,1,NULL),(90,3,'2026-11-03',5,1,NULL),(91,4,'2026-10-05',5,3,NULL),(92,4,'2026-10-06',5,1,NULL),(93,4,'2026-10-07',5,1,NULL),(94,4,'2026-10-08',5,5,NULL),(95,4,'2026-10-09',5,5,NULL),(96,4,'2026-10-10',5,3,NULL),(97,4,'2026-10-11',5,1,NULL),(98,4,'2026-10-12',5,1,NULL),(99,4,'2026-10-13',5,1,NULL),(100,4,'2026-10-14',5,1,NULL),(101,4,'2026-10-15',5,3,NULL),(102,4,'2026-10-16',5,1,NULL),(103,4,'2026-10-17',5,1,NULL),(104,4,'2026-10-18',5,1,NULL),(105,4,'2026-10-19',5,1,NULL),(106,4,'2026-10-20',5,3,NULL),(107,4,'2026-10-21',5,1,NULL),(108,4,'2026-10-22',5,1,NULL),(109,4,'2026-10-23',5,1,NULL),(110,4,'2026-10-24',5,1,NULL),(111,4,'2026-10-25',5,3,NULL),(112,4,'2026-10-26',5,1,NULL),(113,4,'2026-10-27',5,1,NULL),(114,4,'2026-10-28',5,1,NULL),(115,4,'2026-10-29',5,1,NULL),(116,4,'2026-10-30',5,3,NULL),(117,4,'2026-10-31',5,1,NULL),(118,4,'2026-11-01',5,1,NULL),(119,4,'2026-11-02',5,1,NULL),(120,4,'2026-11-03',5,1,NULL),(121,5,'2026-10-05',5,3,NULL),(122,5,'2026-10-06',5,1,NULL),(123,5,'2026-10-07',5,1,NULL),(124,5,'2026-10-08',5,5,NULL),(125,5,'2026-10-09',5,5,NULL),(126,5,'2026-10-10',5,3,NULL),(127,5,'2026-10-11',5,1,NULL),(128,5,'2026-10-12',5,1,NULL),(129,5,'2026-10-13',5,1,NULL),(130,5,'2026-10-14',5,1,NULL),(131,5,'2026-10-15',5,3,NULL),(132,5,'2026-10-16',5,1,NULL),(133,5,'2026-10-17',5,1,NULL),(134,5,'2026-10-18',5,1,NULL),(135,5,'2026-10-19',5,1,NULL),(136,5,'2026-10-20',5,3,NULL),(137,5,'2026-10-21',5,1,NULL),(138,5,'2026-10-22',5,1,NULL),(139,5,'2026-10-23',5,1,NULL),(140,5,'2026-10-24',5,1,NULL),(141,5,'2026-10-25',5,3,NULL),(142,5,'2026-10-26',5,1,NULL),(143,5,'2026-10-27',5,1,NULL),(144,5,'2026-10-28',5,1,NULL),(145,5,'2026-10-29',5,1,NULL),(146,5,'2026-10-30',5,3,NULL),(147,5,'2026-10-31',5,1,NULL),(148,5,'2026-11-01',5,1,NULL),(149,5,'2026-11-02',5,1,NULL),(150,5,'2026-11-03',5,1,NULL),(151,6,'2026-10-05',5,3,NULL),(152,6,'2026-10-06',5,1,NULL),(153,6,'2026-10-07',5,1,NULL),(154,6,'2026-10-08',5,5,NULL),(155,6,'2026-10-09',5,5,NULL),(156,6,'2026-10-10',5,3,NULL),(157,6,'2026-10-11',5,1,NULL),(158,6,'2026-10-12',5,1,NULL),(159,6,'2026-10-13',5,1,NULL),(160,6,'2026-10-14',5,1,NULL),(161,6,'2026-10-15',5,3,NULL),(162,6,'2026-10-16',5,1,NULL),(163,6,'2026-10-17',5,1,NULL),(164,6,'2026-10-18',5,1,NULL),(165,6,'2026-10-19',5,1,NULL),(166,6,'2026-10-20',5,3,NULL),(167,6,'2026-10-21',5,1,NULL),(168,6,'2026-10-22',5,1,NULL),(169,6,'2026-10-23',5,1,NULL),(170,6,'2026-10-24',5,1,NULL),(171,6,'2026-10-25',5,3,NULL),(172,6,'2026-10-26',5,1,NULL),(173,6,'2026-10-27',5,1,NULL),(174,6,'2026-10-28',5,1,NULL),(175,6,'2026-10-29',5,1,NULL),(176,6,'2026-10-30',5,3,NULL),(177,6,'2026-10-31',5,1,NULL),(178,6,'2026-11-01',5,1,NULL),(179,6,'2026-11-02',5,1,NULL),(180,6,'2026-11-03',5,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `InfoArticle`
--

LOCK TABLES `InfoArticle` WRITE;
/*!40000 ALTER TABLE `InfoArticle` DISABLE KEYS */;
INSERT INTO `InfoArticle` VALUES (1,'gioi-thieu','Thông tin người bán','ABOUT','Về StayTour','StayTour là nền tảng đặt homestay và tour du lịch nội địa.',1,1,'2026-10-05 04:43:06.000','2026-10-05 04:43:06.000'),(2,'dieu-kien-giao-dich','Điều kiện giao dịch chung','POLICY','Điều khoản','Các điều kiện và điều khoản giao dịch chung khi sử dụng StayTour.',1,2,'2026-10-05 04:43:06.000','2026-10-05 04:43:06.000'),(3,'chinh-sach-doi-tra-huy','Chính sách đổi – trả – hủy','POLICY','Hủy & hoàn tiền','Chính sách hủy đặt chỗ và hoàn tiền theo từng mốc thời gian.',1,3,'2026-10-05 04:43:06.000','2026-10-05 04:43:06.000'),(4,'bao-mat-du-lieu','Bảo vệ dữ liệu cá nhân','POLICY','Bảo mật','Cam kết bảo vệ dữ liệu cá nhân của khách hàng.',1,4,'2026-10-05 04:43:06.000','2026-10-05 04:43:06.000');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LoginAttempt`
--

LOCK TABLES `LoginAttempt` WRITE;
/*!40000 ALTER TABLE `LoginAttempt` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LookupAttempt`
--

LOCK TABLES `LookupAttempt` WRITE;
/*!40000 ALTER TABLE `LookupAttempt` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payment`
--

LOCK TABLES `Payment` WRITE;
/*!40000 ALTER TABLE `Payment` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PolicyMilestone`
--

LOCK TABLES `PolicyMilestone` WRITE;
/*!40000 ALTER TABLE `PolicyMilestone` DISABLE KEYS */;
INSERT INTO `PolicyMilestone` VALUES (1,1,7,100),(2,1,3,50);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
INSERT INTO `Product` VALUES (1,'Pine Hill Homestay','pine-hill-homestay','HOMESTAY','VISIBLE','Homestay view đồi thông, không gian yên tĩnh gần trung tâm Đà Lạt.','Đà Lạt',850000,4.5,'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=70',1,'Wifi,Bếp,Chỗ đậu xe,View đồi',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-05 04:39:53.742','2026-10-05 04:39:53.800'),(2,'Sunny Villa Đà Lạt','sunny-villa-da-lat','HOMESTAY','VISIBLE','Villa nguyên căn 3 phòng ngủ, có bếp và sân vườn.','Đà Lạt',1500000,5,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=70',1,'Wifi,Bếp,Hồ bơi,Chỗ đậu xe,BBQ',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-05 04:39:53.746','2026-10-05 04:39:53.804'),(3,'Cozy Corner Đà Lạt','cozy-corner-da-lat','HOMESTAY','VISIBLE','Phòng đôi ấm cúng ngay trung tâm, đi bộ ra chợ đêm.','Đà Lạt',550000,4.5,'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=70',0,'Wifi,Máy sưởi',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-05 04:39:53.749','2026-10-05 04:39:53.749'),(4,'Sea Breeze Mỹ Khê','sea-breeze-my-khe','HOMESTAY','VISIBLE','Homestay cách biển Mỹ Khê 200m, ban công đón nắng.','Đà Nẵng',950000,4.7,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=70',1,'Wifi,Máy lạnh,View biển,Ban công',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-05 04:39:53.752','2026-10-05 04:39:53.752'),(5,'Ocean View Studio','ocean-view-studio','HOMESTAY','VISIBLE','Studio tầng cao nhìn ra biển, đầy đủ tiện nghi.','Đà Nẵng',1200000,4.6,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=70',0,'Wifi,Máy lạnh,Hồ bơi,View biển',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-05 04:39:53.756','2026-10-05 04:39:53.756'),(6,'Hidden Homestay (ẩn)','hidden-homestay','HOMESTAY','HIDDEN','Sản phẩm đang ẩn – KHÔNG được xuất hiện ở trang chủ/danh mục/tìm kiếm.','Đà Lạt',700000,4,'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=800&q=70',1,'Wifi',NULL,NULL,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,NULL,NULL,NULL,NULL,'2026-10-05 04:39:53.759','2026-10-05 04:39:53.759'),(7,'Chinh phục Fansipan 3N2Đ','tour-fansipan-3n2d','TOUR','VISIBLE','Trekking Tây Bắc, chinh phục nóc nhà Đông Dương.','Sa Pa, Lào Cai',3200000,5,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=70',1,NULL,3,2240000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nNgày 3: Tự do khám phá và trở về.',NULL,NULL,NULL,'2026-10-05 04:39:53.763','2026-10-05 04:39:53.810'),(8,'Săn mây Tà Xùa 3N2Đ','tour-ta-xua-3n2d','TOUR','VISIBLE','Săn mây, cắm trại giữa sống lưng khủng long Tà Xùa.','Sơn La',2500000,4.7,'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?auto=format&fit=crop&w=800&q=70',0,NULL,3,1750000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nNgày 3: Tự do khám phá và trở về.',NULL,NULL,NULL,'2026-10-05 04:39:53.766','2026-10-05 04:39:53.766'),(9,'Cù Lao Chàm 1 ngày','tour-cu-lao-cham','TOUR','VISIBLE','Lặn ngắm san hô, khám phá đảo Cù Lao Chàm.','Hội An, Quảng Nam',750000,4.6,'https://images.unsplash.com/photo-1505228395891-9a51e7e86bf6?auto=format&fit=crop&w=800&q=70',1,NULL,1,525000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nBuổi chiều: Trở về, kết thúc chương trình.',NULL,NULL,NULL,'2026-10-05 04:39:53.769','2026-10-05 04:39:53.769'),(10,'Lý Sơn 2N1Đ','tour-ly-son-2n1d','TOUR','VISIBLE','Đảo tiền tiêu Lý Sơn, cánh đồng tỏi và biển xanh.','Quảng Ngãi',1800000,4.5,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=70',0,NULL,2,1260000,'Miễn phí hủy trong vòng 24 giờ sau khi đặt. Hủy trước 7 ngày so với ngày nhận/khởi hành: hoàn 100%. Hủy trong vòng 3–7 ngày: hoàn 50%. Hủy trong vòng 3 ngày: không hoàn tiền.',NULL,'Ngày 1: Khởi hành, di chuyển đến điểm đến, nhận phòng.\nNgày 2: Tham quan các điểm nổi bật, trải nghiệm địa phương.\nBuổi chiều: Trở về, kết thúc chương trình.',NULL,NULL,NULL,'2026-10-05 04:39:53.772','2026-10-05 04:39:53.772');
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductImage`
--

LOCK TABLES `ProductImage` WRITE;
/*!40000 ALTER TABLE `ProductImage` DISABLE KEYS */;
INSERT INTO `ProductImage` VALUES (1,1,'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=70',0),(2,1,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(3,1,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(4,2,'https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=800&q=70',0),(5,2,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(6,2,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(7,3,'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=70',0),(8,3,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(9,3,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(10,4,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=70',0),(11,4,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(12,4,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(13,5,'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=800&q=70',0),(14,5,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(15,5,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(16,6,'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?auto=format&fit=crop&w=800&q=70',0),(17,6,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(18,6,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(19,7,'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=70',0),(20,7,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(21,7,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(22,8,'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?auto=format&fit=crop&w=800&q=70',0),(23,8,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(24,8,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(25,9,'https://images.unsplash.com/photo-1505228395891-9a51e7e86bf6?auto=format&fit=crop&w=800&q=70',0),(26,9,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(27,9,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2),(28,10,'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=70',0),(29,10,'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?auto=format&fit=crop&w=800&q=70',1),(30,10,'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=70',2);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
INSERT INTO `Promotion` VALUES (1,'Giảm 20% đặt homestay dịp lễ','Áp dụng cho đơn đặt trước 7 ngày.','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,'2026-10-05 04:43:05.995'),(2,'Tour Tây Bắc mùa săn mây','Ưu đãi nhóm từ 4 khách trở lên.','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,'2026-10-05 04:43:05.995');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Property`
--

LOCK TABLES `Property` WRITE;
/*!40000 ALTER TABLE `Property` DISABLE KEYS */;
INSERT INTO `Property` VALUES (1,'HS001','Pine Hill Homestay','pine-hill-homestay','HOMESTAY',NULL,'Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.','Homestay ấm cúng giữa rừng thông Đà Lạt, view đồi lãng mạn.',NULL,NULL,'Đà Lạt, Lâm Đồng',NULL,NULL,'14:00','12:00',850000,30,1,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1618773928121-c32242e63f39?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.832','2026-10-05 04:43:05.832'),(2,'HS002','Biển Ngọc Villa','bien-ngoc-villa','HOMESTAY',NULL,'Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.','Villa sát biển Mỹ Khê, hồ bơi riêng, đầy đủ tiện nghi.',NULL,NULL,'Mỹ Khê, Đà Nẵng',NULL,NULL,'14:00','12:00',1600000,30,1,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.866','2026-10-05 04:43:05.866'),(3,'HS003','Sông Trăng Riverside','song-trang-riverside','HOMESTAY',NULL,'Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.','Nhà vườn bên sông Hoài, đạp xe 5 phút tới phố cổ.',NULL,NULL,'Hội An, Quảng Nam',NULL,NULL,'14:00','12:00',1100000,30,1,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.888','2026-10-05 04:43:05.888'),(4,'HS004','Nhà Của Rừng','nha-cua-rung-sapa','HOMESTAY',NULL,'Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.','Bungalow gỗ giữa thung lũng ruộng bậc thang Sa Pa.',NULL,NULL,'Sa Pa, Lào Cai',NULL,NULL,'14:00','12:00',700000,30,1,4.6,12,NULL,NULL,'VISIBLE','https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.908','2026-10-05 04:43:05.908');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RefundRequest`
--

LOCK TABLES `RefundRequest` WRITE;
/*!40000 ALTER TABLE `RefundRequest` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Review`
--

LOCK TABLES `Review` WRITE;
/*!40000 ALTER TABLE `Review` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewToken`
--

LOCK TABLES `ReviewToken` WRITE;
/*!40000 ALTER TABLE `ReviewToken` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=1081 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomInventory`
--

LOCK TABLES `RoomInventory` WRITE;
/*!40000 ALTER TABLE `RoomInventory` DISABLE KEYS */;
INSERT INTO `RoomInventory` VALUES (1,1,'2026-10-06',6,0,0,NULL,0),(2,1,'2026-10-07',6,0,0,NULL,0),(3,1,'2026-10-08',6,0,0,NULL,0),(4,1,'2026-10-09',6,0,0,NULL,0),(5,1,'2026-10-10',6,0,0,NULL,0),(6,1,'2026-10-11',6,0,0,NULL,0),(7,1,'2026-10-12',6,0,0,NULL,0),(8,1,'2026-10-13',6,0,0,NULL,0),(9,1,'2026-10-14',6,0,0,NULL,0),(10,1,'2026-10-15',6,0,0,NULL,0),(11,1,'2026-10-16',6,0,0,NULL,0),(12,1,'2026-10-17',6,0,0,NULL,0),(13,1,'2026-10-18',6,0,0,NULL,0),(14,1,'2026-10-19',6,0,0,NULL,0),(15,1,'2026-10-20',6,0,0,NULL,0),(16,1,'2026-10-21',6,0,0,NULL,0),(17,1,'2026-10-22',6,0,0,NULL,0),(18,1,'2026-10-23',6,0,0,NULL,0),(19,1,'2026-10-24',6,0,0,NULL,0),(20,1,'2026-10-25',6,0,0,NULL,0),(21,1,'2026-10-26',6,0,0,NULL,0),(22,1,'2026-10-27',6,0,0,NULL,0),(23,1,'2026-10-28',6,0,0,NULL,0),(24,1,'2026-10-29',6,0,0,NULL,0),(25,1,'2026-10-30',6,0,0,NULL,0),(26,1,'2026-10-31',6,0,0,NULL,0),(27,1,'2026-11-01',6,0,0,NULL,0),(28,1,'2026-11-02',6,0,0,NULL,0),(29,1,'2026-11-03',6,0,0,NULL,0),(30,1,'2026-11-04',6,0,0,NULL,0),(31,1,'2026-11-05',6,0,0,NULL,0),(32,1,'2026-11-06',6,0,0,NULL,0),(33,1,'2026-11-07',6,0,0,NULL,0),(34,1,'2026-11-08',6,0,0,NULL,0),(35,1,'2026-11-09',6,0,0,NULL,0),(36,1,'2026-11-10',6,0,0,NULL,0),(37,1,'2026-11-11',6,0,0,NULL,0),(38,1,'2026-11-12',6,0,0,NULL,0),(39,1,'2026-11-13',6,0,0,NULL,0),(40,1,'2026-11-14',6,0,0,NULL,0),(41,1,'2026-11-15',6,0,0,NULL,0),(42,1,'2026-11-16',6,0,0,NULL,0),(43,1,'2026-11-17',6,0,0,NULL,0),(44,1,'2026-11-18',6,0,0,NULL,0),(45,1,'2026-11-19',6,0,0,NULL,0),(46,1,'2026-11-20',6,0,0,NULL,0),(47,1,'2026-11-21',6,0,0,NULL,0),(48,1,'2026-11-22',6,0,0,NULL,0),(49,1,'2026-11-23',6,0,0,NULL,0),(50,1,'2026-11-24',6,0,0,NULL,0),(51,1,'2026-11-25',6,0,0,NULL,0),(52,1,'2026-11-26',6,0,0,NULL,0),(53,1,'2026-11-27',6,0,0,NULL,0),(54,1,'2026-11-28',6,0,0,NULL,0),(55,1,'2026-11-29',6,0,0,NULL,0),(56,1,'2026-11-30',6,0,0,NULL,0),(57,1,'2026-12-01',6,0,0,NULL,0),(58,1,'2026-12-02',6,0,0,NULL,0),(59,1,'2026-12-03',6,0,0,NULL,0),(60,1,'2026-12-04',6,0,0,NULL,0),(61,1,'2026-12-05',6,0,0,NULL,0),(62,1,'2026-12-06',6,0,0,NULL,0),(63,1,'2026-12-07',6,0,0,NULL,0),(64,1,'2026-12-08',6,0,0,NULL,0),(65,1,'2026-12-09',6,0,0,NULL,0),(66,1,'2026-12-10',6,0,0,NULL,0),(67,1,'2026-12-11',6,0,0,NULL,0),(68,1,'2026-12-12',6,0,0,NULL,0),(69,1,'2026-12-13',6,0,0,NULL,0),(70,1,'2026-12-14',6,0,0,NULL,0),(71,1,'2026-12-15',6,0,0,NULL,0),(72,1,'2026-12-16',6,0,0,NULL,0),(73,1,'2026-12-17',6,0,0,NULL,0),(74,1,'2026-12-18',6,0,0,NULL,0),(75,1,'2026-12-19',6,0,0,NULL,0),(76,1,'2026-12-20',6,0,0,NULL,0),(77,1,'2026-12-21',6,0,0,NULL,0),(78,1,'2026-12-22',6,0,0,NULL,0),(79,1,'2026-12-23',6,0,0,NULL,0),(80,1,'2026-12-24',6,0,0,NULL,0),(81,1,'2026-12-25',6,0,0,NULL,0),(82,1,'2026-12-26',6,0,0,NULL,0),(83,1,'2026-12-27',6,0,0,NULL,0),(84,1,'2026-12-28',6,0,0,NULL,0),(85,1,'2026-12-29',6,0,0,NULL,0),(86,1,'2026-12-30',6,0,0,NULL,0),(87,1,'2026-12-31',6,0,0,NULL,0),(88,1,'2027-01-01',6,0,0,NULL,0),(89,1,'2027-01-02',6,0,0,NULL,0),(90,1,'2027-01-03',6,0,0,NULL,0),(91,1,'2027-01-04',6,0,0,NULL,0),(92,1,'2027-01-05',6,0,0,NULL,0),(93,1,'2027-01-06',6,0,0,NULL,0),(94,1,'2027-01-07',6,0,0,NULL,0),(95,1,'2027-01-08',6,0,0,NULL,0),(96,1,'2027-01-09',6,0,0,NULL,0),(97,1,'2027-01-10',6,0,0,NULL,0),(98,1,'2027-01-11',6,0,0,NULL,0),(99,1,'2027-01-12',6,0,0,NULL,0),(100,1,'2027-01-13',6,0,0,NULL,0),(101,1,'2027-01-14',6,0,0,NULL,0),(102,1,'2027-01-15',6,0,0,NULL,0),(103,1,'2027-01-16',6,0,0,NULL,0),(104,1,'2027-01-17',6,0,0,NULL,0),(105,1,'2027-01-18',6,0,0,NULL,0),(106,1,'2027-01-19',6,0,0,NULL,0),(107,1,'2027-01-20',6,0,0,NULL,0),(108,1,'2027-01-21',6,0,0,NULL,0),(109,1,'2027-01-22',6,0,0,NULL,0),(110,1,'2027-01-23',6,0,0,NULL,0),(111,1,'2027-01-24',6,0,0,NULL,0),(112,1,'2027-01-25',6,0,0,NULL,0),(113,1,'2027-01-26',6,0,0,NULL,0),(114,1,'2027-01-27',6,0,0,NULL,0),(115,1,'2027-01-28',6,0,0,NULL,0),(116,1,'2027-01-29',6,0,0,NULL,0),(117,1,'2027-01-30',6,0,0,NULL,0),(118,1,'2027-01-31',6,0,0,NULL,0),(119,1,'2027-02-01',6,0,0,NULL,0),(120,1,'2027-02-02',6,0,0,NULL,0),(121,2,'2026-10-06',4,0,0,NULL,0),(122,2,'2026-10-07',4,0,0,NULL,0),(123,2,'2026-10-08',4,0,0,NULL,0),(124,2,'2026-10-09',4,0,0,NULL,0),(125,2,'2026-10-10',4,0,0,NULL,0),(126,2,'2026-10-11',4,0,0,NULL,0),(127,2,'2026-10-12',4,0,0,NULL,0),(128,2,'2026-10-13',4,0,0,NULL,0),(129,2,'2026-10-14',4,0,0,NULL,0),(130,2,'2026-10-15',4,0,0,NULL,0),(131,2,'2026-10-16',4,0,0,NULL,0),(132,2,'2026-10-17',4,0,0,NULL,0),(133,2,'2026-10-18',4,0,0,NULL,0),(134,2,'2026-10-19',4,0,0,NULL,0),(135,2,'2026-10-20',4,0,0,NULL,0),(136,2,'2026-10-21',4,0,0,NULL,0),(137,2,'2026-10-22',4,0,0,NULL,0),(138,2,'2026-10-23',4,0,0,NULL,0),(139,2,'2026-10-24',4,0,0,NULL,0),(140,2,'2026-10-25',4,0,0,NULL,0),(141,2,'2026-10-26',4,0,0,NULL,0),(142,2,'2026-10-27',4,0,0,NULL,0),(143,2,'2026-10-28',4,0,0,NULL,0),(144,2,'2026-10-29',4,0,0,NULL,0),(145,2,'2026-10-30',4,0,0,NULL,0),(146,2,'2026-10-31',4,0,0,NULL,0),(147,2,'2026-11-01',4,0,0,NULL,0),(148,2,'2026-11-02',4,0,0,NULL,0),(149,2,'2026-11-03',4,0,0,NULL,0),(150,2,'2026-11-04',4,0,0,NULL,0),(151,2,'2026-11-05',4,0,0,NULL,0),(152,2,'2026-11-06',4,0,0,NULL,0),(153,2,'2026-11-07',4,0,0,NULL,0),(154,2,'2026-11-08',4,0,0,NULL,0),(155,2,'2026-11-09',4,0,0,NULL,0),(156,2,'2026-11-10',4,0,0,NULL,0),(157,2,'2026-11-11',4,0,0,NULL,0),(158,2,'2026-11-12',4,0,0,NULL,0),(159,2,'2026-11-13',4,0,0,NULL,0),(160,2,'2026-11-14',4,0,0,NULL,0),(161,2,'2026-11-15',4,0,0,NULL,0),(162,2,'2026-11-16',4,0,0,NULL,0),(163,2,'2026-11-17',4,0,0,NULL,0),(164,2,'2026-11-18',4,0,0,NULL,0),(165,2,'2026-11-19',4,0,0,NULL,0),(166,2,'2026-11-20',4,0,0,NULL,0),(167,2,'2026-11-21',4,0,0,NULL,0),(168,2,'2026-11-22',4,0,0,NULL,0),(169,2,'2026-11-23',4,0,0,NULL,0),(170,2,'2026-11-24',4,0,0,NULL,0),(171,2,'2026-11-25',4,0,0,NULL,0),(172,2,'2026-11-26',4,0,0,NULL,0),(173,2,'2026-11-27',4,0,0,NULL,0),(174,2,'2026-11-28',4,0,0,NULL,0),(175,2,'2026-11-29',4,0,0,NULL,0),(176,2,'2026-11-30',4,0,0,NULL,0),(177,2,'2026-12-01',4,0,0,NULL,0),(178,2,'2026-12-02',4,0,0,NULL,0),(179,2,'2026-12-03',4,0,0,NULL,0),(180,2,'2026-12-04',4,0,0,NULL,0),(181,2,'2026-12-05',4,0,0,NULL,0),(182,2,'2026-12-06',4,0,0,NULL,0),(183,2,'2026-12-07',4,0,0,NULL,0),(184,2,'2026-12-08',4,0,0,NULL,0),(185,2,'2026-12-09',4,0,0,NULL,0),(186,2,'2026-12-10',4,0,0,NULL,0),(187,2,'2026-12-11',4,0,0,NULL,0),(188,2,'2026-12-12',4,0,0,NULL,0),(189,2,'2026-12-13',4,0,0,NULL,0),(190,2,'2026-12-14',4,0,0,NULL,0),(191,2,'2026-12-15',4,0,0,NULL,0),(192,2,'2026-12-16',4,0,0,NULL,0),(193,2,'2026-12-17',4,0,0,NULL,0),(194,2,'2026-12-18',4,0,0,NULL,0),(195,2,'2026-12-19',4,0,0,NULL,0),(196,2,'2026-12-20',4,0,0,NULL,0),(197,2,'2026-12-21',4,0,0,NULL,0),(198,2,'2026-12-22',4,0,0,NULL,0),(199,2,'2026-12-23',4,0,0,NULL,0),(200,2,'2026-12-24',4,0,0,NULL,0),(201,2,'2026-12-25',4,0,0,NULL,0),(202,2,'2026-12-26',4,0,0,NULL,0),(203,2,'2026-12-27',4,0,0,NULL,0),(204,2,'2026-12-28',4,0,0,NULL,0),(205,2,'2026-12-29',4,0,0,NULL,0),(206,2,'2026-12-30',4,0,0,NULL,0),(207,2,'2026-12-31',4,0,0,NULL,0),(208,2,'2027-01-01',4,0,0,NULL,0),(209,2,'2027-01-02',4,0,0,NULL,0),(210,2,'2027-01-03',4,0,0,NULL,0),(211,2,'2027-01-04',4,0,0,NULL,0),(212,2,'2027-01-05',4,0,0,NULL,0),(213,2,'2027-01-06',4,0,0,NULL,0),(214,2,'2027-01-07',4,0,0,NULL,0),(215,2,'2027-01-08',4,0,0,NULL,0),(216,2,'2027-01-09',4,0,0,NULL,0),(217,2,'2027-01-10',4,0,0,NULL,0),(218,2,'2027-01-11',4,0,0,NULL,0),(219,2,'2027-01-12',4,0,0,NULL,0),(220,2,'2027-01-13',4,0,0,NULL,0),(221,2,'2027-01-14',4,0,0,NULL,0),(222,2,'2027-01-15',4,0,0,NULL,0),(223,2,'2027-01-16',4,0,0,NULL,0),(224,2,'2027-01-17',4,0,0,NULL,0),(225,2,'2027-01-18',4,0,0,NULL,0),(226,2,'2027-01-19',4,0,0,NULL,0),(227,2,'2027-01-20',4,0,0,NULL,0),(228,2,'2027-01-21',4,0,0,NULL,0),(229,2,'2027-01-22',4,0,0,NULL,0),(230,2,'2027-01-23',4,0,0,NULL,0),(231,2,'2027-01-24',4,0,0,NULL,0),(232,2,'2027-01-25',4,0,0,NULL,0),(233,2,'2027-01-26',4,0,0,NULL,0),(234,2,'2027-01-27',4,0,0,NULL,0),(235,2,'2027-01-28',4,0,0,NULL,0),(236,2,'2027-01-29',4,0,0,NULL,0),(237,2,'2027-01-30',4,0,0,NULL,0),(238,2,'2027-01-31',4,0,0,NULL,0),(239,2,'2027-02-01',4,0,0,NULL,0),(240,2,'2027-02-02',4,0,0,NULL,0),(241,3,'2026-10-06',2,0,0,NULL,0),(242,3,'2026-10-07',2,0,0,NULL,0),(243,3,'2026-10-08',2,0,0,NULL,0),(244,3,'2026-10-09',2,0,0,NULL,0),(245,3,'2026-10-10',2,0,0,NULL,0),(246,3,'2026-10-11',2,0,0,NULL,0),(247,3,'2026-10-12',2,0,0,NULL,0),(248,3,'2026-10-13',2,0,0,NULL,0),(249,3,'2026-10-14',2,0,0,NULL,0),(250,3,'2026-10-15',2,0,0,NULL,0),(251,3,'2026-10-16',2,0,0,NULL,0),(252,3,'2026-10-17',2,0,0,NULL,0),(253,3,'2026-10-18',2,0,0,NULL,0),(254,3,'2026-10-19',2,0,0,NULL,0),(255,3,'2026-10-20',2,0,0,NULL,0),(256,3,'2026-10-21',2,0,0,NULL,0),(257,3,'2026-10-22',2,0,0,NULL,0),(258,3,'2026-10-23',2,0,0,NULL,0),(259,3,'2026-10-24',2,0,0,NULL,0),(260,3,'2026-10-25',2,0,0,NULL,0),(261,3,'2026-10-26',2,0,0,NULL,0),(262,3,'2026-10-27',2,0,0,NULL,0),(263,3,'2026-10-28',2,0,0,NULL,0),(264,3,'2026-10-29',2,0,0,NULL,0),(265,3,'2026-10-30',2,0,0,NULL,0),(266,3,'2026-10-31',2,0,0,NULL,0),(267,3,'2026-11-01',2,0,0,NULL,0),(268,3,'2026-11-02',2,0,0,NULL,0),(269,3,'2026-11-03',2,0,0,NULL,0),(270,3,'2026-11-04',2,0,0,NULL,0),(271,3,'2026-11-05',2,0,0,NULL,0),(272,3,'2026-11-06',2,0,0,NULL,0),(273,3,'2026-11-07',2,0,0,NULL,0),(274,3,'2026-11-08',2,0,0,NULL,0),(275,3,'2026-11-09',2,0,0,NULL,0),(276,3,'2026-11-10',2,0,0,NULL,0),(277,3,'2026-11-11',2,0,0,NULL,0),(278,3,'2026-11-12',2,0,0,NULL,0),(279,3,'2026-11-13',2,0,0,NULL,0),(280,3,'2026-11-14',2,0,0,NULL,0),(281,3,'2026-11-15',2,0,0,NULL,0),(282,3,'2026-11-16',2,0,0,NULL,0),(283,3,'2026-11-17',2,0,0,NULL,0),(284,3,'2026-11-18',2,0,0,NULL,0),(285,3,'2026-11-19',2,0,0,NULL,0),(286,3,'2026-11-20',2,0,0,NULL,0),(287,3,'2026-11-21',2,0,0,NULL,0),(288,3,'2026-11-22',2,0,0,NULL,0),(289,3,'2026-11-23',2,0,0,NULL,0),(290,3,'2026-11-24',2,0,0,NULL,0),(291,3,'2026-11-25',2,0,0,NULL,0),(292,3,'2026-11-26',2,0,0,NULL,0),(293,3,'2026-11-27',2,0,0,NULL,0),(294,3,'2026-11-28',2,0,0,NULL,0),(295,3,'2026-11-29',2,0,0,NULL,0),(296,3,'2026-11-30',2,0,0,NULL,0),(297,3,'2026-12-01',2,0,0,NULL,0),(298,3,'2026-12-02',2,0,0,NULL,0),(299,3,'2026-12-03',2,0,0,NULL,0),(300,3,'2026-12-04',2,0,0,NULL,0),(301,3,'2026-12-05',2,0,0,NULL,0),(302,3,'2026-12-06',2,0,0,NULL,0),(303,3,'2026-12-07',2,0,0,NULL,0),(304,3,'2026-12-08',2,0,0,NULL,0),(305,3,'2026-12-09',2,0,0,NULL,0),(306,3,'2026-12-10',2,0,0,NULL,0),(307,3,'2026-12-11',2,0,0,NULL,0),(308,3,'2026-12-12',2,0,0,NULL,0),(309,3,'2026-12-13',2,0,0,NULL,0),(310,3,'2026-12-14',2,0,0,NULL,0),(311,3,'2026-12-15',2,0,0,NULL,0),(312,3,'2026-12-16',2,0,0,NULL,0),(313,3,'2026-12-17',2,0,0,NULL,0),(314,3,'2026-12-18',2,0,0,NULL,0),(315,3,'2026-12-19',2,0,0,NULL,0),(316,3,'2026-12-20',2,0,0,NULL,0),(317,3,'2026-12-21',2,0,0,NULL,0),(318,3,'2026-12-22',2,0,0,NULL,0),(319,3,'2026-12-23',2,0,0,NULL,0),(320,3,'2026-12-24',2,0,0,NULL,0),(321,3,'2026-12-25',2,0,0,NULL,0),(322,3,'2026-12-26',2,0,0,NULL,0),(323,3,'2026-12-27',2,0,0,NULL,0),(324,3,'2026-12-28',2,0,0,NULL,0),(325,3,'2026-12-29',2,0,0,NULL,0),(326,3,'2026-12-30',2,0,0,NULL,0),(327,3,'2026-12-31',2,0,0,NULL,0),(328,3,'2027-01-01',2,0,0,NULL,0),(329,3,'2027-01-02',2,0,0,NULL,0),(330,3,'2027-01-03',2,0,0,NULL,0),(331,3,'2027-01-04',2,0,0,NULL,0),(332,3,'2027-01-05',2,0,0,NULL,0),(333,3,'2027-01-06',2,0,0,NULL,0),(334,3,'2027-01-07',2,0,0,NULL,0),(335,3,'2027-01-08',2,0,0,NULL,0),(336,3,'2027-01-09',2,0,0,NULL,0),(337,3,'2027-01-10',2,0,0,NULL,0),(338,3,'2027-01-11',2,0,0,NULL,0),(339,3,'2027-01-12',2,0,0,NULL,0),(340,3,'2027-01-13',2,0,0,NULL,0),(341,3,'2027-01-14',2,0,0,NULL,0),(342,3,'2027-01-15',2,0,0,NULL,0),(343,3,'2027-01-16',2,0,0,NULL,0),(344,3,'2027-01-17',2,0,0,NULL,0),(345,3,'2027-01-18',2,0,0,NULL,0),(346,3,'2027-01-19',2,0,0,NULL,0),(347,3,'2027-01-20',2,0,0,NULL,0),(348,3,'2027-01-21',2,0,0,NULL,0),(349,3,'2027-01-22',2,0,0,NULL,0),(350,3,'2027-01-23',2,0,0,NULL,0),(351,3,'2027-01-24',2,0,0,NULL,0),(352,3,'2027-01-25',2,0,0,NULL,0),(353,3,'2027-01-26',2,0,0,NULL,0),(354,3,'2027-01-27',2,0,0,NULL,0),(355,3,'2027-01-28',2,0,0,NULL,0),(356,3,'2027-01-29',2,0,0,NULL,0),(357,3,'2027-01-30',2,0,0,NULL,0),(358,3,'2027-01-31',2,0,0,NULL,0),(359,3,'2027-02-01',2,0,0,NULL,0),(360,3,'2027-02-02',2,0,0,NULL,0),(361,4,'2026-10-06',5,0,0,NULL,0),(362,4,'2026-10-07',5,0,0,NULL,0),(363,4,'2026-10-08',5,0,0,NULL,0),(364,4,'2026-10-09',5,0,0,NULL,0),(365,4,'2026-10-10',5,0,0,NULL,0),(366,4,'2026-10-11',5,0,0,NULL,0),(367,4,'2026-10-12',5,0,0,NULL,0),(368,4,'2026-10-13',5,0,0,NULL,0),(369,4,'2026-10-14',5,0,0,NULL,0),(370,4,'2026-10-15',5,0,0,NULL,0),(371,4,'2026-10-16',5,0,0,NULL,0),(372,4,'2026-10-17',5,0,0,NULL,0),(373,4,'2026-10-18',5,0,0,NULL,0),(374,4,'2026-10-19',5,0,0,NULL,0),(375,4,'2026-10-20',5,0,0,NULL,0),(376,4,'2026-10-21',5,0,0,NULL,0),(377,4,'2026-10-22',5,0,0,NULL,0),(378,4,'2026-10-23',5,0,0,NULL,0),(379,4,'2026-10-24',5,0,0,NULL,0),(380,4,'2026-10-25',5,0,0,NULL,0),(381,4,'2026-10-26',5,0,0,NULL,0),(382,4,'2026-10-27',5,0,0,NULL,0),(383,4,'2026-10-28',5,0,0,NULL,0),(384,4,'2026-10-29',5,0,0,NULL,0),(385,4,'2026-10-30',5,0,0,NULL,0),(386,4,'2026-10-31',5,0,0,NULL,0),(387,4,'2026-11-01',5,0,0,NULL,0),(388,4,'2026-11-02',5,0,0,NULL,0),(389,4,'2026-11-03',5,0,0,NULL,0),(390,4,'2026-11-04',5,0,0,NULL,0),(391,4,'2026-11-05',5,0,0,NULL,0),(392,4,'2026-11-06',5,0,0,NULL,0),(393,4,'2026-11-07',5,0,0,NULL,0),(394,4,'2026-11-08',5,0,0,NULL,0),(395,4,'2026-11-09',5,0,0,NULL,0),(396,4,'2026-11-10',5,0,0,NULL,0),(397,4,'2026-11-11',5,0,0,NULL,0),(398,4,'2026-11-12',5,0,0,NULL,0),(399,4,'2026-11-13',5,0,0,NULL,0),(400,4,'2026-11-14',5,0,0,NULL,0),(401,4,'2026-11-15',5,0,0,NULL,0),(402,4,'2026-11-16',5,0,0,NULL,0),(403,4,'2026-11-17',5,0,0,NULL,0),(404,4,'2026-11-18',5,0,0,NULL,0),(405,4,'2026-11-19',5,0,0,NULL,0),(406,4,'2026-11-20',5,0,0,NULL,0),(407,4,'2026-11-21',5,0,0,NULL,0),(408,4,'2026-11-22',5,0,0,NULL,0),(409,4,'2026-11-23',5,0,0,NULL,0),(410,4,'2026-11-24',5,0,0,NULL,0),(411,4,'2026-11-25',5,0,0,NULL,0),(412,4,'2026-11-26',5,0,0,NULL,0),(413,4,'2026-11-27',5,0,0,NULL,0),(414,4,'2026-11-28',5,0,0,NULL,0),(415,4,'2026-11-29',5,0,0,NULL,0),(416,4,'2026-11-30',5,0,0,NULL,0),(417,4,'2026-12-01',5,0,0,NULL,0),(418,4,'2026-12-02',5,0,0,NULL,0),(419,4,'2026-12-03',5,0,0,NULL,0),(420,4,'2026-12-04',5,0,0,NULL,0),(421,4,'2026-12-05',5,0,0,NULL,0),(422,4,'2026-12-06',5,0,0,NULL,0),(423,4,'2026-12-07',5,0,0,NULL,0),(424,4,'2026-12-08',5,0,0,NULL,0),(425,4,'2026-12-09',5,0,0,NULL,0),(426,4,'2026-12-10',5,0,0,NULL,0),(427,4,'2026-12-11',5,0,0,NULL,0),(428,4,'2026-12-12',5,0,0,NULL,0),(429,4,'2026-12-13',5,0,0,NULL,0),(430,4,'2026-12-14',5,0,0,NULL,0),(431,4,'2026-12-15',5,0,0,NULL,0),(432,4,'2026-12-16',5,0,0,NULL,0),(433,4,'2026-12-17',5,0,0,NULL,0),(434,4,'2026-12-18',5,0,0,NULL,0),(435,4,'2026-12-19',5,0,0,NULL,0),(436,4,'2026-12-20',5,0,0,NULL,0),(437,4,'2026-12-21',5,0,0,NULL,0),(438,4,'2026-12-22',5,0,0,NULL,0),(439,4,'2026-12-23',5,0,0,NULL,0),(440,4,'2026-12-24',5,0,0,NULL,0),(441,4,'2026-12-25',5,0,0,NULL,0),(442,4,'2026-12-26',5,0,0,NULL,0),(443,4,'2026-12-27',5,0,0,NULL,0),(444,4,'2026-12-28',5,0,0,NULL,0),(445,4,'2026-12-29',5,0,0,NULL,0),(446,4,'2026-12-30',5,0,0,NULL,0),(447,4,'2026-12-31',5,0,0,NULL,0),(448,4,'2027-01-01',5,0,0,NULL,0),(449,4,'2027-01-02',5,0,0,NULL,0),(450,4,'2027-01-03',5,0,0,NULL,0),(451,4,'2027-01-04',5,0,0,NULL,0),(452,4,'2027-01-05',5,0,0,NULL,0),(453,4,'2027-01-06',5,0,0,NULL,0),(454,4,'2027-01-07',5,0,0,NULL,0),(455,4,'2027-01-08',5,0,0,NULL,0),(456,4,'2027-01-09',5,0,0,NULL,0),(457,4,'2027-01-10',5,0,0,NULL,0),(458,4,'2027-01-11',5,0,0,NULL,0),(459,4,'2027-01-12',5,0,0,NULL,0),(460,4,'2027-01-13',5,0,0,NULL,0),(461,4,'2027-01-14',5,0,0,NULL,0),(462,4,'2027-01-15',5,0,0,NULL,0),(463,4,'2027-01-16',5,0,0,NULL,0),(464,4,'2027-01-17',5,0,0,NULL,0),(465,4,'2027-01-18',5,0,0,NULL,0),(466,4,'2027-01-19',5,0,0,NULL,0),(467,4,'2027-01-20',5,0,0,NULL,0),(468,4,'2027-01-21',5,0,0,NULL,0),(469,4,'2027-01-22',5,0,0,NULL,0),(470,4,'2027-01-23',5,0,0,NULL,0),(471,4,'2027-01-24',5,0,0,NULL,0),(472,4,'2027-01-25',5,0,0,NULL,0),(473,4,'2027-01-26',5,0,0,NULL,0),(474,4,'2027-01-27',5,0,0,NULL,0),(475,4,'2027-01-28',5,0,0,NULL,0),(476,4,'2027-01-29',5,0,0,NULL,0),(477,4,'2027-01-30',5,0,0,NULL,0),(478,4,'2027-01-31',5,0,0,NULL,0),(479,4,'2027-02-01',5,0,0,NULL,0),(480,4,'2027-02-02',5,0,0,NULL,0),(481,5,'2026-10-06',3,0,0,NULL,0),(482,5,'2026-10-07',3,0,0,NULL,0),(483,5,'2026-10-08',3,0,0,NULL,0),(484,5,'2026-10-09',3,0,0,NULL,0),(485,5,'2026-10-10',3,0,0,NULL,0),(486,5,'2026-10-11',3,0,0,NULL,0),(487,5,'2026-10-12',3,0,0,NULL,0),(488,5,'2026-10-13',3,0,0,NULL,0),(489,5,'2026-10-14',3,0,0,NULL,0),(490,5,'2026-10-15',3,0,0,NULL,0),(491,5,'2026-10-16',3,0,0,NULL,0),(492,5,'2026-10-17',3,0,0,NULL,0),(493,5,'2026-10-18',3,0,0,NULL,0),(494,5,'2026-10-19',3,0,0,NULL,0),(495,5,'2026-10-20',3,0,0,NULL,0),(496,5,'2026-10-21',3,0,0,NULL,0),(497,5,'2026-10-22',3,0,0,NULL,0),(498,5,'2026-10-23',3,0,0,NULL,0),(499,5,'2026-10-24',3,0,0,NULL,0),(500,5,'2026-10-25',3,0,0,NULL,0),(501,5,'2026-10-26',3,0,0,NULL,0),(502,5,'2026-10-27',3,0,0,NULL,0),(503,5,'2026-10-28',3,0,0,NULL,0),(504,5,'2026-10-29',3,0,0,NULL,0),(505,5,'2026-10-30',3,0,0,NULL,0),(506,5,'2026-10-31',3,0,0,NULL,0),(507,5,'2026-11-01',3,0,0,NULL,0),(508,5,'2026-11-02',3,0,0,NULL,0),(509,5,'2026-11-03',3,0,0,NULL,0),(510,5,'2026-11-04',3,0,0,NULL,0),(511,5,'2026-11-05',3,0,0,NULL,0),(512,5,'2026-11-06',3,0,0,NULL,0),(513,5,'2026-11-07',3,0,0,NULL,0),(514,5,'2026-11-08',3,0,0,NULL,0),(515,5,'2026-11-09',3,0,0,NULL,0),(516,5,'2026-11-10',3,0,0,NULL,0),(517,5,'2026-11-11',3,0,0,NULL,0),(518,5,'2026-11-12',3,0,0,NULL,0),(519,5,'2026-11-13',3,0,0,NULL,0),(520,5,'2026-11-14',3,0,0,NULL,0),(521,5,'2026-11-15',3,0,0,NULL,0),(522,5,'2026-11-16',3,0,0,NULL,0),(523,5,'2026-11-17',3,0,0,NULL,0),(524,5,'2026-11-18',3,0,0,NULL,0),(525,5,'2026-11-19',3,0,0,NULL,0),(526,5,'2026-11-20',3,0,0,NULL,0),(527,5,'2026-11-21',3,0,0,NULL,0),(528,5,'2026-11-22',3,0,0,NULL,0),(529,5,'2026-11-23',3,0,0,NULL,0),(530,5,'2026-11-24',3,0,0,NULL,0),(531,5,'2026-11-25',3,0,0,NULL,0),(532,5,'2026-11-26',3,0,0,NULL,0),(533,5,'2026-11-27',3,0,0,NULL,0),(534,5,'2026-11-28',3,0,0,NULL,0),(535,5,'2026-11-29',3,0,0,NULL,0),(536,5,'2026-11-30',3,0,0,NULL,0),(537,5,'2026-12-01',3,0,0,NULL,0),(538,5,'2026-12-02',3,0,0,NULL,0),(539,5,'2026-12-03',3,0,0,NULL,0),(540,5,'2026-12-04',3,0,0,NULL,0),(541,5,'2026-12-05',3,0,0,NULL,0),(542,5,'2026-12-06',3,0,0,NULL,0),(543,5,'2026-12-07',3,0,0,NULL,0),(544,5,'2026-12-08',3,0,0,NULL,0),(545,5,'2026-12-09',3,0,0,NULL,0),(546,5,'2026-12-10',3,0,0,NULL,0),(547,5,'2026-12-11',3,0,0,NULL,0),(548,5,'2026-12-12',3,0,0,NULL,0),(549,5,'2026-12-13',3,0,0,NULL,0),(550,5,'2026-12-14',3,0,0,NULL,0),(551,5,'2026-12-15',3,0,0,NULL,0),(552,5,'2026-12-16',3,0,0,NULL,0),(553,5,'2026-12-17',3,0,0,NULL,0),(554,5,'2026-12-18',3,0,0,NULL,0),(555,5,'2026-12-19',3,0,0,NULL,0),(556,5,'2026-12-20',3,0,0,NULL,0),(557,5,'2026-12-21',3,0,0,NULL,0),(558,5,'2026-12-22',3,0,0,NULL,0),(559,5,'2026-12-23',3,0,0,NULL,0),(560,5,'2026-12-24',3,0,0,NULL,0),(561,5,'2026-12-25',3,0,0,NULL,0),(562,5,'2026-12-26',3,0,0,NULL,0),(563,5,'2026-12-27',3,0,0,NULL,0),(564,5,'2026-12-28',3,0,0,NULL,0),(565,5,'2026-12-29',3,0,0,NULL,0),(566,5,'2026-12-30',3,0,0,NULL,0),(567,5,'2026-12-31',3,0,0,NULL,0),(568,5,'2027-01-01',3,0,0,NULL,0),(569,5,'2027-01-02',3,0,0,NULL,0),(570,5,'2027-01-03',3,0,0,NULL,0),(571,5,'2027-01-04',3,0,0,NULL,0),(572,5,'2027-01-05',3,0,0,NULL,0),(573,5,'2027-01-06',3,0,0,NULL,0),(574,5,'2027-01-07',3,0,0,NULL,0),(575,5,'2027-01-08',3,0,0,NULL,0),(576,5,'2027-01-09',3,0,0,NULL,0),(577,5,'2027-01-10',3,0,0,NULL,0),(578,5,'2027-01-11',3,0,0,NULL,0),(579,5,'2027-01-12',3,0,0,NULL,0),(580,5,'2027-01-13',3,0,0,NULL,0),(581,5,'2027-01-14',3,0,0,NULL,0),(582,5,'2027-01-15',3,0,0,NULL,0),(583,5,'2027-01-16',3,0,0,NULL,0),(584,5,'2027-01-17',3,0,0,NULL,0),(585,5,'2027-01-18',3,0,0,NULL,0),(586,5,'2027-01-19',3,0,0,NULL,0),(587,5,'2027-01-20',3,0,0,NULL,0),(588,5,'2027-01-21',3,0,0,NULL,0),(589,5,'2027-01-22',3,0,0,NULL,0),(590,5,'2027-01-23',3,0,0,NULL,0),(591,5,'2027-01-24',3,0,0,NULL,0),(592,5,'2027-01-25',3,0,0,NULL,0),(593,5,'2027-01-26',3,0,0,NULL,0),(594,5,'2027-01-27',3,0,0,NULL,0),(595,5,'2027-01-28',3,0,0,NULL,0),(596,5,'2027-01-29',3,0,0,NULL,0),(597,5,'2027-01-30',3,0,0,NULL,0),(598,5,'2027-01-31',3,0,0,NULL,0),(599,5,'2027-02-01',3,0,0,NULL,0),(600,5,'2027-02-02',3,0,0,NULL,0),(601,6,'2026-10-06',6,0,0,NULL,0),(602,6,'2026-10-07',6,0,0,NULL,0),(603,6,'2026-10-08',6,0,0,NULL,0),(604,6,'2026-10-09',6,0,0,NULL,0),(605,6,'2026-10-10',6,0,0,NULL,0),(606,6,'2026-10-11',6,0,0,NULL,0),(607,6,'2026-10-12',6,0,0,NULL,0),(608,6,'2026-10-13',6,0,0,NULL,0),(609,6,'2026-10-14',6,0,0,NULL,0),(610,6,'2026-10-15',6,0,0,NULL,0),(611,6,'2026-10-16',6,0,0,NULL,0),(612,6,'2026-10-17',6,0,0,NULL,0),(613,6,'2026-10-18',6,0,0,NULL,0),(614,6,'2026-10-19',6,0,0,NULL,0),(615,6,'2026-10-20',6,0,0,NULL,0),(616,6,'2026-10-21',6,0,0,NULL,0),(617,6,'2026-10-22',6,0,0,NULL,0),(618,6,'2026-10-23',6,0,0,NULL,0),(619,6,'2026-10-24',6,0,0,NULL,0),(620,6,'2026-10-25',6,0,0,NULL,0),(621,6,'2026-10-26',6,0,0,NULL,0),(622,6,'2026-10-27',6,0,0,NULL,0),(623,6,'2026-10-28',6,0,0,NULL,0),(624,6,'2026-10-29',6,0,0,NULL,0),(625,6,'2026-10-30',6,0,0,NULL,0),(626,6,'2026-10-31',6,0,0,NULL,0),(627,6,'2026-11-01',6,0,0,NULL,0),(628,6,'2026-11-02',6,0,0,NULL,0),(629,6,'2026-11-03',6,0,0,NULL,0),(630,6,'2026-11-04',6,0,0,NULL,0),(631,6,'2026-11-05',6,0,0,NULL,0),(632,6,'2026-11-06',6,0,0,NULL,0),(633,6,'2026-11-07',6,0,0,NULL,0),(634,6,'2026-11-08',6,0,0,NULL,0),(635,6,'2026-11-09',6,0,0,NULL,0),(636,6,'2026-11-10',6,0,0,NULL,0),(637,6,'2026-11-11',6,0,0,NULL,0),(638,6,'2026-11-12',6,0,0,NULL,0),(639,6,'2026-11-13',6,0,0,NULL,0),(640,6,'2026-11-14',6,0,0,NULL,0),(641,6,'2026-11-15',6,0,0,NULL,0),(642,6,'2026-11-16',6,0,0,NULL,0),(643,6,'2026-11-17',6,0,0,NULL,0),(644,6,'2026-11-18',6,0,0,NULL,0),(645,6,'2026-11-19',6,0,0,NULL,0),(646,6,'2026-11-20',6,0,0,NULL,0),(647,6,'2026-11-21',6,0,0,NULL,0),(648,6,'2026-11-22',6,0,0,NULL,0),(649,6,'2026-11-23',6,0,0,NULL,0),(650,6,'2026-11-24',6,0,0,NULL,0),(651,6,'2026-11-25',6,0,0,NULL,0),(652,6,'2026-11-26',6,0,0,NULL,0),(653,6,'2026-11-27',6,0,0,NULL,0),(654,6,'2026-11-28',6,0,0,NULL,0),(655,6,'2026-11-29',6,0,0,NULL,0),(656,6,'2026-11-30',6,0,0,NULL,0),(657,6,'2026-12-01',6,0,0,NULL,0),(658,6,'2026-12-02',6,0,0,NULL,0),(659,6,'2026-12-03',6,0,0,NULL,0),(660,6,'2026-12-04',6,0,0,NULL,0),(661,6,'2026-12-05',6,0,0,NULL,0),(662,6,'2026-12-06',6,0,0,NULL,0),(663,6,'2026-12-07',6,0,0,NULL,0),(664,6,'2026-12-08',6,0,0,NULL,0),(665,6,'2026-12-09',6,0,0,NULL,0),(666,6,'2026-12-10',6,0,0,NULL,0),(667,6,'2026-12-11',6,0,0,NULL,0),(668,6,'2026-12-12',6,0,0,NULL,0),(669,6,'2026-12-13',6,0,0,NULL,0),(670,6,'2026-12-14',6,0,0,NULL,0),(671,6,'2026-12-15',6,0,0,NULL,0),(672,6,'2026-12-16',6,0,0,NULL,0),(673,6,'2026-12-17',6,0,0,NULL,0),(674,6,'2026-12-18',6,0,0,NULL,0),(675,6,'2026-12-19',6,0,0,NULL,0),(676,6,'2026-12-20',6,0,0,NULL,0),(677,6,'2026-12-21',6,0,0,NULL,0),(678,6,'2026-12-22',6,0,0,NULL,0),(679,6,'2026-12-23',6,0,0,NULL,0),(680,6,'2026-12-24',6,0,0,NULL,0),(681,6,'2026-12-25',6,0,0,NULL,0),(682,6,'2026-12-26',6,0,0,NULL,0),(683,6,'2026-12-27',6,0,0,NULL,0),(684,6,'2026-12-28',6,0,0,NULL,0),(685,6,'2026-12-29',6,0,0,NULL,0),(686,6,'2026-12-30',6,0,0,NULL,0),(687,6,'2026-12-31',6,0,0,NULL,0),(688,6,'2027-01-01',6,0,0,NULL,0),(689,6,'2027-01-02',6,0,0,NULL,0),(690,6,'2027-01-03',6,0,0,NULL,0),(691,6,'2027-01-04',6,0,0,NULL,0),(692,6,'2027-01-05',6,0,0,NULL,0),(693,6,'2027-01-06',6,0,0,NULL,0),(694,6,'2027-01-07',6,0,0,NULL,0),(695,6,'2027-01-08',6,0,0,NULL,0),(696,6,'2027-01-09',6,0,0,NULL,0),(697,6,'2027-01-10',6,0,0,NULL,0),(698,6,'2027-01-11',6,0,0,NULL,0),(699,6,'2027-01-12',6,0,0,NULL,0),(700,6,'2027-01-13',6,0,0,NULL,0),(701,6,'2027-01-14',6,0,0,NULL,0),(702,6,'2027-01-15',6,0,0,NULL,0),(703,6,'2027-01-16',6,0,0,NULL,0),(704,6,'2027-01-17',6,0,0,NULL,0),(705,6,'2027-01-18',6,0,0,NULL,0),(706,6,'2027-01-19',6,0,0,NULL,0),(707,6,'2027-01-20',6,0,0,NULL,0),(708,6,'2027-01-21',6,0,0,NULL,0),(709,6,'2027-01-22',6,0,0,NULL,0),(710,6,'2027-01-23',6,0,0,NULL,0),(711,6,'2027-01-24',6,0,0,NULL,0),(712,6,'2027-01-25',6,0,0,NULL,0),(713,6,'2027-01-26',6,0,0,NULL,0),(714,6,'2027-01-27',6,0,0,NULL,0),(715,6,'2027-01-28',6,0,0,NULL,0),(716,6,'2027-01-29',6,0,0,NULL,0),(717,6,'2027-01-30',6,0,0,NULL,0),(718,6,'2027-01-31',6,0,0,NULL,0),(719,6,'2027-02-01',6,0,0,NULL,0),(720,6,'2027-02-02',6,0,0,NULL,0),(721,7,'2026-10-06',3,0,0,NULL,0),(722,7,'2026-10-07',3,0,0,NULL,0),(723,7,'2026-10-08',3,0,0,NULL,0),(724,7,'2026-10-09',3,0,0,NULL,0),(725,7,'2026-10-10',3,0,0,NULL,0),(726,7,'2026-10-11',3,0,0,NULL,0),(727,7,'2026-10-12',3,0,0,NULL,0),(728,7,'2026-10-13',3,0,0,NULL,0),(729,7,'2026-10-14',3,0,0,NULL,0),(730,7,'2026-10-15',3,0,0,NULL,0),(731,7,'2026-10-16',3,0,0,NULL,0),(732,7,'2026-10-17',3,0,0,NULL,0),(733,7,'2026-10-18',3,0,0,NULL,0),(734,7,'2026-10-19',3,0,0,NULL,0),(735,7,'2026-10-20',3,0,0,NULL,0),(736,7,'2026-10-21',3,0,0,NULL,0),(737,7,'2026-10-22',3,0,0,NULL,0),(738,7,'2026-10-23',3,0,0,NULL,0),(739,7,'2026-10-24',3,0,0,NULL,0),(740,7,'2026-10-25',3,0,0,NULL,0),(741,7,'2026-10-26',3,0,0,NULL,0),(742,7,'2026-10-27',3,0,0,NULL,0),(743,7,'2026-10-28',3,0,0,NULL,0),(744,7,'2026-10-29',3,0,0,NULL,0),(745,7,'2026-10-30',3,0,0,NULL,0),(746,7,'2026-10-31',3,0,0,NULL,0),(747,7,'2026-11-01',3,0,0,NULL,0),(748,7,'2026-11-02',3,0,0,NULL,0),(749,7,'2026-11-03',3,0,0,NULL,0),(750,7,'2026-11-04',3,0,0,NULL,0),(751,7,'2026-11-05',3,0,0,NULL,0),(752,7,'2026-11-06',3,0,0,NULL,0),(753,7,'2026-11-07',3,0,0,NULL,0),(754,7,'2026-11-08',3,0,0,NULL,0),(755,7,'2026-11-09',3,0,0,NULL,0),(756,7,'2026-11-10',3,0,0,NULL,0),(757,7,'2026-11-11',3,0,0,NULL,0),(758,7,'2026-11-12',3,0,0,NULL,0),(759,7,'2026-11-13',3,0,0,NULL,0),(760,7,'2026-11-14',3,0,0,NULL,0),(761,7,'2026-11-15',3,0,0,NULL,0),(762,7,'2026-11-16',3,0,0,NULL,0),(763,7,'2026-11-17',3,0,0,NULL,0),(764,7,'2026-11-18',3,0,0,NULL,0),(765,7,'2026-11-19',3,0,0,NULL,0),(766,7,'2026-11-20',3,0,0,NULL,0),(767,7,'2026-11-21',3,0,0,NULL,0),(768,7,'2026-11-22',3,0,0,NULL,0),(769,7,'2026-11-23',3,0,0,NULL,0),(770,7,'2026-11-24',3,0,0,NULL,0),(771,7,'2026-11-25',3,0,0,NULL,0),(772,7,'2026-11-26',3,0,0,NULL,0),(773,7,'2026-11-27',3,0,0,NULL,0),(774,7,'2026-11-28',3,0,0,NULL,0),(775,7,'2026-11-29',3,0,0,NULL,0),(776,7,'2026-11-30',3,0,0,NULL,0),(777,7,'2026-12-01',3,0,0,NULL,0),(778,7,'2026-12-02',3,0,0,NULL,0),(779,7,'2026-12-03',3,0,0,NULL,0),(780,7,'2026-12-04',3,0,0,NULL,0),(781,7,'2026-12-05',3,0,0,NULL,0),(782,7,'2026-12-06',3,0,0,NULL,0),(783,7,'2026-12-07',3,0,0,NULL,0),(784,7,'2026-12-08',3,0,0,NULL,0),(785,7,'2026-12-09',3,0,0,NULL,0),(786,7,'2026-12-10',3,0,0,NULL,0),(787,7,'2026-12-11',3,0,0,NULL,0),(788,7,'2026-12-12',3,0,0,NULL,0),(789,7,'2026-12-13',3,0,0,NULL,0),(790,7,'2026-12-14',3,0,0,NULL,0),(791,7,'2026-12-15',3,0,0,NULL,0),(792,7,'2026-12-16',3,0,0,NULL,0),(793,7,'2026-12-17',3,0,0,NULL,0),(794,7,'2026-12-18',3,0,0,NULL,0),(795,7,'2026-12-19',3,0,0,NULL,0),(796,7,'2026-12-20',3,0,0,NULL,0),(797,7,'2026-12-21',3,0,0,NULL,0),(798,7,'2026-12-22',3,0,0,NULL,0),(799,7,'2026-12-23',3,0,0,NULL,0),(800,7,'2026-12-24',3,0,0,NULL,0),(801,7,'2026-12-25',3,0,0,NULL,0),(802,7,'2026-12-26',3,0,0,NULL,0),(803,7,'2026-12-27',3,0,0,NULL,0),(804,7,'2026-12-28',3,0,0,NULL,0),(805,7,'2026-12-29',3,0,0,NULL,0),(806,7,'2026-12-30',3,0,0,NULL,0),(807,7,'2026-12-31',3,0,0,NULL,0),(808,7,'2027-01-01',3,0,0,NULL,0),(809,7,'2027-01-02',3,0,0,NULL,0),(810,7,'2027-01-03',3,0,0,NULL,0),(811,7,'2027-01-04',3,0,0,NULL,0),(812,7,'2027-01-05',3,0,0,NULL,0),(813,7,'2027-01-06',3,0,0,NULL,0),(814,7,'2027-01-07',3,0,0,NULL,0),(815,7,'2027-01-08',3,0,0,NULL,0),(816,7,'2027-01-09',3,0,0,NULL,0),(817,7,'2027-01-10',3,0,0,NULL,0),(818,7,'2027-01-11',3,0,0,NULL,0),(819,7,'2027-01-12',3,0,0,NULL,0),(820,7,'2027-01-13',3,0,0,NULL,0),(821,7,'2027-01-14',3,0,0,NULL,0),(822,7,'2027-01-15',3,0,0,NULL,0),(823,7,'2027-01-16',3,0,0,NULL,0),(824,7,'2027-01-17',3,0,0,NULL,0),(825,7,'2027-01-18',3,0,0,NULL,0),(826,7,'2027-01-19',3,0,0,NULL,0),(827,7,'2027-01-20',3,0,0,NULL,0),(828,7,'2027-01-21',3,0,0,NULL,0),(829,7,'2027-01-22',3,0,0,NULL,0),(830,7,'2027-01-23',3,0,0,NULL,0),(831,7,'2027-01-24',3,0,0,NULL,0),(832,7,'2027-01-25',3,0,0,NULL,0),(833,7,'2027-01-26',3,0,0,NULL,0),(834,7,'2027-01-27',3,0,0,NULL,0),(835,7,'2027-01-28',3,0,0,NULL,0),(836,7,'2027-01-29',3,0,0,NULL,0),(837,7,'2027-01-30',3,0,0,NULL,0),(838,7,'2027-01-31',3,0,0,NULL,0),(839,7,'2027-02-01',3,0,0,NULL,0),(840,7,'2027-02-02',3,0,0,NULL,0),(841,8,'2026-10-06',10,0,0,NULL,0),(842,8,'2026-10-07',10,0,0,NULL,0),(843,8,'2026-10-08',10,0,0,NULL,0),(844,8,'2026-10-09',10,0,0,NULL,0),(845,8,'2026-10-10',10,0,0,NULL,0),(846,8,'2026-10-11',10,0,0,NULL,0),(847,8,'2026-10-12',10,0,0,NULL,0),(848,8,'2026-10-13',10,0,0,NULL,0),(849,8,'2026-10-14',10,0,0,NULL,0),(850,8,'2026-10-15',10,0,0,NULL,0),(851,8,'2026-10-16',10,0,0,NULL,0),(852,8,'2026-10-17',10,0,0,NULL,0),(853,8,'2026-10-18',10,0,0,NULL,0),(854,8,'2026-10-19',10,0,0,NULL,0),(855,8,'2026-10-20',10,0,0,NULL,0),(856,8,'2026-10-21',10,0,0,NULL,0),(857,8,'2026-10-22',10,0,0,NULL,0),(858,8,'2026-10-23',10,0,0,NULL,0),(859,8,'2026-10-24',10,0,0,NULL,0),(860,8,'2026-10-25',10,0,0,NULL,0),(861,8,'2026-10-26',10,0,0,NULL,0),(862,8,'2026-10-27',10,0,0,NULL,0),(863,8,'2026-10-28',10,0,0,NULL,0),(864,8,'2026-10-29',10,0,0,NULL,0),(865,8,'2026-10-30',10,0,0,NULL,0),(866,8,'2026-10-31',10,0,0,NULL,0),(867,8,'2026-11-01',10,0,0,NULL,0),(868,8,'2026-11-02',10,0,0,NULL,0),(869,8,'2026-11-03',10,0,0,NULL,0),(870,8,'2026-11-04',10,0,0,NULL,0),(871,8,'2026-11-05',10,0,0,NULL,0),(872,8,'2026-11-06',10,0,0,NULL,0),(873,8,'2026-11-07',10,0,0,NULL,0),(874,8,'2026-11-08',10,0,0,NULL,0),(875,8,'2026-11-09',10,0,0,NULL,0),(876,8,'2026-11-10',10,0,0,NULL,0),(877,8,'2026-11-11',10,0,0,NULL,0),(878,8,'2026-11-12',10,0,0,NULL,0),(879,8,'2026-11-13',10,0,0,NULL,0),(880,8,'2026-11-14',10,0,0,NULL,0),(881,8,'2026-11-15',10,0,0,NULL,0),(882,8,'2026-11-16',10,0,0,NULL,0),(883,8,'2026-11-17',10,0,0,NULL,0),(884,8,'2026-11-18',10,0,0,NULL,0),(885,8,'2026-11-19',10,0,0,NULL,0),(886,8,'2026-11-20',10,0,0,NULL,0),(887,8,'2026-11-21',10,0,0,NULL,0),(888,8,'2026-11-22',10,0,0,NULL,0),(889,8,'2026-11-23',10,0,0,NULL,0),(890,8,'2026-11-24',10,0,0,NULL,0),(891,8,'2026-11-25',10,0,0,NULL,0),(892,8,'2026-11-26',10,0,0,NULL,0),(893,8,'2026-11-27',10,0,0,NULL,0),(894,8,'2026-11-28',10,0,0,NULL,0),(895,8,'2026-11-29',10,0,0,NULL,0),(896,8,'2026-11-30',10,0,0,NULL,0),(897,8,'2026-12-01',10,0,0,NULL,0),(898,8,'2026-12-02',10,0,0,NULL,0),(899,8,'2026-12-03',10,0,0,NULL,0),(900,8,'2026-12-04',10,0,0,NULL,0),(901,8,'2026-12-05',10,0,0,NULL,0),(902,8,'2026-12-06',10,0,0,NULL,0),(903,8,'2026-12-07',10,0,0,NULL,0),(904,8,'2026-12-08',10,0,0,NULL,0),(905,8,'2026-12-09',10,0,0,NULL,0),(906,8,'2026-12-10',10,0,0,NULL,0),(907,8,'2026-12-11',10,0,0,NULL,0),(908,8,'2026-12-12',10,0,0,NULL,0),(909,8,'2026-12-13',10,0,0,NULL,0),(910,8,'2026-12-14',10,0,0,NULL,0),(911,8,'2026-12-15',10,0,0,NULL,0),(912,8,'2026-12-16',10,0,0,NULL,0),(913,8,'2026-12-17',10,0,0,NULL,0),(914,8,'2026-12-18',10,0,0,NULL,0),(915,8,'2026-12-19',10,0,0,NULL,0),(916,8,'2026-12-20',10,0,0,NULL,0),(917,8,'2026-12-21',10,0,0,NULL,0),(918,8,'2026-12-22',10,0,0,NULL,0),(919,8,'2026-12-23',10,0,0,NULL,0),(920,8,'2026-12-24',10,0,0,NULL,0),(921,8,'2026-12-25',10,0,0,NULL,0),(922,8,'2026-12-26',10,0,0,NULL,0),(923,8,'2026-12-27',10,0,0,NULL,0),(924,8,'2026-12-28',10,0,0,NULL,0),(925,8,'2026-12-29',10,0,0,NULL,0),(926,8,'2026-12-30',10,0,0,NULL,0),(927,8,'2026-12-31',10,0,0,NULL,0),(928,8,'2027-01-01',10,0,0,NULL,0),(929,8,'2027-01-02',10,0,0,NULL,0),(930,8,'2027-01-03',10,0,0,NULL,0),(931,8,'2027-01-04',10,0,0,NULL,0),(932,8,'2027-01-05',10,0,0,NULL,0),(933,8,'2027-01-06',10,0,0,NULL,0),(934,8,'2027-01-07',10,0,0,NULL,0),(935,8,'2027-01-08',10,0,0,NULL,0),(936,8,'2027-01-09',10,0,0,NULL,0),(937,8,'2027-01-10',10,0,0,NULL,0),(938,8,'2027-01-11',10,0,0,NULL,0),(939,8,'2027-01-12',10,0,0,NULL,0),(940,8,'2027-01-13',10,0,0,NULL,0),(941,8,'2027-01-14',10,0,0,NULL,0),(942,8,'2027-01-15',10,0,0,NULL,0),(943,8,'2027-01-16',10,0,0,NULL,0),(944,8,'2027-01-17',10,0,0,NULL,0),(945,8,'2027-01-18',10,0,0,NULL,0),(946,8,'2027-01-19',10,0,0,NULL,0),(947,8,'2027-01-20',10,0,0,NULL,0),(948,8,'2027-01-21',10,0,0,NULL,0),(949,8,'2027-01-22',10,0,0,NULL,0),(950,8,'2027-01-23',10,0,0,NULL,0),(951,8,'2027-01-24',10,0,0,NULL,0),(952,8,'2027-01-25',10,0,0,NULL,0),(953,8,'2027-01-26',10,0,0,NULL,0),(954,8,'2027-01-27',10,0,0,NULL,0),(955,8,'2027-01-28',10,0,0,NULL,0),(956,8,'2027-01-29',10,0,0,NULL,0),(957,8,'2027-01-30',10,0,0,NULL,0),(958,8,'2027-01-31',10,0,0,NULL,0),(959,8,'2027-02-01',10,0,0,NULL,0),(960,8,'2027-02-02',10,0,0,NULL,0),(961,9,'2026-10-06',4,0,0,NULL,0),(962,9,'2026-10-07',4,0,0,NULL,0),(963,9,'2026-10-08',4,0,0,NULL,0),(964,9,'2026-10-09',4,0,0,NULL,0),(965,9,'2026-10-10',4,0,0,NULL,0),(966,9,'2026-10-11',4,0,0,NULL,0),(967,9,'2026-10-12',4,0,0,NULL,0),(968,9,'2026-10-13',4,0,0,NULL,0),(969,9,'2026-10-14',4,0,0,NULL,0),(970,9,'2026-10-15',4,0,0,NULL,0),(971,9,'2026-10-16',4,0,0,NULL,0),(972,9,'2026-10-17',4,0,0,NULL,0),(973,9,'2026-10-18',4,0,0,NULL,0),(974,9,'2026-10-19',4,0,0,NULL,0),(975,9,'2026-10-20',4,0,0,NULL,0),(976,9,'2026-10-21',4,0,0,NULL,0),(977,9,'2026-10-22',4,0,0,NULL,0),(978,9,'2026-10-23',4,0,0,NULL,0),(979,9,'2026-10-24',4,0,0,NULL,0),(980,9,'2026-10-25',4,0,0,NULL,0),(981,9,'2026-10-26',4,0,0,NULL,0),(982,9,'2026-10-27',4,0,0,NULL,0),(983,9,'2026-10-28',4,0,0,NULL,0),(984,9,'2026-10-29',4,0,0,NULL,0),(985,9,'2026-10-30',4,0,0,NULL,0),(986,9,'2026-10-31',4,0,0,NULL,0),(987,9,'2026-11-01',4,0,0,NULL,0),(988,9,'2026-11-02',4,0,0,NULL,0),(989,9,'2026-11-03',4,0,0,NULL,0),(990,9,'2026-11-04',4,0,0,NULL,0),(991,9,'2026-11-05',4,0,0,NULL,0),(992,9,'2026-11-06',4,0,0,NULL,0),(993,9,'2026-11-07',4,0,0,NULL,0),(994,9,'2026-11-08',4,0,0,NULL,0),(995,9,'2026-11-09',4,0,0,NULL,0),(996,9,'2026-11-10',4,0,0,NULL,0),(997,9,'2026-11-11',4,0,0,NULL,0),(998,9,'2026-11-12',4,0,0,NULL,0),(999,9,'2026-11-13',4,0,0,NULL,0),(1000,9,'2026-11-14',4,0,0,NULL,0),(1001,9,'2026-11-15',4,0,0,NULL,0),(1002,9,'2026-11-16',4,0,0,NULL,0),(1003,9,'2026-11-17',4,0,0,NULL,0),(1004,9,'2026-11-18',4,0,0,NULL,0),(1005,9,'2026-11-19',4,0,0,NULL,0),(1006,9,'2026-11-20',4,0,0,NULL,0),(1007,9,'2026-11-21',4,0,0,NULL,0),(1008,9,'2026-11-22',4,0,0,NULL,0),(1009,9,'2026-11-23',4,0,0,NULL,0),(1010,9,'2026-11-24',4,0,0,NULL,0),(1011,9,'2026-11-25',4,0,0,NULL,0),(1012,9,'2026-11-26',4,0,0,NULL,0),(1013,9,'2026-11-27',4,0,0,NULL,0),(1014,9,'2026-11-28',4,0,0,NULL,0),(1015,9,'2026-11-29',4,0,0,NULL,0),(1016,9,'2026-11-30',4,0,0,NULL,0),(1017,9,'2026-12-01',4,0,0,NULL,0),(1018,9,'2026-12-02',4,0,0,NULL,0),(1019,9,'2026-12-03',4,0,0,NULL,0),(1020,9,'2026-12-04',4,0,0,NULL,0),(1021,9,'2026-12-05',4,0,0,NULL,0),(1022,9,'2026-12-06',4,0,0,NULL,0),(1023,9,'2026-12-07',4,0,0,NULL,0),(1024,9,'2026-12-08',4,0,0,NULL,0),(1025,9,'2026-12-09',4,0,0,NULL,0),(1026,9,'2026-12-10',4,0,0,NULL,0),(1027,9,'2026-12-11',4,0,0,NULL,0),(1028,9,'2026-12-12',4,0,0,NULL,0),(1029,9,'2026-12-13',4,0,0,NULL,0),(1030,9,'2026-12-14',4,0,0,NULL,0),(1031,9,'2026-12-15',4,0,0,NULL,0),(1032,9,'2026-12-16',4,0,0,NULL,0),(1033,9,'2026-12-17',4,0,0,NULL,0),(1034,9,'2026-12-18',4,0,0,NULL,0),(1035,9,'2026-12-19',4,0,0,NULL,0),(1036,9,'2026-12-20',4,0,0,NULL,0),(1037,9,'2026-12-21',4,0,0,NULL,0),(1038,9,'2026-12-22',4,0,0,NULL,0),(1039,9,'2026-12-23',4,0,0,NULL,0),(1040,9,'2026-12-24',4,0,0,NULL,0),(1041,9,'2026-12-25',4,0,0,NULL,0),(1042,9,'2026-12-26',4,0,0,NULL,0),(1043,9,'2026-12-27',4,0,0,NULL,0),(1044,9,'2026-12-28',4,0,0,NULL,0),(1045,9,'2026-12-29',4,0,0,NULL,0),(1046,9,'2026-12-30',4,0,0,NULL,0),(1047,9,'2026-12-31',4,0,0,NULL,0),(1048,9,'2027-01-01',4,0,0,NULL,0),(1049,9,'2027-01-02',4,0,0,NULL,0),(1050,9,'2027-01-03',4,0,0,NULL,0),(1051,9,'2027-01-04',4,0,0,NULL,0),(1052,9,'2027-01-05',4,0,0,NULL,0),(1053,9,'2027-01-06',4,0,0,NULL,0),(1054,9,'2027-01-07',4,0,0,NULL,0),(1055,9,'2027-01-08',4,0,0,NULL,0),(1056,9,'2027-01-09',4,0,0,NULL,0),(1057,9,'2027-01-10',4,0,0,NULL,0),(1058,9,'2027-01-11',4,0,0,NULL,0),(1059,9,'2027-01-12',4,0,0,NULL,0),(1060,9,'2027-01-13',4,0,0,NULL,0),(1061,9,'2027-01-14',4,0,0,NULL,0),(1062,9,'2027-01-15',4,0,0,NULL,0),(1063,9,'2027-01-16',4,0,0,NULL,0),(1064,9,'2027-01-17',4,0,0,NULL,0),(1065,9,'2027-01-18',4,0,0,NULL,0),(1066,9,'2027-01-19',4,0,0,NULL,0),(1067,9,'2027-01-20',4,0,0,NULL,0),(1068,9,'2027-01-21',4,0,0,NULL,0),(1069,9,'2027-01-22',4,0,0,NULL,0),(1070,9,'2027-01-23',4,0,0,NULL,0),(1071,9,'2027-01-24',4,0,0,NULL,0),(1072,9,'2027-01-25',4,0,0,NULL,0),(1073,9,'2027-01-26',4,0,0,NULL,0),(1074,9,'2027-01-27',4,0,0,NULL,0),(1075,9,'2027-01-28',4,0,0,NULL,0),(1076,9,'2027-01-29',4,0,0,NULL,0),(1077,9,'2027-01-30',4,0,0,NULL,0),(1078,9,'2027-01-31',4,0,0,NULL,0),(1079,9,'2027-02-01',4,0,0,NULL,0),(1080,9,'2027-02-02',4,0,0,NULL,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RoomType`
--

LOCK TABLES `RoomType` WRITE;
/*!40000 ALTER TABLE `RoomType` DISABLE KEYS */;
INSERT INTO `RoomType` VALUES (1,1,'Phòng tiêu chuẩn',28,'1 giường đôi',2,6,1,0,850000,'Gọn gàng, ban công nhỏ nhìn ra vườn.'),(2,1,'Phòng Deluxe',28,'1 giường lớn',2,4,1,0,1250000,'Rộng rãi, cửa kính lớn view đồi thông.'),(3,1,'Phòng Family',28,'2 giường đôi',4,2,1,0,1800000,'Phù hợp gia đình 4 người.'),(4,2,'Phòng hướng biển',28,'1 giường lớn',2,5,1,0,1600000,'Ban công nhìn thẳng ra biển.'),(5,2,'Suite gia đình',28,'2 giường lớn',4,3,1,0,2600000,'Không gian rộng, bếp mini.'),(6,3,'Phòng vườn',28,'1 giường đôi',2,6,1,0,1100000,'Yên tĩnh, nhìn ra vườn.'),(7,3,'Phòng view sông',28,'1 giường lớn',2,3,1,0,1600000,'Ban công nhìn ra sông Hoài.'),(8,4,'Giường tầng (Dorm)',28,'Giường tầng',1,10,1,0,350000,'Tiết kiệm cho khách đi phượt.'),(9,4,'Cabin gỗ',28,'1 giường đôi',2,4,1,0,1200000,'Riêng tư, lò sưởi ấm áp.');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tour`
--

LOCK TABLES `Tour` WRITE;
/*!40000 ALTER TABLE `Tour` DISABLE KEYS */;
INSERT INTO `Tour` VALUES (1,'TR001','Săn mây Tà Xùa 3N2Đ','san-may-ta-xua-3n2d','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.','Chinh phục sống lưng khủng long, săn biển mây tuyệt đẹp.',NULL,NULL,NULL,3,2,'Hà Nội','Tà Xùa, Sơn La',NULL,1,25,NULL,2500000,30,1,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.930','2026-10-05 04:43:05.930'),(2,'TR002','Khám phá Hà Giang 4N3Đ','kham-pha-ha-giang-4n3d','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.','Cao nguyên đá Đồng Văn, đèo Mã Pí Lèng, sông Nho Quế.',NULL,NULL,NULL,4,3,'Hà Nội','Hà Giang',NULL,1,25,NULL,3900000,30,1,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.947','2026-10-05 04:43:05.947'),(3,'TR003','Lý Sơn – Đảo tiên 2N1Đ','ly-son-dao-tien-2n1d','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.','Đảo núi lửa, bãi biển trong xanh, hải sản tươi ngon.',NULL,NULL,NULL,2,1,'Đà Nẵng','Lý Sơn, Quảng Ngãi',NULL,1,25,NULL,1800000,30,1,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.961','2026-10-05 04:43:05.961'),(4,'TR004','Kỳ Co – Eo Gió 1 ngày','ky-co-eo-gio-1-ngay','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.','Biển Kỳ Co ngọc bích, cano vượt sóng, lặn ngắm san hô.',NULL,NULL,NULL,1,0,'Quy Nhơn','Quy Nhơn, Bình Định',NULL,1,25,NULL,650000,30,1,4.7,20,'VISIBLE','https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1000&q=70',1,NULL,NULL,NULL,'2026-10-05 04:43:05.978','2026-10-05 04:43:05.978');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourDeparture`
--

LOCK TABLES `TourDeparture` WRITE;
/*!40000 ALTER TABLE `TourDeparture` DISABLE KEYS */;
INSERT INTO `TourDeparture` VALUES (1,1,'2026-10-15','2026-10-17',20,0,0,'OPEN',NULL),(2,1,'2026-10-29','2026-10-31',20,0,0,'OPEN',NULL),(3,1,'2026-11-14','2026-11-16',20,0,0,'OPEN',NULL),(4,2,'2026-10-15','2026-10-18',20,0,0,'OPEN',NULL),(5,2,'2026-10-29','2026-11-01',20,0,0,'OPEN',NULL),(6,2,'2026-11-14','2026-11-17',20,0,0,'OPEN',NULL),(7,3,'2026-10-15','2026-10-16',20,0,0,'OPEN',NULL),(8,3,'2026-10-29','2026-10-30',20,0,0,'OPEN',NULL),(9,3,'2026-11-14','2026-11-15',20,0,0,'OPEN',NULL),(10,4,'2026-10-15','2026-10-15',20,0,0,'OPEN',NULL),(11,4,'2026-10-29','2026-10-29',20,0,0,'OPEN',NULL),(12,4,'2026-11-14','2026-11-14',20,0,0,'OPEN',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TourPrice`
--

LOCK TABLES `TourPrice` WRITE;
/*!40000 ALTER TABLE `TourPrice` DISABLE KEYS */;
INSERT INTO `TourPrice` VALUES (1,1,'ADULT',2500000,'Người lớn',0),(2,1,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(3,2,'ADULT',2500000,'Người lớn',0),(4,2,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(5,3,'ADULT',2500000,'Người lớn',0),(6,3,'CHILD',1750000,'Trẻ em 5–11 tuổi',0),(7,4,'ADULT',3900000,'Người lớn',0),(8,4,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(9,5,'ADULT',3900000,'Người lớn',0),(10,5,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(11,6,'ADULT',3900000,'Người lớn',0),(12,6,'CHILD',2730000,'Trẻ em 5–11 tuổi',0),(13,7,'ADULT',1800000,'Người lớn',0),(14,7,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(15,8,'ADULT',1800000,'Người lớn',0),(16,8,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(17,9,'ADULT',1800000,'Người lớn',0),(18,9,'CHILD',1260000,'Trẻ em 5–11 tuổi',0),(19,10,'ADULT',650000,'Người lớn',0),(20,10,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(21,11,'ADULT',650000,'Người lớn',0),(22,11,'CHILD',455000,'Trẻ em 5–11 tuổi',0),(23,12,'ADULT',650000,'Người lớn',0),(24,12,'CHILD',455000,'Trẻ em 5–11 tuổi',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TravelGuide`
--

LOCK TABLES `TravelGuide` WRITE;
/*!40000 ALTER TABLE `TravelGuide` DISABLE KEYS */;
INSERT INTO `TravelGuide` VALUES (1,'Kinh nghiệm du lịch Đà Lạt 3 ngày 2 đêm','kinh-nghiem-du-lich-da-lat-3n2d','Ban biên tập StayTour','https://images.unsplash.com/photo-1589820296156-2454bb8a6ad1?auto=format&fit=crop&w=1000&q=70','Gợi ý lịch trình Đà Lạt tiết kiệm cho nhóm bạn.','Ngày 1: khám phá trung tâm, chợ đêm Đà Lạt.\nNgày 2: đồi chè Cầu Đất, săn mây.\nNgày 3: vườn hoa, mua đặc sản về làm quà.','Đà Lạt, Lâm Đồng',NULL,NULL,'2026-10-05 04:43:06.002','VISIBLE',NULL,'2026-10-05 04:43:06.003','2026-10-05 04:43:06.003');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
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

-- Dump completed on 2026-10-05  4:44:13
