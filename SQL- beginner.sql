-- T1: SELECT/ FROM/ Save/DISTINCT

-- T2: WHERE >/</!=/'', AND, OR 
-- LIKE '%%' or 'a__'
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM employee_demographics
WHERE gender != 'Female';
SELECT*
FROM employee_demographics
WHERE birth_date > '1985-01-01' AND gender= 'male';

SELECT*
FROM employee_demographics
WHERE (birth_date > '1985-01-01' AND gender= 'male') OR age= 44;

-- LIKE statment
-- % or _
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'A%';

-- T3: Group by & ORDER by

SELECT gender ,AVG(age), MAX(age),MIN(age), COUNT(age)
FROM employee_demographics
group by gender;

SELECT occupation, salary
FROM employee_salary
GROUP BY occupation, salary;

-- ORDER BY ( alt.: order by column position) (DESC/ASC)
SELECT *
FROM employee_demographics
ORDER BY gender, age ASC;
-- order by 5,4;

-- T4 Having VS Where
-- Having comes after Group By and filters on the aggregate function level

SELECT *
FROM employee_salary;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
group by occupation
HAVING AVG(salary)> 75000;

-- T5: LIMIT & Aliasing

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3;
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2,1;

-- Aliasing

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
having avg_age>40;
