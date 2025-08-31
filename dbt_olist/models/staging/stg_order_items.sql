{{ config(
    materialized='table',
    description='Staging model for Olist order items with data quality fixes (same columns as raw)'
) }}

-- Clean and normalize order items data according to the data dictionary
-- - Fix financial precision: FLOAT64 → DECIMAL for price and freight_value
-- Keep same columns as raw table, just cleaned

with source_data as (
    select * from {{ source('olist_raw', 'public_olist_order_items') }}
),

cleaned_order_items as (
    select
        -- Primary and foreign keys (no changes needed)
        order_id,
        order_item_id,
        product_id,
        seller_id,
        
        -- Timestamp (no changes needed, already TIMESTAMP)
        shipping_limit_date,
        
        -- Fix financial precision (critical issue from data dictionary)
        -- FLOAT64 storage causes rounding errors in financial calculations
        round(cast(price as numeric), 2) as price,
        round(cast(freight_value as numeric), 2) as freight_value
        
    from source_data
)

select * from cleaned_order_items
