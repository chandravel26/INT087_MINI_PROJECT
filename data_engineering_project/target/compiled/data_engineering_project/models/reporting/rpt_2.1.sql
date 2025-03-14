WITH cross_sell_analysis AS (
    SELECT
        customer_id,
        COUNT(product_id)     AS num_products_bought,
        SUM(revenue) AS total_spent
    FROM
        NEWDB.DESCHEMA_staging.stg_hotelbook
    WHERE
        payment_month >= ADD_MONTHS(current_date, -12)
    GROUP BY
        customer_id
),
highest_cross_sell AS (
    SELECT
        customer_id,
        num_products_bought,
        total_spent,
        RANK() OVER (ORDER BY num_products_bought DESC, total_spent DESC) AS cross_sell_rank
    FROM cross_sell_analysis
)
 
SELECT
    *
FROM
    highest_cross_sell