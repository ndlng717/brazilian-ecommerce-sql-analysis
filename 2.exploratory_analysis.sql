select distinct product_category_name
from public.products;

select *
from products
where product_category_name like '%beleza%';

--Orders by Order Status
select order_status, count(*) as total_orders
from public.orders
group by order_status
having count(*) > 1000
order by total_orders desc;

--Revenue by Order Status
select o.order_status, SUM(p.payment_value ) revenues
from orders o
join payments p 
using(order_id)
group by o.order_status 
order by revenues desc;

--Average Delivery Time
select avg(order_delivered_customer_date - order_purchase_timestamp) avg_delivery_time
from orders o
where o.order_delivered_customer_date is not null;

--Orders by Year
select extract(year from order_delivered_customer_date) as year, count(*) as no_of_orders
from orders o
where order_delivered_customer_date is not null
group by year
order by year;

--Sales by Order ID
with product_sales as(
select product_id , count(*) as total_sales
from order_items oi 
group by product_id 
)
select *
from product_sales
order by total_sales desc
limit 10;

--Revenue by Seller
select seller_id, sum(price) as revenue, rank() over(order by sum(price) desc) as seller_rank
from public.order_items
group by seller_id 
order by seller_rank 
limit 10;

--Running Revenue by Date
select order_purchase_timestamp::date as day, sum(payment_value) as revenues,
sum(sum(payment_value)) over(order by order_purchase_timestamp::date rows between unbounded preceding and current row)as running_total
from orders o
join payments p
using(order_id)
group by day
order by day;

--Delivery Delay Impact on Review Score
select
case
	when o.order_delivered_customer_date > o.order_estimated_delivery_date
	then 'late'
else 'on time'
end as delivery_status,
count(*) as no_of_orders,
round(avg(r.review_score),2) as avg_review_score
from orders o
join reviews r
using(order_id)
where o.order_delivered_customer_date is not null
group by delivery_status;

--Revenues by Category
select ct.product_category_name_english, SUM(oi.price) as revenues
from products p
join category_translation ct
using(product_category_name)
join order_items oi
using(product_id)
group by ct.product_category_name_english
order by revenues desc
limit 10;

--Median Review Score
select PERCENTILE_DISC(0.5) within group (order by review_score)
from reviews r;