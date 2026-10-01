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

-- ----------------------------------------------------------
-- Task 08: Inactive Strategic Accounts
-- LeetCode: 1581. Customer Who Visited but Did Not Make Any Transactions
-- Business Question:
-- Strategic account executives are auditing high-priority accounts to identify dormant relationships. Retrieve customer identifier, customer name, country, and sales region for all customers with 'Strategic' priority who have not placed any orders in the system.
-- ----------------------------------------------------------

SELECT  
	dc.customer_id,
    dc.customer_name,
    dc.country,
    dc.sales_region
FROM dim_customer AS dc
LEFT JOIN fact_orders AS fo
    ON dc.customer_id = fo.customer_id
WHERE dc.priority = 'Strategic'
    AND fo.order_id IS NULL;

-- ----------------------------------------------------------
-- Task 09: Deteriorating Consecutive Lead Time Performance
-- LeetCode: 197. Rising Temperature
-- Business Question:
-- Logistics supervisors track supplier deterioration across continuous fulfillment days. 
-- Identify order instances where, for the same supplier, an order was placed exactly one day after an earlier order and suffered a strictly higher delivery delay (late_days) than that previous day's order.
-- ----------------------------------------------------------

SELECT  
    a.order_id,
    a.supplier_id,
    a.order_date AS current_order_date,
    a.late_days AS current_late_days,
    b.order_date AS previous_order_date,
    b.late_days AS previous_late_days
FROM fact_orders AS a 
INNER JOIN fact_orders AS b
    ON a.supplier_id = b.supplier_id
    AND a.order_date = DATE_ADD(b.order_date, INTERVAL 1 DAY)
WHERE a.late_days > b.late_days;

-- ----------------------------------------------------------
-- Task 10: Warehouse Lead Time & Dispatch Cycle Efficiency
-- LeetCode: 1661. Average Time of Process per Machine
-- Business Question:
-- Supply chain operational excellence requires benchmarking fulfillment throughput across distribution hubs. Calculate the average fulfillment lead time in days (elapsed duration between order placement and shipment dispatch) for each warehouse. 
-- Retrieve the warehouse identifier, warehouse name, and average dispatch lead time rounded to 3 decimal places. Sort by average dispatch time ascending.
-- ----------------------------------------------------------

SELECT  
	dw.warehouse_id,
	dw.warehouse_name,
    ROUND(AVG(DATEDIFF(fc.ship_date, fc.order_date)), 3) AS avg_dispatch_days
FROM dim_warehouse AS dw 
INNER JOIN fact_orders AS fc
    ON dw.warehouse_id = fc.warehouse_id
GROUP BY dw.warehouse_id, dw.warehouse_name
ORDER BY avg_dispatch_days ASC;

-- ----------------------------------------------------------
-- Task 11: Vendor Quality Compliance & Low-Defect Screening
-- LeetCode: 577. Employee Bonus
-- Business Question:
-- Supplier quality assurance monitors component defect tolerance to ensure production reliability. 
-- Retrieve the supplier name and average defect rate for all suppliers whose defect rate is strictly less than 0.015 (1.5%) or is recorded as NULL.
-- ----------------------------------------------------------

SELECT 
    supplier_name, avg_defect_rate
FROM dim_supplier
WHERE avg_defect_rate < 0.015
    OR avg_defect_rate IS NULL;