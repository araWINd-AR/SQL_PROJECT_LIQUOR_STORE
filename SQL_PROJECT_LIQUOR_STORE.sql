
DROP DATABASE IF EXISTS mini_project;
CREATE DATABASE mini_project;
USE mini_project;



/* Vendor table */
CREATE TABLE vendor (
  vendor_id INT PRIMARY KEY,
  fname VARCHAR(50) NOT NULL,
  vendor_company VARCHAR(100) NOT NULL
);

/* Items table */
CREATE TABLE items (
  item_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(50) NOT NULL,
  vendor_company VARCHAR(100) NOT NULL,
  cases_order INT NOT NULL DEFAULT 0
);

/* Regular customers table */
CREATE TABLE regular_customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  fname VARCHAR(50) NOT NULL,
  lname VARCHAR(50) NOT NULL,
  item VARCHAR(100) NOT NULL,
  number INT NOT NULL DEFAULT 0,
  discount INT NOT NULL DEFAULT 0
);

/* Working hours table (used for self join) */
CREATE TABLE working_hours (
  id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  hours INT NOT NULL
);

/* Working information table */
CREATE TABLE working_information (
  info_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_id INT NOT NULL,
  vendor_id INT NOT NULL,
  weekly_hours INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE inventory_log (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  item_name VARCHAR(100) NOT NULL,
  log_message VARCHAR(255) NOT NULL,
  log_date DATETIME NOT NULL
);


CREATE TABLE employee_log (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_id INT NOT NULL,
  vendor_id INT NOT NULL,
  log_message VARCHAR(255) NOT NULL,
  log_date DATETIME NOT NULL
);


/*  TRIGGERS*/

DROP TRIGGER IF EXISTS low_inventory_trigger;
DROP TRIGGER IF EXISTS reward_regular_customers;
DROP TRIGGER IF EXISTS employee_order_log;

DELIMITER $$

/* Trigger 1: log low inventory after update */
CREATE TRIGGER low_inventory_trigger
AFTER UPDATE ON items
FOR EACH ROW
BEGIN
  IF NEW.cases_order < 10 THEN
    INSERT INTO inventory_log (item_name, log_message, log_date)
    VALUES (
      NEW.name,
      CONCAT('Low inventory: ', NEW.cases_order, ' cases left'),
      NOW()
    );
  END IF;
END$$

/* reward regular customers before insert */
CREATE TRIGGER reward_regular_customers
BEFORE INSERT ON regular_customers
FOR EACH ROW
BEGIN
  IF NEW.number > 50 THEN
    SET NEW.discount = 10;
  ELSE
    SET NEW.discount = 0;
  END IF;
END$$

/* log employee overtime after insert */
CREATE TRIGGER employee_order_log
AFTER INSERT ON working_information
FOR EACH ROW
BEGIN
  IF NEW.weekly_hours > 40 THEN
    INSERT INTO employee_log (employee_id, vendor_id, log_message, log_date)
    VALUES (
      NEW.employee_id,
      NEW.vendor_id,
      CONCAT(
        'Overtime: ', NEW.weekly_hours,
        ' hours worked while ordering for vendor ',
        NEW.vendor_id
      ),
      NOW()
    );
  END IF;
END$$

DELIMITER ;


/* SAMPLE DATA */

INSERT INTO vendor (vendor_id, fname, vendor_company) VALUES
(98, 'Justin',  'Mancini'),
(77, 'Rita',    'FritoLay'),
(55, 'Arjun',   'SunriseBrew');

INSERT INTO items (name, type, vendor_company, cases_order) VALUES
('Mancini Vodka Classic',   'Vodka',   'Mancini',      6),
('Mancini Whiskey Reserve', 'Whiskey', 'Mancini',      2),
('Sunrise Lager',           'Beer',    'SunriseBrew',  8),
('FritoLay Rum Gold',       'RUM',     'FritoLay',     12),
('Mancini Beer Light',      'Beer',    'Mancini',      4);

/* Trigger reward_regular_customers applies on inserts */
INSERT INTO regular_customers (fname, lname, item, number) VALUES
('Asha',  'K', 'Sunrise Lager',  12),
('Rahul', 'S', 'Mancini Beer Light', 55),
('Neha',  'P', 'Mancini Vodka Classic', 8);

INSERT INTO working_hours (id, name, hours) VALUES
(1, 'E1', 8),
(2, 'E2', 8),
(3, 'E3', 6),
(4, 'E4', 6),
(5, 'E5', 10);


/*  QUERIES  */


SELECT cases_order FROM items;


SELECT name FROM items
ORDER BY name;


SELECT DISTINCT(type) FROM items;

SELECT name FROM items i
WHERE i.vendor_company = 'Mancini' AND i.cases_order > 2;

SELECT vendor_id FROM vendor v
WHERE v.fname = 'Justin' OR v.vendor_id = 98;


SELECT name FROM items
WHERE type IN ('Vodka', 'Whiskey');


SELECT * FROM items
WHERE vendor_company LIKE 'M%';


SELECT SUM(cases_order) AS cases_order_one_month
FROM items;

SELECT MIN(cases_order) AS min_cases
FROM items;

SELECT COUNT(*) AS number_of_vendors
FROM vendor;

/* self join */
SELECT
  e1.name AS Employee1_Name, e1.id AS Employee1_ID,
  e2.name AS Employee2_Name, e2.id AS Employee2_ID
FROM working_hours e1
JOIN working_hours e2
  ON e1.hours = e2.hours
WHERE e1.id <> e2.id;

/* inner join */
SELECT
  rc.fname AS FNAME,
  rc.lname AS LNAME,
  i.name AS ITEM_NAME,
  v.fname AS VENDOR_NAME
FROM regular_customers rc
JOIN items i
  ON rc.item = i.name
JOIN vendor v
  ON i.vendor_company = v.vendor_company;

/* left outer join */
SELECT
  i.name,
  v.vendor_company
FROM items i
LEFT OUTER JOIN vendor v
  ON i.vendor_company = v.vendor_company;

/* group by having */
SELECT name, SUM(cases_order) AS cases_order
FROM items
GROUP BY name
HAVING SUM(cases_order) > 3;


/*  VIEWS  */

DROP VIEW IF EXISTS Rum;
CREATE VIEW Rum AS
SELECT * FROM items
WHERE type IN ('RUM');

DROP VIEW IF EXISTS highest_selling_beer;
CREATE VIEW highest_selling_beer AS
SELECT i.name, i.cases_order, i.vendor_company
FROM items i
WHERE i.cases_order > 5 AND i.type IN ('Beer');

DROP VIEW IF EXISTS preferred_customers_with_vendor;
CREATE VIEW preferred_customers_with_vendor AS
SELECT r.fname, r.item, i.vendor_company
FROM regular_customers r
JOIN items i
  ON i.name = r.item
WHERE r.number > 10;


/*  QUICK TESTS */

/* Test low_inventory_trigger  */
UPDATE items i
JOIN (
    SELECT item_id
    FROM items
    WHERE name = 'Sunrise Lager'
    LIMIT 1
) t
ON i.item_id = t.item_id
SET i.cases_order = 9;

/* Verify inventory trigger log */
SELECT * FROM inventory_log ORDER BY log_date DESC;

/* Test reward_regular_customers */
INSERT INTO regular_customers (fname, lname, item, number)
VALUES ('Test', 'User', 'Mancini Vodka Classic', 60);

/* Verify discount applied */
SELECT * FROM regular_customers WHERE fname = 'Test';

/* Test employee_order_log */
INSERT INTO working_information (employee_id, vendor_id, weekly_hours)
VALUES (101, 98, 45);

/* Verify employee log */
SELECT * FROM employee_log ORDER BY log_date DESC;
