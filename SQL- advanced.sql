-- T1: CTEs : Common table expressions
-- We use it for readability & perform more advanced calculations in one query 

WITH CTE_Example (Gender, avg_sal, max_sal, min_sal, count_sal)AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id=dem.employee_id
group by gender
)

SELECT AVG(avg_sal)
FROM CTE_Example;

WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics 
WHERE birth_date>'1985-01-01'
),
CTE_Example2 AS
(
select employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id;
    
-- T2: Temporary Tables
-- 1st way (CREATE TEMPORARY TABLE/ INSERT INTO/ VALUES()

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);
SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES ('Alex', 'Freberg','Lord of the rings');
SELECT *
FROM temp_table;

-- 2nd way 
SELECT *
FROM employee_salary;

CREATE temporary table salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT*
FROM salary_over_50k;

-- T3: Stored procedures
SELECT *
FROM employee_salary
WHERE salary >=50000;

USE parks_and_recreation;
CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries;

-- DELIMITER $$

DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
SELECT *
FROM employee_salary
WHERE salary >= 50000;
SELECT *
FROM employee_salary
WHERE salary >=10000;
END $$
DELIMITER ;

CALL large_salaries3();

DELIMITER $$
CREATE PROCEDURE large_salaries5(p_employee_id INT)
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE employee_id=p_employee_id;
END $$
DELIMITER ;

CALL large_salaries5(1);

-- T4: Triggers and Events

DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics(employee_id, first_name,last_name)
    VALUES(NEW.employee_id,NEW.first_name, NEW.last_name);
END $$
DELIMITER ;
 INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
 VALUES('13','Menna','Samir','CEO',1000000,NULL);
 
 SELECT *
 FROM employee_demographics;
 
 -- EVENTS
 SELECT *
 FROM employee_demographics;
 DELIMITER $$
 CREATE EVENT delete_retirees
 ON SCHEDULE EVERY 30 SECOND
 DO
 BEGIN
	DELETE
	FROM employee_demographics
	WHERE age >=60;
 END $$
 DELIMITER ;
 
 SELECT *
 FROM employee_demographics;

