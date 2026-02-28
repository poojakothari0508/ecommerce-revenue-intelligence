-- Query 4: New vs. Repeat Customers

WITH customer_order_counts AS (
    SELECT 
        c.customer_unique_id, 
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT 
    CASE 
        WHEN total_orders = 1 THEN 'One-Time Customer' 
        ELSE 'Repeat Customer' 
    END AS customer_type,
    COUNT(customer_unique_id) AS total_customers,
    ROUND(
        COUNT(customer_unique_id)::numeric / SUM(COUNT(customer_unique_id)) OVER() * 100
    , 2) AS percentage_of_total
FROM customer_order_counts
GROUP BY 1;

-- Query 5: Average Order Value (AOV) by Payment Type

SELECT 
    p.payment_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value)::numeric, 2) AS total_revenue,
    ROUND(SUM(p.payment_value)::numeric / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY average_order_value DESC;