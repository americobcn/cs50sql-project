-- Insert Services Data
INSERT INTO `services` (`name`, `price`)
VALUES  ('audio', 150),
        ('video', 210),
        ('vfx', 250),
        ('3d', 220),
        ('production', 110),
        ('design', 175),
        ('deliveries', 120);


-- Load Departments data
INSERT INTO `departments` (`name`)
VALUES ('audio'), ('video'), ('3d'), ('vfx'), ('production'), ('legal'), ('administration');


-- Insert Clients Data
INSERT INTO `clients` (`name`, `phone`, `address`, `company_type`)
VALUES  ('New Digital', '+34 934525858', 'Passeig de Gràcia, 25, 4rt 2a, Barcelona', 'agency'),
        ('La Hermida', '+34 935289863', 'Carrer de Mallorca, 127, 1er 2na, Barcelona', 'production'),
        ('Summer Digit', '+34 932456858', 'Avinguda Paral.lel, 19, baixos, Barcelona', 'publisher'),
        ('Normmal', '+34 939877852', 'Carrer Puigmarti, 89, 4rt 3a, Barcelona', 'agency'),
        ('Amazon Prime Video', '+34 932345112', 'Passeig Maragall, 77, 3er 1a, Barcelona', 'platform'),
        ('Elena Housting', '+34 933562441', 'Carrer de Vallfogona, 125, 4rt 2a, Barcelona', 'other'),
        ('Hidrogen SL', '+34 935684125', 'Avinguda Josep Torres, 47, 1e 3a, Barcelona', 'production');


-- Insert Contacts Data
INSERT INTO `contacts` (`first_name`, `last_name`, `phone`, `email`, `client_id`)
VALUES  ('Jhon', 'Doe', '+34 659969632', 'jhon@doe.com', (SELECT `id` FROM `clients` WHERE `name` = 'New Digital')),
        ('Jane', 'Doe', '+34 658569985', 'jane@doe.com', (SELECT `id` FROM `clients` WHERE `name` = 'Normmal')),
        ('Mary', 'Das', '+34 665885412', 'mary@das.com', (SELECT `id` FROM `clients` WHERE `name` = 'New Digital')),
        ('Carl', 'Crack', '+34 632566654', 'carl@crack.com', (SELECT `id` FROM `clients` WHERE `name` = 'Summer Digit')),
        ('Moni', 'Cim', '+34 689754556', 'moni@cim.com', (SELECT `id` FROM `clients` WHERE `name` = 'Hidrogen SL'));


-- Load Employees data
INSERT INTO `employees`(`first_name`, `last_name`, `gender`, `hire_date`, `salary`, `department_id`)
VALUES  ('Jennifer', 'Alston', 'F', '2006-05-17' , 4570, (SELECT `id` FROM `departments` WHERE `name` = 'video')),
        ('Helen', 'Hurrington', 'F', '2008-06-16', 5480, (SELECT `id` FROM `departments` WHERE `name` = 'audio')),
        ('Jhon', 'Ford', 'M', '2021-01-02', 6580, (SELECT `id` FROM `departments` WHERE `name` = 'vfx')),
        ('Charles', 'Davis', 'M', '2016-06-30', 4150, (SELECT `id` FROM `departments` WHERE `name` = '3d')),
        ('Ronnie', 'Miller', 'M', '2018-08-01', 3980, (SELECT `id` FROM `departments` WHERE `name` = '3d')),
        ('Mark', 'Smith', 'M', '2015-06-11', 5420, (SELECT `id` FROM `departments` WHERE `name` = 'vfx')),
        ('Claudia', 'Alston', 'F', '2017-03-01', 5040, (SELECT `id` FROM `departments` WHERE `name` = 'audio')),
        ('Melanie', 'Crush ', 'F', '2012-01-14', 3560, (SELECT `id` FROM `departments` WHERE `name` = 'production')),
        ('Robert', 'Benn', 'M', '2011-05-25', 4760, (SELECT `id` FROM `departments` WHERE `name` = 'legal')),
        ('Anna', 'Williams', 'F', '2006-06-06', 5230, (SELECT `id` FROM `departments` WHERE `name` = 'production')),
        ('Laura', 'Bright', 'F', '2020-07-15', 3210, (SELECT `id` FROM `departments` WHERE `name` = 'administration')),
        ('Anthony', 'McKenzie', 'M', '2022-008-30', 5420, (SELECT `id` FROM `departments` WHERE `name` = 'video'));


