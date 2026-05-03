{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ source('airbnb_data', 'listings') }}

)

, cleaned as (

    select
        cast(id as int64) as listing_id,
        review_scores_rating,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value,
        host_id
    from source

)

select * from cleaned