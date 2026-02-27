import pandas as pd
import numpy as np
import random
from datetime import timedelta

# CONFIG
RAW_DATA_PATH = 'data/raw/'  # Make sure this matches your folder name!
OUTPUT_PATH = 'data/raw/'

print("Loading Olist Orders...")
orders = pd.read_csv(f'{RAW_DATA_PATH}olist_orders_dataset.csv')

# Convert dates
orders['order_purchase_timestamp'] = pd.to_datetime(orders['order_purchase_timestamp'])

# ---------------------------------------------------------
# 1. GENERATE MARKETING CAMPAIGNS
# ---------------------------------------------------------
print("Generating Marketing Data...")
campaigns = [
    {'campaign_id': 'CMP_001', 'channel': 'Social Media', 'name': 'Summer_Sale_FB', 'cost': 5000},
    {'campaign_id': 'CMP_002', 'channel': 'Search', 'name': 'Google_Ads_Generic', 'cost': 12000},
    {'campaign_id': 'CMP_003', 'channel': 'Email', 'name': 'Newsletter_Promo', 'cost': 800},
    {'campaign_id': 'CMP_004', 'channel': 'Influencer', 'name': 'Insta_Influencer_Launch', 'cost': 3500},
    {'campaign_id': 'CMP_005', 'channel': 'Organic', 'name': 'SEO_Traffic', 'cost': 0}
]
df_campaigns = pd.DataFrame(campaigns)

# Assign orders to campaigns (Weighted logic: Organic is biggest, others follow)
weights = [0.2, 0.3, 0.15, 0.1, 0.25]
orders['campaign_id'] = np.random.choice(
    [c['campaign_id'] for c in campaigns], 
    size=len(orders), 
    p=weights
)

# Export Marketing Table
df_campaigns.to_csv(f'{OUTPUT_PATH}marketing_campaigns.csv', index=False)
print(f"Saved: {OUTPUT_PATH}marketing_campaigns.csv")

# Export Order-Marketing Link (We will join this in SQL)
# We only need order_id and campaign_id for the join table
marketing_attribution = orders[['order_id', 'campaign_id']]
marketing_attribution.to_csv(f'{OUTPUT_PATH}order_marketing_attribution.csv', index=False)
print(f"Saved: {OUTPUT_PATH}order_marketing_attribution.csv")


# ---------------------------------------------------------
# 2. GENERATE WEB EVENTS (The "Big Data" Table)
# ---------------------------------------------------------
print("Generating Web Clickstream Data (This might take a moment)...")

# We will generate 3-5 events per order to simulate browsing behavior
events = []
event_types = ['page_view', 'add_to_cart', 'page_view', 'login']

# Sample 10% of orders to keep file size manageable for local dev
sample_orders = orders.sample(frac=0.1, random_state=42)

for index, row in sample_orders.iterrows():
    n_events = random.randint(3, 6)
    base_time = row['order_purchase_timestamp']
    
    for i in range(n_events):
        # Events happen BEFORE purchase
        event_time = base_time - timedelta(minutes=random.randint(5, 120))
        
        events.append({
            'event_id': f"EVT_{random.randint(100000, 999999)}",
            'customer_id': row['customer_id'],
            'event_type': random.choice(event_types),
            'event_timestamp': event_time,
            'device': random.choice(['mobile', 'desktop', 'tablet']),
            'session_id': f"SES_{random.randint(1000, 9999)}"
        })

df_events = pd.DataFrame(events)
df_events.to_csv(f'{OUTPUT_PATH}web_events.csv', index=False)
print(f"Saved: {OUTPUT_PATH}web_events.csv")
print("DONE! Synthetic data generation complete.")