
  create or replace   view NEWDB.DESCHEMA_staging.stg_prod
  
   as (
    with product as (
    select distinct *
    from newdb.deschema.prod
    where product_id is not null
    order by product_id
)
select * from product
  );

