select *
from {{ ref('listing_monthly_metrics') }}
where round(100.0 * num_booked_nights / nullif(num_available_nights, 0), 2) != pct_occupancy