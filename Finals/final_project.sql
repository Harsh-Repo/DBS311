--NAME: Harsh Patel
--Seneca ID Number:  146315205
--COURSE:DBS311
--Final project

--SECTION A
-- QUESTION 1:
SELECT WORKDEPT, JOB, EMPNO, SUM(SALARY + BONUS + COMM) AS "TOTAL COMPENSATION"
FROM EMPLOYEE
group by WORKDEPT, JOB, EMPNO
ORDER BY WORKDEPT, JOB;

-- QUESTION 2:
select initcap(lower(lastname)) from employee intersect select initcap(lower(name)) from staff order by 1;

-- QUESTION 3:
select lastname from employee, staff where empno= id order by empno,lastname;

-- QUESTION 4:
SELECT lastname
FROM employee
WHERE lower(lastname) LIKE '%oo%' OR lower(lastname) LIKE '%z%'
UNION ALL
SELECT name
FROM staff
WHERE lower(name)LIKE '%oo%' OR lower(name) LIKE '%z%'
ORDER BY lastname;

-- QUESTION 5:
SELECT  DISTINCT A.WORKDEPT AS DEPARTMENT, C.MAN_SALARY AS MANAGER_SALARY, NVL(B.HIGHEST, 0)AS HIGHEST_SALARY_DEPT 
FROM EMPLOYEE A LEFT JOIN 
(SELECT MAX(SALARY+BONUS+COMM) AS HIGHEST, WORKDEPT FROM EMPLOYEE WHERE JOB <> 'MANAGER' GROUP BY WORKDEPT ) B 
ON A.WORKDEPT = B.WORKDEPT JOIN 
(SELECT SALARY+BONUS+COMM AS MAN_SALARY, WORKDEPT FROM EMPLOYEE WHERE JOB = 'MANAGER' ) C 
ON A.WORKDEPT = C.WORKDEPT where (C.MAN_SALARY)-(B.HIGHEST)<10000 ;

-- QUESTION 6:
select lower(lastname)  as "LastName", bonus+comm as "Variable Pay" from 
employee
UNION ALL
select lower(name) as "LastName", NVL(comm,0) as "Variable Pay" from
staff
order by "LastName";


-- QUESTION 7:
set serverout on;
CREATE OR REPLACE PROCEDURE UPDATE_SALARY
( E_ID IN EMPLOYEE.EMPNO%type, RATING IN number)
is
-- declare variables
M_SALARY NUMBER;
M_BONUS NUMBER;
M_COMM NUMBER;
N_SALARY NUMBER;
N_BONUS NUMBER;
N_COMM NUMBER;
N_EMP NUMBER;
-- Declare exception for empno not found
EMP_EXP EXCEPTION;
-- Declare exception for incorrect rating 
RATING_EXP EXCEPTION;
BEGIN
-- to count the number of records
SELECT COUNT(*) INTO N_EMP  FROM EMPLOYEE WHERE EMPNO = E_ID ;
-- check condition and display the output
IF N_EMP > 0 THEN
SELECT SALARY, BONUS, COMM INTO M_SALARY, M_BONUS, M_COMM FROM EMPLOYEE WHERE EMPNO = E_ID;
IF RATING =1 THEN
N_SALARY :=M_SALARY+10000;
N_COMM :=M_COMM+(M_SALARY * .05);
N_BONUS := M_BONUS + 300;
DBMS_OUTPUT.PUT_LINE('EMPNO ' || E_ID || ' OLD SALARY ' || M_SALARY || ' OLD BONUS ' || M_BONUS || ' OLD COMM ' || M_COMM || ' NEW SALARY ' 
|| N_SALARY || ' NEW BONUS ' || N_BONUS  || ' NEW COMM '|| N_COMM ) ;
   
ELSIF RATING =2 THEN
N_SALARY :=M_SALARY+5000;
N_COMM :=M_COMM+(M_SALARY * .02);
N_BONUS := M_BONUS + 200;
DBMS_OUTPUT.PUT_LINE('EMPNO ' || E_ID || ' OLD SALARY ' || M_SALARY || ' OLD BONUS ' || M_BONUS || ' OLD COMM ' || M_COMM || ' NEW SALARY ' 
|| N_SALARY || ' NEW BONUS ' || N_BONUS  || ' NEW COMM '|| N_COMM ) ;
ELSIF RATING =3 THEN
N_SALARY :=M_SALARY+3000;
DBMS_OUTPUT.PUT_LINE('EMPNO ' || E_ID || ' OLD SALARY ' || M_SALARY || ' OLD BONUS ' || M_BONUS || ' OLD COMM ' || M_COMM || ' NEW SALARY ' 
|| N_SALARY || ' NEW BONUS ' || M_BONUS  || ' NEW COMM '|| M_COMM ) ;
ELSE

-- raise exception for incorrect education level input 
RAISE RATING_EXP;
END IF;
ELSE
-- -- raise exception for empno not found
RAISE EMP_EXP ;
END IF;
-- handling exception part
EXCEPTION
   WHEN EMP_EXP THEN
      dbms_output.put_line('EMPNO NOT FOUND!');
  WHEN RATING_EXP THEN
      dbms_output.put_line('NON VALID RATING ONLY 1,2, 3 ALLOWED');
   WHEN others THEN
      dbms_output.put_line('Error!' || M_SALARY);
END;

EXEC UPDATE_SALARY('10',1);
--SECTION B

-- QUESTION 1:





