--Hw-19



CREATE TABLE #Employees7 (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

CREATE TABLE DepartmentBonus (
    Department NVARCHAR(50) PRIMARY KEY,
    BonusPercentage DECIMAL(5,2)
);

INSERT INTO #Employees7 VALUES
(1, 'John', 'Doe', 'Sales', 5000),
(2, 'Jane', 'Smith', 'Sales', 5200),
(3, 'Mike', 'Brown', 'IT', 6000),
(4, 'Anna', 'Taylor', 'HR', 4500);

INSERT INTO DepartmentBonus VALUES
('Sales', 10),
('IT', 15),
('HR', 8);

select * from #Employees7
select * from departments

create proc getemployeebonuses
as
begin
    create table #employeebonus ( employeeid int, fullname nvarchar(101), department nvarchar(50), salary decimal(10,2),  bonusamount decimal(10,2))
    insert into #employeebonus (employeeid, fullname, department, salary, bonusamount)
    select  e.employeeid,  e.firstname + ' ' + e.lastname as fullname,  e.department,  e.salary, e.salary * db.bonuspercentage / 100 as bonusamount from #Employees7 as e
    join 
    departmentbonus db on e.department = db.department;
    select * from #employeebonus;
end

exec getemployeebonuses


create proc getupdatedsalaryofemployees
as
begin
  create table #employeeupdatedsalary( employeeid int, fullname nvarchar(101), department nvarchar(50), salary decimal(10,2),  bonusamount decimal(10,2), Updatedsalary decimal(10,2))
    insert into #employeeupdatedsalary (employeeid, fullname, department, salary, bonusamount, Updatedsalary)
    select  e.employeeid,  e.firstname + ' ' + e.lastname as fullname,  e.department,  e.salary, e.salary * db.bonuspercentage / 100 as bonusamount,e.salary * db.bonuspercentage / 100 + e.Salary as Updatedsalary from #Employees7 as e
     join 
    departmentbonus db on e.department = db.department;
    select * from #employeeupdatedsalary
end

exec getupdatedsalaryofemployees





CREATE TABLE Products_Current (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE Products_New (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products_Current VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 600),
(3, 'Smartphone', 800);

INSERT INTO Products_New VALUES
(2, 'Tablet Pro', 700),
(3, 'Smartphone', 850),
(4, 'Smartwatch', 300);

select * from Products_Current
select * from Products_New

;merge into Products_Current as target
using Products_New as Source
on Target.productID = Source.ProductID
when matched then
	update set
		--target.ProductID = Source.ProductId,
		target.ProductName = Source.ProductName,
		target.Price = Source.Price
	
when Not Matched by Target then
	insert (ProductID,ProductName,Price)
	values (Source.ProductID,Source.ProductName,Source.Price);

	select * from Products_Current



CREATE TABLE Tree (
    id INT PRIMARY KEY,
    p_id INT
);
TRUNCATE TABLE Tree;

INSERT INTO Tree (id, p_id) VALUES (1, NULL);
INSERT INTO Tree (id, p_id) VALUES (2, 1);
INSERT INTO Tree (id, p_id) VALUES (3, 1);
INSERT INTO Tree (id, p_id) VALUES (4, 2);
INSERT INTO Tree (id, p_id) VALUES (5, 2);

select * from Tree


SELECT 
    t1.id,
    CASE 
        WHEN t1.p_id IS NULL THEN 'Root'
        WHEN t1.id IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree t1
ORDER BY t1.id;

-- Signups jadvalini yaratish
CREATE TABLE Signups (
    user_id INT PRIMARY KEY,
    time_stamp DATETIME
);

-- Confirmations jadvalini yaratish
CREATE TABLE Confirmations (
    user_id INT,
    time_stamp DATETIME,
    action VARCHAR(10) CHECK (action IN ('confirmed', 'timeout'))
);

-- Signups jadvalidagi ma'lumotlarni tozalash
TRUNCATE TABLE Signups;

-- Signups jadvaliga ma'lumot kiritish
INSERT INTO Signups (user_id, time_stamp) VALUES 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

-- Confirmations jadvalidagi ma'lumotlarni tozalash
TRUNCATE TABLE Confirmations;

-- Confirmations jadvaliga ma'lumot kiritish
INSERT INTO Confirmations (user_id, time_stamp, action) VALUES 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

select * from Signups
select * from Confirmations

SELECT 
    s.user_id,
    CAST(COUNT(CASE WHEN c.action = 'confirmed' THEN 1 END) AS FLOAT) /
    NULLIF(COUNT(c.action), 0) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id;


CREATE TABLE employees8 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

INSERT INTO employees8 (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

select * from employees8

SELECT *
FROM employees8
WHERE salary = (
    SELECT MIN(salary)
    FROM employees8
);


-- Products Table
CREATE TABLE Products8 (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

-- Sales Table
CREATE TABLE Sales5 (
    SaleID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products8(ProductID),
    Quantity INT,
    SaleDate DATE
);

INSERT INTO Products8 (ProductID, ProductName, Category, Price) VALUES
(1, 'Laptop Model A', 'Electronics', 1200),
(2, 'Laptop Model B', 'Electronics', 1500),
(3, 'Tablet Model X', 'Electronics', 600),
(4, 'Tablet Model Y', 'Electronics', 700),
(5, 'Smartphone Alpha', 'Electronics', 800),
(6, 'Smartphone Beta', 'Electronics', 850),
(7, 'Smartwatch Series 1', 'Wearables', 300),
(8, 'Smartwatch Series 2', 'Wearables', 350),
(9, 'Headphones Basic', 'Accessories', 150),
(10, 'Headphones Pro', 'Accessories', 250),
(11, 'Wireless Mouse', 'Accessories', 50),
(12, 'Wireless Keyboard', 'Accessories', 80),
(13, 'Desktop PC Standard', 'Computers', 1000),
(14, 'Desktop PC Gaming', 'Computers', 2000),
(15, 'Monitor 24 inch', 'Displays', 200),
(16, 'Monitor 27 inch', 'Displays', 300),
(17, 'Printer Basic', 'Office', 120),
(18, 'Printer Pro', 'Office', 400),
(19, 'Router Basic', 'Networking', 70),
(20, 'Router Pro', 'Networking', 150);

INSERT INTO Sales5 (SaleID, ProductID, Quantity, SaleDate) VALUES
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

select * from Products8
select * from Sales5

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        P.ProductName,
        SUM(S.Quantity) AS TotalQuantitySold,
        SUM(S.Quantity * P.Price) AS TotalSalesAmount,
        MIN(S.SaleDate) AS FirstSaleDate,
        MAX(S.SaleDate) AS LastSaleDate
    FROM Products8 P
    LEFT JOIN Sales5 S ON P.ProductID = S.ProductID
    WHERE P.ProductID = @ProductID
    GROUP BY P.ProductName;
END;

EXEC GetProductSalesSummary @ProductID = 1;
