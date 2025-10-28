# Advanced SQL Queries – Airbnb Database

This directory contains SQL queries designed to demonstrate mastery of **join operations** and **subqueries** in PostgreSQL using the **Airbnb Clone database**.

## 📌 Objectives

- Practice retrieving related data across multiple tables using joins
- Write both **correlated** and **non-correlated** subqueries
- Retrieve meaningful insights from multiple tables

## 📂 Files

| File                | Description                                                                              |
| ------------------- | ---------------------------------------------------------------------------------------- |
| `joins_queries.sql` | Contains SQL join queries demonstrating `INNER JOIN`, `LEFT JOIN`, and `FULL OUTER JOIN` |
| `subqueries.sql`    | Contains SQL queries demonstrating **correlated** and **non-correlated** subqueries      |

## 🧠 Queries Included

### Joins Queries (`joins_queries.sql`)

1. **INNER JOIN:**  
   Retrieve all bookings and the respective users who made those bookings.

2. **LEFT JOIN:**  
   Retrieve all properties and their reviews, including properties that have no reviews.  
   _(Optionally includes the review authors and property hosts.)_

3. **FULL OUTER JOIN:**  
   Retrieve all users and all bookings, even if:
   - a user has no booking
   - a booking is not linked to a user

### Subqueries (`subqueries.sql`)

1. **Non-correlated subquery:**  
   Find all properties where the average rating is greater than 4.0.

2. **Correlated subquery:**  
   Find users who have made more than 3 bookings.

3. **Alternative aggregate approach (optional):**  
   Use `GROUP BY` + `HAVING` to compute average ratings or booking counts without using subqueries.

## 🏁 Usage

Run the scripts inside PostgreSQL:

```sql
\i joins_queries.sql;
\i subqueries.sql;
```
