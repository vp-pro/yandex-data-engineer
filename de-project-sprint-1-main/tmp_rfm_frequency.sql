insert into analysis.tmp_rfm_frequency
with frequency_group as(
  select user_id, COUNT(case when status = 4 then 1 else NULL end) as n_orders from orders
  where extract(year from order_ts)>=2022
  group by user_id
)
  select user_id,
  ntile(5) over (order by n_orders ASC) as frequency
  from frequency_group
