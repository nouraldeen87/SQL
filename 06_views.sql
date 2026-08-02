CREATE VIEW NA_market AS(SELECT `Game_Name`,
`Platform`,
`Year_of_Release`,
`Genre`,
`Publisher`,
CONCAT('$',`NA_Sales`,'M'),
`Critic_Score`,
`Critic_Count`,
`User_Score`,
`User_Count`,
`Developer`,
`Rating`
FROM `Video_Games`);



CREATE VIEW EU_market AS(SELECT `Game_Name`,
`Platform`,
`Year_of_Release`,
`Genre`,
`Publisher`,
CONCAT('$',`EU_Sales`,'M'),
`Critic_Score`,
`Critic_Count`,
`User_Score`,
`User_Count`,
`Developer`,
`Rating`
FROM `Video_Games`);


CREATE VIEW JP_market AS(SELECT `Game_Name`,
`Platform`,
`Year_of_Release`,
`Genre`,
`Publisher`,
CONCAT('$',`JP_Sales`,'M'),
`Critic_Score`,
`Critic_Count`,
`User_Score`,
`User_Count`,
`Developer`,
`Rating`
FROM `Video_Games`);


CREATE VIEW other_market AS(SELECT `Game_Name`,
`Platform`,
`Year_of_Release`,
`Genre`,
`Publisher`,
CONCAT('$',`Other_Sales`,'M'),
`Critic_Score`,
`Critic_Count`,
`User_Score`,
`User_Count`,
`Developer`,
`Rating`
FROM `Video_Games`);



CREATE VIEW global_market AS(SELECT `Game_Name`,
`Platform`,
`Year_of_Release`,
`Genre`,
`Publisher`,
CONCAT('$',`global_Sales`,'M'),
`Critic_Score`,
`Critic_Count`,
`User_Score`,
`User_Count`,
`Developer`,
`Rating`
FROM `Video_Games`);