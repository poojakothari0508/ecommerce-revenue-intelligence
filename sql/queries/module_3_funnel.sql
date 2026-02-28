-- Query 6: Overall Funnel Conversion Rates

WITH funnel_steps AS (
    SELECT 
        SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS total_views,
        SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS total_add_to_cart,
        SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS total_checkouts,
        SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS total_purchases
    FROM web_events
)
SELECT 
    total_views,
    total_add_to_cart,
    total_checkouts,
    total_purchases,
    ROUND((total_add_to_cart::numeric / NULLIF(total_views, 0)) * 100, 2) AS view_to_cart_rate,
    ROUND((total_checkouts::numeric / NULLIF(total_add_to_cart, 0)) * 100, 2) AS cart_to_checkout_rate,
    ROUND((total_purchases::numeric / NULLIF(total_views, 0)) * 100, 2) AS overall_conversion_rate
FROM funnel_steps;

-- Query 7: Abandoned Cart Analysis

WITH user_funnel AS (
    SELECT 
        customer_id,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM web_events
    GROUP BY customer_id
)
SELECT 
    COUNT(customer_id) AS total_users,
    SUM(CASE WHEN added_to_cart = 1 AND purchased = 0 THEN 1 ELSE 0 END) AS abandoned_carts,
    ROUND(
        (SUM(CASE WHEN added_to_cart = 1 AND purchased = 0 THEN 1 ELSE 0 END)::numeric / COUNT(customer_id)) * 100
    , 2) AS abandoned_cart_rate
FROM user_funnel;
