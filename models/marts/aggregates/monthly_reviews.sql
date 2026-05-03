{{config(
    materialized='table',
    schema='marts'
) }}

with filtered as (

    select 
        date_trunc(review_date, month) as review_month,
        count(*) as review_count
    from {{ ref('dim_reviews') }}
    where review_date is not null
    group by 1
)

select * from filtered