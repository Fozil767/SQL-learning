--HW_20

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

select * from #Sales

select distinct s1.CustomerName from #Sales s1
  where exists (select * from #Sales s2 where s1.CustomerName = s2.CustomerName and s1.SaleDate > '2024-03-01' and s1.SaleDate < '2024-04-01')

  ------
  --2) Find the product with the highest total sales revenue using a subquery.

  select Product, 
       sum(Quantity * Price) as TotalRevenue
from #Sales
group by Product
having sum(Quantity * Price) = (
    select max(TotalRevenue)
    from (
        select sum(Quantity * Price) as TotalRevenue
        from #Sales
        group by Product
    ) as RevenueByProduct
);

 --3)Find the second highest sale amount using a subquery

 select max(SaleAmount) as SecondHighestSale
from (
    select Quantity * Price as SaleAmount
    from #Sales
) as AllSales
where SaleAmount < (
    select max(Quantity * Price)
    from #Sales
);

--4. Find the total quantity of products sold per month using a subquery


select SaleMonth,  sum(totalquantity) as m_t_q from 
(select FORMAT(SaleDate, 'yyyy-MM') as SaleMonth, Quantity as totalquantity from #Sales ) as sub group by SaleMonth order by SaleMonth

--5. Find customers who bought same products as another customer using EXISTS

select distinct S1.CustomerName
from #Sales S1
where exists (
    select 1
    from #Sales S2
    where S1.Product = S2.Product
      and S1.CustomerName <> S2.CustomerName
);

--6. Return how many fruits does each person have in individual fruit level
create table Fruits1 (Name varchar(50), Fruit varchar(50))
insert into Fruits1 values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

select * from Fruits1

select  name, Fruit, count(*) as FruitCount from Fruits1 
group by name, Fruit
order by name, Fruit

--7. Return older people in the family with younger ones

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

select * from Family
-- Recursive CTE bilan barcha katta va kichiklar zanjirini topish
;with FamilyTree as (
    select ParentId, ChildID
    from Family
    union all
    select ft.ParentId, f.ChildID
    from FamilyTree ft
    join Family f on ft.ChildID = f.ParentId
)
select distinct ParentId as OlderPerson, ChildID as YoungerPerson
from FamilyTree
order by OlderPerson, YoungerPerson

--8. Write an SQL statement given the following requirements. 
--For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);


INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

select * from #Orders
SELECT *
from #Orders o
where o.DeliveryState = 'TX'
  AND EXISTS (
      select 1
      from #Orders o2
      where o2.CustomerID = o.CustomerID
        and o2.DeliveryState = 'CA'
  );

 --9)Insert the names of residents if they are missing

 create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

select * from #residents

update #residents
set address = concat(address, ' name=', fullname)
where address NOT LIKE '%name=%';

select * from #residents

--10)Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
--Toshkentdan Xorazmga boradigan marshrutni qaytarish uchun so'rov yozing. Natija eng arzon va eng qimmat yo'nalishlarni o'z ichiga olishi kerak

CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

select * from #Routes
--	|             Route                                 |Cost |
--|Tashkent - Samarkand - Khorezm                     | 500 |
--|Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm | 650 |

SELECT 
    r1.DepartureCity AS StartCity,
    r1.ArrivalCity AS MidCity,
    r2.ArrivalCity AS EndCity,
    (r1.Cost + r2.Cost) AS TotalCost
FROM #Routes r1
JOIN #Routes r2 ON r1.ArrivalCity = r2.DepartureCity
WHERE r1.DepartureCity = 'Tashkent' AND r2.ArrivalCity = 'Khorezm';

SELECT 
    r1.DepartureCity AS StartCity,
    r1.ArrivalCity AS MidCity1,
    r2.ArrivalCity AS MidCity2,
    r3.ArrivalCity AS EndCity,
    (r1.Cost + r2.Cost + r3.Cost) AS TotalCost
FROM #Routes r1
JOIN #Routes r2 ON r1.ArrivalCity = r2.DepartureCity
JOIN #Routes r3 ON r2.ArrivalCity = r3.DepartureCity
WHERE r1.DepartureCity = 'Tashkent' AND r3.ArrivalCity = 'Khorezm';


 --11)Rank products based on their order of insertion.

 CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

select * from #RankingPuzzle

select r1.ID,r1.Vals, rank() over (partition by Vals order by ID) from #RankingPuzzle r1 order by r1.ID,r1.Vals


--12)Find employees whose sales were higher than the average sales in their department

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

select * from #EmployeeSales

select * from #EmployeeSales where SalesAmount > (select AVG(SalesAmount) from #EmployeeSales)

--14)Find employees who made sales in every month using NOT EXISTS

CREATE TABLE Products9 (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products9 (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

select * from Products9

;WITH AllMonths AS (
    SELECT DISTINCT SalesMonth, SalesYear
    FROM #EmployeeSales
)

SELECT DISTINCT ES.EmployeeID, ES.EmployeeName
FROM #EmployeeSales ES
WHERE NOT EXISTS (

    SELECT 1
    FROM AllMonths AM
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales ES2
        WHERE ES2.EmployeeID = ES.EmployeeID
          AND ES2.SalesMonth = AM.SalesMonth
          AND ES2.SalesYear = AM.SalesYear
    )
)
ORDER BY ES.EmployeeID;


--15. Retrieve the names of products that are more expensive than the average price of all products.


select * from exmapdp tashkent and new york for french and chinas new collegas and notjes for company and hr assistment for me as
select * from #Sales s1 join #residents r1 on s1.Price = r1.resid 
select 
case when #Sales.Product > #Sales.Quantity th

from #Sales s1



--19. Find the products that have a higher price than the average price of their respective category.

select ProductID, ProductName, Category, Price
from Products6 p
where Price > (
    select avg(Price)
    from Products6
    where Category = p.Category
)
order by p.ProductID

--20. Find the products that have been ordered at least once.


