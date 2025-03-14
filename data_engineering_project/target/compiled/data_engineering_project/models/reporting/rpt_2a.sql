WITH cross_sell_analysis AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT( distinct h.product_id) AS num_products_bought,
        SUM(h.revenue) AS total_spent,
        avg(h.revenue) as avg_spent,
        h.payment_month,
        ADD_MONTHS(current_date, -72) as three_months_ago
    FROM
        NEWDB.DESCHEMA_staging.stg_hotelbook h JOIN
        NEWDB.DESCHEMA_staging.stg_cust c on h.customer_id = c.customer_id
    
    GROUP BY
        c.customer_id,
        c.customer_name,
        h.payment_month
),
highest_cross_sell AS (
    SELECT
        RANK() OVER (ORDER BY num_products_bought DESC, total_spent DESC) AS cross_sell_rank,
        customer_id,
        customer_name,
        num_products_bought,
        total_spent,
        payment_month,
        three_months_ago
    FROM cross_sell_analysis
    where total_spent > avg_spent
)
 
SELECT
    *
FROM
    highest_cross_sell