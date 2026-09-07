-- ==========================================================
-- PROJECT: Supply Chain Analytics (SQL 50 Leet Code)
-- SECTION 2: Basic Joins (Tasks 06 - 14)
-- FILE: 02_sql_queries/02_basic_joins.sql
-- ==========================================================

USE supply_chain_db;

-- ----------------------------------------------------------
-- Task 06: Order Supplier Risk Profile Enrichment
-- LeetCode: 1378. Replace Employee ID With The Unique Identifier
-- Business Question:
-- Supply chain risk management requires monitoring vendor exposure across all historical sales. 
-- Retrieve each order identifier, order date, and revenue alongside the associated supplier name and risk tier. 
-- Ensure all orders are displayed even if supplier master data is unassigned.
-- ----------------------------------------------------------

SELECT  
    fo.order_id,
    fo.order_date,
    fo.revenue,
    ds.supplier_name,
    ds.risk_tier
FROM fact_orders AS fo
LEFT JOIN dim_supplier AS ds
ON fo.supplier_id = ds.supplier_id;
