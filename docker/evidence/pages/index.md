---
title: Flink Lakehouse Dashboard
---

# Flink LakeHouse Dashboard

Real-time data ingested from Kafka into Iceberg via Apache Flink.

---

## Key Metrics

<BigValue
  data={kpis}
  value=total_users
  title="Total Users"
/>

<BigValue
  data={kpis}
  value=total_transactions
  title="Total Transactions"
/>

<BigValue
  data={kpis}
  value=total_volume
  title="Transaction Volume ($)"
  fmt=usd2
/>


---

## Transactions

### High level View

<Grid cols=2>
  <BarChart
    data={tx_by_type}
    x=type
    y=total_amount
    title="Volume by Transaction Type ($)"
    yFmt=usd0k
  />
  <BarChart
    data={tx_by_status}
    x=status
    y=tx_count
    title="Transactions by Status"
  />
</Grid>

[//]: # (#### Transaction Amount per Day)

<LineChart
  data={tx_amount_per_day}
  x=day
  y=total_amount
  title="Daily Transaction Volume ($)"
  yFmt=usd0k
/>

[//]: # (#### Transaction Count per Day)

<BarChart
  data={tx_amount_per_day}
  x=day
  y=tx_count
  title="Daily Transaction Count"
/>

### Detailed View

[//]: # (#### Transactions per Hour)

<BarChart
  data={tx_per_hour}
  x=hour
  y=tx_count
  title="Transaction Count per Hour"
/>

[//]: # (#### Transactions Volume per Country)

<BarChart
  data={tx_per_country}
  x=country
  y=total_amount
  title="Transaction Volume by Country ($)"
/>

[//]: # (#### Transactions Count per Country)

<BarChart
  data={tx_per_country}
  x=country
  y=tx_count
  title="Transaction Count by Country"
/>

[//]: # (#### Top 20 Users by Transaction Amount)

<BarChart
  data={tx_amount_per_user}
  x=user_id
  y=total_amount
  title="Transaction Amount per User (Top 20)"
  swapXY=true
  yFmt=usd0k
/>


---

## Users

[//]: # (### Users per Country)

<BarChart
  data={users_by_country}
  x=country
  y=user_count
  title="Users by Country"
  swapXY=true
/>


---
<details>
<summary>KPIs sql defintion </summary>
Thease queries are used as source for the charts above. Thus do not delete them.
The complexity of queries is hidden by the sql files in source. The queries below mostly reference the output fo these quries.

```sql kpis
select * from demo_lh.kpis
```

```sql tx_amount_per_day
select * from demo_lh.tx_amount_per_day
```

```sql tx_amount_per_user
select * from demo_lh.tx_amount_per_user
```

```sql tx_per_hour
select * from demo_lh.tx_per_hour
```

```sql tx_per_country
select * from demo_lh.tx_per_country
```

```sql tx_by_type
select * from demo_lh.tx_by_type
```

```sql tx_by_status
select * from demo_lh.tx_by_status
```

```sql users_by_country
select * from demo_lh.users_by_country
```

</details>
