WITH customer_revenue AS (
    SELECT
        t.customer_id,
        c.customer_name,
        SUM(t.revenue) AS total_revenue
    FROM NEWDB.DESCHEMA_staging.stg_hotelbook t
    JOIN NEWDB.DESCHEMA_staging.stg_cust c
        ON t.customer_id = c.customer_id
    GROUP BY t.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_revenue,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM customer_revenue