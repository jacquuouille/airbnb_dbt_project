{{config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ ref('stg_listings') }} as listings

),

neighbourhoods as (

    select * from {{ ref('vancouver_neighborhoods') }}

), 

final as ( 
    select 
        s.listing_id,
        s.listing_name,
        s.listing_description,
        s.neighborhood,
        n.latitude,
        n.longitude,
        s.property_type,
        s.room_type,
        s.accommodates,
        s.bathrooms,
        s.bedrooms,
        s.beds,
        s.amenities,
        s.minimum_nights,
        s.maximum_nights,
        s.availability_365,
        s.review_scores_rating,
        s.review_scores_accuracy,
        s.review_scores_cleanliness,
        s.review_scores_checkin,
        s.review_scores_communication,
        s.review_scores_location,
        s.review_scores_value,
        s.listing_url, 
        s.last_scraped,
        s.host_id
    from source s
    left join neighbourhoods n on s.neighborhood = n.neighborhood
)

select * from final