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
        date_trunc(calendar_date, month) as month,
        listing_id,
        sum(is_booked) as nights_booked, 
        count(*) as total_nights,
        round(
            sum(is_booked) * 1.0 / count(*), 2
        ) as occupancy_rate
    from calendar
    group by 
        1, 2

)

select * from monthly_occupancy