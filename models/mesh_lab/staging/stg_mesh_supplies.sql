select
    id as supply_id,
    sku,
    name as supply_name,
    cost,
    perishable
from {{ source('jaffle_shop_mesh', 'supplies') }}