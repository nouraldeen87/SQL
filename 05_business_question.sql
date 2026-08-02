-- =========================================================
-- Business Questions — Video_Games dataset
-- Fixed & optimized version
-- =========================================================

-- Q1: Which platform achieved the highest total global sales?
-- FIX: sort by the raw numeric SUM, not the formatted text alias
SELECT
    Platform,
    CONCAT('$', ROUND(SUM(Global_Sales), 2), 'M') AS total_global_sales
FROM `Video_Games`
GROUP BY Platform
ORDER BY SUM(Global_Sales) DESC
LIMIT 1;


-- Q2: Which publisher has achieved the highest sales?
SELECT
    Publisher,
    CONCAT('$', ROUND(SUM(Global_Sales), 2), 'M') AS total_global_sales
FROM `Video_Games`
GROUP BY Publisher
ORDER BY SUM(Global_Sales) DESC
LIMIT 1;

-- Q2b: Is focusing on a few large publishers a risk? (concentration analysis)
-- Shows what % of total industry sales the top 10 publishers control
WITH publisher_sales AS (
    SELECT
        Publisher,
        SUM(Global_Sales) AS total_sales
    FROM `Video_Games`
    WHERE Publisher IS NOT NULL
    GROUP BY Publisher
),
ranked AS (
    SELECT
        Publisher,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
        ROUND(total_sales * 100.0 / SUM(total_sales) OVER (), 2) AS pct_of_total_market
    FROM publisher_sales
)
SELECT
    Publisher,
    CONCAT('$', ROUND(total_sales, 2), 'M') AS total_global_sales,
    CONCAT(pct_of_total_market, '%') AS market_share,
    sales_rank
FROM ranked
ORDER BY sales_rank
LIMIT 10;


-- Q3: How have global sales evolved over the years?
-- Is the industry growing or declining?
SELECT
    Year_of_Release,
    CONCAT('$', ROUND(SUM(Global_Sales), 2), 'M') AS total_global_sales
FROM `Video_Games`
WHERE Year_of_Release IS NOT NULL
GROUP BY Year_of_Release
ORDER BY Year_of_Release ASC;


-- Q4: Is there a relationship between critics' ratings (Critic_Score) and actual sales?
-- Does perceived quality translate into sales?
SELECT
    CONCAT(Critic_Score, '/100') AS Critic_Score,
    CONCAT('$', ROUND(SUM(Global_Sales), 2), 'M') AS total_global_sales,
    COUNT(*) AS num_games
FROM `Video_Games`
WHERE Critic_Score IS NOT NULL
GROUP BY Critic_Score
ORDER BY Critic_Score ASC;

