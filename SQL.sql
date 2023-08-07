--Retrieve the department names and the highest salary in each department.--
SELECT d.department_name, MAX(e.salary) AS highest_salary
FROM department d
LEFT JOIN employee e ON d.department_id = e.department_id
GROUP BY d.department_name;

select * from employee;
CREATE TABLE orderss (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customer (Customer_id),
    order_date DATETIME,
    order_total DECIMAL(10, 2)
);


--Write a stored procedure that takes a customer_id as input and returns the total number of orders placed by that customer.--
CREATE PROCEDURE dbo.USP_GetTotalOrdersByCustomer
    @customer_id INT
AS
BEGIN
    SELECT COUNT(*) AS total_orders
    FROM orderss
    WHERE customer_id = @customer_id;
END

EXEC dbo.USP_GetTotalOrdersByCustomer @customer_id = 123;

CREATE PROCEDURE dbo.USP_InsertOrder
    @order_id INT,
    @customer_id INT,
    @order_date DATETIME,
    @order_total DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO orderss (order_id, customer_id, order_date, order_total)
    VALUES (@order_id, @customer_id, @order_date, @order_total);
END



EXEC dbo.USP_InsertOrder 
    @order_id = 6,
    @customer_id = 105,
    @order_date = '2023-04-05',
    @order_total = 80000.75;
	select * from orderss;

	CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    address VARCHAR(200)
);

CREATE PROCEDURE dbo.USP_InsertCustomer
    @customer_id INT,
    @customer_name VARCHAR(100),
    @contact_email VARCHAR(100),
    @contact_phone VARCHAR(20),
    @address VARCHAR(200)
AS
BEGIN
    INSERT INTO customer (customer_id, customer_name, contact_email, contact_phone, address)
    VALUES (@customer_id, @customer_name, @contact_email, @contact_phone, @address);
END


-- First, check if the constraint exists (optional but recommended)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_orders_customer')
BEGIN
    ALTER TABLE orderss
    ADD CONSTRAINT FK_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES customer (customer_id);
END


drop table orderss;

EXEC dbo.USP_InsertOrder 
    @order_id = 11,
    @customer_id = 105,
    @order_date = '2023-08-05',
    @order_total = 30000.75;
	select * from orderss;

EXEC dbo.USP_InsertCustomer 
    @customer_id = 105,
    @customer_name = 'Rutuja jadhav',
    @contact_email = 'rutuja.jadhav@capgimini.com',
    @contact_phone = '1234567891',
    @address = '123 Main Street, Anytown, airoli';
	
	select customer_id,count(order_id) as orderid from orderss group by customer_id Having count(order_id) > 1;
	select * from orderss;

	SELECT customer_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM orderss
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);

SELECT DISTINCT c.customer_name
FROM customer c
INNER JOIN orderss o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;
 
 select * from orderss;
 select * from customer;
 select * from orders;
 truncate table customer;
 delete from customer where customer_id = 105 ;
 delete from customer;
 delete from department;
 select * from department;
 select * from employee;
 DELETE FROM employee WHERE department_id IN (SELECT department_id FROM department);
 SELECT * FROM customer where customer_id between 102 and 104;
 
​SELECT customer_name from customer where customer_id = ANY (SELECT customer_id from orderss where order_total= 6000.75);
SELECT * INTO ordersss
FROM orderss
where 1=0;
drop table ordersss;
​
select * from ordersss;
select * from orderss;
SELECT * FROM customer;
select * from orders;
insert into ordersss select * from orderss;
truncate table ordersss;
select * from employee ;
select * from department;

--Write a SQL query to retrieve the names of employees who have a salary greater than the average salary of all employees
SELECT employee_name, salary
FROM employee
WHERE salary > (SELECT AVG(salary) FROM employee);

--Write a SQL query to find the total number of orders placed by each customer, along with their names
SELECT c.customer_name, COUNT(o.order_id) as order_count
FROM customer c
INNER JOIN orderss o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

--Write a SQL query to find the top 3 highest paid employees along with their names and salaries
select top 3 employee_name , max(salary) as highest_salary from employee group by employee_name; 
select * from employee;
SELECT TOP 3 employee_name, salary
FROM employee
ORDER BY salary DESC;

--Write a SQL query to calculate the average salary of employees in each department, along with the department name
select d.department_name , avg(e.salary) as average_salary from employee e inner join department d on 
e.department_id = d.department_id group by d.department_name;


--Write a SQL query to find the customer who has placed the maximum number of orders
select top 1 c.customer_name , max(o.customer_id) as max_customer from customer c inner join orderss o on 
o.customer_id = c.customer_id group by c.customer_name order by max_customer desc;

SELECT TOP 1 c.customer_name, COUNT(o.order_id) AS order_count
FROM customer c
INNER JOIN orderss o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY order_count DESC;

