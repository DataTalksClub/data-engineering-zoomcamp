import pytest
import os
import tempfile
from unittest.mock import Mock, patch
import pandas as pd


@pytest.fixture
def sample_csv_data():
    """Sample CSV data for testing"""
    return """tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count,trip_distance,fare_amount
2021-01-01 00:30:10,2021-01-01 00:45:39,1,2.10,8.0
2021-01-01 00:51:20,2021-01-01 01:07:15,1,0.20,3.0
2021-01-01 00:09:00,2021-01-01 00:18:12,1,1.60,7.0"""


@pytest.fixture
def temp_csv_file(sample_csv_data):
    """Create a temporary CSV file for testing"""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.csv', delete=False) as f:
        f.write(sample_csv_data)
        temp_file_path = f.name
    
    yield temp_file_path
    
    if os.path.exists(temp_file_path):
        os.unlink(temp_file_path)


@pytest.fixture
def temp_parquet_file():
    """Create a temporary parquet file path for testing"""
    with tempfile.NamedTemporaryFile(suffix='.parquet', delete=False) as f:
        temp_file_path = f.name
    
    yield temp_file_path
    
    if os.path.exists(temp_file_path):
        os.unlink(temp_file_path)


@pytest.fixture
def mock_gcs_client():
    """Mock Google Cloud Storage client"""
    with patch('google.cloud.storage.Client') as mock_client:
        mock_bucket = Mock()
        mock_blob = Mock()
        mock_client.return_value.bucket.return_value = mock_bucket
        mock_bucket.blob.return_value = mock_blob
        yield mock_client


@pytest.fixture
def mock_sqlalchemy_engine():
    """Mock SQLAlchemy engine for database testing"""
    with patch('sqlalchemy.create_engine') as mock_engine:
        mock_connection = Mock()
        mock_engine.return_value.connect.return_value = mock_connection
        yield mock_engine


@pytest.fixture
def mock_pandas_read_csv():
    """Mock pandas read_csv for testing"""
    sample_df = pd.DataFrame({
        'tpep_pickup_datetime': ['2021-01-01 00:30:10', '2021-01-01 00:51:20'],
        'tpep_dropoff_datetime': ['2021-01-01 00:45:39', '2021-01-01 01:07:15'],
        'passenger_count': [1, 1],
        'trip_distance': [2.10, 0.20],
        'fare_amount': [8.0, 3.0]
    })
    
    with patch('pandas.read_csv') as mock_read_csv:
        mock_read_csv.return_value = sample_df
        yield mock_read_csv


@pytest.fixture
def mock_environment_variables():
    """Mock environment variables for testing"""
    env_vars = {
        'GCP_PROJECT_ID': 'test-project',
        'GCP_GCS_BUCKET': 'test-bucket',
        'AIRFLOW_HOME': '/tmp/airflow',
        'BIGQUERY_DATASET': 'test_dataset',
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    }
    
    with patch.dict(os.environ, env_vars):
        yield env_vars