-- Q4b: Actual correlation coefficient (Pearson's r) between Critic_Score and Global_Sales
-- MySQL has no built-in CORR() function, so it is computed manually here.
-- r near 0 = weak/no linear relationship, near 1 or -1 = strong relationship
SELECT
    ROUND(
        (COUNT(*) * SUM(Critic_Score * Global_Sales) - SUM(Critic_Score) * SUM(Global_Sales))
        /
        (
            SQRT(COUNT(*) * SUM(POW(Critic_Score, 2)) - POW(SUM(Critic_Score), 2))
            *
            SQRT(COUNT(*) * SUM(POW(Global_Sales, 2)) - POW(SUM(Global_Sales), 2))
        )
    , 3) AS critic_score_sales_correlation
FROM `Video_Games`
WHERE Critic_Score IS NOT NULL
  AND Global_Sales IS NOT NULL;
-- Result ~0.24 -> weak positive relationship. Critic scores explain only a small part
-- of what drives sales; marketing, IP strength, and platform install base likely matter more.


-- Q5: Does the user rating (User_Score) differ significantly from the critics' rating?
-- Where is the biggest gap between them?
-- FIX: User_Score is stored as text (contains 'tbd' values) — must filter and CAST before math
SELECT
    Game_Name,
    Critic_Score,
    User_Score,
    ROUND(Critic_Score - (CAST(User_Score AS DECIMAL(4,2)) * 10), 2) AS difference_scores
FROM `Video_Games`
WHERE Critic_Score IS NOT NULL
  AND User_Score IS NOT NULL
  AND User_Score != 'tbd'
ORDER BY ABS(difference_scores) DESC;


-- Q6: Which games achieved high sales despite low critic reviews (or vice versa)?
-- "Hidden gems" (high sales / low score) or over-marketed games revealed
-- FIX: LIMIT 50 was arbitrary. Now uses actual thresholds: top 25% sales vs bottom 25%
-- critic score (hidden gems), and the mirror case (overhyped/over-marketed games).
WITH thresholds AS (
    SELECT
        (SELECT Global_Sales FROM `Video_Games`
         WHERE Global_Sales IS NOT NULL
         ORDER BY Global_Sales DESC LIMIT 1 OFFSET (
            SELECT FLOOR(COUNT(*) * 0.25) FROM `Video_Games` WHERE Global_Sales IS NOT NULL
         )) AS sales_p75,
        (SELECT Critic_Score FROM `Video_Games`
         WHERE Critic_Score IS NOT NULL
         ORDER BY Critic_Score ASC LIMIT 1 OFFSET (
            SELECT FLOOR(COUNT(*) * 0.25) FROM `Video_Games` WHERE Critic_Score IS NOT NULL
         )) AS score_p25,
        (SELECT Global_Sales FROM `Video_Games`
         WHERE Global_Sales IS NOT NULL
         ORDER BY Global_Sales ASC LIMIT 1 OFFSET (
            SELECT FLOOR(COUNT(*) * 0.25) FROM `Video_Games` WHERE Global_Sales IS NOT NULL
         )) AS sales_p25,
        (SELECT Critic_Score FROM `Video_Games`
         WHERE Critic_Score IS NOT NULL
         ORDER BY Critic_Score DESC LIMIT 1 OFFSET (
            SELECT FLOOR(COUNT(*) * 0.25) FROM `Video_Games` WHERE Critic_Score IS NOT NULL
         )) AS score_p75
)
-- Hidden gems: top 25% sales but bottom 25% critic score
SELECT
    'Hidden Gem' AS category,
    Game_Name,
    Critic_Score,
    Global_Sales
FROM `Video_Games`, thresholds
WHERE Global_Sales >= sales_p75
  AND Critic_Score <= score_p25
  AND Critic_Score IS NOT NULL

UNION ALL

-- Over-marketed: bottom 25% sales but top 25% critic score
SELECT
    'Overhyped/Underperformed' AS category,
    Game_Name,
    Critic_Score,
    Global_Sales
FROM `Video_Games`, thresholds
WHERE Global_Sales <= sales_p25
  AND Critic_Score >= score_p75
  AND Critic_Score IS NOT NULL

ORDER BY category, Global_Sales DESC;


-- Q7: Does Japan (JP_Sales) prefer different types of games than North America and Europe?
-- FIX: original query was invalid SQL (FROM with no table, ANY() with multiple columns).
-- Compare regional totals per genre side by side instead.
SELECT
    Genre,
    ROUND(SUM(NA_Sales), 2)  AS NA_total,
    ROUND(SUM(EU_Sales), 2)  AS EU_total,
    ROUND(SUM(JP_Sales), 2)  AS JP_total,
    ROUND(SUM(JP_Sales) - SUM(NA_Sales), 2) AS JP_vs_NA_gap
FROM `Video_Games`
GROUP BY Genre
ORDER BY JP_total DESC;


-- Q8: Which platforms are dominant in each region?
-- (e.g., Nintendo stronger in Japan vs Xbox in America)
WITH regional_platform_sales AS (
    SELECT
        Platform,
        SUM(NA_Sales) AS NA_total,
        SUM(EU_Sales) AS EU_total,
        SUM(JP_Sales) AS JP_total
    FROM `Video_Games`
    GROUP BY Platform
)
SELECT 'NA' AS Region, Platform, ROUND(NA_total, 2) AS total_sales
FROM regional_platform_sales
ORDER BY NA_total DESC
LIMIT 5;

-- (Run separately for EU and JP by swapping the ORDER BY column,
--  or UNION them together if you want one combined result set)


-- Q9: Who are the most productive and consistently successful developers over the years?
-- FIX: original GROUP BY included Game_Name, which returned one row per game instead of
-- aggregating per developer. Now measures productivity (games shipped) and consistency
-- (years active) together.
SELECT
    Developer,
    COUNT(DISTINCT Game_Name)              AS total_games,
    COUNT(DISTINCT Year_of_Release)        AS years_active,
    CONCAT('$', ROUND(SUM(Global_Sales), 2), 'M') AS total_global_sales,
    CONCAT('$', ROUND(AVG(Global_Sales), 2), 'M') AS avg_sales_per_game
FROM `Video_Games`
WHERE Developer IS NOT NULL
GROUP BY Developer
ORDER BY total_games DESC, years_active DESC
LIMIT 20;