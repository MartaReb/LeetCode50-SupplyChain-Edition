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
-- Our warehouse operations team needs to prioritize dispatch for high-risk perishable inventory to minimize spoilage. Retrieve the product identifier, product name, and shelf life for all chilled goods that have a shelf life strictly under 60 days.
-- ----------------------------------------------------------

SELECT 
    product_id,
    product_name,
    shelf_life_days
FROM dim_product
WHERE storage_type = 'Chilled'
  AND shelf_life_days < 60;