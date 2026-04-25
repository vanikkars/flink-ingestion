select
    strftime(event_time, '%Y-%m-%d')     as day,
    count(*)                             as order_count,
    round(sum(quantity * unit_price), 2) as revenue
from iceberg_catalog.demo.orders
group by day
order by day