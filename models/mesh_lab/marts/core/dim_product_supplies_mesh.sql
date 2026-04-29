with products as (
    select * from {{ ref('stg_mesh_products') }}
),

supplies as (
    select * from {{ ref('stg_mesh_supplies') }}
),

final as (
    select
        products.sku,
        products.product_name,
        products.product_type,
        supplies.supply_id,
        supplies.supply_name,
        supplies.cost as supply_cost,
        supplies.perishable
    from products
    left join supplies on products.sku = supplies.sku
)

select * from final