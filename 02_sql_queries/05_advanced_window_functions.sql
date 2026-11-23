-- ==========================================================
-- PROJECT: Supply Chain Analytics (SQL 50 Leet Code)
-- SECTION 5: Advanced Window Functions & Analytical Patterns (Tasks 33 - 40)
-- FILE: 02_sql_queries/05_advanced_window_functions.sql
-- ==========================================================

USE supply_chain_db;

-- ----------------------------------------------------------
-- Task 33: Product ABC (Pareto) Revenue Classification
-- LeetCode: 1204. Last Person to Fit in the Bus (Cumulative Distribution / Window Extension)
-- Business Question:
-- Inventory management wants to prioritize stock control using an ABC (Pareto) classification based on revenue contribution. 
-- Calculate total revenue per ordered product, compute the cumulative percentage share of total company revenue ordered from highest to lowest revenue, and classify products into 'A' (<= 80%), 'B' (> 80% and <= 95%), and 'C' (> 95%). 
-- Round monetary and percentage values to 2 decimal places. 
-- Sort by total revenue descending, then product_id ascending.
-- ----------------------------------------------------------

WITH product_revenue AS (
    SELECT
        fo.product_id,
        dp.product_name,
        dp.category,
        SUM(fo.revenue) AS total_revenue
    FROM fact_orders fo
    INNER JOIN dim_product dp
        ON fo.product_id = dp.product_id
    GROUP BY fo.product_id, dp.product_name, dp.category
),

cumulative_calculation AS (
    SELECT
        product_id,
        product_name,
        category,
        total_revenue,
        SUM(total_revenue) OVER(ORDER BY total_revenue DESC, product_id ASC) AS cumulative_revenue,
        SUM(total_revenue) OVER() AS company_total_revenue
    FROM product_revenue
)

SELECT
    product_id,
    product_name,
    category,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND((cumulative_revenue / company_total_revenue) * 100, 2) AS cumulative_revenue_pct,
    CASE
        WHEN (cumulative_revenue / company_total_revenue) * 100 <= 80 THEN 'A'
        WHEN (cumulative_revenue / company_total_revenue) * 100 <= 95 THEN 'B'
        ELSE 'C'
    END AS abc_class
FROM cumulative_calculation
ORDER BY total_revenue DESC, product_id ASC;