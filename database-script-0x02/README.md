# 📌 README – `seed.sql`

This file contains SQL `INSERT` statements that preload the database with sample data for learning, testing, and experimenting with CRUD operations.

## ✅ What this script does

It populates key tables with realistic demo data, including:

| Table        | Sample Entries Include                                                  |
| ------------ | ----------------------------------------------------------------------- |
| **User**     | Multiple real-world style users with different emails, passwords, names |
| **Property** | Various properties owned by users: houses, apartments, unique stays     |
| **Booking**  | Multiple bookings across different users, dates, and statuses           |
| **Payment**  | Payments linked to bookings with different methods and amounts          |

## 🚀 How to execute

Run inside **psql**:

```sh
psql -U <username> -d <database_name> -f seed.sql
```
