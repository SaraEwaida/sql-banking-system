SELECT c.FIRST_NAME , c.LAST_NAME , c.CUSTOMER_ID , a.BALANCE
FROM CUSTOMERS c
LEFT JOIN ACCOUNTS a ON c.CUSTOMER_ID = a.CUSTOMER_ID; 
SET PAGESIZE 50

SELECT c.first_name || ' ' || c.last_name AS customer_name,
l.AMOUNT
FROM CUSTOMERS c
INNER JOIN LOANS l ON c.customer_id = l.customer_id;





SELECT e.EMPLOYEE_ID , e.FIRST_NAME , e.LAST_NAME , b.BRANCH_ID , b.BRANCH_NAME
FROM EMPLOYEES e
LEFT JOIN BRANCHES b ON e.BRANCH_ID = b.BRANCH_ID; 


SELECT c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_balance DESC
FETCH FIRST 3 ROWS ONLY;


HAVING count(l.loan_id) = 0;

SELECT * FROM LOANS;
SELECT * FROM CUSTOMERS;

SELECT * FROM ACCOUNTS;

SELECT * FROM TRANSACTIONS;

SELECT 
    account_id,
    SUM(CASE WHEN trans_type = 'deposit' THEN amount
             WHEN trans_type = 'withdrawal' THEN -amount
        END) AS net_transaction
FROM transactions
GROUP BY account_id
ORDER BY account_id;

SELECT DISTINCT TRANS_TYPE FROM transactions;

SELECT 
    ACCOUNT_ID,
    SUM(CASE WHEN TRANS_TYPE = 'DEPOSIT' THEN AMOUNT
             WHEN TRANS_TYPE = 'WITHDRAWAL' THEN -AMOUNT
        END) AS net_transaction
FROM transactions
GROUP BY ACCOUNT_ID
ORDER BY ACCOUNT_ID;






SELECT 'Total Deposits' AS transaction_type, SUM(amount) AS total
FROM transactions
WHERE trans_type = 'deposit'

UNION ALL

SELECT 'Total Withdrawals' AS trans_type, SUM(amount) AS total
FROM transactions
WHERE trans_type = 'withdrawal';



SELECT SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) AS total_deposits, SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) AS total_withdrawals FROM transactions;




SELECT a.ACCOUNT_ID , a.status
FROM ACCOUNTS a
LEFT JOIN TRANSACTIONS t ON a.ACCOUNT_ID = t.ACCOUNT_ID
WHERE t.TRANSACTION_ID IS NULL;

SELECT account_id, account_type, balance, status
FROM ACCOUNTS
WHERE account_id NOT IN (
    SELECT account_id FROM TRANSACTIONS);













SELECT c.first_name, c.last_name ,a.CUSTOMER_ID, count(*) AS num_accounts
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
GROUP BY c.first_name, c.last_name , a.customer_ID
HAVING count(*) > 1;


SELECT c.first_name, c.last_name ,a.CUSTOMER_ID,  SUM(*) AS Total_balance
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id

SELECT c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_balance DESC;

DESC accounts;
DESC branches;

SELECT b.BRANCH_NAME, SUM(a.BALANCE) AS total_balance
FROM accounts a
JOIN customers c ON a.CUSTOMER_ID = c.CUSTOMER_ID
JOIN branches b ON c.BRANCH_ID = b.BRANCH_ID
GROUP BY b.BRANCH_NAME
ORDER BY total_balance DESC
FETCH FIRST 1 ROWS ONLY;

SELECT 
    c.FIRST_NAME || ' ' || c.LAST_NAME AS customer_name, t.AMOUNT, t.TRANS_TYPE
FROM transactions t
JOIN accounts a ON t.ACCOUNT_ID = a.ACCOUNT_ID
JOIN customers c ON a.CUSTOMER_ID = c.CUSTOMER_ID
WHERE t.AMOUNT = (SELECT MAX(AMOUNT) FROM transactions);

DESC loans;

SELECT b.BRANCH_NAME,SUM(l.AMOUNT) AS total_loan_amount
FROM loans l
JOIN customers c ON l.CUSTOMER_ID = c.CUSTOMER_ID
JOIN branches b ON c.BRANCH_ID = b.BRANCH_ID
GROUP BY b.BRANCH_NAME
ORDER BY total_loan_amount DESC;

SELECT 
    c.FIRST_NAME || ' ' || c.LAST_NAME AS customer_name,
    a.BALANCE,
    RANK() OVER (ORDER BY a.BALANCE DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY a.BALANCE DESC) AS dense_rank
FROM accounts a
JOIN customers c ON a.CUSTOMER_ID = c.CUSTOMER_ID;

SELECT  ACCOUNT_ID, TRANS_DATE, AMOUNT, TRANS_TYPE,
SUM(AMOUNT) OVER (PARTITION BY ACCOUNT_ID ORDER BY TRANS_DATE) AS running_total
FROM transactions;

