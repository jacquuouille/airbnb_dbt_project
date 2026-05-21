# {params.neighbourhood.replace(/-/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}

``` sql monthly_bookings
    with bookings_all_neighbourhoods as (
        select 
            month 
            , sum(num_nights_booked) / count(distinct listing_neighbourhood) as avg_bookings_all_neighbourhoods
        from 
            airbnb_data.listing_monthly_metrics
        group by 
            1
    )

    select 
        m.month 
        , b.avg_bookings_all_neighbourhoods
        , sum(m.num_nights_booked) as bookings
    from 
        airbnb_data.listing_monthly_metrics m
    inner join 
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    left join 
        bookings_all_neighbourhoods b
        on m.month = b.month
    where 
        lower(replace(m.listing_neighbourhood, ' ', '-')) = '${params.neighbourhood}'
    group by 
        1, 2
```

<LineChart
    data={monthly_bookings}
    x=month
    y={['bookings', 'avg_bookings_all_neighbourhoods']}
    chartAreaHeight=300
    title="Bookings Over Time"
    markers=true
    markerShape=emptyCircle
    colorPalette={
        [
        '#000000' ,
        '#8b8b8b'
        ]
    }
/>

``` sql top_listing_num_nights_booked
    select 
        l.listing_name
        , l.listing_url
        , '/neighbourhood/' || lower(replace(l.listing_neighbourhood, ' ', '-')) 
    || '/' || l.listing_name as link
        , m.occupancy_rate_pct / 100 as occupancy_rate_pct
    from 
        airbnb_data.listing_performance_metrics m
    inner join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    where 
        lower(replace(l.listing_neighbourhood, ' ', '-')) = '${params.neighbourhood}'
    order by 
        4 desc
```

<DataTable data={top_listing_num_nights_booked} search=true title="Top Listings by Occupancy" subtitle="→ click on a listing name to explore its details, or view the listing on the Airbnb." link=link>
    <Column id=listing_name/>
    <Column id=listing_url contentType=link linkLabel="View Listing →"/>
    <Column id=occupancy_rate_pct contentType=colorscale/>
</DataTable> 