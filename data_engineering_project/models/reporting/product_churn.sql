WITH product_churn AS (
    SELECT
        customer_id,
        payment_month,
        product_id,
        MAX(payment_month) OVER(PARTITION BY customer_id) AS max_payment_date_of_customer
    FROM
        {{ ref('stg_hotelbook') }}
    WHERE
        payment_month IS NOT NULL
    GROUP BY
        customer_id, payment_month, product_id
),
churned_or_not AS (
    SELECT
        customer_id,
        payment_month,
        product_id,
        (CASE
            WHEN
                payment_month IS NOT NULL
                AND
                DATEDIFF(MONTH, MAX(payment_month),max_payment_date_of_customer) > 12
            THEN 1
            ELSE 0
        END) AS churned
    FROM
        product_churn
    GROUP BY
        customer_id,
        payment_month,
        product_id,
        max_payment_date_of_customer
 
),
highest_product_churn AS (
    SELECT
        PRODUCT_ID,
        COUNT(churned) AS num_products_churned
    FROM
        churned_or_not
    WHERE
        churned = 1
    GROUP BY
        PRODUCT_ID
)
 
SELECT
    *
FROM
    highest_product_churn
ORDER BY
    num_products_churned
DESC