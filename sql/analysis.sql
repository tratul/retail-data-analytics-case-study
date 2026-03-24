-- =========================================
-- 📊 RETAIL DATA ANALYTICS CASE STUDY
-- Author: Mahmudul Hasan Bhuiyan
-- Description: Business-focused SQL analysis on retail transaction data
-- =========================================


-- =========================================
-- 1. DATA CLEANING & PREPARATION
-- =========================================

-- Remove rows with missing CustomerID
DELETE FROM retail
WHERE CustomerID IS NULL;

-- Remove negative or zero quantity (optional, depends on business case)
DELETE FROM retail
WHERE Quantity <= 0;

-- Remove negative price values
DELETE FROM retail
WHERE UnitPrice <= 0;


-- =========================================
-- 2. BASIC KPI METRICS
-- =========================================

-- Total Revenue
SELECT 
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM retail;

-- Total Orders
SELECT 
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM retail;

-- Total Customers
SELECT 
    COUNT(DISTINCT CustomerID) AS total_customers
FROM retail;

-- Average Order Value (AOV)
SELECT 
    ROUND(SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM retail;


-- =========================================
-- 3. SALES ANALYSIS
-- =========================================

-- Monthly Revenue Trend
SELECT 
    DATE_TRUNC('month', InvoiceDate) AS month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS monthly_revenue
FROM retail
GROUP BY month
ORDER BY month;

-- Daily Revenue Trend
SELECT 
    DATE(InvoiceDate) AS day,
    ROUND(SUM(Quantity * UnitPrice), 2) AS daily_revenue
FROM retail
GROUP BY day
ORDER BY day;

-- Revenue by Country
SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM retail
GROUP BY Country
ORDER BY revenue DESC;


-- =========================================
-- 4. PRODUCT ANALYSIS
-- =========================================

-- Top 10 Best-Selling Products (by quantity)
SELECT 
    Description,
    SUM(Quantity) AS total_quantity_sold
FROM retail
GROUP BY Description
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Top 10 Products by Revenue
SELECT 
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM retail
GROUP BY Description
ORDER BY total_revenue DESC
LIMIT 10;

-- Number of Unique Products
SELECT 
    COUNT(DISTINCT Description) AS unique_products
FROM retail;


-- =========================================
-- 5. CUSTOMER ANALYSIS
-- =========================================

-- Top 10 Customers by Revenue
SELECT 
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_spent
FROM retail
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;

-- Average Spending per Customer
SELECT 
    ROUND(AVG(customer_total), 2) AS avg_customer_spending
FROM (
    SELECT 
        CustomerID,
        SUM(Quantity * UnitPrice) AS customer_total
    FROM retail
    GROUP BY CustomerID
) sub;

-- Customer Order Frequency
SELECT 
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM retail
GROUP BY CustomerID
ORDER BY total_orders DESC
LIMIT 10;


-- =========================================
-- 6. RETURN / CANCELLATION ANALYSIS
-- =========================================

-- Identify returned/cancelled orders (InvoiceNo starting with 'C')
SELECT 
    COUNT(*) AS total_returns
FROM retail
WHERE InvoiceNo LIKE 'C%';

-- Return rate
SELECT 
    ROUND(
        (COUNT(CASE WHEN InvoiceNo LIKE 'C%' THEN 1 END) * 100.0) / COUNT(*), 
        2
    ) AS return_rate_percentage
FROM retail;

-- Products with highest returns
SELECT 
    Description,
    SUM(Quantity) AS total_returned
FROM retail
WHERE Quantity < 0
GROUP BY Description
ORDER BY total_returned ASC
LIMIT 10;


-- =========================================
-- 7. TIME-BASED ANALYSIS
-- =========================================

-- Revenue by Day of Week
SELECT 
    TO_CHAR(InvoiceDate, 'Day') AS day_of_week,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM retail
GROUP BY day_of_week
ORDER BY revenue DESC;

-- Revenue by Hour of Day
SELECT 
    EXTRACT(HOUR FROM InvoiceDate) AS hour,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM retail
GROUP BY hour
ORDER BY hour;


-- =========================================
-- 8. ADVANCED ANALYSIS (BONUS ⭐)
-- =========================================

-- Top 20% Customers Contribution (Pareto Analysis)
WITH customer_revenue AS (
    SELECT 
        CustomerID,
        SUM(Quantity * UnitPrice) AS revenue
    FROM retail
    GROUP BY CustomerID
),
ranked_customers AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY revenue DESC) AS percentile_group
    FROM customer_revenue
)
SELECT 
    percentile_group,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ranked_customers
GROUP BY percentile_group
ORDER BY percentile_group;

-- Monthly Active Customers
SELECT 
    DATE_TRUNC('month', InvoiceDate) AS month,
    COUNT(DISTINCT CustomerID) AS active_customers
FROM retail
GROUP BY month
ORDER BY month;


-- =========================================
-- END OF FILE
-- =========================================