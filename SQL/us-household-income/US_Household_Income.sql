SELECT *
FROM US_Household.USHouseholdIncome
;


SELECT *
FROM US_Household.ushouseholdincome_statistics
;


SELECT COUNT(id)
FROM US_Household.USHouseholdIncome
;


SELECT COUNT(id)
FROM US_Household.ushouseholdincome_statistics
;


SELECT id, COUNT(id)
FROM US_Household.USHouseholdIncome
GROUP BY id
HAVING COUNT(id) > 1
;



SELECT *
FROM (
SELECT 
	row_id, 
    id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM US_Household.USHouseholdIncome
) duplicates
WHERE row_num > 1
;


DELETE FROM USHouseholdIncome
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT 
		row_id, 
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM US_Household.USHouseholdIncome
		) duplicates
	WHERE row_num > 1)
; 



SELECT DISTINCT State_Name
FROM US_Household.USHouseholdIncome
ORDER BY 1
;

UPDATE US_Household.USHouseholdIncome
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE US_Household.USHouseholdIncome
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;


SELECT DISTINCT State_ab
FROM US_Household.USHouseholdIncome
ORDER BY 1
;


SELECT DISTINCT *
FROM US_Household.USHouseholdIncome
WHERE Place = ''
ORDER BY 1
;


UPDATE USHouseholdIncome
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;


SELECT Type, COUNT(Type)
FROM US_Household.USHouseholdIncome
GROUP BY Type
;


UPDATE USHouseholdIncome
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


SELECT ALand, AWater
FROM US_Household.USHouseholdIncome
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
;

SELECT ALand, AWater
FROM US_Household.USHouseholdIncome
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
;


SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Household.USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10 
;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Household.USHouseholdIncome
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10 
;


SELECT *
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;


SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;


SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0    
GROUP BY u.State_Name
;


SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0    
GROUP BY u.State_Name
ORDER BY 2
LIMIT 5
;


SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0    
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10
;



SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0    
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10
;



SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0    
GROUP BY Type
ORDER BY 3 DESC
;


SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0    
GROUP BY Type
ORDER BY 4 DESC
;



SELECT *
FROM US_Household.USHouseholdIncome
WHERE Type = 'Community'
;



SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
WHERE Mean <> 0    
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
;



SELECT u.State_Name, City, ROUND(AVG(Mean),1)
FROM US_Household.USHouseholdIncome u
INNER JOIN US_Household.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC
;





