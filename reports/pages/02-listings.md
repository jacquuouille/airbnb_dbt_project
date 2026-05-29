--- 
title : Listings
--- 

<p style="font-size: 0.85rem; color: #666;">
Explore and export Vancouver's Airbnb listings by neighbourhood. Use the filter below to select a neighbourhood and browse all active listings.
</p>

<hr style="border: none; border-top: 1px solid #ffffff; width: 50%; margin: 10px auto;"/>

```sql neighbourhoods_names
    select 
       distinct listing_neighbourhood
        , listing_name
    from
        airbnb_data.listings 
```

<Dropdown
    data={neighbourhoods_names}
    name=selected_item
    value=listing_neighbourhood
    multiple=true
    defaultValue="Arbutus Ridge"
    title="Selected Neighbourhood"
/>

```sql listing_kpis
    select 
        count(distinct listing_id) as num_listings
    from
        airbnb_data.listings
    where 
        listing_neighbourhood in ${inputs.selected_item.value}
```

<BigValue
    data={listing_kpis}
    value=num_listings
    title="Active Listings"
    fmt=num0
/>

``` sql listings_details
    select 
        l.listing_name
        , l.listing_property_type
        , l.listing_room_type
        , l.listing_url
        , '/neighbourhood/' 
        || lower(replace(l.listing_neighbourhood, ' ', '-')) 
        || '/' 
        || l.listing_id::bigint as link
        , m.avg_rating as score_review
        , count(distinct r.review_id) as num_reviews
        , avg(p.pct_occupancy) as occupancy
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
        airbnb_data.listing_monthly_metrics p
        on h.host_id = p.host_id
        and l.listing_id = p.listing_id
    left join 
        airbnb_data.reviews r
        on l.listing_id = r.listing_id
    where 
        l.listing_neighbourhood in ${inputs.selected_item.value}
    group by 
        1, 2, 3, 4, 5, 6
    order by 
        7 desc
```

<DataTable data={listings_details} title="Listings" subtitle="→ Click on a listing name to explore its details" search=true link=link rows=20>
    <Column id=listing_name/>
    <Column id=score_review title="Score" contentType=colorscale colorScale={['#e6ecff', '#a4b8fc']} fmt=num1/>
    <Column id=num_reviews contentType=bar barColor=#a4b8fc backgroundColor=#ebebeb title="Reviews" fmt=num0 />
    <Column id=occupancy contentType=colorscale colorScale={['#e6ecff', '#a4b8fc']} fmt=num1/>
    
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