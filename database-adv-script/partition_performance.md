# Booking Table Partitioning Performance

## Before Partitioning

```

Seq Scan on booking  (cost=0.00..1.17 rows=1 width=76) (actual time=0.095..0.097 rows=11 loops=1)
Filter: ((start_date >= '2025-01-01 00:00:00') AND (start_date <= '2025-12-31 00:00:00'))
Planning Time: 5.103 ms
Execution Time: 0.136 ms

```

## After Partitioning

```

Sort  (cost=21.74..21.75 rows=4 width=76) (actual time=0.018..0.019 rows=11 loops=1)
Sort Key: booking_partitioned.start_date
Sort Method: quicksort  Memory: 26kB
->  Seq Scan on booking_2025 booking_partitioned  (cost=0.00..21.70 rows=4 width=76) (actual time=0.007..0.008 rows=11 loops=1)
Filter: ((start_date >= '2025-01-01 00:00:00') AND (start_date <= '2025-12-31 23:59:59'))
Planning Time: 2.771 ms
Execution Time: 0.034 ms

```

## ✅ Observations

- Execution time reduced from **0.136 ms → 0.034 ms**
- Planning time reduced from **5.103 ms → 2.771 ms**
- Only the relevant partition (`booking_2025`) was scanned, improving query efficiency.

## 📈 Conclusion

Partitioning by `start_date` significantly improves performance for date-range queries, reducing execution time by **~4x** and planning overhead by almost **50%**.

**Author:** Solomon Ferede Ezez  
**Date:** November 2025
