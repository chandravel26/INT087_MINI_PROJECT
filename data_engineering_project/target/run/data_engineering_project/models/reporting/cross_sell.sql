
  create or replace   view NEWDB.DESCHEMA_reporting.cross_sell
  
   as (
    WITH cross_sell_analysis AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT( distinct h.product_id) AS num_products_bought
    FROM
        NEWDB.DESCHEMA_staging.stg_hotelbook h JOIN
        NEWDB.DESCHEMA_staging.stg_cust c on h.customer_id = c.customer_id
    
    WHERE h.revenue_type=1
    
    GROUP BY
        c.customer_id,
        c.customer_name 
        )
 
SELECT
    *
FROM
   cross_sell_analysis
ORDER BY
    num_products_bought desc
LIMIT 10
  );

