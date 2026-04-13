-- Import CTEs

with

customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    -- Note: We are referencing the singular version 'payment' 
    -- because that's the one with the total_amount_paid logic
    select * from {{ ref('stg_stripe__payment') }}
)

-- Logical CTE
select
    orders.order_id,
    orders.customer_id,
    orders.order_placed_at,
    orders.order_status,
    payments.payment_amount,
    payments.created_at,
    customers.customer_first_name,
    customers.customer_last_name

from orders
left join payments on orders.order_id = payments.order_id
left join customers on orders.customer_id = customers.customer_id