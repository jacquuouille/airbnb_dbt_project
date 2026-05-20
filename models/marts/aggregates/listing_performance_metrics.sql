{{ config(
    materialized='table',
    schema='marts'
) }}

with calendar as (
    select * from {{ ref('fct_calendar') }}
),

listings as (
    select * from {{ ref('dim_listings') }}
),

reviews as (
    select * from {{ ref('dim_reviews') }}
),

base as (
    select
        c.listing_id,
        l.host_id,
        round(
            100.0 * (sum(case when c.is_available = 'false' then 1 else 0 end) / count(c.listing_id)), 2
        ) as occupancy_rate_pct,
        count(distinct r.review_id) as num_reviews,
        max(l.review_scores_rating)            as avg_rating,
        max(l.review_scores_accuracy)          as avg_accuracy,
        max(l.review_scores_cleanliness)       as avg_cleanliness,
        max(l.review_scores_checkin)           as avg_checkin,
        max(l.review_scores_communication)     as avg_communication,
        max(l.review_scores_location)          as avg_location
    from calendar c
    join listings l on c.listing_id = l.listing_id
    join reviews r on c.listing_id = r.listing_id
    group by 1, 2
)

select * from base