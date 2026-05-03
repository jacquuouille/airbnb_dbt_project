{{config(
    materialized='view',
    schema='staging'
) }}

with source as (

    select * from  {{ref('stg_hosts') }} as hosts

)

select 
    host_id,
    host_name,
    hosts_time_as_user_years,
    hosts_time_as_user_months,
    hosts_time_as_host_years,
    hosts_time_as_host_months,
    host_location,
    host_about,
    host_listings_count,
    host_identity_verified,
    last_scraped,
    host_profile_url
from source