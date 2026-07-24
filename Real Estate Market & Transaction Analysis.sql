/*==========================================================
Real Estate Market & Transaction Analysis
SQL Project

Tools:
- MySQL 8.0
- SQL
- Window Functions
- CTEs
- Aggregate Functions

Author:
Arnnav Paul
==========================================================*/
CREATE DATABASE real_estate_project;
USE real_estate_project;

CREATE TABLE Properties (
    Property_ID VARCHAR(20),
    Type VARCHAR(100),
    City VARCHAR(100),
    Size_SqFt VARCHAR(50),
    Bedrooms VARCHAR(20),
    Bathrooms VARCHAR(20),
    Year_Built VARCHAR(20),
    Listing_Price VARCHAR(50),
    Rental_Price VARCHAR(50),
    Neighborhood VARCHAR(100),
    Status VARCHAR(30)
);

SET SQL_SAFE_UPDATES = 0;

UPDATE Properties
SET
    Type = NULLIF(TRIM(Type), ''),
    Size_SqFt = NULLIF(TRIM(Size_SqFt), ''),
    Listing_Price = NULLIF(TRIM(Listing_Price), ''),
    Rental_Price = NULLIF(TRIM(Rental_Price), ''),
    Year_Built = NULLIF(TRIM(Year_Built), '');
    
    SET SQL_SAFE_UPDATES = 1;
    
    SELECT
    SUM(Type IS NULL) AS Missing_Type,
    SUM(Size_SqFt IS NULL) AS Missing_Size,
    SUM(Listing_Price IS NULL) AS Missing_Listing,
    SUM(Rental_Price IS NULL) AS Missing_Rental,
    SUM(Year_Built IS NULL) AS Missing_Year
FROM Properties;

ALTER TABLE Properties
MODIFY Property_ID INT,
MODIFY Type VARCHAR(50),
MODIFY City VARCHAR(100),
MODIFY Size_SqFt DECIMAL(10,1),
MODIFY Bedrooms INT,
MODIFY Bathrooms INT,
MODIFY Year_Built YEAR,
MODIFY Listing_Price DECIMAL(18,8),
MODIFY Rental_Price DECIMAL(18,8),
MODIFY Neighborhood VARCHAR(100),
MODIFY Status VARCHAR(30);

CREATE TABLE Market_Trends (
    City VARCHAR(100),
    Year VARCHAR(20),
    Avg_Home_Price VARCHAR(50),
    Avg_Rent_Price VARCHAR(50),
    Housing_Demand_Index VARCHAR(50),
    Unemployment_Rate VARCHAR(50),
    Interest_Rate VARCHAR(50),
    New_Construction_Count VARCHAR(50),
    Investor_Activity_Score VARCHAR(50),
    Income_Bracket VARCHAR(50),
    Affordability_Avg_Home_Price VARCHAR(50),
    Affordability_Median_Household_Income VARCHAR(50),
    Affordability_Price_to_Income_Ratio VARCHAR(50),
    Affordability_Change_YoY VARCHAR(50)
);

SELECT COUNT(*) AS Total_Rows
FROM Market_Trends;

SET SQL_SAFE_UPDATES = 0;

UPDATE Market_Trends
SET
    City = NULLIF(TRIM(City), ''),
    Year = NULLIF(TRIM(Year), ''),
    Avg_Home_Price = NULLIF(TRIM(Avg_Home_Price), ''),
    Avg_Rent_Price = NULLIF(TRIM(Avg_Rent_Price), ''),
    Housing_Demand_Index = NULLIF(TRIM(Housing_Demand_Index), ''),
    Unemployment_Rate = NULLIF(TRIM(Unemployment_Rate), ''),
    Interest_Rate = NULLIF(TRIM(Interest_Rate), ''),
    New_Construction_Count = NULLIF(TRIM(New_Construction_Count), ''),
    Investor_Activity_Score = NULLIF(TRIM(Investor_Activity_Score), ''),
    Income_Bracket = NULLIF(TRIM(Income_Bracket), ''),
    Affordability_Avg_Home_Price = NULLIF(TRIM(Affordability_Avg_Home_Price), ''),
    Affordability_Median_Household_Income = NULLIF(TRIM(Affordability_Median_Household_Income), ''),
    Affordability_Price_to_Income_Ratio = NULLIF(TRIM(Affordability_Price_to_Income_Ratio), ''),
    Affordability_Change_YoY = NULLIF(TRIM(Affordability_Change_YoY), '');

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Market_Trends
MODIFY City VARCHAR(100),
MODIFY Year YEAR,
MODIFY Avg_Home_Price DECIMAL(15,2),
MODIFY Avg_Rent_Price DECIMAL(15,2),
MODIFY Housing_Demand_Index DECIMAL(6,2),
MODIFY Unemployment_Rate DECIMAL(5,2),
MODIFY Interest_Rate DECIMAL(4,2),
MODIFY New_Construction_Count INT,
MODIFY Investor_Activity_Score DECIMAL(6,2),
MODIFY Income_Bracket VARCHAR(50),
MODIFY Affordability_Avg_Home_Price DECIMAL(15,2),
MODIFY Affordability_Median_Household_Income DECIMAL(15,2),
MODIFY Affordability_Price_to_Income_Ratio DECIMAL(6,2),
MODIFY Affordability_Change_YoY DECIMAL(6,2);

CREATE TABLE Agent (
    Agent_ID VARCHAR(20),
    Agent_Name VARCHAR(100),
    Experience_Years VARCHAR(20),
    Total_Sales_Closed VARCHAR(20),
    Total_Rentals_Closed VARCHAR(20),
    Agent_Rating VARCHAR(50)
);



SET SQL_SAFE_UPDATES = 0;

UPDATE Agent
SET
    Agent_Name = NULLIF(TRIM(Agent_Name), ''),
    Experience_Years = NULLIF(TRIM(Experience_Years), ''),
    Total_Sales_Closed = NULLIF(TRIM(Total_Sales_Closed), ''),
    Total_Rentals_Closed = NULLIF(TRIM(Total_Rentals_Closed), ''),
    Agent_Rating = NULLIF(TRIM(Agent_Rating), '');

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Agent
MODIFY Agent_ID INT,
MODIFY Agent_Name VARCHAR(100),
MODIFY Experience_Years INT,
MODIFY Total_Sales_Closed INT,
MODIFY Total_Rentals_Closed INT,
MODIFY Agent_Rating DECIMAL(10,9);

ALTER TABLE Agent
ADD PRIMARY KEY (Agent_ID);

-- ==========================================================
-- STAGE 1: DATA EXPLORATION & INITIAL ASSESSMENT
-- ==========================================================

-- ==========================================================
-- Q1: How can we evaluate the completeness and reliability of the real estate dataset to ensure sufficient data availability while identifying potential anomalies or data collection issues?
-- ==========================================================
-- ----------------------------------------------------------
-- Q1.1 Examine the total number of records across key tables to determine whether the dataset is extensive enough for meaningful analysis.
-- ----------------------------------------------------------

SELECT 'Properties' AS Table_Name, COUNT(*) AS Total_Records
FROM Properties
UNION ALL
SELECT 'Market_Trends', COUNT(*)
FROM Market_Trends
UNION ALL
SELECT 'Agent', COUNT(*)
FROM Agent;

-- ----------------------------------------------------------
-- Q1.2 Identify unexpectedly low record counts, which may indicate gaps in data collection or reporting  inconsistencies.
-- ----------------------------------------------------------
-- Record count by City (Market Trends)
SELECT
City,
COUNT(*) AS Records_Per_City
FROM Market_Trends
GROUP BY City
ORDER BY Records_Per_City ASC;

