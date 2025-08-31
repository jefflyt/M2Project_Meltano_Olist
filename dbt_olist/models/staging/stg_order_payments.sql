{{ config(
    materialized='table',
    description='Staging model for Olist order payments with data quality fixes (same columns as raw)'
) }}

-- Clean and normalize order payments data according to the data dictionary
-- - Fix financial precision: FLOAT64 → DECIMAL for payment_value
-- - Normalize payment_type to lowercase
-- Keep same columns as raw table, just cleaned

with source_data as (
    select * from {{ source('olist_raw', 'public_olist_order_payments') }}
),

cleaned_order_payments as (
    select
        -- Primary and foreign keys (no changes needed)
        order_id,
        payment_sequential,
        
        -- Normalize payment type to lowercase
        lower(trim(payment_type)) as payment_type,
        
        -- No changes needed for installments
        payment_installments,
        
        -- Fix financial precision (critical issue from data dictionary)
        -- FLOAT64 storage causes rounding errors in financial calculations
        round(cast(payment_value as numeric), 2) as payment_value
        
    from source_data
)

select * from cleaned_order_payments
