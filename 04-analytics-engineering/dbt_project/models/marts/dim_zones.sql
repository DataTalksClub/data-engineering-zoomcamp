select
    locationid,
    borough,
    zone,
    service_zone
from {{ ref('taxi_zone_lookup') }}