# Normalization to 3NF — Airbnb DB

Summary

- Reviewed requirements.md. Most entity choices are reasonable. Minor violations / redundancies exist (non-atomic location, derived attribute total_price, some naming inconsistencies).
- Goal: produce a schema in Third Normal Form (3NF): 1NF (atomic values), 2NF (no partial dependencies on a non-composite PK), 3NF (no transitive dependencies).

Identified issues

1. location (Property) is a single VARCHAR — not atomic (street/city/state/country/postal/coords).
2. total_price (Booking) is a derived attribute: depends on price_per_night and booking duration (transitive/derived).
3. pricepernight naming inconsistent (use snake_case: price_per_night).

Normalization steps applied

1. 1NF: Break location into atomic address fields (or a separate PropertyAddress table). Ensure all columns store atomic values.
2. 2NF: All tables use single-column surrogate PKs (UUID). No partial dependencies exist because no composite PKs are used.
3. 3NF: Remove transitive/derived attributes. Remove total_price from Booking (compute from price_per_night \* nights when needed) or store it with a DB trigger/audit if performance/historical immutability is required. Keep foreign keys strictly to referenced PKs.

Revised schema (concise DDL-like specification)

- User

  - user_id UUID PRIMARY KEY
  - first_name VARCHAR NOT NULL
  - last_name VARCHAR NOT NULL
  - email VARCHAR UNIQUE NOT NULL
  - password_hash VARCHAR NOT NULL
  - phone_number VARCHAR
  - role VARCHAR NOT NULL ENUM (guest, host, admin)
  - created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

- Property

  - property_id UUID PRIMARY KEY
  - host_id UUID NOT NULL REFERENCES "User"(user_id)
  - name VARCHAR NOT NULL
  - description TEXT NOT NULL
  - price_per_night DECIMAL NOT NULL
  - currency CHAR(3) DEFAULT 'USD'
  - created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  - updated_at TIMESTAMP

- PropertyAddress (separates location into atomic fields)

  - property_id UUID PRIMARY KEY REFERENCES Property(property_id)
  - street VARCHAR
  - city VARCHAR
  - state VARCHAR
  - country VARCHAR
  - postal_code VARCHAR
  - latitude DECIMAL(9,6)
  - longitude DECIMAL(9,6)

- Booking

  - booking_id UUID PRIMARY KEY
  - property_id UUID NOT NULL REFERENCES Property(property_id)
  - user_id UUID NOT NULL REFERENCES "User"(user_id)
  - start_date DATE NOT NULL
  - end_date DATE NOT NULL
  - status VARCHAR NOT NULL -- ENUM: pending, confirmed, canceled
  - created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  - Note: total_price removed (derived). Use a query:
    total_price = (SELECT price_per_night FROM Property WHERE property_id = ...) \* (end_date - start_date)

- Payment

  - payment_id UUID PRIMARY KEY
  - booking_id UUID UNIQUE NOT NULL REFERENCES Booking(booking_id) -- 1:1
  - amount DECIMAL NOT NULL
  - payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  - payment_method VARCHAR NOT NULL ENUM(credit_card, paypal, stripe)

- Review

  - review_id UUID PRIMARY KEY
  - property_id UUID NOT NULL REFERENCES Property(property_id)
  - user_id UUID NOT NULL REFERENCES "User"(user_id)
  - rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5)
  - comment TEXT
  - created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

- Message
  - message_id UUID PRIMARY KEY
  - sender_id UUID NOT NULL REFERENCES "User"(user_id)
  - recipient_id UUID NOT NULL REFERENCES "User"(user_id)
  - message_body TEXT NOT NULL
  - sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  - Note: Add indexes on (sender_id), (recipient_id) and optionally (sender_id, recipient_id, sent_at)

Additional notes / trade-offs

- total_price: removing it makes schema 3NF.
- Ensure consistent naming (snake_case) and add appropriate indexes (email, user_id, property_id, booking_id).
- Ensure FK ON DELETE/UPDATE policies are chosen according to business rules (CASCADE vs RESTRICT).
