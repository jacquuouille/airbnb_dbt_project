{{config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from  {{ ref('stg_reviews') }} as reviews

)

select 
    review_id,
    listing_id,
    reviewer_id,
    reviewer_name,
    review_date,
    review_comments
from source