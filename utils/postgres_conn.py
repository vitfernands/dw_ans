from sqlalchemy import create_engine
from utils.logger import logger

def create_postgres_connection(usuario: str, senha: str, server:str, port: str, database: str): 
    try:
        engine = create_engine(f'postgresql://{usuario}:{senha}@{server}:{port}/{database}')
        return engine
    except Exception as e:
        logger.error(f"Não foi possível estabelecer conexao com o banco de dados: {database}, erro: {e}")