{{ config(materialized='table') }}

select
    l.location_id,
    l.location,
    l.city,
    l.region,
    l.country,
    count(distinct oh.order_id) as total_orders,
    sum(oh.order_total) as total_sales
from {{ ref('raw_pos_location') }} l
join {{ ref('raw_pos_order_header') }} oh
    on l.location_id = oh.location_id
group by l.location_id, l.location, l.city, l.region, l.country
