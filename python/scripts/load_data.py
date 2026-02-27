import pandas as pd
from sqlalchemy import create_engine
import os

# CONFIGURATION
# ---------------------------------------------------------
db_user = 'postgres'
db_password = '0911saqlain'  # <--- SQL server password of your machine!
db_host = 'localhost'
db_port = '5432'
db_name = 'ecommerce_db'

# Connection String
connection_str = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
engine = create_engine(connection_str)

# FILE MAPPING (CSV Filename -> Database Table Name)
# Order matters! Parent tables first, children second.
files_to_load = [
    ('olist_products_dataset.csv', 'products'),
    ('olist_sellers_dataset.csv', 'sellers'),
    ('olist_customers_dataset.csv', 'customers'),
    ('olist_orders_dataset.csv', 'orders'),
    ('olist_order_items_dataset.csv', 'order_items'),
    ('olist_order_payments_dataset.csv', 'payments'),
    ('marketing_campaigns.csv', 'marketing_campaigns'),
    ('order_marketing_attribution.csv', 'order_marketing_attribution'),
    ('web_events.csv', 'web_events')
]

BASE_PATH = 'data/raw/'

print("Starting ETL Process...")

for file_name, table_name in files_to_load:
    file_path = f"{BASE_PATH}{file_name}"
    
    if os.path.exists(file_path):
        print(f"Loading {table_name}...")
        try:
            # Read CSV
            df = pd.read_csv(file_path)
            
            # Data Cleaning (Basic)
            # Ensure dates are parsed correctly if pandas missed them
            for col in df.columns:
                if 'date' in col or 'timestamp' in col:
                    df[col] = pd.to_datetime(df[col])
            
            # Load to SQL
            # if_exists='append' adds data to the table we created.
            # index=False ensures we don't upload the row number.
            df.to_sql(table_name, engine, if_exists='append', index=False)
            
            print(f"✅ Success: {table_name} loaded ({len(df)} rows)")
            
        except Exception as e:
            print(f"❌ Error loading {table_name}: {e}")
    else:
        print(f"⚠️ File not found: {file_name}")

print("ETL Process Completed.")