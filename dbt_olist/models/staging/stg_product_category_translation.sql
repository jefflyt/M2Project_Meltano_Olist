{{ config(
    materialized='table',
    description='Staging model for Olist product category translation (same columns as raw)'
) }}

-- Clean and normalize product category translation data
-- - Standardize category names to lowercase
-- Keep same columns as raw table, just cleaned

with source_data as (
    select * from {{ source('olist_raw', 'public_product_category_name_translation') }}
),

cleaned_translations as (
    select
        -- Standardize category names to lowercase for consistency
        lower(trim(product_category_name)) as product_category_name,
        lower(trim(product_category_name_english)) as product_category_name_english
        
    from source_data
)

select * from cleaned_translations
