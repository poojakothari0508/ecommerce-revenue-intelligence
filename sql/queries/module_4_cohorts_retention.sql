-- Query 8: Monthly Cohort Retention -- (one of the most advanced query) --

WITH user_cohorts AS (
    SELECT 
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
order_months AS (
    SELECT 
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
cohort_retention AS (
    SELECT 
        uc.cohort_month,
        (EXTRACT(YEAR FROM om.order_month) - EXTRACT(YEAR FROM uc.cohort_month)) * 12 + 
        (EXTRACT(MONTH FROM om.order_month) - EXTRACT(MONTH FROM uc.cohort_month)) AS month_index,
        COUNT(DISTINCT uc.customer_unique_id) AS active_users
    FROM user_cohorts uc
    JOIN order_months om ON uc.customer_unique_id = om.customer_unique_id
    GROUP BY 1, 2
),
cohort_size AS (
    SELECT cohort_month, active_users AS total_users 
    FROM cohort_retention 
    WHERE month_index = 0
)
SELECT 
    TO_CHAR(cr.cohort_month, 'YYYY-MM') AS cohort_month,
    cs.total_users,
    cr.month_index,
    cr.active_users,
    ROUND((cr.active_users::numeric / cs.total_users) * 100, 2) AS retention_percentage
FROM cohort_retention cr
JOIN cohort_size cs ON cr.cohort_month = cs.cohort_month
WHERE cr.cohort_month >= '2017-01-01' -- Exclude early beta testing data
ORDER BY cr.cohort_month, cr.month_index;

-- Query 9: Churn Identification (Recency Analysis)

WITH user_recency AS (
    SELECT 
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_purchase_date,
        (SELECT MAX(order_purchase_timestamp) FROM orders) AS max_database_date
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT 
    CASE 
        WHEN max_database_date - last_purchase_date <= INTERVAL '90 days' THEN '1. Active (0-90 days)'
        WHEN max_database_date - last_purchase_date <= INTERVAL '180 days' THEN '2. At Risk (91-180 days)'
        WHEN max_database_date - last_purchase_date <= INTERVAL '365 days' THEN '3. Churned (181-365 days)'
        ELSE '4. Lost (> 365 days)'
    END AS customer_status,
    COUNT(customer_unique_id) AS total_customers,
    ROUND(COUNT(customer_unique_id)::numeric / SUM(COUNT(customer_unique_id)) OVER () * 100, 2) AS percentage_of_total
FROM user_recency
GROUP BY 1
ORDER BY 1;
