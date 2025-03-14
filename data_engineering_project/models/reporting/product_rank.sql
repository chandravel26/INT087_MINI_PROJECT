WITH product_revenue AS (
    SELECT
        t.product_id,
        SUM(t.revenue) AS total_revenue,
        p.product_family,
        p.product_sub_family
    FROM {{ ref('stg_hotelbook') }} t
    JOIN {{ ref('stg_prod') }} p
        ON t.product_id = p.product_id
    GROUP BY t.product_id, p.product_family, p.product_sub_family
)
SELECT
    product_id,
    total_revenue,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    product_family,
    product_sub_family
FROM product_revenue