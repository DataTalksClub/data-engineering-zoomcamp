import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


# Function to convert camel case to snake case
def camel_to_snake(name):
    import re
    name = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', name).lower()


@transformer
def transform(data, *args, **kwargs):
    """
    removes rows where passenger_count is zero and trip_distance is zero
    creates new column lpep_pickup_date from lpep_pickup_datetime via picking date only from that column
    converts all columns names from camel case to snake case e.g vendroID to vendor_id
    """
    # Specify your transformation logic here

    print(f"""Rows in Raw data = {data.shape[0]}""")
    filtered_data = data[(data['passenger_count']>0) & (data['trip_distance']>0)]
    print(f"""Rows in filtered data where passenger_count and trip_distance is > 0 = {filtered_data.shape[0]}""")


    print(filtered_data.info(verbose=True))    
    filtered_data['lpep_pickup_datetime'] = pd.to_datetime(filtered_data['lpep_pickup_datetime'])
    filtered_data['lpep_pickup_date'] = filtered_data['lpep_pickup_datetime'].dt.date
    filtered_data.columns = [camel_to_snake(col) for col in filtered_data.columns]
    print(filtered_data.info(verbose=True))

    print(filtered_data['vendor_id'].unique())


    return filtered_data


@test
def test_output(output, *args) -> None:
    """
    Test the output of the block.

    Parameters:
        output (pandas.DataFrame): The DataFrame representing the output data.
        *args: Additional arguments (not used in this function).

    Raises:
        AssertionError: If the 'vendor_id' column is not present in the DataFrame.
        AssertionError: If any value in the 'passenger_count' column is not greater than zero.
        AssertionError: If any value in the 'trip_distance' column is not greater than zero.
    """
    assert 'vendor_id' in output.columns, 'checking the presence of vendor_id column'
    assert (output['passenger_count']>0).all(), 'passenger_count is greater than zero'
    assert (output['trip_distance']>0).all(), 'trip_distance is greater than zero'