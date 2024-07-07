SET SQL_SAFE_UPDATES = 0;

use market_star_schema;


-- Module: Database Design and Introduction to SQL
-- Session: Database Creation in MySQL Workbench
-- DDL Statements

-- 1. Create a table shipping_mode_dimen having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN

CREATE TABLE IF NOT EXISTS `shipping_mode_dimen`(
	`Ship_Mode` VARCHAR(25),
    `Vehicle_Company` VARCHAR(25),
    `Toll_Required` BOOLEAN
    );
    
DESC shipping_mode_dimen;  

-- 2. Make 'Ship_Mode' as the primary key in the above table.
ALTER TABLE `shipping_mode_dimen` ADD CONSTRAINT PRIMARY KEY(Ship_Mode);

DESC shipping_mode_dimen; 
-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false

INSERT INTO `shipping_mode_dimen` (`Ship_Mode`,`Vehicle_Company`,`Toll_Required`)
VALUES
('DELIVERY TRUCK', 'Ashok Leyland', FALSE), ('REGULAR AIR', 'Air India', FALSE);

SELECT *
FROM `shipping_mode_dimen`;

-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘Yes’.
UPDATE `shipping_mode_dimen` 
SET `Toll_Required`=TRUE 
WHERE `Ship_Mode`='DELIVERY TRUCK';

-- 3. Delete the entry for Air India.
DELETE FROM `shipping_mode_dimen`
WHERE `Vehicle_Company`='AIR_INDIA';

-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 
ALTER TABLE `shipping_mode_dimen`
ADD COLUMN `Vechicle_Number` VARCHAR(32);

desc `shipping_mode_dimen`;

-- 2. Update its value to 'MH-05-R1234'.
UPDATE `shipping_mode_dimen` SET `Vechicle_Number`='MH-05-R1234';

SELECT *
FROM `shipping_mode_dimen`;

-- 3. Delete the created column.
ALTER TABLE `shipping_mode_dimen`
DROP COLUMN `Vehicle_Company`;

SELECT *
FROM `shipping_mode_dimen`;
-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.
ALTER TABLE `shipping_mode_dimen`
CHANGE COLUMN `Toll_Required` `Toll_Amount` INTEGER;


-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.

DROP TABLE `shipping_mode_dimen`;

-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.
SELECT *
FROM cust_dimen;

-- 2. List the names of all the customers.
SELECT Customer_Name
FROM cust_dimen;

-- 3. Print the name of all customers along with their city and state.
SELECT Customer_Name, City, State
FROM cust_dimen;

-- 4. Print the total number of customers.
select count(*) as Total_Customers
from cust_dimen;

-- 5. How many customers are from West Bengal?
SELECT COUNT(*) AS Cust_West_Bengal
FROM cust_dimen
WHERE state='West Bengal';

-- 6. Print the names of all customers who belong to West Bengal.
SELECT Customer_Name, State
FROM cust_dimen
WHERE state='West Bengal';

-- -----------------------------------------------------------------------------------------------------------------
-- Operators

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.
SELECT Customer_Name
FROM cust_dimen
WHERE Customer_Segment='CORPORATE' OR state='Mumbai';

-- 2. Print the names of all corporate customers from Mumbai.
SELECT Customer_Name
FROM cust_dimen
WHERE  Customer_Segment='Corporate' AND state='Mumbai';


-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.
SELECT Customer_Name
FROM cust_dimen
WHERE State IN ('Tamil Nadu','Karnataka','Telengana','Kerala');

-- 4. Print the details of all non-small-business customers.
SELECT Customer_Name
FROM cust_dimen
WHERE Customer_Segment = 'SMALL BUSINESS';

-- 5. List the order ids of all those orders which caused losses.
SELECT COUNT(Ord_id)
FROM market_fact_full
WHERE Profit<0;

-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.
SELECT Ord_id
FROM market_fact_full
WHERE Ord_id LIKE '%\_5%'
AND Shipping_Cost BETWEEN 10 AND 15;

-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.
SELECT ROUND(SUM(Sales),1) AS Total_Sales
FROM market_fact_full;

-- 2. What are the total numbers of customers from each city?
SELECT City, COUNT(Cust_id) AS Total_Customers
FROM cust_dimen
GROUP BY City;

-- 3. Find the number of orders which have been sold at a loss.
SELECT COUNT(Ord_id)
FROM market_fact_full
WHERE Profit<0;

