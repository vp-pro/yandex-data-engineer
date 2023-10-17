create OR REPLACE view de.analysis.orderitems AS
select * from de.production.orderitems;
create OR REPLACE view de.analysis.products AS
select * from de.production.products;
create OR REPLACE view de.analysis.users AS
select * from de.production.users;
create OR REPLACE view de.analysis.orders AS
select * from de.production.orders;
create OR REPLACE view de.analysis.orderstatuses AS
select * from de.production.orderstatuses;