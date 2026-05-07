import os
import csv
import pandas as pd
from dotenv import load_dotenv
from utils.logger import logger
from utils.postgres_conn import create_postgres_connection
from utils.s3_conn import s3_conn
from pathlib import Path
import s3fs

load_dotenv()

def ingestao_oltp(path: str, table_name: str, conn) -> None:
    delimitador = obter_delimitador(path=path)

    try:
        df = pd.read_csv(path, delimiter=delimitador)

        df.to_sql(
            name=table_name,
            con=conn,
            if_exists='replace',
            index=False
        )

        logger.info(f"Realizado ingestão na tabela: {table_name}")
    except Exception as e:
        logger.error(f"Erro ao tentar inserir dados na tabela: {table_name}, {e}")

def percorrer_bucket(bucket_name: str) -> None:
    s3 = s3_conn()
    conn = create_postgres_connection(
        usuario=os.getenv("POSTGRES_USER"),
        senha=os.getenv("POSTGRES_PASSWORD"),
        server=os.getenv("POSTGRES_SERVER"),
        port=os.getenv("POSTGRES_PORT"),
        database=os.getenv("OLTP_DATABASE")
    )

    try:
        paginator = s3.get_paginator('list_objects_v2')

        page_iterator = paginator.paginate(Bucket=bucket_name)

        for page in page_iterator:
            for obj in page.get('Contents', []):
                s3_key = obj['Key']

                if not s3_key.endswith('.csv'):
                    continue

                table_name = s3_key.split('/')[-2].lower()

                s3_path = f"s3://{bucket_name}/{s3_key}"

                logger.info(f"Processando: {s3_path}")
                logger.info(f"Inserindo na tabela: {table_name}")

                ingestao_oltp(
                    path=s3_path,
                    table_name=table_name,
                    conn=conn
                )
    except Exception as e:
        logger.error(f"Erro ao coletar dados do s3: {e}")

def obter_delimitador(path: str):
    if path.startswith('s3://'):
        fs = s3fs.S3FileSystem()

        with fs.open(path, 'r', encoding='latin1') as f:
            sample = f.read(5000)

        sniffer = csv.Sniffer()
        return sniffer.sniff(sample).delimiter