ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id);

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_geography
    FOREIGN KEY (geo_id) REFERENCES geography (geo_id);

ALTER TABLE order_item
    ADD CONSTRAINT fk_item_order
    FOREIGN KEY (order_serial) REFERENCES orders (order_serial);

ALTER TABLE order_item
    ADD CONSTRAINT fk_item_product
    FOREIGN KEY (product_serial) REFERENCES products (product_serial);
