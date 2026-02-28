-- Query 1: Total Revenue (Overall vs. Delivered)

SELECT 
    ROUND(SUM(p.payment_value)::numeric, 2) AS total_revenue_all,
    ROUND(SUM(CASE WHEN o.order_status = 'delivered' THEN p.payment_value ELSE 0 END)::numeric, 2) AS total_delivered_revenue
FROM orders o
JOIN payments p ON o.order_id = p.order_id;

-- Query 2: Orders per Month & Month-over-Month (MoM) Growth

WITH monthly_metrics AS (
    SELECT 
        TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS order_month,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    WHERE order_status = 'delivered'
    GROUP BY 1
)
SELECT 
    order_month,
    total_orders,
    LAG(total_orders) OVER(ORDER BY order_month) AS previous_month_orders,
    ROUND(
        (total_orders - LAG(total_orders) OVER(ORDER BY order_month))::numeric / 
        NULLIF(LAG(total_orders) OVER(ORDER BY order_month), 0) * 100
    , 2) AS mom_growth_pct
FROM monthly_metrics
ORDER BY order_month;

-- Query 3: Top 10 Product Categories by Revenue

SELECT 
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name IS NOT NULL
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;