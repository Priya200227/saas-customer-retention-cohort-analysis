CREATE TABLE subscriptions (
subscription_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT,
plan_type VARCHAR(20),
start_date DATE,
end_date DATE,
status VARCHAR(20),

FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO subscriptions (user_id, plan_type, start_date, end_date, status)

SELECT user_id,
		CASE
		WHEN RAND() < 0.65 THEN 'Basic'
		WHEN RAND() < 0.95 THEN 'Pro'
		ELSE 'Enterprise'
		END,
DATE_ADD(signup_date, INTERVAL FLOOR(RAND()*30) DAY),
NULL,
'active'
FROM users
WHERE RAND() < 0.25;

-- VALIDATION
SELECT COUNT(*) FROM subscriptions;

SELECT plan_type, COUNT(*)
FROM subscriptions
GROUP BY plan_type;

SELECT MIN(start_date), MAX(start_date)
FROM subscriptions;

-- SIMULATE CHURN
SET SQL_SAFE_UPDATES = 0;
UPDATE subscriptions
SET end_date = DATE_ADD(start_date, INTERVAL FLOOR(1 + RAND()*12) MONTH),
status =
CASE
WHEN RAND() < 0.6 THEN 'cancelled'
ELSE 'active'
END;

-- VALIDATION
SELECT status, COUNT(*)
FROM subscriptions
GROUP BY status;

SELECT AVG(DATEDIFF(end_date,start_date))/30
FROM subscriptions;