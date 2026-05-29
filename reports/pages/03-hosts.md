--- 
title: Hosts
--- 

<p style="font-size: 0.85rem; color: #666;">
Explore Vancouver's Airbnb hosts by neighbourhood. Use the filter below to select a neighbourhood and browse all active hosts — including their listings count, occupancy, and review scores.
</p>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

```sql host_location
    select 
       distinct host_location 
    from
        airbnb_data.hosts 
```

<Dropdown
    data={host_location}
    name=selected_item
    value=host_location
    multiple=true
    defaultValue="Burnaby, Canada"
    title="Selected Host Location"
/>

``` sql host_listings_count
    select 
        count(distinct host_id) as num_host
    from 
        airbnb_data.hosts
    where
        host_location in ${inputs.selected_item.value}
```

```sql hosts_with_multiple_listings
    with 
    host_listings_count as ( 
        select 
            host_listings_count
            , count(distinct host_id) as num_host
        from
            airbnb_data.hosts
        where 
            host_location in ${inputs.selected_item.value}
        group by 
            1
    )
    
    select 
        sum(case when host_listings_count > 1 then num_host end) 
        , sum(num_host)
        , sum(case when host_listings_count > 1 then num_host end) / sum(num_host) as host_multiple_listings
    from 
        host_listings_count
```

<BigValue
    data={host_listings_count}
    value=num_host
    title="Active Hosts"
    fmt=num0
/>
<BigValue
    data={hosts_with_multiple_listings}
    value=host_multiple_listings
    title="Share of Hosts with Multiple Listings"
    fmt=pct1
/>

``` sql hosts_details
    select 
        h.host_name
        , h.host_listings_count
        , '/host/' || h.host_id as link
        , avg(avg_rating) as score
        , count(distinct r.review_id) as num_reviews
    from 
        airbnb_data.hosts h
    inner join 
        airbnb_data.listing_performance_metrics m
        on h.host_id = m.host_id
    inner join 
        airbnb_data.reviews r
        on m.listing_id = r.listing_id
    where 
        h.host_location in ${inputs.selected_item.value}
    group by
        1, 2, 3
    order by 
        2 desc, 3 desc, 1
```

<DataTable data={hosts_details} title="Hosts" subtitle="→ Click on a listing name to explore its details" search=true link=link rows=20>
    <Column id=host_name/> 
    <Column id=host_listings_count title="Listings"/>
    <Column id=num_reviews title="Reviews" fmt=num0 contentType=bar barColor=#a4b8fc backgroundColor=#ebebeb/>
    <Column id=score title="Score" fmt=num1 contentType=colorscale colorScale={['#e6ecff', '#a4b8fc']}/>
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