

  create or replace table `basic-strata-359416`.`trips_data_all`.`dim_zones`
  
  
  OPTIONS()
  as (
    

select 
    locationid, 
    borough, 
    zone, 
    replace(service_zone,'Boro','Green') as service_zone
from `basic-strata-359416`.`trips_data_all`.`taxi_zone_lookup`
  );
  