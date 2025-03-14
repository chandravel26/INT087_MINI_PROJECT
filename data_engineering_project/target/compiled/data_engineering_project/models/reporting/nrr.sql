WITH customer_transactions AS (
    SELECT
        customer_id,
        payment_month,
        SUM(revenue) AS total_revenue
    FROM NEWDB.DESCHEMA_staging.stg_hotelbook
    WHERE payment_month <= DATEADD(MONTH, -12, (SELECT MAX(payment_month) FROM NEWDB.DESCHEMA_staging.stg_hotelbook))
    GROUP BY 1, 2
),
 
previous_revenue AS (
    SELECT
        customer_id,
        payment_month,
        total_revenue,
        LAG(total_revenue) OVER (PARTITION BY customer_id ORDER BY payment_month) AS prev_revenue
    FROM customer_transactions
),
 
expansion_contraction AS (
    SELECT
        customer_id,
        payment_month,
        prev_revenue,
        total_revenue,
        CASE
            WHEN total_revenue > prev_revenue THEN total_revenue - prev_revenue
            ELSE 0
        END AS expansion_revenue,
        CASE
            WHEN total_revenue < prev_revenue THEN prev_revenue - total_revenue
            ELSE 0
        END AS contraction_revenue
    FROM previous_revenue
)
 
SELECT
    customer_id,
    payment_month,
    total_revenue AS current_revenue,
    prev_revenue AS previous_revenue,
    expansion_revenue,
    contraction_revenue,
    CASE
        WHEN prev_revenue = 0 THEN NULL  
        ELSE (total_revenue + expansion_revenue - contraction_revenue) / prev_revenue
    END AS nrr
FROM expansion_contraction