{{config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ source('airbnb_data', 'reviews') }}

)   

, cleaned as (

    select 
        listing_id
        , id as review_id
        , date as review_date
        , reviewer_id
        , reviewer_name
        , comments as review_comments
    from source

)

select * from cleaned