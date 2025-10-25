# Airbnb (3NF) PostgreSQL Schema

This repository contains a normalized (3NF) PostgreSQL schema for a simplified Airbnb-like system.

## Files

- `database-script-0x01/schema.sql` — DDL that creates tables, enums, indexes and a convenience view (`booking_totals`).
- `normalization.md` — design notes and rationale.

## Requirements

- PostgreSQL 12+
- psql client
- Superuser or a role allowed to create extensions (for `pgcrypto`)

## Install / Apply schema

1. Open terminal (Linux).
2. Connect and run:
   ```
   psql -d your_database -f database-script-0x01/schema.sql
   ```
   or copy/paste the file contents into psql.

## Key design decisions

- UUID surrogate primary keys (generated via `pgcrypto`'s `gen_random_uuid()`).
- Enums used for `role`, `booking_status`, and `payment_method`.
- Address factored into `property_address` for atomic fields.
- `total_price` removed from `booking` (derived). Use the `booking_totals` view or compute at query time.
- Indexes added on common lookup columns (email, host_id, property_id, booking.user_id, message sender/recipient).

## Example: compute booking total

To compute total price for a booking at query time:

```sql
SELECT b.booking_id,
       p.price_per_night,
       b.start_date,
       b.end_date,
       (p.price_per_night * (b.end_date - b.start_date))::numeric(12,2) AS total_price
FROM booking b
JOIN property p ON p.property_id = b.property_id
WHERE b.booking_id = '<booking-uuid>';
```

Or use the provided view:

```sql
SELECT * FROM booking_totals WHERE booking_id = '<booking-uuid>';
```

## Notes / Recommendations

- Adjust FK ON DELETE behavior to match business rules (current defaults favor RESTRICT/CASCADE as in `sql/schema.sql`).
- Consider storing historical price snapshots or recording `price_per_night` on `booking` if prices change and immutability is required.
- Limit access to `password_hash` and sensitive fields; enforce encryption/column-level security as needed.
- Add more indexes based on measured query patterns.

## Testing / Seeds

- Create lightweight seed scripts to insert roles, users, hosts, properties and bookings for integration testing.
- Use transactions and `ROLLBACK` in tests to keep the DB clean.

## License

Project content: MIT (or choose your preferred license).
