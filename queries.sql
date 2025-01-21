-- List all clients
SELECT * FROM `clients`;
/*
+----+--------------------+---------------+----------------------------------------------+--------------+
| id | name               | phone         | address                                      | company_type |
+----+--------------------+---------------+----------------------------------------------+--------------+
|  1 | New Digital        | +34 934525858 | Passeig de Gràcia, 25, 4rt 2a, Barcelona     | agency       |
|  2 | La Hermida         | +34 935289863 | Carrer de Mallorca, 127, 1er 2na, Barcelona  | production   |
|  3 | Summer Digit       | +34 932456858 | Avinguda Paral.lel, 19, baixos, Barcelona    | publisher    |
|  4 | Normmal            | +34 939877852 | Carrer Puigmarti, 89, 4rt 3a, Barcelona      | agency       |
|  5 | Amazon Prime Video | +34 932345112 | Passeig Maragall, 77, 3er 1a, Barcelona      | platform     |
|  6 | Elena Housting     | +34 933562441 | Carrer de Vallfogona, 125, 4rt 2a, Barcelona | other        |
|  7 | Hidrogen SL        | +34 935684125 | Avinguda Josep Torres, 47, 1e 3a, Barcelona  | production   |
+----+--------------------+---------------+----------------------------------------------+--------------+
*/

-- List clients filtered by types
SELECT * FROM `clients` WHERE `company_type`='agency';
/*
+----+-------------+---------------+-------------------------------------------+--------------+
| id | name        | phone         | address                                   | company_type |
+----+-------------+---------------+-------------------------------------------+--------------+
|  1 | New Digital | +34 934525858 | Passeig de Gràcia, 25, 4rt 2a, Barcelona  | agency       |
|  4 | Normmal     | +34 939877852 | Carrer Puigmarti, 89, 4rt 3a, Barcelona   | agency       |
+----+-------------+---------------+-------------------------------------------+--------------+
*/


-- Count different types of customers for statistical purposes.
SELECT `company_type`,  COUNT(`id`) AS `N` FROM `clients` GROUP BY `company_type`;
/*
+--------------+---+
| company_type | N |
+--------------+---+
| agency       | 2 |
| production   | 2 |
| publisher    | 1 |
| platform     | 1 |
| other        | 1 |
+--------------+---+
*/


-- List all contacts basic info and company where they work for.
SELECT `full_name`, `email`, clients.name AS 'company' FROM `contacts`
JOIN `clients` ON  `client_id` = clients.id;
/*
+------------+----------------+--------------+
| full_name  | email          | company      |
+------------+----------------+--------------+
| Jhon Doe   | jhon@doe.com   | New Digital  |
| Jane Doe   | jane@doe.com   | Normmal      |
| Mary Das   | mary@das.com   | New Digital  |
| Carl Crack | carl@crack.com | Summer Digit |
| Moni Cim   | moni@cim.com   | Hidrogen SL  |
+------------+----------------+--------------+
*/


-- Search contacts basic info that works for a specific company.
SELECT `full_name`, `email`, contacts.phone, clients.name AS 'company' FROM `contacts`
JOIN `clients` ON  `client_id` = clients.id
WHERE `client_id` = (
    SELECT `id` FROM `clients` WHERE `name` = 'New Digital'
);
/*
+-----------+--------------+---------------+-------------+
| full_name | email        | phone         | company     |
+-----------+--------------+---------------+-------------+
| Jhon Doe  | jhon@doe.com | +34 659969632 | New Digital |
| Mary Das  | mary@das.com | +34 665885412 | New Digital |
+-----------+--------------+---------------+-------------+
*/


-- List all audio employees ordered by rate_hour descendant
SELECT `full_name`, `rate_hour` FROM `employees`
WHERE `department_id` = (
    SELECT `id`FROM `departments` WHERE `name` = 'audio'
)
ORDER BY rate_hour DESC;
/*
+------------------+-----------+
| full_name        | rate_hour |
+------------------+-----------+
| Helen Hurrington |     34.25 |
| Claudia Alston   |     31.50 |
+------------------+-----------+
*/


-- List all employees ordered by department and name
SELECT `full_name`, departments.name AS 'department' , `rate_hour` FROM `employees`
JOIN `departments` ON  `department_id` = departments.id
ORDER BY departments.name, `name`;
/*
+------------------+----------------+-----------+
| name             | department     | rate_hour |
+------------------+----------------+-----------+
| Charles Davis    | 3d             |     25.94 |
| Ronnie Miller    | 3d             |     24.88 |
| Laura Bright     | administration |     20.06 |
| Claudia Alston   | audio          |     31.50 |
| Helen Hurrington | audio          |     34.25 |
| Robert Benn      | legal          |     29.75 |
| Anna Williams    | production     |     32.69 |
| Melanie Crush    | production     |     22.25 |
| Jhon Ford        | vfx            |     41.13 |
| Mark Smith       | vfx            |     33.88 |
| Anthony McKenzie | video          |     33.88 |
| Jennifer Alston  | video          |     28.56 |
+------------------+----------------+-----------+
*/


-- List all project tasks and employee for the task ordered by date
SELECT `name`, `service_id` AS 'service', `full_name` AS 'operator' ,`start_time`  FROM `projects`
JOIN `tasks` ON projects.id = `project_id`
JOIN `employees` ON employees.id = tasks.employee_id
WHERE `name` = 'Nike Pegasus'
ORDER BY `start_time`;
/*
+--------------+---------+----------------+---------------------+
| name         | service | operator       | start_time          |
+--------------+---------+----------------+---------------------+
| Nike Pegasus | 3d      | Ronnie Miller  | 2025-01-03 09:00:00 |
| Nike Pegasus | audio   | Claudia Alston | 2025-01-03 10:00:00 |
| Nike Pegasus | vfx     | Mark Smith     | 2025-01-12 10:00:00 |
+--------------+---------+----------------+---------------------+
*/

