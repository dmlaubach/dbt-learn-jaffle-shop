
select
    order_id,
    max(created_at) as created_at,
    payment_status, 
    -- amount is stored in cents, convert it to dollars
    sum({{ cents_to_dollars("payment_amount", 0) }})  as payment_amount
from {{ ref('stg_stripe__payments') }}
where payment_status <> 'fail'
group by 1, 3



