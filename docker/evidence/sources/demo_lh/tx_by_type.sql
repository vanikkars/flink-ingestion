select
    type,
    count(*)              as tx_count,
    round(sum(amount), 2) as total_amount
from iceberg_catalog.demo.transactions
group by type
order by total_amount desc