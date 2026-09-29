{% snapshot snapshot_customer_loyalty %}

{{
    config(
        target_schema='snapshots',
        unique_key='customer_id',
        strategy='check',
        check_cols=['city', 'country', 'postal_code', 'preferred_language', 'favourite_brand', 'marital_status', 'children_count', 'e_mail', 'phone_number']
    )
}}

select
    customer_id,
    first_name,
    last_name,
    city,
    country,
    postal_code,
    preferred_language,
    gender,
    favourite_brand,
    marital_status,
    children_count,
    sign_up_date,
    birthday_date,
    e_mail,
    phone_number
from {{ ref('raw_customer_customer_loyalty') }}

{% endsnapshot %}
