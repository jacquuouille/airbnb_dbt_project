# {host_details_kpis[0].host_name}

<span class="text-sm hover:underline font-semibold"><a href={host_details_kpis[0].host_profile_url} target="_blank"> → View Profile</a></span>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

```sql host_details_kpis 
    select 
        h.host_id
        , h.host_name
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
        , m.avg_rating as score_review
        , count(distinct r.review_id) as num_reviews
    from 
        airbnb_data.hosts h
    inner join 
        airbnb_data.listings l
        on h.host_id = l.host_id
    inner join 
        airbnb_data.reviews r
        on l.listing_id = r.listing_id
    left join 
        airbnb_data.listing_performance_metrics m
        on h.host_id = m.host_id
    where 
        h.host_id::text = '${params.host_name}'
    group by 
        1, 2, 3, 4, 5, 6, 7
```

<BigValue
    data={host_details_kpis}
    value=host_listings_count
    title="Listings"
    fmt=num0
/>
<BigValue
    data={host_details_kpis}
    value=num_reviews
    title="Reviews"
    fmt=num0
/>
<BigValue
    data={host_details_kpis}
    value=score_review
    title="Score Review ★"
    fmt=num2
/>
<BigValue
    data={host_details_kpis}
    value=hosts_time
    title={host_details_kpis[0].hosts_time_label}
    fmt=num0
/>

``` sql host_description 
    select 
        case when host_about != '' then regexp_replace(host_about, '<[^>]+>', ' ', 'g') else '-' end as host_description
    from 
        airbnb_data.hosts
    where 
        host_id::text = '${params.host_name}'
```

### Host Description
<span class="text-sm">
    <Value 
        data={host_description} 
        column=host_description 
    />
</span>

``` sql host_details
    select 
        host_location
        , case 
            when host_identity_verified = 'false' then 'Not verified ❌' 
            when host_identity_verified = 'true' then 'Verified ✅' 
            else '-'
            end 
        as identity
   from 
        airbnb_data.hosts
    where 
        host_id::text = '${params.host_name}'
```

<DataTable data={host_details} />

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

``` sql hosts_listings_details
    select 
        l.listing_name
        , l.listing_property_type
        , l.listing_room_type
        , l.listing_url
        , '/neighbourhood/' || lower(replace(l.listing_neighbourhood, ' ', '-')) 
    || '/' || l.listing_name as link
        , m.avg_rating as score_review
        , count(distinct r.review_id) as num_reviews
    from 
        airbnb_data.listings l
    inner join 
        airbnb_data.hosts h
        on l.host_id = h.host_id
    left join 
        airbnb_data.listing_performance_metrics m
        on h.host_id = m.host_id
        and l.listing_id = m.listing_id
    left join 
        airbnb_data.reviews r
        on l.listing_id = r.listing_id
    where 
        h.host_id::text = '${params.host_name}' 
    group by 
        1, 2, 3, 4, 5, 6
    order by 
        7 desc
```

<DataTable data={hosts_listings_details} title="Host's Listings" subtitle="→ Click on a listing name to explore its details" search=true link=link>
    <Column id=listing_name/>
    <Column id=listing_room_type/>
    <Column id=num_reviews contentType=bar backgroundColor=#ebebeb title="Reviews" fmt=num0/>
    <Column id=score_review contentType=colorscale fmt=num1/>
    
</DataTable> 

``` sql hosts_listings
    select 
        distinct l.listing_name 
        , l.listing_neighbourhood
        , l.listing_latitude
        , l.listing_longitude
        , l.listing_property_type
        , l.listing_room_type
    from 
        airbnb_data.listings l
    inner join 
        airbnb_data.hosts h
        on l.host_id = h.host_id
    where 
        h.host_id::text = '${params.host_name}'
```

<PointMap
    data={hosts_listings}
    lat=listing_latitude
    long=listing_longitude
    pointName=listing_name
    height=300
    title="Host's Listings Location"
    link=listing_url
/> 