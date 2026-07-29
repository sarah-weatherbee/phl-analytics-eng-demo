# Philadelphia L&I Violations - Ingestion and Exploration

Basic engineering project modeling Philadelphia
Licenses & Inspections (L&I) code violations: ingestion from API,
transformation and testing in dbt on BigQuery


## Architecture

OpenDataPhilly (Carto SQL API)
  --> Python ingestion → BigQuery (raw)
  --> dbt (staging + marts + tests)
  --> HEX (to come)


## Data source

Violations issued by the Philadelphia Department of Licenses & Inspections,
under the Building Construction and Occupancy Code. Public data via
[OpenDataPhilly](https://opendataphilly.org/datasets/licenses-and-inspections-code-violations/),
served through the Carto SQL API. Updated daily; maintained by the L&I GIS team.

- Field dictionary (used for column descriptions in dbt models): [metadata.phila.gov L&I Violations]
- API endpoint: https://phl.carto.com/api/v2/sql

**Scope:** violations issued 2025-forward.


## Approach

This project looks at violation *activity* only: volume, timing, location (zip), and type.
Violation-level and case-level status have been deliberately excluded at this time.

Data quality notes:
As of initial data query (July 25, 2026), zipcode and councildistrict were missing values on <1% of records. Those have been labeled 'Unknown'.

## Setup

_(to be completed)_

## Project structure

_(to be completed)_