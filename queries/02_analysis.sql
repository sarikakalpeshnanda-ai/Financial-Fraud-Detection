-- -----------------------------------------------------------------------------
-- 02_ANALYSIS: Mid-level analysis focusing on trends and patterns
-- -----------------------------------------------------------------------------

-- 1. User-wise average spending vs their total spending
-- Helps in identifying the baseline behavior of each user
SELECT 
    user_id, 
    ROUND(AVG(amount), 2) as avg_spend, 
    MAX(amount) as max_spend, 
    COUNT(*) as total_tx
FROM transactions
WHERE payment_status = 'Success'
GROUP BY user_id;

-- 2. Identify "Frequent Failures"
-- Users who have more than 2 failed transactions in the dataset
SELECT 
    user_id, 
    COUNT(*) as failed_attempts
FROM transactions
WHERE payment_status = 'Failed'
GROUP BY user_id
HAVING COUNT(*) > 2;

-- 3. Merchant Category analysis for high-value transactions
-- Finding categories that usually attract the highest amounts
SELECT 
    merchant_category, 
    COUNT(*) as tx_count, 
    AVG(amount) as avg_amount
FROM transactions
WHERE amount > 1000
GROUP BY merchant_category;

-- 4. Device Analysis
-- Checking if a single device is being used by multiple users (Account Takeover indicator)
SELECT 
    device_id, 
    COUNT(DISTINCT user_id) as unique_users
FROM transactions
GROUP BY device_id
HAVING COUNT(DISTINCT user_id) > 1;