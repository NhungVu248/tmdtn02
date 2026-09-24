-- DropForeignKey
ALTER TABLE `booking` DROP FOREIGN KEY `Booking_productId_fkey`;

-- DropForeignKey
ALTER TABLE `tourdeparture` DROP FOREIGN KEY `TourDeparture_productId_fkey`;

-- DropIndex
DROP INDEX `TourDeparture_productId_idx` ON `tourdeparture`;

-- AlterTable
ALTER TABLE `booking` ADD COLUMN `tourDepartureId` INTEGER NULL,
    ADD COLUMN `tourId` INTEGER NULL,
    MODIFY `productId` INTEGER NULL;

-- AlterTable
ALTER TABLE `category` ADD COLUMN `kind` VARCHAR(191) NULL;

-- AlterTable
ALTER TABLE `discountcode` ADD COLUMN `tourId` INTEGER NULL;

-- AlterTable
ALTER TABLE `favorite` ADD COLUMN `tourId` INTEGER NULL,
    MODIFY `productId` INTEGER NULL;

-- AlterTable
ALTER TABLE `product` ADD COLUMN `cancellationPolicyId` INTEGER NULL;

-- AlterTable
ALTER TABLE `review` ADD COLUMN `productType` ENUM('HOMESTAY', 'TOUR') NOT NULL DEFAULT 'HOMESTAY',
    ADD COLUMN `tourId` INTEGER NULL,
    MODIFY `productId` INTEGER NULL;

-- AlterTable
ALTER TABLE `tourdeparture` DROP COLUMN `bookedSeats`,
    DROP COLUMN `closed`,
    DROP COLUMN `date`,
    DROP COLUMN `priceAdultOverride`,
    DROP COLUMN `priceChildOverride`,
    DROP COLUMN `productId`,
    DROP COLUMN `totalSeats`,
    ADD COLUMN `bookedSlots` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `departureDate` DATE NOT NULL,
    ADD COLUMN `guideName` VARCHAR(191) NULL,
    ADD COLUMN `heldSlots` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `returnDate` DATE NULL,
    ADD COLUMN `status` ENUM('OPEN', 'CLOSED', 'FULL', 'CANCELLED') NOT NULL DEFAULT 'OPEN',
    ADD COLUMN `totalSlots` INTEGER NOT NULL,
    ADD COLUMN `tourId` INTEGER NOT NULL;

