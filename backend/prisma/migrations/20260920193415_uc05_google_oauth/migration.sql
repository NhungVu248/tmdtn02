-- Cho phép password NULL (tài khoản Google không có mật khẩu)
ALTER TABLE `User` MODIFY `password` VARCHAR(191) NULL;

-- Thêm avatar và googleId
ALTER TABLE `User` ADD COLUMN `avatar` VARCHAR(191) NULL,
    ADD COLUMN `googleId` VARCHAR(191) NULL;

-- Ràng buộc duy nhất cho googleId
CREATE UNIQUE INDEX `User_googleId_key` ON `User`(`googleId`);
