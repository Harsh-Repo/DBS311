-- ***********************
-- Student Name: Harsh Patel
-- Student ID:146315205
-- Date:18/02/2022
-- Purpose: Assignment 1 - DBS311
-- ***********************
-- Question 1 –. Display the employee number, full employee name, job title, and hire date of all 
--employees hired in September with the most recently hired employees displayed 
--first. 

-- Q1 SOLUTION -- 
SELECT
  employee_id AS "Employee Number",
  first_name || ' ' || last_name AS "Full Name",
  job_title AS "Job Title",
  to_char(hire_date, '[Month ddTH" of year "YYYY"]') AS "Start Date" 
FROM
  employees 
WHERE
  hire_date < '1-10-16' 
  AND hire_date > '31-8-16' 
ORDER BY
  hire_date DESC,
  employee_id;

-- Question 2 – The company wants to see the total sale amount per sales person (salesman) for all 
--orders. Assume that online orders do not have any sales representative. For online 
--orders (orders with no salesman ID), consider the salesman ID as 0. Display the 
--salesman ID and the total sale amount for each employee. 
--Sort the result according to employee number.
-- Q2 SOLUTION --
SELECT
  nvl(o.salesman_id, 0) AS "Employee Number",
  to_char(round(SUM(oi.total), 2), '$99,999,999.99') AS "Total Sale" 
FROM
  (
    SELECT
      order_id,
      SUM(quantity*unit_price) AS total 
    FROM
      order_items 
    GROUP BY
      order_id 
    ORDER BY
      order_id
  )
  oi 
  JOIN
    orders o 
    ON oi.order_id = o.order_id 
GROUP BY
  o.salesman_id 
ORDER BY
  "employee number" ASC;
 
-- Question 3 – . Display customer Id, customer name and total number of orders for customers that 
--the value of their customer ID is in values from 35 to 45. Include the customers with 
--no orders in your report if their customer ID falls in the range 35 and 45. 
--Sort the result by the value of total orders.
-- Q3 SOLUTION --

SELECT
  c.customer_id AS "Customer Id",
  name AS "Name",
  COUNT(o.order_id) AS "Total Orders" 
FROM
  customers c 
  FULL OUTER JOIN
    orders o 
    ON c.customer_id = o.customer_id 
WHERE
  c.customer_id BETWEEN 35 AND 45 
GROUP BY
  c.customer_id,
  name 
ORDER BY
  "Total Orders";

-- Question 4 – Display customer ID, customer name, and the order ID and the order date of all 
--orders for customer whose ID is 44.
--a. Show also the total quantity and the total amount of each customer’s order.
--b. Sort the result from the highest to lowest total order amount.

-- Q4 SOLUTION --

SELECT
  c.customer_id AS "Customer Id",
  name AS "Name",
  o.order_id,
  to_char( o.order_date, 'DD-MON-YY') AS "Order Date",
  to_char(round(SUM(oi.quantity* oi.unit_price), 2), '$99,999,999.99') AS "Total Amount" 
FROM
  (
(customers c 
    INNER JOIN
      orders o 
      ON c.customer_id = o.customer_id) 
    INNER JOIN
      order_items oi 
      ON oi.order_id = o.order_id
  )
WHERE
  c.customer_id = 44 
GROUP BY
  c.customer_id,
  name,
  o.order_id,
  o.order_date 
ORDER BY
  "Total Amount" DESC;

--Question 5 – Display customer Id, name, total number of orders, the total number of items 
--ordered, and the total order amount for customers who have more than 30 orders. 
--Sort the result based on the total number of orders.

-- Q5 SOLUTION --
SELECT
  c.customer_id AS "Customer Id",
  name AS "Name",
  COUNT(o.order_id)AS "Total Number of Orders",
  COUNT(oi.item_id) AS "Total Items",
  to_char(round(SUM(oi.quantity* oi.unit_price), 2), '$99,999,999.99') AS "Total Amount" 
FROM
  (
(customers c 
    INNER JOIN
      orders o 
      ON c.customer_id = o.customer_id) 
    INNER JOIN
      order_items oi 
      ON oi.order_id = o.order_id
  )
HAVING
  COUNT(o.order_id) > 30 
GROUP BY
  c.customer_id,
  name 
ORDER BY
  COUNT(o.order_id);

--Question 6 –Display Warehouse Id, warehouse name, product category Id, product category 
--name, and the lowest product standard cost for this combination.
--• In your result, include the rows that the lowest standard cost is less then $200.
--• Also, include the rows that the lowest cost is more than $500.
--• Sort the output according to Warehouse Id, warehouse name and then product 
--category Id, and product category name.

-- Q6 SOLUTION --

SELECT
  w.warehouse_id,
  w.warehouse_name,
  p.category_id,
  d.category_name,
  to_char( MIN(p.standard_cost), '$9,999.99')  AS "Lowest Cost"
