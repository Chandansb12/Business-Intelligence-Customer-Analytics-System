-- PROJECT 1: BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS SYSTEM
-- SQL BUSINESS ANALYSIS QUERIES
-- STEPS 1 TO 38

USE Project1_BusinessAnalytics;


-- STEP 1: OVERALL BUSINESS KPI
-- Purpose: Get total transactions, revenue, cost, profit, AOV and margin

SELECT
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Net_Revenue), 2) AS Average_Order_Value,
    ROUND((SUM(Profit) / SUM(Net_Revenue)) * 100, 2) AS Overall_Profit_Margin
FROM fact_transaction;


-- STEP 2: MONTHLY BUSINESS PERFORMANCE
-- Purpose: Analyze revenue, cost and profit month by month

SELECT
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM fact_transaction
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
ORDER BY Month;


-- STEP 3: REGION PERFORMANCE
-- Purpose: Compare business performance across regions

SELECT
    g.Region,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_geography g
    ON f.Geography_ID = g.Geography_ID
GROUP BY g.Region
ORDER BY Total_Revenue DESC;


-- STEP 4: CATEGORY PERFORMANCE
-- Purpose: Compare revenue, cost and profit by product category

SELECT
    p.Category,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_product p
    ON f.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Total_Revenue DESC;


-- STEP 5: CUSTOMER KPI
-- Purpose: Analyze total customers and average revenue per customer

SELECT
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Net_Revenue) / COUNT(DISTINCT Customer_ID), 2) AS Revenue_Per_Customer
FROM fact_transaction;


-- STEP 6: NEW VS EXISTING CUSTOMERS
-- Purpose: Compare new and existing customer performance

SELECT
    c.Customer_Type,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Type;


-- STEP 7: TOP 10 CUSTOMERS BY REVENUE
-- Purpose: Find customers generating the highest revenue

SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Revenue DESC
LIMIT 10;


-- STEP 8: TOP 10 CUSTOMERS BY TRANSACTIONS
-- Purpose: Find customers with the highest purchase frequency

SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(*) AS Total_Transactions
FROM fact_transaction f
JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Transactions DESC
LIMIT 10;


-- STEP 9: TOP 10 PRODUCTS BY REVENUE
-- Purpose: Find products generating the highest revenue

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,
    COUNT(*) AS Total_Transactions,
    SUM(f.Quantity) AS Total_Quantity,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_product p
    ON f.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
ORDER BY Total_Revenue DESC
LIMIT 10;


-- STEP 10: TOP 10 PRODUCTS BY PROFIT
-- Purpose: Find the most profitable products

SELECT
    p.Product_ID,
    p.Product_Name,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit,
    ROUND((SUM(f.Profit) / SUM(f.Net_Revenue)) * 100, 2) AS Profit_Margin
FROM fact_transaction f
JOIN dim_product p
    ON f.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;


-- STEP 11: SALES CHANNEL PERFORMANCE
-- Purpose: Compare performance by sales channel

SELECT
    Sales_Channel,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Net_Revenue)) * 100, 2) AS Profit_Margin
FROM fact_transaction
GROUP BY Sales_Channel
ORDER BY Total_Revenue DESC;


-- STEP 12: PAYMENT METHOD PERFORMANCE
-- Purpose: Compare transactions and revenue by payment method

SELECT
    Payment_Method,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Net_Revenue)) * 100, 2) AS Profit_Margin
FROM fact_transaction
GROUP BY Payment_Method
ORDER BY Total_Revenue DESC;


-- STEP 13: TRANSACTION STATUS
-- Purpose: Analyze completed, returned and cancelled transactions

SELECT
    Transaction_Status,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM fact_transaction
GROUP BY Transaction_Status
ORDER BY Total_Transactions DESC;


-- STEP 13B: RETURN AND CANCELLATION RATE
-- Purpose: Calculate return and cancellation percentages

SELECT
    COUNT(*) AS Total_Transactions,
    SUM(Transaction_Status = 'Completed') AS Completed_Transactions,
    SUM(Transaction_Status = 'Returned') AS Returned_Transactions,
    SUM(Transaction_Status = 'Cancelled') AS Cancelled_Transactions,
    ROUND(SUM(Transaction_Status = 'Returned') / COUNT(*) * 100, 2) AS Return_Rate,
    ROUND(SUM(Transaction_Status = 'Cancelled') / COUNT(*) * 100, 2) AS Cancellation_Rate
