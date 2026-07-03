{{config(
    materialized='view',
    schema='staging'
)}}

with source as (

    select * from {{ source('airbnb_data', 'listings') }}
    
) 
    
, cleaned as (

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
        cast(case 
            when host_identity_verified is true then 'true'
            when host_identity_verified is false then 'false'
            else 'unknown'
        end as string) as host_identity_verified,
        last_scraped,
        host_profile_url
    from source
    qualify row_number() over (partition by host_id order by last_scraped desc) = 1
)

select * from cleaned