-- CreateTable
CREATE TABLE `CancellationPolicy` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `isRefundable` BOOLEAN NOT NULL DEFAULT true,
    `freeHours` INTEGER NOT NULL DEFAULT 24,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PolicyMilestone` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `policyId` INTEGER NOT NULL,
    `daysBefore` INTEGER NOT NULL,
    `refundRate` INTEGER NOT NULL,

    INDEX `PolicyMilestone_policyId_idx`(`policyId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Tour` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tourCode` VARCHAR(191) NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `slug` VARCHAR(191) NOT NULL,
    `shortDescription` VARCHAR(191) NULL,
    `description` TEXT NULL,
    `highlights` TEXT NULL,
    `regionId` INTEGER NULL,
    `themeId` INTEGER NULL,
    `durationDays` INTEGER NOT NULL DEFAULT 1,
    `durationNights` INTEGER NOT NULL DEFAULT 0,
    `departurePoint` VARCHAR(191) NULL,
    `destination` VARCHAR(191) NULL,
    `meetingPoint` TEXT NULL,
    `minPax` INTEGER NOT NULL DEFAULT 1,
    `maxPax` INTEGER NOT NULL DEFAULT 30,
    `guideLanguage` VARCHAR(191) NULL,
    `basePrice` INTEGER NOT NULL,
    `depositRate` INTEGER NULL,
    `cancellationPolicyId` INTEGER NULL,
    `avgRating` DOUBLE NOT NULL DEFAULT 0,
    `reviewCount` INTEGER NOT NULL DEFAULT 0,
    `status` ENUM('DRAFT', 'VISIBLE', 'HIDDEN') NOT NULL DEFAULT 'DRAFT',
    `thumbnail` VARCHAR(191) NULL,
    `isFeatured` BOOLEAN NOT NULL DEFAULT false,
    `metaTitle` VARCHAR(191) NULL,
    `metaDescription` VARCHAR(191) NULL,
    `createdById` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Tour_tourCode_key`(`tourCode`),
    UNIQUE INDEX `Tour_slug_key`(`slug`),
    INDEX `Tour_status_idx`(`status`),
    INDEX `Tour_regionId_idx`(`regionId`),
    INDEX `Tour_themeId_idx`(`themeId`),
    INDEX `Tour_isFeatured_idx`(`isFeatured`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TourImage` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tourId` INTEGER NOT NULL,
    `url` VARCHAR(191) NOT NULL,
    `caption` VARCHAR(191) NULL,
    `isCover` BOOLEAN NOT NULL DEFAULT false,
    `sortOrder` INTEGER NOT NULL DEFAULT 0,

    INDEX `TourImage_tourId_idx`(`tourId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TourPrice` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `departureId` INTEGER NOT NULL,
    `paxType` ENUM('ADULT', 'CHILD', 'INFANT') NOT NULL,
    `price` INTEGER NOT NULL,
    `description` VARCHAR(191) NULL,
    `requiresProof` BOOLEAN NOT NULL DEFAULT false,

    INDEX `TourPrice_departureId_idx`(`departureId`),
    UNIQUE INDEX `TourPrice_departureId_paxType_key`(`departureId`, `paxType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TourItinerary` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tourId` INTEGER NOT NULL,
    `dayNumber` INTEGER NOT NULL,
    `title` VARCHAR(191) NULL,
    `description` TEXT NULL,
    `meals` VARCHAR(191) NULL,
    `accommodation` VARCHAR(191) NULL,

    INDEX `TourItinerary_tourId_idx`(`tourId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TourInclusion` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tourId` INTEGER NOT NULL,
    `type` ENUM('INCLUDED', 'EXCLUDED') NOT NULL,
    `itemText` VARCHAR(191) NOT NULL,
    `sortOrder` INTEGER NOT NULL DEFAULT 0,

    INDEX `TourInclusion_tourId_idx`(`tourId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TourNote` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tourId` INTEGER NOT NULL,
    `type` ENUM('TERM', 'FAQ', 'REDEMPTION') NOT NULL,
    `title` VARCHAR(191) NULL,
    `content` TEXT NOT NULL,
    `sortOrder` INTEGER NOT NULL DEFAULT 0,

    INDEX `TourNote_tourId_idx`(`tourId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE INDEX `Booking_tourId_idx` ON `Booking`(`tourId`);

-- CreateIndex
CREATE UNIQUE INDEX `Favorite_userId_tourId_key` ON `Favorite`(`userId`, `tourId`);

-- CreateIndex
CREATE INDEX `Review_tourId_idx` ON `Review`(`tourId`);

-- CreateIndex
CREATE INDEX `TourDeparture_tourId_idx` ON `TourDeparture`(`tourId`);

-- AddForeignKey
ALTER TABLE `Booking` ADD CONSTRAINT `Booking_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Booking` ADD CONSTRAINT `Booking_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `DiscountCode` ADD CONSTRAINT `DiscountCode_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Favorite` ADD CONSTRAINT `Favorite_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Product` ADD CONSTRAINT `Product_cancellationPolicyId_fkey` FOREIGN KEY (`cancellationPolicyId`) REFERENCES `CancellationPolicy`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Review` ADD CONSTRAINT `Review_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PolicyMilestone` ADD CONSTRAINT `PolicyMilestone_policyId_fkey` FOREIGN KEY (`policyId`) REFERENCES `CancellationPolicy`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Tour` ADD CONSTRAINT `Tour_regionId_fkey` FOREIGN KEY (`regionId`) REFERENCES `Category`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Tour` ADD CONSTRAINT `Tour_themeId_fkey` FOREIGN KEY (`themeId`) REFERENCES `Category`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Tour` ADD CONSTRAINT `Tour_cancellationPolicyId_fkey` FOREIGN KEY (`cancellationPolicyId`) REFERENCES `CancellationPolicy`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Tour` ADD CONSTRAINT `Tour_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `Admin`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TourImage` ADD CONSTRAINT `TourImage_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TourDeparture` ADD CONSTRAINT `TourDeparture_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TourPrice` ADD CONSTRAINT `TourPrice_departureId_fkey` FOREIGN KEY (`departureId`) REFERENCES `TourDeparture`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TourItinerary` ADD CONSTRAINT `TourItinerary_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TourInclusion` ADD CONSTRAINT `TourInclusion_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TourNote` ADD CONSTRAINT `TourNote_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

