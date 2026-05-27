---
title: Overview
---

<p style="font-size: 0.85rem; color: #666;">
Explore Vancouver's Airbnb market using <a href="https://insideairbnb.com" target="_blank" class="hover:underline" style="font-style: italic; color: #666;">InsideAirbnb.com</a> data. Analyze occupancy rates, amenities, and review trends across neighbourhoods, room types and property categories, with interactive neighbourhood filter to slice and explore the data your way.
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
        , avg(p.avg_rating) as avg_ratings 
        , avg(m.pct_occupancy)/100 as avg_accurancy
    from 
        airbnb_data.listing_monthly_metrics m
    inner join 
        airbnb_data.listing_performance_metrics p
        on m.listing_id = p.listing_id 
        and m.host_id = p.host_id
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
    title="Occupancy (avg.)"
    fmt=pct1
/>
<BigValue
    data={main_kpis}
    value=avg_ratings
    title="Score Rating ★ (avg.)" 
    <Info description="Out of 5"
    fmt=num1
/>

<hr style="border: none; border-top: 1px solid #ffffff; width: 80%; margin: 15px auto;"/>

## Occupancy
<Note> Analyze occupancy trends over time and break them down across key dimensions. </Note>

``` sql monthly_occupancy
    select 
        month_date
        , avg(m.pct_occupancy) / 100 as occupancy_rate_pct
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
    x=month_date
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
        , l.listing_property_type
        , l.listing_room_type 
        , l.listing_name
        , avg(m.pct_occupancy) as avg_pct_occupancy
    from 
        airbnb_data.listing_monthly_metrics m
    inner join 
        airbnb_data.listings l 
        on m.listing_id = l.listing_id
    where 
        l.listing_neighbourhood in ${inputs.selected_item.value}
    group by 
        1, 2, 3, 4
```

<DimensionGrid
    data={dimension_grid}
    metric='avg(avg_pct_occupancy)'
    name=multi_dimensions
    multiple
/>

<hr style="border: none; border-top: 1px solid #ffffff; width: 80%; margin: 15px auto;"/>

## Review Score
<Note> Key figures from Vancouver's short-term rental market for the selected neighbourhoods (all-time guest reviews). </Note>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 3px auto;"/>

``` sql reviews_kpis
    select 
        median(m.num_reviews) as median_reviews
        , count(distinct case when m.avg_rating < 4 then m.listing_id end) / count(distinct m.listing_id) as prop_listing_under_4
    from
        airbnb_data.listing_performance_metrics m
    inner join 
        airbnb_data.listings l 
        on m.listing_id = l.listing_id
    where 
        l.listing_neighbourhood in ${inputs.selected_item.value}
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
    title="Share of Listings with Score Rating < 4"
    fmt=pct0
/>

``` sql score_distribution
    select 
        distinct score
        , sum(num_listings) over(partition by score) / sum(num_listings) over() as num_listing_prop
    from ( 
        select 
            round(m.avg_rating, 1) as score
            , count(distinct m.listing_id) as num_listings
        from
            airbnb_data.listing_performance_metrics m
        inner join 
            airbnb_data.listings l 
            on m.listing_id = l.listing_id
        where 
            l.listing_neighbourhood in ${inputs.selected_item.value} 
            --and m.avg_rating <= 5 and m.avg_rating >= 4
        group by 
            1
    ) a
    order by 
        1
```

<BarChart
    data={score_distribution}
    x=score
    y=num_listing_prop
    xFmt=num1
    yFmt=pct1
    chartAreaHeight=210
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

## Listings
<Note>See where and how listings are distributed across Vancouver.</Note>

``` sql num_listings_host
    with listings as (
        select 
            m.host_id
            , count(distinct m.listing_id) as num_listings
        from 
            airbnb_data.listing_performance_metrics m
        inner join 
            airbnb_data.listings l 
            on m.listing_id = l.listing_id
        where 
            l.listing_neighbourhood in ${inputs.selected_item.value} 
        group by 
            1
    )

    select 
        count(distinct case when num_listings > 1 then host_id end) / count(distinct host_id) as prop
    from 
        listings
```

<BigValue
    data={num_listings_host}
    value=prop
    title="Share of Hosts with Multiple Listings"
    fmt=pct1
/>

``` sql listing_location
    select 
        m.listing_neighbourhood
        , l.neighbourhood_latitude
        , l.neighbourhood_longitude
        , lower(replace(m.listing_neighbourhood, ' ', '-')) as link
        , count(distinct m.listing_id) as listings
    from 
        airbnb_data.listing_monthly_metrics m
    left join 
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    where 
        m.listing_neighbourhood in ${inputs.selected_item.value} 
    group by 
        1, 2, 3, 4
```

#### Listings Location 

<BubbleMap
    data={listing_location}
    lat=neighbourhood_latitude
    long=neighbourhood_longitude
    size=listings
    sizeFmt=num0
    value=listings
    pointName=listing_neighbourhood
    height=350
    maxSize=50
    tooltip={[
        {id: 'listing_neighbourhood', fmt:'id', showColumnName:false, valueClass: 'text-lg font-semibold'},
        {id: 'listings', fmt: 'num0', fieldClass: 'text-[grey]', valueClass: 'text-[black]'},
        {id: 'link', showColumnName: false, contentType: 'link', linkLabel: 'Click to explore', valueClass: 'font-bold mt-1'}
        ]}
    link=link
/>

``` sql listings_by_room
    select 
        listing_room_type as name
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
        listing_room_type 
        , listing_property_type
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
                radius: ['73%', '65%'],
                data: [...listings_by_room],
            }
        ]
    }
}
/>

<DataTable data={listing_by_room_property} title="Listings by Property Type">
    <Column id=listing_property_type />
    <Column id=num_listings title="Listings" contentType=bar barColor=#aecfaf/> 
</DataTable>

</Grid>

## Get in Touch
<p style="font-size: 0.85rem; color: #666;">
Have questions, feedback, or just want to connect?
</p>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

- Message me on [**LinkedIn**](www.linkedin.com/in/jacques-hervochon-27448898)
- Reach me by [**Email**](mailto:jacqueshervochon@gmail.com)
- Check out my work on [**GitHub**](https://github.com/yourprofile)
