WITH source AS (
    SELECT
        t.customer_id,
        c.customer_name,
        SUM(t.revenue) AS total
    FROM {{ ref('stg_hotelbook') }} t
    JOIN {{ ref('stg_cust') }} c
        ON t.customer_id = c.customer_id
    GROUP BY t.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total,
    DENSE_RANK() OVER (ORDER BY total DESC) AS revenue_rank
FROM source