# World Life Expectancy Project (Data Cleaning)
SELECT * 
FROM world_life_expectancy;

SELECT Country, Year, CONCAT(Country,Year), COUNT(CONCAT(Country,Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country,Year)
HAVING COUNT(CONCAT(Country,Year))>1;


SELECT *
FROM
(SELECT Row_ID, 
CONCAT(Country, Year), 
ROW_NUMBER()OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_num
FROM world_life_expectancy) AS Row_table
WHERE Row_num >1;


DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN ( 
	SELECT Row_ID
	FROM
	(SELECT Row_ID, 
	CONCAT(Country, Year), 
	ROW_NUMBER()OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_num
	FROM world_life_expectancy) AS Row_table
	WHERE Row_num >1);
    
    SELECT *
FROM world_life_expectancy
WHERE Status='';

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status<>'';

SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status='Developing';

UPDATE world_life_expectancy
SET Status ='Developing'
WHERE Country IN ( SELECT DISTINCT(Country)
                   FROM world_life_expectancy
                   WHERE Status='Developing');
                   
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country=t2.Country
SET t1.Status ='Developing'
WHERE t1.Status =''
AND t2.Status <>''
AND t2.Status ='Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country=t2.Country
SET t1.Status ='Developed'
WHERE t1.Status =''
AND t2.Status <>''
AND t2.Status ='Developed';

SELECT t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1) 
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country= t2.Country
    AND t1.Year= t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country= t3.Country
    AND t1.Year= t3.Year +1
WHERE t1.`Life expectancy`='';


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country= t2.Country
    AND t1.Year= t2.Year -1
JOIN world_life_expectancy t3
	ON t1.Country= t3.Country
    AND t1.Year= t3.Year +1
SET t1.`Life expectancy`=ROUND((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy`='';

SELECT Country, MIN(`Life expectancy`),MAX(`Life expectancy`), ROUND(MAX(`Life expectancy`)-MIN(`Life expectancy`),1) AS Life_Increase_15_years
FROM world_life_expectancy
GROUP BY Country 
HAVING MIN(`Life expectancy`) <>0
AND MAX(`Life expectancy`)<>0
ORDER BY Life_Increase_15_years DESC;

SELECT Country, ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(`GDP`),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0 AND GDP > 0
ORDER BY Life_Exp ASC; 

SELECT 
SUM( CASE WHEN GDP >=1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG( CASE WHEN GDP >=1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_expectancy,
SUM( CASE WHEN GDP <=1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG( CASE WHEN GDP <=1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_expectancy
FROM world_life_expectancy;

SELECT Status, ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY Status;

SELECT Country,  ROUND(AVG(`Life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
Having BMI>0 AND Life_Exp >0
ORDER BY BMI DESC;

SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%united%';

SELECT COUNT(id)
FROM us_household_income_statistics;
SELECT COUNT(id)
FROM us_household_income;

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id)>1;

SELECT *
FROM(SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id)row_num
FROM us_household_income
) duplicates
WHERE row_num >1;

DELETE FROM us_household_income
WHERE row_id IN( 
 SELECT row_id
 FROM (
	SELECT row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id)row_num
	FROM us_household_income
	) duplicates
	WHERE row_num >1);
    
SELECT DISTINCT(State_Name)
FROM us_household_income
GROUP BY State_Name
ORDER BY 1;

UPDATE us_household_income
SET State_Name= 'Georgia'
WHERE State_Name= 'georia';

    
SELECT DISTINCT(State_ab)
FROM us_household_income
GROUP BY State_ab
ORDER BY 1;

SELECT *
FROM us_household_income
WHERE Place= ''
ORDER BY 1;

UPDATE us_household_income
SET Place= 'Autaugaville'
WHERE County='Autauga County'
AND City='Vinemont';

SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type; 

UPDATE us_household_income
SET Type= 'Borough'
WHERE Type= 'Boroughs';

SELECT ALand, AWater
FROM us_household_income
WHERE AWater=0 OR AWater='' OR AWater IS NULL;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10; 

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id=us.id
WHERE Mean <>0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10; 


SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id=us.id
WHERE Mean <>0
GROUP BY Type
HAVING COUNT(Type) >100
ORDER BY 3 DESC
LIMIT 20;  

SELECT *
FROM us_household_income
WHERE Type ='Community';

SELECT u.State_Name,City, ROUND(AVG(Mean),1),ROUND(AVG(Median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id=us.id
GROUP BY u.State_Name,City
ORDER BY ROUND(AVG(Mean),1) DESC;



