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

)

, monthly_occupancy as (

    select 
        date_trunc(c.calendar_date, month) as month,
        c.listing_id,
        l.property_type,
        l.room_type,
        sum(c.is_booked) as nights_booked, 
        count(*) as total_nights,
        round(
            100.0*sum(c.is_booked) * 1.0 / count(*), 2
        ) as occupancy_rate_pct
    from calendar c
    left join {{ ref('dim_listings') }} l using (listing_id)
    group by 
        1, 2, 3, 4

)

select * from monthly_occupancy