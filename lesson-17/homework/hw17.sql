--HW_17

 --1)You must provide a report of all distributors and their sales by region. If a distributor did not have any sales for a region, rovide a zero-dollar value for that day. 
 --Assume there is at least one sale for each region

 DROP TABLE IF EXISTS #RegionSales;
GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);

select * from #RegionSales order by Sales

with AllCombinations as (
    select r.Region, d.Distributor
    from (select distinct Region from #RegionSales) r
    cross join (select distinct Distributor from #RegionSales) d
)
select 
    ac.Region,
    ac.Distributor,
    isnull(rs.Sales, 0) as Sales
from AllCombinations ac
left join #RegionSales rs
    on ac.Region = rs.Region AND ac.Distributor = rs.Distributor
order by ac.Region, ac.Distributor;

--2. Find managers with at least five direct reports
CREATE TABLE Employee7 (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee7;
INSERT INTO Employee7 VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

select * from Employee7

select e1.id as manager_id, e1.name as manager_name, count(e2.id) from Employee7 e1 
join Employee7 e2 on e1.id = e2.managerId group by e1.id, e1.name having count(e2.id) >= 5

--3) Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
CREATE TABLE Products4 (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders2 (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products4;
INSERT INTO Products4 VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders2;
INSERT INTO Orders2 VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

select * from Products4
select * from Orders2

select p4.product_name, sum(o2.unit) as total_units from Products4 p4
join Orders2 o2 on p4.product_id = o2.product_id
where o2.order_date >= '2020-02-01' and o2.order_date < '2020-03-01' 
group by p4.product_name having sum(o2.unit) >=100

----4)Write an SQL statement that returns the vendor from which each customer has placed the most orders
--Har bir mijoz eng ko'p buyurtma bergan sotuvchini qaytaradigan SQL bayonotini yozing
CREATE TABLE Orders3 (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders3 VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

select * from Orders3

;with VendorCounts as (
    select 
        CustomerID,
        Vendor,
        count(*) as OrderCount
    from Orders3
    group by CustomerID, Vendor
),
RankedVendors as (
    select *,
           rank() over (partition by CustomerID order by OrderCount desc) as rnk
    from VendorCounts
)
select CustomerID, Vendor
from RankedVendors
where rnk = 1

--5. You will be given a number as a variable called @Check_Prime check if this number is prime then return
--'This number is prime' else eturn 'This number is not prime'
--DECLARE @Check_Prime INT = 91;
--create function prime 
--returns int
--as 
--begin
--if @Check_Prime / 2
-- print ('tub son')
-- else ('toq son')
-- select @Check_Prime() 

 DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;

IF @Check_Prime < 2
BEGIN
    SET @IsPrime = 0;
END
ELSE
BEGIN
    WHILE @i * @i <= @Check_Prime
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0;
            BREAK;
        END
        SET @i = @i + 1;
    END
END

IF @IsPrime = 1
    PRINT 'Prime';
ELSE
    PRINT 'Not Prime';

--6)Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.	

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');


select * from Device

--7)Write a SQL to find all Employees who earn more than the average salary in their corresponding department. Return EmpID, EmpName,Salary in your output
--Tegishli bo'limda o'rtacha maoshdan ko'proq maosh oladigan barcha Xodimlarni topish uchun SQL yozing. Chiqishingizda EmpID, EmpName, Maoshni qaytaring
CREATE TABLE Employee4 (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee4 VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

select * from Employee4

select 
  e.EmpID,
  e.EmpName,
  e.Salary
from Employee4 e
join (
    select DeptID, avg(Salary) as AvgSalary
    from Employee4
    group by DeptID
) d on e.DeptID = d.DeptID
where e.Salary > d.AvgSalary;



--8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. 
--If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. 
--Calculate the total winnings for today’s drawing.
CREATE TABLE WinningNumbers (Number INT);
INSERT INTO WinningNumbers VALUES (25), (45), (78);

CREATE TABLE Tickets (
    TicketID INT,
    Number INT
);
INSERT INTO Tickets VALUES
(1, 25), (1, 45), (1, 78),      -- Full match: $100
(2, 25), (2, 45), (2, 60),      -- Partial match (2 correct): $10
(3, 25), (3, 90), (3, 10),      -- Partial match (1 correct): $10
(4, 80), (4, 81), (4, 82);      -- No match: $0

select * from WinningNumbers
select * from Tickets

select
    TicketID,
    count(distinct t.Number) as MatchingCount,
    case 
        when count(distinct t.Number) = 3 then 100
        when count(distinct t.Number) >= 1 then 10
        else 0
    end as Prize
from Tickets t
join WinningNumbers w on t.Number = w.Number
group by TicketID;

