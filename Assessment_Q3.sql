USE adashi_staging

SELECT
    id AS plan_id,  
    owner_id,  
   
    CASE
        WHEN is_regular_savings = 1 THEN 'Savings'  -- Marks as 'Savings' if flagged as regular savings
        WHEN is_a_fund = 1 THEN 'Investment'       -- Marks as 'Investment' if flagged as a fund
        ELSE 'Other'                               -- If neither then defults to 'Other' 
    END AS type,
    last_charge_date AS last_transaction_date,  -- gets the date of the last transaction on the plan
   
    DATEDIFF(CURDATE(), last_charge_date) AS inactivity_days -- Calculates the number of days since the last transaction to measure inactivity
FROM plans_plan
WHERE
    last_charge_date IS NOT NULL  -- this only considers plans that have had at least one transaction
    AND DATEDIFF(CURDATE(), last_charge_date) > 365  -- Filter plans that have been inactive for more than 1 year
    AND is_deleted = 0  -- Exclude plans marked as deleted
    AND is_archived = 0;  -- Exclude plans marked as archived