-- List a project tasks budget estimated cost for the client by task
SELECT projects.name, `service_id` AS 'service', `start_time`, `end_time`, ROUND((services.price * `spended_time`), 2) AS 'total'  FROM `projects`
JOIN `tasks` ON projects.id = `project_id`
JOIN `services` ON services.service = tasks.service_id
WHERE projects.name = 'Nike Pegasus'
ORDER BY `start_time`;
/*
+--------------+---------+---------------------+---------------------+---------+
| name         | service | start_time          | end_time            | total   |
+--------------+---------+---------------------+---------------------+---------+
| Nike Pegasus | 3d      | 2025-01-03 09:00:00 | 2025-01-03 14:30:00 | 1100.00 |
| Nike Pegasus | audio   | 2025-01-03 10:00:00 | 2025-01-03 14:00:00 |  600.00 |
| Nike Pegasus | vfx     | 2025-01-12 10:00:00 | 2025-01-12 17:00:00 | 1750.00 |
+--------------+---------+---------------------+---------------------+---------+
*/


-- List a project name, budget and an consumed budget the client based on scheduled tasks
SELECT projects.name, budget, ROUND(SUM(services.price * `spended_time`), 2) AS 'consumed' FROM `projects`
JOIN `tasks` ON projects.id = `project_id`
JOIN `services` ON services.service = tasks.service_id
WHERE projects.name = 'Adidas Runners';
/*
+----------------+----------+----------+
| name           | budget   | consumed |
+----------------+----------+----------+
| Adidas Runners | 17500.00 | 150.0000 |
+----------------+----------+----------+
*/


-- Calculate budget balance for a project active or not.(budget - all services * hours consumed or scheduled)
WITH project_budget_services_consumed AS (
        SELECT projects.name, budget, SUM(services.price * `spended_time`) AS 'services_consumed' FROM `projects`
        JOIN `tasks` ON projects.id = `project_id`
        JOIN `services` ON services.service = tasks.service_id
        WHERE projects.name = 'Nike Pegasus')
SELECT `name`, ROUND((budget - services_consumed), 2) AS 'budget balance' FROM project_budget_services_consumed;
/*
+--------------+----------------+
| name         | budget balance |
+--------------+----------------+
| Nike Pegasus |       14550.00 |
+--------------+----------------+
*/


-- List all active projects budget balance based on scheduled tasks
SELECT projects.name, budget, ROUND(SUM(services.price * `spended_time`), 2) AS 'services consumed' FROM `projects`
JOIN `tasks` ON projects.id = `project_id`
JOIN `services` ON services.service = tasks.service_id
WHERE projects.is_deleted = 0
GROUP BY projects.name;
/*
+-------------------+----------+-------------------+
| name              | budget   | services consumed |
+-------------------+----------+-------------------+
| Nike Pegasus      | 18000.00 |           3450.00 |
| Adidas Runners    | 17500.00 |            150.00 |
| HH Winter         | 23400.00 |           1500.00 |
| Grifols WorldWide | 36000.00 |            220.00 |
+-------------------+----------+-------------------+
*/


-- List all active projects budget balance based on budget and scheduled tasks for January 2025 ordered by
-- percentage of budget consumed
WITH projects_monthly_balance AS (
        SELECT projects.name, budget, SUM(services.price * `spended_time`) AS 'services_consumed'
        FROM `projects`
        JOIN `tasks` ON projects.id = `project_id`
        JOIN `services` ON services.service = tasks.service_id
        WHERE YEAR(`end_time`) = 2025 AND MONTH(`end_time`) = 1 AND projects.is_deleted = 0
        GROUP BY projects.name )
SELECT `name` AS 'project',
        budget, services_consumed,
        ROUND((budget - services_consumed), 2) AS 'January 2025 balance',
        ROUND((services_consumed / budget * 100), 2) AS 'Percentage consumed'
FROM projects_monthly_balance
ORDER BY `Percentage consumed` DESC;
/*
+----------------+----------------------+
| project        | January 2025 balance |
+----------------+----------------------+
| Nike Pegasus   |             14550.00 |
| Adidas Runners |             17350.00 |
| HH Winter      |             21900.00 |
+----------------+----------------------+
*/


-- Calculate monthly incomes by service
WITH services_incomes_by_month AS (
        SELECT services.service AS 'service', SUM(services.price * `spended_time`) AS 'service_total' FROM `tasks`
        JOIN `services` ON services.service = tasks.service_id
        WHERE MONTH(`end_time`) = 1 AND YEAR(`end_time`) = 2025 AND tasks.is_deleted = 0
        GROUP BY services.service )
SELECT service , ROUND(service_total, 2) AS 'total incomes' FROM services_incomes_by_month;
/*
+---------+---------------+
| service | total incomes |
+---------+---------------+
| audio   |       1500.00 |
| 3d      |       1100.00 |
| vfx     |       2500.00 |
+---------+---------------+
*/


-- Call a stored procedure
CALL get_project_services_consumed_id(1);
/*
+--------------+----------+-------------------+
| name         | budget   | services_consumed |
+--------------+----------+-------------------+
| Nike Pegasus | 18000.00 |         3450.0000 |
+--------------+----------+-------------------+
*/


-- Call a stored procedure
CALL get_project_services_consumed_by_name('Nike Pegasus');
/*
+--------------+----------+-------------------+
| name         | budget   | services_consumed |
+--------------+----------+-------------------+
| Nike Pegasus | 18000.00 |         3450.0000 |
+--------------+----------+-------------------+
*/
