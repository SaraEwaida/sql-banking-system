-- 1. BRANCHES
CREATE TABLE BRANCHES (
    branch_id     NUMBER PRIMARY KEY,
    branch_name   VARCHAR2(50),
    city          VARCHAR2(30),
    phone         VARCHAR2(20)
);

INSERT INTO BRANCHES VALUES (1, 'Main Branch',     'New York',    '212-000-0001');
INSERT INTO BRANCHES VALUES (2, 'Downtown Branch', 'New York',    '212-000-0002');
INSERT INTO BRANCHES VALUES (3, 'West Branch',     'Los Angeles', '310-000-0001');
INSERT INTO BRANCHES VALUES (4, 'North Branch',    'Chicago',     '312-000-0001');
INSERT INTO BRANCHES VALUES (5, 'East Branch',     'Houston',     '713-000-0001');

-- 2. CUSTOMERS
CREATE TABLE CUSTOMERS (
    customer_id   NUMBER PRIMARY KEY,
    first_name    VARCHAR2(30),
    last_name     VARCHAR2(30),
    email         VARCHAR2(50),
    phone         VARCHAR2(20),
    city          VARCHAR2(30),
    join_date     DATE,
    branch_id     NUMBER REFERENCES BRANCHES(branch_id)
);

INSERT INTO CUSTOMERS VALUES (1,  'Alice', 'Johnson', 'alice@email.com',  '555-1001', 'New York',    DATE '2020-01-15', 1);
INSERT INTO CUSTOMERS VALUES (2,  'Bob',   'Smith',   'bob@email.com',    '555-1002', 'New York',    DATE '2019-03-22', 2);
INSERT INTO CUSTOMERS VALUES (3,  'Carol', 'Davis',   'carol@email.com',  '555-1003', 'Los Angeles', DATE '2021-07-10', 3);
INSERT INTO CUSTOMERS VALUES (4,  'David', 'Wilson',  'david@email.com',  '555-1004', 'Chicago',     DATE '2018-11-05', 4);
INSERT INTO CUSTOMERS VALUES (5,  'Emma',  'Brown',   'emma@email.com',   '555-1005', 'Houston',     DATE '2022-02-28', 5);
INSERT INTO CUSTOMERS VALUES (6,  'Frank', 'Taylor',  'frank@email.com',  '555-1006', 'New York',    DATE '2020-06-14', 1);
INSERT INTO CUSTOMERS VALUES (7,  'Grace', 'Anderson','grace@email.com',  '555-1007', 'Los Angeles', DATE '2021-09-30', 3);
INSERT INTO CUSTOMERS VALUES (8,  'Henry', 'Martinez','henry@email.com',  '555-1008', 'Chicago',     DATE '2019-12-01', 4);
INSERT INTO CUSTOMERS VALUES (9,  'Irene', 'Garcia',  'irene@email.com',  '555-1009', 'Houston',     DATE '2023-01-20', 5);
INSERT INTO CUSTOMERS VALUES (10, 'James', 'Lee',     'james@email.com',  '555-1010', 'New York',    DATE '2017-08-18', 2);

-- 3. ACCOUNTS
CREATE TABLE ACCOUNTS (
    account_id    NUMBER PRIMARY KEY,
    customer_id   NUMBER REFERENCES CUSTOMERS(customer_id),
    account_type  VARCHAR2(20),
    balance       NUMBER(12,2),
    open_date     DATE,
    status        VARCHAR2(10)
);

