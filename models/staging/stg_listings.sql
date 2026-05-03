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
        minimum_nights_avg_ntm as minimum_nights,
        maximum_nights_avg_ntm as maximum_nights,
        availability_365,
        listing_url, 
        last_scraped,
        host_id
    from source

)

select * from cleaned