-- Insert Projects
INSERT INTO `projects` (`name`, `description`, `deadline`, `budget`, `client_id`, `contact_id`)
VALUES  ('Nike Pegasus', 'Video Online 45" + 3 Instagram Shorts 15"', '2025-01-15', 18000,
            (SELECT `id` FROM `clients` WHERE `name`= 'Normmal'),
            (SELECT `id` FROM `contacts` WHERE `full_name`= 'Jane Doe')),
        ('Cupra Born', '6 Instagram Shorts 15"', '2025-02-01', 24000,
            (SELECT `id` FROM `clients` WHERE `name`= 'Summer Digit'),
            (SELECT `id` FROM `contacts` WHERE `full_name`= 'Carl Crack')),
        ('Adidas Runners', 'Commercial 30" + 2 Videos 50"', '2025-01-28', 17500,
            (SELECT `id` FROM `clients` WHERE `name`= 'Hidrogen SL'),
            (SELECT `id` FROM `contacts` WHERE `full_name`= 'Moni Cim')),
        ('HH Winter', 'Spot 45" + 3 Shorts x 15"', '2025-02-25', 23400,
            (SELECT `id` FROM `clients` WHERE `name`= 'New Digital'),
            (SELECT `id` FROM `contacts` WHERE `full_name`= 'Mary Das')),
        ('Grifols WorldWide', 'Video Online 45" + 3 Instagram Shorts 15"', '2025-03-25', 36000,
            (SELECT `id` FROM `clients` WHERE `name`= 'Normmal'),
            (SELECT `id` FROM `contacts` WHERE `full_name`= 'Jane Doe'));


-- Insert Tasks
INSERT INTO `tasks` (`project_id`, `employee_id`, `service_id`, `comment`, `start_time`, `end_time`)
VALUES  (
            (SELECT `id` FROM `projects` WHERE `name` = 'Nike Pegasus'),
            (SELECT `id` FROM `employees` WHERE CONCAT(`first_name`, ' ' , `last_name`) = 'Claudia Alston'),
            ('audio'), ('Prep material'), ('2025-01-03 10:00:00'), ('2025-01-03 14:00:00')
        ),
        (
            (SELECT `id` FROM `projects` WHERE `name` = 'Nike Pegasus'),
            (SELECT `id` FROM `employees` WHERE CONCAT(`first_name`, ' ' , `last_name`) = 'Ronnie Miller'),
            ('3d'), ('Design Shoes'), ('2025-01-03 09:00:00'), ('2025-01-03 14:30:00')
        ),
        (
            (SELECT `id` FROM `projects` WHERE `name` = 'HH Winter'),
            (SELECT `id` FROM `employees` WHERE CONCAT(`first_name`, ' ' , `last_name`) = 'Jhon Ford'),
            ('vfx'), ('Integrate 3d jackest'), ('2025-01-10 11:00:00'), ('2025-01-10 14:30:00')
        ),
        (
            (SELECT `id` FROM `projects` WHERE `name` = 'HH Winter'),
            (SELECT `id` FROM `employees` WHERE CONCAT(`first_name`, ' ' , `last_name`) = 'Helen Hurrington'),
            ('audio'), ('Mixes and deliveries'), ('2025-01-11 14:00:00'), ('2025-01-11 19:00:00')
        ),
        (
            (SELECT `id` FROM `projects` WHERE `name` = 'Nike Pegasus'),
            (SELECT `id` FROM `employees` WHERE CONCAT(`first_name`, ' ' , `last_name`) = 'Mark Smith'),
            ('vfx'), ('Compose designed shots'), ('2025-01-12 10:00:00'), ('2025-01-12 17:00:00')
        ),
        (
            (SELECT `id` FROM `projects` WHERE `name` = 'Adidas Runners'),
            (SELECT `id` FROM `employees` WHERE CONCAT(`first_name`, ' ' , `last_name`) = 'Claudia Alston'),
            ('audio'), ('Deliveries'), ('2025-01-25 10:00:00'), ('2025-01-25 11:00:00')
        ),
        (
            (SELECT `id` FROM `projects` WHERE `name` = 'Grifols WorldWide'),
            (SELECT `id` FROM `employees` WHERE CONCAT(`first_name`, ' ' , `last_name`) = 'Anna Williams'),
            ('production'), ('Coordinate material and personnel'), ('2025-01-02 10:00:00'), ('2025-01-02 12:00:00')
        );

