-- ***********************
-- Name: Harsh Patel
-- ID:146315205
-- Date: 8/02/2022
-- Purpose: Lab 3 DBS311
-- ***********************
-- Question 1 – Write a SQL query to display the last name and hire date of all employees who were hired before the 
--employee with ID 107 got hired but after March 2016. Sort the result by the hire date and then 
--employee ID
-- Q1 SOLUTION --
Select last_name, to_char(hire_date,'DD-MON-YYYY') AS hire_date
from employees
where (hire_date < '07-06-16' AND hire_date > '31-03-16' AND employee_id < '107')
order by hire_date, employee_id;

-- ***********************

-- Question 2 – Write a SQL query to display customer name and credit limit for customers with lowest credit limit. Sort 
--the result by customer ID.
-- Q2 Solution –
SELECT name, credit_limit
FROM customers
WHERE credit_limit = (SELECT min(credit_limit) FROM Customers);

-- ***********************

-- Question 3 – Write a SQL query to display the product ID, product name, and list price of the highest paid product(s) 
--in each category. Sort by category ID and the product ID.
-- Q3 Solution –

SELECT category_id, product_id, product_name,list_price
from products
WHERE list_price IN (SELECT max(list_price) from products group by category_id )
order by category_id, product_id; 

-- ***********************

-- Question 4 – Write a SQL query to display the category ID and the category name of the most expensive (highest list 
--price) product(s).
-- Q4 Solution –
SELECT p.category_id, category_name
FROM products p
JOIN product_categories pc ON p.category_id = pc.category_id
WHERE list_price =(SELECT max(list_price)FROM products);

-- ***********************

-- Question 5 –Write a SQL query to display product name and list price for products in category 1 which have the list 
--price less than the lowest list price in ANY category. Sort the output by top list prices first and then by 
--the product ID.
-- Q5 Solution – 
SELECT product_name, list_price
FROM products
WHERE (category_id = '1') AND (list_price < ANY
(SELECT min(list_price)
FROM products
GROUP BY category_id))
ORDER BY list_price DESC, product_id;

-- ***********************

-- Question 6-- Display the maximum price (list price) of the category(s) that has the lowest price product.
-- Q6 Solution –

SELECT  max(list_price)
FROM products
WHERE (category_id,list_price) NOT IN
(SELECT category_id, min(list_price)
FROM products
GROUP BY category_id);

-- ***********************
 






