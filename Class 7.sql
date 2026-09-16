
-- Mod 1 Class 1: Intro to Structured Data

-- Activity Part 1
show tables;

describe table customer;
describe table orders;
describe table lineitem;

select *
from customer
limit 10;

select *
from orders 
limit 10;

select *
from lineitem
limit 10;

select count(*)
from customer;

select count(*)
from orders;

select count(*)
from lineitem;

-- Activity Part 2: Lucidchart (no sql)

-- Activity Part 3: Describe a couple of columns in the customer table
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

