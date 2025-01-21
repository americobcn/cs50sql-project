-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
-- docker container run --name mysql -p 3306:3306 -v /workspaces/$RepositoryName:/mnt -e MYSQL_ROOT_PASSWORD=crimson -d mysql
-- mysql -h 127.0.0.1 -P 3306 -u root -p < ./schema.sql

DROP DATABASE IF EXISTS `projects`;

CREATE DATABASE `projects`;

USE `projects`;

CREATE TABLE `clients` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL UNIQUE,
    `phone` VARCHAR(64) NOT NULL UNIQUE,
    `address` VARCHAR(64) NOT NULL UNIQUE,
    `company_type` ENUM('production', 'agency', 'platform', 'publisher','other') DEFAULT 'other',
    PRIMARY KEY(`id`)
);


CREATE TABLE `contacts` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(64) NOT NULL,
    `last_name` VARCHAR(64) NOT NULL,
    `full_name` VARCHAR(128) AS (CONCAT(first_name, ' ', last_name)),
    `phone` VARCHAR(64) NOT NULL UNIQUE,
    `email` VARCHAR(48) NOT NULL UNIQUE,
    `client_id` INT ,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`client_id`) REFERENCES clients(`id`)
);


CREATE TABLE `departments` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    PRIMARY KEY(`id`)
);


CREATE TABLE `employees` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(64) NOT NULL,
    `last_name` VARCHAR(64) NOT NULL,
    `full_name` VARCHAR(128) AS (CONCAT(first_name, ' ', last_name)),
    `gender` ENUM ('M','F', 'O')  NOT NULL,
    `hire_date` DATE NOT NULL,
    `salary` DECIMAL(10,2),
    `rate_hour` DECIMAL(10,2) AS (`salary` / 160),
    `department_id` INT ,
    `is_deleted` BOOLEAN DEFAULT 0,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`department_id`) REFERENCES`departments`(`id`)
);


CREATE TABLE `projects` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(64) NOT NULL UNIQUE,
    `description` TEXT,
    `date_created` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `deadline` DATETIME NOT NULL,
    `budget` DECIMAL(7,2) NOT NULL CHECK(`budget` > 0),
    `client_id` INT ,
    `contact_id` INT ,
    `is_active` BOOLEAN DEFAULT 1,
    `is_deleted` BOOLEAN DEFAULT 0,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`client_id`) REFERENCES `clients`(`id`),
    FOREIGN KEY(`contact_id`) REFERENCES `contacts`(`id`)
);


CREATE TABLE `services` (
    `service` VARCHAR(64) UNIQUE NOT NULL,
    `price` DECIMAL(5,2) NOT NULL DEFAULT 0,
    PRIMARY KEY (`name`)
);


CREATE TABLE `tasks` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `project_id` INT ,
    `employee_id` INT ,
    `service_id` VARCHAR(64),
    `comment` TEXT,
    `start_time` TIMESTAMP NOT NULL,
    `end_time` TIMESTAMP NOT NULL,
    `spended_time` DECIMAL(6,2) AS (TIMESTAMPDIFF(HOUR, start_time, end_time)),
    `is_deleted` BOOLEAN DEFAULT 0,
    FOREIGN KEY(`project_id`) REFERENCES `projects`(`id`),
    FOREIGN KEY(`employee_id`) REFERENCES `employees`(`id`),
    FOREIGN KEY(`service_id`) REFERENCES `services`(`name`),
    PRIMARY KEY(`id`)
);


/* Stored Procedures */

-- Set project as deleted and related tasks too.

delimiter //
CREATE PROCEDURE get_project_services_consumed_id (p_id INT)
BEGIN
    SELECT  projects.name, budget, SUM(services.price * `spended_time`) AS 'services_consumed'
    FROM `projects`
    JOIN `tasks` ON projects.id = `project_id`
    JOIN `services` ON services.service = tasks.service_id
    WHERE projects.id = p_id
    GROUP BY projects.name;
END//
delimiter ;


delimiter //
CREATE PROCEDURE get_project_services_consumed_by_name (p_name VARCHAR(64))
BEGIN
    SELECT  projects.name, budget, SUM(services.price * `spended_time`) AS 'services_consumed'
    FROM `projects`
    JOIN `tasks` ON projects.id = `project_id`
    JOIN `services` ON services.service = tasks.service_id
    WHERE projects.name = p_name
    GROUP BY projects.name;
END//
delimiter ;



/* Triggers */

-- When a project is soft deleted, the 'is_deleted' column is updated, then the tasks associated with the project
-- are updated according to the value updated in the project's 'is_deleted' column.
delimiter //
CREATE TRIGGER delete_tasks AFTER UPDATE ON `projects`
FOR EACH ROW
    BEGIN
        IF NEW.is_deleted != OLD.is_deleted THEN
            UPDATE `tasks` SET `is_deleted` = NEW.is_deleted WHERE `project_id` = OLD.id;
        END IF;
    END//
delimiter ;


/* Indexes */

CREATE INDEX company_type_index ON `clients` (`company_type`);
CREATE INDEX is_deleted_project_index ON `projects`(`is_deleted`);
CREATE INDEX is_deleted_task_index ON `tasks`(`is_deleted`);

