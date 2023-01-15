SET SERVEROUTPUT ON;

-- Q1 - FACTORIAL

CREATE OR REPLACE PROCEDURE FACTORIAL (IN num integer)
LANGUAGE SQL
BEGIN

   DECLARE fact INTEGER;--
   DECLARE count INTEGER;--

   SET count = num;--
   SET fact = 1;--

   WHILE count > 1 DO
      SET fact = fact * count;--
      SET count = count - 1;--
   END WHILE;--

   IF num = 0 or num = 1 THEN
      CALL DBMS_OUTPUT.PUT_LINE(num || '! = 1');--
   ELSE
      CALL DBMS_OUTPUT.PUT_LINE(num || '! = ' || fact);--
   END IF;--

END;

-- Q2 - CALCULATE SALARY

CREATE OR REPLACE TYPE empRow AS ROW ANCHOR ROW OF employees;

CREATE OR REPLACE PROCEDURE CALCULATE_SALARY (IN emp_no INTEGER)
LANGUAGE SQL
BEGIN

   DECLARE salemp empRow;-- 
   DECLARE total_sal INTEGER;--
   DECLARE num_years INTEGER;--

   SET total_sal = 10000;--
       
   SELECT * INTO salemp FROM EMPLOYEES WHERE EMPLOYEE_ID = emp_no;--

   SET num_years = year(current_date)-year(salemp.hire_date);--

   WHILE num_years > 1 DO
      SET total_sal = total_sal * 1.05;--
      SET num_years = num_years - 1;--
   END WHILE;--

   CALL DBMS_OUTPUT.PUT_LINE('First Name: ' || salemp.first_name);--
   CALL DBMS_OUTPUT.PUT_LINE('Last Name: ' || salemp.last_name);--
   CALL DBMS_OUTPUT.PUT_LINE('Salary: $' || total_sal);--

END;

-- Q3 - WAREHOUSE REPORT

CREATE OR REPLACE TYPE locRow AS ROW ANCHOR ROW OF locations;

CREATE OR REPLACE PROCEDURE WAREHOUSE_REPORT
LANGUAGE SQL
BEGIN

   DECLARE locrec locRow;-- 
   DECLARE wh_id INTEGER;--
   DECLARE loc_id INTEGER;--
   DECLARE wh_name CHAR(25);--

   SET wh_id = 1;--
       
   WHILE wh_id < 10 DO
      
      SELECT warehouse_name INTO wh_name FROM warehouses WHERE warehouse_id = wh_id;--
      SELECT location_id INTO loc_id FROM warehouses WHERE warehouse_id = wh_id;--
      SELECT * INTO locrec FROM locations WHERE location_id = loc_id;--

      CALL DBMS_OUTPUT.PUT_LINE('Warehouse ID: ' || wh_id);--
      CALL DBMS_OUTPUT.PUT_LINE('Warehouse Name: ' || wh_name);--
      CALL DBMS_OUTPUT.PUT_LINE('City: ' || locrec.city);--
      
      IF locrec.state IS NULL THEN
         CALL DBMS_OUTPUT.PUT_LINE('State: no state');--
      ELSE
         CALL DBMS_OUTPUT.PUT_LINE('State: ' || locrec.state);--
      END IF;--
      
      CALL DBMS_OUTPUT.NEW_LINE();--

      SET wh_id = wh_id + 1;--
   
   END WHILE;--

END;