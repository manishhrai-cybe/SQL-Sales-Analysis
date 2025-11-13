-- Create database
CREATE DATABASE marketing_campaign_db;
USE marketing_campaign_db;

-- Create tables
CREATE TABLE campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    gender VARCHAR(10),
    age_group VARCHAR(20),
    region VARCHAR(50)
);

CREATE TABLE emails (
    email_id INT PRIMARY KEY,
    campaign_id INT,
    customer_id INT,
    sent_date DATE,
    opened BOOLEAN,
    clicked BOOLEAN,
    converted BOOLEAN,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Sample data for campaigns
INSERT INTO campaigns VALUES
(1, 'Summer Sale', '2024-06-01', '2024-06-30', 5000.00),
(2, 'Festive Offers', '2024-10-01', '2024-10-31', 7000.00),
(3, 'New Year Deals', '2024-12-15', '2025-01-15', 8000.00);

-- Sample data for customers
INSERT INTO customers VALUES
(101, 'Male', '18-25', 'North'),
(102, 'Female', '26-35', 'East'),
(103, 'Female', '36-45', 'South'),
(104, 'Male', '26-35', 'West'),
(105, 'Female', '18-25', 'North');

-- Sample data for emails
INSERT INTO emails VALUES
(1001, 1, 101, '2024-06-02', TRUE, TRUE, TRUE),
(1002, 1, 102, '2024-06-03', TRUE, FALSE, FALSE),
(1003, 2, 103, '2024-10-05', TRUE, TRUE, FALSE),
(1004, 2, 104, '2024-10-07', FALSE, FALSE, FALSE),
(1005, 3, 105, '2024-12-20', TRUE, TRUE, TRUE);

-- 1️⃣ Total Emails Sent per Campaign
SELECT c.campaign_name, COUNT(e.email_id) AS total_emails_sent
FROM emails e
JOIN campaigns c ON e.campaign_id = c.campaign_id
GROUP BY c.campaign_name;

-- 2️⃣ Open Rate per Campaign
SELECT c.campaign_name,
       ROUND(SUM(CASE WHEN e.opened THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS open_rate
FROM emails e
JOIN campaigns c ON e.campaign_id = c.campaign_id
GROUP BY c.campaign_name;

-- 3️⃣ Click-Through Rate (CTR)
SELECT c.campaign_name,
       ROUND(SUM(CASE WHEN e.clicked THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS click_through_rate
FROM emails e
JOIN campaigns c ON e.campaign_id = c.campaign_id
GROUP BY c.campaign_name;

-- 4️⃣ Conversion Rate
SELECT c.campaign_name,
       ROUND(SUM(CASE WHEN e.converted THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS conversion_rate
FROM emails e
JOIN campaigns c ON e.campaign_id = c.campaign_id
GROUP BY c.campaign_name;

-- 5️⃣ ROI Calculation (Assume each conversion = $50 revenue)
SELECT c.campaign_name,
       c.budget,
       SUM(CASE WHEN e.converted THEN 50 ELSE 0 END) AS total_revenue,
       ROUND((SUM(CASE WHEN e.converted THEN 50 ELSE 0 END) - c.budget), 2) AS roi
FROM campaigns c
JOIN emails e ON c.campaign_id = e.campaign_id
GROUP BY c.campaign_name, c.budget;