FROM fact_transaction;


-- STEP 14: TOP 10 STATES BY REVENUE
-- Purpose: Find states generating the highest revenue

SELECT
    g.State,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_geography g
    ON f.Geography_ID = g.Geography_ID
GROUP BY g.State
ORDER BY Total_Revenue DESC
LIMIT 10;


-- STEP 15: TOP 10 CITIES BY REVENUE
-- Purpose: Find cities generating the highest revenue

SELECT
    g.City,
    g.State,
    g.Region,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_geography g
    ON f.Geography_ID = g.Geography_ID
GROUP BY g.City, g.State, g.Region
ORDER BY Total_Revenue DESC
LIMIT 10;


-- STEP 16: MONTHLY REVENUE AND PROFIT
-- Purpose: Analyze monthly revenue and profit trend

SELECT
    YEAR(Transaction_Date) AS Year,
    MONTH(Transaction_Date) AS Month_Number,
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Year_Month,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM fact_transaction
GROUP BY
    YEAR(Transaction_Date),
    MONTH(Transaction_Date),
    DATE_FORMAT(Transaction_Date, '%Y-%m')
ORDER BY Year, Month_Number;


-- STEP 17: MONTH-OVER-MONTH GROWTH
-- Purpose: Calculate monthly revenue growth compared with previous month

WITH Monthly_Sales AS (
    SELECT
        DATE_FORMAT(Transaction_Date, '%Y-%m') AS Month,
        SUM(Net_Revenue) AS Revenue
    FROM fact_transaction
    GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
)
SELECT
    Month,
    ROUND(Revenue, 2) AS Revenue,
    ROUND(
        (Revenue - LAG(Revenue) OVER (ORDER BY Month))
        / LAG(Revenue) OVER (ORDER BY Month) * 100,
        2
    ) AS MoM_Growth_Percent
FROM Monthly_Sales
ORDER BY Month;


-- STEP 18: YEAR-OVER-YEAR GROWTH
-- Purpose: Compare monthly revenue with the same month of previous year

WITH Monthly_Sales AS (
    SELECT
        YEAR(Transaction_Date) AS Year,
        MONTH(Transaction_Date) AS Month_Number,
        SUM(Net_Revenue) AS Revenue
    FROM fact_transaction
    GROUP BY YEAR(Transaction_Date), MONTH(Transaction_Date)
)
SELECT
    Year,
    Month_Number,
    ROUND(Revenue, 2) AS Revenue,
    ROUND(
        (
            Revenue -
            LAG(Revenue, 12) OVER (
                ORDER BY Year, Month_Number
            )
        )
        /
        LAG(Revenue, 12) OVER (
            ORDER BY Year, Month_Number
        ) * 100,
        2
    ) AS YoY_Growth_Percent
FROM Monthly_Sales
ORDER BY Year, Month_Number;


-- STEP 19: CUSTOMER PURCHASE FREQUENCY
-- Purpose: Group customers based on number of transactions

WITH Customer_Frequency AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Total_Transactions
    FROM fact_transaction
    GROUP BY Customer_ID
)
SELECT
    CASE
        WHEN Total_Transactions BETWEEN 2 AND 5 THEN '2-5 Transactions'
        WHEN Total_Transactions BETWEEN 6 AND 10 THEN '6-10 Transactions'
        WHEN Total_Transactions BETWEEN 11 AND 20 THEN '11-20 Transactions'
        ELSE '20+ Transactions'
    END AS Frequency_Group,
    COUNT(*) AS Total_Customers
FROM Customer_Frequency
GROUP BY Frequency_Group
ORDER BY Total_Customers DESC;


-- STEP 20: CUSTOMER REVENUE SEGMENTS
-- Purpose: Group customers based on total revenue generated