-- Record count by Year (Market Trends)
SELECT
Year,
COUNT(*) AS Records_Per_Year
FROM Market_Trends
GROUP BY Year
ORDER BY Year;

-- Property count by City

SELECT
City,
COUNT(*) AS Property_Count
FROM Properties
GROUP BY City
ORDER BY Property_Count ASC;

-- ----------------------------------------------------------
-- Q1.3 Categorize undefined property types as 'Other' using a CASE statement to ensure consistent data classification.
-- ----------------------------------------------------------

SELECT
    CASE
        WHEN Type IS NULL OR TRIM(Type) = '' THEN 'Other'
        ELSE Type
    END AS Property_Type,
    COUNT(*) AS Total_Properties
FROM Properties
GROUP BY Property_Type
ORDER BY Total_Properties DESC;

-- ----------------------------------------------------------
-- Q1.4 Ensure all property transactions include valid Property IDs.
-- ----------------------------------------------------------
-- Check for NULL Property IDs
SELECT
    COUNT(*) AS Null_Property_IDs
FROM Properties
WHERE Property_ID IS NULL;
-- Check for Duplicate Property IDs
SELECT
Property_ID,
COUNT(*) AS Occurrences
FROM Properties
GROUP BY Property_ID
HAVING COUNT(*) > 1;

-- ==========================================================
-- Q2: How comprehensive is the transaction data, and does
-- missing field percentage impact market analysis depth?
-- ==========================================================
-- ----------------------------------------------------------
-- Q2.1 Count missing values in essential fields
-- ----------------------------------------------------------

SELECT
SUM(Listing_Price IS NULL) AS Missing_Listing_Price,
SUM(Type IS NULL) AS Missing_Property_Type,
SUM(Size_SqFt IS NULL) AS Missing_Size_SqFt,
COUNT(*) AS Total_Records
FROM Properties;

-- ----------------------------------------------------------
-- Q2.2 Calculate the percentage of missing values in essential fields
-- ----------------------------------------------------------

SELECT
ROUND(SUM(Listing_Price IS NULL) * 100.0 / COUNT(*), 2) AS Pct_Missing_Listing_Price,
ROUND(SUM(Type IS NULL) * 100.0 / COUNT(*), 2) AS Pct_Missing_Property_Type,
ROUND(SUM(Size_SqFt IS NULL) * 100.0 / COUNT(*), 2) AS Pct_Missing_Size_SqFt
FROM Properties;

-- ----------------------------------------------------------
-- Q2.3 Identify cities where missing values are concentrated, helping prioritize data cleaning.
-- ----------------------------------------------------------

SELECT
City,COUNT(*) AS Total_Records,
ROUND(SUM(Listing_Price IS NULL) * 100.0 / COUNT(*), 2) AS Pct_Missing_Listing_Price,
ROUND(SUM(Type IS NULL) * 100.0 / COUNT(*), 2) AS Pct_Missing_Property_Type,
ROUND(SUM(Size_SqFt IS NULL) * 100.0 / COUNT(*), 2) AS Pct_Missing_Size_SqFt
FROM Properties
GROUP BY City
ORDER BY Pct_Missing_Listing_Price DESC;


-- ==========================================================
-- Q3: How can we detect duplicate property transactions,
-- extreme pricing values, and unrealistic property sizes
-- to ensure data accuracy?
--
-- To maintain the integrity of real estate transaction
-- analysis, it is essential to identify inconsistencies
-- in the dataset. Duplicate transaction records can inflate
-- market trends, incorrect pricing values may distort
-- financial insights, and unrealistic property sizes can
-- lead to flawed investment assessments.
-- ==========================================================


-- ----------------------------------------------------------
-- Q3.1 Identify duplicate property transactions based on Property_ID, City, Property Type, and Listing Price.
-- ----------------------------------------------------------

SELECT
    Property_ID,
    City,
    Type,
    Listing_Price,
    COUNT(*) AS Occurrences
FROM Properties
GROUP BY
    Property_ID,
    City,
    Type,
    Listing_Price
HAVING COUNT(*) > 1;

-- ----------------------------------------------------------
-- Q3.2 Check for duplicate Property IDs to identify accidental duplicate records.
-- ----------------------------------------------------------

SELECT
Property_ID,
COUNT(*) AS Occurrences
FROM Properties
GROUP BY Property_ID
HAVING COUNT(*) > 1;

-- ----------------------------------------------------------
-- Q3.3 Detect properties with invalid listing or rental
-- prices (negative or zero values).
-- ----------------------------------------------------------

SELECT *
FROM Properties
WHERE Listing_Price <= 0
   OR Rental_Price <= 0;
   
   -- ----------------------------------------------------------
-- Q3.4 Identify pricing outliers by detecting the
-- top 1% highest listing prices using PERCENT_RANK().
-- ----------------------------------------------------------

SELECT
Property_ID,
City,
Type,
Listing_Price
FROM
(SELECT
Property_ID,
City,
Type,
Listing_Price,
PERCENT_RANK() OVER (ORDER BY Listing_Price) AS Pct_Rank
FROM Properties
WHERE Listing_Price IS NOT NULL
) AS Ranked_Prices
WHERE Pct_Rank >= 0.99
ORDER BY Listing_Price DESC;

-- ----------------------------------------------------------
-- Q3.5 Detect properties with negative listing or rental
-- prices that may indicate data entry errors.
-- ----------------------------------------------------------

SELECT
Property_ID,
City,
Type,
Listing_Price,
Rental_Price
FROM Properties
WHERE Listing_Price < 0
OR Rental_Price < 0;

-- ----------------------------------------------------------
-- Q3.6 Review the distribution of property sizes to
-- understand the range of Size_SqFt values.
-- ----------------------------------------------------------

SELECT
MIN(Size_SqFt) AS Minimum_Size,
MAX(Size_SqFt) AS Maximum_Size,
ROUND(AVG(Size_SqFt),2) AS Average_Size
FROM Properties;

-- ----------------------------------------------------------
-- Q3.7 Detect extreme property size outliers using
-- PERCENT_RANK().
-- ----------------------------------------------------------

SELECT
Property_ID,
City,
Type,
Size_SqFt
FROM
(SELECT
Property_ID,
City,
Type,
Size_SqFt,
PERCENT_RANK() OVER (ORDER BY Size_SqFt) AS Pct_Rank
FROM Properties
WHERE Size_SqFt IS NOT NULL
) AS Ranked_Size
WHERE Pct_Rank >= 0.99
OR Pct_Rank <= 0.01
ORDER BY Size_SqFt DESC;

-- ==========================================================
-- STAGE 2: DATA CLEANING & INTEGRITY MANAGEMENT
-- ==========================================================

-- ==========================================================
-- Q1: How can we handle missing values in transaction
-- price and property size?
-- ==========================================================
SET SQL_SAFE_UPDATES = 0;

UPDATE Properties
SET Type = 'Other'
WHERE (Type IS NULL OR TRIM(Type) = '')
  AND Property_ID > 0;

-- ----------------------------------------------------------
-- Q1.1 Impute missing Listing_Price values using the
-- median Listing_Price of properties with the same
-- City and Property Type.
-- ----------------------------------------------------------

