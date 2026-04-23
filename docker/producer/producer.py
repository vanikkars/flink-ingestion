"""
Synthetic order-event producer.

Publishes JSON order events to the Kafka `orders` topic at a configurable rate.
Each event looks like:
  {
    "order_id":    "ord-00001",
    "customer_id": "cust-042",
    "product_id":  "prod-007",
    "quantity":    3,
    "unit_price":  29.99,
    "status":      "PLACED",
    "event_time":  "2024-04-22T10:00:00.000"
  }
"""

import json
import os
import random
import time
from dataclasses import asdict, dataclass
from datetime import datetime, timezone

from kafka import KafkaProducer

BOOTSTRAP_SERVERS = os.environ.get("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
TOPIC             = os.environ.get("KAFKA_TOPIC", "orders")
EVENTS_PER_SECOND = float(os.environ.get("EVENTS_PER_SECOND", "2"))

STATUSES    = ["PLACED", "CONFIRMED", "SHIPPED", "DELIVERED", "CANCELLED"]
N_CUSTOMERS = 50
N_PRODUCTS  = 20


@dataclass
class OrderEvent:
    order_id:    str
    customer_id: str
    product_id:  str
    quantity:    int
    unit_price:  float
    status:      str
    event_time:  str


def make_event(seq: int) -> OrderEvent:
    return OrderEvent(
        order_id=f"ord-{seq:06d}",
        customer_id=f"cust-{random.randint(1, N_CUSTOMERS):03d}",
        product_id=f"prod-{random.randint(1, N_PRODUCTS):03d}",
        quantity=random.randint(1, 10),
        unit_price=round(random.uniform(5.0, 500.0), 2),
        status=random.choice(STATUSES),
        event_time=datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3],
    )


def main() -> None:
    print(f"Connecting to Kafka at {BOOTSTRAP_SERVERS} …", flush=True)

    producer = KafkaProducer(
        bootstrap_servers=BOOTSTRAP_SERVERS,
        value_serializer=lambda v: json.dumps(v).encode("utf-8"),
        acks="all",
    )

    print(f"Publishing to topic '{TOPIC}' at {EVENTS_PER_SECOND} events/sec", flush=True)

    seq = 1
    interval = 1.0 / EVENTS_PER_SECOND

    while True:
        event = make_event(seq)
        producer.send(TOPIC, value=asdict(event))
        print(f"→ {asdict(event)}", flush=True)
        seq += 1
        time.sleep(interval)


if __name__ == "__main__":
    main()