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
        sum(products.price) as calculated_subtotal
    from items
    left join products on items.sku = products.sku
    group by 1
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        cast(orders.ordered_at as date) as order_date,
        stores.store_name,
        
        -- Calculated Metrics (The "Truth" from items)
        coalesce(order_item_revenue.count_items, 0) as count_items,
        coalesce(order_item_revenue.calculated_subtotal, 0) as subtotal,
        round(coalesce(order_item_revenue.calculated_subtotal, 0) * stores.tax_rate, 2) as tax_paid,
        
        -- Audit Fields (Raw values from source)
        orders.raw_subtotal,
        orders.raw_tax_paid,
        
        -- Reconciliation Columns
        (coalesce(order_item_revenue.calculated_subtotal, 0) - orders.raw_subtotal) as subtotal_variance,
        
        case 
            when (coalesce(order_item_revenue.calculated_subtotal, 0) - orders.raw_subtotal) = 0 then true 
            else false 
        end as is_subtotal_reconciled

    from orders
    left join stores on orders.store_id = stores.store_id
    left join order_item_revenue on orders.order_id = order_item_revenue.order_id
)

select * from final