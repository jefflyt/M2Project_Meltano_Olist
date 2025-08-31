# Marketing Analytics Business Objectives

This document outlines the key Marketing analytics objectives and recommended visualizations based on the dbt staging/warehouse schemas provided in `dbt_olist_stg` (dim_*, fact_order_items). It is designed to be directly actionable in a BI tool (e.g., Looker Studio, Tableau, Power BI).

## Primary Marketing Goals

- Grow revenue and order volume
- Improve customer acquisition and retention
- Increase average order value (AOV) and conversion on installments
- Optimize seller and product mix
- Monitor delivery experience impact on review scores

## Canonical Data Model

- Fact: `fact_order_items`
- Dimensions: `dim_date`, `dim_customer`, `dim_seller`, `dim_product`, `dim_geolocation`, `dim_payment`, `dim_orders`, `dim_order_reviews`

Join keys (typical):
- fact_order_items.order_date_sk → dim_date.date_sk
- fact_order_items.customer_sk → dim_customer.customer_sk
- fact_order_items.seller_sk → dim_seller.seller_sk
- fact_order_items.product_sk → dim_product.product_sk
- fact_order_items.customer_geography_sk → dim_geolocation.geolocation_sk
- fact_order_items.seller_geography_sk → dim_geolocation.geolocation_sk
- fact_order_items.payment_sk → dim_payment.payment_sk
- fact_order_items.review_sk → dim_order_reviews.review_sk
- fact_order_items.order_sk → dim_orders.order_sk

Note: Metrics aggregate at the order-item grain; use distinct order_id/order_sk when needed.

## Core KPIs and Definitions

- Revenue: SUM(fact_order_items.price + fact_order_items.freight_value)
- Orders: COUNT DISTINCT fact_order_items.order_id
- Items Sold: COUNT(*)
- AOV (Average Order Value): Revenue / Orders
- Average Item Price: AVG(fact_order_items.price)
- Payment Value: SUM(fact_order_items.payment_value)
- Installment Share: AVG(CASE WHEN payment_installments > 1 THEN 1 ELSE 0 END)
- Review Score (avg): AVG(fact_order_items.review_score)
- On-time Delivery Proxy: AVG(CASE WHEN dim_orders.order_delivered_customer_date <= dim_orders.order_estimated_delivery_date THEN 1 ELSE 0 END)

## Required Filters/Slicers

- Date range (dim_date)
- State/City (dim_geolocation for customer and seller)
- Product category (dim_product)
- Seller (dim_seller)
- Payment type (dim_payment)
- Order status (dim_orders)

## Dashboard 1: Growth & Revenue Overview

Purpose: Track growth, seasonality, and channel performance.

- Cards
  - Revenue (current period, prior period, delta)
  - Orders, Items, AOV
  - Avg Review Score
- Time Series
  - Revenue by month (dim_date)
  - Orders vs. AOV by month
- Breakdown
  - Revenue by customer state (map using customer_geography)
  - Revenue by product category (dim_product)
- Drilldowns
  - Top sellers by revenue
  - Top categories by revenue growth

## Dashboard 2: Acquisition & Retention

Purpose: Understand customer behavior and repeat purchasing.

- Cards
  - New Customers (count of first-order customers in period)
  - Repeat Rate (share of orders from returning customers)
  - Revenue from New vs Returning
- Cohort View
  - Monthly acquisition cohorts with repeat purchase rate over time
- Segmentation
  - AOV by state/city
  - Orders per customer by product category

Implementation notes:
- Identify first order date per customer_id using dim_orders + fact_order_items
- New customer = first order date within period; returning otherwise

## Dashboard 3: Product & Pricing

Purpose: Optimize product mix and pricing.

- Cards
  - Avg Item Price, Discount proxy (if price vs payment_value available)
- Category Deep Dive
  - Revenue & Items by product_category_name
  - Price distribution by category
- Cross-sell
  - Basket size proxy: items per order (count items / count distinct orders)

## Dashboard 4: Experience & Reviews

Purpose: Track delivery experience and its impact on reviews.

- KPIs
  - On-time delivery proxy
  - Avg review score, review distribution
- Visuals
  - Review score by product category
  - Review score by customer state/city
  - Late vs on-time delivery and average review score

Data requirements:
- Use dim_orders timestamps for delivered vs estimated
- Use dim_order_reviews.review_creation_date & review_answer_timestamp for freshness

## Dashboard 5: Payment Behavior

Purpose: Understand payment preferences and installment impacts.

- KPIs
  - Payment Value, Installment Share
  - AOV by payment type
- Visuals
  - Payment type share over time
  - Installments vs AOV and Review Score

## Data Quality & Modeling Assumptions

- Grain: order-item
- Use dim_date for all time series; avoid using raw timestamps directly
- Geolocation: use customer_geography_sk for customer-centric views; seller_geography_sk for supply view
- ZIP code: standardized to 5-digit with leading zeros in staging
- Aggregations: use SUM for monetary values, COUNT DISTINCT for orders, and AVG for scores

## Suggested Semantic Layer (optional)

- Measures
  - revenue, orders, items_sold, aov, avg_item_price, payment_value, installment_share, avg_review_score, on_time_rate
- Dimensions
  - date, year, month, quarter
  - customer_state, customer_city
  - seller_state, seller_city
  - product_category, seller_name/id
  - payment_type, order_status

## Next Steps

1. Publish these models to a BI tool with a star schema connection centered on fact_order_items.
2. Create a date spine using dim_date and set default fiscal/calendar filters.
3. Add row-level security if needed (e.g., by seller).
4. Validate metrics on a small sample and reconcile with source exports.
