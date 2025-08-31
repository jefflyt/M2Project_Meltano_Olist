{{ config(
    materialized='table',
    description='Staging model for Olist customers data with data quality fixes (same columns as raw)'
) }}

-- Clean and normalize customers data according to the data dictionary
-- - Fix ZIP code data loss: restore leading zeros
-- - Standardize city and state to uppercase
-- Keep same columns as raw table, just cleaned

with source_data as (
    select * from {{ source('olist_raw', 'public_olist_customers') }}
),

cleaned_customers as (
    select
        -- Primary identifiers (no changes needed)
        customer_id,
        customer_unique_id,
        
        -- Fix ZIP code data loss (critical issue from data dictionary)
        -- ZIP codes stored as INT64 lose leading zeros (e.g., 01409 becomes 1409)
        case 
            when customer_zip_code_prefix is not null 
            then lpad(cast(customer_zip_code_prefix as string), 5, '0')
            else null
        end as customer_zip_code_prefix,

        -- Geographic information - standardize to uppercase
        trim(upper(customer_city)) as customer_city,
        trim(upper(customer_state)) as customer_state

    from source_data
)

select * from cleaned_customers
