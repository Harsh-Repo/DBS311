-- ***********************
-- Name: HARSH PATEL 
-- ID: 146315205
-- Date: 2/2/2022
-- Purpose: Lab 2 DBS311
-- ***********************
-- Question 1 – For each job title display the number of employees. Sort the result according to the number of employees.

-- Q1 SOLUTION --
SELECT
  job_title,
  COUNT(*) AS "EMPLOYEES" 
FROM
  employees 
GROUP BY
  job_title 
ORDER BY
  "EMPLOYEES";
  
 -- *********************** 

 -- Question 2 –Display the highest, lowest, and average customer credit limits. Name these results high, 
low, and average. Add a column that shows the difference between the highest and the
lowest credit limits named “High and Low Difference”. Round the average to 2 decimal 
places.

-- Q2 SOLUTION --
SELECT
  MAX(credit_limit) AS "HIGH",
  MIN(credit_limit) AS "LOW",
  CAST(AVG(credit_limit) AS DECIMAL(10, 2)) AS "AVERAGE",
  MAX(credit_limit) - MIN(credit_limit) AS "High Low Difference" 
FROM
  customers;

-- ***********************
  
-- Question 3 – Display the order id, the total number of products, and the total order amount for orders 
with the total amount over $1,000,000. Sort the result based on total amount from the high 
to low values.
-- Q3 SOLUTION --
SELECT
  order_id,
  SUM(quantity) AS total_items,
  SUM(quantity*unit_price) AS total_amount 
FROM
  order_items 
GROUP BY
  order_id 
ORDER BY
  SUM(quantity*unit_price) DESC 
  FETCH first 9 ROWS ONLY;

-- ***********************
  
-- Question 4 – Display the warehouse id, warehouse name, and the total number of products for each 
warehouse. Sort the result according to the warehouse ID.

-- Q4 SOLUTION --
SELECT
  w.warehouse_id,
  warehouse_name,
  SUM(quantity) AS "TOTAL_PRODUCTS"
FROM
  inventories i 
  JOIN
    warehouses w 
    ON i.warehouse_id = w.warehouse_id 
GROUP BY
  w.warehouse_id,
  warehouse_name 
ORDER BY
  w.warehouse_id;

-- ***********************
  
 -- Question 5 – For each customer display customer number, customer full name, and the total number of 
orders issued by the customer.
 If the customer does not have any orders, the result shows 0.
 Display only customers whose customer name starts with ‘O’ and contains ‘e’.
 Include also customers whose customer name ends with ‘t’.
 Show the customers with highest number of orders first.

-- Q5 SOLUTION --
SELECT
  c.customer_id,
  c.name AS "customer name",
  COUNT(DISTINCT o.order_id) AS "total NO OF orders" 
FROM
  (
(customers c 
    LEFT JOIN
      orders o 
      ON c.customer_id = o.customer_id) 
    FULL OUTER JOIN
      order_items oi 
      ON oi.order_id = o.order_id
  )
WHERE
  (
    c.name LIKE 'O%e%' 
    OR c.name LIKE '%t'
  )
GROUP BY
  c.customer_id,
  c.name 
ORDER BY
  COUNT(o.order_id) DESC ;
  
  
  

-- ***********************
  
-- Question 6 –Write a SQL query to show the total and the average sale amount for each category. Round
the average to 2 decimal places.

-- Q6 SOLUTION --

CREATE view sales AS 
SELECT
  category_id,
  o.product_id,
  SUM(o.quantity* o.unit_price) AS amount 
FROM
  order_items o 
  JOIN
    products p 
    ON p.product_id = o.product_id 
GROUP BY
  o.product_id,
  category_id 
ORDER BY
  category_id;

SELECT
  category_id,
  SUM(amount) AS total_amount,
  CAST(AVG(amount) AS DECIMAL(10, 2)) AS average_amount
FROM
  sales 
GROUP BY
  category_id;
-- ***********************