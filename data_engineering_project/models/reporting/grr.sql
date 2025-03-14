WITH cust_trans AS (
    SELECT
        customer_id,
        payment_month,
        SUM(revenue) AS total
    FROM {{ ref('stg_hotelbook') }}
    WHERE payment_month <= DATEADD(MONTH, -12, (SELECT MAX(payment_month) FROM {{ ref('stg_hotelbook') }}))
    GROUP BY 1, 2
),
 
prev_rev AS (
    SELECT
        customer_id,
        payment_month,
        total,
        LAG(total) OVER (PARTITION BY customer_id ORDER BY payment_month) AS prev_revenue
    FROM cust_trans
),
 
expansion_contract AS (
    SELECT
        customer_id,
        payment_month,
        prev_revenue,
        total,
        CASE
            WHEN total > prev_revenue THEN total - prev_revenue
            ELSE 0
        END AS expansion_revenue,
        CASE
            WHEN total < prev_revenue THEN prev_revenue - total
            ELSE 0
        END AS contract_revenue
    FROM prev_rev
)
 
SELECT
    customer_id,
    payment_month,
    total AS current_revenue,
    prev_revenue AS prev_rev,
    expansion_revenue,
    contract_revenue,
    CASE
        WHEN prev_revenue = 0 THEN NULL  
        ELSE (total - contract_revenue) / prev_revenue
    END AS nrr
FROM expansion_contract