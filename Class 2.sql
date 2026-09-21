
-- Mod 2 Class 2: Intro to Structured Data






-- Activity Part : Lucidchart (no sql)

-- Activity Part : Describe a couple of columns in the customer table
select c_custkey,
    c_acctbal
from customer
limit 10;

select min(c_acctbal) as min_acct_bal,
    max(c_acctbal) as max_acct_bal,
    avg(c_acctbal) as avg_acct_bal,
    count(*) - count(c_acctbal) as count_missing
from customer;

select c_custkey,
    c_mktsegment
from customer
limit 10;

select distinct c_mktsegment
from customer;

