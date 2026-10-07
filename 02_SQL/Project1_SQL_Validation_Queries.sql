-- ============================================================
-- PROJECT 1: BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS SYSTEM
-- SQL DATA VALIDATION QUERIES
-- Database: MySQL / MySQL Workbench
-- ============================================================
--
-- PURPOSE:
-- Validate that the imported Project 1 data is complete,
-- consistent, correctly related, and mathematically correct.
--
-- Expected results are written below each query.
-- ============================================================

-- 1. ROW COUNT VALIDATION
-- Confirms that the expected number of rows were imported.

SELECT COUNT(*) AS Total_Customers FROM dim_customer;
-- Expected: 7500

SELECT COUNT(*) AS Total_Products FROM dim_product;
-- Expected: 150

SELECT COUNT(*) AS Total_Geographies FROM dim_geography;
-- Expected: 121

SELECT COUNT(*) AS Total_Dates FROM dim_date;
-- Expected: 1096

SELECT COUNT(*) AS Total_Transactions FROM fact_transaction;
-- Expected: 100000


-- 2. DUPLICATE PRIMARY KEY VALIDATION
-- GROUP BY finds repeated IDs.
-- HAVING COUNT(*) > 1 returns only duplicate IDs.
-- Expected: No rows.

SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM dim_customer
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT Product_ID, COUNT(*) AS Duplicate_Count
FROM dim_product
GROUP BY Product_ID
HAVING COUNT(*) > 1;

SELECT Geography_ID, COUNT(*) AS Duplicate_Count
FROM dim_geography
GROUP BY Geography_ID
HAVING COUNT(*) > 1;

SELECT `Date`, COUNT(*) AS Duplicate_Count
FROM dim_date
GROUP BY `Date`
HAVING COUNT(*) > 1;

SELECT Transaction_ID, COUNT(*) AS Duplicate_Count
FROM fact_transaction
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;


-- 3. NULL VALIDATION
-- COUNT(column) counts only NON-NULL values.
-- If COUNT(column) equals COUNT(*), there are no NULLs
-- in that column for the checked rows.

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Transaction_ID) AS Transaction_ID_Count,
    COUNT(Transaction_Date) AS Transaction_Date_Count,
    COUNT(Customer_ID) AS Customer_ID_Count,
    COUNT(Product_ID) AS Product_ID_Count,
    COUNT(Geography_ID) AS Geography_ID_Count
FROM fact_transaction;
-- Expected: 100000 for every count.

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Customer_ID) AS Customer_ID_Count,
    COUNT(Customer_Name) AS Customer_Name_Count,
    COUNT(Join_Date) AS Join_Date_Count,
    COUNT(Geography_ID) AS Geography_ID_Count
FROM dim_customer;
-- Expected: 7500 for every count.

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Product_ID) AS Product_ID_Count,
    COUNT(Product_Name) AS Product_Name_Count,
    COUNT(Cost_Price) AS Cost_Price_Count,
    COUNT(Selling_Price) AS Selling_Price_Count
FROM dim_product;
-- Expected: 150 for every count.

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Geography_ID) AS Geography_ID_Count,
    COUNT(City) AS City_Count,
    COUNT(State) AS State_Count,
    COUNT(Region) AS Region_Count
FROM dim_geography;
-- Expected: 121 for every count.

-- Good habit:
-- Use backticks around column names such as Date, Day, Month,
-- Quarter, Year, Year_Month, and Financial_Year.
-- Backticks explicitly tell MySQL to treat them as column names.

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(`Date`) AS Date_Count,
    COUNT(`Day`) AS Day_Count,
    COUNT(`Day_Name`) AS Day_Name_Count,
    COUNT(`Week_Number`) AS Week_Number_Count,
    COUNT(`Month`) AS Month_Count,
    COUNT(`Month_Number`) AS Month_Number_Count,
    COUNT(`Quarter`) AS Quarter_Count,
    COUNT(`Year`) AS Year_Count,
    COUNT(`Year_Month`) AS Year_Month_Count,
    COUNT(`Financial_Year`) AS Financial_Year_Count
FROM dim_date;
-- Expected: 1096 for every count.


-- 4. RELATIONSHIP / REFERENCE VALIDATION
-- LEFT JOIN keeps all fact rows.
-- If a matching dimension row does not exist, the dimension ID is NULL.
-- Expected invalid-reference count: 0.

SELECT COUNT(*) AS Invalid_Customer_References
FROM fact_transaction f
LEFT JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;
-- Expected: 0

SELECT COUNT(*) AS Invalid_Product_References
FROM fact_transaction f
LEFT JOIN dim_product p
    ON f.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;
-- Expected: 0

SELECT COUNT(*) AS Invalid_Geography_References
FROM fact_transaction f
LEFT JOIN dim_geography g
    ON f.Geography_ID = g.Geography_ID
WHERE g.Geography_ID IS NULL;
-- Expected: 0

SELECT COUNT(*) AS Invalid_Date_References
FROM fact_transaction f
LEFT JOIN dim_date d
    ON f.Transaction_Date = d.`Date`
