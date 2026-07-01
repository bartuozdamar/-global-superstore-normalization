-- expected: 3819 / 1590 / 10768 / 25754 / 51290
SELECT 'geography'  AS table_name, count(*) FROM geography
UNION ALL SELECT 'customers',  count(*) FROM customers
UNION ALL SELECT 'products',   count(*) FROM products
UNION ALL SELECT 'orders',     count(*) FROM orders
UNION ALL SELECT 'order_item', count(*) FROM order_item;
