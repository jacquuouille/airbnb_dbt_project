{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ source('airbnb_data', 'listings') }}

)

, cleaned as (

    select
        id as listing_id,
        name as listing_name,
        description as listing_description,
        neighbourhood_cleansed as neighbourhood,
        latitude,
        longitude,
        property_type,
        room_type,
        accommodates,
        bathrooms,
        bedrooms,
        beds,
        amenities,
        cast(minimum_nights_avg_ntm as integer) as minimum_nights,
        cast(maximum_nights_avg_ntm as integer) as maximum_nights,
        availability_365,
        review_scores_rating,
        review_scores_accuracy,
        review_scores_cleanliness,
        review_scores_checkin,
        review_scores_communication,
        review_scores_location,
        review_scores_value,
        listing_url, 
        last_scraped,
        host_id
    from source

)

select * from cleaned