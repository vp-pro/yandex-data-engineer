-- init tables:

drop table if exists shipping_info;
drop table if exists shipping_country_rates;
drop table if exists vendor_agreement_description;
drop table if exists shipping_transfer;
drop table if exists shipping_status; 

create table shipping_country_rates (
	id serial,
	shipping_country varchar(50),
	shipping_country_base_rate numeric(4,3),
	primary key(id)
);
create index shipping_country_rates_id_index on shipping_country_rates(id);

create table vendor_agreement_description (
	agreement_id serial,
	agreement_number varchar(20),
	agreement_rate float,
	agreement_commission float,
	primary key(agreement_id)
);
create index vendor_agreement_description_id_index on vendor_agreement_description(agreement_id);

create table shipping_transfer (
	id serial,
	transfer_type varchar(2),
	transfer_model varchar(50),
	shipping_transfer_rate numeric(4,3),	
	primary key (id)
);
create index shipping_transfer_id_index on shipping_transfer(id);


create table shipping_info (
	shipping_id serial,
	shipping_transfer_id bigint,
	shipping_agreement_id bigint,
	shipping_country_rate_id bigint,
	shipping_plan_datetime timestamp,
	payment_amount numeric(14,2),
	vendor_id bigint,
	primary key (shipping_id),
	CONSTRAINT fk_shipping_transfer_id foreign key (shipping_transfer_id) references shipping_transfer(id),
	CONSTRAINT fk_shipping_agreement_id foreign key (shipping_agreement_id) references vendor_agreement_description(agreement_id),
	CONSTRAINT fk_shipping_country_rate_id foreign key (shipping_country_rate_id) references shipping_country_rates(id)
);
create index shipping_info_id_index on shipping_info(shipping_id);

create table shipping_status (
	shipping_id bigint,
	status varchar(50),
	state varchar(50),
	shipping_start_fact_datetime timestamp,
	shipping_end_fact_datetime timestamp	
);
create index shipping_status_id_index on shipping_status(shipping_id);

-- insert data

insert into shipping_country_rates (shipping_country, shipping_country_base_rate)
select distinct shipping_country , cast(shipping_country_base_rate as numeric(4,3)) from shipping;

insert into vendor_agreement_description (agreement_id, agreement_number, agreement_rate, agreement_commission)
select distinct cast((regexp_split_to_array(vendor_agreement_description, ':'))[1] as int) as agreement_id,
	cast((regexp_split_to_array(vendor_agreement_description, ':'))[2] as varchar(20)) as agreement_number,
	cast((regexp_split_to_array(vendor_agreement_description, ':'))[3] as numeric(3,2)) as agreement_rate,
	cast((regexp_split_to_array(vendor_agreement_description, ':'))[4] as numeric(3,2)) as agreement_commission
	from shipping s 
order by agreement_id;

insert into shipping_transfer ( transfer_type, transfer_model, shipping_transfer_rate)
select distinct (regexp_split_to_array(shipping_transfer_description, ':'))[1] as transfer_type,
(regexp_split_to_array(shipping_transfer_description, ':'))[2] as transfer_model,
 cast(shipping_transfer_rate as numeric(4,3)) as shipping_transfer_rate
from shipping
order by transfer_model, transfer_type;


INSERT INTO shipping_status (shipping_id, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
SELECT 
    shippingid,
    status,
    state,
    MAX(CASE WHEN state = 'booked' THEN state_datetime END) AS shipping_start_fact_datetime,
    MAX(CASE WHEN state = 'recieved' THEN state_datetime END) AS shipping_end_fact_datetime 
FROM 
    shipping
GROUP BY 
    shippingid, status, state
ORDER BY 
    shippingid;


insert into shipping_info (shipping_id, 
  shipping_transfer_id, 
  shipping_agreement_id, 
  shipping_country_rate_id, 
  shipping_plan_datetime, 
  payment_amount, 
  vendor_id
)
select distinct shippingid as shipping_id, st.id as shipping_transfer_id, vad.agreement_id as sheeping_agreement_id, scr.id as shipping_country_rate_id, s.shipping_plan_datetime, s.payment_amount, s.vendorid as vendor_id
from shipping s
  left join shipping_transfer as st on ((regexp_split_to_array(s.shipping_transfer_description, ':'))[1] = st.transfer_type 
    and (regexp_split_to_array(s.shipping_transfer_description, ':'))[2] = st.transfer_model )
  left join vendor_agreement_description as vad on (vad.agreement_id = cast((regexp_split_to_array(s.vendor_agreement_description, ':'))[1] as int))
  left join shipping_country_rates scr on (scr.shipping_country = s.shipping_country)
order by shipping_id;