-- 4. Find the total number of customers from Bihar in each segment.
SELECT COUNT(Customer_Name),Customer_Segment
FROM cust_dimen
WHERE state = 'Bihar'
GROUP BY Customer_Segment;

-- 5. Find the customers who incurred a shipping cost of more than 50.
SELECT Cust_id
FROM market_fact_full
WHERE Shipping_Cost > 50;


-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.
SELECT Customer_Name
FROM cust_dimen
ORDER BY Customer_Name ASC;

-- 2. Print the three most ordered products.
                
SELECT Prod_id, SUM(Order_Quantity)
FROM market_fact_full
GROUP BY Prod_id
ORDER BY SUM(Order_Quantity) DESC
LIMIT 3;



-- 3. Print the three least ordered products.
SELECT Prod_id,
       SUM(Order_Quantity)
FROM market_fact_full
GROUP BY Prod_id
ORDER by SUM(Order_Quantity) ASC
LIMIT 3;
              

-- 4. Find the sales made by the five most profitable products.
SELECT ROUND(SUM(Sales)), Prod_id
FROM market_fact_full
GROUP BY Prod_id
HAVING SUM(Sales) < 4000
ORDER BY SUM(Sales) DESC
LIMIT 5;


-- 5. Arrange the order ids in the order of their recency.
SELECT Ord_id, DATE(Order_Date) AS order_date
FROM orders_dimen
ORDER BY order_date DESC
LIMIT 5;

-- 6. Arrange all consumers from Coimbatore in alphabetical order.
SELECT Customer_Name
FROM cust_dimen
WHERE City = 'Coimbatore'
ORDER BY Customer_Name ASC;

-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions

-- 1. Print the customer names in proper case.
SELECT CONCAT(
           UPPER(SUBSTRING(Customer_Name, 1, 1)),
           LOWER(SUBSTRING(Customer_Name, 2))
       ) AS Proper_Case_Customer_Name
FROM cust_dimen;

-- 2. Print the product names in the following format: Category_Subcategory.
SELECT CONCAT(Product_category,'_',Product_Sub_Category)
FROM prod_dimen;

-- 3. In which month were the most orders shipped?
SELECT MONTH(Ship_Date) AS ship_month, COUNT(*) AS Order_Count
FROM shipping_dimen
GROUP BY ship_month
ORDER BY Order_Count DESC;


-- 4. Which month and year combination saw the most number of critical orders?
SELECT COUNT(Ord_id) AS order_count, 
	  MONTH(Order_Date) AS order_month, 
      YEAR(Order_Date) AS order_year
FROM orders_dimen
WHERE Order_Priority = 'Critical'
GROUP BY order_year,order_month
ORDER BY order_count DESC;

-- 5. Find the most commonly used mode of shipment in 2011.
SELECT COUNT(ship_id) AS shipment_count,Ship_Mode
FROM shipping_dimen
GROUP BY Ship_Mode
ORDER BY shipment_count DESC;

-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.
SELECT Customer_Name
FROM cust_dimen
WHERE Customer_Name REGEXP 'car';


-- 2. Print customer names starting with A, B, C or D and ending with 'er'.
SELECT Customer_Name
FROM cust_dimen
WHERE Customer_Name REGEXP '^[ABCD].*er$';

-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales.
SELECT Ord_id, ROUND(Sales) AS rounded_sales
FROM market_fact_full
WHERE Sales = (
                      SELECT MAX(Sales)
                      FROM market_fact_full
                      );


-- 2. Return the product categories and subcategories of all the products which don’t have details about the product
-- base margin.
SELECT Prod_id
FROM market_fact_full
WHERE Product_Base_Margin is NULL;

SELECT *
FROM prod_dimen
WHERE Prod_id IN (
                 SELECT Prod_id
                 FROM market_fact_full
                 WHERE Product_Base_Margin is null
                 );


-- 3. Print the name of the most frequent customer.
SELECT cust_id, customer_Name
FROM cust_dimen
WHERE cust_id IN (
                  SELECT  cust_id
                  FROM market_fact_full
                  GROUP BY cust_id
                  ORDER BY COUNT(Order_Quantity) desc
                  );


-- 4. Print the three most common products.
SELECT Prod_id
FROM prod_dimen
WHERE Prod_id IN (
                 SELECT Prod_id
                 FROM market_fact_full
                 group by Prod_id
                 ORDER BY count(Prod_id)
                 );

