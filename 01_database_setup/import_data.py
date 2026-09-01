"""
PROJECT: Supply Chain Analytics(SQL 50 LeetCode)
FILE: 01_database_setup/import_data.py
DESCRIPTION: Automated ETL script to load Supply Chain data into MySQL
"""

import os
import pandas as pd
from sqlalchemy import create_engine

# Database connection credentials (retrieved from environment variables or placeholders)
DB_USER = os.getenv("DB_USER", "your_mysql_user")
DB_PASSWORD = os.getenv("DB_PASSWORD", "your_mysql_password")
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "3306")
DB_NAME = os.getenv("DB_NAME", "supply_chain_db")

CONNECTION_STRING = f"mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
EXCEL_FILE = "data/supply_chain_data.xlsx"

# Mapping configuration: Excel sheets to relational MySQL tables (snake_case)
TABLE_CONFIGS = [
    # 1. Dimension Tables (Parent entities loaded first)
    {
        "sheet": "Dim_Channel",
        "table": "dim_channel",
        "columns": {"Channel": "channel"},
    },
    {
        "sheet": "Dim_Product",
        "table": "dim_product",
        "columns": {
            "ProductID": "product_id",
            "Category": "category",
            "Subcategory": "subcategory",
            "Brand": "brand",
            "ProductName": "product_name",
            "ShelfLifeDays": "shelf_life_days",
            "StorageType": "storage_type",
            "UnitWeightKg": "unit_weight_kg",
            "ListPrice": "list_price",
            "StandardCost": "standard_cost",
        },
    },
    {
        "sheet": "Dim_Supplier",
        "table": "dim_supplier",
        "columns": {
            "SupplierID": "supplier_id",
            "SupplierName": "supplier_name",
            "SupplierRegion": "supplier_region",
            "RiskTier": "risk_tier",
            "PlannedLeadTimeDays": "planned_lead_time_days",
            "ReliabilityPct": "reliability_pct",
            "AvgDefectRate": "avg_defect_rate",
            "City": "city",
            "Country": "country",
            "Latitude": "latitude",
            "Longitude": "longitude",
        },
    },
    {
        "sheet": "Dim_Customer",
        "table": "dim_customer",
        "columns": {
            "CustomerID": "customer_id",
            "CustomerName": "customer_name",
            "CustomerSegment": "customer_segment",
            "Country": "country",
            "City": "city",
            "SalesRegion": "sales_region",
            "Priority": "priority",
        },
    },
    {
        "sheet": "Dim_Warehouse",
        "table": "dim_warehouse",
        "columns": {
            "WarehouseID": "warehouse_id",
            "WarehouseName": "warehouse_name",
            "Country": "country",
            "WarehouseRegion": "warehouse_region",
            "CapacityPallets": "capacity_pallets",
            "ColdStorageFlag": "cold_storage_flag",
        },
    },
    {
        "sheet": "Dim_Date",
        "table": "dim_date",
        "columns": {
            "Date": "order_date",
            "Year": "year",
            "Quarter": "quarter",
            "MonthNo": "month_no",
            "MonthName": "month_name",
            "ISOWeek": "iso_week",
            "DayName": "day_name",
            "IsWeekend": "is_weekend",
            "IsSummer": "is_summer",
            "IsDecemberPeak": "is_december_peak",
        },
    },
    # 2. Fact Table (Child entity loaded last)
    {
        "sheet": "Fact_Orders",
        "table": "fact_orders",
        "columns": {
            "OrderID": "order_id",
            "OrderDate": "order_date",
            "RequiredDate": "required_date",
            "ShipDate": "ship_date",
            "ProductID": "product_id",
            "CustomerID": "customer_id",
            "Channel": "channel",
            "SupplierID": "supplier_id",
            "WarehouseID": "warehouse_id",
            "OrderQty": "order_qty",
            "UnitPrice": "unit_price",
            "DiscountPct": "discount_pct",
            "Revenue": "revenue",
            "UnitCost": "unit_cost",
            "COGS": "cogs",
            "GrossProfit": "gross_profit",
            "OTIF_Flag": "otif_flag",
            "LateDays": "late_days",
            "StockoutFlag": "stockout_flag",
            "ReturnQty": "return_qty",
            "WasteQty": "waste_qty",
            "QualityIssueFlag": "quality_issue_flag",
            "PromoFlag": "promo_flag",
        },
    },
]


def run_pipeline():
    """Extracts data from Excel sheets, transforms schemas, and loads into MySQL."""
    try:
        engine = create_engine(CONNECTION_STRING)
        print("Database connection initialized.")

        for config in TABLE_CONFIGS:
            sheet = config["sheet"]
            table = config["table"]
            cols = config["columns"]

            print(f"Ingesting sheet: '{sheet}' -> table: '{table}'...")
            df = pd.read_excel(EXCEL_FILE, sheet_name=sheet)

            # Apply column mapping
            df = df.rename(columns=cols)

            # Standardize date formats to YYYY-MM-DD
            for col in df.columns:
                if "date" in col.lower():
                    df[col] = pd.to_datetime(df[col]).dt.date

            # Ingest data into relational tables
            df.to_sql(name=table, con=engine, if_exists="append", index=False)
            print(f"Successfully loaded {len(df)} rows into `{table}`.")

        print("\nETL Pipeline completed successfully.")

    except Exception as e:
        print(f"ETL Pipeline execution failed: {e}")


if __name__ == "__main__":
    run_pipeline()