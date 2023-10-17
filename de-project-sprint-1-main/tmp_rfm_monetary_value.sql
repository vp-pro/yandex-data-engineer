insert into analysis.tmp_rfm_monetary_value
with monetary_group as (
  	select user_id, SUM(case when status = 4 then payment else 0 end) as total_payment
   	from orders
	where extract(year from order_ts)>=2022
	group by user_id
)
  select user_id,
  ntile(5) over (order by total_payment ASC) as monetary_value
  from monetary_group
