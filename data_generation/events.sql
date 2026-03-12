CREATE TABLE events (
event_id INT PRIMARY KEY AUTO_INCREMENT,
user_id INT,
event_date DATE,
event_type VARCHAR(50),
platform VARCHAR(20),

FOREIGN KEY (user_id) REFERENCES users(user_id)
);


INSERT INTO events (user_id, event_date, event_type, platform)

SELECT
u.user_id,
DATE_ADD(u.signup_date, INTERVAL FLOOR(RAND()*540) DAY),

ELT(FLOOR(1 + RAND()*5),
'login',
'feature_use',
'file_upload',
'project_create',
'share'),

ELT(FLOOR(1 + RAND()*3),
'mobile',
'desktop',
'tablet')

FROM users u
JOIN (
SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
) t;

-- VALIDATION
SELECT COUNT(*) FROM events;

SELECT event_type, COUNT(*)
FROM events
GROUP BY event_type;