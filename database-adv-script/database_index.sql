-- database_index.sql
-- Author: Solomon Ferede Ezez
-- Purpose: Create indexes and measure query performance

-- Example: Query before indexing
EXPLAIN ANALYZE
SELECT *
FROM booking
JOIN users USING(user_id)
JOIN property USING(property_id)
WHERE users.email = 'bob@example.com'
  AND property.property_id = 'some-uuid';
  
-- === USERS TABLE ===
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- === BOOKING TABLE ===
CREATE INDEX IF NOT EXISTS idx_booking_user_id ON booking(user_id);
CREATE INDEX IF NOT EXISTS idx_booking_property_id ON booking(property_id);
CREATE INDEX IF NOT EXISTS idx_booking_status ON booking(status);

-- === PROPERTY TABLE ===
CREATE INDEX IF NOT EXISTS idx_property_price ON property(price_per_night);
CREATE INDEX IF NOT EXISTS idx_property_id ON property(property_id);

-- === PROPERTY_ADDRESS TABLE ===
CREATE INDEX IF NOT EXISTS idx_property_address_property_id ON property_address(property_id);
CREATE INDEX IF NOT EXISTS idx_property_address_city ON property_address(city);
CREATE INDEX IF NOT EXISTS idx_property_address_country ON property_address(country);
CREATE INDEX IF NOT EXISTS idx_property_address_postal_code ON property_address(postal_code);
CREATE INDEX IF NOT EXISTS idx_property_address_city_country ON property_address(city, country);


-- Example: Query after indexing
EXPLAIN ANALYZE
SELECT *
FROM booking
JOIN users USING(user_id)
JOIN property USING(property_id)
WHERE users.email = 'bob@example.com'
  AND property.property_id = 'some-uuid';
