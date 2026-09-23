-- Thêm bookingId vào Review (gắn đánh giá với đơn đã hoàn tất)
ALTER TABLE `Review` ADD COLUMN `bookingId` INTEGER NULL;
CREATE UNIQUE INDEX `Review_bookingId_key` ON `Review`(`bookingId`);
ALTER TABLE `Review` ADD CONSTRAINT `Review_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- Token đánh giá dùng một lần cho Guest
CREATE TABLE `ReviewToken` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `bookingId` INTEGER NOT NULL,
    `tokenHash` VARCHAR(191) NOT NULL,
    `expiresAt` DATETIME(3) NOT NULL,
    `usedAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `ReviewToken_bookingId_key`(`bookingId`),
    UNIQUE INDEX `ReviewToken_tokenHash_key`(`tokenHash`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `ReviewToken` ADD CONSTRAINT `ReviewToken_bookingId_fkey` FOREIGN KEY (`bookingId`) REFERENCES `Booking`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
