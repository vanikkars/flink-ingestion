# Kafka → Iceberg via Flink (Docker demo)

A self-contained demo that streams JSON events from a Kafka topic into an
Apache Iceberg table, with everything running locally via Docker Compose.

## Architecture

```
┌──────────────┐      JSON events       ┌─────────────────────────────┐
│ kafka-       │  ──────────────────▶   │ Kafka topic: orders         │
│ producer     │                        └────────────┬────────────────┘
│ (Python)     │                                     │ Kafka SQL connector
└──────────────┘                                     ▼
                                        ┌─────────────────────────────┐
                                        │ Flink (JobManager +         │
                                        │        TaskManager)         │
                                        │                             │
                                        │  kafka_orders  (source)     │
                                        │       ↓ INSERT INTO         │
                                        │  iceberg_catalog.demo       │
                                        │        .orders  (sink)      │
                                        └────────────┬────────────────┘
                                                     │ Iceberg / Parquet files
                                                     ▼
                                        ┌─────────────────────────────┐
                                        │ MinIO  (s3a://iceberg-      │
                                        │         warehouse/)         │
                                        └────────────┬────────────────┘
                                                     │ schema / metadata
                                                     ▼
                                        ┌─────────────────────────────┐
                                        │ Hive Metastore  (:9083)     │
                                        │  backed by Postgres         │
                                        └─────────────────────────────┘
```

## Services

| Service            | Image                              | Exposed port     |
|--------------------|------------------------------------|------------------|
| zookeeper          | confluentinc/cp-zookeeper:7.6.0    | —                |
| kafka              | confluentinc/cp-kafka:7.6.0        | 9092             |
| minio              | minio/minio                        | 9000, 9001 (UI)  |
| postgres           | postgres:15                        | —                |
| metastore          | custom (apache/hive:4.0.0 base)    | 9083             |
| flink-jobmanager   | custom (flink:1.18)                | 8081 (UI)        |
| flink-taskmanager  | custom (flink:1.18)                | —                |
| flink-sql-job      | custom (flink:1.18)                | —                |
| kafka-producer     | custom (python:3.11-slim)          | —                |

## Quick start

```bash
# Build images and start everything
docker compose up --build
```

First boot takes a few minutes — Maven JARs are downloaded into the Flink and
Metastore images, Hive schema is initialised in Postgres, and the Flink SQL job
is submitted automatically.

### Watch events being produced

```bash
docker logs -f kafka-producer
```

### Flink UI

Open **http://localhost:8081** — you should see one running job
(`INSERT INTO iceberg_catalog.demo.orders`).

### Browse Parquet files in MinIO

Open the MinIO console at **http://localhost:9001**
(user: `minioadmin` / password: `minioadmin`) and navigate to
`iceberg-warehouse/demo/orders/`.

### Query the Iceberg table from Flink SQL

```bash
docker exec -it flink-jobmanager /opt/flink/bin/sql-client.sh
```

Inside the SQL client:

```sql
CREATE CATALOG iceberg_catalog WITH (
    'type'                      = 'iceberg',
    'catalog-type'              = 'hive',
    'uri'                       = 'thrift://metastore:9083',
    'warehouse'                 = 's3a://iceberg-warehouse/',
    'io-impl'                   = 'org.apache.iceberg.aws.s3.S3FileIO',
    'fs.s3a.endpoint'           = 'http://minio:9000',
    'fs.s3a.access.key'         = 'minioadmin',
    'fs.s3a.secret.key'         = 'minioadmin',
    'fs.s3a.path.style.access'  = 'true'
);

USE CATALOG iceberg_catalog;
USE demo;

-- Batch read of committed Iceberg snapshots
SELECT status, COUNT(*) AS cnt
FROM orders
GROUP BY status;
```

> Iceberg commits happen on Flink checkpoints (default every 60 s).
> Wait at least a minute after startup before querying.

## Event schema (Kafka JSON)

```json
{
  "order_id":    "ord-000042",
  "customer_id": "cust-017",
  "product_id":  "prod-005",
  "quantity":    3,
  "unit_price":  149.99,
  "status":      "PLACED",
  "event_time":  "2024-04-22T10:00:00.000"
}
```

## Tear down

```bash
docker compose down -v
```