-- AlterTable
ALTER TABLE `product` ADD COLUMN `excluded` TEXT NULL,
    ADD COLUMN `included` TEXT NULL;

-- AlterTable
ALTER TABLE `tourdeparture` ADD COLUMN `closed` BOOLEAN NOT NULL DEFAULT false,
    ADD COLUMN `priceAdultOverride` INTEGER NULL,
    ADD COLUMN `priceChildOverride` INTEGER NULL;
