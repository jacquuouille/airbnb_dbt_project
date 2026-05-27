select 
    *
from 
    {{ ref('listing_monthly_metrics') }}
where 
    num_booked_nights = 0 and pct_occupancy > 0