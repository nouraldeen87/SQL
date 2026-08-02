--- database exploration ---
SELECT *
FROM information_schema.TABLES
WHERE `TABLE_SCHEMA`='project';

SELECT *
FROM information_schema.COLUMNS
WHERE `TABLE_SCHEMA`='project';

--- dimension exploration ---

-- unique platforms
SELECT DISTINCT Platform
FROM `Video_Games`
ORDER BY `Platform`;

-- unique years
SELECT DISTINCT `Year_of_Release`
FROM `Video_Games`
ORDER BY `Year_of_Release`;

-- unique Genre
SELECT DISTINCT Genre
FROM `Video_Games`;

-- unique Publisher
SELECT DISTINCT Publisher
FROM `Video_Games`;

-- unique Developer
SELECT DISTINCT `Developer` 
FROM `Video_Games`;

-- unique Rating
SELECT DISTINCT Rating
FROM `Video_Games`;

SELECT Game_Name,
Developer,
Publisher,
Genre,
Year_of_Release,
CONCAT('$',Global_Sales,'M') AS `Global_Sales`
FROM`Video_Games`;

--- date exploration ---

SELECT MIN(`Year_of_Release`) AS oldest_year,
MAX(`Year_of_Release`) AS newest_year
FROM `Video_Games`;

--- measure exploration ---
SELECT CONCAT('$',ROUND(SUM(NA_Sales),2),'M') AS NA_total_sales,
CONCAT('$',ROUND(AVG(`NA_Sales`),2),'M')AS NA_avg_sales
FROM `Video_Games`;

SELECT CONCAT('$',ROUND(SUM(`EU_Sales`),2),'M') AS EU_total_sales,
CONCAT('$',ROUND(AVG(`EU_Sales`),2),'M')AS EU_avg_sales
FROM `Video_Games`;


SELECT CONCAT('$',ROUND(SUM(`JP_Sales`),2),'M')AS JP_total_sales,
CONCAT('$',ROUND(AVG(`JP_Sales`),2),'M')AS JP_avg_sales
FROM `Video_Games`;

SELECT CONCAT('$',ROUND(SUM(`Other_Sales`),2),'M')AS Other_total_Sales,
CONCAT('$',ROUND(AVG(`Other_Sales`),2),'M')AS Other_avg_sales
FROM `Video_Games`;

SELECT CONCAT('$',ROUND(SUM(`Global_Sales`),2),'M')AS Global_total_Sales,
CONCAT('$',ROUND(AVG(`Global_Sales`),2),'M')AS Global_avg_Sales 
FROM `Video_Games`;

SELECT SUM(`Critic_Score`) AS total_critic_score,
ROUND(AVG(`Critic_Score`),1) AS avg_critic_score,
COUNT(`Critic_Count`) total_critic_count
FROM `Video_Games`;


SELECT ROUND(SUM(`User_Score`),1)AS total_user_score,
ROUND(AVG(`User_Score`),1)AS avg_user_score,
COUNT(`User_Count`)AS total_user_count 
FROM`Video_Games`;

SELECT 'total_games' AS measure_name,COUNT(DISTINCT `Game_Name`)AS measure_value
FROM `Video_Games`;

--- magnitude exploration ---
SELECT Platform,
COUNT(User_Count) as total_user_count
FROM `Video_Games`
GROUP BY `Platform`
ORDER BY total_user_count DESC;


SELECT `Game_Name`,
COUNT(User_Count) as total_user_count
FROM `Video_Games`
GROUP BY `Game_Name`
ORDER BY total_user_count DESC;

--- ranking analysis ---
SELECT Game_Name,
CONCAT(ROUND(AVG(`Critic_Score`),0),'/100')AS avg_critic_score,
CONCAT(ROUND(AVG(User_Score),1),'/10')AS avg_user_score
FROM`Video_Games`
GROUP BY `Game_Name`
ORDER BY avg_user_score DESC
LIMIT 5;


SELECT `Genre`,
CONCAT(ROUND(AVG(`Critic_Score`),0),'/100')AS avg_critic_score,
CONCAT(ROUND(AVG(User_Score),1),'/10')AS avg_user_score
FROM`Video_Games`
GROUP BY `Genre`
ORDER BY avg_user_score
LIMIT 5;