UPDATE Properties p
JOIN (SELECT
City,Type,AVG(Listing_Price) AS Median_Price
FROM
(SELECT City,Type,
Listing_Price,
ROW_NUMBER() OVER (PARTITION BY City, Type ORDER BY Listing_Price
) AS rn,
COUNT(*) OVER (
PARTITION BY City, Type
) AS cnt
FROM Properties
WHERE Listing_Price IS NOT NULL) x
WHERE rn IN (FLOOR((cnt + 1)/2), FLOOR((cnt + 2)/2))
GROUP BY City, Type
) m
ON p.City = m.City
AND p.Type = m.Type
SET p.Listing_Price = m.Median_Price
WHERE p.Listing_Price IS NULL;

-- ----------------------------------------------------------
-- Q1.2 Impute missing Size_SqFt using the average size of similar properties within the same City and Property Type.
-- ----------------------------------------------------------

UPDATE Properties p

JOIN
(SELECT City,Type,
AVG(Size_SqFt) AS Avg_Size
FROM Properties
WHERE Size_SqFt IS NOT NULL
GROUP BY City,
Type) Avg_Size_Table
ON p.City = Avg_Size_Table.City
AND p.Type = Avg_Size_Table.Type
SET p.Size_SqFt = Avg_Size_Table.Avg_Size
WHERE p.Size_SqFt IS NULL;

-- ==========================================================
-- Q3: Correct Extreme Listing Prices
-- ==========================================================

-- Remove invalid listing prices
SET SQL_SAFE_UPDATES = 0;

DELETE FROM Properties
WHERE Listing_Price <= 0
  AND Property_ID > 0;

-- Cap extremely high prices at the 99th percentile for each city
UPDATE Properties p
JOIN (
    SELECT
        City,
        MIN(Listing_Price) AS Cap_Price
    FROM (
        SELECT
            City,
            Listing_Price,
            PERCENT_RANK() OVER (
                PARTITION BY City
                ORDER BY Listing_Price
            ) AS Pct_Rank
        FROM Properties
        WHERE Listing_Price IS NOT NULL
    ) ranked
    WHERE Pct_Rank >= 0.99
    GROUP BY City
) caps
ON p.City = caps.City
SET p.Listing_Price = caps.Cap_Price
WHERE p.Listing_Price > caps.Cap_Price;

SET SQL_SAFE_UPDATES = 1;

-- Verify updated price range
SELECT
    MIN(Listing_Price) AS Minimum_Price,
    MAX(Listing_Price) AS Maximum_Price
FROM Properties;

-- ----------------------------------------------------------
-- Q1.4 Verify that missing values have been imputed.
-- ----------------------------------------------------------

SELECT
SUM(Listing_Price IS NULL) AS Remaining_Missing_Listing_Price,
SUM(Size_SqFt IS NULL) AS Remaining_Missing_Size_SqFt
FROM Properties;


-- ----------------------------------------------------------
-- Q1.5 Handle any remaining missing values using the Property Type average as a fallback.
-- ----------------------------------------------------------

UPDATE Properties p

JOIN
(SELECT Type,AVG(Listing_Price) AS Avg_Listing_Price
FROM Properties
WHERE Listing_Price IS NOT NULL
GROUP BY Type
) Type_Average
ON p.Type = Type_Average.Type
SET p.Listing_Price = Type_Average.Avg_Listing_Price
WHERE p.Listing_Price IS NULL;

UPDATE Properties p
JOIN
(SELECT
Type,AVG(Size_SqFt) AS Avg_Size
FROM Properties
WHERE Size_SqFt IS NOT NULL
GROUP BY Type
) Type_Size
ON p.Type = Type_Size.Type
SET p.Size_SqFt = Type_Size.Avg_Size
WHERE p.Size_SqFt IS NULL;

-- ----------------------------------------------------------
-- Q1.8 Re-enable Safe Update Mode.
-- ----------------------------------------------------------

SET SQL_SAFE_UPDATES = 1;

SELECT
    Property_ID,
    Listing_Price,
    Neighborhood,
    COUNT(*) AS Duplicate_Count
FROM Properties
GROUP BY
    Property_ID,
    Listing_Price,
    Neighborhood
HAVING COUNT(*) > 1;

-- ==========================================================
-- STAGE 3: MARKET TRENDS & PRICING ANALYSIS
-- ==========================================================

-- ==========================================================
-- Q1: How does property pricing vary across different cities over time?
-- ==========================================================
-- ----------------------------------------------------------
-- Q1.1 Calculate the average property listing price for each city and year.
-- ----------------------------------------------------------

SELECT
City,Year,ROUND(AVG(Avg_Home_Price), 2) AS Average_Listing_Price
FROM Market_Trends
GROUP BY City,Year
ORDER BY City,Year;

-- ----------------------------------------------------------
-- Q1.2 Calculate the Year-on-Year (YoY) percentage
-- change in average home prices from 2019 to 2023.
-- ----------------------------------------------------------

SELECT
City,Year,Avg_Home_Price,
LAG(Avg_Home_Price) OVER(PARTITION BY City ORDER BY Year) AS Previous_Year_Price,
ROUND((Avg_Home_Price - LAG(Avg_Home_Price) OVER
(PARTITION BY City ORDER BY Year))/LAG(Avg_Home_Price) OVER(PARTITION BY City ORDER BY Year ) * 100,2) AS YoY_Percentage_Change
FROM Market_Trends
WHERE Year BETWEEN 2019 AND 2023
ORDER BY City,Year;

-- ----------------------------------------------------------
-- Q1.3 Display listing price trends across cities over consecutive years.
-- ----------------------------------------------------------

SELECT City,Year,Avg_Home_Price
FROM Market_Trends
WHERE Year BETWEEN 2019 AND 2023
ORDER BY City,Year;
-- ----------------------------------------------------------
-- Q1.4 Compare listing prices across major cities using conditional aggregation.
-- ----------------------------------------------------------

SELECT
Year,
ROUND(AVG(CASE WHEN City = 'New York' THEN Avg_Home_Price END),2) AS New_York,
ROUND(AVG(CASE WHEN City = 'Los Angeles' THEN Avg_Home_Price END),2) AS Los_Angeles,
ROUND(AVG(CASE WHEN City = 'San Francisco' THEN Avg_Home_Price END),2) AS San_Francisco,
ROUND(AVG(CASE WHEN City = 'Chicago' THEN Avg_Home_Price END),2) AS Chicago,
ROUND(AVG(CASE WHEN City = 'Miami' THEN Avg_Home_Price END),2) AS Miami,
ROUND(AVG(CASE WHEN City = 'Seattle' THEN Avg_Home_Price END),2) AS Seattle
FROM Market_Trends
WHERE Year BETWEEN 2019 AND 2023
GROUP BY Year
ORDER BY Year;

-- ==========================================================
-- STAGE 3: MARKET TRENDS & PRICING ANALYSIS
-- ==========================================================
-- ==========================================================
-- Q2: Highest and Lowest Property Values by Year
-- ==========================================================

WITH Yearly_City_Price AS (
    SELECT
        Year,
        City,
        ROUND(AVG(Avg_Home_Price),2) AS Avg_Price,
        RANK() OVER (
            PARTITION BY Year
            ORDER BY AVG(Avg_Home_Price) DESC
        ) AS High_Rank,
        RANK() OVER (
            PARTITION BY Year
            ORDER BY AVG(Avg_Home_Price)
        ) AS Low_Rank
    FROM Market_Trends
    GROUP BY Year, City
)

