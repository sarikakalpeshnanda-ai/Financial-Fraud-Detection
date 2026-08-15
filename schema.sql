-- Create Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50),
    account_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    risk_score INT CHECK (risk_score BETWEEN 0 AND 100)
);

-- Create Transactions Table
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15, 2),
    currency VARCHAR(3),
    transaction_date TIMESTAMP,
    location_city VARCHAR(50),
    location_country VARCHAR(50),
    merchant_category VARCHAR(50),
    payment_status VARCHAR(20), -- 'Success', 'Failed', 'Pending'
    device_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Create Merchant Table
CREATE TABLE merchants (
    merchant_id INT PRIMARY KEY,
    merchant_name VARCHAR(100),
    category VARCHAR(50),
    trust_score INT CHECK (trust_score BETWEEN 0 AND 100)
);