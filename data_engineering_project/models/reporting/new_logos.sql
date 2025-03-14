WITH newlogo AS  (
    SELECT
       customer_id,
       DATE_TRUNC('YEAR', MIN(PAYMENT_MONTH)) AS FISCAL_YEAR_START
    FROM
        {{ ref('stg_hotelbook') }}
    GROUP BY customer_id
)
SELECT
    COUNT(DISTINCT customer_id) AS customer_count,
    FISCAL_YEAR_START
FROM newlogo
GROUP BY FISCAL_YEAR_START
ORDER BY FISCAL_YEAR_START