FROM
  (
((warehouses w 
    INNER JOIN
      inventories i 
      ON w.warehouse_id = i.warehouse_id) 
    INNER JOIN
      products p 
      ON i.product_id = p.product_id) 
    INNER JOIN
      product_categories d 
      ON d.category_id = p.category_id
  )
GROUP BY
  w.warehouse_id,
  w.warehouse_name,
  p.category_id,
  d.category_name 
HAVING
  MIN(p.standard_cost) > 500 
  OR MIN(p.standard_cost) < 200 
ORDER BY
  w.warehouse_id;
 
 
 --Question 7 –Display the total number of orders per month. Sort the result from January to 
--December.

-- Q7 SOLUTION --

SELECT
  to_char(order_date, 'Month') AS "Month",
  COUNT(order_id) AS "Number Of Orders" 
FROM
  orders 
GROUP BY
  to_char(order_date, 'Month'),
  to_char(order_date, 'Mm') 
ORDER BY
  to_char(order_date, 'Mm');

-- Question 8 –. Display product Id, product name for products that their list price is more than any 
--highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located 
--outside the Americas regions. Then you need to return all products that their list 
--price is higher than any highest standard cost of those warehouses.)
--Sort the result according to list price from highest value to the lowest.
-- Q8 SOLUTION --

SELECT
  product_id AS "Product Id",
  product_name AS "Product Name",
  to_char(list_price, '$9,999.99') AS "Total Amount" 
FROM
  products 
WHERE
  list_price > ANY ( 
  SELECT
    MAX(p.standard_cost) 
  FROM
    products p 
    INNER JOIN
      inventories i 
      ON i.product_id = p.product_id 
    INNER JOIN
      warehouses w 
      ON i.warehouse_id = w.warehouse_id 
    INNER JOIN
      locations l 
      ON l.location_id = w.location_id 
    INNER JOIN
      countries c 
      ON l.country_id = c.country_id 
    INNER JOIN
      regions r 
      ON r.region_id = c.region_id 
      AND r.region_name != 'American' 
  GROUP BY
    i.warehouse_id ) 
  ORDER BY
    list_price DESC;

-- Question 9 – Write a SQL statement to display the most expensive and the cheapest product (list 
--price). Display product ID, product name, and the list price.

-- Q9 SOLUTION --
SELECT
  product_id AS "Product Id",
  product_name AS "Product Name",
  to_char(list_price, '$9,999.99')  AS "Price"
FROM
  products 
WHERE
  list_price = ANY (
  SELECT
    MAX(list_price) 
  FROM
    products 
  UNION
  SELECT
    MIN(list_price) 
  FROM
    products);

-- Question 10 – Write a SQL query to display the number of customers with total order amount over 
--the average amount of all orders, the number of customers with total order amount 
--under the average amount of all orders, number of customers with no orders, and 
--the total number of customers.
--See the format of the following result.
-- Q10 SOLUTION --

SELECT
  "customer report" 
FROM
  (
    SELECT
      'Number of customers with total purchase amount over average: ' || COUNT(*) AS "customer report",
      1 sortorder 
    FROM
      (
        SELECT
          c.customer_id,
          SUM(oi.quantity*oi.unit_price) AS total_amount 
        FROM
          customers c 
          INNER JOIN
            orders o 
            ON c.customer_id = o.customer_id 
          INNER JOIN
            order_items oi 
            ON oi.order_id = o.order_id 
        GROUP BY
          c.customer_id
      )
    WHERE
      total_amount > (
      SELECT
        AVG (quantity*unit_price) 
      FROM
        order_items) 
      UNION ALL
      SELECT
        'Number of customers with total purchase amount over average: ' || COUNT(*) AS "customer report",
        2 sortorder 
      FROM
        (
          SELECT
            c.customer_id,
            SUM(oi.quantity*oi.unit_price) AS total_amount 
          FROM
            customers c 
            INNER JOIN
              orders o 
              ON c.customer_id = o.customer_id 
            INNER JOIN
              order_items oi 
              ON oi.order_id = o.order_id 
          GROUP BY
            c.customer_id
        )
      WHERE
        total_amount < (
        SELECT
          AVG (quantity*unit_price) 
        FROM
          order_items) 
        UNION ALL
        SELECT
          concat('Number of customers with no orders: ', COUNT(customers) - COUNT(orders)) AS "customer report",
          3 sortorder 
        FROM
          (
            SELECT
              c.customer_id AS customers,
              SUM(o.order_id) AS orders 
            FROM
              customers c 
              LEFT JOIN
                orders o 
                ON c.customer_id = o.customer_id 
            GROUP BY
              c.customer_id
          )
        UNION ALL
        SELECT
          concat('Total number of customers: ', COUNT(customers)) AS "customer report",
          4 sortorder 
        FROM
          (
            SELECT
              c.customer_id AS customers,
              SUM(o.order_id) AS orders 
            FROM
              customers c 
              LEFT JOIN
                orders o 
                ON c.customer_id = o.customer_id 
            GROUP BY
              c.customer_id
          )
  )
ORDER BY
  sortorder;







