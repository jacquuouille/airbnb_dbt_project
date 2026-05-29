select listing_id
from {{ ref('dim_listings') }}
group by 1
having count(distinct listing_neighbourhood) > 1