# Sample Analytics SQL Queries

##This guide provides beginner-friendly SQL examples for exploring analytics engineering outputs.

## Monthly Revenue Trend

```sql
SELECT
    DATE_TRUNC('month', pickup_datetime) AS revenue_month,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS total_trips
FROM fact_trips
GROUP BY 1
ORDER BY 1;
```

## Top Pickup Zones by Revenue

```sql
SELECT
    pickup_zone,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS total_trips
FROM fact_trips
GROUP BY pickup_zone
ORDER BY total_revenue DESC
LIMIT 10;
```

## Business Questions

1. How is revenue changing over time?
2. Which pickup zones generate the most revenue?
3. Which areas need deeper analysis?
```