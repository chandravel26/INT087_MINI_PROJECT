with country as (
    select distinct
    customer_id::INTEGER as customer_id,
    country,
    region
    from {{ source('raw_schema_name','country')}}
    order by customer_id,country,region
)
select * from country