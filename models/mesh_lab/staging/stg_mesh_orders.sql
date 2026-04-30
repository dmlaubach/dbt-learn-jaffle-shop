select
    id as order_id,
    customer as customer_id,
    ordered_at,
    store_id,
    subtotal as raw_subtotal, 
    tax_paid as raw_tax_paid,
    order_total as raw_order_total
from {{ source('jaffle_shop_mesh', 'orders') }}