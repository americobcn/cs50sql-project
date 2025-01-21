/***************************************************/
/***************************************************/

/* Before optimization */
EXPLAIN SELECT `company_type`,  COUNT(`id`) AS `N` FROM `clients` GROUP BY `company_type`;
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-----------------+
| id | select_type | table   | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra           |
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-----------------+
|  1 | SIMPLE      | clients | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    7 |   100.00 | Using temporary |
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-----------------+
1 row in set, 1 warning (0,00 sec)

/* After optimization */
mysql> EXPLAIN SELECT `company_type`,  COUNT(`id`) AS `N` FROM `clients` GROUP BY `company_type`;
+----+-------------+---------+------------+-------+--------------------+--------------------+---------+------+------+----------+-------------+
| id | select_type | table   | partitions | type  | possible_keys      | key                | key_len | ref  | rows | filtered | Extra       |
+----+-------------+---------+------------+-------+--------------------+--------------------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | clients | NULL       | index | company_type_index | company_type_index | 2       | NULL |    7 |   100.00 | Using index |
+----+-------------+---------+------------+-------+--------------------+--------------------+---------+------+------+----------+-------------+
1 row in set, 1 warning (0,00 sec)


/* Before optimization */
EXPLAIN SELECT * FROM `clients` WHERE `company_type`='agency';
+----+-------------+---------+------------+------+---------------------------+---------------------------+---------+-------+------+----------+-----------------------+
| id | select_type | table   | partitions | type | possible_keys             | key                       | key_len | ref   | rows | filtered | Extra                 |
+----+-------------+---------+------------+------+---------------------------+---------------------------+---------+-------+------+----------+-----------------------+
|  1 | SIMPLE      | clients | NULL       | ALL  | company_type_unique_index | company_type_unique_index | 2       | const |    2 |   100.00 | Using index condition |
+----+-------------+---------+------------+------+---------------------------+---------------------------+---------+-------+------+----------+-----------------------+
1 row in set, 1 warning (0,00 sec)


/* After optimization */
EXPLAIN SELECT * FROM `clients` WHERE `company_type`='agency';
+----+-------------+---------+------------+------+---------------------------+---------------------------+---------+-------+------+----------+-----------------------+
| id | select_type | table   | partitions | type | possible_keys             | key                       | key_len | ref   | rows | filtered | Extra                 |
+----+-------------+---------+------------+------+---------------------------+---------------------------+---------+-------+------+----------+-----------------------+
|  1 | SIMPLE      | clients | NULL       | ref  | company_type_unique_index | company_type_unique_index | 2       | const |    2 |   100.00 | Using index condition |
+----+-------------+---------+------------+------+---------------------------+---------------------------+---------+-------+------+----------+-----------------------+
1 row in set, 1 warning (0,00 sec)


/***************************************************/
/***************************************************/


/* Before optimization */
mysql> explain SELECT projects.name, budget, ROUND(SUM(services.price * `spended_time`), 2) AS 'services consumed' FROM `projects`
    -> JOIN `tasks` ON projects.id = `project_id`
    -> JOIN `services` ON services.service = tasks.service_id
    -> WHERE projects.is_deleted = 0
    -> GROUP BY projects.name;
+----+-------------+----------+------------+--------+-----------------------+------------+---------+---------------------------+------+----------+------------------------------+
| id | select_type | table    | partitions | type   | possible_keys         | key        | key_len | ref                       | rows | filtered | Extra                        |
+----+-------------+----------+------------+--------+-----------------------+------------+---------+---------------------------+------+----------+------------------------------+
|  1 | SIMPLE      | projects | NULL       | ALL    | PRIMARY,name          | NULL       | NULL    | NULL                      |    5 |    20.00 | Using where; Using temporary |
|  1 | SIMPLE      | tasks    | NULL       | ref    | project_id,service_id | project_id | 5       | projects.projects.id      |    1 |   100.00 | Using where                  |
|  1 | SIMPLE      | services | NULL       | eq_ref | PRIMARY,name          | PRIMARY    | 258     | projects.tasks.service_id |    1 |   100.00 | NULL                         |
+----+-------------+----------+------------+--------+-----------------------+------------+---------+---------------------------+------+----------+------------------------------+
3 rows in set, 1 warning (0,00 sec)

/* After optimization */

