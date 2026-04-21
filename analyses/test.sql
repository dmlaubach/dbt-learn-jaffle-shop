select 
    order_id, 
    payment_amount, 
    order_status,
    customer_id
from {{ ref('int_orders') }}
where payment_amount <= 0