WHERE d.`Date` IS NULL;
-- Expected: 0


-- 5. FINANCIAL CALCULATION VALIDATION
-- ABS() returns the absolute difference.
-- A tolerance of 0.01 allows small decimal/rounding differences.

-- Gross Amount = Quantity * Unit Price
SELECT COUNT(*) AS Gross_Amount_Mismatches
FROM fact_transaction
WHERE ABS(Gross_Amount - (Quantity * Unit_Price)) > 0.01;
-- Expected: 0

-- Discount Amount = Gross Amount * Discount Percent
SELECT COUNT(*) AS Discount_Amount_Mismatches
FROM fact_transaction
WHERE ABS(Discount_Amount - (Gross_Amount * Discount_Percent)) > 0.01;
-- Expected: 0

-- Net Revenue = Gross Amount - Discount Amount
SELECT COUNT(*) AS Net_Revenue_Mismatches
FROM fact_transaction
WHERE ABS(Net_Revenue - (Gross_Amount - Discount_Amount)) > 0.01;
-- Expected: 0

-- Total Cost = Quantity * Unit Cost
SELECT COUNT(*) AS Total_Cost_Mismatches
FROM fact_transaction
WHERE ABS(Total_Cost - (Quantity * Unit_Cost)) > 0.01;
-- Expected: 0

-- Profit = Net Revenue - Total Cost
SELECT COUNT(*) AS Profit_Mismatches
FROM fact_transaction
WHERE ABS(Profit - (Net_Revenue - Total_Cost)) > 0.01;
-- Expected: 0

-- Profit Margin = (Profit / Net Revenue) * 100
-- NULLIF(Net_Revenue, 0) prevents division-by-zero errors.
-- Example: 21.1700 means 21.17%.
SELECT COUNT(*) AS Profit_Margin_Mismatches
FROM fact_transaction
WHERE ABS(
    Profit_Margin - ((Profit / NULLIF(Net_Revenue, 0)) * 100)
) > 0.01;
-- Expected: 0


-- 6. BASIC NUMERIC / DATA VALIDITY

-- Quantity must be greater than 0.
SELECT COUNT(*) AS Invalid_Quantity
FROM fact_transaction
WHERE Quantity <= 0;
-- Expected: 0

-- Unit Price must be greater than 0.
SELECT COUNT(*) AS Invalid_Unit_Price
FROM fact_transaction
WHERE Unit_Price <= 0;
-- Expected: 0

-- Unit Cost must be greater than 0.
SELECT COUNT(*) AS Invalid_Unit_Cost
FROM fact_transaction
WHERE Unit_Cost <= 0;
-- Expected: 0

-- Discount Percent is stored as a decimal:
-- 0.15 = 15%, 0.05 = 5%, 0.00 = 0%.
SELECT COUNT(*) AS Invalid_Discount_Percent
FROM fact_transaction
WHERE Discount_Percent < 0
   OR Discount_Percent > 1;
-- Expected: 0

-- Profit Margin is stored as a percentage number:
-- 21.1700 = 21.17%.
SELECT COUNT(*) AS Invalid_Profit_Margin
FROM fact_transaction
WHERE Profit_Margin < 0
   OR Profit_Margin > 100;
-- Expected: 0


-- 7. TRANSACTION DATE RANGE VALIDATION
-- Confirms the earliest and latest transaction dates.

SELECT
    MIN(Transaction_Date) AS First_Transaction_Date,
    MAX(Transaction_Date) AS Last_Transaction_Date
FROM fact_transaction;
-- Validated result:
-- First date: 2024-01-01
-- Last date : 2026-12-31


-- 8. FINAL RECONCILIATION
-- Produces the main financial totals from the fact table.
-- These totals were reconciled against the original dataset.

SELECT
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM fact_transaction;
-- Validated result:
-- Total Transactions: 100000
-- Total Revenue:      412829960.96
-- Total Cost:         326765369.15
-- Total Profit:       86064591.81


-- ============================================================
-- FINAL RESULT
-- ============================================================
-- Row counts                    -> PASSED
-- Duplicate primary keys        -> PASSED
-- NULL checks                   -> PASSED
-- Customer references           -> PASSED
-- Product references            -> PASSED
-- Geography references          -> PASSED
-- Date references               -> PASSED
-- Gross Amount calculation      -> PASSED
-- Discount Amount calculation   -> PASSED
-- Net Revenue calculation       -> PASSED
-- Total Cost calculation        -> PASSED
-- Profit calculation            -> PASSED
-- Profit Margin calculation     -> PASSED
-- Quantity validity             -> PASSED
-- Unit Price validity           -> PASSED
-- Unit Cost validity            -> PASSED
-- Discount % validity           -> PASSED
-- Profit Margin validity        -> PASSED
-- Transaction date range        -> PASSED
-- Final reconciliation          -> PASSED
--
-- The Project 1 MySQL data passed the complete validation stage.
-- The database is ready for SQL Business Analysis.
-- ============================================================
