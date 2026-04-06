--Which states generate the most revenue?
select s.seller_state, SUM(oi.price + oi.freight_value ) as revenue
from sellers s
join order_items oi
using(seller_id)
group by s.seller_state
order by revenue desc
limit 10;

--Do higher shipping costs affect review scores?
select
case
	when oi.freight_value <= 50 then 'low'
	when oi.freight_value <= 100 then 'somewhat low'
	when oi.freight_value <= 200 then 'moderate'
	when oi.freight_value <= 300 then 'high'
	else 'very high'
end as shipping_classification,
count(*) as no_of_orders,
round(AVG(r.review_score ),2) as average_score
from order_items oi 
join reviews r 
using(order_id)
group by shipping_classification
order by average_score desc;

--Which month has the highest revenue?
select date_trunc('month', o.order_purchase_timestamp) as month, round(sum(p.payment_value/1000),0) as revenue_k
from orders o 
join payments p 
using(order_id)
group by month
order by revenue_k desc;

--Customer lifetime value
select c.customer_unique_id, round(SUM(p.payment_value),0) lifetime_value
from customers c 
join orders o
using(customer_id)
join payments p 
using(order_id)
group by c.customer_unique_id
order by lifetime_value desc

--Are repeat customers happier?
with customer_orders as (
select c.customer_unique_id, count(o.order_id) as total_orders
from customers c 
join orders o 
using(customer_id)
group by c.customer_unique_id
)
select
case
	when total_orders = 1 then 'one-time'
	else 'repeat'
end as customer_frequency,
round(AVG(r.review_score ),2) avg_review_score
from customer_orders co
join customers c 
using(customer_unique_id)
join orders o 
using(customer_id)
join reviews r 
using(order_id)
group by customer_frequency;