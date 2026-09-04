-- ==========================================================
-- PROJECT: Supply Chain Analytics (SQL 50 LeetCode)
-- SECTION 1: Select (Tasks 01 - 05)
-- FILE: 02_sql_queries/01_select.sql
-- ==========================================================

USE supply_chain_db;

-- ----------------------------------------------------------
-- Task 01: Perishable Cold-Chain Alert
-- LeetCode: 1757. Recyclable and Low Fat Products
-- Business Question:
-- Our warehouse operations team needs to prioritize dispatch for high-risk perishable inventory to minimize spoilage. 
--Retrieve the product identifier, product name, and shelf life for all chilled goods that have a shelf life strictly under 60 days.
-- ----------------------------------------------------------

SELECT 
    product_id,
    product_name,
    shelf_life_days
FROM dim_product
WHERE storage_type = 'Chilled'
  AND shelf_life_days < 60;

-- ----------------------------------------------------------
-- Task 02: Standard Pricing & Low Concession Audit
-- LeetCode: 584. Find Customer Referee
-- Business Question:
-- Our pricing strategy team is evaluating list price adherence across our distribution network. 
--Retrieve all orders where customers were granted a commercial discount strictly lower than 5% (including transactions with no discount applied). 
--Display the order identifier, customer identifier, unit price, and discount percentage.
-- ----------------------------------------------------------

SELECT 
    order_id,
    customer_id,
    unit_price,
    discount_pct
FROM fact_orders
WHERE discount_pct < 0.05 
   OR discount_pct IS NULL;

-- ----------------------------------------------------------
-- Task 03: High-Capacity Baltic Distribution Centers
-- LeetCode: 595. Big Countries
-- Business Question:
-- Network capacity planners require a list of primary distribution hubs capable of handling large-scale pallet storage in the Baltic region. 
--Retrieve the warehouse name, country, and pallet capacity for all warehouses located in 'Baltics' with a capacity of at least 8,000 pallets.
-- ----------------------------------------------------------

SELECT 
    warehouse_name,
    country,
    capacity_pallets
FROM dim_warehouse
WHERE warehouse_region = 'Baltics'
    AND capacity_pallets >= 8000;
   