SELECT
    Year,
    CASE
        WHEN High_Rank = 1 THEN 'Highest Property Values'
        ELSE 'Lowest Property Values'
    END AS Property_Values,
    City,
    Avg_Price
FROM Yearly_City_Price
WHERE High_Rank = 1
   OR Low_Rank = 1
ORDER BY Year;

-- Year-over-Year Price Change

SELECT
    Year,
    City,
    ROUND(AVG(Avg_Home_Price),2) AS Current_Price,

    ROUND(
        (
            AVG(Avg_Home_Price)
            -
            LAG(AVG(Avg_Home_Price))
            OVER(PARTITION BY City ORDER BY Year)
        )
        /
        NULLIF(
            LAG(AVG(Avg_Home_Price))
            OVER(PARTITION BY City ORDER BY Year),
            0
        ) * 100,
        2
    ) AS Price_Change_Percentage,

    CASE
        WHEN AVG(Avg_Home_Price)
             >
             LAG(AVG(Avg_Home_Price))
             OVER(PARTITION BY City ORDER BY Year)
        THEN 'Increase'

        WHEN AVG(Avg_Home_Price)
             <
             LAG(AVG(Avg_Home_Price))
             OVER(PARTITION BY City ORDER BY Year)
        THEN 'Decline'

        ELSE 'No Change'
    END AS Trend

FROM Market_Trends
GROUP BY Year, City
ORDER BY City, Year;

-- ==========================================================
-- Q3: How do property prices vary by property type?
-- ==========================================================
-- ----------------------------------------------------------
-- Q3.1 Compare the average listing price for each property type to identify the most expensive and affordable housing options.
-- ----------------------------------------------------------

SELECT
Type AS Property_Type,
COUNT(*) AS Total_Listings,
ROUND(AVG(Listing_Price),2) AS Average_Listing_Price,
ROUND(MIN(Listing_Price),2) AS Minimum_Listing_Price,
ROUND(MAX(Listing_Price),2) AS Maximum_Listing_Price
FROM Properties
WHERE Listing_Price IS NOT NULL
GROUP BY Type
ORDER BY Average_Listing_Price DESC;

-- ----------------------------------------------------------
-- Q3.2 Analyze pricing variability within each property type using Standard Deviation. Higher standard deviation indicates greater price variation and investment risk.
-- ----------------------------------------------------------

SELECT
Type AS Property_Type,
COUNT(*) AS Total_Listings,
ROUND(AVG(Listing_Price),2) AS Average_Listing_Price,
ROUND(STDDEV(Listing_Price),2) AS Price_Standard_Deviation,
ROUND(MIN(Listing_Price),2) AS Minimum_Listing_Price,
ROUND(MAX(Listing_Price),2) AS Maximum_Listing_Price
FROM Properties
WHERE Listing_Price IS NOT NULL
GROUP BY Type
ORDER BY Average_Listing_Price DESC;

-- ----------------------------------------------------------
-- Q3.3 Compare average property prices across different property types within each city.
-- ----------------------------------------------------------

SELECT
City,Type AS Property_Type,
COUNT(*) AS Total_Listings,
ROUND(AVG(Listing_Price),2) AS Average_Listing_Price
FROM Properties
WHERE Listing_Price IS NOT NULL
GROUP BY City,Type
ORDER BY
City,Average_Listing_Price DESC;

-- ----------------------------------------------------------
-- Q3.4 Classify each property type into Premium,Mid-Range, and Budget market segments based on the overall average listing price.
-- ----------------------------------------------------------

WITH Type_Average AS
(
SELECT
Type,
ROUND(AVG(Listing_Price),2) AS Average_Listing_Price
FROM Properties
WHERE Listing_Price IS NOT NULL
GROUP BY Type
),
Overall_Average AS
(
    SELECT
        AVG(Listing_Price) AS Overall_Average_Price
    FROM Properties
    WHERE Listing_Price IS NOT NULL
)
SELECT
t.Type AS Property_Type,
t.Average_Listing_Price,
CASE
WHEN t.Average_Listing_Price >= o.Overall_Average_Price * 1.20
THEN 'Premium'
WHEN t.Average_Listing_Price <= o.Overall_Average_Price * 0.80
THEN 'Budget'
ELSE 'Mid-Range'
END AS Market_Segment
FROM Type_Average t
CROSS JOIN Overall_Average o
ORDER BY t.Average_Listing_Price DESC;

-- ----------------------------------------------------------
-- Q3.5 Calculate the market share of each property type based on the total number of listings.
-- ----------------------------------------------------------

SELECT
Type AS Property_Type,
COUNT(*) AS Listing_Count,
ROUND(COUNT(*) * 100.0 /
(SELECT 
COUNT(*)
FROM Properties
WHERE Type IS NOT NULL),2) AS Market_Share_Percentage
FROM Properties
WHERE Type IS NOT NULL
GROUP BY Type
ORDER BY
Listing_Count DESC;

-- ==========================================================
-- Q4: Which property types are most frequently listed,
-- and how does listing volume vary across cities?
--
-- This analysis identifies the most frequently listed
-- property types, compares listing volumes across cities,
-- and evaluates whether demand for specific property
-- types varies by location.
-- ==========================================================


-- ----------------------------------------------------------
-- Q4.1 Identify the most frequently listed property types to understand what dominates the real estate market.
-- ----------------------------------------------------------

SELECT
Type AS Property_Type,
COUNT(*) AS Listing_Count,
ROUND(
COUNT(*) * 100.0 /
(
SELECT COUNT(*)
FROM Properties WHERE Type IS NOT NULL),2) AS Market_Share_Percentage
FROM Properties
WHERE Type IS NOT NULL
GROUP BY Type
ORDER BY Listing_Count DESC;

-- ----------------------------------------------------------
-- Q4.2 Compare listing volumes across cities to determine
-- which cities have the highest real estate activity.
-- ----------------------------------------------------------

SELECT
City,
COUNT(*) AS Total_Listings,
ROUND(COUNT(*) * 100.0 /
(
SELECT COUNT(*)
FROM Properties),2) AS Market_Share_Percentage
FROM Properties
GROUP BY City
ORDER BY Total_Listings DESC;

-- ----------------------------------------------------------
-- Q4.3 Analyze whether demand for certain property types fluctuates across different cities.
-- ----------------------------------------------------------

SELECT
City,
Type AS Property_Type,
COUNT(*) AS Total_Listings
FROM Properties
WHERE Type IS NOT NULL
GROUP BY
City,Type
ORDER BY
City,Total_Listings DESC;


-- ----------------------------------------------------------
-- Q4.4 Calculate the percentage share of each property
-- type within every city to compare local demand patterns.
-- ----------------------------------------------------------

SELECT
City,
Type AS Property_Type,
COUNT(*) AS Total_Listings,
ROUND(COUNT(*) * 100.0 /SUM(COUNT(*)) OVER (PARTITION BY City),2) AS Percentage_Within_City
FROM Properties
WHERE Type IS NOT NULL
GROUP BY
City,Type
ORDER BY
City,Percentage_Within_City DESC;

-- ==========================================================
-- Q5: How do interest rate changes impact property prices?
--
-- Interest rates directly affect mortgage affordability,
-- influencing buyer behavior and property pricing.
-- This analysis examines how changes in interest rates
-- impact average home prices and overall market trends.
-- ==========================================================


-- ----------------------------------------------------------
-- Q5.1 Compare average home prices at different interest rate levels to understand pricing sensitivity.
-- ----------------------------------------------------------

