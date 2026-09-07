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

-- ----------------------------------------------------------
-- Task 07: Product Line Profitability Breakdown
-- LeetCode: 1068. Product Sales Analysis I
-- Business Question:
-- Category managers require visibility into product-level margin generation across historical transactions. 
-- Retrieve the order identifier, product name, product category, order revenue, and gross profit for all fulfilled orders with matched product records.
-- ----------------------------------------------------------

SELECT  
    fo.order_id,
    dp.product_name,
    dp.category,
    fo.revenue,
    fo.gross_profit
FROM fact_orders AS fo
INNER JOIN dim_product AS dp
ON fo.product_id = dp.product_id;