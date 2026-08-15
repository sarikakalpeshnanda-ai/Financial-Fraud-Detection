-- -----------------------------------------------------------------------------
-- 03_ADVANCED_QUERIES: The Fraud Detection Engine
-- Using CTEs, Window Functions, and Time-based analysis
-- -----------------------------------------------------------------------------

-- 🚩 DETECTOR 1: Rapid-Fire Failed Payments (Card Testing)
-- Flag users who have 3+ failed payments within a 10-minute window
WITH FailedAttempts AS (
    SELECT 
        user_id, 
        transaction_date,
        LAG(transaction_date, 2) OVER (PARTITION BY user_id ORDER BY transaction_date) as third_prev_tx_date
    FROM transactions
    WHERE payment_status = 'Failed'
)
SELECT DISTINCT user_id 
FROM FailedAttempts 
WHERE transaction_date - third_prev_tx_date <= INTERVAL '10 minutes';


-- 🚩 DETECTOR 2: Impossible Travel (Velocity Check)
-- Flag transactions where a user transacts in two different cities 
-- in a timeframe too short for physical travel (e.g., < 5 hours)
WITH TravelLog AS (
    SELECT 
        user_id, 
        location_city, 
        transaction_date,
        LAG(location_city) OVER (PARTITION BY user_id ORDER BY transaction_date) as prev_city,
        LAG(transaction_date) OVER (PARTITION BY user_id ORDER BY transaction_date) as prev_tx_date
    FROM transactions
    WHERE payment_status = 'Success'
)
SELECT 
    user_id, 
    prev_city, 
    location_city, 
    prev_tx_date, 
    transaction_date,
    (transaction_date - prev_tx_date) as travel_time
FROM TravelLog
WHERE location_city <> prev_city 
AND (transaction_date - prev_tx_date) < INTERVAL '5 hours';


-- 🚩 DETECTOR 3: High-Value Anomalies (Z-Score / Multiplier Logic)
-- Flag transactions that are 3x greater than the user's historical average spending
WITH UserAverages AS (
    SELECT 
        user_id, 
        AVG(amount) as avg_amount
    FROM transactions
    WHERE payment_status = 'Success'
    GROUP BY user_id
)
SELECT 
    t.transaction_id, 
    t.user_id, 
    t.amount, 
    ua.avg_amount, 
    (t.amount / ua.avg_amount) as multiplier
FROM transactions t
JOIN UserAverages ua ON t.user_id = ua.user_id
WHERE t.amount > (ua.avg_amount * 3) 
AND t.payment_status = 'Success';


-- 🚩 DETECTOR 4: Rapid Transaction Spikes (Burst Detection)
-- Flag users who make more than 4 transactions in under 5 minutes
WITH TransactionWindows AS (
    SELECT 
        user_id, 
        transaction_date,
        COUNT(*) OVER (
            PARTITION BY user_id 
            ORDER BY transaction_date 
            RANGE BETWEEN INTERVAL '5 minutes' PRECEDING AND CURRENT ROW
        ) as tx_count_5min
    FROM transactions
)
SELECT DISTINCT user_id 
FROM TransactionWindows 
WHERE tx_count_5min > 4;


-- 🚀 FINAL SUMMARY: Comprehensive Fraud Alert Table
-- Combines all the above logic into a single report
WITH 
    CardTesting AS (
        SELECT DISTINCT user_id FROM (
            SELECT user_id, transaction_date, LAG(transaction_date, 2) OVER (PARTITION BY user_id ORDER BY transaction_date) as prev_date
            FROM transactions WHERE payment_status = 'Failed'
        ) t WHERE transaction_date - prev_date <= INTERVAL '10 minutes'
    ),
    ImpossibleTravel AS (
        SELECT DISTINCT user_id FROM (
            SELECT user_id, location_city, LAG(location_city) OVER (PARTITION BY user_id ORDER BY transaction_date) as p_city,
            transaction_date, LAG(transaction_date) OVER (PARTITION BY user_id ORDER BY transaction_date) as p_date
            FROM transactions WHERE payment_status = 'Success'
        ) t WHERE location_city <> p_city AND (transaction_date - p_date) < INTERVAL '5 hours'
    ),
    HighValue AS (
        SELECT DISTINCT user_id FROM (
            SELECT t.user_id, t.amount, AVG(t.amount) OVER(PARTITION BY t.user_id) as avg_amt
            FROM transactions t WHERE t.payment_status = 'Success'
        ) t WHERE amount > (avg_amt * 3)
    )
SELECT 
    u.user_id, 
    u.full_name, 
    u.risk_score,
    CASE WHEN ct.user_id IS NOT NULL THEN '🚩 YES' ELSE '✅ NO' END as is_card_testing,
    CASE WHEN it.user_id IS NOT NULL THEN '🚩 YES' ELSE '✅ NO' END as is_impossible_travel,
    CASE WHEN hv.user_id IS NOT NULL THEN '🚩 YES' ELSE '✅ NO' END as is_high_value_anomaly
FROM users u
LEFT JOIN CardTesting ct ON u.user_id = ct.user_id
LEFT JOIN ImpossibleTravel it ON u.user_id = it.user_id
LEFT JOIN HighValue hv ON u.user_id = hv.user_id;