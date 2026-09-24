-- Bổ sung các bảng còn thiếu trong lịch sử migration (trước đây tạo bằng `db push`).
-- Dùng IF NOT EXISTS + FK khai báo NGAY TRONG CREATE TABLE để:
--   • Trên DB đã có bảng (db push): bỏ qua toàn bộ CREATE -> không trùng tên FK.
--   • Trên shadow database (dựng từ đầu): tạo đầy đủ bảng + FK để migrate chạy sạch.

-- CreateTable: ảnh đính kèm đánh giá (UC-15)
CREATE TABLE IF NOT EXISTS `ReviewImage` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `reviewId` INTEGER NOT NULL,
    `url` VARCHAR(191) NOT NULL,
    `sortOrder` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `ReviewImage_reviewId_idx`(`reviewId`),
    PRIMARY KEY (`id`),
    CONSTRAINT `ReviewImage_reviewId_fkey` FOREIGN KEY (`reviewId`) REFERENCES `Review`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable: cẩm nang du lịch (blog)
CREATE TABLE IF NOT EXISTS `TravelGuide` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(191) NOT NULL,
    `slug` VARCHAR(191) NOT NULL,
    `authorName` VARCHAR(191) NULL,
    `coverImage` VARCHAR(191) NULL,
    `excerpt` TEXT NULL,
    `content` TEXT NOT NULL,
    `locationName` VARCHAR(191) NULL,
    `latitude` DOUBLE NULL,
    `longitude` DOUBLE NULL,
    `publishedAt` DATETIME(3) NULL,
    `status` ENUM('DRAFT', 'VISIBLE', 'HIDDEN') NOT NULL DEFAULT 'DRAFT',
    `createdById` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `TravelGuide_slug_key`(`slug`),
    INDEX `TravelGuide_status_idx`(`status`),
    INDEX `TravelGuide_publishedAt_idx`(`publishedAt`),
    PRIMARY KEY (`id`),
    CONSTRAINT `TravelGuide_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `Admin`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable: bảng nối cẩm nang <-> tour liên quan
CREATE TABLE IF NOT EXISTS `TravelGuideTour` (
    `guideId` INTEGER NOT NULL,
    `tourId` INTEGER NOT NULL,

    INDEX `TravelGuideTour_tourId_idx`(`tourId`),
    PRIMARY KEY (`guideId`, `tourId`),
    CONSTRAINT `TravelGuideTour_guideId_fkey` FOREIGN KEY (`guideId`) REFERENCES `TravelGuide`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `TravelGuideTour_tourId_fkey` FOREIGN KEY (`tourId`) REFERENCES `Tour`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AlterTable: chuẩn hoá cột travelguide theo schema hiện hành
ALTER TABLE `travelguide` MODIFY `content` TEXT NOT NULL,
    MODIFY `authorName` VARCHAR(191) NULL,
    MODIFY `publishedAt` DATETIME(3) NULL,
    MODIFY `status` ENUM('DRAFT', 'VISIBLE', 'HIDDEN') NOT NULL DEFAULT 'DRAFT';
