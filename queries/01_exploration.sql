-- -----------------------------------------------------------------------------
-- 01_EXPLORATION: Sanity checks and high-level data overview
-- -----------------------------------------------------------------------------

-- 1. General Transaction Volume Summary
SELECT 
    payment_status, 
    COUNT(*) as total_transactions, 
    SUM(amount) as total_volume, 
    AVG(amount) as avg_transaction_value
FROM transactions
GROUP BY payment_status;

-- 2. Top 5 User's with the highest total spending
SELECT 
    u.full_name, 
    SUM(t.amount) as total_spent
FROM users u
JOIN transactions t ON u.user_id = t.user_id
WHERE t.payment_status = 'Success'
GROUP BY u.full_name
ORDER BY total_spent DESC
LIMIT 5;

-- 3. Distribution of transactions across countries
SELECT 
    location_country, 
    COUNT(*) as transaction_count
FROM transactions
GROUP BY location_country
ORDER BY transaction_count DESC;

-- 4. Check for users with high internal risk scores and their transaction counts
SELECT 
    u.user_id, 
    u.full_name, 
    u.risk_score, 
    COUNT(t.transaction_id) as tx_count
FROM users u
LEFT JOIN transactions t ON u.user_id = t.user_id
WHERE u.risk_score > 70
GROUP BY u.user_id, u.full_name, u.risk_score;