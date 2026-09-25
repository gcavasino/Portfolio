SELECT *
FROM worldlifexpectancy;

#Data Cleaning

SELECT 
    Country,
    Year,
    CONCAT(Country, Year),
    COUNT(CONCAT(Country, Year))
FROM
    worldlifexpectancy
GROUP BY Country , Year , CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;


SELECT *
FROM(
	Select Row_id, 
	CONCAT(Country, Year), 
	row_number() over( Partition by CONCAT(Country, Year) order by CONCAT(Country, Year)) as Row_Num
	FROM
	worldlifexpectancy
    ) as Row_Table
WHERE Row_Num > 1
;


DELETE FROM worldlifexpectancy
WHERE Row_id IN (
SELECT Row_id
FROM(
	Select Row_id, 
	CONCAT(Country, Year), 
	row_number() over( Partition by CONCAT(Country, Year) order by CONCAT(Country, Year)) as Row_Num
	FROM
	worldlifexpectancy
    ) as Row_Table
WHERE Row_Num > 1
)
;



SELECT *
FROM worldlifexpectancy
WHERE Status = ''
;

SELECT DISTINCT(Country)
FROM worldlifexpectancy
WHERE Status = 'Developing'
;


UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;


UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;


SELECT *
FROM worldlifexpectancy
WHERE Lifeexpectancy = ''
;

SELECT 
	t1.Country, t1.Year, t1.Lifeexpectancy, 
    t2.Country, t2.Year, t2.Lifeexpectancy,
    t3.Country, t3.Year, t3.Lifeexpectancy,
    ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year -1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country 
    AND t1.Year = t3.Year -1
WHERE t1.Lifeexpectancy = ''
;



UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year -1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country 
    AND t1.Year = t3.Year -1
SET t1.Lifeexpectancy = ROUND((t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
WHERE t1.Lifeexpectancy = ''
;



#Data Analysis


SELECT Country, 
	MIN(Lifeexpectancy), 
    MAX(Lifeexpectancy),
    ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy),1) AS Life_Increase_15_Years
FROM worldlifexpectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0
AND MAX(Lifeexpectancy) <> 0
ORDER BY Life_Increase_15_Years DESC
;



SELECT Year, ROUND(AVG(Lifeexpectancy),1)
FROM worldlifexpectancy
WHERE Lifeexpectancy <> 0
AND Lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year
;



SELECT Country, ROUND(AVG(Lifeexpectancy),1) AS Life_Exp, ROUND(AVG(GDP),1) AS AGV_GDP
FROM worldlifexpectancy
GROUP BY Country
HAVING Life_Exp > 0
AND AGV_GDP > 0
ORDER BY AGV_GDP ASC
;


SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
ROUND(AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END),1) High_GDP_Lifeexpectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
ROUND(AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END),1) Low_GDP_Lifeexpectancy
FROM worldlifexpectancy
;


SELECT
	Status,
    COUNT(DISTINCT Country) AS Country_Count,
    ROUND(AVG(Lifeexpectancy),1) AS Life_Exp
FROM worldlifexpectancy
GROUP BY Status
;




SELECT 
	Country, 
    ROUND(AVG(Lifeexpectancy),1) AS Life_Exp, 
    ROUND(AVG(BMI),1) AS AGV_BMI
FROM worldlifexpectancy
GROUP BY Country
HAVING Life_Exp > 0
AND AGV_BMI > 0
ORDER BY AGV_BMI DESC
;



SELECT
	Country,
    Year,
    Lifeexpectancy,
    AdultMortality,
    SUM(AdultMortality) OVER (PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM worldlifexpectancy
;
