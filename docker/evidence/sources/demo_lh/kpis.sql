select
    (select count(*)              from iceberg_catalog.demo.users)        as total_users,
    (select count(*)              from iceberg_catalog.demo.transactions)  as total_transactions,
    (select round(sum(amount), 2) from iceberg_catalog.demo.transactions)  as total_volume