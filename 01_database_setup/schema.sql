-- ==========================================================
-- PROJECT: Supply Chain Analytics (SQL 50 LeetCode)
-- FILE: 01_database_setup/schema.sql
-- ENGINE: MySQL 8.0+
-- DESCRIPTION: Star Schema DDL for Supply Chain Analytics
-- ==========================================================

DROP DATABASE IF EXISTS supply_chain_db;
CREATE DATABASE supply_chain_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE supply_chain_db;

-- ----------------------------------------------------------
-- 1. DIMENSION TABLES
-- ----------------------------------------------------------

-- Dimension: Sales Channels
CREATE TABLE dim_channel (
    channel VARCHAR(50) NOT NULL,
    PRIMARY KEY (channel)
);

-- Dimension: Products
CREATE TABLE dim_product (
    product_id VARCHAR(10) NOT NULL,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    shelf_life_days INT NOT NULL,
    storage_type VARCHAR(50) NOT NULL,
    unit_weight_kg DECIMAL(8, 3) NOT NULL,
    list_price DECIMAL(10, 2) NOT NULL,
    standard_cost DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (product_id)
);

-- Dimension: Suppliers
CREATE TABLE dim_supplier (
    supplier_id VARCHAR(10) NOT NULL,
    supplier_name VARCHAR(150) NOT NULL,
    supplier_region VARCHAR(100) NOT NULL,
    risk_tier VARCHAR(20) NOT NULL,
    planned_lead_time_days INT NOT NULL,
    reliability_pct DECIMAL(5, 4) NOT NULL,
    avg_defect_rate DECIMAL(6, 4) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    PRIMARY KEY (supplier_id)
);

-- Dimension: Customers
CREATE TABLE dim_customer (
    customer_id VARCHAR(10) NOT NULL,
    customer_name VARCHAR(150) NOT NULL,
    customer_segment VARCHAR(50) NOT NULL,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    sales_region VARCHAR(100) NOT NULL,
    priority VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Dimension: Warehouses
CREATE TABLE dim_warehouse (
    warehouse_id VARCHAR(10) NOT NULL,
    warehouse_name VARCHAR(150) NOT NULL,
    country VARCHAR(100) NOT NULL,
    warehouse_region VARCHAR(100) NOT NULL,
    capacity_pallets INT NOT NULL,
    cold_storage_flag TINYINT(1) NOT NULL,
    PRIMARY KEY (warehouse_id)
);

-- Dimension: Date / Calendar
CREATE TABLE dim_date (
    order_date DATE NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL,
    month_no INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    iso_week INT NOT NULL,
    day_name VARCHAR(20) NOT NULL,
    is_weekend TINYINT(1) NOT NULL,
    is_summer TINYINT(1) NOT NULL,
    is_december_peak TINYINT(1) NOT NULL,
    PRIMARY KEY (order_date)
);

-- ----------------------------------------------------------
-- 2. FACT TABLE
-- ----------------------------------------------------------

CREATE TABLE fact_orders (
    order_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    required_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    channel VARCHAR(50) NOT NULL,
    supplier_id VARCHAR(10) NOT NULL,
    warehouse_id VARCHAR(10) NOT NULL,
    order_qty INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    discount_pct DECIMAL(5, 4) NOT NULL,
    revenue DECIMAL(12, 2) NOT NULL,
    unit_cost DECIMAL(10, 2) NOT NULL,
    cogs DECIMAL(12, 2) NOT NULL,
    gross_profit DECIMAL(12, 2) NOT NULL,
    otif_flag TINYINT(1) NOT NULL,
    late_days INT NOT NULL,
    stockout_flag TINYINT(1) NOT NULL,
    return_qty INT NOT NULL,
    waste_qty INT NOT NULL,
    quality_issue_flag TINYINT(1) NOT NULL,
    promo_flag TINYINT(1) NOT NULL,
    PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_date FOREIGN KEY (order_date) REFERENCES dim_date(order_date),
    CONSTRAINT fk_orders_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    CONSTRAINT fk_orders_channel FOREIGN KEY (channel) REFERENCES dim_channel(channel),
    CONSTRAINT fk_orders_supplier FOREIGN KEY (supplier_id) REFERENCES dim_supplier(supplier_id),
    CONSTRAINT fk_orders_warehouse FOREIGN KEY (warehouse_id) REFERENCES dim_warehouse(warehouse_id)
);

-- ----------------------------------------------------------
-- 3. PERFORMANCE INDEXES (FOR JOIN & FILTER OPTIMIZATION)
-- ----------------------------------------------------------

CREATE INDEX idx_orders_date ON fact_orders(order_date);
CREATE INDEX idx_orders_product ON fact_orders(product_id);
CREATE INDEX idx_orders_customer ON fact_orders(customer_id);
CREATE INDEX idx_orders_supplier ON fact_orders(supplier_id);
CREATE INDEX idx_orders_warehouse ON fact_orders(warehouse_id);