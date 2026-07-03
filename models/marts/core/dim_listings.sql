{{config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from {{ ref('int_listings_enriched') }} as listings

)

select * from source