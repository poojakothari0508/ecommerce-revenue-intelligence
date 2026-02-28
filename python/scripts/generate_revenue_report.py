import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt
import seaborn as sns
import os

# 1. Database Configuration (Same as your web_events script!)
db_user = 'postgres'
db_password = '' # <--- SQL server password of your machine!
db_host = 'localhost'
db_port = '5432'
db_name = 'ecommerce_db'

connection_str = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}'
engine = create_engine(connection_str)

print("Connecting to database and pulling data...")

# 2. The SQL Query (Monthly Revenue)
query = """
    SELECT 
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS order_month,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
    ORDER BY 1;
"""

# 3. SQL -> Pandas Workflow
df = pd.read_sql(query, engine)

# Convert total_revenue to numeric for plotting
df['total_revenue'] = pd.to_numeric(df['total_revenue'])

# 4. Generate the Chart
print("Generating revenue trend chart...")
plt.figure(figsize=(12, 6))
sns.set_theme(style="whitegrid")

# Create a line plot
sns.lineplot(data=df, x='order_month', y='total_revenue', marker='o', color='b', linewidth=2)

# Format the chart
plt.title('Monthly Revenue Trend', fontsize=16, fontweight='bold')
plt.xlabel('Month', fontsize=12)
plt.ylabel('Total Revenue (BRL)', fontsize=12)
plt.xticks(rotation=45)
plt.tight_layout()

# 5. Save the Chart automatically
# Create a 'reports' folder if it doesn't exist
os.makedirs('reports', exist_ok=True)
output_path = 'reports/monthly_revenue_trend.png'
plt.savefig(output_path)

print(f"✅ Success! Report saved to: {output_path}")