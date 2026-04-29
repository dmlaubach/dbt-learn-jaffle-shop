with orders as (
    select * from {{ ref('stg_mesh_orders') }}
),

items as (
    select * from {{ ref('stg_mesh_items') }}
),

products as (
    select * from {{ ref('stg_mesh_products') }}
),

stores as (
    select * from {{ ref('stg_mesh_stores') }}
),

order_item_revenue as (
    select
        items.order_id,
        count(items.item_id) as count_items,
        sum(products.price) as subtotal
    from items
    left join products on items.sku = products.sku
    group by 1
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.ordered_at,
        stores.store_name,
        orders.status,
        coalesce(order_item_revenue.count_items, 0) as count_items,
        coalesce(order_item_revenue.subtotal, 0) as subtotal,
        round(coalesce(order_item_revenue.subtotal, 0) * stores.tax_rate, 2) as tax_paid
    from orders
    left join stores on orders.store_id = stores.store_id
    left join order_item_revenue on orders.order_id = order_item_revenue.order_id
)

select * from final