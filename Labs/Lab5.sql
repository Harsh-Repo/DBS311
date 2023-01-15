SET SERVEROUTPUT ON;

-- Q1 - EVEN_ODD

CREATE OR REPLACE PROCEDURE EVEN_ODD (IN num integer)
LANGUAGE SQL
BEGIN

   IF mod(num,2) = 0 THEN 
      CALL DBMS_OUTPUT.PUT_LINE('This is an even number');--
     
   ELSEIF mod(num,2) = 1 THEN 
      CALL DBMS_OUTPUT.PUT_LINE('This is an odd number');--
      
   ELSE
      CALL DBMS_OUTPUT.PUT_LINE('ERROR:  Bad Input');--   

   END IF;--

END;

-- Q2 - FIND_EMPLOYEE

CREATE OR REPLACE TYPE employeesRow AS ROW ANCHOR ROW OF employees;

CREATE OR REPLACE PROCEDURE FIND_EMPLOYEE (IN empno INTEGER)
LANGUAGE SQL
BEGIN

   DECLARE emp employeesRow;-- 

   SELECT * INTO emp FROM EMPLOYEES WHERE EMPLOYEE_ID = empno;--

   CALL DBMS_OUTPUT.PUT_LINE('First name: '||emp.first_name);--
   CALL DBMS_OUTPUT.PUT_LINE('Last name: '||emp.last_name);--
   CALL DBMS_OUTPUT.PUT_LINE('Email: '||emp.email);--
   CALL DBMS_OUTPUT.PUT_LINE('Phone: '||emp.phone);--
   CALL DBMS_OUTPUT.PUT_LINE('Hire Date: '||emp.hire_date);--
   CALL DBMS_OUTPUT.PUT_LINE('Job title: '||emp.job_title);--   

END;

-- Q3 - UPDATE PRICE BY CATEGORY

CREATE OR REPLACE PROCEDURE UPDATE_PRICE_BY_CAT (IN cat INTEGER, amount DECIMAL(9,2))
LANGUAGE SQL
BEGIN

   DECLARE norows INTEGER;--
   SET norows = (SELECT COUNT(*) FROM products WHERE category_id = cat AND list_price != 0);--
   UPDATE products SET list_price = list_price + amount WHERE category_id = cat AND list_price != 0;--
   CALL DBMS_OUTPUT.PUT_LINE('# rows updated: '|| norows);--

END;

-- Q4 - UPDATE PRICE UNDER AVERAGE

CREATE OR REPLACE PROCEDURE UPDATE_PRICE_UNDER_AVERAGE
LANGUAGE SQL
BEGIN

   DECLARE avgprice DECIMAL(9,2);--
   DECLARE norows INTEGER;--
   SET avgprice = (SELECT AVG(list_price) FROM products);--
   
   SET norows = (SELECT COUNT(*) FROM products WHERE list_price < avgprice);--   

   IF avgprice <= 1000.00 THEN 
      UPDATE products SET list_price = list_price * 1.02 WHERE list_price < avgprice;--
      CALL DBMS_OUTPUT.PUT_LINE('Average Price: '||avgprice||'.  '||norows||' below average price products updated by 2%');--
      
   ELSE
      UPDATE products SET list_price = list_price * 1.01 WHERE list_price < avgprice;--
      CALL DBMS_OUTPUT.PUT_LINE('Average Price: '||avgprice||'.  '||norows||' below average price products updated by 1%');--
   
   END IF;--

END;

-- Q5 - PRODUCT PRICE REPORT

CREATE OR REPLACE PROCEDURE PRODUCT_PRICE_REPORT
LANGUAGE SQL
BEGIN

   DECLARE avgprice DECIMAL(9,2);--
   DECLARE minprice DECIMAL(9,2);--
   DECLARE maxprice DECIMAL(9,2);--
   DECLARE cheap INTEGER;--
   DECLARE fair INTEGER;--
   DECLARE expensive INTEGER;--

   SET cheap = 0;--
   SET fair = 0;--
   SET expensive = 0;--

   SET avgprice = (SELECT AVG(list_price) FROM products);--
   SET minprice = (SELECT MIN(list_price) FROM products);--
   SET maxprice = (SELECT MAX(list_price) FROM products);--

   SET cheap = (SELECT COUNT(*) FROM products WHERE list_price < ((avgprice - minprice)/2));--
   SET fair = (SELECT COUNT(*) FROM products WHERE list_price >= ((avgprice - minprice)/2) AND list_price <= ((maxprice - avgprice)/2));--
   SET expensive = (SELECT COUNT(*) FROM products WHERE list_price > ((maxprice - avgprice)/2));--

   CALL DBMS_OUTPUT.PUT_LINE('Cheap: '||cheap);--
   CALL DBMS_OUTPUT.PUT_LINE('Fair: '||fair);--
   CALL DBMS_OUTPUT.PUT_LINE('Expensive: '||expensive);--

END;      
