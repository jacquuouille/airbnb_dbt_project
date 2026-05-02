{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ source('airbnb_data', 'calendar') }}

)

, filtered as (
    select
        listing_id,
        date as calendar_date,
        cast(
            case 
                when available is true then 'true'
                when available is false then 'false'
                else null
            end 
        as string) as is_available,
        price,
        adjusted_price,
        minimum_nights,
        maximum_nights
    from source

)

select * from filtered