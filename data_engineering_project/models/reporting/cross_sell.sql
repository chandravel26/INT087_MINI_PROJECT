WITH crosssell AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT( distinct h.product_id) AS counts
    FROM
        {{ref('stg_hotelbook')}} h JOIN
        {{ref('stg_cust')}} c on h.customer_id = c.customer_id
    
    WHERE h.revenue_type=1
    
    GROUP BY
        c.customer_id,
        c.customer_name 
        )
 
SELECT
    *
FROM
   crosssell
ORDER BY
    counts desc
LIMIT 10
 





