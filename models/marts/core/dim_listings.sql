{{config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ ref('stg_listings') }} as listings

)

select 
    listing_id,
    listing_name,
    listing_description,
    neighbourhood,
    latitude,
    longitude,
    property_type,
    room_type,
    accommodates,
    bathrooms,
    bedrooms,
    beds,
    amenities,
    minimum_nights,
    maximum_nights,
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