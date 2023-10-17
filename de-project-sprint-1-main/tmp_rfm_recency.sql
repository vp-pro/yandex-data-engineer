insert into analysis.tmp_rfm_recency
with recency_group as (
  select u.id as user_id , max(case when status = 4 then order_ts else NULL end) last_order from orders
  full join users u on u.id=orders.user_id
  where extract(year from order_ts)>=2022
  group by u.id
)
  select user_id,
  ntile(5) over (order by case when last_order is NULL then 0 else 1 end, last_order ASC) as recency
  from recency_group