--HW_22

--1)Compute Running Total Sales per Customer

CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

	select * from sales_data


select
    sale_id,
    customer_id,
    customer_name,
    order_date,
    total_amount,
    sum(total_amount) over (
        partition by customer_id
        order by order_date
        rows between unbounded preceding AND current row
    ) as running_total
from sales_data
order by customer_id, order_date;

--2)Count the Number of Orders per Product Category

select 
    product_category,
    count(*) as order_count
from sales_data
group by product_category
order by order_count desc;


--3)Find the Maximum Total Amount per Product Category

select * from sales_data

select sd.product_category,max(sd.total_amount) as max_total_amount from sales_data sd
group by sd.product_category
order by max_total_amount desc



--4)Find the Minimum Price of Products per Product Category

select s1.product_category,min(s1.unit_price) as min_price from sales_data s1
group by s1.product_category
order by min_price asc


--5)
--Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)

select *, avg(total_amount) over(order by order_date rows between 1 preceding and 1 following) from sales_data s1
order by s1.order_date


--6)Find the Total Sales per Region
select * from sales_data

select s1.region,sum(total_amount) as total_sales from sales_data s1
group by s1.region
order by total_sales desc


--7)Compute the Rank of Customers Based on Their Total Purchase Amount

select
    customer_id,
    customer_name,
    sum(total_amount) AS Total_Purchase,
    rank() over (order by sum(total_amount) desc) as Purchase_Rank
from sales_data
group by customer_id, customer_name
order by Purchase_Rank;


--8)Calculate the Difference Between Current and Previous Sale Amount per Customer

SELECT
    customer_id,
    customer_name,
    order_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS Previous_Amount,
    total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS Difference
FROM sales_data
ORDER BY customer_id, order_date;

--9)Find the Top 3 Most Expensive Products in Each Category

select * from sales_data


select *
from (
    select
        product_category,
        product_name,
        unit_price,
        rank() over (partition by product_category order by unit_price desc) as price_rank
    from sales_data
) as RankedProducts
where price_rank <= 3
order by product_category, price_rank;


--10)Compute the Cumulative Sum of Sales Per Region by Order Date

select *  from sales_data

select s1.region,sum(s1.total_amount) as total_date from sales_data s1
group by s1.region
order by total_date desc

--11)Compute Cumulative Revenue per Product Category

SELECT
    sale_id,
    product_category,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM sales_data
ORDER BY product_category, order_date;

--12)Here you need to find out the sum of previous values. Please go through the sample input and expected output.

-- Jadval yaratish
CREATE TABLE #SimpleIDTable (
    ID INT
);

-- Qiymatlarni qo‘shish
INSERT INTO #SimpleIDTable (ID) VALUES
(1),
(2),
(3),
(4),
(5);

select 
    id,
    sum(id) over (order by id rows between unbounded preceding and 0 preceding) as PreviousSum
from #SimpleIDTable;

--13)Sum of Previous Values to Current Value


CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

select * from OneColumn

select *, sum(o.Value) over(order by value rows between unbounded preceding and current row) as current_value from OneColumn o

--14)Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.
--For more details please check the sample input and expected output.

CREATE TABLE Row_Nums (
    Id INT,
    Vals VARCHAR(10)
);
INSERT INTO Row_Nums VALUES
(101,'a'), (102,'b'), (102,'c'), (103,'f'), (103,'e'), (103,'q'), (104,'r'), (105,'p');

select * from Row_Nums

select 
    Id,
    Vals,
    (row_number() over (partition by Id order by Vals) * 2) - 1 as RowNum
from Row_Nums;


--15)Find customers who have purchased items from more than one product_category

SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;


--16)Find Customers with Above-Average Spending in Their Region


with CustomerSpending as (
    select 
        customer_id,
        customer_name,
        region,
        sum(total_amount) as customer_total
    from sales_data
    group by customer_id, customer_name, region
),
RegionalAvg as (
    select 
        *,
        avg(customer_total) over (partition by region) as avg_region_total
    from CustomerSpending
)
select *
from RegionalAvg
where  customer_total > avg_region_total;



--17)Rank customers based on their total spending (total_amount) within each region.
--If multiple customers have the same spending, they should receive the same rank.

select * from sales_data


;with CustomerSpending as (
    select 
        customer_id,
        customer_name,
        region,
        sum(total_amount) as total_spending
    from sales_data
    group by customer_id, customer_name, region
)
select 
    customer_id,
    customer_name,
    region,
    total_spending,
    dense_rank() over (partition by region order by total_spending desc) as spending_rank
from CustomerSpending
order by region, spending_rank;



--18)Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.

select 
    customer_id,
    customer_name,
    order_date,
    total_amount,
    sum(total_amount) over (
        partition by customer_id 
        order by order_date
        rows between unbounded preceding and current row
    ) as cumulative_sales
from sales_data
order by customer_id, order_date;


--19)Calculate the sales growth rate (growth_rate) for each month compared to the previous month.

with monthly_sales as (
    select
        format(order_date, 'yyyy-MM') as sales_month,
        sum(total_amount) AS monthly_total
    from sales_data
    group by format(order_date, 'yyyy-MM')
)
select 
    sales_month,
    monthly_total,
    lag(monthly_total) over (order by sales_month) as prev_month_total,
    case 
        when lag(monthly_total) over (order by sales_month) is null then null
        else 
            round(
                100.0 * (monthly_total - lag(monthly_total) over (order by sales_month)) 
                / lag(monthly_total) over (order by sales_month), 2
            )
    end as growth_rate
from monthly_sales
orde by sales_month;

--20)Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)

with total_spent as (
    select 
        customer_id,
        customer_name,
        sum(total_amount) as total_amount_spent
    from sales_data
    group by customer_id, customer_name
),
last_order as (
    select 
        customer_id,
        total_amount AS last_order_amount,
        row_number() over (partition by customer_id order by order_date desc) as rn
    from sales_data
)
select 
    t.customer_id,
    t.customer_name,
    t.total_amount_spent,
    l.last_order_amount
from total_spent t
join last_order l on t.customer_id = l.customer_id
where l.rn = 1
  and t.total_amount_spent > l.last_order_amount;
