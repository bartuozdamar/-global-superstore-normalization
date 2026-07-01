# Global Superstore – Normalization (PostgreSQL)

I took the Global Superstore CSV (one flat file, ~51k rows, 24 columns) and broke it
into proper related tables in Postgres. The goal was to stop repeating the same facts
on every row and split everything into tables that link together with foreign keys.

Did this mostly to actually learn normalization properly. First time through I was
kind of following steps without getting it, so I dropped everything and rebuilt the
whole thing from scratch a second time writing the queries myself. That's when it
clicked.

## Tools
- PostgreSQL
- DBeaver (imported the CSV straight into a `global_superstore` table, no staging)

## The tables

| table       | rows   | key            |
|-------------|--------|----------------|
| geography   | 3,819  | surrogate geo_id |
| customers   | 1,590  | customer_id (real) |
| products    | 10,768 | surrogate product_serial |
| orders      | 25,754 | surrogate order_serial |
| order_item  | 51,290 | surrogate item_id |

order_item links to orders + products, orders links to customers + geography.

## Key decisions

The main thing I learned: don't trust an ID just because it's called an ID. You have
to test it. I checked each one with `GROUP BY id HAVING COUNT(DISTINCT ...) > 1`.

- **customers** – Customer ID came back clean (one name per id), so I used it directly.
- **products** – Product ID is dirty. 457 ids point to two different products (found one
  id that was both a Chromcraft and a Bevis table). Can't use it as a key, so surrogate.
- **orders** – Order ID is also dirty, ~660 of them cover two totally different orders
  (different customer, date, city under the same id). Surrogate again. This one caught
  me out at first, I assumed order_id was unique and my insert blew up on a duplicate key.
- **geography** – city isn't unique (loads of repeated city names in different states),
  so surrogate. distinct cities = 3,636 but distinct full places = 3,819, that gap is
  the repeated names.

Also split orders vs order_item because the 51k rows are line items, not orders – they
collapse to ~25k actual orders. Dropped Postal Code, it's null for most non-US orders.

## The tricky part

The lookup joins. The surrogate keys (geo_id, order_serial, product_serial) only exist
in my new tables, not in the source, so to fill orders/order_item I had to join back to
the tables I'd already built and match on the real columns. order_item does this twice
in one query. Took me a bit to see why order_id alone wasn't enough to match a line to
its order.

## Normal form

It's in 3NF. One spot I left alone: sub_category → category in products could be its own
table for stricter 3NF but I left it inline, felt like overkill for a tiny lookup.

## Run order
1. Import the CSV into `global_superstore` via DBeaver
2. sql/01_data_quality_checks.sql  (the id tests)
3. sql/02_create_tables.sql
4. sql/03_populate_tables.sql
5. sql/04_foreign_keys.sql
6. sql/05_verify.sql

## Next
Analysis on the clean schema – revenue over time, RFM, cohorts, that kind of thing.
