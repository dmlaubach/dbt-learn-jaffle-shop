{{ audit_helper.compare_row_counts(
    a_relation = ref('customer_orders_legacy'),
    b_relation = ref('fct_orders')
) }}