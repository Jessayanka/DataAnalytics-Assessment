USE adashi_staging
SHOW TABLES; 

WITH customer_stats AS( 
	SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name, -- concatenates first & last name into a single 'name' column
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months, -- to calculate tenure in months from months joined till present
        COUNT(sa.id) AS total_savings_actions, -- to count the number of savings account linked to each user
        AVG(sa.amount) AS avg_savings_value -- average amount calculated saved per action
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount sa ON sa.owner_id = u.id
GROUP BY
		u.id, name, tenure_months
)        
-- this step highlights the final selection with estimated CLV calculation
SELECT
     customer_id,
     name,
     tenure_months,
     total_savings_actions,
     ROUND(
		(total_savings_actions / NULLIF(tenure_months, 0))  -- prevents division by 0
        * 12 -- annualizes the actions i.e. per year
        * (avg_savings_value * 0.001 / 100) -- converts kobo to naira
	 , 2) AS estimated_clv   
FROM
    customer_stats
ORDER BY
    estimated_clv DESC; -- sorts customers by descending estimated CLV 