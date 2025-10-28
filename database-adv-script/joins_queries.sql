-- 1️⃣ INNER JOIN
-- Retrieve all bookings and the users who made those bookings 
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM booking b
INNER JOIN users u 
ON b.user_id = u.user_id;

-- 2️⃣ LEFT JOIN
-- Retrieve all properties and their reviews, including properties without reviews
SELECT
    p.property_id,
    p.name AS property_name,
    r.review_id,
    r.rating,
    r.comment
FROM property p
LEFT JOIN review r
ON p.property_id = r.property_id
ORDER BY p.name, r.review_id;

-- 3️⃣ FULL OUTER JOIN
-- Retrieve all users and all bookings, even unmatched records

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.start_date,
    b.status
FROM users u
FULL OUTER JOIN booking b
ON u.user_id = b.user_id;