SELECT
CASE WHEN Interest_Rate < 3 THEN 'Below 3%'
WHEN Interest_Rate BETWEEN 3 AND 4.99 THEN '3% - 5%'
WHEN Interest_Rate BETWEEN 5 AND 6.99 THEN '5% - 7%'
ELSE '7% and Above'
END AS Interest_Rate_Band,
COUNT(*) AS Total_Records,
ROUND(AVG(Avg_Home_Price),2) AS Average_Home_Price
FROM Market_Trends
WHERE Interest_Rate IS NOT NULL
AND Avg_Home_Price IS NOT NULL
GROUP BY Interest_Rate_Band
ORDER BY
CASE WHEN Interest_Rate_Band = 'Below 3%' THEN 1
WHEN Interest_Rate_Band = '3% - 5%' THEN 2
WHEN Interest_Rate_Band = '5% - 7%' THEN 3
ELSE 4
END;

-- ----------------------------------------------------------
-- Q5.2 Identify whether price growth slows when interest rates rise.
-- ----------------------------------------------------------

WITH Yearly_Data AS
(SELECT
City,Year,
ROUND(AVG(Interest_Rate),2) AS Interest_Rate,
ROUND(AVG(Avg_Home_Price),2) AS Avg_Home_Price
FROM Market_Trends
GROUP BY City,Year)
SELECT
City,Year,Interest_Rate,Avg_Home_Price,
ROUND(Interest_Rate -LAG(Interest_Rate)OVER(PARTITION BY City ORDER BY Year),2) AS Interest_Rate_Change,
ROUND((Avg_Home_Price -LAG(Avg_Home_Price)
OVER(PARTITION BY City ORDER BY Year))/LAG(Avg_Home_Price)OVER(PARTITION BY City ORDER BY Year)* 100,2) AS Price_Growth_Percentage
FROM Yearly_Data
ORDER BY City,Year;

-- ----------------------------------------------------------
-- Q5.3 Analyze the overall relationship between
-- interest rates and average home prices using
-- Pearson Correlation.
-- ----------------------------------------------------------

SELECT
ROUND((COUNT(*) * SUM(Interest_Rate * Avg_Home_Price)
-SUM(Interest_Rate) * SUM(Avg_Home_Price))/
(SQRT(COUNT(*) * SUM(POW(Interest_Rate,2))
-POW(SUM(Interest_Rate),2))*SQRT(COUNT(*) * SUM(POW(Avg_Home_Price,2))
-POW(SUM(Avg_Home_Price),2))),4)
AS Correlation_Rate_vs_Price
FROM Market_Trends
WHERE Interest_Rate IS NOT NULL
AND Avg_Home_Price IS NOT NULL;

-- ==========================================================
-- STAGE 4: BUYER BEHAVIOR & INVESTMENT PATTERNS
-- ==========================================================

-- ==========================================================
-- Q1: Which Cities Exhibit the Strongest Housing Demand,and What Are the Typical Home and Rent Prices in These Areas?
-- ==========================================================
-- ----------------------------------------------------------
-- Q1.1 Identify cities with the highest Housing Demand Index.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Housing_Demand_Index),2) AS Average_Housing_Demand_Index
FROM Market_Trends
WHERE Housing_Demand_Index IS NOT NULL
GROUP BY City
ORDER BY Average_Housing_Demand_Index DESC;

-- ----------------------------------------------------------
-- Q1.2 Retrieve the corresponding average home price and average rent price for each city.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Housing_Demand_Index),2) AS Average_Housing_Demand_Index,
ROUND(AVG(Avg_Home_Price),2) AS Average_Home_Price,
ROUND(AVG(Avg_Rent_Price),2) AS Average_Rent_Price
FROM Market_Trends
WHERE Housing_Demand_Index IS NOT NULL
GROUP BY City
ORDER BY Average_Housing_Demand_Index DESC;

-- ----------------------------------------------------------
-- Q1.3 Compare home prices and rental prices using the Price-to-Annual-Rent Ratio to evaluate affordability and investment opportunities.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Housing_Demand_Index),2) AS Average_Housing_Demand_Index,
ROUND(AVG(Avg_Home_Price),2) AS Average_Home_Price,
ROUND(AVG(Avg_Rent_Price),2) AS Average_Rent_Price,
ROUND(
AVG(Avg_Home_Price) /
NULLIF(AVG(Avg_Rent_Price) * 12,0),
2) AS Price_To_Annual_Rent_Ratio
FROM Market_Trends
WHERE Housing_Demand_Index IS NOT NULL
GROUP BY City
ORDER BY Average_Housing_Demand_Index DESC;

-- ----------------------------------------------------------
-- Q1.4 Identify high-demand cities with potential
-- affordability gaps and investment opportunities.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Housing_Demand_Index),2) AS Average_Housing_Demand_Index,
ROUND(AVG(Avg_Home_Price),2) AS Average_Home_Price,
ROUND(AVG(Avg_Rent_Price),2) AS Average_Rent_Price,
ROUND(AVG(Avg_Home_Price) /
NULLIF(AVG(Avg_Rent_Price) * 12,0),
2) AS Price_To_Annual_Rent_Ratio
FROM Market_Trends
WHERE Housing_Demand_Index IS NOT NULL
GROUP BY City
HAVING Average_Housing_Demand_Index >
(SELECT AVG(Housing_Demand_Index)
FROM Market_Trends)
ORDER BY Price_To_Annual_Rent_Ratio DESC;

-- ==========================================================
-- Q2: What is the distribution of property sizes across different property types?
-- ==========================================================
-- ----------------------------------------------------------
-- Q2.1 Compare average property sizes across different property types.
-- ----------------------------------------------------------

SELECT
Type AS Property_Type,
COUNT(*) AS Total_Listings,
ROUND(AVG(Size_SqFt), 2) AS Average_Size_SqFt
FROM Properties
WHERE Size_SqFt IS NOT NULL
GROUP BY Type
ORDER BY Average_Size_SqFt DESC;

-- ----------------------------------------------------------
-- Q2.2 Identify property types that consistently offer larger square footage using descriptive statistics.
-- ----------------------------------------------------------

SELECT
Type AS Property_Type,
COUNT(*) AS Total_Listings,
ROUND(AVG(Size_SqFt), 2) AS Average_Size_SqFt,
ROUND(STDDEV(Size_SqFt), 2) AS Size_Std_Deviation,
ROUND(MIN(Size_SqFt), 2) AS Minimum_Size,
ROUND(MAX(Size_SqFt), 2) AS Maximum_Size
FROM Properties
WHERE Size_SqFt IS NOT NULL
GROUP BY Type
ORDER BY Average_Size_SqFt DESC;

-- ----------------------------------------------------------
-- Q2.3 Analyze the distribution of property sizes
-- using size categories.
-- ----------------------------------------------------------

SELECT
Type AS Property_Type,
CASE WHEN Size_SqFt < 800 THEN 'Under 800 SqFt'
WHEN Size_SqFt BETWEEN 800 AND 1499 THEN '800 - 1,499 SqFt'
WHEN Size_SqFt BETWEEN 1500 AND 2499 THEN '1,500 - 2,499 SqFt'
WHEN Size_SqFt BETWEEN 2500 AND 3999 THEN '2,500 - 3,999 SqFt'
ELSE '4,000+ SqFt'
END AS Size_Category,
COUNT(*) AS Total_Properties
FROM Properties
WHERE Size_SqFt IS NOT NULL
GROUP BY Type,Size_Category
ORDER BY Type,
FIELD(Size_Category,'Under 800 SqFt','800 - 1,499 SqFt','1,500 - 2,499 SqFt','2,500 - 3,999 SqFt','4,000+ SqFt');

