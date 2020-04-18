WITH
  source AS (
    SELECT * FROM {{ source('shop', 'customers') }}
  )

SELECT id as customer_id,
       first_name,
       last_name
  FROM source
