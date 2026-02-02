Data Engineering Zoomcamp 2026 - Week 2 Homework

Setup

This project uses Docker Compose to run:
	•	Postgres (NY Taxi data)
	•	PgAdmin
	•	Kestra (workflow orchestration)

How to run

docker compose up -d

Services:
	•	Postgres: localhost:5432
	•	PgAdmin: http://localhost:8085
	•	Kestra UI: http://localhost:8080

Pipelines

Implemented Kestra flows:
	•	04_postgres_taxi, manual ingestion for a single taxi / year / month
	•	12_postgres_taxi_backfill, backfill flow looping over taxi type and Year-Month combinations (2020 Yellow, 2021 March)

Flows:
	•	Download CSVs from DataTalksClub NYC TLC releases
	•	Load into Postgres using staging tables + MERGE
	•	Generate deterministic unique_row_id
	•	Cleanup execution files after ingestion

Data validation

Row counts verified directly in Postgres using SQL:

SELECT COUNT(*) FROM yellow_tripdata;
SELECT COUNT(*) FROM green_tripdata;

Homework answers
	•	Terraform workflow: terraform init → terraform apply -auto-approve → terraform destroy
	•	Yellow Taxi 2020 rows: 24,648,499
	•	Green Taxi 2020 rows: 1,734,051
	•	Yellow Taxi March 2021 rows: 1,925,152
	•	Kestra Schedule timezone: America/New_York

Notes
	•	CSV files are handled ephemerally by Kestra and uploaded to internal storage.
	•	Postgres tables are treated as the source of truth for validation.
	•	Secrets (GCP credentials) are injected via Docker environment variables and excluded from git.