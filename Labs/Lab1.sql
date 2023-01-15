-- ***********************
-- Name: Harsh Patel
-- ID: 146315205
-- Date: 25/01/2022
-- Purpose: Lab 1 DBS311
-- ***********************


-- Question 1--  Write a query to display the tomorrow’s date in the following format:
 January 10th of year 2019
the result will depend on the day when you RUN/EXECUTE this query. Label the column 
Tomorrow?.

-- Q1 SOLUTION --
   SELECT to_char(sysdate+1, 'Month" "dd"th of year "yyyy') AS "Tomorrow"
FROM dual;

-- Question 2-- Define an SQL variable called �tomorrow�, assign it a value of tomorrow�s date and use it 
in an SQL statement. Here the question is asking you to use a Substitution variable. Instead of 
using the constant values in your queries, you can use variables to store and reuse the values.

-- Q2 Solution --
define today_date = sysdate;
define tommorow = sysdate +1;
Select &tommorow from employees
Fetch FIRST 5 ROWS ONLY;

undefine today_date, tommorow;

-- ***********************

-- Question 3 -- For each product in category 2, 3, and 5, show product ID, product name, list price, and 
the new list price increased by 2%. Display a new list price as a whole number.
In your result, add a calculated column to show the difference of old and new list prices.
Sort the result according to category ID first and then based on product ID.
You output has to match the following result. This result is partially displayed as it has 158 
rows.
See the result for the first 10 rows.
 
-- Q3 Solution --
SELECT product_id, product_name, list_price, 
round (list_price * 1.02) AS "New price", 
(round (list_price * 1.02) - list_price) 
AS "Price Difference" 
FROM products 
WHERE category_id = 2 OR category_id = 3 OR category_id = 5 
ORDER BY category_id, product_id;

-- ***********************

-- Question 4 -- For employees whose manager ID is 2, write a query that displays the employee’s Full 
Name and Job Title in the following format:
Summer, Payne is Public Accountant.
Sort the result based on employee ID.

-- Q4 Solution--
SELECT last_name||', '||first_name||' is '||job_title AS "employee info" 
FROM employees 
WHERE manager_id=2 
ORDER BY employee_id;

-- ***********************

-- Question 5 -- For each employee hired before October 2016, display the employee’s last name, hire 
date and calculate the number of YEARS between TODAY and the date the employee was hired.
• Label the column Years worked. 
• Order your results by the number of years employed. Round the number of 
years employed up to the closest whole number.
 
-- Q5 Solution --
SELECT last_name, hire_date, round(((sysdate-hire_date)/365),0) AS "Years Worked"
FROM employees
ORDER BY  hire_date, "Years Worked";

-- ***********************
-- Question 6 -- Display each employee’s last name, hire date, and the review date, which is the first 
Tuesday after a year of service, but only for those hired after January 1, 2016. 
• Label the column REVIEW DAY. 
• Format the dates to appear in the format like:
 TUESDAY, August the Thirty-First of year 2016
You can use ddspth to have the above format for the day.
• Sort by review date

-- Q6 Solution --
SELECT 
last_name AS "last name", 
hire_date AS "hire DATE", 
to_char(next_day(hire_date + 366, 'TUESDAY'), 'DAY, Month" the "DdSpTh" of  
year "YYYY') AS "REVIEW DAY" 
FROM 
employees 
WHERE 
hire_date > to_date('16-01-01', 'YY-MM-DD') 
ORDER BY 
next_day(hire_date + 366, 'TUESDAY');

-- ***********************
-- Question 7 -- For all warehouses, display warehouse id, warehouse name, city, and state. For 
warehouses with the null value for the state column, display “unknown�?. Sort the result based 
on the warehouse ID.

-- Q7 Solution --
SELECT 
w.warehouse_id AS "Warehouse ID", 
w.warehouse_name AS "Warehouse Name", 
l.city AS "City", 
nvl(l.state, 'Unknown') AS "State" 
FROM 
warehouses w 
JOIN 
locations l 
ON w.location_id = l.location_id
ORDER BY 
w.warehouse_id;

-- ***********************
