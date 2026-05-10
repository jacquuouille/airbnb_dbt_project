select 
    *
from 
    {{ ref('listing_monthly_metrics') }}
where 
    num_nights_booked = 0 and occupancy_rate_pct > 0