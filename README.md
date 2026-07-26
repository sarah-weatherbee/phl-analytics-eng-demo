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

**Scope:** violations issued 2025-forward (~150k rows).


## Approach

This project looks at violation *activity* only: volume, timing, location (zip), and type.
Violation-level and case-level status have been deliberately excluded at this time.
rather than guessed at.

## Setup

_(to be completed)_

## Project structure

_(to be completed)_