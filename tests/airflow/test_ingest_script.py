import pytest
import pandas as pd
from unittest.mock import Mock, patch, MagicMock
from sqlalchemy import create_engine
import tempfile
import os

import sys
sys.path.append('/home/ubuntu/data-engineering-zoomcamp/cohorts/2022/week_2_data_ingestion/airflow/dags_local')
from ingest_script import ingest_callable


class TestIngestScript:
    """Test cases for ingest_script.py functions"""

    @patch('ingest_script.create_engine')
    @patch('ingest_script.pd.read_csv')
    @patch('ingest_script.time')
    @patch('pandas.DataFrame.to_sql')
    def test_ingest_callable_success(self, mock_to_sql, mock_time, mock_read_csv, mock_create_engine):
        """Test successful data ingestion"""
        mock_engine = Mock()
        mock_connection = Mock()
        mock_create_engine.return_value = mock_engine
        mock_engine.connect.return_value = mock_connection
        
        mock_time.side_effect = [1000.0, 1001.0, 1002.0, 1003.0]
        
        sample_df = pd.DataFrame({
            'tpep_pickup_datetime': ['2021-01-01 00:30:10', '2021-01-01 00:51:20'],
            'tpep_dropoff_datetime': ['2021-01-01 00:45:39', '2021-01-01 01:07:15'],
            'passenger_count': [1, 1],
            'trip_distance': [2.10, 0.20],
            'fare_amount': [8.0, 3.0]
        })
        
        mock_iterator = Mock()
        mock_iterator.__next__ = Mock(side_effect=[sample_df, StopIteration()])
        mock_read_csv.return_value = mock_iterator
        
        user = "test_user"
        password = "test_password"
        host = "localhost"
        port = "5432"
        db = "test_db"
        table_name = "test_table"
        csv_file = "/tmp/test.csv"
        execution_date = "2021-01-01"
        
        ingest_callable(user, password, host, port, db, table_name, csv_file, execution_date)
        
        expected_connection_string = f'postgresql://{user}:{password}@{host}:{port}/{db}'
        mock_create_engine.assert_called_once_with(expected_connection_string)
        mock_engine.connect.assert_called_once()
        
        mock_read_csv.assert_called_once_with(csv_file, iterator=True, chunksize=100000)
        
        assert mock_to_sql.call_count >= 2

    @patch('ingest_script.create_engine')
    @patch('ingest_script.pd.read_csv')
    def test_ingest_callable_database_connection_failure(self, mock_read_csv, mock_create_engine):
        """Test ingest_callable when database connection fails"""
        mock_engine = Mock()
        mock_create_engine.return_value = mock_engine
        mock_engine.connect.side_effect = Exception("Connection failed")
        
        user = "test_user"
        password = "test_password"
        host = "localhost"
        port = "5432"
        db = "test_db"
        table_name = "test_table"
        csv_file = "/tmp/test.csv"
        execution_date = "2021-01-01"
        
        with pytest.raises(Exception, match="Connection failed"):
            ingest_callable(user, password, host, port, db, table_name, csv_file, execution_date)

    @patch('ingest_script.create_engine')
    @patch('ingest_script.pd.read_csv')
    def test_ingest_callable_csv_read_failure(self, mock_read_csv, mock_create_engine):
        """Test ingest_callable when CSV reading fails"""
        mock_engine = Mock()
        mock_connection = Mock()
        mock_create_engine.return_value = mock_engine
        mock_engine.connect.return_value = mock_connection
        
        mock_read_csv.side_effect = FileNotFoundError("CSV file not found")
        
        user = "test_user"
        password = "test_password"
        host = "localhost"
        port = "5432"
        db = "test_db"
        table_name = "test_table"
        csv_file = "/tmp/nonexistent.csv"
        execution_date = "2021-01-01"
        
        with pytest.raises(FileNotFoundError, match="CSV file not found"):
            ingest_callable(user, password, host, port, db, table_name, csv_file, execution_date)

    @patch('ingest_script.create_engine')
    @patch('ingest_script.pd.read_csv')
    @patch('ingest_script.time')
    @patch('pandas.DataFrame.to_sql')
    def test_ingest_callable_multiple_chunks(self, mock_to_sql, mock_time, mock_read_csv, mock_create_engine):
        """Test ingest_callable with multiple data chunks"""
        mock_engine = Mock()
        mock_connection = Mock()
        mock_create_engine.return_value = mock_engine
        mock_engine.connect.return_value = mock_connection
        
        mock_time.side_effect = [1000.0, 1001.0, 1002.0, 1003.0, 1004.0, 1005.0]
        
        chunk1 = pd.DataFrame({
            'tpep_pickup_datetime': ['2021-01-01 00:30:10'],
            'tpep_dropoff_datetime': ['2021-01-01 00:45:39'],
            'passenger_count': [1],
            'trip_distance': [2.10],
            'fare_amount': [8.0]
        })
        
        chunk2 = pd.DataFrame({
            'tpep_pickup_datetime': ['2021-01-01 01:30:10'],
            'tpep_dropoff_datetime': ['2021-01-01 01:45:39'],
            'passenger_count': [2],
            'trip_distance': [3.20],
            'fare_amount': [12.0]
        })
        
        mock_iterator = Mock()
        mock_iterator.__next__ = Mock(side_effect=[chunk1, chunk2, StopIteration()])
        mock_read_csv.return_value = mock_iterator
        
        user = "test_user"
        password = "test_password"
        host = "localhost"
        port = "5432"
        db = "test_db"
        table_name = "test_table"
        csv_file = "/tmp/test.csv"
        execution_date = "2021-01-01"
        
        ingest_callable(user, password, host, port, db, table_name, csv_file, execution_date)
        
        assert mock_iterator.__next__.call_count == 3
        assert mock_to_sql.call_count >= 3

    @patch('ingest_script.create_engine')
    @patch('ingest_script.pd.read_csv')
    @patch('ingest_script.time')
    @patch('pandas.DataFrame.to_sql')
    def test_ingest_callable_datetime_conversion(self, mock_to_sql, mock_time, mock_read_csv, mock_create_engine):
        """Test that datetime columns are properly converted"""
        mock_engine = Mock()
        mock_connection = Mock()
        mock_create_engine.return_value = mock_engine
        mock_engine.connect.return_value = mock_connection
        
        mock_time.side_effect = [1000.0, 1001.0, 1002.0, 1003.0]
        
        sample_df = pd.DataFrame({
            'tpep_pickup_datetime': ['2021-01-01 00:30:10'],
            'tpep_dropoff_datetime': ['2021-01-01 00:45:39'],
            'passenger_count': [1],
            'trip_distance': [2.10],
            'fare_amount': [8.0]
        })
        
        mock_iterator = Mock()
        mock_iterator.__next__ = Mock(side_effect=[sample_df, StopIteration()])
        mock_read_csv.return_value = mock_iterator
        
        with patch('pandas.to_datetime') as mock_to_datetime:
            mock_to_datetime.return_value = pd.to_datetime(['2021-01-01 00:30:10'])
            
            user = "test_user"
            password = "test_password"
            host = "localhost"
            port = "5432"
            db = "test_db"
            table_name = "test_table"
            csv_file = "/tmp/test.csv"
            execution_date = "2021-01-01"
            
            ingest_callable(user, password, host, port, db, table_name, csv_file, execution_date)
            
            assert mock_to_datetime.call_count >= 2
            assert mock_to_sql.call_count >= 2

    def test_ingest_callable_parameter_validation(self):
        """Test ingest_callable with various parameter combinations"""
        with patch('ingest_script.create_engine') as mock_create_engine:
            mock_create_engine.side_effect = Exception("Invalid connection string")
            
            with pytest.raises(Exception):
                ingest_callable("", "", "", "", "", "", "", "")

    @patch('ingest_script.create_engine')
    @patch('ingest_script.pd.read_csv')
    @patch('ingest_script.time')
    @patch('pandas.DataFrame.to_sql')
    def test_ingest_callable_sql_insertion_failure(self, mock_to_sql, mock_time, mock_read_csv, mock_create_engine):
        """Test ingest_callable when SQL insertion fails"""
        mock_engine = Mock()
        mock_connection = Mock()
        mock_create_engine.return_value = mock_engine
        mock_engine.connect.return_value = mock_connection
        
        mock_time.side_effect = [1000.0, 1001.0, 1002.0, 1003.0]
        
        sample_df = pd.DataFrame({
            'tpep_pickup_datetime': ['2021-01-01 00:30:10'],
            'tpep_dropoff_datetime': ['2021-01-01 00:45:39'],
            'passenger_count': [1],
            'trip_distance': [2.10],
            'fare_amount': [8.0]
        })
        
        mock_to_sql.side_effect = Exception("SQL insertion failed")
        
        mock_iterator = Mock()
        mock_iterator.__next__ = Mock(side_effect=[sample_df, StopIteration()])
        mock_read_csv.return_value = mock_iterator
        
        user = "test_user"
        password = "test_password"
        host = "localhost"
        port = "5432"
        db = "test_db"
        table_name = "test_table"
        csv_file = "/tmp/test.csv"
        execution_date = "2021-01-01"
        
        with pytest.raises(Exception, match="SQL insertion failed"):
            ingest_callable(user, password, host, port, db, table_name, csv_file, execution_date)
