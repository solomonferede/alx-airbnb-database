-- Users (hosts and guests)
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role)
VALUES
  ('Alice', 'Johnson', 'alice@example.com', 'hash_pwd_1', '+251900000001', 'host'),
  ('Bob', 'Smith', 'bob@example.com', 'hash_pwd_2', '+251900000002', 'guest'),
  ('Charlie', 'Brown', 'charlie@example.com', 'hash_pwd_3', '+251900000003', 'guest'),
  ('Diana', 'King', 'diana@example.com', 'hash_pwd_4', '+251900000004', 'host'),
  ('Ethan', 'Williams', 'ethan@example.com', 'hash_pwd_5', '+251900000005', 'guest');

-- Grab user UUIDs for reference
SELECT user_id, first_name, email FROM users;

-- Properties
INSERT INTO property (host_id, name, description, price_per_night, currency)
SELECT user_id, name, description, price, 'USD'
FROM users
JOIN (
  VALUES
    ('Alice', 'Sunny Apartment', 'Beautiful apartment in Addis Ababa', 49.99),
    ('Alice', 'Studio Loft', 'Modern loft with great light', 39.50),
    ('Diana', 'Cozy Cottage', 'Quiet home in the countryside', 79.99)
) AS t(host, name, description, price)
ON users.first_name = t.host;

-- Confirm
SELECT property_id, name FROM property;

-- Property Address
INSERT INTO property_address (property_id, street, city, state, country, postal_code, latitude, longitude)
SELECT property_id,
       street, city, state, country, postal, lat, lng
FROM property
JOIN (
  VALUES
    ('Sunny Apartment', 'Airport Rd', 'Addis Ababa', 'Addis Ababa', 'Ethiopia', '1000', 9.0108, 38.7613),
    ('Studio Loft', 'Bole Ave', 'Addis Ababa', 'Addis Ababa', 'Ethiopia', '1000', 9.0150, 38.7600),
    ('Cozy Cottage', 'Green Hills', 'Hawassa', 'Sidama', 'Ethiopia', '2000', 7.0621, 38.4769)
) AS a(name, street, city, state, country, postal, lat, lng)
USING (name);

-- Bookings (Charlie + Ethan booking Alice's places)
INSERT INTO booking (property_id, user_id, start_date, end_date, status)
SELECT p.property_id, u.user_id, s_date, e_date, status
FROM property p
JOIN users u ON u.email IN ('charlie@example.com', 'ethan@example.com')
JOIN (
  VALUES
    ('Sunny Apartment', 'charlie@example.com', '2025-01-10', '2025-01-14', 'confirmed'),
    ('Studio Loft', 'ethan@example.com', '2025-02-01', '2025-02-05', 'pending'),
    ('Sunny Apartment', 'ethan@example.com', '2025-03-10', '2025-03-15', 'confirmed')
) AS b(name, email, s_date, e_date, status)
ON p.name = b.name AND u.email = b.email;

-- Check
SELECT booking_id, status FROM booking;

-- Payment
INSERT INTO payment (booking_id, amount, payment_method)
SELECT b.booking_id, p.price_per_night * (b.end_date - b.start_date), 'credit_card'
FROM booking b
JOIN property p USING(property_id)
WHERE b.status = 'confirmed';

-- Reviews (only confirmed stays)
INSERT INTO review (property_id, user_id, rating, comment)
SELECT b.property_id, b.user_id,
       (random() * 4 + 1)::INT,
       'Great stay, recommended!'
FROM booking b
WHERE b.status = 'confirmed';

-- Messages between users
INSERT INTO message (sender_id, recipient_id, message_body)
SELECT s.user_id, r.user_id,
       CONCAT('Hi ', r.first_name, '! Looking forward to my stay.')
FROM users s, users r
WHERE s.role = 'guest' AND r.role = 'host'
LIMIT 5;