WITH Customer_Revenue AS (
    SELECT
        Customer_ID,
        SUM(Net_Revenue) AS Total_Revenue
    FROM fact_transaction
    GROUP BY Customer_ID
)
SELECT
    CASE
        WHEN Total_Revenue < 25000 THEN 'Below 25K'
        WHEN Total_Revenue < 50000 THEN '25K-50K'
        WHEN Total_Revenue < 100000 THEN '50K-100K'
        WHEN Total_Revenue < 150000 THEN '100K-150K'
        ELSE 'Above 150K'
    END AS Revenue_Segment,
    COUNT(*) AS Total_Customers,
    ROUND(SUM(Total_Revenue), 2) AS Segment_Revenue
FROM Customer_Revenue
GROUP BY Revenue_Segment
ORDER BY Segment_Revenue DESC;


-- STEP 21: CUSTOMER RECENCY
-- Purpose: Find each customer's most recent purchase date

SELECT
    Customer_ID,
    MAX(Transaction_Date) AS Last_Purchase_Date
FROM fact_transaction
GROUP BY Customer_ID;


-- STEP 22: CUSTOMER FREQUENCY
-- Purpose: Count transactions for each customer

SELECT
    Customer_ID,
    COUNT(*) AS Total_Transactions
FROM fact_transaction
GROUP BY Customer_ID;


-- STEP 23: CUSTOMER MONETARY VALUE
-- Purpose: Calculate total revenue generated by each customer

SELECT
    Customer_ID,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue
FROM fact_transaction
GROUP BY Customer_ID;


-- STEP 24: CUSTOMER RFM RAW DATA
-- Purpose: Combine Recency, Frequency and Monetary values

SELECT
    Customer_ID,
    MAX(Transaction_Date) AS Last_Purchase_Date,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue
FROM fact_transaction
GROUP BY Customer_ID;


-- STEP 25: RFM SCORING
-- Purpose: Give customers Recency, Frequency and Monetary scores

WITH Customer_RFM AS (
    SELECT
        Customer_ID,
        MAX(Transaction_Date) AS Last_Purchase_Date,
        COUNT(*) AS Total_Transactions,
        SUM(Net_Revenue) AS Total_Revenue
    FROM fact_transaction
    GROUP BY Customer_ID
)
SELECT
    Customer_ID,
    Last_Purchase_Date,
    Total_Transactions,
    ROUND(Total_Revenue, 2) AS Total_Revenue,
    6-NTILE(5) OVER (ORDER BY Last_Purchase_Date) AS Recency_Score,
    NTILE(5) OVER (ORDER BY Total_Transactions) AS Frequency_Score,
    NTILE(5) OVER (ORDER BY Total_Revenue) AS Monetary_Score
FROM Customer_RFM;


-- STEP 26: COMBINED RFM SCORE
-- Purpose: Combine three RFM scores into one score

WITH Customer_RFM AS (
    SELECT
        Customer_ID,
        MAX(Transaction_Date) AS Last_Purchase_Date,
        COUNT(*) AS Total_Transactions,
        SUM(Net_Revenue) AS Total_Revenue
    FROM fact_transaction
    GROUP BY Customer_ID
),
RFM_Scored AS (
    SELECT
        Customer_ID,
        Last_Purchase_Date,
        Total_Transactions,
        Total_Revenue,
        6-NTILE(5) OVER (ORDER BY Last_Purchase_Date) AS Recency_Score,
        NTILE(5) OVER (ORDER BY Total_Transactions) AS Frequency_Score,
        NTILE(5) OVER (ORDER BY Total_Revenue) AS Monetary_Score
    FROM Customer_RFM
)
SELECT
    Customer_ID,
    Last_Purchase_Date,
    Total_Transactions,
    ROUND(Total_Revenue, 2) AS Total_Revenue,
    Recency_Score,
    Frequency_Score,
    Monetary_Score,
    CONCAT(Recency_Score, Frequency_Score, Monetary_Score) AS RFM_Score
FROM RFM_Scored;


-- STEP 27: CUSTOMER RFM SEGMENTATION
-- Purpose: Assign customers to business segments using RFM scores

