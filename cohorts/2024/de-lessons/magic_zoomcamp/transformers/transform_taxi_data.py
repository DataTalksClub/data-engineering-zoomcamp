# from magic_zoomcamp.utils.helpers import shared

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

import re

def camel_to_snake(name):
    # Replace lowercase-uppercase transitions with underscores
    name = re.sub(r'(?<=[a-z])(?=[A-Z])', '_', name)
    return name.lower()

@transformer
def transform(data, *args, **kwargs):
    print(f'Preprocessing: rows where passenger count is zero: {data.passenger_count.isin([0]).sum()}')

    # clean column names, make all lowercase and convert to snake_case
    data.columns = data.columns.map(camel_to_snake)

    # create new column of date dtype for 'lpep_pickup_date' from 'lpep_pickup_datetime'
    data['tpep_pickup_date'] = data['tpep_pickup_datetime'].dt.date

    # drop records of rides with no passengers
    print(f"Rows with out passengers: {data['passenger_count'].fillna(0).isin([0]).sum() }")
    data = data[data['passenger_count'] > 0]

    # drop records of rides with 0 trip_distance
    print(f"Rows with 0 trip_distance: {data['trip_distance'].fillna(0).isin([0]).sum() }")
    data = data[data['trip_distance'] > 0]

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output['passenger_count'].isin([0]).sum() == 0, 'There are rides with zero passengers'