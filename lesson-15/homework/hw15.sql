create database Hw_Works
use Hw_Works

--1) Find Employees with Minimum Salary
--Eng kam ish haqi bo'lgan xodimlarni toping
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);

select * from employees

select * from employees
where salary = ( select min(salary) from employees)

--2)Find Products Above Average Price
--O'rtacha narxdan yuqori mahsulotlarni toping
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

select * from products

select * from products where price > (select avg(price) from products)

--3)Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. 
--Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)
--Savdo bo'limida xodimlarni toping Vazifa: "Sotish" bo'limida ishlaydigan xodimlarni oling. 
--Jadvallar: xodimlar (ustunlar: id, ism, bo'lim_id), bo'limlar (ustunlar: id, bo'lim_nomi)

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees1 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees1 (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

select * from departments
select * from employees1

select  * from employees1
where department_id = ( select id from departments where department_name = 'Sales')

--4)Find Customers with No Orders
--Buyurtmasiz mijozlarni toping
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

select * from customers
where customer_id not in (select customer_id FROM orders)

--5)Find Products with Max Price in Each Category
--Har bir turkumda maksimal narxga ega mahsulotlarni toping

CREATE TABLE products1 (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products1 (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

select * from products1

select * from products1 p where price = (select max(price) from products1 where category_id = p.category_id)

--6)Find Employees in Department with Highest Average Salary
--Bo'limda eng yuqori o'rtacha ish haqi bo'lgan xodimlarni toping

CREATE TABLE departments1 (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees2 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments1 (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees2 (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);

select * from employees2
where department_id = (select top 1 department_id from employees2 group by department_id order by avg(salary) desc)

--7)Find Employees Earning Above Department Average
--Bo'lim o'rtachasidan yuqori daromad oladigan xodimlarni toping

CREATE TABLE employees3 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees3 (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

select * from employees3 e 
where salary > ( select avg(salary)from employees3
where department_id = e.department_id)

 --8)Find Students with Highest Grade per Course
 --Har bir kurs bo'yicha eng yuqori ball olgan talabalarni toping
 CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);

select * from students
select * from grades


select * from grades g where grade > (select avg(g.grade) from students s where s.student_id = g.student_id)



 --10)Find Employees whose Salary Between Company Average and Department Max Salary
 --Ish haqi kompaniyaning o'rtacha va bo'limning maksimal ish haqi o'rtasida bo'lgan xodimlarni toping

 CREATE TABLE employees4 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees4 (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

select  * from employees4 e where e.salary >= ( select avg(salary) from employees4)