WITH Customer_RFM AS (
    SELECT
        Customer_ID,
        MAX(Transaction_Date) AS Last_Purchase_Date,
        COUNT(*) AS Total_Transactions,
        SUM(Net_Revenue) AS Total_Revenue
    FROM fact_transaction
    GROUP BY Customer_ID
),
RFM_Scored AS (
    SELECT
        Customer_ID,
        Last_Purchase_Date,
        Total_Transactions,
        Total_Revenue,
        6-NTILE(5) OVER (ORDER BY Last_Purchase_Date) AS Recency_Score,
        NTILE(5) OVER (ORDER BY Total_Transactions) AS Frequency_Score,
        NTILE(5) OVER (ORDER BY Total_Revenue) AS Monetary_Score
    FROM Customer_RFM
)
SELECT
    Customer_ID,
    CONCAT(Recency_Score, Frequency_Score, Monetary_Score) AS RFM_Score,
    CASE
        WHEN Recency_Score = 5
         AND Frequency_Score = 5
         AND Monetary_Score = 5
            THEN 'Champions'
        WHEN Recency_Score = 5
          OR Frequency_Score = 5
          OR Monetary_Score = 5
            THEN 'Loyal Customers'
        WHEN Recency_Score = 3
          OR Frequency_Score = 3
          OR Monetary_Score = 3
            THEN 'Potential Customers'
        WHEN Recency_Score = 2
          OR Frequency_Score = 2
          OR Monetary_Score = 2
            THEN 'At Risk'
        ELSE 'Low Engagement'
    END AS Customer_Segment
FROM RFM_Scored;


-- STEP 28: CUSTOMER SEGMENT SUMMARY
-- Purpose: Count customers in each RFM segment

WITH Customer_RFM AS (
    SELECT
        Customer_ID,
        MAX(Transaction_Date) AS Last_Purchase_Date,
        COUNT(*) AS Total_Transactions,
        SUM(Net_Revenue) AS Total_Revenue
    FROM fact_transaction
    GROUP BY Customer_ID
),
RFM_Scored AS (
    SELECT
        Customer_ID,
        6-NTILE(5) OVER (ORDER BY Last_Purchase_Date) AS Recency_Score,
        NTILE(5) OVER (ORDER BY Total_Transactions) AS Frequency_Score,
        NTILE(5) OVER (ORDER BY Total_Revenue) AS Monetary_Score
    FROM Customer_RFM
),
Segments AS (
    SELECT
        CASE
            WHEN Recency_Score = 5
             AND Frequency_Score = 5
             AND Monetary_Score = 5
                THEN 'Champions'
            WHEN Recency_Score = 5
              OR Frequency_Score = 5
              OR Monetary_Score = 5
                THEN 'Loyal Customers'
            WHEN Recency_Score = 3
              OR Frequency_Score = 3
              OR Monetary_Score = 3
                THEN 'Potential Customers'
            WHEN Recency_Score = 2
              OR Frequency_Score = 2
              OR Monetary_Score = 2
                THEN 'At Risk'
            ELSE 'Low Engagement'
        END AS Customer_Segment
    FROM RFM_Scored
)
SELECT
    Customer_Segment,
    COUNT(*) AS Total_Customers
FROM Segments
GROUP BY Customer_Segment
ORDER BY Total_Customers DESC;


-- STEP 29: REVENUE AND PROFIT BY CUSTOMER SEGMENT
-- Purpose: Measure business value of each customer segment

WITH Customer_RFM AS (
    SELECT
        Customer_ID,
        MAX(Transaction_Date) AS Last_Purchase_Date,
        COUNT(*) AS Total_Transactions,
        SUM(Net_Revenue) AS Total_Revenue
    FROM fact_transaction
    GROUP BY Customer_ID
),
RFM_Scored AS (
    SELECT
        Customer_ID,
        6-NTILE(5) OVER (ORDER BY Last_Purchase_Date) AS Recency_Score,
        NTILE(5) OVER (ORDER BY Total_Transactions) AS Frequency_Score,
        NTILE(5) OVER (ORDER BY Total_Revenue) AS Monetary_Score
    FROM Customer_RFM
),
Segments AS (
    SELECT
        Customer_ID,
        CASE
            WHEN Recency_Score = 5
             AND Frequency_Score = 5
             AND Monetary_Score = 5
                THEN 'Champions'
            WHEN Recency_Score = 5
              OR Frequency_Score = 5
              OR Monetary_Score = 5
                THEN 'Loyal Customers'
            WHEN Recency_Score = 3
              OR Frequency_Score = 3
              OR Monetary_Score = 3
                THEN 'Potential Customers'
            WHEN Recency_Score = 2
              OR Frequency_Score = 2
              OR Monetary_Score = 2
                THEN 'At Risk'
            ELSE 'Low Engagement'
        END AS Customer_Segment
    FROM RFM_Scored
)
SELECT
    s.Customer_Segment,
    COUNT(DISTINCT s.Customer_ID) AS Total_Customers,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM Segments s
