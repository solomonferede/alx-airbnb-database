-- 1️⃣ Non-correlated subquery
-- Find all properties where the average rating is greater than 4.0
SELECT p.property_id,
       p.name AS property_name,
       pa.city
FROM property p
INNER JOIN property_address pa USING(property_id)
WHERE (
    SELECT AVG(r.rating)
    FROM review r
    WHERE r.property_id = p.property_id
) > 4.0;


-- 2️⃣ Correlated subquery
-- Find users who have made more than 3 bookings
SELECT u.user_id,
       u.first_name,
       u.last_name,
       u.email
FROM users u
WHERE (
    SELECT COUNT(*)
    FROM booking b
    WHERE b.user_id = u.user_id
) > 3;
