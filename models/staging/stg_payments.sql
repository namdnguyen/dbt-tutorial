WITH
  source AS (
    SELECT * FROM {{ source('shop', 'payments') }}
  )

SELECT id AS payment_id,
       order_id,
       payment_method,
       amount
  FROM source
