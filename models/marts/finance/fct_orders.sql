WITH orders AS  (
    select * from {{ ref ('stg_jaffle_shop__orders' )}}
),

payments AS (
    select * from {{ ref ('stg_stripe__payments') }}
),

order_payments AS (
    SELECT
        order_id,
        sum (case when status = 'success' then amount end) as amount

    FROM payments
    group by 1
),

 final as (

    SELECT
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce (order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

SELECT * FROM final