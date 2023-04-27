ALTER TABLE `owned_vehicles`
ADD COLUMN `registered` VARCHAR(255) NOT NULL DEFAULT 'not' COLLATE 'utf8mb4_general_ci',
ADD COLUMN `date_expiried` DATE DEFAULT NULL;