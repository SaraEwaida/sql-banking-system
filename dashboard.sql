-- ============================================================
-- PALESTINE INVESTMENT BANK — BI DASHBOARD QUERIES

-- ============================================================
-- OVERVIEW PANEL
-- ============================================================
-- * Total customers, total accounts, total active accounts
-- PURPOSE : Count total customers, accounts, and active accounts
-- TABLES USED  : CUSTOMERS, ACCOUNTS
-- BUSINESS MEANING :showing bank size and account health
SELECT COUNT(*) AS total_customers,
COUNT(a.account_id) AS total_accounts,
SUM(CASE WHEN a.status = 'ACTIVE' THEN 1 ELSE 0 END) AS total_active_accounts
FROM CUSTOMERS c
LEFT JOIN ACCOUNTS a ON c.customer_id = a.customer_id;

-- ============================================================
-- * Total balance across all active accounts
-- PURPOSE: Total balance held across all active accounts
-- TABLES USED  : ACCOUNTS
-- BUSINESS MEANING : Total deposits the bank manages — key liquidity metric
SELECT ROUND(SUM(balance), 2) AS total_active_balance
FROM ACCOUNTS
WHERE status = 'ACTIVE';

-- ============================================================
-- * Total loans outstanding (ACTIVE only) and total loan amount
-- PURPOSE      : Total active loans count and outstanding loan amount
-- TABLES USED  : LOANS
-- BUSINESS MEANING : Total lending exposure — how much the bank has issued and not yet recovered
SELECT COUNT(*) AS total_active_loans,
SUM(amount) AS total_loan_amount
FROM LOANS
WHERE status = 'ACTIVE';

-- ============================================================
-- * Total employees by job_title
-- PURPOSE    : Headcount breakdown by job title
-- TABLES USED  : EMPLOYEES
-- BUSINESS MEANING : Workforce distribution — helps HR plan staffing and costs
SELECT job_title, COUNT(*) AS num_employees
FROM EMPLOYEES
GROUP BY job_title
ORDER BY num_employees DESC;

-- ============================================================
-- TRANSACTIONS PANEL
-- ============================================================
-- * Total deposits, withdrawals, and transfers this month
-- PURPOSE      : Total deposits, withdrawals, and transfers this month
-- TABLES USED  : TRANSACTIONS
-- BUSINESS MEANING : Monthly cash flow summary — shows money in vs money out
SELECT 
SUM(CASE WHEN trans_type = 'DEPOSIT'    THEN amount ELSE 0 END) AS total_deposits,
SUM(CASE WHEN trans_type = 'WITHDRAWAL' THEN amount ELSE 0 END) AS total_withdrawals,
SUM(CASE WHEN trans_type = 'TRANSFER'   THEN amount ELSE 0 END) AS total_transfers
FROM TRANSACTIONS
WHERE EXTRACT(MONTH FROM trans_date) = EXTRACT(MONTH FROM SYSDATE)
  AND EXTRACT(YEAR  FROM trans_date) = EXTRACT(YEAR  FROM SYSDATE);

-- ============================================================
-- * Daily transaction volume for the last 30 days (for a line chart)
-- PURPOSE      : Daily transaction volume for the last 30 days
-- TABLES USED  : TRANSACTIONS
-- BUSINESS MEANING : Trend line showing activity patterns — identify spikes, drops, and seasonality
SELECT TO_CHAR(trans_date, 'YYYY-MM-DD') AS trans_day,
COUNT(*)        AS num_transactions,
SUM(amount)     AS daily_volume
FROM TRANSACTIONS
WHERE trans_date >= SYSDATE - 30
GROUP BY TO_CHAR(trans_date, 'YYYY-MM-DD')
ORDER BY trans_day;

-- ============================================================
-- * Top 5 accounts by transaction count
-- PURPOSE      : Top 5 most transacted accounts
-- TABLES USED  : TRANSACTIONS, ACCOUNTS, CUSTOMERS
-- BUSINESS MEANING : Identifies most active accounts — candidates for premium service or fraud review

