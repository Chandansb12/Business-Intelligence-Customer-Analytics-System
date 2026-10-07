select * from fact_transaction;
SELECT COUNT(*) AS Total_Transactions
FROM fact_transaction;
SELECT COUNT(*) AS Total_Customers
FROM fact_transaction;

-- checks duplicate values
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

-- check Missing/Null values
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Transaction_ID) AS Transaction_ID_Count,
    COUNT(Transaction_Date) AS Transaction_Date_Count,
    COUNT(Customer_ID) AS Customer_ID_Count,
    COUNT(Product_ID) AS Product_ID_Count,
    COUNT(Geography_ID) AS Geography_ID_Count
FROM fact_transaction;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Customer_ID) AS Customer_ID_Count,
    COUNT(Customer_Name) AS Customer_Name_Count,
    COUNT(Join_Date) AS Join_Date_Count,
    COUNT(Geography_ID) AS Geography_ID_Count
FROM dim_customer;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Product_ID) AS Product_ID_Count,
    COUNT(Product_Name) AS Product_Name_Count,
    COUNT(Cost_Price) AS Cost_Price_Count,
    COUNT(Selling_Price) AS Selling_Price_Count
FROM dim_product;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Geography_ID) AS Geography_ID_Count,
    COUNT(City) AS City_Count,
    COUNT(State) AS State_Count,
    COUNT(Region) AS Region_Count
FROM dim_geography;

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

-- relationship/reference validation
SELECT
    COUNT(*) AS Invalid_Customer_References
FROM fact_transaction f
LEFT JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

SELECT
    COUNT(*) AS Invalid_Product_References
FROM fact_transaction f
LEFT JOIN dim_product p
    ON f.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

SELECT
    COUNT(*) AS Invalid_Geography_References
FROM fact_transaction f
LEFT JOIN dim_geography g
    ON f.Geography_ID = g.Geography_ID
WHERE g.Geography_ID IS NULL;

SELECT
    COUNT(*) AS Invalid_Date_References
FROM fact_transaction f
LEFT JOIN dim_date d
    ON f.Transaction_Date = d.`Date`
WHERE d.`Date` IS NULL;

-- calculation validation
SELECT COUNT(*) AS Gross_Amount_Mismatches
FROM fact_transaction
WHERE ABS(Gross_Amount - (Quantity * Unit_Price)) > 0.01;

SELECT COUNT(*) AS Discount_Amount_Mismatches
FROM fact_transaction
WHERE ABS(Discount_Amount - (Gross_Amount * Discount_Percent)) > 0.01;

SELECT COUNT(*) AS Net_Revenue_Mismatches
FROM fact_transaction
WHERE ABS(Net_Revenue - (Gross_Amount - Discount_Amount)) > 0.01;

SELECT COUNT(*) AS Total_Cost_Mismatches
FROM fact_transaction
WHERE ABS(Total_Cost - (Quantity * Unit_Cost)) > 0.01;

SELECT COUNT(*) AS Profit_Mismatches
FROM fact_transaction
WHERE ABS(Profit - (Net_Revenue - Total_Cost)) > 0.01;

SELECT COUNT(*) AS Profit_Margin_Mismatches
FROM fact_transaction
WHERE ABS(
    Profit_Margin - ((Profit / NULLIF(Net_Revenue, 0)) * 100)
) > 0.01;

SELECT COUNT(*) AS Invalid_Quantity
FROM fact_transaction
WHERE Quantity <= 0;

SELECT COUNT(*) AS Invalid_Unit_Price
FROM fact_transaction
WHERE Unit_Price <= 0;

SELECT COUNT(*) AS Invalid_Unit_Cost
FROM fact_transaction
WHERE Unit_Cost <= 0;

SELECT COUNT(*) AS Invalid_Discount_Percent
FROM fact_transaction
WHERE Discount_Percent < 0
   OR Discount_Percent > 1;
   
SELECT COUNT(*) AS Invalid_Profit_Margin
FROM fact_transaction
WHERE Profit_Margin < 0
   OR Profit_Margin > 100;
   
SELECT
    MIN(Transaction_Date) AS First_Transaction_Date,
    MAX(Transaction_Date) AS Last_Transaction_Date
FROM fact_transaction;

SELECT
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM fact_transaction;