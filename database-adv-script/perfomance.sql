EXPLAIN ANALYZE
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
