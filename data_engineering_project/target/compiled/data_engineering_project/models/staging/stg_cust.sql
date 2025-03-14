with customer as (
    select distinct
    customer_id::INTEGER as customer_id,
    customername::VARCHAR as customer_name,
    company::VARCHAR as company_name,
    from newdb.deschema.cust
    where customer_id is not null
    order by customer_id
)
select * from customer