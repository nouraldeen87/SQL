-- identify table
SELECT *
FROM `Video_Games`;

--- change column value from text to int or float
ALTER TABLE `Video_Games`
    MODIFY COLUMN `User_Count` INT DEFAULT NULL;

ALTER TABLE `Video_Games`
    MODIFY COLUMN `User_Score` FLOAT DEFAULT NULL;


ALTER TABLE `Video_Games`
    MODIFY COLUMN `Critic_Count` INT DEFAULT NULL;

ALTER TABLE `Video_Games`
    MODIFY COLUMN `Critic_Score` FLOAT DEFAULT NULL;

-- change year from int to year
ALTER TABLE `Video_Games`
    MODIFY COLUMN `Year_of_Release` YEAR DEFAULT NULL;


-- to find null values in the Rating column and replace them with 'Unknown'
SELECT *
FROM `Video_Games`
    WHERE Rating='';

UPDATE `Video_Games` SET `Rating` = 'Unknown'
    WHERE `Rating` = '';

-- to find null values in the Developer column and replace them with 'Unknown'
SELECT *
FROM `Video_Games`
    WHERE `Developer`='';

UPDATE `Video_Games` SET `Developer` = 'Unknown'
    WHERE `Developer` = '';


-- check any column have a null value
SELECT *
FROM `Video_Games`
    WHERE `User_Count` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `User_Score` IS NULL;

SELECT *
FROM `Video_Games`
    WHERE `Critic_Count` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `Critic_Score` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `Global_Sales` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `Other_Sales` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `JP_Sales` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `EU_Sales` IS NULL;

SELECT *
FROM `Video_Games`
    WHERE `NA_Sales` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `Publisher` IS NULL;

SELECT *
FROM `Video_Games`
    WHERE `Genre` IS NULL;

SELECT *
FROM `Video_Games`
    WHERE `Year_of_Release` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `Platform` IS NULL;


SELECT *
FROM `Video_Games`
    WHERE `Game_Name` IS NULL;