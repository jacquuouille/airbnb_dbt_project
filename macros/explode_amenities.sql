{% macro explode_amenities(source_table, amenities_column='amenities') %}

(

    select
        listing_id,
        json_value(amenity_json) as amenity
    from {{ source_table }}
    cross join unnest (json_extract_array({{ amenities_column }})) as amenity_json

)

{% endmacro %}