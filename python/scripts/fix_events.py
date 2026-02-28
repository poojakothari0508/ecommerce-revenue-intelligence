import pandas as pd
from sqlalchemy import create_engine

# CONFIGURATION (Same as before)
db_user = 'postgres'
db_password = '' # <--- SQL server password of your machine!
db_host = 'localhost'
db_port = '5432'
db_name = 'ecommerce_db'

connection_str = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
engine = create_engine(connection_str)

print("Fixing Web Events...")

# 1. Read the CSV
df = pd.read_csv('data/raw/web_events.csv')
original_count = len(df)

# 2. Drop Duplicates (The Magic Fix)
# We keep the first occurrence of an ID and drop the rest
df.drop_duplicates(subset=['event_id'], keep='first', inplace=True)
new_count = len(df)

print(f"Removed {original_count - new_count} duplicate rows.")

# 3. Load to SQL
try:
    df.to_sql('web_events', engine, if_exists='append', index=False)
    print(f"✅ Success: web_events loaded ({len(df)} rows)")
except Exception as e:
    print(f"❌ Error: {e}")