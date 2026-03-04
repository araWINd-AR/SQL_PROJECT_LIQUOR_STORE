# Inventory & Vendor Management Mini Project (MySQL)

This is a small database project built using MySQL.  
I created this project to practice SQL concepts like tables, triggers, joins, views, and queries.

The system manages vendors, items, customers, and employee working information.  
It also includes automatic logging using triggers.

---

## Project Purpose

The goal of this project was to understand how databases work in a real scenario.

It shows how a store or company might manage:

- Vendors who supply items
- Inventory of products
- Regular customers
- Employee working information
- Automatic logs for important events

---

## Database Features

This project includes the following SQL concepts:

- Table creation
- Primary keys and relationships
- Triggers
- Views
- Joins
- Aggregate functions
- Sample data insertion

---

## Tables Used

The database contains the following tables:

- **vendor** – stores vendor details
- **items** – stores item information and inventory
- **regular_customers** – stores customer purchase data
- **working_hours** – employee working hours
- **working_information** – tracks employee orders
- **inventory_log** – logs low inventory alerts
- **employee_log** – logs employee overtime

---

## Triggers Implemented

Three triggers are used in this project.

### 1. Low Inventory Trigger
If item stock becomes less than 10 cases, a message is automatically logged in the inventory log table.

### 2. Reward Regular Customers
If a customer orders more than 50 items, they automatically receive a 10% discount.

### 3. Employee Overtime Log
If an employee works more than 40 hours in a week while placing vendor orders, the system logs the overtime.

---

## SQL Concepts Demonstrated

This project demonstrates many SQL operations such as:

- SELECT queries
- DISTINCT
- ORDER BY
- WHERE conditions
- Aggregate functions
- GROUP BY and HAVING
- INNER JOIN
- LEFT JOIN
- SELF JOIN

---

## Views Created

The database also includes views for easier data access.

- **Rum** – shows all rum items
- **highest_selling_beer** – shows beer items with high sales
- **preferred_customers_with_vendor** – shows preferred customers and vendor information

---

## How to Run the Project

1. Open MySQL Workbench or any SQL environment.
2. Run the SQL script file.
3. The database and tables will be created automatically.
4. Sample data will be inserted.
5. You can run the queries at the end of the script to test the system.

---

## What I Learned

While building this project, I practiced:

- Designing relational databases
- Writing SQL queries
- Using triggers for automation
- Creating views for easier reporting
- Working with joins and aggregate functions

---

## Author

Aravind Ganipisetty

Master’s in Computer and Information Science  
Interested in Python, automation, AI systems, and database design.
