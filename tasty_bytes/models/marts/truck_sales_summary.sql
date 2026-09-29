{{ config(materialized='table') }}

select
    t.truck_id,
    t.primary_city,
    t.region,
    t.country,
    t.franchise_id,
    count(distinct oh.order_id) as total_orders,
    sum(oh.order_total) as total_sales
from {{ ref('raw_pos_truck') }} t
join {{ ref('raw_pos_order_header') }} oh
    on t.truck_id = oh.truck_id
group by t.truck_id, t.primary_city, t.region, t.country, t.franchise_id
