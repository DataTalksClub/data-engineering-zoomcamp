from pandas import DataFrame
import math
if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


def select_number_columns(df: DataFrame) ->DataFrame:
    """Selects specific columns from the given DataFrame and returns a new DataFrame with only those columns."""
    return df[['Age', 'Fare', 'Parch', 'Pclass', 'SibSp', 'Survived']]


def fill_missing_values_with_median(df: DataFrame) ->DataFrame:
    """Fills in missing values in each column of the given DataFrame with the median value of that column."""
    for col in df.columns:
        values = sorted(df[col].dropna().tolist())
        median_age = values[math.floor(len(values) / 2)]
        df[[col]] = df[[col]].fillna(median_age)
    return df


@transformer
def transform_df(df: DataFrame, *args, **kwargs) ->DataFrame:
    """Transforms the given DataFrame by filling in missing values with the median and selecting specific columns.

    Template code for a transformer block.

    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        df (DataFrame): Data frame from parent block.

    Returns:
        DataFrame: Transformed data frame
    """
    return fill_missing_values_with_median(select_number_columns(df))


@test
def test_output(df) ->None:
    """Tests the output of the block to ensure it is not undefined.

    Template code for testing the output of the block.
    """
    assert df is not None, 'The output is undefined'
