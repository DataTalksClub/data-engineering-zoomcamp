import os

def main():
    for month in range(1,13):
        file = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-{month:02}.csv.gz"
        file_name = f"fhv_tripdata_2019-{month:02}.csv.gz"
        os.system(f"wget {file} -O {file_name}")

if "__main__" == __name__:
    main()
