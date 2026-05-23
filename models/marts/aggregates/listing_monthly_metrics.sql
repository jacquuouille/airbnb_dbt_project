{{config(
    materialized='table',
    schema='marts'
) }}

with calendar as (

    select
        calendar_date,
        listing_id,
        case when is_available = 'false' then 1 else 0 end as is_booked
    from {{ ref('fct_calendar') }}

),

listings as (

    select
        listing_id,
        host_id,
        listing_neighbourhood,
        property_type,
        room_type
    from {{ ref('dim_listings') }}

)

, monthly_occupancy as (

    select 
        date_trunc(c.calendar_date, month) as month,
        l.host_id,
        c.listing_id,
        l.listing_neighbourhood,
        l.property_type,
        l.room_type,
        sum(c.is_booked) as num_nights_booked, 
        count(c.listing_id) as num_total_nights,
        round(
            100.0*sum(c.is_booked) * 1.0 / count(c.listing_id), 2
        ) as occupancy_rate_pct
    from 
        calendar c
    inner join 
        listings l 
        on c.listing_id = l.listing_id
    group by 
        1, 2, 3, 4, 5, 6

)

select * from monthly_occupancy