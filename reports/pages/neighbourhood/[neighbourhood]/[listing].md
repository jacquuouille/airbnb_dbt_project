# {params.listing.replace(/-/g, ' ').replace(/\b\w/g, c => c.toUpperCase())}

<span class="text-sm hover:underline font-semibold"><a href={listings_kpis[0].listing_url} target="_blank"> → View Listing</a></span>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

```sql listings_kpis
    select 
        m.listing_id
        , l.listing_url
        , h.host_name
        , m.occupancy_rate_pct / 100 as occupancy_rate_pct
        , m.avg_rating as score_review
        , count(distinct review_id) as num_reviews
    from 
        airbnb_data.listing_performance_metrics m
    left join
        airbnb_data.hosts h
        on m.host_id = h.host_id
    left join
        airbnb_data.reviews r
        on m.listing_id = r.listing_id
    inner join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
        and m.host_id = h.host_id
    where 
        l.listing_name = '${params.listing}' 
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
    value=score_review
    title="Score Review ★"
    fmt=num2
/>
<BigValue
    data={listings_kpis}
    value=num_reviews
    title="Reviews"
    fmt=num0
/>

``` sql listing_description 
    select 
        regexp_replace(listing_description, '<[^>]+>', ' ', 'g') as listing_description
    from 
        airbnb_data.listings
    where 
        listing_name = '${params.listing}'
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
        property_type
        , room_type
        , accommodates
        , bathrooms
        , beds
    from
        airbnb_data.listings
    where 
        listing_name = '${params.listing}'
```

<DataTable data={listing_details} />

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

```sql monthly_bookings
    select 
        m.month
        , l.listing_name
        , l.listing_longitude
        , l.listing_latitude
        , l.listing_url
        , round(listing_latitude::numeric, 4) || ', ' || round(listing_longitude::numeric, 4) || ')' as point_label
        , h.host_name
        , sum(num_nights_booked) as booked_nights
    from 
        airbnb_data.listing_monthly_metrics m
    left join 
        airbnb_data.hosts h
        on m.host_id = h.host_id
    inner join
        airbnb_data.listings l
        on m.listing_id = l.listing_id
        and m.host_id = h.host_id
    where 
        l.listing_name = '${params.listing}'
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
/>

<LineChart
    data={monthly_bookings}
    x=month
    y=booked_nights
    markers=true
    markerShape=emptyCircle
    chartAreaHeight=300
    title="Booked Nights Over Time"
/>

</Grid>

```sql listing_review_scores
   select listing_id, 'Accuracy' as category, review_scores_accuracy as score from airbnb_data.listings where listing_name = '${params.listing}'
   union all 
   select listing_id, 'Cleanliness' as category, review_scores_cleanliness as score from airbnb_data.listings where listing_name = '${params.listing}'
   union all 
   select listing_id, 'Checkin' as category, review_scores_checkin as score from airbnb_data.listings where listing_name = '${params.listing}' 
   union all 
   select listing_id, 'Communication' as category, review_scores_communication as score from airbnb_data.listings where listing_name = '${params.listing}'
   union all 
   select listing_id, 'Location' as category, review_scores_location as score from airbnb_data.listings where listing_name = '${params.listing}'
```

<BarChart
    data={listing_review_scores}
    x=category
    y=score
    swapXY=true
    chartAreaHeight=250
    labels=true
    labelFmt=num1
    title="Reviews by Category"
/>

``` sql listing_reviews
    select 
        distinct r.reviewer_name
        , r.review_date
        , r.review_comments
    from 
        airbnb_data.reviews r
    inner join
        airbnb_data.listings l
        on r.listing_id = l.listing_id
    where 
        l.listing_name = '${params.listing}'
    order by 
        2 desc, 1, 3
```

<DataTable 
    data={listing_reviews}
    title="Listings Comments"
/>

``` sql listings_host
    select 
        h.host_name
        , h.host_listings_count
        , h.host_profile_url
        , '/host/' || h.host_id as link
    from 
        airbnb_data.hosts h
    inner join 
        airbnb_data.listings l
        on h.host_id = l.host_id
    where 
        l.listing_name = '${params.listing}'
```

<DataTable data={listings_host} title="Host Details" subtitle="→ Click on the host name to explore its details, or view its profile on Airbnb." link=link>
    <Column id=host_name/>
    <Column id=host_listings_count title="Listings"/>
    <Column id=host_profile_url contentType=link linkLabel="View Profile →" title="Profile URL" />
</DataTable>