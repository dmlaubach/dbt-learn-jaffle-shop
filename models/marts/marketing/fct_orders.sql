{{
    config(
        materialized='incremental',
        unique_key = 'order_id',
        incremental_strategy = 'merge'
    )
}}

with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('int_payments_grouped_by_order') }}
),

customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date
    from orders
    group by 1
),

order_payments as (
    select
        order_id,
        max(created_at) as payment_finalized_date, 
        sum(case when payment_status != 'fail' then payment_amount else 0 end) as total_amount_paid
    from payments
    group by 1
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date as order_placed_at,
        orders.status as order_status,
        customers.first_name as customer_first_name,
        customers.last_name as customer_last_name,
        order_payments.payment_finalized_date,
        coalesce(order_payments.total_amount_paid, 0) as total_amount_paid,
        row_number() over (order by orders.order_id) as transaction_seq,
        row_number() over (partition by orders.customer_id order by orders.order_id) as customer_sales_seq,

        -- CHANGED: Now pulling from the correct local CTE
        case 
            when customer_orders.first_order_date = orders.order_date then 'new' 
            else 'return' 
        end as nvsr,

        customer_orders.first_order_date as fdos,

        sum(coalesce(order_payments.total_amount_paid, 0)) over (
            partition by orders.customer_id 
            order by orders.order_date, orders.order_id
            rows between unbounded preceding and current row
        ) as customer_lifetime_value

    from orders
    left join order_payments using (order_id)
    left join customers using (customer_id)
    left join customer_orders using (customer_id)
)

select * from final

{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where order_placed_at >= (select max(order_placed_at) from {{ this }}) 
{% endif %}


-- this is a meaningless comment for dev to qa deployment testing 29/04/2026