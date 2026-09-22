-- CreateTable
CREATE TABLE `Booking` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `pinHash` VARCHAR(191) NULL,
    `type` ENUM('HOMESTAY', 'TOUR') NOT NULL,
    `status` ENUM('PENDING_DEPOSIT', 'DEPOSITED', 'CONFIRMED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING_DEPOSIT',
    `productId` INTEGER NOT NULL,
    `userId` INTEGER NULL,
    `guestName` VARCHAR(191) NOT NULL,
    `guestEmail` VARCHAR(191) NOT NULL,
    `guestPhone` VARCHAR(191) NOT NULL,
    `checkIn` DATE NULL,
    `checkOut` DATE NULL,
    `nights` INTEGER NULL,
    `guests` INTEGER NOT NULL DEFAULT 1,
    `children` INTEGER NOT NULL DEFAULT 0,
    `totalPrice` INTEGER NOT NULL,
    `depositAmount` INTEGER NOT NULL,
    `remainingAmount` INTEGER NOT NULL,
    `heldUntil` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Booking_code_key`(`code`),
    INDEX `Booking_productId_idx`(`productId`),
    INDEX `Booking_userId_idx`(`userId`),
    INDEX `Booking_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Booking` ADD CONSTRAINT `Booking_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `Product`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Booking` ADD CONSTRAINT `Booking_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
