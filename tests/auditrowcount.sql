{% set old_relation = adapter.get_relation(
      database = "ANALYTICS",
      schema = "DBT_DLAUBACH",
      identifier = "CUSTOMER_ORDERS_LEGACY"
) -%}


{% set dbt_relation = adapter.get_relation(
      database = "ANALYTICS",
      schema = "DBT_DLAUBACH",
      identifier = "FCT_ORDERS"
) -%}

{{ audit_helper.compare_row_counts(
    a_relation = old_relation,
    b_relation = dbt_relation
) }}