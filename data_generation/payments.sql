CREATE TABLE payments (
payment_id INT PRIMARY KEY AUTO_INCREMENT,
subscription_id INT,
payment_date DATE,
amount DECIMAL(10,2),
payment_status VARCHAR(20),

FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

INSERT INTO payments (subscription_id, payment_date, amount, payment_status)

SELECT
s.subscription_id,
DATE_ADD(s.start_date, INTERVAL seq.month_offset MONTH),

CASE
WHEN s.plan_type = 'Basic' THEN 10
WHEN s.plan_type = 'Pro' THEN 25
WHEN s.plan_type = 'Enterprise' THEN 60
END,

CASE
WHEN RAND() < 0.95 THEN 'success'
ELSE 'failed'
END

FROM subscriptions s
JOIN (
SELECT 0 AS month_offset
UNION SELECT 1
UNION SELECT 2
UNION SELECT 3
UNION SELECT 4
UNION SELECT 5
UNION SELECT 6
UNION SELECT 7
UNION SELECT 8
UNION SELECT 9
UNION SELECT 10
UNION SELECT 11
) seq
ON DATE_ADD(s.start_date, INTERVAL seq.month_offset MONTH) <= s.end_date;

SELECT COUNT(*) FROM payments;

SELECT payment_status, COUNT(*)
FROM payments
GROUP BY payment_status;

SELECT MIN(payment_date), MAX(payment_date)
FROM payments;