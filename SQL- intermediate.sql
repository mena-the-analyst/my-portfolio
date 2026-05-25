--  T1 JOINS
-- inner joins/ outer joins/ self joins

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id= sal.employee_id;

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id= sal.employee_id;

-- OUTER JOINS (LEFT/RIGHT)

SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id= sal.employee_id;
-- SELF JOIN

SELECT emp1.employee_id AS emp_santa, emp1.first_name AS first_name_santa, emp1.last_name AS last_name_santa, emp2.employee_id AS emp_id, emp2.first_name AS first_name_emp, emp2.last_name AS last_name_emp
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id +1= emp2.employee_id
;

-- Joining multiple tables together

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id= sal. employee_id;
    
SELECT *
FROM parks_departments;

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id= sal. employee_id
INNER JOIN parks_departments pd
	ON sal.dept_id=pd.department_id;

-- T2:UNIONS

SELECT age, gender
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary; 

-- union is normally union distinct but we can use UNION ALL
SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

-- T3:String functions
-- Lenght('')/  UPPER('')/ Lower('')/ TRIM('') L R/ Substring/replace/locate/CONCAT

SELECT first_name, length(first_name)
FROM employee_demographics
order by 2;

SELECT UPPER('sky');
SELECT LOWER('sky');
SELECT TRIM('   sky  ');
SELECT RTRIM('   sky  ');
SELECT LTRIM('   sky  ');
SELECT first_name, LEFT(first_name,4) As trimmed
FROM employee_demographics;
SELECT first_name, RIGHT(first_name,4) As trimmed
FROM employee_demographics;

SELECT first_name, SUBSTRING(birth_date, 6,2) AS birth_month
FROM employee_demographics;

SELECT first_name, REPLACE( first_name, 'a','z')
FROM employee_demographics;

SELECT LOCATE('x','Alexander');
SELECT first_name, LOCATE('An',first_name)
FROM employee_demographics;

SELECT first_name, last_name, concat(first_name,' ',last_name) AS full_name
FROM employee_demographics;

-- T4: Case statement

SELECT first_name, 
last_name,
age,
CASE
	WHEN age<=30 THEN 'Young'
    WHEN age between 31 and 50 THEN 'Old'
END AS Age_Bracket
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT first_name, last_name,salary,
CASE
	WHEN salary< 50000 THEN salary*1.05
    WHEN salary > 50000 THEN salary*1.07
end As New_salary
FROM employee_salary;

-- T5: Sub queries

SELECT *
FROM employee_demographics
WHERE employee_id IN
				( SELECT employee_id
                FROM employee_salary
                WHERE dept_id=1)
;

SELECT first_name, salary, 
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

-- T6: Window Functions

SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id= sal.employee_id
GROUP BY gender;

-- OVER(PARTITION BY ORDER BY)
SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id= sal.employee_id;
-- Rolling_total    
SELECT dem.first_name,dem.last_name,gender, salary, sum(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id= sal.employee_id;

SELECT dem.employee_id, dem.first_name,dem.last_name,gender, salary,
row_number() OVER(partition by gender order by salary DESC) AS row_num,
RANK() OVER(partition by gender order by salary DESC) rank_num,
DENSE_RANK() OVER(partition by gender order by salary DESC) Dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id= sal.employee_id;

