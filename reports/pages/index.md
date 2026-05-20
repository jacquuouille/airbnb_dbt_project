---
title: Overview
---

<p style="font-size: 0.85rem; color: #666;">
Explore Vancouver's Airbnb market using <a href="https://insideairbnb.com" target="_blank" style="font-style: italic; color: #666;">InsideAirbnb.com</a> data. Analyze occupancy rates, amenities, and review trends across neighbourhoods, room types and property categories, with interactive neighbourhood filter to slice and explore the data your way.
</p> 

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

```sql neighbourhoods_names
    select 
        listing_neighbourhood
    from
        airbnb_data.listings
    group by 
        1
```

<Dropdown
    data={neighbourhoods_names}
    name=selected_item
    multiple=true
    value=listing_neighbourhood
    selectAllByDefault=true
    title="Selected Neighbourhood"
/>

``` sql main_kpis 
    select 
        count(distinct m.host_id) as num_hosts
        , count(distinct m.listing_id) as num_listings
        , avg(m.avg_rating) as avg_ratings 
        , avg(m.occupancy_rate_pct)/100 as avg_accurancy
    from 
        airbnb_data.listing_performance_metrics m
    inner join 
        airbnb_data.listings l 
        on m.listing_id = l.listing_id
    where 
        l.listing_neighbourhood in ${inputs.selected_item.value}
```

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 3px auto;"/>

## Highlights 
<Note> Key figures from Vancouver's short-term rental market for the selected neighbourhoods. </Note>

<BigValue
    data={main_kpis}
    value=num_listings
    title="All Listings"
    fmt=num0
/>
<BigValue
    data={main_kpis}
    value=num_hosts
    title="Listed Hosts"
    fmt=num0
/>
<BigValue
    data={main_kpis}
    value=avg_accurancy
    title="Occupancy Rate (avg.)"
    fmt=pct1
/>
<BigValue
    data={main_kpis}
    value=avg_ratings
    title="Listing Ratings (avg.)" 
    <Info description="Out of 5"
    fmt=num1
/>

<hr style="border: none; border-top: 1px solid #ffffff; width: 80%; margin: 15px auto;"/>

## Occupancy
<Note> Analyze occupancy trends over time and break them down across key dimensions. </Note>

``` sql monthly_occupancy
    select 
        month
        , avg(m.occupancy_rate_pct) / 100 as occupancy_rate_pct
    from 
        airbnb_data.listing_monthly_metrics m
    inner join 
        airbnb_data.listings l 
        on m.listing_id = l.listing_id
    where 
        l.listing_neighbourhood in ${inputs.selected_item.value}
    group by 
        1
    order by 
        1 desc
```

<AreaChart
    data={monthly_occupancy}
    x=month
    y=occupancy_rate_pct
    yMin=0
    yMax=0.8
    title="Occupancy Over Time"
    chartAreaHeight=250
/>

#### Occupancy Breakdown (top 10)
<Note> Click on as many dimension values as you want to filter the charts below.</Note>

``` sql dimension_grid
    select
        l.listing_neighbourhood
        , l.property_type
        , l.room_type 
        , l.listing_name
        , m.occupancy_rate_pct
    from 
        listing_performance_metrics m
    inner join 
        listings l 
        on m.listing_id = l.listing_id
    where 
        l.listing_neighbourhood in ${inputs.selected_item.value}
```

<DimensionGrid
    data={dimension_grid}
    metric='avg(occupancy_rate_pct)'
    name=multi_dimensions
    multiple
/>

<hr style="border: none; border-top: 1px solid #ffffff; width: 80%; margin: 15px auto;"/>

## Listings
<Note>See where and how listings are distributed across Vancouver.</Note>

``` sql listing_location
    select 
        m.listing_neighbourhood
        , l.neighbourhood_latitude
        , l.neighbourhood_longitude
        , count(distinct m.listing_id) as num_listings
    from 
        airbnb_data.listing_monthly_metrics m
    left join 
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    where 
        m.listing_neighbourhood in ${inputs.selected_item.value} 
    group by 
        1, 2, 3
```

<BubbleMap
        data={listing_location}
        lat=neighbourhood_latitude
        long=neighbourhood_longitude
        size=num_listings
        sizeFmt=num0
        value=num_listings
        pointName=listing_neighbourhood
        maxSize=40
        height=300
        title="Listings by Neighbourhood"
    />

``` sql listings_by_room
    select 
        room_type as name
        , count(distinct listing_id) as value
    from 
        airbnb_data.listings
    where 
        listing_neighbourhood in ${inputs.selected_item.value}
    group by 
        1
```

``` sql listing_by_room_property 
    select 
        room_type 
        , property_type
        , count(distinct listing_id) as num_listings
    from 
         airbnb_data.listings
    where 
        listing_neighbourhood in ${inputs.selected_item.value}
    group by 
        1, 2
    order by 
        3 desc
```

<Grid cols=2>
    <ECharts config={
    {
        title: {
            text: 'Listings by Room Type',
            left: 'left'
        },
        tooltip: {
            formatter: '{b}: {c} ({d}%)'
        },
        series: [
            {
                type: 'pie',
                radius: ['80%', '70%'],
                data: [...listings_by_room],
            }
        ]
    }
}
/>

<DataTable data={listing_by_room_property} title="Listings by Property Type">
    <Column id=property_type />
    <Column id=num_listings title="Listings" contentType=bar barColor=#aecfaf/> 
</DataTable>

</Grid>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 3px auto;"/>

## Reviews 
<Note> Key figures from Vancouver's short-term rental market for the selected neighbourhoods (all-time guest reviews). </Note>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 3px auto;"/>

``` sql reviews_kpis
    select 
        median(num_reviews) as median_reviews
        , count(distinct case when avg_rating < 4 then listing_id end) / count(distinct listing_id) as prop_listing_under_4
    from
        airbnb_data.listing_performance_metrics
```

<BigValue
    data={reviews_kpis}
    value=median_reviews
    title="Reviews per Listing (median)"
    fmt=num0
/>
<BigValue
    data={reviews_kpis}
    value=prop_listing_under_4
    title="Share of Listings with Score < 4"
    fmt=pct0
/>

``` sql score_distribution
    select 
        round(avg_rating, 1) as score
        , count(distinct listing_id) as num_listings
    from
        airbnb_data.listing_performance_metrics
    where 
        avg_rating <= 5 and score >= 4
    group by 
        1
    order by 
        1
```

<BarChart
    data={score_distribution}
    x=score
    y=num_listings
    xFmt=num1
    title="Listing Score Distribution"
    echartsOptions={{
        xAxis: {
            min: 4.0,
            max: 5.0
        },
        series: [{
            barWidth: '70%'
        }]
    }}
/>

## What's Next?
- [Connect your data sources](settings)
- Edit/add markdown files in the `pages` folder
- Deploy your project with [Evidence Cloud](https://evidence.dev/cloud)

## Get Support
- Message us on [Slack](https://slack.evidence.dev/)
- Read the [Docs](https://docs.evidence.dev/)
- Open an issue on [Github](https://github.com/evidence-dev/evidence)
