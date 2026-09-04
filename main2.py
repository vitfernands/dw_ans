from pathlib import Path
from etl.stage import Pipeline_stage

DATA_DIR = Path("data")

pipeline = Pipeline_stage(DATA_DIR)

pipeline.execute()