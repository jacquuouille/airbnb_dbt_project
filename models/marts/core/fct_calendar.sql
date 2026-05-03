{{config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ ref('stg_calendar') }} as calendar

)

, cleaned as (

    select 
        *,
        coalesce(adjusted_price, price) as actual_price
    from source

)

select * from cleaned