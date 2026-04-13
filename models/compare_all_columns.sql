{% set old_relation = adapter.get_relation(
      database = "ANALYTICS",
      schema = "DBT_DLAUBACH",
      identifier = "customer_orders_legacy"
) -%}

{% set dbt_relation = ref('fct_orders') %}

{{ audit_helper.compare_all_columns(
    a_relation = old_relation,
    b_relation = dbt_relation,
    primary_key = "order_id"
) }}