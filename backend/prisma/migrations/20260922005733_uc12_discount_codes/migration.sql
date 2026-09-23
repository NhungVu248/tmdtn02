-- AlterTable
ALTER TABLE `booking` ADD COLUMN `discountAmount` INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN `discountCode` VARCHAR(191) NULL,
    ADD COLUMN `discountConsumed` BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE `DiscountCode` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `type` VARCHAR(191) NOT NULL,
    `value` INTEGER NOT NULL,
    `minOrderValue` INTEGER NOT NULL DEFAULT 0,
    `scope` VARCHAR(191) NOT NULL DEFAULT 'ALL',
    `productId` INTEGER NULL,
    `audience` VARCHAR(191) NOT NULL DEFAULT 'ALL',
    `startAt` DATETIME(3) NULL,
    `endAt` DATETIME(3) NULL,
    `maxUses` INTEGER NULL,
    `usedCount` INTEGER NOT NULL DEFAULT 0,
    `active` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `DiscountCode_code_key`(`code`),
    INDEX `DiscountCode_productId_idx`(`productId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `DiscountCode` ADD CONSTRAINT `DiscountCode_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
