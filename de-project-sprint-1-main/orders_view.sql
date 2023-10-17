CREATE OR REPLACE VIEW de.analysis.orders AS
SELECT o.order_id, o.order_ts, o.user_id, o.bonus_payment, o.payment,
o.cost, o.bonus_grant, ls.status_id AS status
FROM de.production.orders o
LEFT JOIN (
    SELECT ol.order_id, ol.status_id
    FROM de.production.orderstatuslog ol
    JOIN (
        SELECT order_id, MAX(dttm) AS max_dttm
        FROM de.production.orderstatuslog
        WHERE EXTRACT(YEAR FROM dttm) >= 2022
        GROUP BY order_id
    ) lc ON ol.order_id = lc.order_id AND ol.dttm = lc.max_dttm
) ls ON o.order_id = ls.order_id;