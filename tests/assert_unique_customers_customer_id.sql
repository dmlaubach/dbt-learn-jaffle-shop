select
    customer_id,
    count(*) as row_count
from {{ ref('dim_customers') }}
group by 1
having row_count > 1