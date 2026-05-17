with listings as (

    select * from {{ ref('stg_listings') }}

), 

neighbourhoods as (

    select * from {{ ref('stg_neighbourhoods') }}

),

joined as (
    select 
        l.listing_id,
        l.listing_name,
        l.listing_description,
        l.listing_neighbourhood,
        n.neighbourhood_latitude,
        n.neighbourhood_longitude,
        l.property_type,
        l.room_type,
        l.accommodates,
        l.bathrooms,
        l.bedrooms,
        l.beds,
        l.amenities,
        l.minimum_nights,
        l.maximum_nights,
        l.availability_365,
        l.review_scores_rating,
        l.review_scores_accuracy,
        l.review_scores_cleanliness,
        l.review_scores_checkin,
        l.review_scores_communication,
        l.review_scores_location,
        l.review_scores_value,
        l.listing_url, 
        l.last_scraped,
        l.host_id
    from listings l
    left join neighbourhoods n on l.listing_neighbourhood = n.neighbourhood
)

select * from joined