SELECT a.account_id,a.account_type, c.first_name || ' ' || c.last_name AS customer_name,
COUNT(t.transaction_id) AS num_transactions, SUM(t.amount)AS total_volume
FROM TRANSACTIONS t
JOIN ACCOUNTS a  ON t.account_id  = a.account_id
JOIN CUSTOMERS c ON a.customer_id = c.customer_id
GROUP BY a.account_id, a.account_type, c.first_name, c.last_name
ORDER BY num_transactions DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================
-- LOANS & RISK PANEL
-- ============================================================
-- * % of loans with at least one MISSED payment
-- PURPOSE      : Percentage of loans with at least one missed payment
-- TABLES USED  : LOANS, LOAN_PAYMENTS
-- BUSINESS MEANING : Portfolio health indicator — high % means rising default risk
SELECT 
 COUNT(DISTINCT l.loan_id) AS total_loans,
COUNT(DISTINCT lp.loan_id) AS loans_with_missed_payments,
ROUND(COUNT(DISTINCT lp.loan_id) * 100 / COUNT(DISTINCT l.loan_id), 2) AS missed_pct
FROM LOANS l
LEFT JOIN LOAN_PAYMENTS lp ON l.loan_id = lp.loan_id AND lp.status = 'MISSED';

-- ============================================================
-- * Total interest paid vs principal paid across all LOAN_PAYMENTS
-- PURPOSE      : Total interest paid vs principal paid across all loan payments
-- TABLES USED  : LOAN_PAYMENTS
-- BUSINESS MEANING : Interest = bank revenue. Principal = debt recovery. 
-- Shows lending profitability vs repayment progress.
SELECT 
SUM(principal_paid) AS total_principal_paid,
SUM(interest_paid)  AS total_interest_paid,
SUM(principal_paid) - SUM(interest_paid) AS difference
FROM LOAN_PAYMENTS;
-- ============================================================
-- * Customers with ACTIVE loans AND OVERDRAFT fees (risk flag)
-- PURPOSE      : Customers with active loans AND overdraft fees — high risk flag
-- TABLES USED  : CUSTOMERS, LOANS, ACCOUNTS, FEES
-- BUSINESS MEANING : These customers are borrowing AND overdrafting — highest default risk profile
SELECT c.customer_id, c.first_name || ' ' || c.last_name  AS customer_name,
COUNT(DISTINCT l.loan_id) AS active_loans,
SUM(l.amount) AS total_loan_amount,
COUNT(DISTINCT f.fee_id) AS overdraft_fees,
SUM(a.balance) AS total_balance
FROM CUSTOMERS c
JOIN LOANS l    ON c.customer_id = l.customer_id AND l.status = 'ACTIVE'
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
JOIN FEES f     ON a.account_id  = f.account_id  AND f.fee_type = 'OVERDRAFT'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY overdraft_fees DESC, total_loan_amount DESC;

-- ============================================================
-- BRANCH PERFORMANCE PANEL
-- ============================================================
-- * Each branch: total customers, total balance, total loans, total transactions
-- PURPOSE      : Each branch total customers, balance, loans, and transactions
-- TABLES USED  : BRANCHES, CUSTOMERS, ACCOUNTS, LOANS, TRANSACTIONS
-- BUSINESS MEANING : Side-by-side branch comparison — identify top and bottom performers
SELECT b.branch_id, b.branch_name, b.city,
COUNT(DISTINCT c.customer_id) AS total_customers,
SUM(a.balance) AS total_balance,
SUM(l.amount) AS total_loans,
COUNT(DISTINCT t.transaction_id) AS total_transactions
FROM BRANCHES b
LEFT JOIN CUSTOMERS c   ON b.branch_id   = c.branch_id
LEFT JOIN ACCOUNTS a    ON c.customer_id = a.customer_id
LEFT JOIN LOANS l       ON c.customer_id = l.customer_id AND l.status = 'ACTIVE'
LEFT JOIN TRANSACTIONS t ON a.account_id = t.account_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_balance DESC;

