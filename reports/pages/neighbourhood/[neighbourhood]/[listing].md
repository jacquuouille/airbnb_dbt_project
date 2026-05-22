# {params.listing.replace(/-/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}

```sql monthly_bookings
    select 
        distinct m.month 
        , m.occupancy_rate_pct / 100 as occupancy_rate_pct
        , l.listing_name
        , l.listing_longitude
        , l.listing_latitude
        , round(listing_latitude::numeric, 4) || ', ' || round(listing_longitude::numeric, 4) || ')' as point_label
        , h.host_name
    from 
        airbnb_data.listing_monthly_metrics m
    inner join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    left join 
        airbnb_data.hosts h
        on m.host_id = h.host_id
    where 
        l.listing_name = '${params.listing}'
    order by 
        1
```

<Grid cols=2>

<AreaChart
    data={monthly_bookings}
    x=month
    y=occupancy_rate_pct
    yMax=1
    markers=true
    markerShape=emptyCircle
    chartAreaHeight=300
    title="Occupancy Rate Over Time"
/>

<PointMap
    data={monthly_bookings}
    lat=listing_latitude
    long=listing_longitude
    pointName=point_label
    height=300
    title="Listing Location"
/>

</Grid>