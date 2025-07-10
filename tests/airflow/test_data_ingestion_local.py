import pytest
import os
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime, timedelta

import sys
sys.path.append('/home/ubuntu/data-engineering-zoomcamp/cohorts/2022/week_2_data_ingestion/airflow/dags_local')


class TestDataIngestionLocal:
    """Test cases for data_ingestion_local.py DAG configuration"""

    @patch.dict(os.environ, {
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    })
    @patch('airflow.operators.python.PythonOperator')
    @patch('airflow.operators.bash.BashOperator')
    @patch('airflow.DAG')
    def test_dag_creation_and_configuration(self, mock_dag, mock_bash_op, mock_python_op):
        """Test that the DAG is created with correct configuration"""
        mock_dag_instance = MagicMock()
        mock_dag_instance.__enter__ = Mock(return_value=mock_dag_instance)
        mock_dag_instance.__exit__ = Mock(return_value=None)
        mock_dag.return_value = mock_dag_instance
        
        mock_bash_task = Mock()
        mock_bash_task.__rshift__ = Mock(return_value=mock_bash_task)
        mock_python_task = Mock()
        mock_python_task.__rshift__ = Mock(return_value=mock_python_task)
        
        mock_bash_op.return_value = mock_bash_task
        mock_python_op.return_value = mock_python_task
        
        import data_ingestion_local
        
        mock_dag.assert_called_once()
        dag_call_args = mock_dag.call_args
        
        assert dag_call_args[0][0] == 'LocalIngestionDag'
        assert dag_call_args[1]['schedule_interval'] == '0 6 2 * *'
        
        assert 'start_date' in dag_call_args[1]

    @patch.dict(os.environ, {
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    })
    @patch('airflow.operators.bash.BashOperator')
    def test_wget_task_configuration(self, mock_bash_op):
        """Test wget task configuration"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
            
        mock_bash_task = Mock()
        mock_bash_op.return_value = mock_bash_task
        
        import data_ingestion_local
        
        mock_bash_op.assert_called()
        
        bash_call_args = mock_bash_op.call_args[1]
        
        assert bash_call_args['task_id'] == 'wget'
        assert 'curl' in bash_call_args['bash_command']
        assert 'yellow_tripdata_' in bash_call_args['bash_command'] and 'execution_date.strftime' in bash_call_args['bash_command']

    @patch.dict(os.environ, {
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    })
    @patch('airflow.operators.python.PythonOperator')
    def test_ingest_task_configuration(self, mock_python_op):
        """Test ingest task configuration"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
            
        mock_python_task = Mock()
        mock_python_op.return_value = mock_python_task
        
        import data_ingestion_local
        
        mock_python_op.assert_called()
        
        python_call_args = mock_python_op.call_args[1]
        
        assert python_call_args['task_id'] == 'ingest'
        assert python_call_args['python_callable'].__name__ == 'ingest_callable'
        
        op_kwargs = python_call_args['op_kwargs']
        assert op_kwargs['user'] == 'test_user'
        assert op_kwargs['password'] == 'test_password'
        assert op_kwargs['host'] == 'localhost'
        assert op_kwargs['port'] == '5432'
        assert op_kwargs['db'] == 'test_db'
        assert 'yellow_taxi_' in op_kwargs['table_name'] and 'execution_date.strftime' in op_kwargs['table_name']
        assert '/opt/airflow/' in op_kwargs['csv_file'] and 'output_' in op_kwargs['csv_file'] and 'execution_date.strftime' in op_kwargs['csv_file']

    @patch.dict(os.environ, {})
    def test_missing_environment_variables(self):
        """Test behavior when required environment variables are missing"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
        
        try:
            import data_ingestion_local
        except KeyError as e:
            expected_vars = ['PG_HOST', 'PG_USER', 'PG_PASSWORD', 'PG_PORT', 'PG_DATABASE']
            assert any(var in str(e) for var in expected_vars)

    @patch.dict(os.environ, {
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    })
    def test_task_dependencies(self):
        """Test that task dependencies are set up correctly"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
            
        with patch('airflow.operators.bash.BashOperator') as mock_bash_op, \
             patch('airflow.operators.python.PythonOperator') as mock_python_op:
            
            mock_bash_task = Mock()
            mock_bash_task.__rshift__ = Mock(return_value=mock_bash_task)
            mock_python_task = Mock()
            mock_python_task.__rshift__ = Mock(return_value=mock_python_task)
            
            mock_bash_op.return_value = mock_bash_task
            mock_python_op.return_value = mock_python_task
            
            import data_ingestion_local
            
            mock_bash_task.__rshift__.assert_called_once_with(mock_python_task)

    @patch.dict(os.environ, {
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    })
    def test_dag_schedule_once(self):
        """Test that DAG is scheduled to run once"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
        
        with patch('airflow.DAG') as mock_dag:
            mock_dag_instance = MagicMock()
            mock_dag_instance.__enter__ = Mock(return_value=mock_dag_instance)
            mock_dag_instance.__exit__ = Mock(return_value=None)
            mock_dag.return_value = mock_dag_instance
            
            import data_ingestion_local
            
            dag_call_args = mock_dag.call_args
            assert dag_call_args[1]['schedule_interval'] == '0 6 2 * *'

    @patch.dict(os.environ, {
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    })
    def test_file_paths_configuration(self):
        """Test that file paths are configured correctly"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
        
        with patch('airflow.operators.bash.BashOperator') as mock_bash_op, \
             patch('airflow.operators.python.PythonOperator') as mock_python_op:
            
            import data_ingestion_local
            
            bash_call_args = mock_bash_op.call_args[1]
            bash_command = bash_call_args['bash_command']
            
            assert 'yellow_tripdata_' in bash_command and 'execution_date.strftime' in bash_command
            
            python_call_args = mock_python_op.call_args[1]
            op_kwargs = python_call_args['op_kwargs']
            
            assert '/opt/airflow/' in op_kwargs['csv_file'] and 'output_' in op_kwargs['csv_file'] and 'execution_date.strftime' in op_kwargs['csv_file']

    @patch.dict(os.environ, {
        'PG_HOST': 'localhost',
        'PG_USER': 'test_user',
        'PG_PASSWORD': 'test_password',
        'PG_PORT': '5432',
        'PG_DATABASE': 'test_db'
    })
    def test_ingest_callable_import(self):
        """Test that ingest_callable is properly imported"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
        
        with patch('airflow.operators.python.PythonOperator') as mock_python_op:
            import data_ingestion_local
            
            python_call_args = mock_python_op.call_args[1]
            python_callable = python_call_args['python_callable']
            
            assert python_callable.__name__ == 'ingest_callable'
            
            assert python_callable.__module__ == 'ingest_script'

    @patch.dict(os.environ, {
        'PG_HOST': 'custom_host',
        'PG_USER': 'custom_user',
        'PG_PASSWORD': 'custom_password',
        'PG_PORT': '3306',
        'PG_DATABASE': 'custom_db'
    })
    def test_custom_environment_variables(self):
        """Test DAG with custom environment variables"""
        if 'data_ingestion_local' in sys.modules:
            del sys.modules['data_ingestion_local']
        
        with patch('airflow.operators.python.PythonOperator') as mock_python_op:
            import data_ingestion_local
            
            python_call_args = mock_python_op.call_args[1]
            op_kwargs = python_call_args['op_kwargs']
            
            assert op_kwargs['user'] == 'custom_user'
            assert op_kwargs['password'] == 'custom_password'
            assert op_kwargs['host'] == 'custom_host'
            assert op_kwargs['port'] == '3306'
            assert op_kwargs['db'] == 'custom_db'
