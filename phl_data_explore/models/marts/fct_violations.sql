{{ config(materialized='table') }}

with violations as (
    select * from {{ ref('stg_violations') }}
)

select
    violation_id,
    violation_date,
    violation_month,
    violation_type,
    violation_code,
    council_district,
    zip_code,
    case_type,
    case_priority
from violations