-- ***********************
-- Name: Harsh Patel
-- ID:146315205
-- Date: 16/02/2022
-- Purpose: Lab 4 DBS311
-- ***********************
-- Question 1 –. Display cities that no warehouse is located in them. (use set operators to answer this 
--question)
-- Q1 SOLUTION --
SELECT
  city 
FROM
  locations minus 
  SELECT
    l.city 
  FROM
    locations l,
    warehouses w 
  WHERE
    l.location_id = w.location_id;

-- ***********************

-- Question 2 – Display the category ID, category name, and the number of products in category 1, 2, 
--and 5. In your result, display first the number of products in category 5, then category 1 
--and then 2.
-- Q2 Solution –
SELECT
  p.category_id,
  pc.category_name,
  COUNT(p.category_id) AS COUNT 
FROM
  products p 
  JOIN
    product_categories pc 
    ON p.category_id = pc.category_id 
WHERE
  p.category_id IN 
  (
    1,
    2,
    5
  )
GROUP BY
  pc.category_name,
  p.category_id 
ORDER BY
  COUNT DESC;
-- ***********************

-- Question 3 – Display product ID for products whose quantity in the inventory is less than to 5. (You 
--are not allowed to use JOIN for this question.)

-- Q3 Solution –
SELECT
  product_id 
FROM
  inventories 
WHERE
  quantity < 5;
-- ***********************

-- Question 4 – We need a single report to display all warehouses and the state that they are located in 
--and all states regardless of whether they have warehouses in them or not. (Use set 
--operators in you answer.)

-- Q4 Solution –
SELECT
  warehouse_name,
  state 
FROM
  warehouses 
  LEFT JOIN
    locations 
    ON warehouses.location_id = locations.location_id 
  UNION
  SELECT
    warehouse_name,
    state 
  FROM
    warehouses 
    RIGHT JOIN
      locations 
      ON warehouses.location_id = locations.location_id;