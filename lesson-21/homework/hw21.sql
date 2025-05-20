--HW_21

--1)Write a query to assign a row number to each sale based on the SaleDate.

CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    SaleAmount DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CustomerID INT NOT NULL
);
INSERT INTO ProductSales (SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID)
VALUES 
(1, 'Product A', '2023-01-01', 148.00, 2, 101),
(2, 'Product B', '2023-01-02', 202.00, 3, 102),
(3, 'Product C', '2023-01-03', 248.00, 1, 103),
(4, 'Product A', '2023-01-04', 149.50, 4, 101),
(5, 'Product B', '2023-01-05', 203.00, 5, 104),
(6, 'Product C', '2023-01-06', 252.00, 2, 105),
(7, 'Product A', '2023-01-07', 151.00, 1, 101),
(8, 'Product B', '2023-01-08', 205.00, 8, 102),
(9, 'Product C', '2023-01-09', 253.00, 7, 106),
(10, 'Product A', '2023-01-10', 152.00, 2, 107),
(11, 'Product B', '2023-01-11', 207.00, 3, 108),
(12, 'Product C', '2023-01-12', 249.00, 1, 109),
(13, 'Product A', '2023-01-13', 153.00, 4, 110),
(14, 'Product B', '2023-01-14', 208.50, 5, 111),
(15, 'Product C', '2023-01-15', 251.00, 2, 112),
(16, 'Product A', '2023-01-16', 154.00, 1, 113),
(17, 'Product B', '2023-01-17', 210.00, 8, 114),
(18, 'Product C', '2023-01-18', 254.00, 7, 115),
(19, 'Product A', '2023-01-19', 155.00, 3, 116),
(20, 'Product B', '2023-01-20', 211.00, 4, 117),
(21, 'Product C', '2023-01-21', 256.00, 2, 118),
(22, 'Product A', '2023-01-22', 157.00, 5, 119),
(23, 'Product B', '2023-01-23', 213.00, 3, 120),
(24, 'Product C', '2023-01-24', 255.00, 1, 121),
(25, 'Product A', '2023-01-25', 158.00, 6, 122),
(26, 'Product B', '2023-01-26', 215.00, 7, 123),
(27, 'Product C', '2023-01-27', 257.00, 3, 124),
(28, 'Product A', '2023-01-28', 159.50, 4, 125),
(29, 'Product B', '2023-01-29', 218.00, 5, 126),
(30, 'Product C', '2023-01-30', 258.00, 2, 127);

select * from ProductSales
 

select p1.SaleDate, row_number() over ( order by SaleDate ) as rnk from ProductSales p1


--2)Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.


select
    ProductName,
    SUM(Quantity) AS TotalQuantitySold,
    dense_rank() over (order by sum(Quantity) desc) as ProductRank
from ProductSales
group by ProductName
order by ProductRank;


--3)Write a query to identify the top sale for each customer based on the SaleAmount.
;with RankedSales as (
    select
        SaleID,
        CustomerID,
        ProductName,
        SaleDate,
        SaleAmount,
        Quantity,
        row_number() over (partition by CustomerID order by SaleAmount desc) as rn
    from ProductSales
)
select *
from RankedSales
where rn = 1
order by CustomerID;




--4)Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.

select * from ProductSales

select *, lead(SaleAmount) over (partition by productname order by customerid) as ld from ProductSales

--5)Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.

select
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    lag(SaleAmount) over (order by SaleDate) as PreviousSaleAmount
from ProductSales
order by SaleDate


--SELECT
--    SaleID,
--    ProductName,
--    SaleDate,
--    SaleAmount,
--    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
--FROM ProductSales
--WHERE SaleAmount > LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate)
--ORDER BY ProductName, SaleDate;

--❗ Diqqat:
--SQL Server’da LAG() funksiyasidan WHERE ichida bevosita foydalanganda "analytic function cannot be used directly in 
--WHERE clause" degan xatolik chiqadi. Shuning uchun bu usulni subquery yoki CTE (Common Table Expression) yordamida yozamiz:

