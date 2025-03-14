
  create or replace   view NEWDB.DESCHEMA_staging.stg_hotelbook
  
   as (
    with hotelbook as (
    select distinct
    customer_id,
    product_id,
    payment_month,
    revenue_type,
    revenue,
    quantity,
    companies as company,
    dimension_1,
    dimension_2,
    dimension_3,
    dimension_4,
    dimension_5,
    dimension_6,
    dimension_7,
    dimension_8,
    dimension_9,
    dimension_10
    from newdb.deschema.hotelbook
    where customer_id is not null
    order by customer_id,payment_month,revenue 
)
select * from hotelbook
  );

