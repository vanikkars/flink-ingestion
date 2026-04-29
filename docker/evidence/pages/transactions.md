---
title: Transactions
---

Transactions dashboard provides insights into the transaction patterns, volumes, and trends. The data is sourced from the `demo_lh` database, which is continuously updated with near real-time transaction data.


## High level View

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

<BubbleChart
  data={tx_by_country_bubble}
  x=avg_tx_volume
  y=avg_tx_count
  size=total_volume
  series=country
  xAxisTitle="Avg Transaction Volume ($)"
  yAxisTitle="Avg Number of Transactions"
  title="Transaction Behaviour by Country"
/>

<LineChart
  data={tx_amount_per_day}
  x=day
  y=total_amount
  title="Daily Transaction Volume ($)"
  yFmt=usd0k
/>

<BarChart
  data={tx_amount_per_day}
  x=day
  y=tx_count
  title="Daily Transaction Count"
/>



## Detailed View

<BarChart
  data={tx_per_hour}
  x=hour
  y=tx_count
  title="Transaction Count per Hour"
/>

<BarChart
  data={tx_per_country}
  x=country
  y=total_amount
  title="Transaction Volume by Country ($)"
/>

<BarChart
  data={tx_per_country}
  x=country
  y=tx_count
  title="Transaction Count by Country"
/>

<BarChart
  data={tx_amount_per_user}
  x=user_id
  y=total_amount
  title="Transaction Amount per User (Top 20)"
  swapXY=true
  yFmt=usd0k
/>



<details>

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


```sql tx_by_country_bubble
select * from demo_lh.tx_by_country_bubble
```

</details>