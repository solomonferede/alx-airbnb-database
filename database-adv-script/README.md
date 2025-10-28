# Advanced SQL Joins – Airbnb Database

This directory contains SQL queries designed to demonstrate mastery of join operations in PostgreSQL using the **Airbnb Clone database**.

## 📌 Objectives

- Practice retrieving related data across multiple tables
- Utilize different types of SQL joins:
  - `INNER JOIN`
  - `LEFT JOIN`
  - `FULL OUTER JOIN`

## 📂 Files

| File                | Description                                         |
| ------------------- | --------------------------------------------------- |
| `joins_queries.sql` | Contains all SQL join queries required in this task |

## 🧠 Queries Included

1. **INNER JOIN:**
   Retrieve all bookings and the respective users who made those bookings.

2. **LEFT JOIN:**
   Retrieve all properties and their reviews, including properties that have no reviews.

3. **FULL OUTER JOIN:**
   Retrieve all users and all bookings, even if:
   - a user has no booking
   - a booking is not linked to a user

## 🏁 Usage

Run the script inside PostgreSQL:

```sql
\i joins_queries.sql;
```
