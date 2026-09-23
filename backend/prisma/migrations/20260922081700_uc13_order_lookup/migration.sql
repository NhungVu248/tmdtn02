-- AlterTable
ALTER TABLE `booking` ADD COLUMN `lookupFailCount` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `lookupLockedUntil` DATETIME(3) NULL;

-- CreateTable
CREATE TABLE `LookupAttempt` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `ip` VARCHAR(191) NULL,
    `success` BOOLEAN NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `LookupAttempt_code_idx`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
