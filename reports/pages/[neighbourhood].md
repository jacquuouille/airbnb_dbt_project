# {params.neighbourhood.replace(/-/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}

``` sql occupancy
    with bookings_all_neighbourhoods as (
        select 
            avg(pct_occupancy) as occupancy_rate_pct_all_neighbourhoods
        from 
            airbnb_data.listing_monthly_metrics
    )

    select 
        b.occupancy_rate_pct_all_neighbourhoods
        , avg(m.pct_occupancy) / 100 as occupancy_rate
        , avg(m.pct_occupancy) - (b.occupancy_rate_pct_all_neighbourhoods) as diff
    from
        airbnb_data.listing_monthly_metrics m
    inner join 
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    cross join
        bookings_all_neighbourhoods b
    where 
        lower(replace(m.listing_neighbourhood, ' ', '-')) = '${params.neighbourhood}'
    group by 
        1
```

``` sql score
    with score_reviews_all_neighbourhood as (
        select 
            round(avg(avg_rating), 1) as avg_rating_all_neighbourhoods
        from 
            airbnb_data.listing_performance_metrics
    )

    select 
        b.avg_rating_all_neighbourhoods
        , avg(m.avg_rating) as score_review
        , round(avg(m.avg_rating) - (b.avg_rating_all_neighbourhoods), 1) as diff
    from
        airbnb_data.listing_performance_metrics m
    inner join 
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    cross join
        score_reviews_all_neighbourhood b
    where 
        lower(replace(l.listing_neighbourhood, ' ', '-')) = '${params.neighbourhood}'
    group by 
        1
```

<BigValue
    data={occupancy}
    value=occupancy_rate
    title="Occupancy"
    comparison=diff
    comparisonFmt=num1
    comparisonTitle="perc. points vs. City Average"
    <Info description="perc. points: percentage points"
    fmt=pct1
/>
<BigValue
    data={score}
    value=score_review
    title="Score Review ★ (avg.)"
    <Info description="Out of 5"
    comparison=diff
    comparisonFmt=num1
    comparisonTitle="points vs. City Average"
    fmt=num1
/>

``` sql monthly_occupancy
    with bookings_all_neighbourhoods as (
        select 
            month_date
            , avg(pct_occupancy) / 100 as monthly_occupancy_rate_pct_all_neighbourhoods
        from 
            airbnb_data.listing_monthly_metrics
        group by 
            1
    )

    select 
        distinct m.month_date
        , b.monthly_occupancy_rate_pct_all_neighbourhoods
        , avg(m.pct_occupancy) / 100 as monthly_occupancy_rate_pct
    from
        airbnb_data.listing_monthly_metrics m
    inner join 
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    left join 
        bookings_all_neighbourhoods b
        on m.month_date = b.month_date
    where 
        lower(replace(m.listing_neighbourhood, ' ', '-')) = '${params.neighbourhood}'
    group by 
        1, 2
```

<LineChart
    data={monthly_occupancy}
    x=month_date
    y={['monthly_occupancy_rate_pct', 'monthly_occupancy_rate_pct_all_neighbourhoods']}
    chartAreaHeight=300
    title="Occupancy Over Time vs. Vancouver Average"
    markers=true
    markerShape=emptyCircle
    colorPalette={
        [
        '#a4b8fc' ,
        '#515151'
        ]
    }
/>

``` sql top_listing_num_nights_booked
    select 
        distinct l.listing_name
        , l.listing_url
        , '/neighbourhood/' 
        || lower(replace(l.listing_neighbourhood, ' ', '-')) 
        || '/' 
        || l.listing_id::bigint as link
        , avg(m.pct_occupancy) / 100 as occupancy_rate_pct
    from 
        airbnb_data.listing_monthly_metrics m
    inner join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
    where 
        lower(replace(l.listing_neighbourhood, ' ', '-')) = '${params.neighbourhood}'
    group by 
        1, 2, 3
    order by 
        4 desc
```

<DataTable data={top_listing_num_nights_booked} search=true title="Top Listings by Occupancy" subtitle="→ Click on a listing name to explore its details" link=link>
    <Column id=listing_name/>
    <Column id=occupancy_rate_pct title="Occupancy" contentType=colorscale colorScale={['#e6ecff', '#a4b8fc']}/>
</DataTable> 

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

## Get in Touch
<p style="font-size: 0.85rem; color: #666;">
Have questions, feedback, or just want to connect?
</p>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

- Message me on [**LinkedIn**](www.linkedin.com/in/jacques-hervochon-27448898)
- Reach me by [**Email**](mailto:jacqueshervochon@gmail.com)
- Check out my work on [**GitHub**](https://github.com/yourprofile)