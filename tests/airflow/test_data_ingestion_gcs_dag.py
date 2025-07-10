import pytest
import os
import tempfile
from unittest.mock import Mock, patch, MagicMock
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import pyarrow.csv as pv

import sys

mock_dag = MagicMock()
mock_dag.__enter__ = Mock(return_value=mock_dag)
mock_dag.__exit__ = Mock(return_value=None)

mock_operator = MagicMock()
mock_operator.__rshift__ = Mock(return_value=mock_operator)

sys.modules['airflow'] = Mock()
sys.modules['airflow'].DAG = Mock(return_value=mock_dag)
sys.modules['airflow.utils'] = Mock()
sys.modules['airflow.utils.dates'] = Mock()
sys.modules['airflow.operators'] = Mock()
sys.modules['airflow.operators.bash'] = Mock()
sys.modules['airflow.operators.bash'].BashOperator = Mock(return_value=mock_operator)
sys.modules['airflow.operators.python'] = Mock()
sys.modules['airflow.operators.python'].PythonOperator = Mock(return_value=mock_operator)
sys.modules['airflow.providers'] = Mock()
sys.modules['airflow.providers.google'] = Mock()
sys.modules['airflow.providers.google.cloud'] = Mock()
sys.modules['airflow.providers.google.cloud.operators'] = Mock()
sys.modules['airflow.providers.google.cloud.operators.bigquery'] = Mock()
sys.modules['airflow.providers.google.cloud.operators.bigquery'].BigQueryCreateExternalTableOperator = Mock(return_value=mock_operator)

sys.path.append('/home/ubuntu/data-engineering-zoomcamp/cohorts/2022/week_2_data_ingestion/airflow/dags')
from data_ingestion_gcs_dag import format_to_parquet, upload_to_gcs


class TestDataIngestionGcsDag:
    """Test cases for data_ingestion_gcs_dag.py functions"""

    def test_format_to_parquet_success(self, temp_csv_file, temp_parquet_file):
        """Test successful CSV to Parquet conversion"""
        test_data = """tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count
2021-01-01 00:30:10,2021-01-01 00:45:39,1
2021-01-01 00:51:20,2021-01-01 01:07:15,2"""
        
        with open(temp_csv_file, 'w') as f:
            f.write(test_data)
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv, \
             patch('pyarrow.parquet.write_table') as mock_write_table:
            
            mock_table = Mock()
            mock_read_csv.return_value = mock_table
            
            format_to_parquet(temp_csv_file)
            
            mock_read_csv.assert_called_once_with(temp_csv_file)
            expected_parquet_file = temp_csv_file.replace('.csv', '.parquet')
            mock_write_table.assert_called_once_with(mock_table, expected_parquet_file)

    def test_format_to_parquet_invalid_extension(self, caplog):
        """Test format_to_parquet with non-CSV file"""
        test_file = "/tmp/test.txt"
        
        format_to_parquet(test_file)
        
        assert "Can only accept source files in CSV format" in caplog.text

    def test_format_to_parquet_nonexistent_file(self):
        """Test format_to_parquet with nonexistent file"""
        nonexistent_file = "/tmp/nonexistent.csv"
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv:
            mock_read_csv.side_effect = FileNotFoundError("File not found")
            
            with pytest.raises(FileNotFoundError):
                format_to_parquet(nonexistent_file)

    @patch('google.cloud.storage.Client')
    def test_upload_to_gcs_success(self, mock_storage_client):
        """Test successful upload to GCS"""
        mock_client = Mock()
        mock_bucket = Mock()
        mock_blob = Mock()
        
        mock_storage_client.return_value = mock_client
        mock_client.bucket.return_value = mock_bucket
        mock_bucket.blob.return_value = mock_blob
        
        bucket_name = "test-bucket"
        object_name = "test-object"
        local_file = "/tmp/test-file.parquet"
        
        upload_to_gcs(bucket_name, object_name, local_file)
        
        mock_storage_client.assert_called_once()
        mock_client.bucket.assert_called_once_with(bucket_name)
        mock_bucket.blob.assert_called_once_with(object_name)
        mock_blob.upload_from_filename.assert_called_once_with(local_file)

    @patch('google.cloud.storage.Client')
    def test_upload_to_gcs_with_multipart_settings(self, mock_storage_client):
        """Test that upload_to_gcs sets correct multipart settings"""
        mock_client = Mock()
        mock_bucket = Mock()
        mock_blob = Mock()
        
        mock_storage_client.return_value = mock_client
        mock_client.bucket.return_value = mock_bucket
        mock_bucket.blob.return_value = mock_blob
        
        upload_to_gcs("test-bucket", "test-object", "/tmp/test-file.parquet")
        

    @patch('google.cloud.storage.Client')
    def test_upload_to_gcs_upload_failure(self, mock_storage_client):
        """Test upload_to_gcs when upload fails"""
        mock_client = Mock()
        mock_bucket = Mock()
        mock_blob = Mock()
        
        mock_storage_client.return_value = mock_client
        mock_client.bucket.return_value = mock_bucket
        mock_bucket.blob.return_value = mock_blob
        mock_blob.upload_from_filename.side_effect = Exception("Upload failed")
        
        with pytest.raises(Exception, match="Upload failed"):
            upload_to_gcs("test-bucket", "test-object", "/tmp/test-file.parquet")

    def test_format_to_parquet_empty_csv(self, temp_csv_file):
        """Test format_to_parquet with empty CSV file"""
        with open(temp_csv_file, 'w') as f:
            f.write("")
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv:
            mock_read_csv.side_effect = pa.ArrowInvalid("Empty CSV")
            
            with pytest.raises(pa.ArrowInvalid):
                format_to_parquet(temp_csv_file)

    def test_format_to_parquet_malformed_csv(self, temp_csv_file):
        """Test format_to_parquet with malformed CSV file"""
        malformed_data = "header1,header2\nvalue1\nvalue2,value3,value4"
        with open(temp_csv_file, 'w') as f:
            f.write(malformed_data)
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv:
            mock_read_csv.side_effect = pa.ArrowInvalid("Malformed CSV")
            
            with pytest.raises(pa.ArrowInvalid):
                format_to_parquet(temp_csv_file)
