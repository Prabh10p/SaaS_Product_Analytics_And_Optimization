create database if not exists saas;
use saas;

# 1- Understanding the Dataset
select * from ravenstack_accounts;
select * from ravenstack_churn_events;
select * from ravenstack_feature_usage;
select * from ravenstack_subscriptions;
select * from ravenstack_support_ticketsravenstack_accountsravenstack_accounts;



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



# 4- Explanatory Data Analysis(Feature Usage)

# (a) Count total usage events.


# (b) Most frequently used features (feature_name) overall.


# (c) Average usage_count and usage_duration_secs per feature.


# (d) Beta features usage vs regular features.




# 5 - Explanatory Data Analysis(Support Tickets)

# (a) Count total tickets by priority.


# (b) Average resolution_time_hours per priority.


# (c) Count tickets by satisfaction_score.


# (d) Tickets with escalations (escalation_flag = TRUE).



# 5 - Explanatory Data Analysis(Churn Events)

# (a) Count churn events by reason_code.


# (b) Average refund_amount_usd.


# (c) Count churn with/without prior upgrade/downgrade.


# (d) Count churn events that were reactivations.











2. Intermediate Analytics (Cross-Table)
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