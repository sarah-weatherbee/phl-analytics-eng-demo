"""
Pull Philadelphia L&I code violations from Carto SQL API into BigQuery.

Source: OpenDataPhilly / City of Philadelphia, Dept. of Licenses & Inspections.
Lands raw data in raw_phl.violations. Limited to 2025-forward.
"""
import os
import requests
import pandas as pd
from dotenv import load_dotenv
from google.cloud import bigquery

load_dotenv()

PROJECT = "data-warehouse-etl-338517"
RAW_TABLE = "raw_phl.violations"
CARTO_URL = "https://phl.carto.com/api/v2/sql"

# fields
COLUMNS = [
    "violationnumber",
    "violationdate",
    "violationcodetitle",
    "violationcode",
    "council_district",
    "zip",
    "casetype",
    "caseprioritydesc",
]

def fetch() -> pd.DataFrame:
    query = (
        f"SELECT {', '.join(COLUMNS)} "
        f"FROM violations "
        f"WHERE violationdate >= '2025-01-01'"
    )
    print("Requesting violation data")
    resp = requests.get(
        CARTO_URL,
        params={"q": query, "format": "json"},
        timeout=300,
    )
    resp.raise_for_status()
    rows = resp.json()["rows"]
    df = pd.DataFrame(rows)
    print(f"Fetched {len(df):,} rows.")
    return df

def load(df: pd.DataFrame) -> None:
    client = bigquery.Client(project=PROJECT)  # reads key
    job = client.load_table_from_dataframe(
        df,
        RAW_TABLE,
        job_config=bigquery.LoadJobConfig(write_disposition="WRITE_TRUNCATE"),
    )
    job.result()
    print(f"Loaded {job.output_rows:,} rows into {PROJECT}.{RAW_TABLE}.")

if __name__ == "__main__":
    load(fetch())