-- ============================================================
-- * Which branch has the highest fee revenue? (FEES where status = PAID)
-- PURPOSE      : Branch fee revenue from PAID fees only
-- TABLES USED  : FEES, ACCOUNTS, CUSTOMERS, BRANCHES
-- BUSINESS MEANING : Shows which branches generate most non-interest revenue
SELECT  b.branch_name, b.city, SUM(f.amount) AS total_fee_revenue,
COUNT(f.fee_id) AS num_fees_collected
FROM FEES f
JOIN ACCOUNTS a  ON f.account_id  = a.account_id
JOIN CUSTOMERS c ON a.customer_id = c.customer_id
JOIN BRANCHES b  ON c.branch_id   = b.branch_id
WHERE f.status = 'PAID'
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_fee_revenue DESC;

-- ============================================================
-- *ATM availability per branch: count of ACTIVE vs OUT_OF_SERVICE ATMs
-- PURPOSE      : ATM availability per branch — ACTIVE vs OUT_OF_SERVICE count
-- TABLES USED  : ATM_MACHINES, BRANCHES
-- BUSINESS MEANING : Operational coverage — branches with many down ATMs need urgent maintenance
SELECT b.branch_name,b.city,COUNT(a.atm_id) AS total_atms,
SUM(CASE WHEN a.status = 'ACTIVE'         THEN 1 ELSE 0 END) AS active_atms,
SUM(CASE WHEN a.status = 'OUT_OF_SERVICE' THEN 1 ELSE 0 END) AS out_of_service,
SUM(CASE WHEN a.status = 'MAINTENANCE'    THEN 1 ELSE 0 END) AS in_maintenance,
SUM(a.cash_available) AS total_cash_available
FROM BRANCHES b
LEFT JOIN ATM_MACHINES a ON b.branch_id = a.branch_id
GROUP BY b.branch_id, b.branch_name, b.city
ORDER BY total_atms DESC;

-- ============================================================
-- CUSTOMER SEGMENT PANEL
-- ============================================================
-- * Top 10 customers by total balance
-- PURPOSE      : Top 10 customers by total account balance
-- TABLES USED  : CUSTOMERS, ACCOUNTS
-- BUSINESS MEANING : VIP customers — highest value relationships requiring premium service
SELECT 
c.customer_id, c.first_name || ' ' || c.last_name  AS customer_name,
COUNT(a.account_id) AS num_accounts,
SUM(a.balance) AS total_balance
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_balance DESC
FETCH FIRST 10 ROWS ONLY;

-- ============================================================
-- * Customer wealth segments using CASE: 'Premium' (>50k), 'Standard' (10k–50k), 'Basic' (<10k)
-- PURPOSE      : Segment all customers into wealth tiers based on total balance
-- TABLES USED  : CUSTOMERS, ACCOUNTS
-- BUSINESS MEANING : Customer segmentation drives marketing strategy, 
-- product targeting, and service level allocation
SELECT 
    wealth_segment,
    COUNT(*) AS num_customers,
    SUM(total_balance) AS segment_total_balance
FROM (SELECT c.customer_id, SUM(a.balance) AS total_balance,
CASE WHEN SUM(a.balance) > 50000 THEN 'Premium'
WHEN SUM(a.balance) BETWEEN 10000 AND 50000 THEN 'Standard'
ELSE 'Basic' END AS wealth_segment
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
GROUP BY c.customer_id
)
GROUP BY wealth_segment
ORDER BY segment_total_balance DESC;

-- ============================================================
-- * Customers with CREDIT cards above average credit_limit
-- PURPOSE      : Customers holding CREDIT cards with above-average credit limit
-- TABLES USED  : CUSTOMERS, ACCOUNTS, CARDS
-- BUSINESS MEANING : High-limit cardholders represent premium spending power 
--                    and higher interchange fee revenue
SELECT c.customer_id, c.first_name || ' ' || c.last_name  AS customer_name,
ca.card_id,ca.credit_limit,
ROUND(AVG(ca.credit_limit) OVER (), 2) AS avg_credit_limit
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
JOIN CARDS ca   ON a.account_id  = ca.account_id
WHERE ca.card_type = 'CREDIT'
  AND ca.credit_limit > (SELECT AVG(credit_limit) FROM CARDS WHERE card_type = 'CREDIT')
ORDER BY ca.credit_limit DESC;