INSERT INTO ACCOUNTS VALUES (101, 1,  'SAVINGS',  15000.00, DATE '2020-01-15', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (102, 1,  'CHECKING',  3200.00, DATE '2020-03-01', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (103, 2,  'SAVINGS',   8500.00, DATE '2019-03-22', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (104, 3,  'CHECKING',  1200.00, DATE '2021-07-10', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (105, 4,  'SAVINGS',  50000.00, DATE '2018-11-05', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (106, 5,  'CHECKING',   750.00, DATE '2022-02-28', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (107, 6,  'SAVINGS',  22000.00, DATE '2020-06-14', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (108, 7,  'CHECKING',  4300.00, DATE '2021-09-30', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (109, 8,  'SAVINGS',   9800.00, DATE '2019-12-01', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (110, 9,  'CHECKING',   300.00, DATE '2023-01-20', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (111, 10, 'SAVINGS',  67000.00, DATE '2017-08-18', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (112, 10, 'CHECKING',  5500.00, DATE '2018-01-10', 'ACTIVE');
INSERT INTO ACCOUNTS VALUES (113, 2,  'CHECKING',     0.00, DATE '2015-05-01', 'CLOSED');

-- 4. TRANSACTIONS
CREATE TABLE TRANSACTIONS (
    transaction_id  NUMBER PRIMARY KEY,
    account_id      NUMBER REFERENCES ACCOUNTS(account_id),
    trans_type      VARCHAR2(20),
    amount          NUMBER(10,2),
    trans_date      DATE,
    description     VARCHAR2(100)
);

INSERT INTO TRANSACTIONS VALUES (1001, 101, 'DEPOSIT',    5000.00, DATE '2024-01-05', 'Salary deposit');
INSERT INTO TRANSACTIONS VALUES (1002, 101, 'WITHDRAWAL', 1200.00, DATE '2024-01-10', 'Rent payment');
INSERT INTO TRANSACTIONS VALUES (1003, 102, 'DEPOSIT',     800.00, DATE '2024-01-12', 'Freelance payment');
INSERT INTO TRANSACTIONS VALUES (1004, 103, 'DEPOSIT',    2000.00, DATE '2024-01-15', 'Salary deposit');
INSERT INTO TRANSACTIONS VALUES (1005, 103, 'WITHDRAWAL',  500.00, DATE '2024-01-18', 'Grocery shopping');
INSERT INTO TRANSACTIONS VALUES (1006, 104, 'WITHDRAWAL',  300.00, DATE '2024-01-20', 'Utility bill');
INSERT INTO TRANSACTIONS VALUES (1007, 105, 'DEPOSIT',   10000.00, DATE '2024-01-22', 'Business revenue');
INSERT INTO TRANSACTIONS VALUES (1008, 106, 'WITHDRAWAL',  200.00, DATE '2024-01-25', 'ATM withdrawal');
INSERT INTO TRANSACTIONS VALUES (1009, 107, 'DEPOSIT',    3000.00, DATE '2024-02-01', 'Salary deposit');
INSERT INTO TRANSACTIONS VALUES (1010, 108, 'TRANSFER',   1500.00, DATE '2024-02-05', 'Transfer to savings');
INSERT INTO TRANSACTIONS VALUES (1011, 109, 'DEPOSIT',    4500.00, DATE '2024-02-10', 'Salary deposit');
INSERT INTO TRANSACTIONS VALUES (1012, 110, 'WITHDRAWAL',  100.00, DATE '2024-02-12', 'ATM withdrawal');
INSERT INTO TRANSACTIONS VALUES (1013, 111, 'DEPOSIT',   20000.00, DATE '2024-02-15', 'Investment return');
INSERT INTO TRANSACTIONS VALUES (1014, 111, 'WITHDRAWAL', 3000.00, DATE '2024-02-20', 'Home renovation');
INSERT INTO TRANSACTIONS VALUES (1015, 112, 'DEPOSIT',    1000.00, DATE '2024-02-22', 'Bonus');

-- 5. LOANS
CREATE TABLE LOANS (
    loan_id       NUMBER PRIMARY KEY,
    customer_id   NUMBER REFERENCES CUSTOMERS(customer_id),
    loan_type     VARCHAR2(30),
    amount        NUMBER(12,2),
    interest_rate NUMBER(4,2),
    start_date    DATE,
    end_date      DATE,
    status        VARCHAR2(10)
);

INSERT INTO LOANS VALUES (201, 1,  'HOME',      200000.00, 3.50, DATE '2020-02-01', DATE '2050-02-01', 'ACTIVE');
INSERT INTO LOANS VALUES (202, 2,  'CAR',        15000.00, 5.20, DATE '2021-06-15', DATE '2026-06-15', 'ACTIVE');
INSERT INTO LOANS VALUES (203, 3,  'PERSONAL',    5000.00, 7.80, DATE '2022-01-10', DATE '2025-01-10', 'ACTIVE');
INSERT INTO LOANS VALUES (204, 4,  'BUSINESS',   80000.00, 4.10, DATE '2019-03-20', DATE '2029-03-20', 'ACTIVE');
INSERT INTO LOANS VALUES (205, 5,  'CAR',         12000.00, 6.00, DATE '2022-05-01', DATE '2027-05-01', 'ACTIVE');
INSERT INTO LOANS VALUES (206, 6,  'PERSONAL',    3000.00, 8.50, DATE '2021-11-30', DATE '2024-11-30', 'PAID');
INSERT INTO LOANS VALUES (207, 8,  'HOME',       150000.00, 3.75, DATE '2020-07-15', DATE '2045-07-15', 'ACTIVE');
INSERT INTO LOANS VALUES (208, 10, 'BUSINESS',   100000.00, 3.90, DATE '2018-09-01', DATE '2028-09-01', 'ACTIVE');

-- 6. EMPLOYEES
CREATE TABLE EMPLOYEES (
    employee_id   NUMBER PRIMARY KEY,
    first_name    VARCHAR2(30),
    last_name     VARCHAR2(30),
    job_title     VARCHAR2(30),
    salary        NUMBER(10,2),
    branch_id     NUMBER REFERENCES BRANCHES(branch_id),
    hire_date     DATE,
    manager_id    NUMBER
);

INSERT INTO EMPLOYEES VALUES (301, 'Sarah',  'Connor', 'Branch Manager', 85000, 1, DATE '2015-03-10', NULL);
INSERT INTO EMPLOYEES VALUES (302, 'Tom',    'Harris', 'Branch Manager', 80000, 2, DATE '2016-07-01', NULL);
INSERT INTO EMPLOYEES VALUES (303, 'Linda',  'White',  'Branch Manager', 78000, 3, DATE '2017-01-15', NULL);
INSERT INTO EMPLOYEES VALUES (304, 'Mark',   'Evans',  'Branch Manager', 82000, 4, DATE '2014-09-20', NULL);
INSERT INTO EMPLOYEES VALUES (305, 'Nancy',  'Clark',  'Branch Manager', 79000, 5, DATE '2016-11-05', NULL);
INSERT INTO EMPLOYEES VALUES (306, 'Paul',   'Walker', 'Loan Officer',   55000, 1, DATE '2018-02-28', 301);
INSERT INTO EMPLOYEES VALUES (307, 'Quinn',  'Adams',  'Teller',         38000, 1, DATE '2020-06-10', 301);
INSERT INTO EMPLOYEES VALUES (308, 'Rachel', 'Brown',  'Teller',         37000, 2, DATE '2021-03-15', 302);
INSERT INTO EMPLOYEES VALUES (309, 'Steve',  'Young',  'Loan Officer',   54000, 3, DATE '2019-08-22', 303);
INSERT INTO EMPLOYEES VALUES (310, 'Tina',   'Scott',  'Teller',         36000, 4, DATE '2022-01-10', 304);

COMMIT;

SELECT table_name FROM user_tables 
WHERE table_name IN ('BRANCHES','CUSTOMERS','ACCOUNTS','TRANSACTIONS','LOANS','EMPLOYEES');

-- See all branches
SELECT * FROM BRANCHES;

-- See all customers
SELECT * FROM CUSTOMERS;


SELECT c.first_name || ' ' || c.last_name AS full_name,
b.branch_name
FROM CUSTOMERS c
LEFT JOIN BRANCHES b ON c.branch_id = b.branch_id;

-- List transactions with customer names
SELECT c.first_name || ' ' || c.last_name AS customer_names,
t.transaction_id, t.trans_type, t.amount,
t.trans_date, t.description
FROM TRANSACTIONS t
JOIN ACCOUNTS a ON t.account_id = a.account_id
JOIN CUSTOMERS c ON a.customer_id = c.customer_id;



SET PAGESIZE 150

SELECT city 
,count (*) AS Customer_Count
 FROM CUSTOMERS GROUP BY CITY;


SELECT count (*) AS total_customers FROM CUSTOMERS;

SELECT *
FROM CUSTOMERS
ORDER BY JOIN_DATE DESC;

-- See all accounts with their balances
SELECT * FROM ACCOUNTS where rownum = 0;

SELECT * FROM TRANSACTIONS;

SELECT trans_type
,SUM (amount) AS total_transaction
FROM TRANSACTIONS
GROUP BY TRANS_TYPE;

SELECT * FROM LOANS;

SELECT * FROM EMPLOYEES;

SELECT * FROM ACCOUNTS;

SELECT ACCOUNT_TYPE, count (*) AS accounts
FROM ACCOUNTS 
GROUP BY ACCOUNT_TYPE;

SELECT * 
FROM ACCOUNTS 
WHERE balance > 10000;


SELECT * FROM CUSTOMERS
WHERE CITY='New York';

SELECT ACCOUNT_ID
WHERE STATUS = 'ACTIVE';

SELECT * FROM ACCOUNTS WHERE status = 'ACTIVE';








-- Customers with their account balances
SELECT c.first_name, c.last_name, a.account_type, a.balance
FROM CUSTOMERS c
INNER JOIN ACCOUNTS a ON c.customer_id = a.customer_id;

CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) NOT NULL,
    Age int
);

ALTER TABLE EMPLOYEES 
ADD CONSTRAINT chk_salary CHECK (salary > 0);

ALTER TABLE TRANSACTIONS 
ADD CONSTRAINT chk_amount CHECK (amount > 0);

CREATE SEQUENCE seq_branch
    START WITH 6
    INCREMENT BY 1
    NOCACHE;

    CREATE OR REPLACE VIEW VW_EMP_BRANCH AS
SELECT e.first_name, e.last_name, 
       e.job_title, e.salary, b.city
FROM EMPLOYEES e
JOIN BRANCHES b ON e.branch_id = b.branch_id;

SELECT * FROM VW_EMP_BRANCH;

-- When creating a table:
CREATE TABLE table_name (
    column_name datatype CHECK (condition)
);

-- Adding to existing table:
ALTER TABLE table_name 
ADD CONSTRAINT constraint_name CHECK (condition);