-- Insert Users
INSERT INTO users (user_id, full_name, email, country, risk_score) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'USA', 10),
(2, 'Bob Smith', 'bob@example.com', 'UK', 20),
(3, 'Charlie Brown', 'charlie@example.com', 'Canada', 80), -- High risk user
(4, 'Diana Prince', 'diana@example.com', 'USA', 15),
(5, 'Eve Hacker', 'eve@example.com', 'Russia', 95);      -- High risk user

-- Insert Transactions
-- User 1: Normal behavior
INSERT INTO transactions VALUES 
(101, 1, 50.00, 'USD', '2023-10-01 10:00:00', 'New York', 'USA', 'Grocery', 'Success', 'DEV_01'),
(102, 1, 20.00, 'USD', '2023-10-01 12:00:00', 'New York', 'USA', 'Coffee', 'Success', 'DEV_01'),
(103, 1, 100.00, 'USD', '2023-10-02 15:00:00', 'New York', 'USA', 'Electronics', 'Success', 'DEV_01');

-- User 2: Rapid-Fire Failed Payments (Fraud Indicator 1)
INSERT INTO transactions VALUES 
(201, 2, 10.00, 'GBP', '2023-10-03 09:00:00', 'London', 'UK', 'Online', 'Failed', 'DEV_02'),
(202, 2, 10.00, 'GBP', '2023-10-03 09:01:00', 'London', 'UK', 'Online', 'Failed', 'DEV_02'),
(203, 2, 10.00, 'GBP', '2023-10-03 09:02:00', 'London', 'UK', 'Online', 'Failed', 'DEV_02'),
(204, 2, 10.00, 'GBP', '2023-10-03 09:03:00', 'London', 'UK', 'Online', 'Success', 'DEV_02');

-- User 3: Impossible Travel (Fraud Indicator 2)
-- Transacted in Canada, then 1 hour later in Japan
INSERT INTO transactions VALUES 
(301, 3, 100.00, 'CAD', '2023-10-04 10:00:00', 'Toronto', 'Canada', 'Retail', 'Success', 'DEV_03'),
(302, 3, 500.00, 'JPY', '2023-10-04 11:00:00', 'Tokyo', 'Japan', 'Luxury', 'Success', 'DEV_03');

-- User 4: High-Value Anomaly (Fraud Indicator 3)
-- Average spend is $30, suddenly spends $5000
INSERT INTO transactions VALUES 
(401, 4, 30.00, 'USD', '2023-10-05 10:00:00', 'Miami', 'USA', 'Food', 'Success', 'DEV_04'),
(402, 4, 45.00, 'USD', '2023-10-05 14:00:00', 'Miami', 'USA', 'Food', 'Success', 'DEV_04'),
(403, 4, 5000.00, 'USD', '2023-10-06 02:00:00', 'Miami', 'USA', 'Jewelry', 'Success', 'DEV_04');

-- User 5: Rapid Spikes / High Frequency (Fraud Indicator 4)
INSERT INTO transactions VALUES 
(501, 5, 100.00, 'USD', '2023-10-07 10:00:00', 'Moscow', 'Russia', 'Gaming', 'Success', 'DEV_05'),
(502, 5, 120.00, 'USD', '2023-10-07 10:00:30', 'Moscow', 'Russia', 'Gaming', 'Success', 'DEV_05'),
(503, 5, 110.00, 'USD', '2023-10-07 10:01:00', 'Moscow', 'Russia', 'Gaming', 'Success', 'DEV_05'),
(504, 5, 130.00, 'USD', '2023-10-07 10:01:30', 'Moscow', 'Russia', 'Gaming', 'Success', 'DEV_05'),
(505, 5, 100.00, 'USD', '2023-10-07 10:02:00', 'Moscow', 'Russia', 'Gaming', 'Success', 'DEV_05');