-- ==========================================================
-- STAGE 5: HOUSING SUPPLY & MARKET COMPETITIVENESS
-- ==========================================================
-- ==========================================================
-- Q1: Which years saw the highest number of new property developments?
-- ==========================================================
-- ----------------------------------------------------------
-- Q1.1 Track the total number of new properties built each year.
-- ----------------------------------------------------------

SELECT
Year,
SUM(New_Construction_Count) AS Total_New_Constructions
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
GROUP BY Year
ORDER BY Year;

-- ----------------------------------------------------------
-- Q1.2 Observe construction activity across cities over time to understand supply trends.
-- ----------------------------------------------------------

SELECT
City,Year,New_Construction_Count
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
ORDER BY City,Year;

-- ----------------------------------------------------------
-- Q1.3 Determine the years with the highest and lowest number of newly constructed properties.
-- ----------------------------------------------------------

SELECT
Year,
Total_New_Constructions
FROM
(SELECT
Year,
SUM(New_Construction_Count) AS Total_New_Constructions,
RANK() OVER (ORDER BY SUM(New_Construction_Count) DESC) AS Highest_Rank,
RANK() OVER (ORDER BY SUM(New_Construction_Count) ASC
) AS Lowest_Rank
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
GROUP BY Year) Ranked_Years
WHERE Highest_Rank = 1
OR Lowest_Rank = 1;

-- ----------------------------------------------------------
-- Q1.4 Analyze year-over-year changes in construction
-- activity across cities.
-- ----------------------------------------------------------

SELECT
City,
Year,
New_Construction_Count,
New_Construction_Count -
LAG(New_Construction_Count)
OVER (PARTITION BY City ORDER BY Year) AS Construction_Change,
ROUND((New_Construction_Count -
LAG(New_Construction_Count)
OVER (PARTITION BY City ORDER BY Year))/NULLIF(LAG(New_Construction_Count)OVER (PARTITION BY City ORDER BY Year),0) * 100,2) AS Construction_Growth_Percentage
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
ORDER BY City,Year;

-- ==========================================================
-- Q2: Which cities have experienced the most new construction over the past years?
-- ==========================================================
-- ----------------------------------------------------------
-- Q2.1 Identify cities with the highest number of newly built properties.
-- ----------------------------------------------------------

SELECT
City,SUM(New_Construction_Count) AS Total_New_Constructions
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
GROUP BY City
ORDER BY Total_New_Constructions DESC;

-- ----------------------------------------------------------
-- Q2.2 Rank cities based on total construction activity.
-- ----------------------------------------------------------

SELECT
City,SUM(New_Construction_Count) AS Total_New_Constructions,
RANK() OVER(ORDER BY SUM(New_Construction_Count) DESC) AS Development_Rank
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
GROUP BY City
ORDER BY
Development_Rank;

-- ----------------------------------------------------------
-- Q2.3 Determine whether construction activity is
-- concentrated in specific metropolitan regions.
-- ----------------------------------------------------------

SELECT
City,
SUM(New_Construction_Count) AS Total_New_Constructions,
ROUND(SUM(New_Construction_Count) * 100.0 /
SUM(SUM(New_Construction_Count)) OVER (),2) AS Construction_Market_Share_Percentage
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
GROUP BY City
ORDER BY
Construction_Market_Share_Percentage DESC;

-- ----------------------------------------------------------
-- Q2.4 Analyze construction trends by city over time.
-- ----------------------------------------------------------

SELECT
City,Year,New_Construction_Count,
RANK() OVER(PARTITION BY City ORDER BY New_Construction_Count DESC) AS Rank_Within_City
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
ORDER BY
City,Year;

-- ----------------------------------------------------------
-- Q2.5 Compare construction activity with housing demand and average home prices.
-- ----------------------------------------------------------

SELECT
City,
SUM(New_Construction_Count) AS Total_New_Constructions,
ROUND(AVG(Housing_Demand_Index),2) AS Average_Housing_Demand,
ROUND(AVG(Avg_Home_Price),2) AS Average_Home_Price
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
GROUP BY City
ORDER BY
Total_New_Constructions DESC;

-- ==========================================================
-- Q3: How does new construction impact average home prices?
-- ==========================================================
-- ----------------------------------------------------------
-- Q3.1 Identify construction spike years for each city.
-- A spike year is defined as construction activity that is at least 30% above the city's average.
-- ----------------------------------------------------------

SELECT
City,Year,
New_Construction_Count,
ROUND(AVG(New_Construction_Count)OVER(PARTITION BY City),2) AS City_Average_Construction,
CASE WHEN New_Construction_Count >AVG(New_Construction_Count)OVER(PARTITION BY City) * 1.30
THEN 'Spike Year'
ELSE 'Normal Year'
END AS Construction_Status
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
ORDER BY City,Year;

-- ----------------------------------------------------------
-- Q3.2 Compare average home prices before, during, and after construction spike years.
-- ----------------------------------------------------------

WITH Construction_Spikes AS
(SELECT
City,Year,New_Construction_Count,Avg_Home_Price,
CASE WHEN New_Construction_Count >AVG(New_Construction_Count)OVER(PARTITION BY City) * 1.30
THEN 'Spike Year'
ELSE 'Normal Year'
END AS Construction_Status
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
AND Avg_Home_Price IS NOT NULL)
SELECT
City,Year,
Construction_Status,
LAG(Avg_Home_Price)
OVER(PARTITION BY City ORDER BY Year) AS Price_Before,
Avg_Home_Price AS Price_During,
LEAD(Avg_Home_Price)
OVER(PARTITION BY City ORDER BY Year) AS Price_After,
ROUND((LEAD(Avg_Home_Price)OVER(PARTITION BY City ORDER BY Year)- 
Avg_Home_Price)/Avg_Home_Price * 100,2) AS Price_Change_After_Spike_Percentage
FROM Construction_Spikes
WHERE Construction_Status = 'Spike Year'
ORDER BY City,Year;

-- ----------------------------------------------------------
-- Q3.3 Calculate the overall correlation between new construction and average home prices.
-- ----------------------------------------------------------

SELECT
ROUND((COUNT(*) * SUM(New_Construction_Count * Avg_Home_Price)
- SUM(New_Construction_Count) * SUM(Avg_Home_Price)
)/(SQRT(COUNT(*) * SUM(POW(New_Construction_Count,2))-POW(SUM(New_Construction_Count),2))*SQRT
(COUNT(*) * SUM(POW(Avg_Home_Price,2))-POW(SUM(Avg_Home_Price),2))),4) AS Correlation_Construction_vs_HomePrice
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
AND Avg_Home_Price IS NOT NULL;

-- ----------------------------------------------------------
-- Q3.4 Calculate the correlation between construction
-- activity and home prices for each city.
-- ----------------------------------------------------------

SELECT
City,
ROUND(
(COUNT(*) * SUM(New_Construction_Count * Avg_Home_Price)- SUM(New_Construction_Count) * SUM(Avg_Home_Price)
)/(SQRT(COUNT(*) * SUM(POW(New_Construction_Count,2))-POW(SUM(New_Construction_Count),2))
*SQRT(COUNT(*) * SUM(POW(Avg_Home_Price,2))-POW(SUM(Avg_Home_Price),2))),4) AS Correlation_Construction_vs_HomePrice
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
AND Avg_Home_Price IS NOT NULL
GROUP BY City
HAVING COUNT(*) > 2
ORDER BY Correlation_Construction_vs_HomePrice;

