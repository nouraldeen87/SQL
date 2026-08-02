CREATE TABLE `Video_Games` (
    `Game_Name` text,
    `Platform` text,
    `Year_of_Release` varchar(255) DEFAULT NULL,
    `Genre` text,
    `Publisher` text,
    `NA_Sales` double DEFAULT NULL,
    `EU_Sales` double DEFAULT NULL,
    `JP_Sales` double DEFAULT NULL,
    `Other_Sales` double DEFAULT NULL,
    `Global_Sales` double DEFAULT NULL,
    `Critic_Score` double DEFAULT NULL,
    `Critic_Count` bigint DEFAULT NULL,
    `User_Score` double DEFAULT NULL,
    `User_Count` bigint DEFAULT NULL,
    `Developer` text,
    `Rating` text
);