WITH
  source AS (
    SELECT * FROM {{ source('shop', 'orders') }}
  )

SELECT id AS order_id,
       user_id AS customer_id,
       order_date,
       status
  FROM source
