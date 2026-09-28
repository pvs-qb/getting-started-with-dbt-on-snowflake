{{
    config(
        materialized='incremental',
        unique_key='order_detail_id',
        incremental_strategy='merge',
        on_schema_change='sync_all_columns'
    )
}}

select
    od.order_detail_id,
    od.order_id,
    od.menu_item_id,
    od.line_number,
    od.quantity,
    od.unit_price,
    od.price,
    od.order_item_discount_amount,
    oh.order_ts
from {{ ref('raw_pos_order_detail') }} od
join {{ ref('raw_pos_order_header') }} oh
    on od.order_id = oh.order_id

{% if is_incremental() %}
where oh.order_ts > (select max(order_ts) from {{ this }})
{% endif %}