;WITH SalesWithPrevious AS (
    SELECT
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT *
FROM SalesWithPrevious
WHERE SaleAmount > PreviousSaleAmount
ORDER BY ProductName, SaleDate;

-------

--7)Write a query to calculate the difference in sale amount from the previous sale for every product

select 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    lag(SaleAmount) over (partition by ProductName order by SaleDate) as PreviousSaleAmount,
    SaleAmount - lag(SaleAmount) over (partition by ProductName order by SaleDate) as DifferenceFromPrevious
from ProductSales
order by ProductName, SaleDate;

-----

--8)Write a query to compare the current sale amount with the next sale amount in terms of percentage change.

select 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    lead(SaleAmount) over (partition by ProductName order by SaleDate) as NextSaleAmount,
    case
        when lead(SaleAmount) over (partition by ProductName order by SaleDate) is null then null
        when SaleAmount = 0 then null
        else round(
            ((lead(SaleAmount) over (partition by ProductName order by SaleDate) - SaleAmount) / SaleAmount) * 100,
            2
        )
    end as PercentageChangeToNext
from ProductSales
order by ProductName, SaleDate;


------
--9_Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    lag(SaleAmount) over (partition by ProductName order by SaleDate) as PreviousSaleAmount,
    case 
        when lag(SaleAmount) over (partition by ProductName order by SaleDate) is null then null
        else round(SaleAmount / lag(SaleAmount) over (partition by ProductName order by SaleDate), 4)
    end as RatioToPrevious
from ProductSales
order by ProductName, SaleDate;

---
--10)Write a query to calculate the difference in sale amount from the very first sale of that product.


select ps.CustomerID,
ps.ProductName,
ps.Quantity,
ps.SaleAmount,
ps.SaleDate, 
FIRST_VALUE(ps.SaleAmount) over (partition by ProductName order by SaleDate) as FirstAmount,
ps.SaleAmount - FIRST_VALUE(ps.SaleAmount) over (partition by ProductName order by SaleDate)  as DiffirenceFromFirst
from ProductSales ps
order by ps.ProductName, ps.SaleDate



 --11)Write a query to find sales that have been increasing continuously for a product 
 --(i.e., each sale amount is greater than the previous sale amount for that product).


;WITH SalesWithPrevious AS (
    SELECT
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT *
FROM SalesWithPrevious
WHERE SaleAmount > PreviousSaleAmount
ORDER BY ProductName, SaleDate;

--12)Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (
        PARTITION BY ProductName 
        ORDER BY SaleDate
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ClosingBalance
FROM ProductSales
ORDER BY ProductName, SaleDate;

--13)Write a query to calculate the moving average of sales amounts over the last 3 sales.


SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    -- 3 ta oxirgi sotuv asosida harakatdagi o'rtacha
    AVG(SaleAmount) OVER (
        ORDER BY SaleDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAverage3Sales
FROM ProductSales;

-------
--14)Write a query to show the difference between each sale amount and the average sale amount.

CREATE TABLE Employees9 (
    EmployeeID   INT PRIMARY KEY,
    Name         VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    HireDate     DATE
);

