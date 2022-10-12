{{
	config(
		materialized = 'view',
		enabled=(target.type == 'redshift')
	)
}}

select *
from {{ ref('data_insert_by_period') }}
where id in (2, 3, 4, 5, 6)
