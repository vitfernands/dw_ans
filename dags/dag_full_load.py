from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.hooks.postgres import PostgresHook
from etl.oltp import percorrer_bucket
from datetime import datetime, timedelta
from pathlib import Path
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import PostgresUserPasswordProfileMapping
import os
from dotenv import load_dotenv

load_dotenv()

BUCKET_NAME = os.getenv("S3_BUCKET_NAME")

DBT_PROJECT_PATH = Path("/opt/airflow/dw_ans/dbt_dw_ans")

profile_config = ProfileConfig(
    profile_name="dbt_dw_ans",
    taget_name="dev",
    profile_mapping=PostgresUserPasswordProfileMapping(
        conn_id="dw_ans",
        profile_args={"schema": "public"}
    )
)

default_args = {
    "owner": "vitorp",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

def exec_ingestao():
    percorrer_bucket(bucket_name=BUCKET_NAME)

#DAG

dag_dbt_postgresql = DbtDag(
    project_config=ProjectConfig(DBT_PROJECT_PATH),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        dbt_executable_path="/opt/airflow/.venv/bin/dbt",
    ),
    schedule_interval='@daily',
    start_date=datetime(2026, 6, 14),
    catchup=False,
    dag_id='dag_postgres_dbt_full_load',
    default_args=default_args,
)               

