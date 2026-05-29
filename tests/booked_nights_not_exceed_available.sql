select *
from {{ ref('listing_monthly_metrics') }}
where num_booked_nights > num_available_nights