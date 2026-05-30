# Data Analytics Engineering Project: dbt, BigQuery & Evidence

This project aims to build an **end-to-end analytics pipeline**, from data transformation to data visualisation. Data is sourced from [Inside Airbnb](https://insideairbnb.com/get-the-data/)

### 1. Project Overview

The project implements a modern data pipeline using BigQuery, dbt and Evidence:
- Load raw data into **BigQuery**
- Transform data into analytics-ready table using **dbt**
- Visualize data in **Evidence** through interactive dashboard

![Schema](screenshots/schema.png)

### 2. Project Structure

```
my_project/
│
├── macros/             # Explode amenities into one row per amenity
├── models/
│   ├── staging/        # Cleaned raw data, contracted staging tables
│   ├── intermediate/   # Processed data for transformation
│   └── marts/          # Business-ready tables (Dim/facts models)
├── seeds/              # Dummy CSV (neighbourhood coordinates (latitude and longitude))
├── tests/              # Business logic tests
├── profiles.yml
└── README.md

Generate and serve documentation locally:

bash
dbt deps
dbt docs generate
dbt docs serve
```

### 3. Dbt Testing

- 3.1. Generic tests: to **validate business rules**

- ```unique```
- ```not_null```
- ```relationships```
- ```accepted_values```
- ```dbt_utils.accepted_range```

```
- name: listing_monthly_metrics
    description: "Aggregated monthly occupancy metrics by listing."
    columns:
      - name: month_date
        description: "Calendar date truncated to the month level."
        tests:
          - not_null
   - name: num_available_nights
         description: "Total number of night"
         tests:
            - dbt_utils.accepted_range:
               arguments:
                  min_value: 0
                  max_value: 31
```

- 3.2. Singular tests: to **validate business logic**

```
select *
from {{ ref('listing_monthly_metrics') }}
where num_booked_nights = 0 and pct_occupancy > 0
```

- 3.3. Grain integrity tests: to **detect duplicates**

```
tests:
      - dbt_utils.unique_combination_of_columns:
          arguments:
            combination_of_columns: ['month_date', 'host_id', 'listing_id']
```

### 4. Continous Integration

To ensure data quality and prevent broken transformations from being merged, the project includes a GitHub Actions CI pipeline that automatically validates dbt changes on every pull request and push to the main branch.

The workflow performs the following steps:
- Checks out the repository code.
- Sets up a Python environment.
- Installs dbt and the BigQuery adapter.
- Authenticates securely to BigQuery using a GitHub Secret containing a service account key.
- Generates the dbt profile used during execution.
- Installs project dependencies (dbt deps).
- Validates the connection to BigQuery (dbt debug).
- Executes dbt build

This creates an automated quality gate that ensures:
- SQL models compile successfully.
- BigQuery credentials and connectivity are valid.
- Data quality tests pass.
- Changes do not introduce breaking transformations.

If any model or test fails, the GitHub Action fails and the pull request is flagged before being merged.