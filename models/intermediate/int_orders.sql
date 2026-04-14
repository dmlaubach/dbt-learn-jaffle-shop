with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

order_values as (
    select
        order_id,
        payment_amount -- This must match the name in stg_stripe__payment
    from {{ ref('int_payments_grouped_by_order') }}
)

select
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    orders.order_status,
    order_values.payment_amount
    
from orders
left join order_values on orders.order_id = order_values.order_id