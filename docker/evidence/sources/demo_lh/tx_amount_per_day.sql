select
    strftime(event_time, '%Y-%m-%d') as day,
    count(*)                         as tx_count,
    round(sum(amount), 2)            as total_amount
from iceberg_catalog.demo.transactions
group by day
order by day