{{ config(
    materialized='table',
    description='Staging model for Olist orders with cleaned timestamps and status (same columns as raw)'
) }}

-- Clean and normalize orders data according to the data dictionary
-- - Cast string timestamp fields to TIMESTAMP using SAFE_CAST
-- - Normalize status values to lowercase
-- Keep same columns as raw table, just cleaned

with source_data as (
    select * from {{ source('olist_raw', 'public_olist_orders') }}
),

cleaned_orders as (
    select
        order_id,
        customer_id,

        -- Normalize status to lowercase
        lower(trim(order_status)) as order_status,

        -- Cast timestamps safely (handle empty strings as NULL)
        safe_cast(NULLIF(trim(cast(order_purchase_timestamp as string)), '') as timestamp) as order_purchase_timestamp,
        safe_cast(NULLIF(trim(cast(order_approved_at as string)), '') as timestamp) as order_approved_at,
        safe_cast(NULLIF(trim(cast(order_delivered_carrier_date as string)), '') as timestamp) as order_delivered_carrier_date,
        safe_cast(NULLIF(trim(cast(order_delivered_customer_date as string)), '') as timestamp) as order_delivered_customer_date,
        safe_cast(NULLIF(trim(cast(order_estimated_delivery_date as string)), '') as timestamp) as order_estimated_delivery_date

    from source_data
)

select * from cleaned_orders