-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base
-- margin among these?
with least_losses as (
          select Prod_id, Profit, Product_Base_Margin
          from market_fact_full
          where Profit < 0
          order by Profit desc
)
          select *
          from least_losses 
          where Product_Base_Margin = (
                                       select max(Product_Base_Margin)
                                       from least_losses
                                       );
          
-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?
WITH low_priority_orders AS (
    SELECT Ord_id, Order_Priority, Order_Date
    FROM orders_dimen
    WHERE MONTH(Order_Date) = 4 AND Order_Priority = 'low'
)
SELECT COUNT(Ord_id) AS order_count
FROM low_priority_orders
WHERE DAY(Order_Date) <= 15;
				

-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.
 create view profit_greater_than_1000
 As select Ord_id,Sales, Order_Quantity,Profit,Shipping_Cost
 from market_fact_full;

select Ord_id, Profit
from profit_greater_than_1000
where Profit > 1000;

-- 2. Which year generated the highest profit?
create view highest_profit_year
as select year(order_date) as year_top_profit,
          sum(profit) as total_profit
from market_fact_full as m
left join orders_dimen as o
using(ord_id)
group by year(order_date);

select year_top_profit
from highest_profit_year
order by total_profit desc
limit 1;




-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join

-- 1. Print the product categories and subcategories along with the profits made for each order.
select Ord_id,Product_Category, Product_Sub_Category,Profit
from prod_dimen as p
inner join market_fact_full as m
on p.Prod_id = m.Prod_id;

-- 2. Find the shipment date, mode and profit made for every single order.
select Ord_id, Ship_Date, Ship_Mode, Profit
from shipping_dimen s
inner join market_fact_full m
using(Ship_id);

-- 3. Print the shipment mode, profit made and product category for each product.
select Ord_id, product_category,Ship_Mode, Profit
from prod_dimen p
inner join market_fact_full m
using(Prod_id)
inner join shipping_dimen s
using(Ship_id);

-- 4. Which customer ordered the most number of products?
select customer_name, count(order_quantity) as total_count
from cust_dimen as c
inner join market_fact_full as m
using(Cust_id)
group by customer_name
order by total_count desc
limit 1;

-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?
SELECT product_category, city, sum(profit) AS total_profit
FROM prod_dimen AS p
INNER JOIN market_fact_full AS m USING(prod_id)
INNER JOIN cust_dimen AS c USING(cust_id)
WHERE product_category = 'Office Supplies' and city in ('Delhi','Patna')
GROUP BY city
ORDER BY total_profit desc;

-- 6. Print the name of the customer with the maximum number of orders.
select customer_name, count(order_quantity) as total_quantity
from cust_dimen c 
inner join market_fact_full m 
using(cust_id)
group by customer_name
order by total_quantity desc;

-- 7. Print the three most common products.
select product_category, count(sales) as product_sales
from prod_dimen p
inner join market_fact_full m 
using(prod_id) 
group by product_category
order by product_sales desc
limit 3;

-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.
select ord_id
from market_fact_full;

-- Execute the below queries before solving the next question.
drop table manu;

create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

select *
from prod_dimen;

-- 2. Display the products sold by all the manufacturers using both inner and outer joins.
select *
from manu;

select distinct manu_id
from prod_dimen;

select product_category, prod_id, manu_name
from prod_dimen p
inner join manu
using(manu_id);
 
select product_category, prod_id, manu_name
from prod_dimen p
left join manu
using(manu_id);

 
select product_category, prod_id, manu_name
from prod_dimen p
right join manu
using(manu_id);

-- 3. Display the number of products sold by each manufacturer.
select count(order_quantity) as total_products, manu_name
from prod_dimen p 
inner join market_fact_full mf
using(prod_Id)
inner join manu m 
using(manu_id)
group by manu_name
order by total_products;


-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.

CREATE OR REPLACE VIEW info_table AS
SELECT 
    c.customer_name, 
    c.customer_segment, 
    m.sales, 
    p.product_category, 
    p.product_sub_category,
    m.order_quantity
FROM cust_dimen c 
INNER JOIN market_fact_full m USING(cust_id)
INNER JOIN prod_dimen p USING(prod_id);

select *
from info_table;

SELECT 
    customer_name, 
    customer_segment,
    SUM(order_quantity) AS total_quantity
