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
  amount_totals AS (
    SELECT order_id,
           SUM(amount) AS order_amount
      FROM payments
     GROUP BY 1
    ),
  final AS (
    SELECT orders.order_id,
           customer_id,
           order_amount,
           order_date,
           status
      FROM orders
             LEFT JOIN amount_totals
                 ON orders.order_id = amount_totals.order_id
  )

SELECT * FROM final
