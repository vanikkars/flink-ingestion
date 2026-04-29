---
title: Users
---


This dashboard provides an overview of user distribution and activity. 
It breaks down the user base by country and highlights the most active users based on their transaction volume. 
Use it to identify geographic concentration and spot the highest-engagement users at a glance.


<BarChart
  data={users_by_country}
  x=country
  y=user_count
  title="Users by Country"
  swapXY=true
/>


<DataTable data={top_users_by_tx} title="Top 10 Users by Transactions">
  <Column id="user_id" title="User ID" />
  <Column id="tx_count" title="Transactions" />
  <Column id="total_amount" title="Total Amount" fmt="num2" contentType=colorscale colorScale=#4a90d9 />
</DataTable>

<details>
KPIs definition

```sql users_by_country
select * from demo_lh.users_by_country
```


```sql top_users_by_tx
select * from demo_lh.top_users_by_tx
```

</details>