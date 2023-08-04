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
    @order_id = 5,
    @customer_id = 105,
    @order_date = '2023-04-05',
    @order_total = 70000.75;


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
    @order_id = 5,
    @customer_id = 104,
    @order_date = '2023-08-05',
    @order_total = 40000.75;
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