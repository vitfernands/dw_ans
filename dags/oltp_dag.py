from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.hooks.postgres import PostgresHook
from etl.oltp import percorrer_bucket
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv

load_dotenv()

BUCKET_NAME = os.getenv("S3_BUCKET_NAME")

default_args = {
    "owner": "vitorp",
    "depends_on_past": False,
    "retries": 2,
    "retry_delay": timedelta(minutes=5)
}

def exec_ingestao():
    percorrer_bucket(bucket_name=BUCKET_NAME)

#DAG

with DAG (
    dag_id="ingestao_stage",
    default_args=default_args,
    description="Realizar a ingestão dos dados para o banco de dados postgreSQL stage",
    start_date=datetime(2026, 5, 15),
    schedule='@daily',
    catchup=False,
    tags=["oltp", "stage"]
) as dag:
    task_ingestao = PythonOperator(
        task_id="ingestao_dados_stage",
        python_callable=exec_ingestao
    )

    task_ingestao

