create database if not exists saas;
use saas;

# 1- Understanding the Dataset
select * from ravenstack_accounts;
select * from ravenstack_churn_events;
select * from ravenstack_feature_usage;
select * from ravenstack_subscriptions;
select * from ravenstack_support_tickets;



select count(*) from ravenstack_accounts;
select count(*) from ravenstack_churn_events;
select count(*) from ravenstack_feature_usage;
select count(*) from ravenstack_subscriptions;
select count(*) from ravenstack_support_ticketsravenstack_accountsravenstack_accounts;


# 2- Explanatory Data Analysis(Accounts)
# (a) Count total accounts and group by plan_tier
select plan_tier,count(*) as total_accounts
from ravenstack_accounts
group by plan_tier;


# (b) Count accounts by industry and country.
select industry,country,count(*) as total_accounts
from ravenstack_accounts
group by industry,country;


# (c) Average seats per account.
select avg(seats) from ravenstack_accounts;

# (d) How many accounts are on trial vs paid?
select
sum(case when is_trial="True" then 1
else 0 end) as 'trial',
sum(case when is_trial='False' then 1 
else 0 end) as "paid"
from ravenstack_accounts;


# 3- Explanatory Data Analysis(Subscriptions)
# (a) Count total subscriptions and group by plan_tier.
select plan_tier,count(*) as total_subscriptions
from ravenstack_subscriptions
group by plan_tier;

# (b) Count subscriptions per account.
select avg(s.t) from(
select account_id,count(*) as t from ravenstack_subscriptions
group by account_id)s;

# (c) Average MRR and ARR per plan.
# mmr - monhtly revenue expected by conpany from subscriptions
select plan_tier,avg(mrr_amount),avg(arr_amount)
from ravenstack_subscriptions
group by plan_tier;

# (d) How many subscriptions are active vs churned?
select 
sum(case when churn_flag="True" then 1
else 0 end) as "churned",
sum(case when churn_flag="False" then 1 else 0
end) as "active"
from ravenstack_subscriptions;

# 4- Explanatory Data Analysis(Feature Usage)

# (a) Count total usage events.
select sum(usage_count) as total_event from ravenstack_feature_usage;

# (b) Most frequently used features (feature_name) overall. --  feature_32
select feature_name,sum(usage_count) 
from ravenstack_feature_usage
group by feature_name
order by sum(usage_count) desc limit 1;

# (c) Average usage_count and usage_duration_secs per feature.
select feature_name,avg(usage_count),avg(usage_duration_secs) from 
ravenstack_feature_usage
group by feature_name;

# (d) Beta features usage vs regular features.
select 
sum(case when is_beta_feature="True" then 1
else 0 end) as "Beta feature usage",
sum(case when is_beta_feature="False" then 1 else 0
end) as "Regular Feature"
from ravenstack_feature_usage;




# 5 - Explanatory Data Analysis(Support Tickets)

# (a) Count total tickets by priority.
select priority, count(*) from ravenstack_support_tickets
group by priority
order by count(*) desc;

# (b) Average resolution_time_hours per priority.
select priority, avg(resolution_time_hours) from ravenstack_support_tickets
group by priority;



# (c) Count tickets by satisfaction_score.
select satisfaction_score,count(*) from ravenstack_support_tickets
group by satisfaction_score;

# (d) Count Tickets with escalations (escalation_flag = TRUE).
select count(*) from ravenstack_support_tickets
where escalation_flag = "TRUE";


# 6 - Explanatory Data Analysis(Churn Events)

# (a) Count churn events by reason_code.
select * from ravenstack_churn_events;
select reason_code, count(*) from ravenstack_churn_events
group by reason_code;

# (b) Average refund_amount_usd.
select avg(refund_amount_usd) from ravenstack_churn_events;

# (c) Count churn rate with/without prior upgrade(Using CTE)

with 
q1 as (
select count(*)*100/(select count(*) from ravenstack_churn_events) as 'churn1'
from ravenstack_churn_events
where preceding_upgrade_flag = "False"),
q2 as
(select count(*)*100/(select count(*) from ravenstack_churn_events) as 'churn2'
from ravenstack_churn_events
where preceding_upgrade_flag = "True")

select  churn1 as 'churn without upgrade', churn2 as 'churn with upgrade' from q1,q2;


# (d) Count churn rate of events that were reactivations.
select count(*)*100/(select count(*) from ravenstack_churn_events) as 'churn rate'
from ravenstack_churn_events
where is_reactivation = "True";











# 2. Intermediate Analytics (Cross-Table)
Top 10 accounts with most subscriptions or upgrades.
Accounts with highest churn risk (join accounts + subscriptions + churn_events).
Correlation between feature_usage and churn (do high usage accounts churn less?).
Average subscription duration (end_date - start_date) by plan_tier.
Tickets per account vs account size (seats) – which accounts generate more tickets?
Average satisfaction score per industry or country.
3. Revenue & Product Metrics
Total MRR & ARR per month/year.
Churned revenue (sum of ARR of churned subscriptions).
Expansion vs contraction revenue (upgrade_flag vs downgrade_flag).
Cohort analysis: revenue retention by signup month.
Average revenue per seat per plan tier.
4. Customer & Engagement Analysis
Number of active vs inactive users per subscription.
Feature adoption rate per plan tier.
Time from signup to first feature usage.
Accounts with zero feature usage but active subscriptions.
Ticket volume vs feature usage (does low usage generate more support?).
5. Advanced Product & Business Insights
Identify power users (top 5% usage) and their retention rates.
Predictive insights (SQL-level approximations):
Accounts with declining feature usage month-over-month.
Accounts with high churn risk based on subscription history & ticket volume.
Churn reason analysis by industry & plan tier.
Revenue leakage: accounts downgraded or churned without refunds.
Subscription lifecycle analysis:
Average subscription length before churn.
Number of trials converted to paid.
6. KPI & Dashboard Metrics
Monthly active accounts (MAA) vs monthly churned accounts.
Average ticket resolution time trend per month.
MRR growth over time by plan tier.
Customer satisfaction trend per quarter.
Feature adoption trend per month. are these questions solving this probelm-RavenStack is a B2B SaaS company offering multiple subscription plans and product features. Despite steady customer growth, profitability and retention are uneven. Leadership needs data-driven insights to optimize revenue, product feature adoption, and support operations.

2 Objectives