
  create or replace   view NEWDB.DESCHEMA_staging.stg_country
  
   as (
    with country as (
    select distinct
    customer_id::INTEGER as customer_id,
    country,
    region
    from newdb.deschema.country
    order by customer_id,country,region
)
select * from country
  );

