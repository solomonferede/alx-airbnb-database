# Advanced SQL Queries – Airbnb Database

This directory contains SQL queries designed to demonstrate mastery of **join operations** and **subqueries** in PostgreSQL using the **Airbnb Clone database**.

## 📌 Objectives

- Practice retrieving related data across multiple tables using joins
- Write both **correlated** and **non-correlated** subqueries
- Retrieve meaningful insights from multiple tables
- Calculate summary metrics using `COUNT` with `GROUP BY`
- Rank entities using SQL window functions (`RANK`, `ROW_NUMBER`)

## 📂 Files

| File                                    | Description                                                                              |
| --------------------------------------- | ---------------------------------------------------------------------------------------- |
| `joins_queries.sql`                     | Contains SQL join queries demonstrating `INNER JOIN`, `LEFT JOIN`, and `FULL OUTER JOIN` |
| `subqueries.sql`                        | Contains SQL queries demonstrating **correlated** and **non-correlated** subqueries      |
| `aggregations_and_window_functions.sql` | SQL queries for aggregation and ranking                                                  |

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

### Aggeregate and window function (`aggregations_and_window_functions.sql`)

1️⃣ **Total Bookings per User**  
Uses `COUNT` and `GROUP BY` to show how many bookings each user has made.

2️⃣ **Property Popularity Ranking**  
Ranks properties based on total bookings using a `RANK()` window function.

## 🏁 Usage

Run the scripts inside PostgreSQL:

```sql
\i joins_queries.sql;
\i subqueries.sql;
```
