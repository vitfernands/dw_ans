import psycopg2
from utils.logger import logger

def create_postgres_connection(usuario: str, senha: str, server:str, port: str, database: str): 
    try:
        conn = psycopg2.connect(
            user=usuario,
            password=senha,
            host=server,
            port=port,
            database=database
        )

        return conn
    except Exception as e:
        logger.error(f"Não foi possível estabelecer conexao com o banco de dados: {database}, erro: {e}")