FROM info_table
WHERE product_sub_category IN ('Pens', 'Art Supplies')
GROUP BY customer_name, customer_segment
HAVING total_quantity > 20;

-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.

(SELECT ord_id 
FROM orders_dimen)
UNION ALL
(SELECT order_number as ord_id 
FROM shipping_dimen);

-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.
(select distinct ord_id As ord_id
from orders_dimen)
union
(select distinct order_number as ord_id
from shipping_dimen);


-- 3. Find the shipment details of products with no information on the product base margin.



-- 4. What are the two most and the two least profitable products?
(select prod_id, sum(profit) as prod_profit
from market_fact_full
group by prod_id
order by prod_profit desc
limit 2)
union
(select prod_id, sum(profit) as prod_profit
from market_fact_full
group by prod_id
order by prod_profit asc
limit 2);

-- -----------------------------------------------------------------------------------------------------------------
select * 
from market_fact_full;

-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- 1. Rank the orders made by AARON BERGMAN in the decreasing order of the resulting sales.
select c.customer_name, m.ord_id, round(m.Sales) as rounded_sales,
       rank() over(PARTITION BY c.customer_name order by Sales desc) As sales_rank
from
market_fact_full AS m
left JOIN cust_dimen AS c
ON m.cust_id = c.cust_id
where customer_name='AARON BERGMAN';

-- Testing Data --
select *
from cust_dimen
where customer_name='AARON BERGMAN';

select *
from market_fact_full
where cust_id in ('Cust_1332','Cust_1345','Cust_1763','Cust_1765','Cust_462','Cust_463');

select *
from market_fact_full;

select customer_name
from market_fact_full
left join cust_dimen 
using(cust_id)
where ord_id = 'Ord_5446'; 

-- above test data code --


-- 2. For the above customer, rank the orders in the increasing order of the discounts
-- provided. Also display the dense ranks.
select customer_name,
       ord_id,Discount,
       dense_rank() over(order by Discount asc) as dense_rank_discounts
from market_fact_full as m
left join cust_dimen as C
using(Cust_id)
where customer_name = 'AARON BERGMAN';


-- 3. Rank the customers in the decreasing order of the number of orders placed.
select customer_name, 
      order_quantity,
      rank() over(order by order_quantity desc) as rank_order_quantity,
      dense_rank() over(order by order_quantity desc) as dense_rank_order_quantity,
      percent_rank() over(order by order_quantity desc) as percent_rank_order_quantity,
      row_number() over(order by order_quantity desc) as row_number_order_quantity
from market_fact_full as m
left join cust_dimen as c
using(cust_id);


-- 4. Create a ranking of the number of orders for each mode of shipment based on 
-- the months in which they were shipped. 
SELECT ship_mode, 
       MONTH(order_date) AS order_month,
       COUNT(ord_id) AS order_count,
       RANK() OVER(PARTITION BY ship_mode ORDER BY COUNT(ord_id) DESC) AS rank_order_quantity
FROM market_fact_full AS m
LEFT JOIN shipping_dimen AS s USING(ship_id)
LEFT JOIN orders_dimen AS o USING(ord_id)
GROUP BY ship_mode, order_month;



-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by
-- Aaron Smayling. Also display the row number for each order.
       
SELECT 
    customer_name,
    COUNT(ord_id) AS order_count,
    shipping_cost,
    RANK() OVER w AS rank_shipping_cost
FROM market_fact_full AS m
INNER JOIN cust_dimen AS c 
USING (cust_id)
WHERE customer_name = 'Aaron Smayling'
GROUP BY customer_name, shipping_cost
window w as (ORDER BY shipping_cost ASC)
ORDER BY shipping_cost ASC;

-- Rank the customers  based on the discounts using window function
select ord_id,
       discount,
       customer_name,
       rank() over w as disc_rank,
       dense_rank() over w as disc_dense_rank,
       row_number() over w as disc_row_num
from market_fact_full as m
inner join cust_dimen as c
using(cust_id)
window w as (partition by customer_name order by discount desc)
limit 5;

-- ---------------- sample----------
WITH shipping_counts AS (
    SELECT *,
           COUNT(*) OVER (PARTITION BY ship_mode) AS ship_mode_count
    FROM shipping_dimen
)
SELECT *,
       RANK() OVER w AS rank_shipmode,
       DENSE_RANK() OVER w AS dense_rank_shipmode,
       PERCENT_RANK() OVER w AS percent_rank_shipmode
