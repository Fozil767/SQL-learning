--HW_18
--You're working in a database for a Retail Sales System. The database contains the following tables:
CREATE TABLE Products6 (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales1 (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products6(ProductID)
);

INSERT INTO Products6 (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales1 (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

select * from Products6
select * from Sales1

select  ProductName
from Products6
where ProductID = (
    select top 1 ProductID
    from Sales1
    group by ProductID
    order by sum(Quantity) desc
);
select *
from Products6
where Price = (
    select max(Price)
    from Products6
    where Category = 'Electronics'
);
--3)Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
create view vw_ProductSalesSummary as
select 
    p.ProductID,
    p.ProductName,
    p.Category,
    isnull(sum(s.Quantity), 0) as TotalQuantitySold
from Products6 p
LEFT JOIN Sales1 s on p.ProductID = s.ProductID
group by 
    p.ProductID,
    p.ProductName,
    p.Category;

	select * from vw_ProductSalesSummary
	--3) Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
create function fn_GetTotalRevenueForProduct (@ProductID INT)
returns decimal(18,2)
as
begin
    declare @TotalRevenue decimal(18,2);

    select @TotalRevenue = sum(s.Quantity * p.Price)
    from Sales1 s
    join Products6 p on s.ProductID = p.ProductID
    where s.ProductID = @ProductID;

    return isnull(@TotalRevenue, 0);
end;

select dbo.fn_GetTotalRevenueForProduct(1) as TotalRevenue;

--4)Create an function fn_GetSalesByCategory(@Category VARCHAR(50))

create function fn_GetSalesByCategory (@Category varchar(50))
returns table
as
return
(
    select 
        p.ProductName,
        sum(s.Quantity) as TotalQuantity,
        sum(s.Quantity * p.Price) as TotalRevenue
    from Products6 p
    join Sales1 s on p.ProductID = s.ProductID
    where p.Category = @Category
    group by p.ProductName
);

select * from fn_GetSalesByCategory('Electronics');


--5)You have to create a function that get one argument as input from user and the function should return 
--'Yes' if the input number is a prime number and 'No' otherwise. You can start it like this:
CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @IsPrime VARCHAR(3)
    IF @Number < 2
    BEGIN
        RETURN 'No'
    END

    DECLARE @i INT = 2
    SET @IsPrime = 'Yes'

    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
        BEGIN
            SET @IsPrime = 'No'
            BREAK
        END
        SET @i = @i + 1
    END

    RETURN @IsPrime
END

SELECT dbo.fn_IsPrime(7)   
SELECT dbo.fn_IsPrime(10)  


 --6)Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:

CREATE FUNCTION dbo.fn_GetNumbersBetween
(
    @Start INT,
    @End INT
)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @Current INT = @Start

    WHILE @Current <= @End
    BEGIN
        INSERT INTO @Numbers (Number)
        VALUES (@Current)

        SET @Current = @Current + 1
    END

    RETURN
END

select * from dbo.fn_GetNumbersBetween(1, 20)

--7. Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct salaries, return NULL.
declare @N int = 2;

with RankedSalaries AS (
    select distinct salary,
           dense_rank() over (order by salary desc) as salary_rank
    from Employee
)
select salary
from RankedSalaries
where salary_rank = @N;

--8)Write a SQL query to find the person who has the most friends.
WITH AllFriends AS (
    SELECT requester_id AS user_id FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS user_id FROM RequestAccepted
),
FriendCounts AS (
    SELECT user_id, COUNT(*) AS total_friends
    FROM AllFriends
    GROUP BY user_id
)
SELECT user_id, total_friends
FROM FriendCounts
ORDER BY total_friends DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;


