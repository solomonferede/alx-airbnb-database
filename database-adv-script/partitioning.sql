-- partitioning.sql
-- Author: Solomon Ferede Ezez
-- Purpose: Implement Booking table partitioning by start_date

-- Step 1: Create the partitioned booking table
CREATE TABLE booking_partitioned (
  booking_id UUID NOT NULL DEFAULT gen_random_uuid(),
  property_id UUID NOT NULL REFERENCES property(property_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  user_id UUID NOT NULL REFERENCES users(user_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  status booking_status_enum NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP NOT NULL DEFAULT now(),
  CHECK (end_date > start_date),
  PRIMARY KEY (booking_id, start_date)  -- Include partition column
) PARTITION BY RANGE (start_date);

-- Step 2: Create yearly partitions
CREATE TABLE booking_2024 PARTITION OF booking_partitioned
  FOR VALUES FROM ('2024-01-01 00:00:00') TO ('2025-01-01 00:00:00');

CREATE TABLE booking_2025 PARTITION OF booking_partitioned
  FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2026-01-01 00:00:00');

-- Step 3: Indexes on partitions
CREATE INDEX idx_booking_2024_user_id ON booking_2024(user_id);
CREATE INDEX idx_booking_2024_property_id ON booking_2024(property_id);

CREATE INDEX idx_booking_2025_user_id ON booking_2025(user_id);
CREATE INDEX idx_booking_2025_property_id ON booking_2025(property_id);

-- Step 4: Migrate data from old booking table
INSERT INTO booking_partitioned
SELECT * FROM booking;

-- Step 5: Test query performance
EXPLAIN ANALYZE
SELECT *
FROM booking_partitioned
WHERE start_date BETWEEN '2025-01-01 00:00:00' AND '2025-12-31 23:59:59'
ORDER BY start_date;
