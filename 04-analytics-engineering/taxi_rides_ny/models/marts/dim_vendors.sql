-- Dimension table for taxi technology vendors
-- Small static dimension defining vendor codes and their company names
-- Uses Jinja macro to generate data (works across BigQuery, DuckDB, Snowflake, etc.)

{{ get_vendor_data() }}
