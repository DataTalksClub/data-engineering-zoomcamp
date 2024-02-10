import io
import pandas as pd
import requests


if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

@data_loader
def load_data_from_api(*args, **kwargs):

    URL_path = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2020-{m}.csv.gz'
    # print(f"Files = {URL_path}")

    df = None
    for month in range(10,13,1):
        month_url=URL_path.format(m=month)
        # print(month_url)
        df = pd.concat([pd.read_csv(month_url),df], ignore_index=True)
        # print(df.shape)
    
    print(df.shape)

    print(df.info(verbose=True))
    
    return df;


# @test
# def test_output(output, *args) -> None:
#     """
#     Template code for testing the output of the block.
#     """
#     assert output is not None, 'The output is undefined'