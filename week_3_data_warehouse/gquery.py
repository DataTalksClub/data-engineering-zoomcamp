from google.cloud import bigquery
from google.oauth2 import service_account

credentials = service_account.Credentials.from_service_account_file(
'/home/felipe/code/FelipeBuongermino/nytaxi-376623-37594d6f751d.json')

project_id = 'nytaxi-376623'
client = bigquery.Client(credentials= credentials,project=project_id)

query_job = client.query("""
    SELECT table_name, partition_id, total_rows
    FROM `fhv_tripdata_2019.INFORMATION_SCHEMA.PARTITIONS`
    WHERE table_name = 'fhv_tripdataALL2_PART_CLUST'
    ORDER BY partition_id DESC""")

print(query_job.to_dataframe())
