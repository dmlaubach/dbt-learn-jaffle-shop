
select
    order_id,
    max(created_at) as created_at,
    payment_status, 
    sum(payment_amount) / 100.0 as payment_amount
from {{ ref('stg_stripe__payments') }}
where payment_status <> 'fail'
group by 1, 3



