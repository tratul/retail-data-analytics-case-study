-- Total Revenue
SELECT 
    SUM(Quantity * UnitPrice) AS total_revenue
FROM retail;

-- Top Products
SELECT 
    Description,
    SUM(Quantity) AS total_sold
FROM retail
GROUP BY Description
ORDER BY total_sold DESC
LIMIT 10;

-- Monthly Revenue
SELECT 
    DATE_TRUNC('month', InvoiceDate) AS month,
    SUM(Quantity * UnitPrice) AS revenue
FROM retail
GROUP BY month
ORDER BY month;


-- Top Customers
SELECT 
    CustomerID,
    SUM(Quantity * UnitPrice) AS total_spent
FROM retail
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;