FROM shipping_counts
WINDOW w AS (
             PARTITION BY ship_mode
             ORDER BY ship_mode_count
);

     
-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the 
-- year 2011.
with shipping_summary_2011 as
(
select ord_id, shipping_cost,
       month(order_date) as order_month
from market_fact_full as m
inner join shipping_dimen as s
using(ship_id)
inner join orders_dimen as o
using(ord_id)
where year(ship_date)='2011'
)
select *,
       avg(shipping_cost) over w as moving_average
from shipping_summary_2011
window w as (order by order_month rows 6 preceding);
 

WITH shipping_summary_2011 AS (
SELECT ord_id,
	   shipping_cost,
	   MONTH(order_date) AS order_month
FROM market_fact_full AS m
INNER JOIN shipping_dimen AS s USING (ship_id)
INNER JOIN orders_dimen AS o USING (ord_id)
WHERE YEAR(ship_date) = 2011
)
SELECT order_month,
    AVG(shipping_cost) OVER w AS moving_average
FROM shipping_summary_2011
window w as (
        ORDER BY order_month 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
);

-- Frames: calculate the running total and moving average for the ship date. 
with daily_shipping_summary as
(
select ship_date,
       sum(shipping_cost) as daily_total
from market_fact_full as m
inner join shipping_dimen as s
using(ship_id)
group by ship_date
)
select *,
       sum(daily_total) over w1 as running_total,
       avg(daily_total) over w2 as moving_avg
from daily_shipping_summary
window w1 as (order by ship_date rows unbounded preceding),
w2 as (order by ship_date rows 6 preceding);

-- Lead and Lag
-- Fetch the frequency of the order details of customer 'Rick Wilson'

with customer_order as
(
select c.customer_name, 
       m.ord_id, 
       o.order_date
from market_fact_full as m
inner join orders_dimen as o
using(ord_id)
inner join cust_dimen as c
using(cust_id)
where customer_name = 'Rick Wilson'
group by m.ord_id,o.order_date
),
next_date_summary as 
(
select *,
       lead(order_date,1,'2015-01-01') over (order by order_date,ord_id) as next_order_date
from customer_order
order by order_date,ord_id
)
select *,
       datediff(next_order_date,order_date) as days_diff
from next_date_summary;



-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.
select ord_id,
       Profit,
       case 
          when Profit < 0 then "Not Profitable"
          else "Profitable"
		end as Profit_type
from market_fact_full;
        
 -- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

select market_fact_id,
       profit,
       case
			when profit < -500 then "Huge Loss"
            when profit between -500 and 0 then "Bearable Loss"
            when profit between 0 and 500 then "Decent profit"
            else "Great Profit"
		end as profit_status
from market_fact_full;


-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze

with customer_summary as
(
select m.cust_id,
       c.customer_name,
       round(sum(m.sales)) as total_sales,
       percent_rank() over(order by round(sum(sales)) desc) as perc_rank
from market_fact_full as m
left join cust_dimen as c
using(cust_id)
group by cust_id
)
select *,
      case 
	      when perc_rank < 0.2 then "Gold"
          when perc_rank <0.35 then "Silver"
          else "Bronze"
	 end as customer_classification
from customer_summary;


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

DELIMITER $$

CREATE FUNCTION profitType(profit INT)
RETURNS VARCHAR(30) DETERMINISTIC

BEGIN 
    DECLARE message VARCHAR(30);

    IF profit < -500 THEN 
        SET message = 'Huge Loss';
    ELSEIF profit BETWEEN -500 AND -1 THEN
        SET message = 'Bearable Loss';
    ELSEIF profit BETWEEN 0 AND 500 THEN
        SET message = 'Decent Profit';
    ELSE 
        SET message = 'Great Profit';
    END IF;

    RETURN message;
END;
$$

DELIMITER ;

select profitType(20) as func_output;


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Procedures

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?


DELIMITER $$
CREATE PROCEDURE get_sales_customers(sales_input INT)
BEGIN
    SELECT DISTINCT cust_id,
                    ROUND(sales) AS sales_amount
    FROM market_fact_full
    WHERE ROUND(sales) > sales_input
    order by cust_id;
END $$

DELIMITER ;

drop procedure get_sales_customers;

call get_sales_customers(1);