-- checking if the natural ids are safe to use as primary keys
-- (customer_id = clean, product_id + order_id = dirty)

-- customer id -> 0 rows, clean
SELECT "Customer ID", COUNT(DISTINCT "Customer Name")
FROM global_superstore
GROUP BY "Customer ID"
HAVING COUNT(DISTINCT "Customer Name") > 1;

-- product id -> 457 rows, same id used for different products
SELECT "Product ID", COUNT(DISTINCT "Product Name")
FROM global_superstore
GROUP BY "Product ID"
HAVING COUNT(DISTINCT "Product Name") > 1;

-- order id -> ~660 rows, same id covers different orders
SELECT "Order ID", COUNT(DISTINCT "Customer ID")
FROM global_superstore
GROUP BY "Order ID"
HAVING COUNT(DISTINCT "Customer ID") > 1;
