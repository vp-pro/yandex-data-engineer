-- Combined the DELETE operations
DELETE FROM mart.f_customer_retention 
WHERE period_id IN (DATE_PART('week', '{{ds}}'::date), DATE_PART('week', '{{ds}}'::date) - 1);

-- Insertion with simplified logic
INSERT INTO mart.f_customer_retention 
            (new_customers_count, returning_customers_count, refunded_customer_count, 
             period_name, period_id, item_id, new_customers_revenue, 
             returning_customers_revenue, customers_refunded)
SELECT 
    COUNT(DISTINCT CASE WHEN status = 'new' THEN customer_id END) AS new_customers_count,
    COUNT(DISTINCT CASE WHEN status <> 'new' THEN customer_id END) AS returning_customers_count,
    COUNT(DISTINCT CASE WHEN status = 'refunded' THEN customer_id END) AS refunded_customer_count,
    'weekly' AS period_name,
    weekly AS period_id,
    item_id,
    SUM(CASE WHEN status = 'new' THEN payment_amount END) AS new_customers_revenue,
    SUM(CASE WHEN status <> 'new' THEN payment_amount END) AS returning_customers_revenue,
    SUM(CASE WHEN status = 'refunded' THEN quantity END) AS customers_refunded
FROM (
       SELECT 
           DATE_PART('week', c.date_actual) AS weekly,
           u.customer_id,
           s.quantity,
           s.payment_amount,
           -- Use a CASE statement to determine the status once
           CASE WHEN COUNT(u.customer_id) OVER(PARTITION BY u.customer_id, DATE_PART('week', c.date_actual)) = 1
                THEN 'new' 
                ELSE s.status
           END AS status,
           s.item_id
       FROM mart.f_sales s
       JOIN mart.d_customer u ON s.customer_id = u.customer_id
       JOIN mart.d_calendar c ON s.date_id = c.date_id
       WHERE c.date_actual BETWEEN '{{ds}}'::date - INTERVAL '1 week' AND '{{ds}}'::date
) AS prep
GROUP BY weekly, item_id;
