{{config(
    materialized='table',
    schema='marts'
) }}

with base as (

    select 
    c.listing_id, 
    round(
        sum(case when c.is_available = 'false' then 1 else 0 end) * 1.0 / count(*), 2
    ) as occupancy_rate,
    avg(l.review_scores_rating) as avg_rating,
    avg(l.review_scores_accuracy) as avg_accuracy,
    avg(l.review_scores_cleanliness) as avg_cleanliness,
    avg(l.review_scores_checkin) as avg_checkin,
    avg(l.review_scores_communication) as avg_communication,
    avg(l.review_scores_location) as avg_location,
    avg(l.review_scores_value) as avg_value
    from 
        {{ ref('fct_calendar') }} c
    join 
        {{ ref('dim_listings') }} l on c.listing_id = l.listing_id
    group by 1

)

select * from base