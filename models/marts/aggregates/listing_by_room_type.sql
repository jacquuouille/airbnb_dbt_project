{{config(
    materialized='table',
    schema='marts'
) }}

with base as (

    select
        room_type,
        neighbourhood,
        count(*) as listing_count
    from {{ ref('dim_listings') }}
    group by 
        1, 2

)

select * from base