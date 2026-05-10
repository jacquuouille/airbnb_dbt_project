select
    *
from
    {{ ref('listing_monthly_metrics') }}
where
    occupancy_rate_pct > 100