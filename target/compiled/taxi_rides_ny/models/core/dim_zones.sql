


select 
    locationid, 
    borough, 
    zone, 
    replace(service_zone,'Boro','Green') as service_zone
from `basic-strata-359416`.`trips_data_all`.`taxi_zone`