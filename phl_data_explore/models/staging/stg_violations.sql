/*
Staging model for L&I code violations.
Cleans and standardizes raw API data: casts types, trims ZIP,
handles missing zip and council district, and deduplicates on violation_id.
*/

with source as (
  select * from {{ source('raw_phl', 'violations') }}
),

cleaned as (
  select
      violationnumber as violation_id,
      -- Source stores violationdate as a timestamp string; parse to timestamp, then take the date
      date(timestamp(violationdate)) as violation_date,
      date_trunc(date(timestamp(violationdate)), month) as violation_month,
      violationcode as violation_code,
      coalesce(violationcodetitle, 'Unknown') as violation_type,
      coalesce(council_district, 'Unknown') as council_district,
      coalesce(left(zip, 5), 'Unknown') as zip_code,
      casetype as case_type,
      caseprioritydesc  as case_priority
  from source

  --exclude any row without a violation date. protects the date-dependent logic downstream.
  where violationdate is not null
),

deduplicated as (
  /*
    There were 2 duplicate violation_id values in the raw data (2025-01-01 through 2025-06-30).
    The are records are identical across every field we ingest (violation number, date, code, status, location)
    The duplicates are likely due to L&I attaching more than one notice to a violation.
    Since we don't ingest publicnov and are counting violations (not notices), these are true duplicates for our
    purposes. row_number() keeps one row per violation_id, enforcing the one-row-per-violation grain.
  */
    select
        *,
        row_number() over (
            partition by violation_id
            order by violation_id
        ) as row_num
    from cleaned
)

select * except(row_num)
from deduplicated
where row_num = 1