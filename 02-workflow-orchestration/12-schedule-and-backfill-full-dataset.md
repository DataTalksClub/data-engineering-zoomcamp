---
video_url: https://www.youtube.com/watch?v=b-6KhfWfk2M
prev_url: 11-load-taxi-data-to-bigquery.md
next_url: 13-why-ai-for-workflows.md
---
# GCP Workflow: Schedule and Backfill Full Dataset

We can now schedule the same pipeline shown above to run daily at 9 AM UTC for the green dataset and at 10 AM UTC for the yellow dataset. You can backfill historical data directly from the Kestra UI.

Since we now process data in a cloud environment with infinitely scalable storage and compute, we can backfill the entire dataset for both the yellow and green taxi data without the risk of running out of resources on our local machine.


The flow code: [`09_gcp_taxi_scheduled.yaml`](flows/09_gcp_taxi_scheduled.yaml).

<!-- nav:start -->
[← Previous: GCP Workflow: Load Taxi Data to BigQuery](11-load-taxi-data-to-bigquery.md) · [Next: Introduction: Why AI for Workflows? →](13-why-ai-for-workflows.md)
<!-- nav:end -->
