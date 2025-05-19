# DataAnalytics-Assessment
SUMMARY:- This repository contains solutions to a set of SQL-based analytics questions using MySQL. The goal was to derive customer insights, estimate customer lifetime value, and explore monthly trends using real savings and user data. 

 
QUESTION 1:- CUSTOMER ACCOUNT INSIGHTS AND CROSS-SELL POTENTIAL
APPROACH: 
1) I performed a JOIN across user_customuser, savings_savingsaccount and plans_plan tables to merge user, account, and plan details. 

2) I then used conditional aggregation to count how many savings (is_regular_savings= 1) and investment (is_a_fund= 1) plans each user holds, ensuring that only funded accounts (confirmed_amount >0) are considered. 

3) I applied a ‘HAVING’ clause to filter and include only customers who have at least one of each plan type. 

4) Finally, I ordered the results by total_deposits in ascending order to prioritize smaller but multi-engaged customers. 

CHALLENGES & RESOLUTIONS

1) Misinterpreted Time Relevance: Initially, I filtered by created_date, assuming that recency was important. I later realized the business objective was to identify currently active, funded accounts, regardless of when they were created. 

2) Missing Name Column: When selecting a name field, the query returned NULL due to a schema mismatch. I resolved this by using CONCAT(u.first_name, ' ', u.last_name) to generate full names dynamically. 

3) Data Validity: revised my query to ensure only funded accounts were counted by explicitly filtering for confirmed_amount > 0. 

 

QUESTION 2: TRANSACTION FREQUENCY ANALYSIS 
APPROACH: 
1) To analyze customer transaction frequency, I first calculated the monthly transaction count per user by grouping transactions by owner_id and the month (%Y-%m) of each transaction_date. 

2) Next, I computed the average number of transactions per month for each customer using AVG() across their monthly counts. This helped standardize activity across users regardless of how long they’ve been on the platform. 

3) I summarized the results by counting the number of users in each category and calculating the average monthly transactions per group. The output was sorted using ORDER BY FIELD() to prioritize high-frequency users in the report. 

4) Customers were then segmented based on their average monthly activity: 
High Frequency: ≥10 transactions/month 
Medium Frequency: 3–9 transactions/month 
Low Frequency: ≤2 transactions/month 

CHALLENGES & RESOLUTIONS
1) Inconsistent Monthly Grouping: Initially, grouping transactions by raw transaction_date led to scattered and inaccurate monthly summaries. To fix this, I used DATE_FORMAT(transaction_date, '%Y-%m') to standardize the grouping by month and ensure each transaction was placed correctly in its monthly bucket. 

2) Unclear Frequency Categories: While implementing the customer segmentation, it was important to ensure customers were placed in the right frequency band. I used a CASE statement with well-defined boundaries (≥10, 3–9, ≤2) to apply these business rules consistently. 

3) Ambiguity in What Constitutes a Transaction: There was some initial uncertainty about whether each row in savings_savingsaccount truly represented a single transaction. After reviewing the schema and business logic, I confirmed that each row could be treated as a transaction event for the purposes of this analysis. 

 

QUESTION 3: ACCOUNT INACTIVITY
APPROACH: 
1) To identify dormant plans, I queried plans_plan to find savings or investment plans that hadn’t had any inflow transactions in the past year. 

2) I filtered for plans where the last_charge_date exists, calculated inactivity using DATEDIFF(CURDATE(), last_charge_date), and selected only those with inactivity over 365 days. I also excluded deleted and archived plans to ensure only active records were considered. 

CHALLENGES & RESOLUTIONS
There were no major challenges were encountered. The query requirements were clearly defined and easily translatable.  


QUESTION 4: CUSTOMER LIFETIME VALUE (CLV) Estimation 
APPROACH: 
1) For CLV estimation, I first calculated customer tenure in months using TIMESTAMPDIFF(MONTH, date_joined, CURDATE()). I then counted savings-related actions and computed the average transaction value per customer using the savings_savingsaccount table. 

2) I then used this simplified formula: 
 CLV = (Total Actions / Tenure) × 12 × (0.1% of Avg. Value) 
 I annualized activity by multiplying by 12 and applied a 0.1% profit margin, converting from Kobo to Naira. 

CHALLENGES & RESOLUTIONS
1) Unusually Low CLV Values: My initial CLV results were extremely low. Upon review, I realized the values were still in Kobo. I fixed this by dividing the average transaction amount by 100 to convert to Naira. 

2) Division by Zero for New Users: Some new users had a tenure of zero months, causing a division error. I wrapped the tenure in a NULLIF(tenure_months, 0) to safely skip those cases. 

3) Incorrect Measure of Transactions: I initially measured the number of accounts instead of actions. I corrected this by counting actual savings actions (sa.id), which gave a more accurate picture of customer activity. 

 
