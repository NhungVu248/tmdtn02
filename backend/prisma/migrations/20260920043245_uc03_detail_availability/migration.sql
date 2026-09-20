-- AlterTable
ALTER TABLE `product` ADD COLUMN `cancellationPolicy` TEXT NULL,
    ADD COLUMN `itinerary` TEXT NULL,
    ADD COLUMN `priceChild` INTEGER NULL;

-- CreateTable
CREATE TABLE `ProductImage` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `productId` INTEGER NOT NULL,
    `url` VARCHAR(191) NOT NULL,
    `order` INTEGER NOT NULL DEFAULT 0,

    INDEX `ProductImage_productId_idx`(`productId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Review` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `productId` INTEGER NOT NULL,
    `authorName` VARCHAR(191) NOT NULL,
    `rating` INTEGER NOT NULL,
    `comment` TEXT NULL,
    `approved` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `Review_productId_idx`(`productId`),
    INDEX `Review_approved_idx`(`approved`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `HomestayAvailability` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `productId` INTEGER NOT NULL,
    `date` DATE NOT NULL,
    `totalRooms` INTEGER NOT NULL,
    `bookedRooms` INTEGER NOT NULL DEFAULT 0,

    INDEX `HomestayAvailability_productId_idx`(`productId`),
    UNIQUE INDEX `HomestayAvailability_productId_date_key`(`productId`, `date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `TourDeparture` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `productId` INTEGER NOT NULL,
    `date` DATE NOT NULL,
    `totalSeats` INTEGER NOT NULL,
    `bookedSeats` INTEGER NOT NULL DEFAULT 0,

    INDEX `TourDeparture_productId_idx`(`productId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `ProductImage` ADD CONSTRAINT `ProductImage_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Review` ADD CONSTRAINT `Review_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `HomestayAvailability` ADD CONSTRAINT `HomestayAvailability_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `TourDeparture` ADD CONSTRAINT `TourDeparture_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
