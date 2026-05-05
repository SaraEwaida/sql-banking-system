#  SQL Banking System

A comprehensive SQL banking database project built with Oracle Database,
inspired by my internship at Palestine Investment Bank.

##  Database Tables

| Table | Description |
|-------|-------------|
| CUSTOMERS | Bank clients (name, email, phone, city, branch) |
| ACCOUNTS | Customer accounts (type, balance, status) |
| TRANSACTIONS | Deposits, withdrawals, transfers |
| LOANS | Customer loans (type, amount, interest rate) |
| BRANCHES | Bank branch locations and contact info |
| EMPLOYEES | Bank staff data |

##  Key Columns

### CUSTOMERS
- CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, CITY, JOIN_DATE, BRANCH_ID

### ACCOUNTS
- ACCOUNT_ID, CUSTOMER_ID, ACCOUNT_TYPE, BALANCE, OPEN_DATE, STATUS

### TRANSACTIONS
- TRANSACTION_ID, ACCOUNT_ID, TRANS_TYPE, AMOUNT, TRANS_DATE, DESCRIPTION

### LOANS
- LOAN_ID, CUSTOMER_ID, LOAN_TYPE, AMOUNT, INTEREST_RATE, START_DATE, END_DATE, STATUS

### BRANCHES
- BRANCH_ID, BRANCH_NAME, CITY, PHONE

##  Topics Covered
- DDL & DML (CREATE, INSERT, UPDATE, DELETE)
- JOINs (INNER, LEFT, RIGHT)
- Aggregate Functions (SUM, COUNT, AVG)
- GROUP BY & HAVING
- Subqueries & EXISTS
- Window Functions (RANK, DENSE_RANK, SUM OVER)
- Business Analytics & KPI Dashboard Queries
- Constraints & Data Integrity

## Tools Used
- Oracle Database XE
- Oracle SQL Developer


##  Author
Sara Ewaida — Computer Engineering Student @ Birzeit University  
Intern @ Palestine Investment Bank
