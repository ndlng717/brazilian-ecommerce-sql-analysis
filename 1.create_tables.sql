create table customers (
customer_id varchar(50) primary key,
customer_unique_id varchar(50),
customer_zip_code_prefix int,
customer_city varchar(100),
customer_state varchar(2)
);

create table geolocation (
geolocation_zip_code_prefix int,
geolocation_lat numeric(10,6),
geolocation_lng numeric(10,6),
geolocation_city varchar(100),
geolocation_state varchar(2)
);

create table order_items (
order_id varchar(100),
order_item_id int,
product_id varchar(100),
seller_id varchar(100),
shipping_limit_date timestamp,
price numeric(10,2),
freight_value numeric(10,2),
primary key (order_id, order_item_id)
);

create table payments (
order_id varchar(100),
payment_sequential int,
payment_type varchar(50),
payment_installments int,
payment_value numeric(10,2),
primary key (order_id, payment_sequential)
);

create table reviews (
review_id varchar(100),
order_id varchar(100),
review_score int,
review_comment_title text,
review_comment_message text,
review_creation_date timestamp,
review_answer_timestamp timestamp
);

COPY reviews
FROM 'F:/Data Analysis/10. Projects/2. SQL/1. Brazilian E-commerce/olist_order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER
QUOTE '"';

create table orders (
order_id varchar(100) primary key,
customer_id varchar(100),
order_status varchar(50),
order_purchase_timestamp timestamp,
order_approved_at timestamp,
order_delivered_carrier_date timestamp,
order_delivered_customer_date timestamp,
order_estimated_delivery_date timestamp
);

create table products (
product_id varchar(100) primary key,
product_category_name varchar(100),
product_name_lenght int,
product_description_lenght int,
product_photos_qty int,
product_weight_g int,
product_length_cm int,
product_height_cm int,
product_width_cm int
);

create table sellers (
seller_id varchar(100) primary key,
seller_zip_code_prefix int,
seller_city varchar(100),
seller_state varchar(2)
);

create table category_translation (
product_category_name varchar(100) primary key,
product_category_name_english varchar(100)
);