JOIN fact_transaction f
    ON s.Customer_ID = f.Customer_ID
GROUP BY s.Customer_Segment
ORDER BY Total_Revenue DESC;


-- STEP 30: REPEAT VS ONE-TIME CUSTOMERS
-- Purpose: Identify customers who purchased more than once

WITH Customer_Frequency AS (
    SELECT
        Customer_ID,
        COUNT(*) AS Total_Transactions
    FROM fact_transaction
    GROUP BY Customer_ID
)
SELECT
    CASE
        WHEN Total_Transactions > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS Customer_Type,
    COUNT(*) AS Total_Customers
FROM Customer_Frequency
GROUP BY Customer_Type;


-- STEP 31: AVERAGE TRANSACTIONS PER CUSTOMER
-- Purpose: Calculate average purchase frequency

SELECT
    ROUND(
        COUNT(*) / COUNT(DISTINCT Customer_ID),
        2
    ) AS Average_Transactions_Per_Customer
FROM fact_transaction;


-- STEP 32: TOP CUSTOMERS WITH TRANSACTION COUNT
-- Purpose: Show top revenue customers with their transaction frequency

SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue
FROM fact_transaction f
JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Revenue DESC
LIMIT 10;


-- STEP 33: TOP CUSTOMERS BY AVERAGE REVENUE PER TRANSACTION
-- Purpose: Find customers with high average transaction value

SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(AVG(f.Net_Revenue), 2) AS Average_Revenue_Per_Transaction
FROM fact_transaction f
JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Average_Revenue_Per_Transaction DESC
LIMIT 10;


-- STEP 34: TOP CUSTOMERS BY PROFITABILITY
-- Purpose: Find customers generating the highest profit

SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit,
    ROUND(
        SUM(f.Profit) / SUM(f.Net_Revenue) * 100,
        2
    ) AS Profit_Margin
FROM fact_transaction f
JOIN dim_customer c
    ON f.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
ORDER BY Total_Profit DESC
LIMIT 10;


-- STEP 35: YEARLY BUSINESS PERFORMANCE
-- Purpose: Compare business performance across years

SELECT
    YEAR(Transaction_Date) AS Year,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(Net_Revenue) * 100,
        2
    ) AS Profit_Margin
FROM fact_transaction
GROUP BY YEAR(Transaction_Date)
ORDER BY Year;


-- STEP 36: CUSTOMER PERFORMANCE BY REGION
-- Purpose: Analyze customers, transactions and revenue by region

SELECT
    g.Region,
    COUNT(DISTINCT f.Customer_ID) AS Total_Customers,
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(f.Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(f.Profit), 2) AS Total_Profit
FROM fact_transaction f
JOIN dim_geography g
    ON f.Geography_ID = g.Geography_ID
GROUP BY g.Region
ORDER BY Total_Revenue DESC;


-- STEP 37: KPI RECONCILIATION
-- Purpose: Recheck major business KPIs before final reporting

SELECT
    COUNT(*) AS Total_Transactions,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Net_Revenue), 2) AS Average_Order_Value,
    ROUND(
        SUM(Profit) / SUM(Net_Revenue) * 100,
        2
    ) AS Overall_Profit_Margin
FROM fact_transaction;


-- STEP 38: FINAL MANAGEMENT SUMMARY
-- Purpose: Get the main business KPIs for management reporting

SELECT
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT Customer_ID) AS Unique_Customers,
    ROUND(SUM(Net_Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Total_Cost), 2) AS Total_Cost,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Net_Revenue), 2) AS Average_Order_Value,
    ROUND(
        (SUM(Profit) / SUM(Net_Revenue)) * 100,
        2
    ) AS Overall_Profit_Margin,
    SUM(
        CASE
            WHEN Transaction_Status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS Returned_Transactions,
    SUM(
        CASE
            WHEN Transaction_Status = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS Cancelled_Transactions
FROM fact_transaction;
