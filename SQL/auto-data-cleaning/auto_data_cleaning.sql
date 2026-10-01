SELECT * 
FROM US_Household.USHouseholdIncome;



DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_And_Clean_Data;
CREATE PROCEDURE Copy_And_Clean_Data()
BEGIN
-- Creating our table

	CREATE TABLE IF NOT EXISTS `USHouseholdIncome_Cleaned` (
	  `row_id` int NOT NULL,
	  `id` int NOT NULL,
	  `State_Code` int NOT NULL,
	  `State_Name` varchar(20) NOT NULL,
	  `State_ab` varchar(2) NOT NULL,
	  `County` varchar(33) NOT NULL,
	  `City` varchar(22) NOT NULL,
	  `Place` varchar(36) DEFAULT NULL,
	  `Type` varchar(12) NOT NULL,
	  `Primary` varchar(5) NOT NULL,
	  `Zip_Code` int NOT NULL,
	  `Area_Code` varchar(3) NOT NULL,
	  `ALand` bigint NOT NULL,
	  `AWater` bigint NOT NULL,
	  `Lat` decimal(10,7) NOT NULL,	
	  `Lon` decimal(12,7) NOT NULL,
	  `TimeStamp` TIMESTAMP NOT NULL,
	  PRIMARY KEY (`row_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Copy data to new table
	INSERT INTO USHouseholdIncome_Cleaned
	SELECT *, CURRENT_TIMESTAMP
	FROM US_Household.USHouseholdIncome;

	-- Remove Duplicates
	DELETE FROM USHouseholdIncome_Cleaned 
	WHERE 
		row_id IN (
		SELECT row_id
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id, `TimeStamp`
				ORDER BY id, `TimeStamp`) AS row_num
		FROM 
			USHouseholdIncome_Cleaned
	) duplicates
	WHERE 
		row_num > 1
	);

	-- Fixing some data quality issues by fixing typos and general standardization
	UPDATE USHouseholdIncome_Cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE USHouseholdIncome_Cleaned
	SET County = UPPER(County);

	UPDATE USHouseholdIncome_Cleaned
	SET City = UPPER(City);

	UPDATE USHouseholdIncome_Cleaned
	SET Place = UPPER(Place);

	UPDATE USHouseholdIncome_Cleaned
	SET State_Name = UPPER(State_Name);

	UPDATE USHouseholdIncome_Cleaned
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE USHouseholdIncome_Cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';


END$$
DELIMITER ;

CALL Copy_And_Clean_Data();


-- Create Event

CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_And_Clean_Data();





-- Debugging or checking SP works

		SELECT row_id, id, row_num
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id
				ORDER BY id) AS row_num
		FROM 
			USHouseholdIncome_Cleaned
	) duplicates
	WHERE 
		row_num > 1;


    SELECT COUNT(row_id)
    FROM USHouseholdIncome_Cleaned;
    
    SELECT State_Name, COUNT(State_Name)
    FROM USHouseholdIncome_Cleaned
    GROUP BY State_Name
    ;


