with amenities as (

    {{ explode_amenities(ref('stg_listings')) }}

)

, calendar as (

    select 
        listing_id,
        round(
            sum(case when is_available = 'false' then 1 else 0 end) / count(*), 2
        ) as occupancy_rate
    from {{ ref('fct_calendar') }}
    group by 1

)

, joined as (

    select 
        c.listing_id, 
        c.occupancy_rate,
        a.amenity
    from amenities a
    join calendar c on a.listing_id = c.listing_id

)

select
    amenity,
    round(
        avg(occupancy_rate), 2
    ) as occupancy_rate
from joined
group by amenity
order by occupancy_rate desc