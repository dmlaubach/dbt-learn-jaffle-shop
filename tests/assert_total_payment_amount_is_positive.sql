select
    order_id,
    payment_amount as total_amount
from {{ ref('int_orders') }}
where total_amount <= 0