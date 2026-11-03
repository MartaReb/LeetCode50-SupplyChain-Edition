-- ==========================================================
-- PROJECT: Supply Chain Analytics (SQL 50 Leet Code)
-- SECTION 4: Subqueries & CTEs (Tasks 25 - 32)
-- FILE: 02_sql_queries/04_subqueries_and_ctes.sql
-- ==========================================================

USE supply_chain_db;

-- ----------------------------------------------------------
-- Task 25: Orders Exceeding Regional Average Revenue (Correlated Subquery / CTE)
-- LeetCode: 585. Investments in 2016
-- Business Question:
-- Commercial analytics needs to identify high-value transaction outliers within each market. 
-- Retrieve all orders where the order revenue exceeds the average order revenue of that order's specific sales region. 
-- Include order identifier, order date, customer name, sales region, and revenue (rounded to 2 decimals). 
-- Sort by revenue descending.
-- ----------------------------------------------------------

SELECT 
    order_id,
    order_date,
    customer_name,
    sales_region,
    ROUND(revenue,2) AS revenue
FROM 
	(SELECT
        fo.order_id,
        fo.order_date,
        dc.customer_name,
        dc.sales_region,
        fo.revenue,
        AVG(fo.revenue) OVER(partition by dc.sales_region) AS avg_revenue
	FROM dim_customer dc
	INNER JOIN fact_orders fo
	    ON dc.customer_id = fo.customer_id
    WHERE dc.sales_region IS NOT NULL) AS t
WHERE revenue > avg_revenue
ORDER BY revenue DESC;


-- ----------------------------------------------------------
-- Task 26: Zero-Sales & Inactive Product Portfolio Audit
-- LeetCode: 183. Customers Who Never Order
-- Business Question:
-- Inventory management needs to identify dead stock / unorderable product listings. 
-- Retrieve the product identifier, product name, category for all products in dim_product that have never been ordered in fact_orders. 
-- Sort by category ascending, then product name ascending.
-- ----------------------------------------------------------

SELECT 
    dp.product_id,
    dp.product_name,
    dp.category
FROM dim_product dp
WHERE NOT EXISTS (
    SELECT 1 
    FROM fact_orders fo 
    WHERE fo.product_id = dp.product_id
)
ORDER BY dp.category ASC, dp.product_name ASC;

-- ----------------------------------------------------------
-- Task 27: Top Performing Product per Category (Ranking with CTEs)
-- LeetCode: 184. Department Highest Salary (adapted for Products/Revenue)
-- Business Question:
-- Category managers need to identify the single highest-grossing product in their respective portfolios. 
-- Calculate the total revenue per product, rank them within each category, and filter the results to show only the #1 product per category. 
-- Sort by category ascending.
-- ----------------------------------------------------------

WITH revenue_cte AS (
    SELECT 
        dp.category,
        dp.product_id,
        dp.product_name,
        ROUND(SUM(fo.revenue), 2) AS total_revenue,
        RANK() OVER(PARTITION BY dp.category ORDER BY SUM(fo.revenue) DESC) as product_rank
    FROM fact_orders fo
    INNER JOIN dim_product dp
        ON dp.product_id = fo.product_id
    GROUP BY dp.category, dp.product_id, dp.product_name
)
SELECT 
    category,
    product_id,
    product_name,
    total_revenue
FROM revenue_cte
WHERE product_rank = 1
ORDER BY category ASC;

-- ----------------------------------------------------------
-- Task 28: Customer First Order (Onboarding) Analysis
-- LeetCode: 512. Game Play Analysis II (adapted for Orders)
-- Business Question:
-- CRM needs to identify the exact date and revenue of each customer's very first order for anniversary campaigns. 
-- Find the earliest order date per customer and its associated revenue. 
-- If there are multiple orders on that first day, pick the one with the highest revenue. 
-- Sort by first order date ascending.
-- ----------------------------------------------------------

WITH rank_orders AS (
    SELECT 
        fo.customer_id,
        dm.customer_name,
        fo.order_date,
        fo.revenue,
        ROW_NUMBER() OVER(PARTITION BY fo.customer_id ORDER BY fo.order_date ASC, fo.revenue DESC) AS rn
    FROM fact_orders fo
    INNER JOIN dim_customer dm
        ON fo.customer_id = dm.customer_id
)
SELECT 
    customer_name,
    order_date AS first_order_date,
    ROUND(revenue, 2) AS first_order_revenue
FROM rank_orders
WHERE rn = 1
ORDER BY first_order_date ASC;

-- ----------------------------------------------------------
-- Task 29: Running Total (Cumulative Revenue) by Month
-- LeetCode: 1204. Last Person to Fit in the Bus (concept of Running Total)
-- Business Question:
-- Finance tracking requires a month-over-month running total of revenue. 
-- First, use a CTE to aggregate total revenue per month (using DATE_FORMAT(order_date, '%Y-%m')). 
-- Then, in the main query, calculate the cumulative (running) total revenue up to that month using a window function. Sort chronologically.
-- ----------------------------------------------------------

WITH month_revenue_cte AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        SUM(revenue) AS monthly_revenue
    FROM fact_orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
    order_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER(ORDER BY order_month ASC), 2) AS running_total
FROM month_revenue_cte
ORDER BY order_month ASC;