select
    *
from
    {{ ref('listing_monthly_metrics') }}
where
    pct_occupancy > 100