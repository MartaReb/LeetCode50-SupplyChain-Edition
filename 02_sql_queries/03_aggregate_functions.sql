-- ==========================================================
-- PROJECT: Supply Chain Analytics (SQL 50 Leet Code)
-- SECTION 3: Aggregate Functions (Tasks 15 - 24)
-- FILE: 02_sql_queries/03_aggregate_functions.sql
-- ==========================================================

USE supply_chain_db;

-- ----------------------------------------------------------
-- Task 15: High-Priority Customer Revenue & Delay Summary
-- LeetCode: 1693. Daily Leads and Partners
-- Business Question:
-- Account executives require a performance summary for top-tier accounts. 
-- Calculate the total order revenue (rounded to 2 decimals) and average delivery delay in days (rounded to 1 decimal) for all customers with 'Strategic' or 'High' priority. 
-- Include accounts without orders. Sort by total revenue descending.
-- ----------------------------------------------------------

SELECT 
    dc.customer_name, 
    dc.priority, 
    IFNULL(ROUND(SUM(fo.revenue), 2), 0) AS total_revenue, 
    ROUND(AVG(fo.late_days), 1) AS avg_late_days
FROM dim_customer dc
LEFT JOIN fact_orders fo
    ON dc.customer_id = fo.customer_id
WHERE dc.priority IN ('Strategic', 'High')
GROUP BY dc.customer_id, dc.customer_name, dc.priority
ORDER BY total_revenue DESC;