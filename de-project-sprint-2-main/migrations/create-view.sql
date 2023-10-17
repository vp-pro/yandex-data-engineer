create view shipping_datamart as
select shipping_id, vendor_id, transfer_type, 
shipping_start_fact_datetime, shipping_end_fact_datetime, shipping_plan_datetime,
case when shipping_end_fact_datetime is not null 
	then extract(day from (shipping_end_fact_datetime - shipping_start_fact_datetime))
	else null 
	end as full_day_at_shupping,
case 	when shipping_plan_datetime > shipping_end_fact_datetime 
		then 0
	when shipping_end_fact_datetime is null 
		then null
	else 1 
	end as is_delay,
case when ss.status = 'finished' 
	then 1
	else 0
	end as is_shipping_finish,
case when shipping_end_fact_datetime > shipping_plan_datetime
	then extract(day from (shipping_end_fact_datetime - shipping_plan_datetime))
	else 0
	end as delay_day_at_shipping,
payment_amount,
payment_amount * (shipping_country_base_rate + agreement_rate + shipping_transfer_rate) as vat,
payment_amount * agreement_commission as profit
from shipping_info
left join shipping_transfer st on(shipping_transfer_id = st.id)
left join shipping_status ss using(shipping_id)
left join vendor_agreement_description vad on (shipping_agreement_id = agreement_id)
left join shipping_country_rates scr on (shipping_country_rate_id = scr.id)
