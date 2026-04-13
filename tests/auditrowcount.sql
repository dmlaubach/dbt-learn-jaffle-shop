{% set old_relation = adapter.get_relation(
      database = "Analytics",
      schema = "dbt_dlaubach",
      identifier = "customer_orders_legacy"
) -%}

{% set dbt_relation = ref('fct_orders') %}

{{ audit_helper.quick_are_relations_identical(
    a_relation = old_relation,
    b_relation = dbt_relation,
    columns = None
) }}