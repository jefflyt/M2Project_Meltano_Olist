{{ config(
    materialized='table',
    description='Staging model for Olist products with data quality fixes (same columns as raw)'
) }}

-- Clean and normalize products data according to the data dictionary
-- - Standardize product category names to lowercase
-- - Keep numeric fields as-is (already properly stored as INT64)
-- Keep same columns as raw table, just cleaned

with source_data as (
    select * from {{ source('olist_raw', 'public_olist_products') }}
),

cleaned_products as (
    select
        -- Primary identifier (no changes needed)
        product_id,
        
        -- Standardize category name to lowercase
        lower(trim(product_category_name)) as product_category_name,
        
        -- Numeric fields (fix spelling for description length)
        product_name_lenght,
        product_description_lenght as product_description_length,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
        
    from source_data
)

select * from cleaned_products