--Write a SQL query to retrieve the names of customers who have placed at least 3 orders
select c.customer_name , count(o.customer_id) as count_customer from orderss o inner join customer c
on o.customer_id = c.customer_id group by c.customer_name having count(o.customer_id) >= 3 ;
 

 --Write a SQL query to find the employees who have the same salary as the highest salary in the company
 /*select top 1 employee_name , max(salary) as max_salary from employee 
 group by employee_name order by max_salary desc ; */

 SELECT employee_name, salary
FROM employee
WHERE salary = (SELECT MAX(salary) FROM employee);

--Write a SQL query to find the customers who have placed orders for more than one product.
select c.customer_name , count(o.order_id) as count_product from customer c join orderss o on c.customer_id = o.customer_id 
group by c.customer_name having count(o.order_id) > 1;

SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customer c
JOIN orderss o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) > 1;

--Write a SQL query to find the departments that have more than 3 employees
select e.employee_name , count(d.department_name) as count_department from employee e
join department d on e.department_id = d.department_id group by employee_name having count(d.department_name)>=3;


SELECT d.department_name, COUNT(e.employee_id) as employee_count
FROM department d
JOIN employee e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 3;
select * from department;
select * from employee;

--Write a SQL query to find the average salary of employees for each department, but only
--consider departments where the average salary is above $50000
select d.department_name, avg(e.salary) as avg_salary from employee e join 
department d on d.department_id= e.department_id group by d.department_name having AVG(e.salary) > 50000;

--Write a SQL query to find the customers who have placed orders in both '2022-01-01' and '2023-01-01'
select c.customer_name from customer c inner join orderss o on c.customer_id=o.customer_id
where o.order_id = 2022-01-01 or o.order_id =2023-01-01
group by c.customer_name having count(o.order_date)=2 ;

CREATE TABLE category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id INT foreign key references category(category_id),
	 order_id INT foreign key references orderss(order_id),
    -- Other columns for product details
);
drop table products;
-- Assuming there are existing categories and orders with the appropriate IDs
INSERT INTO products (product_id, product_name, category_id, order_id)
VALUES
    (1, 'Laptop', 1, 1),
    (2, 'T-Shirt', 2, 1),
    (3, 'Refrigerator', 1, 2),
    (4, 'Smartphone', 2, 2),
    (5, 'Jeans', 2, 3),
    (6, 'Washing Machine', 1, 3),
    (7, 'Novel', 3, 4),
    (8, 'Sofa', 4, 5),
    (9, 'Lipstick', 5, 6),
    (10, 'Action Figure', 6, 7),
    (11, 'Basketball', 7, 8),
    (12, 'Necklace', 8, 9),
    (13, 'Apples', 9, 10),
    (14, 'Headphones', 1, 11),
    (15, 'Shorts', 2, 11);
  INSERT INTO category (category_id, category_name)
VALUES
    (1, 'Electronics'),
    (2, 'Clothing'),
    (3, 'Home Appliances'),
    (4, 'Books'),
    (5, 'Furniture'),
    (6, 'Beauty'),
    (7, 'Toys'),
    (8, 'Sports'),
    (9, 'Jewelry'),
    (10, 'Groceries');
   
--Write a SQL query to find the customers who have placed orders for products from more than one category.
select c.customer_name as count_category from customer c join orderss o on c.customer_id=o.customer_id 
join products p on o.order_id  = p.order_id 
group by c.customer_name
having count(p.category_id)>1;

--Write a SQL query to calculate the total revenue generated by each customer, considering the sum of order totals for each customer
select c.customer_name , sum(o.order_total) as sum_order from
customer c inner join orderss o on c.customer_id=o.customer_id
group by customer_name;
select * from orderss;
select * from customer;
select * from products;
select * from category;

--Write a SQL query to find the top 5 products with the highest total sales revenue, along with their product names and the total revenue
select top 5 p.product_name , sum(o.order_total) as total_revenue from products p 
inner join orderss o on p.order_id = o.order_id group by p.product_name order by total_revenue desc ;

--Write a SQL query to find the average order total for each year, considering the order date.
select year(order_date) as order_year , avg(order_total) as avg_order from orderss group by year(order_date);

--Write a SQL query to find the top 3 customers who have the highest total number of orders
select top 3 c.customer_name , count(o.customer_id) as customer_order from customer c inner join orderss o 
on c.customer_id = o.customer_id group by customer_name order by customer_order desc;
SELECT TOP 3 c.customer_name, COUNT(o.order_id) AS total_orders
FROM customer c
INNER JOIN orderss o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;

--Write a SQL query to find the total revenue generated by each category, considering the sum of order totals for products in each category
select c.category_name , sum(o.order_total) as total_revenue from orderss o
inner join products p on o.order_id = p.product_id
inner join category c on c.category_id = p.category_id
group by c.category_name ;

--Write a SQL query to find the customers who have placed orders for products from all available categories
select c.customer_name , ca.