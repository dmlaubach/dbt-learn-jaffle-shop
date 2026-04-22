select 
    order_id, 
    count(*) as row_count
from {{ ref('fct_orders') }}
group by 1
having count(*) > 1