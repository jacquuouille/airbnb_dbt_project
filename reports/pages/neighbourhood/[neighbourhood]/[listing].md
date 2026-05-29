# {listings_kpis[0].listing_name}

<span class="text-sm hover:underline font-semibold"><a href={listings_kpis[0].listing_url} target="_blank"> → View Listing</a></span>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

<Alert status="warning">
    ⚠️ Reviews may have been written before our analysis period starts.
</Alert>

```sql listings_kpis
    select 
        l.listing_id
        , l.listing_name
        , l.listing_url
        , h.host_name
        , p.avg_rating as score_review
        , coalesce(avg(m.pct_occupancy) / 100, 0) as occupancy_rate_pct
        , count(distinct review_id) as num_reviews
    from 
        airbnb_data.listing_monthly_metrics m
    left join 
        airbnb_data.listing_performance_metrics p
        on m.listing_id = p.listing_id
    left join
        airbnb_data.hosts h
        on m.host_id = h.host_id
    left join
        airbnb_data.reviews r
        on m.listing_id = r.listing_id
    left join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
        and m.host_id = h.host_id
    where  
        l.listing_id = '${params.listing}'::bigint
    group by 
        1, 2, 3, 4, 5
```

<BigValue
    data={listings_kpis}
    value=occupancy_rate_pct
    title="Occupancy"
    fmt=pct1
/>
<BigValue
    data={listings_kpis}
    value=num_reviews
    title="Reviews"
    fmt=num0
/>
<BigValue
    data={listings_kpis}
    value=score_review
    title="Score Review ★"
    fmt=num2
/>

``` sql listing_description 
    select 
        listing_id
        , regexp_replace(listing_description, '<[^>]+>', ' ', 'g') as listing_description
    from 
        airbnb_data.listings
    where 
        listing_id = '${params.listing}'::bigint
```

### Listing Description
<span class="text-sm">
    <Value 
        data={listing_description} 
        column=listing_description 
    />
</span>

``` sql listing_details
    select 
        listing_property_type
        , listing_room_type
        , accommodates
        , bathrooms
        , beds
    from
        airbnb_data.listings
    where 
        listing_id = '${params.listing}'::bigint
```

<DataTable data={listing_details} />

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

```sql monthly_bookings
    select 
        m.month_date
        , l.listing_name
        , l.listing_longitude
        , l.listing_latitude
        , l.listing_url
        , round(listing_latitude::numeric, 4) || ', ' || round(listing_longitude::numeric, 4) || ')' as point_label
        , h.host_name
        , sum(m.num_booked_nights) as booked_nights
    from 
        airbnb_data.listing_monthly_metrics m
    left join 
        airbnb_data.hosts h
        on m.host_id = h.host_id
    left join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
        and m.host_id = h.host_id
    where 
        l.listing_id = '${params.listing}'::bigint
    group by 
        1, 2, 3, 4, 5, 6, 7
    order by 
        1
```

<Grid cols=2>

<PointMap
    data={monthly_bookings}
    lat=listing_latitude
    long=listing_longitude
    pointName=point_label
    height=300
    title="Listing Location"
    link=listing_url
    color=#a4b8fc
/>

<LineChart
    data={monthly_bookings}
    x=month_date
    y=booked_nights
    markers=true
    markerShape=emptyCircle
    chartAreaHeight=300
    title="Booked Nights Over Time"
    lineColor=#a4b8fc
/>

</Grid>

```sql listing_review_scores
   select listing_id, 'Accuracy' as category, review_scores_accuracy as score from airbnb_data.listings where listing_id = '${params.listing}'::bigint
   union all 
   select listing_id, 'Cleanliness' as category, review_scores_cleanliness as score from airbnb_data.listings where listing_id = '${params.listing}'
   union all 
   select listing_id, 'Checkin' as category, review_scores_checkin as score from airbnb_data.listings where listing_id = '${params.listing}'
   union all 
   select listing_id, 'Communication' as category, review_scores_communication as score from airbnb_data.listings where listing_id = '${params.listing}'
   union all 
   select listing_id, 'Location' as category, review_scores_location as score from airbnb_data.listings where listing_id = '${params.listing}'
```

<Alert status="info">
    ℹ️ Charts below may appear blank for listings with no reviews.
</Alert>

<BarChart
    data={listing_review_scores}
    x=category
    y=score
    swapXY=true
    chartAreaHeight=250
    labels=true
    labelFmt=num1
    title="Reviews by Category"
    fillColor=#a4b8fc
/>

``` sql listing_reviews
    select 
        distinct r.reviewer_name
        , case when r.review_date is null then null else r.review_date end as review_date
        , r.review_comments
    from 
        airbnb_data.listings l 
    left join
        airbnb_data.reviews r
        on r.listing_id = l.listing_id
    where 
        l.listing_id = '${params.listing}'
    order by 
        2 desc, 1, 3
```

<DataTable 
    data={listing_reviews}
    title="Listings Comments"
/>

```sql listings_host 
    select 
        h.host_id
        , h.host_name
        , '/host/' || h.host_id as link
        , case
            when h.hosts_time_as_host_years = 0 then h.hosts_time_as_host_months 
            else h.hosts_time_as_host_years 
            end 
        as hosts_time
        , case 
            when h.hosts_time_as_host_years = 0 then 'Months Hosting' 
            else 'Years Hosting' 
            end 
        as hosts_time_label
        , h.host_profile_url
        , h.host_listings_count
    from 
        airbnb_data.hosts h
    left join 
        airbnb_data.listings l
        on h.host_id = l.host_id
    where 
        l.listing_id = '${params.listing}'
```

<DataTable data={listings_host} title="Host Details" subtitle="→ Click on the host name to explore its details, or view its profile on Airbnb." link=link>
    <Column id=host_name/>
    <Column id=host_listings_count title="Listings"/>
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