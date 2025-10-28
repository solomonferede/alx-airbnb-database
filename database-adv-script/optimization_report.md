# Query Optimization Report – Airbnb Database

## Objective

Optimize a complex query that retrieves all bookings along with:

- User details
- Property details
- Payment information

## Initial Query

```sql
SELECT
    b.booking_id,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    b.status,
    pa.amount,
    pa.payment_method
FROM booking b
LEFT JOIN users u USING (user_id)
LEFT JOIN property p USING (property_id)
LEFT JOIN payment pa USING (booking_id);
```

## Observed Issues

- Sequential scans on `booking`, `users`, `property`, and `payment`
- Hash left joins used for joining tables
- Low cost and execution time on small dataset
- Could degrade on large tables without indexes

## Optimization Strategy

1. Add indexes on frequently joined columns:

```sql
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_payment_booking_id ON payment(booking_id);
CREATE INDEX idx_property_host_id ON property(host_id);
```

2. Refactor joins for clarity:

```sql
SELECT
    b.booking_id,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    pa.amount,
    pa.payment_method,
    b.status
FROM booking b
LEFT JOIN users u ON b.user_id = u.user_id
LEFT JOIN property p ON b.property_id = p.property_id
LEFT JOIN payment pa ON b.booking_id = pa.booking_id;
```

3. Use `EXPLAIN ANALYZE` to validate performance.

## EXPLAIN ANALYZE Output (Sample)

```
Hash Left Join  (cost=3.61..4.84 rows=11 width=894) (actual time=0.078..0.088 rows=11 loops=1)
Planning Time: 0.292 ms
Execution Time: 0.136 ms
```

## Recommendations

- Keep optimized query in `performance.sql`
- Add suggested indexes in production
- Monitor performance as database grows
- Consider caching or partitioning for large datasets

## Conclusion

The query is optimized for readability and future scalability.
Performance is excellent for current data, and indexing ensures fast execution on larger datasets.

````# Query Optimization Report – Airbnb Database

## Objective
Optimize a complex query that retrieves all bookings along with:
- User details
- Property details
- Payment information

## Initial Query

```sql
SELECT
    b.booking_id,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    b.status,
    pa.amount,
    pa.payment_method
FROM booking b
LEFT JOIN users u USING (user_id)
LEFT JOIN property p USING (property_id)
LEFT JOIN payment pa USING (booking_id);
````

## Observed Issues

- Sequential scans on `booking`, `users`, `property`, and `payment`
- Hash left joins used for joining tables
- Low cost and execution time on small dataset
- Could degrade on large tables without indexes

## Optimization Strategy

1. Add indexes on frequently joined columns:

```sql
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_property_id ON booking(property_id);
CREATE INDEX idx_payment_booking_id ON payment(booking_id);
CREATE INDEX idx_property_host_id ON property(host_id);
```

2. Refactor joins for clarity:

```sql
SELECT
    b.booking_id,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    pa.amount,
    pa.payment_method,
    b.status
FROM booking b
LEFT JOIN users u ON b.user_id = u.user_id
LEFT JOIN property p ON b.property_id = p.property_id
LEFT JOIN payment pa ON b.booking_id = pa.booking_id;
```

3. Use `EXPLAIN ANALYZE` to validate performance.

## EXPLAIN ANALYZE Output (Sample)

```
Hash Left Join  (cost=3.61..4.84 rows=11 width=894) (actual time=0.078..0.088 rows=11 loops=1)
Planning Time: 0.292 ms
Execution Time: 0.136 ms
```

## Recommendations

- Keep optimized query in `performance.sql`
- Add suggested indexes in production
- Monitor performance as database grows
- Consider caching or partitioning for large datasets

## Conclusion

The query is optimized for readability and future scalability.
Performance is excellent for current data, and indexing ensures fast execution on larger datasets.
