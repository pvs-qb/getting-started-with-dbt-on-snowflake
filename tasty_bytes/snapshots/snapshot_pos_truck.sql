{% snapshot snapshot_pos_truck %}

{{
    config(
        target_schema='snapshots',
        unique_key='truck_id',
        strategy='check',
        check_cols=['franchise_id', 'primary_city', 'region', 'country', 'ev_flag', 'truck_opening_date']
    )
}}

select
    truck_id,
    menu_type_id,
    primary_city,
    region,
    country,
    franchise_id,
    franchise_flag,
    ev_flag,
    truck_opening_date,
    make,
    model
from {{ ref('raw_pos_truck') }}

{% endsnapshot %}
