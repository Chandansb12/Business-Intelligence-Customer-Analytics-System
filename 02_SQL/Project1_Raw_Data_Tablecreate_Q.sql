-- =========================================
-- PROJECT 1
-- BUSINESS INTELLIGENCE & CUSTOMER ANALYTICS
-- SQL TABLE CREATION
-- =========================================

-- Create Schema
CREATE SCHEMA Project1_BusinessAnalytics;

-- =========================================
-- 1. CUSTOMER TABLE
-- =========================================
CREATE TABLE dim_customer (
    Customer_ID VARCHAR(20) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Gender VARCHAR(20),
    Age INT,
    Age_Group VARCHAR(20),
    Join_Date DATE,
    Customer_Type VARCHAR(20),
    Geography_ID VARCHAR(20),
    Customer_Status VARCHAR(20)
);
describe dim_customer;

-- =========================================
-- 2. PRODUCT TABLE
-- =========================================
CREATE TABLE dim_product (
    Product_ID VARCHAR(20) PRIMARY KEY,
    Product_Name VARCHAR(150),
    Category VARCHAR(50),
    Subcategory VARCHAR(50),
    Brand VARCHAR(50),
    Cost_Price DECIMAL(12,2),
    Selling_Price DECIMAL(12,2),
    Product_Status VARCHAR(20)
);
describe dim_product;

-- =========================================
-- 3. GEOGRAPHY TABLE
-- =========================================
CREATE TABLE dim_geography (
    Geography_ID VARCHAR(20) PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    Region VARCHAR(50)
);
describe dim_geography;

-- =========================================
-- 4. DATE TABLE
-- =========================================
-- Good habit:
-- Use backticks around column names such as Date, Day, Month, and Year.
-- Backticks tell MySQL to treat them explicitly as column names.
-- Example: `Date`, `Day`, `Month`, `Year`

CREATE TABLE dim_date (
    `Date` DATE PRIMARY KEY,
    `Day` INT,
    `Day_Name` VARCHAR(20),
    `Week_Number` INT,
    `Month` VARCHAR(20),
    `Month_Number` INT,
    `Quarter` VARCHAR(10),
    `Year` INT,
    `Year_Month` VARCHAR(10),
    `Financial_Year` VARCHAR(10)
);
describe dim_date;

-- =========================================
-- 5. TRANSACTION TABLE
-- =========================================
CREATE TABLE fact_transaction (
    Transaction_ID VARCHAR(20) PRIMARY KEY,
    Transaction_Date DATE,
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(20),
    Geography_ID VARCHAR(20),
    Quantity INT,
    Unit_Price DECIMAL(12,2),
    Discount_Percent DECIMAL(5,4),
    Discount_Amount DECIMAL(12,2),
    Gross_Amount DECIMAL(14,2),
    Net_Revenue DECIMAL(14,2),
    Unit_Cost DECIMAL(12,2),
    Total_Cost DECIMAL(14,2),
    Profit DECIMAL(14,2),
    Profit_Margin DECIMAL(7,4),
    Payment_Method VARCHAR(30),
    Sales_Channel VARCHAR(30),
    Transaction_Status VARCHAR(20)
);
describe fact_transaction;

-- DECIMAL is used for money and percentage values
-- because it stores exact decimal values.
-- Example:
-- DECIMAL(12,2) → 3057.71
-- DECIMAL(5,4)  → 0.1500 = 15%