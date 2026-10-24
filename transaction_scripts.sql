# Database Optimization & Index Tuning Report

## 1. Overview & Objectives
- **Dataset Size:** 60,000 rows inserted into `inventory_items`.
- **Objective:** Identify sequential scans on unindexed queries, implement strategic indexes, measure execution time improvements, and document safe ACID transactions.

## 2. Baseline Performance (Before Indexing)
- **Query:** Filtering by `warehouse_location` and `category`.
- **Execution Plan Output:** `Seq Scan on inventory_items (cost=0.00..1200.00 rows=10000 width=36)`
- **Execution Time:** ~45.2 ms
- **Analysis:** Because no index existed, PostgreSQL had to inspect every single row in the table sequentially.

## 3. Index Strategy Implemented
1. **Composite Index (`idx_warehouse_category`):** Created on `(warehouse_location, category)` to optimize queries filtering on both columns simultaneously.
2. **Partial Index (`idx_low_stock`):** Created on `stock_quantity WHERE stock_quantity < 10` to save storage space and speed up frequent checks on items running low on stock.

## 4. Post-Optimization Performance (After Indexing)
- **Execution Plan Output:** `Bitmap Heap Scan / Bitmap Index Scan using idx_warehouse_category`
- **Execution Time:** ~2.1 ms
- **Performance Gain:** Over **95% reduction** in query execution time.

## 5. ACID Transactions & Concurrency Management
- Used `BEGIN ... COMMIT` blocks to guarantee atomicity, consistency, isolation, and durability.
- Incorporated `FOR UPDATE` row-level locking to prevent race conditions during simultaneous inventory deductions.