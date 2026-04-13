{% set old_relation = adapter.get_relation(
      database = target.database,
      schema = "dbt_dlaubach",
      identifier = "customer_orders_legacy"
) -%}

{% set dbt_relation = ref('fct_orders') %}

{% if execute %}

  {{ audit_helper.compare_all_columns(
      a_relation = old_relation,
      b_relation = dbt_relation,
      primary_key = "order_id"
  ) }}
{% endif %}