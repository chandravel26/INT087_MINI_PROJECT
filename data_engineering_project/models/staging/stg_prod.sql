
with product as (
    select distinct *
    from {{ source('raw_schema_name','prod')}}
    where product_id is not null
    order by product_id
)
select * from product