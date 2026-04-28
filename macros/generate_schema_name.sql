{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if custom_schema_name is none -%}

        {{ default_schema }}

    {#- IF WE ARE IN PROD, WE JUST WANT CUSTOM_SCHEMA_NAME -#}
    {%- elif env_var('DBT_ENV_NAME') in ['prod'] -%}

        {{ custom_schema_name | trim }}

    {%- else -%}

        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- endif -%}

{%- endmacro %}

{#- This is a meaningless comment for testing -#}