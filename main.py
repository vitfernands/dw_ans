from etl.oltp import percorrer_bucket
from dotenv import load_dotenv
import os

def main():
    bucket = os.getenv("S3_BUCKET_NAME")
    percorrer_bucket(bucket_name=bucket)

if __name__ == "__main__":
    main()