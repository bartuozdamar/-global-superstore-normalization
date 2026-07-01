-- DROP TABLE IF EXISTS order_item, orders, products, customers, geography CASCADE;

CREATE TABLE geography (
    geo_id  serial PRIMARY KEY,
    city    text,
    state   text,
    country text,
    region  text,
    market  text
);

CREATE TABLE customers (
    customer_id   text PRIMARY KEY,
    customer_name text,
    segment       text
);

-- surrogate key, product_id is dirty
CREATE TABLE products (
    product_serial serial PRIMARY KEY,
    product_id     text,
    product_name   text,
    sub_category   text,
    category       text
);

-- surrogate key, order_id is dirty
CREATE TABLE orders (
    order_serial   serial PRIMARY KEY,
    order_id       text,
    order_date     text,
    ship_date      text,
    ship_mode      text,
    order_priority text,
    customer_id    text,
    geo_id         integer
);

CREATE TABLE order_item (
    item_id        serial PRIMARY KEY,
    order_serial   integer,
    product_serial integer,
    sales          text,
    quantity       text,
    profit         text,
    shipping_cost  text,
    discount       text
);
