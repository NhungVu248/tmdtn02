-- AlterTable: bổ sung trường hồ sơ phục vụ vận hành đặt phòng/tour (tham khảo Traveloka/Booking)
ALTER TABLE `user` ADD COLUMN `dateOfBirth` DATETIME(3) NULL,
    ADD COLUMN `gender` VARCHAR(191) NULL,
    ADD COLUMN `nationality` VARCHAR(191) NULL,
    ADD COLUMN `idNumber` VARCHAR(191) NULL,
    ADD COLUMN `city` VARCHAR(191) NULL;
