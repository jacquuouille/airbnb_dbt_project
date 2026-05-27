{{ config(
    materialized='table',
    schema='marts'
) }}

with listings as (
    select * from {{ ref('dim_listings') }}
),

reviews as (
    select * from {{ ref('dim_reviews') }}
),

base as (
    select
        l.listing_id,
        l.host_id,
        count(distinct r.review_id) as num_reviews,
        max(l.review_scores_rating)            as avg_rating,
        max(l.review_scores_accuracy)          as avg_accuracy,
        max(l.review_scores_cleanliness)       as avg_cleanliness,
        max(l.review_scores_checkin)           as avg_checkin,
        max(l.review_scores_communication)     as avg_communication,
        max(l.review_scores_location)          as avg_location
    from listings l
    join reviews r on l.listing_id = r.listing_id
    group by 1, 2
)

select * from base