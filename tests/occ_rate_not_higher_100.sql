select *
from {{ ref('agg_listing_monthly_metrics') }}
where pct_occupancy > 100