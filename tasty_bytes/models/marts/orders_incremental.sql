{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge',
        on_schema_change='sync_all_columns'
    )
}}

select
    order_id,
    truck_id,
    location_id,
    customer_id,
    order_channel,
    order_ts,
    served_ts,
    order_currency,
    order_amount,
    order_tax_amount,
    order_discount_amount,
    order_total
from {{ ref('raw_pos_order_header') }}

{% if is_incremental() %}
where order_ts > (select max(order_ts) from {{ this }})
{% endif %}
