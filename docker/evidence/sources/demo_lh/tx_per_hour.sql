select
    strftime(event_time, '%Y-%m-%d %H:00') as hour,
    count(*)                               as tx_count
from iceberg_catalog.demo.transactions
group by hour
order by hour