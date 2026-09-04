import os
import logging
import csv
import psycopg2
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s — %(message)s",
)

class Pipeline_stage:
    def __init__(self, data_path: Path):
        self.data_path = data_path
        self.logger = logging.getLogger(__name__)

    def _carregar_csv(self, cursor, tabela, arquivo):
        with open(arquivo, "r", encoding="utf-8") as f:

            delimiter = self._get_delimiter(arquivo)

            cursor.copy_expert(
                 f"""
                 COPY {tabela}
                 FROM stdin
                 WITH (
                    FORMAT CSV,
                    HEADER TRUE,
                    DELIMITER '{delimiter}',
                    QUOTE '"'
                 )
                 """,
                 f
            )

    def execute(self):
        conn = self._connect_postgres()

        try:
            cursor = conn.cursor()

            for pasta_tabela in self.data_path.iterdir():

                if not pasta_tabela.is_dir():
                    continue

                tabela = pasta_tabela.name

                arquivos_csv = sorted(pasta_tabela.glob("*.csv"))

                # Realizando TRUNCATE das tabelas antes da inserção dos dados csv

                for arquivo in arquivos_csv:
                    self.logger.info(f'TRUNCATE na tabela: {tabela}')

                    try:
                        self._truncate_table(
                            cursor=cursor,
                            conn=conn,
                            tabela=tabela
                        )

                        conn.commit()

                        self.logger.info(f'Realizado TRUNC na tabela {tabela}')

                    except Exception as e:
                        self.logger.error(f'Erro ao fazer o TRUNCATE na tabela {tabela}, erro: {e}')
                        conn.rollback()

                # Inserção dos dados CSV nas tabelas STAGE do Postgres

                for arquivo in arquivos_csv:
                    self.logger.info(f'Carregando tabela: {tabela}')

                    try:
                        self._carregar_csv(
                            cursor=cursor,
                            tabela=tabela,
                            arquivo=arquivo
                        )

                        conn.commit()

                        self.logger.info(f'Tabela "{tabela}" carregada')

                    except Exception as e:
                        self.logger.error(f'Erro ao inserir dados na tabela stage: {tabela}, erro: {e}')
                        conn.rollback()

            cursor.close()
        except Exception as e:
            self.logger.error(f"Erro ao executar o pipeline: {e}")
        finally:
            conn.close()
    
    def _connect_postgres(self):
        try:
            conn = psycopg2.connect(
                user=os.getenv("POSTGRES_USER"),
                password=os.getenv("POSTGRES_PASSWORD"),
                host=os.getenv("POSTGRES_ADDRESS"),
                port=5432,
                database=os.getenv("POSTGRES_DATABASE"),
                options="-c search_path=stage,public"
            )
            return conn
        except Exception as e:
            self.logger.error(f'Não foi possível estabelecer a conexão com o Posgresql: {e}')

    def _get_delimiter(self, path):
        with open(path, 'r', encoding='utf-8') as f:
            sample = f.read(5000)

        sniffer = csv.Sniffer()
        return sniffer.sniff(sample).delimiter

    def _truncate_table(self, cursor, conn, tabela):
        cursor.execute(f"TRUNCATE TABLE {tabela}")

        conn.commit()
        
