---
title: Overview
---

<Details title='About this data'>
  This page can be found in your project at `/pages/index.md`. Make a change to the markdown file and save it to see the change take effect in your browser.
</Details>


``` sql kpis 
    select 
        count(distinct host_id) as num_hosts
        , count(distinct listing_id) as num_listings
        , avg(avg_rating) as avg_ratings 
        , avg(occupancy_rate_pct)/100 as avg_accurancy
    from 
        airbnb_data.listing_performance_metrics
```

<BigValue
    data={kpis}
    value=num_hosts
    fmt=num0
/>
<BigValue
    data={kpis}
    value=num_listings
    fmt=num0
/>
<BigValue
    data={kpis}
    value=avg_accurancy
    fmt=pct1
/>
<BigValue
    data={kpis}
    value=avg_ratings
    fmt=num1
/>


```sql properties
   select
        distinct property_type
   from 
        airbnb_data.listing_monthly_metrics
```

<Dropdown data={properties} name=property_type value=property_type>
    <DropdownOption value="%" valueLabel="All Properties"/>
</Dropdown> 

``` sql monthly_occupancy
    select 
        month
        , room_type
        , sum(num_nights_booked) as num_bookings
        , avg(occupancy_rate_pct) as avg_occupancy_rate
    from 
        airbnb_data.listing_monthly_metrics
    where 
        property_type like '${inputs.property_type.value}'
    group by 
        1, 2
    order by 
        1, 2
```
<BarChart
    data={monthly_occupancy}
    x=month
    y=num_bookings
    series=room_type
/>

``` sql occupancy_rating_loc
    select
        distinct m.listing_id
        , l.neighbourhood
        , l.latitude
        , l.longitude
        , m.occupancy_rate_pct/100 as occ_rate_pct
    from
        airbnb_data.listing_performance_metrics m
    left join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
```

<PointMap
    data={occupancy_rating_loc} 
    lat=latitude
    long=longitude 
    pointName=neighbourhood
    value=occ_rate_pct
    height=200
/>

## What's Next?
- [Connect your data sources](settings)
- Edit/add markdown files in the `pages` folder
- Deploy your project with [Evidence Cloud](https://evidence.dev/cloud)

## Get Support
- Message us on [Slack](https://slack.evidence.dev/)
- Read the [Docs](https://docs.evidence.dev/)
- Open an issue on [Github](https://github.com/evidence-dev/evidence)
