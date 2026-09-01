create database amazon;
-- ● Task 1: Create an ER diagram for the Amazon Fresh database to understand the 
-- EER Diagram
-- Task 2: Identify the primary keys and foreign keys for each table and describe their relationships
-- EER Diagram
-- EER iagram
--  Task 3: Write a query to: 
-- Retrieve all customers from a specific city. & Fetch all products under the "Fruits" category

select * from amazon. customers
where city like "Port David";

select * from amazon. products
where category = "fruits";

-- Task 4: Write DDL statements to recreate the Customers table with the following constraints

-- 1 CustomerID as the primary key.
-- 2  Ensure Age cannot be null and must be greater than 18.
-- 3  Add a unique constraint for Name. 

alter table amazon.customers change customerid customerid varchar(100) primary key;
alter table amazon.customers modify age int not null check (age>18);
alter table amazon.customers add name varchar(100) unique;

--  Task 5: Insert 3 new rows into the Products table using INSERT statements. 
select * from amazon.products;
insert into amazon.products (productid,productname,category,subcategory,priceperunit,stockquantity,supplierid)
values (111,"donut","bakery","sub-bakery-1",300,500,0101),
(112,"kiwi","fruit","sub-fruit-4",200,3,0102),
(113,"milk","dairy","sub-dairy-3",70,5,0103);

--  Task 6: Update the stock quantity of a product where ProductID matches a specific ID. 
select * from amazon.products; 
set sql_safe_updates = 0;
update amazon.products set stockquantity = 300
where productID = "0006853b-74cb-44a2-91ed-699aa31c5b5b";

-- Task 7: Delete a supplier from the Suppliers table where their city matches a specific value. 

select * from amazon.suppliers;
delete from amazon.suppliers 
where city = "South Ana";

 -- Task 8: Use SQL constraints to:
-- 1 Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
-- 2 Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No"). 

select*from amazon.reviews;
alter table amazon.reviews ADD check (rating between 1 and 5);

select*from amazon.customers;
alter table amazon.customers modify PrimeMember varchar(150) default "No";

-- Task 9: Write queries using:
-- 1 WHERE clause to find orders placed after 2024-01-01.

select*from amazon.orders
where OrderDate >2024-01-01;

-- 2 HAVING clause to list products with average ratings greater than 4.

select p.productname, avg (v.Rating) from amazon.reviews as v
right join amazon.products as p
on v.ProductID=p.ProductID
group by p.productID,p.ProductName
having avg(v.Rating) > 4;

-- 3 GROUP BY and ORDER BY clauses to rank products by total sales. 

select orderID,customerID, sum(orderamount) as totalsale from amazon.orders
group by orderid,CustomerID
order by sum(orderamount) desc;

-- Task 10: Identifying High-Value Customers
-- Scenario:
-- Amazon Fresh wants to identify top customers based on their total spending. We will:
-- 1. Calculate each customer's total spending.
-- 2. Rank customers based on their spending.
-- 3. Identify customers who have spent more than ₹5,000. 

-- 1. Calculate each customer's total spending.
select c.name,o.customerid,sum(orderamount) as totalamount from amazon.orders as o
right join amazon.customers as c
on o.CustomerID = c.CustomerID
group by c.name,o.customerid;

-- 2. Rank customers based on their spending.
SELECT CustomerID, SUM(OrderAmount + DeliveryFee) AS total_amount, RANK() OVER (ORDER BY SUM(OrderAmount + DeliveryFee) DESC) AS amount_rank
FROM amazon.orders
GROUP BY CustomerID;

-- 3. Identify customers who have spent more than ₹5,000. 
select c.Name,c.CustomerID,sum(o.OrderAmount) as totalamount 
from amazon.customers as c
left join amazon.orders as o 
on c.CustomerID=o.CustomerID
group by c.Name,c.CustomerID
having sum(o.OrderAmount) > 5000
order by sum(o.OrderAmount) desc;


-- Task 11: Use SQL to:
-- 1. Join the Orders and OrderDetails tables to calculate total revenue per order.

select c.OrderID, o.CustomerID, sum(o.OrderAmount) from amazon.orders as o
right join amazon.order_details as c
on o.OrderID=c.OrderID
group by c.OrderID, o.CustomerID;

-- 2. Identify customers who placed the most orders in a specific time period.

SELECT CustomerID, COUNT(OrderID) AS OrderCount FROM amazon.orders 
WHERE OrderDate BETWEEN "2024-01-01" AND "2024-12-31"
GROUP BY CustomerID ORDER BY OrderCount DESC LIMIT 1;

-- 3. Find the supplier with the most products in stock. 

select SupplierID, sum(StockQuantity) as total_stock from amazon.products
group by SupplierID
order by total_stock desc
limit 1;

-- Task 12: Normalize the Products table to 3NF:
-- 1. Separate product categories and subcategories into a new table.

select *from amazon.products;
create table amazon.products01 (ProductID varchar(100),product_categories
varchar(100), subcategories varchar(100));
insert into amazon.products01 (product_categories, subcategories)
values ("Bakery","Sub-Bakery-1"), ("Dairy","Sub-Dairy-3"), ("Bakery","Sub-bakery-4"),("Snacks","Sub-Snacks-1"), ("Meat","Sub-Meat-4");
select *from amazon.products01;

 -- 2. Create foreign keys to maintain relationships
alter table amazon.products01 add column Productids varchar (100);
insert into amazon.products01(Productid) values ("0006853b-74cb-44a2-91ed-699aa31c5b5b"),
("0219aafa-5dbc-4d92-acd9-8a78b4158651"),("0297061c-1241-4540-ac99-ac6a44fa507e"),
("02c7c358-da33-4586-8e32-5e459b7394fc"),("030ff542-d5f3-4387-9654-90ae0e38702c");

--  Task 13: Write a subquery to:
-- 1.  Identify the top 3 products based on sales revenue.

select(select sum(OrderAmount)as total_sale from amazon.orders
order by total_sale desc ), ProductID, ProductName from amazon.products
group by ProductID, ProductName
limit 3;

-- 2. Find customers who haven’t placed any orders yet

select CustomerID from amazon.orders
where OrderID is null;
select (select CustomerID from amazon.orders
where OrderID is null), name from amazon.customers;

-- Task 14: Provide actionable insights:
-- 1.  Which cities have the highest concentration of Prime members?

select distinct city, count(PrimeMember) as count from amazon.customers
group by city
order by count desc;

-- 2.  What are the top 3 most frequently ordered categories? 

select Category, count(ProductID) as order_count from amazon.products
group by Category
order by count(ProductID) desc
limit 3;

