# 📖 Data Dictionary

## 1. Table: `users`
Stores personal information and internal risk profiling for the account holders.

| Column | Data Type | Description | Constraints |
| :--- | :--- | :--- | :--- |
| `user_id` | INT | Unique identifier for each user | PRIMARY KEY |
| `full_name` | VARCHAR | Legal name of the user | NOT NULL |
| `email` | VARCHAR | Contact email address | UNIQUE |
| `country` | VARCHAR | User's registered country of residence | - |
| `account_created_at` | TIMESTAMP | Date and time account was opened | DEFAULT NOW() |
| `risk_score` | INT | 0-100 score (Higher = Riskier) | CHECK(0-100) |

## 2. Table: `transactions`
Records every financial movement attempted by the users.

| Column | Data Type | Description | Constraints |
| :--- | :--- | :--- | :--- |
| `transaction_id` | INT | Unique identifier for the transaction | PRIMARY KEY |
| `user_id` | INT | ID of the user performing the transaction | FOREIGN KEY $\rightarrow$ users |
| `amount` | DECIMAL | Monetary value of the transaction | > 0 |
| `currency` | VARCHAR | 3-letter currency code (USD, EUR, etc) | - |
| `transaction_date` | TIMESTAMP | Exact date and time of transaction | - |
| `location_city` | VARCHAR | City where transaction originated | - |
| `location_country`| VARCHAR | Country where transaction originated | - |
| `merchant_category`| VARCHAR | Type of business (Retail, Food, etc) | - |
| `payment_status` | VARCHAR | Status: 'Success', 'Failed', 'Pending' | - |
| `device_id` | VARCHAR | Unique ID of the hardware used | - |

## 3. Table: `merchants`
Information about the vendors receiving the payments.

| Column | Data Type | Description | Constraints |
| :--- | :--- | :--- | :--- |
| `merchant_id` | INT | Unique identifier for the merchant | PRIMARY KEY |
| `merchant_name` | VARCHAR | Name of the business | - |
| `category` | VARCHAR | Business sector | - |
| `trust_score` | INT | 0-100 (Lower = More likely to be a shell company) | CHECK(0-100) |