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
-- Retrieve all orders where the order revenue exceeds the average order revenue of that order's specific sales region. Include order identifier, order date, customer name, sales region, and revenue (rounded to 2 decimals). 
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