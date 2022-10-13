{{ config(materialized='ephemeral') }}

select

  first_name,
  last_name,
  email

from {{ ref('data_people') }}
