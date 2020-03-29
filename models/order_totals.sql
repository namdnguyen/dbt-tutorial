{{
  config(
    materialized='table'
  )
}}

with
  orders as (
    select * from {{ ref('stg_orders') }}
  ),
  payments as (
    select * from {{ ref('stg_payments') }}
  ),
  final as (
    select
      order_id,
      payment_id,
      amount,
      order_date,
      status
    from orders
    left join payments using (order_id)
  )
select * from final
