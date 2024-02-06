from pandas import DataFrame

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
    
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transformer(df: DataFrame, *args, **kwargs) ->DataFrame:
    """

    """
    print("Preprocessing: rows with zero passengers",
    df['passenger_count'].isin([0]).sum())
    # df['tpep_pickup_date'] = df['tpep_pickup_datetime'].dt.date
    # df['tpep_dropoff_date'] = df['tpep_dropoff_datetime'].dt.date
    return df[df['passenger_count'] > 0]


@test
def test_output(output, *args) ->None:
    """A template function for testing the output of the block. The output is checked to ensure that it is not None. The function takes in the output and any additional arguments and returns None.

    Template code for testing the output of the block.
    """
    assert output['passenger_count'].isin([0]).sum() == 0, 'There are rides with ziro passengers'
