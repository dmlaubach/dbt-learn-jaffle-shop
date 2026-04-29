select
    id as order_id,
    customer as customer_id,
    ordered_at,
    order_total,
    store_id
from {{ source('jaffle_shop_mesh', 'orders') }}