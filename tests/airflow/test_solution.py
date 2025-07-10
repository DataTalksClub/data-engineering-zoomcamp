import pytest
import os
import tempfile
from unittest.mock import Mock, patch, MagicMock
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import pyarrow.csv as pv
from datetime import datetime, timedelta

import sys

mock_dag = MagicMock()
mock_dag.__enter__ = Mock(return_value=mock_dag)
mock_dag.__exit__ = Mock(return_value=None)

mock_dag_instance = MagicMock()
mock_dag_instance.__enter__ = Mock(return_value=mock_dag_instance)
mock_dag_instance.__exit__ = Mock(return_value=None)

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

sys.path.append('/home/ubuntu/data-engineering-zoomcamp/cohorts/2022/week_2_data_ingestion/homework')
from solution import format_to_parquet, upload_to_gcs, donwload_parquetize_upload_dag


class TestSolution:
    """Test cases for solution.py functions"""

    def test_format_to_parquet_with_dest_file(self, temp_csv_file):
        """Test format_to_parquet with destination file parameter"""
        test_data = """tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count
2021-01-01 00:30:10,2021-01-01 00:45:39,1
2021-01-01 00:51:20,2021-01-01 01:07:15,2"""
        
        with open(temp_csv_file, 'w') as f:
            f.write(test_data)
        
        dest_file = temp_csv_file.replace('.csv', '.parquet')
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv, \
             patch('pyarrow.parquet.write_table') as mock_write_table:
            
            mock_table = Mock()
            mock_read_csv.return_value = mock_table
            
            format_to_parquet(temp_csv_file, dest_file)
            
            mock_read_csv.assert_called_once_with(temp_csv_file)
            mock_write_table.assert_called_once_with(mock_table, dest_file)

    def test_format_to_parquet_without_dest_file(self, temp_csv_file):
        """Test format_to_parquet with destination file parameter"""
        test_data = """tpep_pickup_datetime,tpep_dropoff_datetime,passenger_count
2021-01-01 00:30:10,2021-01-01 00:45:39,1"""
        
        with open(temp_csv_file, 'w') as f:
            f.write(test_data)
        
        dest_file = temp_csv_file.replace('.csv', '.parquet')
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv, \
             patch('pyarrow.parquet.write_table') as mock_write_table:
            
            mock_table = Mock()
            mock_read_csv.return_value = mock_table
            
            format_to_parquet(temp_csv_file, dest_file)
            
            mock_read_csv.assert_called_once_with(temp_csv_file)
            mock_write_table.assert_called_once_with(mock_table, dest_file)

    def test_format_to_parquet_invalid_extension(self, caplog):
        """Test format_to_parquet with non-CSV file"""
        test_file = "/tmp/test.txt"
        dest_file = "/tmp/test.parquet"
        
        format_to_parquet(test_file, dest_file)
        
        assert "Can only accept source files in CSV format" in caplog.text

    @patch('google.cloud.storage.Client')
    def test_upload_to_gcs_simplified(self, mock_storage_client):
        """Test simplified upload_to_gcs function"""
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

    @patch('solution.DAG')
    @patch('solution.BashOperator')
    @patch('solution.PythonOperator')
    def test_donwload_parquetize_upload_dag_creation(self, mock_python_op, mock_bash_op, mock_dag):
        """Test DAG creation function"""
        mock_dag.return_value = mock_dag_instance
        
        mock_bash_task = Mock()
        mock_bash_task.__rshift__ = Mock(return_value=mock_bash_task)
        mock_python_task1 = Mock()
        mock_python_task1.__rshift__ = Mock(return_value=mock_python_task1)
        mock_python_task2 = Mock()
        mock_python_task2.__rshift__ = Mock(return_value=mock_python_task2)
        
        mock_bash_op.return_value = mock_bash_task
        mock_python_op.side_effect = [mock_python_task1, mock_python_task2]
        
        dag_id = "test_dag"
        schedule_interval = "@daily"
        url_template = "https://example.com/data.csv"
        local_csv_path_template = "/tmp/data.csv"
        local_parquet_path_template = "/tmp/data.parquet"
        gcs_path_template = "data/data.parquet"
        
        result_dag = donwload_parquetize_upload_dag(
            dag=mock_dag_instance,
            url_template=url_template,
            local_csv_path_template=local_csv_path_template,
            local_parquet_path_template=local_parquet_path_template,
            gcs_path_template=gcs_path_template
        )
        
        mock_dag.assert_called_once()
        dag_call_args = mock_dag.call_args[1]
        assert dag_call_args['dag_id'] == dag_id
        assert dag_call_args['schedule_interval'] == schedule_interval
        
        assert mock_bash_op.call_count == 1
        assert mock_python_op.call_count == 2
        
        assert result_dag == mock_dag_instance

    @patch('solution.DAG')
    def test_donwload_parquetize_upload_dag_default_args(self, mock_dag):
        """Test DAG creation with default arguments"""
        mock_dag.return_value = mock_dag_instance
        
        result_dag = donwload_parquetize_upload_dag(
            dag=mock_dag_instance,
            url_template="https://example.com/data.csv",
            local_csv_path_template="/tmp/data.csv",
            local_parquet_path_template="/tmp/data.parquet",
            gcs_path_template="data/data.parquet"
        )
        
        mock_dag.assert_called_once()
        dag_call_args = mock_dag.call_args[1]
        
        assert 'default_args' in dag_call_args
        default_args = dag_call_args['default_args']
        assert 'owner' in default_args
        assert 'start_date' in default_args
        assert 'depends_on_past' in default_args
        assert 'retries' in default_args

    def test_format_to_parquet_file_not_found(self):
        """Test format_to_parquet with nonexistent file"""
        nonexistent_file = "/tmp/nonexistent.csv"
        dest_file = "/tmp/nonexistent.parquet"
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv:
            mock_read_csv.side_effect = FileNotFoundError("File not found")
            
            with pytest.raises(FileNotFoundError):
                format_to_parquet(nonexistent_file, dest_file)

    @patch('google.cloud.storage.Client')
    def test_upload_to_gcs_client_error(self, mock_storage_client):
        """Test upload_to_gcs when client creation fails"""
        mock_storage_client.side_effect = Exception("Client creation failed")
        
        with pytest.raises(Exception, match="Client creation failed"):
            upload_to_gcs("test-bucket", "test-object", "/tmp/test-file.parquet")

    @patch('google.cloud.storage.Client')
    def test_upload_to_gcs_bucket_not_found(self, mock_storage_client):
        """Test upload_to_gcs when bucket is not found"""
        mock_client = Mock()
        mock_storage_client.return_value = mock_client
        mock_client.bucket.side_effect = Exception("Bucket not found")
        
        with pytest.raises(Exception, match="Bucket not found"):
            upload_to_gcs("nonexistent-bucket", "test-object", "/tmp/test-file.parquet")

    def test_format_to_parquet_empty_csv(self, temp_csv_file):
        """Test format_to_parquet with empty CSV file"""
        with open(temp_csv_file, 'w') as f:
            f.write("")
        
        dest_file = temp_csv_file.replace('.csv', '.parquet')
        
        with patch('pyarrow.csv.read_csv') as mock_read_csv:
            mock_read_csv.side_effect = pa.ArrowInvalid("Empty CSV")
            
            with pytest.raises(pa.ArrowInvalid):
                format_to_parquet(temp_csv_file, dest_file)

    @patch('solution.DAG')
    @patch('solution.BashOperator')
    @patch('solution.PythonOperator')
    def test_dag_task_dependencies(self, mock_python_op, mock_bash_op, mock_dag):
        """Test that DAG tasks have correct dependencies"""
        mock_dag.return_value = mock_dag_instance
        
        mock_bash_task = Mock()
        mock_bash_task.__rshift__ = Mock(return_value=mock_bash_task)
        mock_python_task1 = Mock()
        mock_python_task1.__rshift__ = Mock(return_value=mock_python_task1)
        mock_python_task2 = Mock()
        mock_python_task2.__rshift__ = Mock(return_value=mock_python_task2)
        
        mock_bash_op.return_value = mock_bash_task
        mock_python_op.side_effect = [mock_python_task1, mock_python_task2]
        
        donwload_parquetize_upload_dag(
            dag=mock_dag_instance,
            url_template="https://example.com/data.csv",
            local_csv_path_template="/tmp/data.csv",
            local_parquet_path_template="/tmp/data.parquet",
            gcs_path_template="data/data.parquet"
        )
        
        mock_bash_task.__rshift__.assert_called_once_with(mock_python_task1)
        mock_python_task1.__rshift__.assert_called_once_with(mock_python_task2)