-- ----------------------------------------------------------
-- Q3.5 Compare construction activity, housing demand,
-- and average home prices across cities and years.
-- ----------------------------------------------------------

SELECT
City,Year,New_Construction_Count,
Housing_Demand_Index,Avg_Home_Price
FROM Market_Trends
WHERE New_Construction_Count IS NOT NULL
ORDER BY City,Year;

-- ==========================================================
-- Q4: Which cities have seen the highest changes in investor activity?
-- ==========================================================
-- ----------------------------------------------------------
-- Q4.1 Calculate the year-over-year investor activity change for each city.
-- ----------------------------------------------------------
WITH Yearly_Data AS
(SELECT
City,Year,
AVG(Investor_Activity_Score) AS Investor_Activity_Score
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City, Year)
SELECT
City,Year,ROUND(Investor_Activity_Score,2) AS Investor_Activity_Score,
ROUND(Investor_Activity_Score -
LAG(Investor_Activity_Score)OVER(PARTITION BY City ORDER BY Year),2) AS Change_From_Prior_Year
FROM Yearly_Data
ORDER BY City,Year;


-- ----------------------------------------------------------
-- Q4.2 Compare investor activity between the first and last available year for each city.
-- ----------------------------------------------------------

WITH City_Range AS
(
SELECT
City,
MIN(Year) AS Start_Year,
MAX(Year) AS End_Year
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City),
Start_End AS
(
SELECT
cr.City,
s.Investor_Activity_Score AS Start_Score,
e.Investor_Activity_Score AS End_Score
FROM City_Range cr
JOIN Market_Trends s
ON cr.City = s.City
AND cr.Start_Year = s.Year
JOIN Market_Trends e
ON cr.City = e.City
AND cr.End_Year = e.Year
)SELECT
City,Start_Score,End_Score,
ROUND(End_Score - Start_Score,2) AS Total_Change,
ROUND((End_Score - Start_Score) /NULLIF(Start_Score,0) * 100,2) AS Percentage_Change
FROM Start_End
ORDER BY
Total_Change DESC;

-- ----------------------------------------------------------
-- Q4.3 Rank cities by the magnitude of investor activity change.
-- ----------------------------------------------------------

WITH City_Range AS
(SELECT
City,
MIN(Year) AS Start_Year,
MAX(Year) AS End_Year
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City),
Start_End AS
(
SELECT
cr.City,
s.Investor_Activity_Score AS Start_Score,
e.Investor_Activity_Score AS End_Score
FROM City_Range cr
JOIN Market_Trends s
ON cr.City = s.City
AND cr.Start_Year = s.Year
JOIN Market_Trends e
ON cr.City = e.City
AND cr.End_Year = e.Year)
SELECT
City,Start_Score,End_Score,
ROUND(End_Score - Start_Score,2) AS Total_Change,
ROUND(ABS(End_Score - Start_Score),2) AS Absolute_Change
FROM Start_End
ORDER BY
Absolute_Change DESC;

-- ----------------------------------------------------------
-- Q4.4 Identify cities with little or no investor activity change.
-- ----------------------------------------------------------

WITH City_Range AS
(SELECT
City,
MIN(Year) AS Start_Year,
MAX(Year) AS End_Year
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City),
Start_End AS
(SELECT
cr.City,
s.Investor_Activity_Score AS Start_Score,
e.Investor_Activity_Score AS End_Score
FROM City_Range cr
JOIN Market_Trends s
ON cr.City = s.City
AND cr.Start_Year = s.Year
JOIN Market_Trends e
ON cr.City = e.City
AND cr.End_Year = e.Year)
SELECT
City,Start_Score,End_Score,
ROUND(End_Score - Start_Score,2) AS Total_Change
FROM Start_End
WHERE ABS(End_Score - Start_Score) <= 0.50
ORDER BY
ABS(Total_Change);

-- ----------------------------------------------------------
-- Q4.5 Measure investor activity volatility for each city.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity,
ROUND(STDDEV(Investor_Activity_Score),2) AS Investor_Activity_Volatility
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City
ORDER BY
Investor_Activity_Volatility DESC;

-- ==========================================================
-- STAGE 6: BUYER SEGMENTATION & AFFORDABILITY CHALLENGES
-- ==========================================================
-- ==========================================================
-- Q1: Which buyer segments are most active in the real estate market, and how do their preferences change over time?
-- ==========================================================
-- ----------------------------------------------------------
-- Q1.1 Analyze investor activity trends over time.
-- ----------------------------------------------------------
-- ==========================================================
-- DATA LIMITATION
-- ==========================================================
-- The provided dataset does not contain a Buyer_Type column
-- (e.g., Investor, First-Time Buyer, Repeat Buyer).
-- Therefore, Investor_Activity_Score is used as the closest
-- available proxy to analyze buyer behavior over time.


SELECT
Year,ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY Year
ORDER BY Year;

-- ----------------------------------------------------------
-- Q1.2 Calculate year-over-year change in investor activity using a window function.
-- ----------------------------------------------------------

WITH Investor_Trend AS
(SELECT
Year,
AVG(Investor_Activity_Score) AS Avg_Investor_Activity
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY Year)
SELECT
Year,
ROUND(Avg_Investor_Activity,2) AS Average_Investor_Activity,
ROUND(Avg_Investor_Activity -
LAG(Avg_Investor_Activity)OVER(ORDER BY Year),2) AS YoY_Change
FROM Investor_Trend
ORDER BY Year;

-- ----------------------------------------------------------
-- Q1.3 Analyze investor activity across different income brackets (buyer affordability proxy).
-- ----------------------------------------------------------

SELECT
Income_Bracket,
COUNT(*) AS Total_Records,
ROUND(AVG(Avg_Home_Price),2) AS Average_Home_Price,
ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity
FROM Market_Trends
WHERE
Income_Bracket IS NOT NULL
AND Investor_Activity_Score IS NOT NULL
GROUP BY
Income_Bracket
ORDER BY
Average_Investor_Activity DESC;

-- ----------------------------------------------------------
-- Q1.4 Identify years where investor activity significantly exceeded the overall average.
-- ----------------------------------------------------------

WITH Investor_Trend AS
(SELECT
Year,
AVG(Investor_Activity_Score) AS Avg_Investor_Activity
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY Year)
SELECT
Year,
ROUND(Avg_Investor_Activity,2) AS Average_Investor_Activity,
ROUND(AVG(Avg_Investor_Activity) OVER(),2) AS Overall_Average,
CASE
WHEN Avg_Investor_Activity >
AVG(Avg_Investor_Activity) OVER() * 1.15
THEN 'Investor Surge'
ELSE 'Normal Activity'
END AS Activity_Status
FROM Investor_Trend
ORDER BY Year;

-- ==========================================================
-- Q2: Which income brackets experience the most significant affordability challenges over time?
-- ==========================================================
-- ----------------------------------------------------------
-- Q2.1 Compute Price-to-Income Ratio for each Income Bracket using a Common Table Expression (CTE).
-- ----------------------------------------------------------