INSERT INTO Employees9 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'John Smith', 'IT', 60000.00, '2020-03-15'),
(2, 'Emma Johnson', 'HR', 50000.00, '2019-07-22'),
(3, 'Michael Brown', 'Finance', 75000.00, '2018-11-10'),
(4, 'Olivia Davis', 'Marketing', 55000.00, '2021-01-05'),
(5, 'William Wilson', 'IT', 62000.00, '2022-06-12'),
(6, 'Sophia Martinez', 'Finance', 77000.00, '2017-09-30'),
(7, 'James Anderson', 'HR', 52000.00, '2020-04-18'),
(8, 'Isabella Thomas', 'Marketing', 58000.00, '2019-08-25'),
(9, 'Benjamin Taylor', 'IT', 64000.00, '2021-11-17'),
(10, 'Charlotte Lee', 'Finance', 80000.00, '2016-05-09'),
(11, 'Ethan Harris', 'IT', 63000.00, '2023-02-14'),
(12, 'Mia Clark', 'HR', 53000.00, '2022-09-05'),
(13, 'Alexander Lewis', 'Finance', 78000.00, '2015-12-20'),
(14, 'Amelia Walker', 'Marketing', 57000.00, '2020-07-28'),
(15, 'Daniel Hall', 'IT', 61000.00, '2018-10-13'),
(16, 'Harper Allen', 'Finance', 79000.00, '2017-03-22'),
(17, 'Matthew Young', 'HR', 54000.00, '2021-06-30'),
(18, 'Ava King', 'Marketing', 56000.00, '2019-04-16'),
(19, 'Lucas Wright', 'IT', 65000.00, '2022-12-01'),
(20, 'Evelyn Scott', 'Finance', 81000.00, '2016-08-07');

select * from Employees9


select e9.EmployeeID,e9.Name,
e9.Department,e9.Salary, 
AVG(e9.Salary) over() as avg_salary,
e9.Salary - AVG(e9.Salary) over() as diffirence_salary from Employees9 e9

--15)Find Employees Who Have the Same Salary Rank

;with SalaryRanks as (
    select 
        EmployeeID,
        name,
        Department,
        Salary,
        rank() over (order by Salary desc) as SalaryRank
    from Employees9
)
select 
    EmployeeID,
    Name,
    Department,
    Salary,
    SalaryRank
from SalaryRanks
where SalaryRank IN (
    select SalaryRank
    from SalaryRanks
    group by SalaryRank
    having count(*) > 1
)
order by SalaryRank, Salary desc;


--16)Identify the Top 2 Highest Salaries in Each Department


with RankedSalaries as (
select        EmployeeID,
        name,
        Department,
        Salary,
        row_number() over (partition by Department order by  Salary desc) as rn
    from Employees9
)
select
    EmployeeID,
    Name,
    Department,
    Salary
from RankedSalaries
where rn <= 2
order by Department, Salary desc;


--17)Find the Lowest-Paid Employee in Each Department

select  *
from Employees9 E
where Salary = (
    select min(Salary)
    from Employees9
    where Department = E.Department
);



--18)Calculate the Running Total of Salaries in Each Department

select e9.Department, sum(e9.Salary) from Employees9 e9
group by e9.Department


select 
    EmployeeID,
    Name,
    Department,
    Salary,
    HireDate,
    sum(Salary) over (
        partition by Department 
        order by HireDate
    ) as RunningTotalSalary
from Employees9;

--19)Find the Total Salary of Each Department Without GROUP BY
select 
    EmployeeID,
    Name,
    Department,
    Salary,
    sum(Salary) over (partition by Department) as TotalSalaryPerDepartment
from Employees9;

--20)Calculate the Average Salary in Each Department Without GROUP BY

select 
    EmployeeID,
    Name,
    Department,
    Salary,
    avg(Salary) over (partition by Department) as total_avg
from Employees9;

--21)Find the Difference Between an Employee’s Salary and Their Department’s Average

select 
    EmployeeID,
    Name,
    Department,
    Salary,
    avg(Salary) over (partition by Department) as AvgDeptSalary,
    Salary - avg(Salary) over (partition by Department) as SalaryDifference
from Employees9;

--22)Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
select 
    EmployeeID,
    Name,
    Department,
    Salary,
    avg(Salary) over (
        order by EmployeeID
        rows between 1 preceding and 1 following
    ) as MovingAvgSalary
from Employees9;

--23)Find the Sum of Salaries for the Last 3 Hired Employees
select sum(Salary) as SumOfLast3Salaries
from (
    select Salary
    from Employees9
    order by HireDate desc
    OFFSET 0 rows fetch next 3 rows ONLY
) as Last3;
