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
                when available = 't' then 'true'
                when available = 'f' then 'false'
                else 'unknown'
            end 
        as string) as is_available,
        price,
        adjusted_price,
        minimum_nights,
        maximum_nights
    from source

)

select * from filtered