SELECT ACCOUNT_ID,TRANS_DATE, AMOUNT, TRANS_TYPE,
MAX(AMOUNT) OVER (PARTITION BY ACCOUNT_ID) AS max_transaction
FROM transactions;


-- Who might be risky customers? (think: loans with low balance, overdraft patterns)
SELECT c.CUSTOMER_ID, a.BALANCE,
l.AMOUNT AS loan_amount
FROM customers c
JOIN accounts a ON c.CUSTOMER_ID = a.CUSTOMER_ID
JOIN loans l ON c.CUSTOMER_ID = l.CUSTOMER_ID
WHERE a.BALANCE < l.AMOUNT
ORDER BY a.BALANCE ASC;

-- Which branch performs best? (think: total balance, number of customers, loan activity)


SELECT b.BRANCH_NAME,
COUNT(DISTINCT c.CUSTOMER_ID) AS total_customers,
SUM(a.BALANCE) AS total_balance,
SUM(l.AMOUNT) AS total_loans
FROM branches b
JOIN customers c ON b.BRANCH_ID = c.BRANCH_ID
JOIN accounts a ON c.CUSTOMER_ID = a.CUSTOMER_ID
LEFT JOIN loans l ON c.CUSTOMER_ID = l.CUSTOMER_ID
GROUP BY b.BRANCH_NAME
ORDER BY total_balance DESC;




-- Shows total number of opened accounts
-- Useful to measure bank activity and expansion
SELECT COUNT(ACCOUNT_ID) AS total_accounts
FROM accounts;


-- shows total money held across all accounts
-- useful to measure overall bank financial health
SELECT SUM(BALANCE) AS total_balance
FROM accounts;


-- shows cash flow in and out of the bank
-- useful to monitor liquidity and transaction activity
SELECT 
SUM(CASE WHEN TRANS_TYPE = 'DEPOSIT' THEN AMOUNT ELSE 0 END) AS total_deposits,
SUM(CASE WHEN TRANS_TYPE = 'WITHDRAWAL' THEN AMOUNT ELSE 0 END) AS total_withdrawals
FROM transactions;



-- shows the highest value customers
-- useful to identify VIP customers for special treatment
SELECT c.CUSTOMER_ID, c.FIRST_NAME || ' ' || c.LAST_NAME AS customer_name,
SUM(a.BALANCE) AS total_balance
FROM customers c
JOIN accounts a ON c.CUSTOMER_ID = a.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID, c.FIRST_NAME, c.LAST_NAME
ORDER BY total_balance DESC
FETCH FIRST 5 ROWS ONLY;



-- shows which branch has highest balance and transaction volume
-- useful to reward top branches and replicate their success
SELECT b.BRANCH_NAME,
COUNT(DISTINCT c.CUSTOMER_ID) AS total_customers,
SUM(a.BALANCE) AS total_balance,
COUNT(t.TRANSACTION_ID) AS transaction_volume
FROM branches b
JOIN customers c ON b.BRANCH_ID = c.BRANCH_ID
JOIN accounts a ON c.CUSTOMER_ID = a.CUSTOMER_ID
LEFT JOIN transactions t ON a.ACCOUNT_ID = t.ACCOUNT_ID
GROUP BY b.BRANCH_NAME
ORDER BY total_balance DESC;



























-- Which accounts are inactive? (think: no transactions, or no recent activity)
SELECT a.ACCOUNT_ID, a.STATUS
FROM accounts a
LEFT JOIN transactions t ON a.ACCOUNT_ID = t.ACCOUNT_ID
WHERE t.ACCOUNT_ID IS NULL;







--Who are high-value customers? (think: high balance, multiple accounts)
SELECT c.CUSTOMER_ID ,
COUNT (a.ACCOUNT_ID) AS total_accounts,
SUM (a.BALANCE) AS total_balance
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.CUSTOMER_ID = a.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID
ORDER BY total_balance DESC;








SELECT c.CUSTOMER_ID,
COUNT(t.transaction_id) AS total_transactions,
SUM(t.amount) AS total_amount,
FROM CUSTOMERS c
JOIN ACCOUNTS a ON c.customer_id = a.customer_id
JOIN TRANSACTIONS t ON a.account_id = t.account_id
GROUP BY c.customer_id
ORDER BY total_transactions DESC;



SELECT c.CUSTOMER_ID, 
Count (t.TRANSACTION_ID) AS total_transactions,
SUM(t.AMOUNT) AS totsl_amount
FROM CUSTOMER c
JOIN ACCOUNTS a ON c.CUSTOMER_ID =a.CUSTOMER_ID
JOIN TRANSCATIONS t ON a.ACCOUNT_ID = t.ACCOUNT_ID
GROUP BY c.CUSTOMER_ID
ORDER BY total_transcations DESC; 