WITH Affordability AS
(SELECT
Income_Bracket,Year,
Affordability_Avg_Home_Price,
Affordability_Median_Household_Income,
ROUND(Affordability_Avg_Home_Price /
NULLIF(Affordability_Median_Household_Income,0),2) AS Computed_Price_to_Income_Ratio,
Affordability_Price_to_Income_Ratio AS Reported_Price_to_Income_Ratio
FROM Market_Trends
WHERE
Income_Bracket IS NOT NULL
AND Affordability_Avg_Home_Price IS NOT NULL
AND Affordability_Median_Household_Income IS NOT NULL)
SELECT *
FROM Affordability
ORDER BY
Income_Bracket,Year;

-- ----------------------------------------------------------
-- Q2.2 Compare average Price-to-Income Ratio across Income Brackets.
-- ----------------------------------------------------------

WITH Affordability AS
(
SELECT
Income_Bracket,
Affordability_Price_to_Income_Ratio
FROM Market_Trends
WHERE
Income_Bracket IS NOT NULL
AND Affordability_Price_to_Income_Ratio IS NOT NULL)
SELECT
Income_Bracket,
ROUND(AVG(Affordability_Price_to_Income_Ratio),2) AS Average_Price_to_Income_Ratio
FROM Affordability
GROUP BY
Income_Bracket
ORDER BY
Average_Price_to_Income_Ratio DESC;

-- ----------------------------------------------------------
-- Q2.3 Rank Income Brackets based on Affordability Stress using CASE.
-- ----------------------------------------------------------

WITH Bracket_Average AS
(SELECT
Income_Bracket,ROUND(AVG(Affordability_Price_to_Income_Ratio),2) AS Average_Ratio
FROM Market_Trends
WHERE
Income_Bracket IS NOT NULL
AND Affordability_Price_to_Income_Ratio IS NOT NULL
GROUP BY Income_Bracket)
SELECT
Income_Bracket,Average_Ratio,
CASE WHEN Average_Ratio <= 3 THEN 'Affordable'
WHEN Average_Ratio BETWEEN 3.01 AND 5 THEN 'Moderately Unaffordable'
WHEN Average_Ratio BETWEEN 5.01 AND 8 THEN 'Seriously Unaffordable'
ELSE 'Severely Unaffordable'
END AS Affordability_Stress,
RANK() OVER(ORDER BY Average_Ratio DESC) AS Stress_Rank
FROM Bracket_Average
ORDER BY
Stress_Rank;

-- ----------------------------------------------------------
-- Q2.4 Analyze affordability trend over time for
-- each Income Bracket.
-- ----------------------------------------------------------

SELECT
Income_Bracket,
Year,Affordability_Price_to_Income_Ratio,
Affordability_Change_YoY,
CASE WHEN Affordability_Change_YoY > 0
THEN 'Affordability Worsening'
WHEN Affordability_Change_YoY < 0
THEN 'Affordability Improving'
ELSE 'No Change'
END AS Trend_Direction
FROM Market_Trends
WHERE
Income_Bracket IS NOT NULL
AND Affordability_Change_YoY IS NOT NULL
ORDER BY
Income_Bracket,Year;

-- ----------------------------------------------------------
-- Q2.5 Identify which Income Bracket experienced
-- the greatest affordability deterioration.
-- ----------------------------------------------------------

WITH Bracket_Years AS
(
SELECT
Income_Bracket,
MIN(Year) AS Start_Year,
MAX(Year) AS End_Year
FROM Market_Trends
WHERE
Income_Bracket IS NOT NULL
AND Affordability_Price_to_Income_Ratio IS NOT NULL
GROUP BY
Income_Bracket),
Start_End AS
(
SELECT
b.Income_Bracket,
s.Affordability_Price_to_Income_Ratio AS Start_Ratio,
e.Affordability_Price_to_Income_Ratio AS End_Ratio
FROM Bracket_Years b
JOIN Market_Trends s
ON b.Income_Bracket = s.Income_Bracket
AND b.Start_Year = s.Year
JOIN Market_Trends e
ON b.Income_Bracket = e.Income_Bracket
AND b.End_Year = e.Year)
SELECT
Income_Bracket,Start_Ratio,End_Ratio,
ROUND(End_Ratio - Start_Ratio,2) AS Ratio_Increase,
ROUND((End_Ratio - Start_Ratio) /NULLIF(Start_Ratio,0) * 100,2) AS Percentage_Increase
FROM Start_End
ORDER BY
Ratio_Increase DESC;

-- ==========================================================
-- Q3: Which cities have seen the most volatility in investor activity over time?
-- ==========================================================
-- ----------------------------------------------------------
-- Q3.1 Calculate the average investor activity score for each city.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City
ORDER BY Average_Investor_Activity DESC;

-- ----------------------------------------------------------
-- Q3.2 Rank cities based on overall investor activity.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity,
RANK() OVER(ORDER BY AVG(Investor_Activity_Score) DESC) AS Investor_Hotspot_Rank
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City
ORDER BY Investor_Hotspot_Rank;


-- ----------------------------------------------------------
-- Q3.3 Measure investor activity volatility using Standard Deviation.
-- ----------------------------------------------------------
SELECT
City,
ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity,
ROUND(STDDEV(Investor_Activity_Score),2) AS Investor_Activity_Volatility,
RANK() OVER(ORDER BY STDDEV(Investor_Activity_Score) DESC) AS Volatility_Rank
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City
HAVING COUNT(*) > 2
ORDER BY Volatility_Rank;

-- ----------------------------------------------------------
-- Q3.4 Calculate the Coefficient of Variation (CV) to compare relative investor activity volatility.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity,
ROUND(STDDEV(Investor_Activity_Score),2) AS Investor_Activity_Volatility,
ROUND(STDDEV(Investor_Activity_Score)/NULLIF(AVG(Investor_Activity_Score),0),4) AS Coefficient_Of_Variation
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City
HAVING COUNT(*) > 2
ORDER BY Coefficient_Of_Variation DESC;


-- ----------------------------------------------------------
-- Q3.5 Classify cities based on investor activity and volatility.
-- ----------------------------------------------------------

SELECT
City,
ROUND(AVG(Investor_Activity_Score),2) AS Average_Investor_Activity,
ROUND(STDDEV(Investor_Activity_Score),2) AS Investor_Activity_Volatility,
RANK() OVER(ORDER BY AVG(Investor_Activity_Score) DESC) AS Activity_Rank,
RANK() OVER(ORDER BY STDDEV(Investor_Activity_Score) DESC) AS Volatility_Rank,
CASE
WHEN AVG(Investor_Activity_Score) >= (SELECT AVG(Investor_Activity_Score) FROM Market_Trends)
AND STDDEV(Investor_Activity_Score) >= (SELECT STDDEV(Investor_Activity_Score) FROM Market_Trends)
THEN 'High Activity, High Volatility'
WHEN AVG(Investor_Activity_Score) >= (SELECT AVG(Investor_Activity_Score) FROM Market_Trends)
AND STDDEV(Investor_Activity_Score) < (SELECT STDDEV(Investor_Activity_Score) FROM Market_Trends)
THEN 'High Activity, Stable'
WHEN AVG(Investor_Activity_Score) < (SELECT AVG(Investor_Activity_Score) FROM Market_Trends)
AND STDDEV(Investor_Activity_Score) >= (SELECT STDDEV(Investor_Activity_Score) FROM Market_Trends)
THEN 'Low Activity, High Volatility'
ELSE 'Low Activity, Stable'
END AS Investor_Risk_Profile
FROM Market_Trends
WHERE Investor_Activity_Score IS NOT NULL
GROUP BY City
HAVING COUNT(*) > 2
ORDER BY Activity_Rank;


-- ==========================================================
-- END OF PROJECT
-- ==========================================================









