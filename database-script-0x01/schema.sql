-- Enable useful extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Enums
CREATE TYPE role_enum AS ENUM ('guest','host','admin');
CREATE TYPE booking_status_enum AS ENUM ('pending','confirmed','canceled');
CREATE TYPE payment_method_enum AS ENUM ('credit_card','paypal','stripe');

-------------------------------------------------------------
-- Users
-------------------------------------------------------------
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(25),
  role role_enum NOT NULL DEFAULT 'guest',
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

-------------------------------------------------------------
-- Property
-------------------------------------------------------------
CREATE TABLE property (
  property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  host_id UUID NOT NULL REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  name VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  price_per_night NUMERIC(10,2) NOT NULL CHECK (price_per_night >= 0),
  currency CHAR(3) NOT NULL DEFAULT 'USD',
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  updated_at TIMESTAMP
);

CREATE INDEX idx_property_host_id ON property(host_id);

-------------------------------------------------------------
-- Property Address (1:1)
-------------------------------------------------------------
CREATE TABLE property_address (
  property_id UUID PRIMARY KEY REFERENCES property(property_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  street VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(30),
  latitude NUMERIC(9,6),
  longitude NUMERIC(9,6)
);

-------------------------------------------------------------
-- Booking
-------------------------------------------------------------
CREATE TABLE booking (
  booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id UUID NOT NULL REFERENCES property(property_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  user_id UUID NOT NULL REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  status booking_status_enum NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  CHECK (end_date > start_date)
);

CREATE INDEX idx_booking_property_start ON booking(property_id, start_date);
CREATE INDEX idx_booking_user_id ON booking(user_id);

-------------------------------------------------------------
-- Payment (1:1 with booking)
-------------------------------------------------------------
CREATE TABLE payment (
  payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID NOT NULL UNIQUE REFERENCES booking(booking_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  amount NUMERIC(10,2) NOT NULL CHECK (amount >= 0),
  payment_date TIMESTAMP NOT NULL DEFAULT now(),
  payment_method payment_method_enum NOT NULL
);

-------------------------------------------------------------
-- Review
-------------------------------------------------------------
CREATE TABLE review (
  review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id UUID NOT NULL REFERENCES property(property_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  user_id UUID NOT NULL REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_review_property_id ON review(property_id);
CREATE INDEX idx_review_user_id ON review(user_id);

-------------------------------------------------------------
-- Messages between users
-------------------------------------------------------------
CREATE TABLE message (
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id UUID NOT NULL REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  recipient_id UUID NOT NULL REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_message_sender ON message(sender_id);
CREATE INDEX idx_message_recipient ON message(recipient_id);
CREATE INDEX idx_message_sender_recipient_sent_at
  ON message(sender_id, recipient_id, sent_at);

-------------------------------------------------------------
-- Convenience View
-------------------------------------------------------------
CREATE OR REPLACE VIEW booking_totals AS
SELECT
  b.booking_id,
  b.property_id,
  b.user_id,
  b.start_date,
  b.end_date,
  (p.price_per_night * EXTRACT(EPOCH FROM (b.end_date - b.start_date)) / 86400)::NUMERIC(12,2)
    AS total_price
FROM booking b
JOIN property p USING (property_id);
