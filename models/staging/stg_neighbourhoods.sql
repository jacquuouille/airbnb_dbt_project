{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ ref('neighborhood_coordinates') }}

), 

cleaned as (

    select
        neighborhood as neighbourhood,
        latitude as neighbourhood_latitude,
        longitude as neighbourhood_longitude
    from source

)

select * from cleaned