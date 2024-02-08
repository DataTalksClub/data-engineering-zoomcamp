import pandas as pd
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    """
    Template code for a transformer block.

    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # Specify your transformation logic here
    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]

    data['lpep_pickup_datetime'] = pd.to_datetime(data['lpep_pickup_datetime'])
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date
    
    def is_camel_case(name):
        return name != name.lower() and name != name.upper() and "_" not in name

    def camel_to_snake(name):
        return ''.join(['_'+i.lower() if i.isupper() else i for i in name]).lstrip('_')

    num_columns_renamed = 0
    for col in data.columns:
        if is_camel_case(col):
            data.rename(columns={col: camel_to_snake(col)}, inplace=True)
            num_columns_renamed += 1

    print("Number of columns renamed to snake case:", num_columns_renamed)
    existing_vendor_ids = data['vendor_i_d'].value_counts().index.tolist()
    print(existing_vendor_ids)


    return data


@test
def test_output(output, *args) -> None:
    assert 'vendor_i_d' in output.columns, "vendor_id column does not exist"
    assert (output['passenger_count'] > 0).all(), "passenger_count is not greater than 0"
    assert (output['trip_distance'] > 0).all(), "trip_distance is not greater than 0"

