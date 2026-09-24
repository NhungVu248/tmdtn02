-- AlterTable
ALTER TABLE `travelguide` MODIFY `content` TEXT NOT NULL,
    MODIFY `authorName` VARCHAR(191) NULL,
    MODIFY `publishedAt` DATETIME(3) NULL,
    MODIFY `status` ENUM('DRAFT', 'VISIBLE', 'HIDDEN') NOT NULL DEFAULT 'DRAFT';

