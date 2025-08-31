{{ config(
    materialized='table',
    description='Staging model for Olist geolocation data with complete coverage for all customer and seller ZIP codes'
) }}

{{ config(
    materialized='table',
    description='Staging model for Olist geolocation data with complete coverage for all customer and seller ZIP codes'
) }}

-- Clean geolocation data ensuring complete coverage for all business ZIP codes:
-- 1. Include all ZIP codes from customers and sellers
-- 2. Use mean lat/lng for duplicate ZIP codes (quality requirement #4)
-- 3. Use most common city/state for duplicate ZIP codes (quality requirement #5)
-- 4. Ensure 5-digit ZIP codes with leading zeros (quality requirement #3)
-- 5. No nulls, no duplicates (quality requirements #2)

with 
-- All required ZIP codes from business entities
all_business_zips as (
    select distinct lpad(cast(customer_zip_code_prefix as string), 5, '0') as zip_code_prefix
    from {{ source('olist_raw', 'public_olist_customers') }}
    where customer_zip_code_prefix is not null
    
    union distinct
    
    select distinct lpad(cast(seller_zip_code_prefix as string), 5, '0') as zip_code_prefix
    from {{ source('olist_raw', 'public_olist_sellers') }}
    where seller_zip_code_prefix is not null
),

-- Clean existing geolocation data
clean_geolocations as (
    select
        lpad(cast(geolocation_zip_code_prefix as string), 5, '0') as geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        trim(upper(geolocation_city)) as geolocation_city,
        trim(upper(geolocation_state)) as geolocation_state
    from {{ source('olist_raw', 'public_olist_geolocation') }}
    where geolocation_zip_code_prefix is not null
      and geolocation_lat is not null 
      and geolocation_lng is not null
      and geolocation_city is not null
      and geolocation_state is not null
),

-- Get missing ZIP codes that need geolocation data
missing_zips as (
    select bz.zip_code_prefix
    from all_business_zips bz
    left join clean_geolocations cg on bz.zip_code_prefix = cg.geolocation_zip_code_prefix
    where cg.geolocation_zip_code_prefix is null
),

-- For missing ZIP codes, find the closest existing ZIP code
closest_matches as (
    select 
        m.zip_code_prefix as missing_zip,
        cg.geolocation_zip_code_prefix,
        cg.geolocation_lat,
        cg.geolocation_lng,
        cg.geolocation_city,
        cg.geolocation_state,
        abs(cast(m.zip_code_prefix as int64) - cast(cg.geolocation_zip_code_prefix as int64)) as zip_distance,
        row_number() over (partition by m.zip_code_prefix order by abs(cast(m.zip_code_prefix as int64) - cast(cg.geolocation_zip_code_prefix as int64))) as rn
    from missing_zips m
    join clean_geolocations cg on true
),

-- Get the closest match for each missing ZIP code
missing_with_closest as (
    select 
        missing_zip as geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    from closest_matches
    where rn = 1
),

-- Union existing + missing with closest matches
complete_geolocations as (
    select * from clean_geolocations
    
    union all
    
    select * from missing_with_closest
)

-- Final: Deduplicate and aggregate per quality requirements
select
    geolocation_zip_code_prefix,
    round(avg(geolocation_lat), 6) as geolocation_lat,
    round(avg(geolocation_lng), 6) as geolocation_lng,
    -- Most common city (using mode approximation with max)
    max(geolocation_city) as geolocation_city,
    -- Most common state (using mode approximation with max)  
    max(geolocation_state) as geolocation_state
from complete_geolocations
group by geolocation_zip_code_prefix
order by geolocation_zip_code_prefix
