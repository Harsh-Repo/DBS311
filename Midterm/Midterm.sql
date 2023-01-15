-- ***********************
-- Name: HARSH PATEL
-- ID: 146315205
-- PURPOSE- MIDTEST
-- ***********************


-- Question 1 – Write a query which shows the common last names of any individuals in both 
--tables. Make sure you ignore case (Smith=SMITH=smith). Make sure duplicates 
--are removed. Alphabetically order the results.
-- Q1 SOLUTION --
SELECT DISTINCT
(e.lastname) AS "Name"
FROM
  employee e 
  JOIN
    staff s 
    ON LOWER(e.lastname) = LOWER(s.name) 
ORDER BY
  e.lastname;

-- Question 2 – Write a query which shows the employee IDs that are unique to the employee 
--table. Order the employee IDs in descending order. An employee ID Is the same 
--in both tables if the integer value of the ID matches.
-- Q2 SOLUTION --
SELECT
  CAST(empno AS number(*, 0)) AS " Employee ID" 
FROM
  employee minus 
  SELECT
    id 
  FROM
    staff 
  ORDER BY
    1 DESC;
    
-- Question 3 – We want to add a new column to the employee table. We want to provide a new
--column with a more complete phone number. Right now the PHONENO column
--only shows the last 4 digits.
--We want a new column which is called PHONE and consists of ###-###-####. The 
--last 4-digits are already in the PHONENO column. The first three digits should be 
--416 and the next three should be 123.
--To improve clarity in the table, we also want to rename the PHONENO column to 
--PHONEEXT.
--Show all the commands used to accomplish this, then, select all data for 
--employees who have the last name of 'smith' (case insensitive).
-- Q3 SOLUTION --


-- Question 4 – Show a list of employee id, names, department, years and job of any employee in 
--the staff table who makes a total amount more than their manager or has more 
--years of service than their manager.
--Make sure to include both salary and commission when calculating the total 
--amount someone makes.
--Exclude staff in department 10 from the query.
--Order the results by department then name
-- Q4 SOLUTION --

SELECT
  id,
  name,
  dept,
  years,
  job 
FROM
  staff s 
WHERE
  s.dept != 10 
  AND 
  (
    salary + comm > ANY( 
    SELECT
      salary + comm 
    FROM
      staff 
    WHERE
      job = 'Mgr' 
      AND dept = s.dept) 
      OR years > ANY (
      SELECT
        years 
      FROM
        staff 
      WHERE
        job = 'Mgr' 
        AND dept = s.dept)
  )
ORDER BY
  dept,
  name;

-- Question 5 – Show a list of all employees, their department and their jobs, from the staff table, 
--that are in the same department as 'Graham'
--Order by name alphabetically. Exclude 'Graham' from the result set.
-- Q5 SOLUTION --
SELECT
  id,
  name,
  dept,
  job 
FROM
  staff 
WHERE
  dept = 
  (
    SELECT
      dept 
    FROM
      staff 
    WHERE
      name = 'Graham' 
  )
  AND name != 'Graham' 
ORDER BY
  name;
  
-- Question 6 – Show the list of employee names, job and variable pay, from the employee table, 
--who have the lowest and highest variable pay (includes commission and bonus) 
--by job category.
--The name should be formatted: lastname, firstname with the first character 
--capitalized and all other characters in lower case. (ie: King, Les). The title of this 
--column should be “Name”.
--The variable pay column should be called “Variable Pay”.
--Order the results by highest variable pay to lowest variable pay.

-- Q6 SOLUTION --

SELECT
(initcap(lastname) || ', ' || initcap( firstname)) AS "Name",
  job,
  salary + nvl(comm, 0) + bonus AS "Variable Pay" 
FROM
  employee 
WHERE
  salary + nvl(comm, 0) + bonus IN 
  (
    SELECT
      MAX(salary + nvl(comm, 0) + bonus) 
    FROM
      employee 
    GROUP BY
      job 
  )
UNION
SELECT
(initcap(lastname) || ', ' || initcap( firstname)) AS "Name",
  job,
  salary + nvl(comm, 0) + bonus AS "Variable pay" 
FROM
  employee 
WHERE
  salary + nvl(comm, 0) + bonus IN 
  (
    SELECT
      MIN(salary + nvl(comm, 0) + bonus) 
    FROM
      employee 
    GROUP BY
      job 
  )
ORDER BY
  "Variable Pay" DESC ;



-- Question 7 – Using the staff table, show all employees who have an 'il' in their name - or - their 
--name ends with an 's'. Make sure your query is case insensitive.
--You just need to display the name of the employee in your output. Order them 
--alphabetically.
-- Q7 SOLUTION --
SELECT
  name 
FROM
  staff 
WHERE
  name LIKE '%s' 
  OR name LIKE '%il%' 
ORDER BY
  name;

-- Question 8 – Using the staff table, display the employee name, job, salary and commission for 
--all employees with a salary less than the salary of all people with a manager job or 
--full compensation less than the full compensation of all the people with a sales
--job.
--Full compensation is the sum of both salary and commission.
--Exclude people with a sales job from the output.
-- Q8 SOLUTION --
SELECT
  name,
  job,
  salary,
  comm 
FROM
  staff 
WHERE
  job != 'Sales' 
  AND 
  (
    salary < (
    SELECT
      MIN(salary) 
    FROM
      staff 
    WHERE
      job = 'Mgr') 
      OR 
      (
        salary + comm
      )
      < (
      SELECT
        MIN("sale_compensation") 
      FROM
        (
          SELECT
(salary + comm) AS "sale_compensation" 
          FROM
            staff 
          WHERE
            job = 'Sales'
        )
)
  )
ORDER BY
  salary;


-- Question 9 – From the employee table, calculate the average compensation for each job 
--category where the employee has 16 or more years of education.
--Display the job and average compensation in the result set.
--Exclude people who are clerks
--Make sure to include salary, commission and bonus when looking at employee 
--compensation
--Order the output by the average salary in ascending order
-- Q9 SOLUTION --
SELECT 
 job, 
 ROUND(AVG(salary + comm + bonus), 2) AS "AVERAGE COMPENSATION" 
FROM 
 EMPLOYEE 
WHERE 
 edlevel >= '16' 
 AND job NOT IN UPPER('clerk') 
GROUP BY 
 job 
ORDER BY 
 AVG(salary + comm + bonus) ASC; 


-- Question 10 – Show the first name, last name, hire date, birth date, education level and years of 
--service for employees who are both in the staff table and the employee table
--An individual is the same individual if a case insensitive comparison of last name 
--matches.
-- Q10 SOLUTION --
SELECT
  e.firstname,
  e.lastname,
  e.hiredate,
  e.birthdate,
  e.edlevel,
  nvl(s.years, 0) AS years 
FROM
  employee e 
  JOIN
    staff s 
    ON LOWER(e.lastname) = LOWER(s.name) 
ORDER BY
  e.firstname;




 
 
 