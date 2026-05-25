# World Life Expectancy Project (Data Cleaning)
-- 1. DRop Duplicates
-- 2. Populate the NULLs
-- 3. Stadardize Data

SELECT * 
FROM world_life_expectancy;

SELECT country, year, CONCAT(country,year), COUNT(CONCAT(country,year))
FROM world_life_expectancy
GROUP BY country, year, CONCAT(country,year)
HAVING COUNT(CONCAT(country,year)) >1;


SELECT *
FROM (
SELECT Row_ID,
CONCAT(country,year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(country,year) ORDER BY CONCAT(country,year)) AS Row_Num
FROM world_life_expectancy
) AS Row_Table
WHERE Row_Num >1;

DELETE FROM world_life_expectancy
	WHERE 
         Row_ID IN (
         SELECT Row_ID
FROM (
SELECT Row_ID,
CONCAT(country,year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(country,year) ORDER BY CONCAT(country,year)) AS Row_Num
FROM world_life_expectancy
) AS Row_Table
WHERE Row_Num >1)
;


SELECT *
FROM world_life_expectancy
WHERE Status = '';


SELECT distinct(Status)
FROM world_life_expectancy
WHERE Status <> '';

SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country= t2.country
SET t1.Status= 'Developing'
WHERE t1.Status= ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country= t2.country
SET t1.Status= 'Developed'
WHERE t1.Status= ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

SELECT t1.Country, t1.Year, t1.`Life Expectancy`,
t2.Country, t2.Year, t2.`Life Expectancy`,
t3.Country, t3.Year, t3.`Life Expectancy`,
ROUND(( t2.`Life Expectancy`+  t3.`Life Expectancy`)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country= t2.country
    AND t1.Year=t2.Year-1
JOIN world_life_expectancy t3
	ON t1.Country=t3.Country
    AND t1.Year= t3.Year +1
    WHERE t1.`Life expectancy`='';
    
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country= t2.country
    AND t1.Year=t2.Year-1
JOIN world_life_expectancy t3
	ON t1.Country=t3.Country
    AND t1.Year= t3.Year +1
SET t1.`Life expectancy`= ROUND(( t2.`Life Expectancy`+  t3.`Life Expectancy`)/2,1)
WHERE t1.`Life expectancy`='';

-- World Life Expectancy Project (EDA)


SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`), 
ROUND(MAX(`Life expectancy`)- MIN(`Life expectancy`),1) AS Life_increase_15_years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_increase_15_years DESC;

SELECT Year,
ROUND(AVG(`Life expectancy`),2)
FROM world_life_expectancy
GROUP BY Year
ORDER BY Year;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_exp, 
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
Having Life_exp <>0 AND GDP <> 0
ORDER BY GDP DESC; 


SELECT 
SUM(CASE WHEN GDP >=1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >=1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <=1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <=1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy;

SELECT Status, ROUND(AVG(`Life expectancy`),1) 
FROM world_life_expectancy
GROUP BY Status;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1) 
FROM world_life_expectancy
GROUP BY Status;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
Having Life_exp >0 AND BMI > 0
ORDER BY BMI DESC; 

-- Rolling total

SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER (PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy;
    



