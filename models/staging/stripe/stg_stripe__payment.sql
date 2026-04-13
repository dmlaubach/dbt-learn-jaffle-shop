
select
    orderid as order_id,
    max(created) as created_at,
    status as payment_status, 
    sum(amount) / 100.0 as payment_amount
from {{ source('stripe', 'payment') }}
where status <> 'fail'
group by 1, 3



