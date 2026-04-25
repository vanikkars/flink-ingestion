select
    country,
    count(*) as user_count
from iceberg_catalog.demo.users
group by country
order by user_count desc