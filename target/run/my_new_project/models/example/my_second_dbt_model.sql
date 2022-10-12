

  create or replace view `basic-strata-359416`.`trips_data_all`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `basic-strata-359416`.`trips_data_all`.`my_first_dbt_model`
where id = 1;

