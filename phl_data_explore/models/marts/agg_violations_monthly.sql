{{ config(materialized='table') }}

/*
Monthly aggregate of violation counts by district and type.
Pre-summarized and materialized as table for the dashboard. (Avoid scans of fct table on each query)
*/

with violations as (
    select * from {{ ref('fct_violations') }}
)

select
    violation_month,
    council_district,
    violation_type,
    count(*) as violation_count
from violations
group by
    violation_month,
    council_district,
    violation_type