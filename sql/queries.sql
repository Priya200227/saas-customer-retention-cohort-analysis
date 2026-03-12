-- TOTAL USERS
select count(*) as total_users
from users;

-- TOTAL PAYING USERS
select count(distinct user_id) as paying_users
from subscriptions;

-- CURRENT ACTIVE SUBSCRIBERS
select count(*) as active_subscribers
from subscriptions
where status = 'active';

-- CHURNED SUBSCRIBERS
select count(*) as churned_scribers
from subscriptions
where status = 'cancelled';

-- CHURN RATE
select sum(status = 'cancelled') / count(*) * 100 as churn_rate
from subscriptions;

-- CALCULATE MRR by month & plan
select date_format(payment_date, '%Y-%m') as monthly,
	   s.plan_type,
	   sum(amount) as MRR
from payments p
join subscriptions s on s.subscription_id = p.subscription_id 
where payment_status = 'success'
group by monthly, s.plan_type
order by monthly;

-- CALCULATE ARPU
select date_format(p.payment_date, '%Y-%m') as monthly,
		round(sum(p.amount) / count(distinct s.user_id),2) as ARPU
from payments p
join subscriptions s on s.subscription_id = p.subscription_id 
where payment_status = 'success'
group by monthly
order by monthly;


-- COHORT RETENTION ANALYSIS
with cohort_size as (
	select date_format(signup_date,'%Y-%m') as cohort_month,
		   count(*) as cohort_users
	from users
    group by cohort_month
),
retention as (
	select date_format(u.signup_date,'%Y-%m') as cohort_month,
			timestampdiff(month, date_format(u.signup_date,'%Y-%m-01'),
								 date_format(e.event_date,'%Y-%m-01'))
							as months_since_signup,
			count(distinct u.user_id) as retained_users
	from users u
    join events e on u.user_id = e.user_id
    where timestampdiff(month, date_format(signup_date,'%Y-%m-01'),
								 date_format(signup_date,'%Y-%m-01')) >=0
	group by cohort_month, months_since_signup
)
select r.cohort_month, r.months_since_signup, r.retained_users,
		c.cohort_users,
        r.retained_users / c.cohort_users * 100 as retention_rate
from retention r
join cohort_size c on r.cohort_month = c.cohort_month
order by r.cohort_month, r.months_since_signup;

-- Customer Lifetime Value
select s.user_id,
		sum(p.amount) as customer_lifetime_value
from payments p
join subscriptions s
on p.subscription_id = s.subscription_id
where p.payment_status = 'success'
group by s.user_id
order by customer_lifetime_value desc;



















