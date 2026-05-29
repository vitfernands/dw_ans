from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime, timedelta

default_args = {
    "owner": "vitorp",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=5)
}

with DAG  (
    dag_id="stage_to_dw",
    default_args=default_args,
    start_date=datetime(2026, 5, 15),
    catchup=False,
    schedule='@daily'
) as dag:
    
    '''Tasks que farão o full load e incremental dos dados stage -> DW'''