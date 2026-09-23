-- CreateTable
CREATE TABLE `SystemConfig` (
    `id` INTEGER NOT NULL DEFAULT 1,
    `depositRatePercent` INTEGER NOT NULL DEFAULT 30,
    `cancelFreeHours` INTEGER NOT NULL DEFAULT 24,
    `cancelTier1Days` INTEGER NOT NULL DEFAULT 7,
    `cancelTier1Ratio` INTEGER NOT NULL DEFAULT 100,
    `cancelTier2Days` INTEGER NOT NULL DEFAULT 3,
    `cancelTier2Ratio` INTEGER NOT NULL DEFAULT 50,
    `sellerName` VARCHAR(191) NULL DEFAULT 'StayTour',
    `sellerAddress` VARCHAR(191) NULL,
    `sellerPhone` VARCHAR(191) NULL,
    `sellerEmail` VARCHAR(191) NULL,
    `siteNotice` TEXT NULL,
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
