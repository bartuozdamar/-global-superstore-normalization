INSERT INTO geography (city, state, country, region, market)
SELECT DISTINCT "City", "State", "Country", "Region", "Market"
FROM global_superstore;

INSERT INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT "Customer ID", "Customer Name", "Segment"
FROM global_superstore;

INSERT INTO products (product_id, product_name, sub_category, category)
SELECT DISTINCT "Product ID", "Product Name", "Sub-Category", "Category"
FROM global_superstore;

-- join to geography to grab geo_id (doesn't exist in the source)
INSERT INTO orders (order_id, order_date, ship_date, ship_mode, order_priority, customer_id, geo_id)
SELECT DISTINCT a."Order ID", a."Order Date", a."Ship Date", a."Ship Mode",
                a."Order Priority", a."Customer ID", b.geo_id
FROM global_superstore AS a
JOIN geography AS b
  ON  a."City"    = b.city
  AND a."State"   = b.state
  AND a."Country" = b.country
  AND a."Region"  = b.region
  AND a."Market"  = b.market;

-- two lookups: order_serial from orders, product_serial from products
-- matching on order_id alone isn't enough (the 660 dupes), so + customer + date
INSERT INTO order_item (order_serial, product_serial, sales, quantity, profit, shipping_cost, discount)
SELECT b.order_serial, c.product_serial,
       a."Sales", a."Quantity", a."Profit", a."Shipping Cost", a."Discount"
FROM global_superstore AS a
JOIN orders AS b
  ON  a."Order Date"  = b.order_date
  AND a."Order ID"    = b.order_id
  AND a."Customer ID" = b.customer_id
JOIN products AS c
  ON  a."Product ID"   = c.product_id
  AND a."Product Name" = c.product_name
  AND a."Sub-Category" = c.sub_category
  AND a."Category"     = c.category;
