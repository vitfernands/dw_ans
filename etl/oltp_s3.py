import os
import csv
from dotenv import load_dotenv
from utils.logger import logger
from utils.postgres_conn import create_postgres_connection
from utils.s3_conn import s3_conn
import s3fs
import tempfile
import io

load_dotenv()

def ingestao_staging(path: str, table_name: str, conn) -> None:
    delimitador = obter_delimitador(path=path)

    cursor = conn.cursor()
    try:
        #f = preprocessar_csv(path)

        with open (path, 'r', encoding='utf-8') as f:

            cursor.copy_expert(
                sql=f"""
                    COPY {table_name}
                    FROM STDIN
                    WITH CSV
                    HEADER
                    DELIMITER '{delimitador}'
                    ENCODING 'UTF-8'
                """,
                file=f
            )

            conn.commit()
    except Exception as e:
        conn.rollback()

        logger.error(f"Erro ao inserir dados na tabela: {table_name}: {e}")
    finally:
        cursor.close()

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

                table_name = s3_key.split('/')[-2].lower().replace('-', '_').replace(' ', '_')

                s3_path = f"s3://{bucket_name}/{s3_key}"

                s3_temp = download_s3_temp(bucket_name, s3_key, s3)

                logger.info(f"Processando: {s3_path}")
                logger.info(f"Inserindo na tabela: {table_name}")

                ingestao_staging(
                    path=s3_temp,
                    table_name=table_name,
                    conn=conn
                )
                
                os.remove(s3_temp)
    except Exception as e:
        logger.error(f"Erro ao coletar dados do s3: {e}")

def obter_delimitador(path: str):
    if path.startswith('s3://'):
        fs = s3fs.S3FileSystem()

        with fs.open(path, 'r', encoding='utf-8') as f:
            sample = f.read(5000)

        sniffer = csv.Sniffer()
        return sniffer.sniff(sample).delimiter
    
    with open(path, 'r', encoding='utf-8') as f:
        sample = f.read(5000)

    sniffer = csv.Sniffer()
    return sniffer.sniff(sample).delimiter
    
def download_s3_temp(bucket, key, s3):
    temp = tempfile.NamedTemporaryFile(
        delete=False,
        suffix='.csv'
    )

    s3.download_fileobj(
        bucket,
        key,
        temp
    )

    temp.close()

    return temp.name

def fix_numeric_decimal(value: str) -> str:
    cleaned = value.strip().replace('.', '').replace(',', '.')
    try:
        float(cleaned)
        return cleaned
    except ValueError:
        return value
    
def preprocessar_csv(path: str) -> io.StringIO:
    buffer = io.StringIO

    with open(path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f, delimiter=';')
        writer = csv.writer(buffer, delimiter=';')

        for i, row in enumerate(reader):
            if i == 0:
                writer.writerow(row)
                continue
            writer.writerow([fix_numeric_decimal(cell) for cell in row])

    buffer.seek(0)
    return buffer
