select
    (select count(*)              from iceberg_catalog.demo.users)        as total_users,
    (select count(*)              from iceberg_catalog.demo.transactions)  as total_transactions,
    (select round(sum(amount), 2) from iceberg_catalog.demo.transactions)  as total_volume,
    (select count(*)              from iceberg_catalog.demo.orders)        as total_orders,
    (select round(sum(quantity * unit_price), 2) from iceberg_catalog.demo.orders) as total_revenue