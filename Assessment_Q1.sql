USE adashi_staging
/*
The query below finds customers who have both savings accts & investment plans.
Aliases used are as follows:
'u' for  user_customuser
'sa' for  savings_savingsaccount 
'p' for plans_plans.
This is to filter out users who have only 1 type of plan and identify cross-sell potential. 
*/
SELECT
    u.id AS owner_id, 
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    SUM(CASE WHEN p.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN 1 ELSE 0 END) AS savings_count,
    SUM(CASE WHEN p.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN 1 ELSE 0 END) AS investment_count,
    FORMAT(SUM(sa.confirmed_amount) / 100, 2) AS total_deposits
FROM
    users_customuser u
JOIN
    savings_savingsaccount sa ON sa.owner_id = u.id
JOIN
    plans_plan p ON sa.plan_id = p.id
GROUP BY
    u.id, u.first_name, u.last_name
HAVING
    savings_count > 0
    AND investment_count > 0
ORDER BY
    total_deposits ASC;


