WITH mnth AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', PAYMENT_MONTH) AS transact_month
    FROM {{ ref('stg_hotelbook') }}
),
 
max_month AS (
    SELECT MAX(transact_month) AS latest FROM mnth
),
 
cust_status AS (
    SELECT
        i.customer_id,
        MAX(i.transact_month) AS max_month,
        CASE
            WHEN MAX(i.transact_month) <= DATEADD('month', -3, m.latest) THEN 'Churned'
            WHEN MIN(i.transact_month) >= DATEADD('month', -3, m.latest) THEN 'New'
            ELSE 'Active'
        END AS churn_status
    FROM mnth i
    CROSS JOIN max_month m
    GROUP BY i.customer_id, m.latest
)
 
SELECT
    churn_status,
    COUNT(*) AS customer_count
FROM cust_status
GROUP BY churn_status