-- ──────────────────────────────────────────────────────────────────────────
-- Flink SQL: Kafka → Iceberg (orders topic)
-- ──────────────────────────────────────────────────────────────────────────

-- 0. Enable checkpointing every 30 seconds (required for Iceberg sink to commit data)
SET 'execution.checkpointing.interval' = '30s';

-- 1. Register the Iceberg catalog backed by Nessie + MinIO
--    Use catalog-impl to reference NessieCatalog directly (bundled in
--    iceberg-flink-runtime), bypassing the limited catalog-type allowlist.
CREATE CATALOG iceberg_catalog WITH (
    'type'                          = 'iceberg',
    'catalog-impl'                  = 'org.apache.iceberg.nessie.NessieCatalog',
    'uri'                           = 'http://nessie:19120/api/v1',
    'ref'                           = 'main',
    'warehouse'                     = 's3a://iceberg-warehouse/',
    'io-impl'                       = 'org.apache.iceberg.hadoop.HadoopFileIO'
);

-- 2. Create the target database in the Iceberg catalog
CREATE DATABASE IF NOT EXISTS iceberg_catalog.demo;

-- 3. Source table — reads raw JSON messages from the Kafka topic
CREATE TEMPORARY TABLE kafka_orders (
    order_id        STRING,
    customer_id     STRING,
    product_id      STRING,
    quantity        INT,
    unit_price      DOUBLE,
    status          STRING,
    event_time      TIMESTAMP(3),
    WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND
) WITH (
    'connector'                     = 'kafka',
    'topic'                         = 'orders',
    'properties.bootstrap.servers'  = 'kafka:29092',
    'properties.group.id'           = 'flink-iceberg-consumer',
    'scan.startup.mode'             = 'earliest-offset',
    'format'                        = 'json',
    'json.timestamp-format.standard' = 'ISO-8601'
);

-- 4. Sink table — Iceberg table stored in MinIO
CREATE TABLE IF NOT EXISTS iceberg_catalog.demo.orders (
    order_id        STRING,
    customer_id     STRING,
    product_id      STRING,
    quantity        INT,
    unit_price      DOUBLE,
    status          STRING,
    event_time      TIMESTAMP(3)
) WITH (
    'write.format.default'          = 'parquet',
    'write.upsert.enabled'          = 'false'
);

-- 5. Continuous INSERT — the actual streaming job
INSERT INTO iceberg_catalog.demo.orders
SELECT
    order_id,
    customer_id,
    product_id,
    quantity,
    unit_price,
    status,
    event_time
FROM kafka_orders;