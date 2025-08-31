{{ config(
    materialized='table',
    description='Staging model for Olist sellers with data quality fixes (same columns as raw)'
) }}

-- Clean and normalize sellers data according to the data dictionary
-- - Fix ZIP code data loss: restore leading zeros (INT64 → STRING)
-- - Standardize city and state to uppercase
-- Keep same columns as raw table, just cleaned

with source_data as (
    select * from {{ source('olist_raw', 'public_olist_sellers') }}
),

cleaned_sellers as (
    select
        -- Primary identifier (no changes needed)
        seller_id,
        
        -- Fix ZIP code data loss (critical issue from data dictionary)
        -- ZIP codes stored as INT64 lose leading zeros (e.g., 01302 becomes 1302)
        case 
            when seller_zip_code_prefix is not null 
            then lpad(cast(seller_zip_code_prefix as string), 5, '0')
            else null
        end as seller_zip_code_prefix,
        
        -- Geographic information - standardize to uppercase
        trim(upper(seller_city)) as seller_city,
        trim(upper(seller_state)) as seller_state
        
    from source_data
)

select * from cleaned_sellers
