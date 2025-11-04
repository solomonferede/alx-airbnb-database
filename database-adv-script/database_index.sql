-- ===========================================================
-- File: database_index.sql
-- Purpose: Create indexes to improve query performance
-- Author: Solomon Ferede Ezez
-- ===========================================================

-- === USERS TABLE ===
-- Index on email for quick login/search lookup
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- === BOOKING TABLE ===
-- Index on foreign keys for joins
CREATE INDEX IF NOT EXISTS idx_booking_user_id ON booking(user_id);
CREATE INDEX IF NOT EXISTS idx_booking_property_id ON booking(property_id);


-- Index on booking status for filtering active/cancelled bookings
CREATE INDEX IF NOT EXISTS idx_booking_status ON booking(status);


-- Index on price for range queries
CREATE INDEX IF NOT EXISTS idx_property_price ON property(price_per_night);

-- Index on property_id for joins (if not already primary key)
CREATE INDEX IF NOT EXISTS idx_property_id ON property(property_id);


-- ===========================================================
-- PROPERTY_ADDRESS TABLE INDEXES
-- ===========================================================

-- Index on property_id for fast joins with property table
CREATE INDEX IF NOT EXISTS idx_property_address_property_id ON property_address(property_id);

-- Index on city for filtering/searching by location
CREATE INDEX IF NOT EXISTS idx_property_address_city ON property_address(city);

-- Index on country for region-level filtering
CREATE INDEX IF NOT EXISTS idx_property_address_country ON property_address(country);

-- Index on postal code for direct lookup
CREATE INDEX IF NOT EXISTS idx_property_address_postal_code ON property_address(postal_code);

-- (Optional) Combined index for frequent queries using city + country together
CREATE INDEX IF NOT EXISTS idx_property_address_city_country ON property_address(city, country);


