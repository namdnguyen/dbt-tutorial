{{
  config(
    materialized='table'
  )
}}

WITH
  orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
  ),
  payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
  ),
  final AS (
    SELECT orders.order_id,
           customer_id,
           payment_id,
           amount,
           order_date,
           status
      FROM orders
             LEFT JOIN payments
                 ON orders.order_id = payments.order_id
  )

SELECT * FROM final
