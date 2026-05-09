---
title: Overview
---

<Details title='How to edit this page'>

  This page can be found in your project at `/pages/index.md`. Make a change to the markdown file and save it to see the change take effect in your browser.
</Details>


``` sql kpis 
    select 
        count(distinct host_id) as num_hosts
        , count(distinct listing_id) as num_listings
        , avg(avg_rating) as avg_ratings 
        , avg(occupancy_rate) as avg_accurancy
    from 
        airbnb_data.listing_metrics
```

``` sql monthly_occupancy
    select 
        month
        , sum(nights_booked) as num_bookings
        , avg(occupancy_rate_pct) as avg_occupancy_rate
    from 
        airbnb_data.monthly_occupancy
    group by 
        1
    order by 
        1
```

<BigValue
    data={kpis}
    value=num_hosts
    fmt=num0
/>
<BigValue
    data={kpis}
    value=num_listings
    fmt=num0
/>
<BigValue
    data={kpis}
    value=avg_accurancy
    fmt=pct1
/>
<BigValue
    data={kpis}
    value=avg_ratings
    fmt=num1
/>

<BarChart
    data={monthly_occupancy}
    x=month
    y=num_bookings
/>



```sql categories
  select
      category
  from needful_things.orders
  group by category
```

<Dropdown data={categories} name=category value=category>
    <DropdownOption value="%" valueLabel="All Categories"/>
</Dropdown>

<Dropdown name=year>
    <DropdownOption value=% valueLabel="All Years"/>
    <DropdownOption value=2019/>
    <DropdownOption value=2020/>
    <DropdownOption value=2021/>
</Dropdown>

```sql orders_by_category
  select 
      date_trunc('month', order_datetime) as month,
      sum(sales) as sales_usd,
      category
  from needful_things.orders
  where category like '${inputs.category.value}'
  and date_part('year', order_datetime) like '${inputs.year.value}'
  group by all
  order by sales_usd desc
```

<BarChart
    data={orders_by_category}
    title="Sales by Month, {inputs.category.label}"
    x=month
    y=sales_usd
    series=category
/>

## What's Next?
- [Connect your data sources](settings)
- Edit/add markdown files in the `pages` folder
- Deploy your project with [Evidence Cloud](https://evidence.dev/cloud)

## Get Support
- Message us on [Slack](https://slack.evidence.dev/)
- Read the [Docs](https://docs.evidence.dev/)
- Open an issue on [Github](https://github.com/evidence-dev/evidence)