mysql> explain SELECT projects.name, budget, ROUND(SUM(services.price * `spended_time`), 2) AS 'services consumed' FROM `projects` JOIN `tasks` ON projects.id = `project_id` JOIN `services` ON services.service = tasks.service_id WHERE projects.is_deleted = 0 GROUP BY projects.name;
+----+-------------+----------+------------+--------+-------------------------------+------------------+---------+---------------------------+------+----------+-----------------+
| id | select_type | table    | partitions | type   | possible_keys                 | key              | key_len | ref                       | rows | filtered | Extra           |
+----+-------------+----------+------------+--------+-------------------------------+------------------+---------+---------------------------+------+----------+-----------------+
|  1 | SIMPLE      | projects | NULL       | ref    | PRIMARY,name,is_deleted_index | is_deleted_index | 2       | const                     |    5 |   100.00 | Using temporary |
|  1 | SIMPLE      | tasks    | NULL       | ref    | project_id,service_id         | project_id       | 5       | projects.projects.id      |    1 |   100.00 | Using where     |
|  1 | SIMPLE      | services | NULL       | eq_ref | PRIMARY,name                  | PRIMARY          | 258     | projects.tasks.service_id |    1 |   100.00 | NULL            |
+----+-------------+----------+------------+--------+-------------------------------+------------------+---------+---------------------------+------+----------+-----------------+
3 rows in set, 1 warning (0,00 sec)


/***************************************************/
/***************************************************/


/*Before optimization */
mysql> explain WITH services_incomes_by_month AS (
    ->         SELECT services.service AS 'service', SUM(services.price * `spended_time`) AS 'service_total' FROM `tasks`
    ->         JOIN `services` ON services.service = tasks.service_id
    ->         WHERE MONTH(`end_time`) = 1 AND YEAR(`end_time`) = 2025 AND tasks.is_deleted = 0
    ->         GROUP BY services.service )
    -> SELECT service , ROUND(service_total, 2) AS 'total incomes' FROM services_incomes_by_month;
+----+-------------+------------+------------+--------+---------------+---------+---------+---------------------------+------+----------+------------------------------+
| id | select_type | table      | partitions | type   | possible_keys | key     | key_len | ref                       | rows | filtered | Extra                        |
+----+-------------+------------+------------+--------+---------------+---------+---------+---------------------------+------+----------+------------------------------+
|  1 | PRIMARY     | <derived2> | NULL       | ALL    | NULL          | NULL    | NULL    | NULL                      |    2 |   100.00 | NULL                         |
|  2 | DERIVED     | tasks      | NULL       | ALL    | service_id    | NULL    | NULL    | NULL                      |    7 |    14.29 | Using where; Using temporary |
|  2 | DERIVED     | services   | NULL       | eq_ref | PRIMARY,name  | PRIMARY | 258     | projects.tasks.service_id |    1 |   100.00 | NULL                         |
+----+-------------+------------+------------+--------+---------------+---------+---------+---------------------------+------+----------+------------------------------+
3 rows in set, 1 warning (0,00 sec)

/* After optimization */

mysql> explain WITH services_incomes_by_month AS (
    ->         SELECT services.service AS 'service', SUM(services.price * `spended_time`) AS 'service_total' FROM `tasks`
    ->         JOIN `services` ON services.service = tasks.service_id
    ->         WHERE MONTH(`end_time`) = 1 AND YEAR(`end_time`) = 2025 AND tasks.is_deleted = 0
    ->         GROUP BY services.service )
    -> SELECT service , ROUND(service_total, 2) AS 'total incomes' FROM services_incomes_by_month;
+----+-------------+------------+------------+--------+----------------------------------+-----------------------+---------+---------------------------+------+----------+------------------------------+
| id | select_type | table      | partitions | type   | possible_keys                    | key                   | key_len | ref                       | rows | filtered | Extra                        |
+----+-------------+------------+------------+--------+----------------------------------+-----------------------+---------+---------------------------+------+----------+------------------------------+
|  1 | PRIMARY     | <derived2> | NULL       | ALL    | NULL                             | NULL                  | NULL    | NULL                      |    7 |   100.00 | NULL                         |
|  2 | DERIVED     | tasks      | NULL       | ref    | service_id,is_deleted_task_index | is_deleted_task_index | 2       | const                     |    7 |   100.00 | Using where; Using temporary |
|  2 | DERIVED     | services   | NULL       | eq_ref | PRIMARY,name                     | PRIMARY               | 258     | projects.tasks.service_id |    1 |   100.00 | NULL                         |
+----+-------------+------------+------------+--------+----------------------------------+-----------------------+---------+---------------------------+------+----------+------------------------------+
3 rows in set, 1 warning (0,00 sec)
