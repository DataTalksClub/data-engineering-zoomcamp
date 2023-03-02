import os

def main():
    colors = ["green", "yellow"]
    years = [2019, 2020]
    for year in years:
        for color in colors:
            for month in range(1,13):
                file = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/{color}/{color}_tripdata_{year}-{month:02}.csv.gz"
                file_name = f"{color}_tripdata_{year}-{month:02}.csv.gz"
                os.system(f"wget {file} -O {file_name}")

if "__main__" == __name__:
    main()
