---
title: Neighbourhood
order: 2
---

```sql test 
select
    *
from airbnb_data.listing_monthly_metrics 
where listing_neighbourhood = '${$page.url.searchParams.get("neighbourhood")}' 
```