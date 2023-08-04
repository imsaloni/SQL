SELECT TOP 1 salary
FROM employee
ORDER BY salary DESC
OFFSET 4 ROWS FETCH NEXT 1 ROWS ONLY;

ALTER TABLE employee
ADD salary DECIMAL(10, 2);

select * from employee;

Alter PROCEDURE [dbo].[USP_AddEditDeleteBulkCOAllowedStatus](	
    @employee_id INT = NULL,
    @ActionID INT,
    @department_id INT,
    @employee_name varchar(MAX),
    @employee_address varchar(MAX),
    @salary DECIMAL(10, 2)  -- Add the salary parameter with appropriate data type
)
AS	
BEGIN
    IF NOT EXISTS (SELECT * FROM employee WHERE employee_id = @employee_id)
    BEGIN
        IF (@ActionId = 1) -- add/Insert
        BEGIN
            INSERT INTO employee (employee_name, employee_address, department_id, salary)
            VALUES (@employee_name, @employee_address, @department_id, @salary)
        END
    END
    ELSE
    BEGIN
        IF (@ActionID = 2) -- edit
        BEGIN
            UPDATE employee
            SET employee_name = @employee_name,
                employee_address = @employee_address,
                department_id = @department_id,
                salary = @salary  -- Update the salary field
            WHERE employee_id = @employee_id
        END

        IF (@ActionID = 3) -- Delete
        BEGIN
            DELETE FROM employee
            WHERE employee_id = @employee_id
        END
    END
END

EXEC [dbo].[USP_AddEditDeleteBulkCOAllowedStatus]
    @employee_id = 1,
    @ActionID = 1,
    @department_id =1 ,
    @employee_name = 'market',
    @employee_address = 'mumbai',
    @salary = 100000.00;
select * from employee;
SELECT TOP 1 salary
FROM (
    SELECT DISTINCT TOP 5 salary
    FROM employee
    ORDER BY salary DESC
) AS FifthHighestSalaries
ORDER BY salary ASC;

select top 1 salary from employee;

SELECT MIN(salary) FROM employee;

SELECT MIN(salary) FROM (SELECT DISTINCT TOP 5 salary FROM employee ORDER BY salary DESC) AS FifthHighestSalaries;
update employee set salary=  55000 where employee_id = 1;
select * from employee;

select *from department;

select employee_name,count(department_name) as depname,avg(salary) as avgsalary from employee inner join department on employee.department_id = department.department_id group by employee_name;
SELECT e.employee_name, d.department_name
FROM employee e
INNER JOIN department d ON e.department_id = d.department_id
WHERE e.salary > (SELECT AVG(salary) FROM employee);


SELECT TOP 5 e.salary as tsalary, e.employee_name, d.department_name
FROM employee e
JOIN department d ON e.department_id = d.department_id
ORDER BY e.salary DESC;

select top 2 e.salary,e.employee_name,d.department_name from employee e 
inner join department d on e.department_id = d.department_id order by e.salary desc;

SELECT d.department_name, COUNT(e.employee_name) AS employee_count
FROM department d
LEFT JOIN employee e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY d.department_name;

SELECT e.employee_name, d.department_name
FROM employee e
INNER JOIN department d ON e.department_id = d.department_id
WHERE e.employee_name = d.department_name;

SELECT employee_name, salary
FROM employee
WHERE salary BETWEEN (
    SELECT AVG(salary) - 1000
    FROM employee
) AND (
    SELECT AVG(salary) + 1000
    FROM employee
);

select * from employee;
select * from department;
drop table employee;

DELETE FROM employee WHERE department_id IN (SELECT department_id FROM department);


EXEC insert_into_department
    @department_id = 1,
    @department_name = 'hr';
select * from department;
drop table department;
drop table employee;
CREATE TABLE department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    -- Add any other columns you need for the "department" table
    -- For example, you can include columns for department description, location, etc.
);

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    employee_address VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2),
    -- Add any other columns you need for the "employee" table
    -- For example, you can include columns for date of birth, hire date, etc.

    -- Adding the FOREIGN KEY CONSTRAINT directly in the CREATE TABLE statement:
    CONSTRAINT FK_Employee_Department
    FOREIGN KEY (department_id) REFERENCES department (department_id)
);


-- Create a stored procedure to insert data into both "employee" and "department" tables
CREATE PROCEDURE usp_InsertEmployeeAndDepartment
    @employee_id INT,
    @employee_name VARCHAR(50),
    @employee_address VARCHAR(100),
    @department_id INT,
    @salary DECIMAL(10, 2),
    @department_name VARCHAR(50)
AS
BEGIN
    -- Check if the department exists in the "department" table
    IF NOT EXISTS (SELECT 1 FROM department WHERE department_id = @department_id)
    BEGIN
        -- Insert the department into the "department" table
        INSERT INTO department (department_id, department_name)
        VALUES (@department_id, @department_name);
    END

    -- Insert the employee into the "employee" table
    INSERT INTO employee (employee_id, employee_name, employee_address, department_id, salary)
    VALUES (@employee_id, @employee_name, @employee_address, @department_id, @salary);
END

EXEC usp_InsertEmployeeAndDepartment
    @employee_id = 3,
    @employee_name = 'saloni shahi',
    @employee_address = '123 Main St',
    @department_id = 101,
    @salary = 50000.00,
    @department_name = 'sales';

	ALTER TABLE employee
ADD CONSTRAINT FK_Employee_Department
FOREIGN KEY (department_id) REFERENCES department(department_id);
