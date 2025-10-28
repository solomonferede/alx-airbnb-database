-- 1️⃣ Total number of bookings made by each user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM users u
LEFT JOIN booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_bookings DESC;


-- 2️⃣ Rank properties by number of bookings (rANK Window Function)
SELECT 
    p.property_id,
    p.name AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (
        ORDER BY COUNT(b.booking_id) DESC
    ) AS property_rank
FROM property p
LEFT JOIN booking b USING(property_id)
GROUP BY p.property_id, p.name
ORDER BY property_rank;

-- 3 RANK properties by number of bookings (ROW_NUMBER() Window Function)

SELECT 
    p.property_id,
    p.name AS property_name,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (
        ORDER BY COUNT(b.booking_id) DESC
    ) AS property_rank
FROM property p
LEFT JOIN booking b USING(property_id)
GROUP BY p.property_id, p.name
ORDER BY property_rank;