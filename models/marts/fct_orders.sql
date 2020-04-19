{{
  config(
    materialized='table'
  )
}}

{%- set payment_methods = dbt_utils.get_column_values(
    table=ref('stg_payments'),
    column='payment_method'
) -%}

WITH
  orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
  ),
  payments AS (
    SELECT * FROM {{ ref('stg_payments') }}
  ),
  amount_totals AS (
    SELECT order_id,
           {%- for payment_method in payment_methods -%}
           SUM(CASE WHEN payment_method = '{{payment_method}}' THEN amount END) AS {{payment_method}}_amount,
           {% endfor -%}
           SUM(amount) AS total_amount
      FROM payments
     GROUP BY 1
    ),
  final AS (
    SELECT orders.order_id,
           customer_id,
           order_date,
           status,
           {%- for payment_method in payment_methods -%}
           {{payment_method}}_amount,
           {% endfor -%}
           total_amount
      FROM orders
             LEFT JOIN amount_totals
                 ON orders.order_id = amount_totals.order_id
  )

SELECT *
  FROM final
 ORDER BY order_id
