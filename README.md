# SQL Project: Awesome Chocolates Sales Analysis

This project contains structured SQL queries performed on the "Awesome Chocolates" sales dataset — a fictional but realistic database simulating product sales, customer locations, and revenue.

## Tools & Technologies
- MySQL
- DBeaver / MySQL Workbench

##  What I Did
- Connected and queried a relational database
- Performed filtering, grouping, aggregation, and joins
- Generated reports on product-wise sales, top regions, and revenue trends

## Folders
- `/queries` → Organized `.sql` files for each business question


## Sample Query
```sql
SELECT Product, SUM(Amount) AS TotalRevenue
FROM sales
GROUP BY Product
ORDER BY TotalRevenue DESC;
