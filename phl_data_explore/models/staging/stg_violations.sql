
with source as (
  select * from {{ source('raw_phl', 'violations') }}
),

cleaned as (
  select
      violationnumber as violation_id,
      date(timestamp(violationdate)) as violation_date,
      date_trunc(date(timestamp(violationdate)), month) as violation_month,
      violationcodetitle as violation_type,
      violationcode as violation_code,
      coalesce(council_district, 'Unknown') as council_district,
      coalesce(left(zip, 5), 'Unknown') as zip_code,
      casetype as case_type,
      caseprioritydesc  as case_priority
  from source
  where violationdate is not null
)

select * from cleaned