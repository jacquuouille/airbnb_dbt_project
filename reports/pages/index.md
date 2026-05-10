---
title: Overview
---

<Details title='About this data'>
  This page can be found in your project at `/pages/index.md`. Make a change to the markdown file and save it to see the change take effect in your browser.
</Details>


``` sql kpis 
    select 
        count(distinct p.host_id) as num_hosts
        , count(distinct p.listing_id) as num_listings
        , avg(p.avg_rating) as avg_ratings 
        , avg(m.occupancy_rate_pct) as avg_accurancy
    from 
        airbnb_data.listing_performance_metrics p
    join 
        airbnb_data.listing_monthly_metrics m
        on p.listing_id = m.listing_id
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
        airbnb_data.monthly_occupancy
```

<Dropdown data={properties} name=property_type value=property_type>
    <DropdownOption value="%" valueLabel="All Properties"/>
</Dropdown> 

``` sql monthly_occupancy
    select 
        month
        , room_type
        , sum(nights_booked) as num_bookings
        , avg(occupancy_rate_pct) as avg_occupancy_rate
    from 
        airbnb_data.monthly_occupancy
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
        listing_id
        , avg(ooccupancy_rate)
```


## What's Next?
- [Connect your data sources](settings)
- Edit/add markdown files in the `pages` folder
- Deploy your project with [Evidence Cloud](https://evidence.dev/cloud)

## Get Support
- Message us on [Slack](https://slack.evidence.dev/)
- Read the [Docs](https://docs.evidence.dev/)
- Open an issue on [Github](https://github.com/evidence-dev/evidence)
