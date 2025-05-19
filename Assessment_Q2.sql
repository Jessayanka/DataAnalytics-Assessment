USE adashi_staging

WITH monthly_transactions AS (
    SELECT
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS month_label, -- Formats transaction date to Year-Month to allow for proper & accurate counting
        COUNT(*) AS transactions_count
    FROM savings_savingsaccount
    GROUP BY owner_id, month_label -- Groups by user and month to get monthly transaction counts
),
avg_transactions AS (
-- this step calculates the average number of transactions per month per customer
    SELECT
        owner_id,
        AVG(transactions_count) AS avg_transactions_per_month -- Average monthly transactions per customer
    FROM monthly_transactions
    GROUP BY owner_id
)
-- this step categorizes users based on their average transaction frequency and summarize counts per category
SELECT
    CASE
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count, -- total users in each frequency category
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM avg_transactions
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

