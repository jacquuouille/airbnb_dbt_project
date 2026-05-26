--- 
title: Hosts
order: 3
--- 

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
    title="Selected Host Location"
/>

```sql hosts_kpis
    select 
        count(distinct host_id) as num_hosts
    from
        airbnb_data.hosts
    where 
        host_location = '${inputs.selected_item.value}'
```

<BigValue
    data={hosts_kpis}
    value=num_hosts
    title="All Hosts"
    fmt=num0
/>

``` sql hosts_details
    select 
        host_name
    from 
        airbnb_data.hosts
    where 
        host_location = '${inputs.selected_item.value}'
```

<DataTable data={hosts_details} title="Hosts" subtitle="→ Click on a listing name to explore its details" search=true link=link rows=20>
    <Column id=host_name/> 
    
</DataTable> 