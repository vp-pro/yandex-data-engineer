-- Add "status" column to mart.f_sales with a default value
ALTER TABLE mart.f_sales
ADD COLUMN status VARCHAR(30) NOT NULL DEFAULT 'shipping';

-- Add "status" column to staging.user_order_log
ALTER TABLE staging.user_order_log
ADD COLUMN status VARCHAR(30);

-- f_customer_retention table
CREATE TABLE IF NOT EXISTS mart.f_customer_retention (
    new_customers_count INT NOT NULL,
    returning_customers_count INT NOT NULL,
    refunded_customer_count INT NOT NULL,
    period_name VARCHAR(30) NOT NULL,
    period_id INT NOT NULL,
    item_id VARCHAR(30) NOT NULL,
    new_customers_revenue NUMERIC(14, 3) NOT NULL,
    returning_customers_revenue NUMERIC(14, 3) NOT NULL,
    customers_refunded INT NOT NULL,
    
    CONSTRAINT f_customer_retention_pk PRIMARY KEY (period_id, item_id)
);
