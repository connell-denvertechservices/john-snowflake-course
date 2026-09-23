-- Module 2 Structured Data
-- Class 3


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

-- SQL Challenge
select *
from customer
where c_custkey = 60008;

select *
from customer
where c_mktsegment = 'AUTOMOBILE';

select *
from orders
where o_orderdate > '1998-08-01';

select *
from orders
where o_orderdate between '1998-07-01' and '1998-08-01';

-- Activity Part 1: Joins
select *
from customer c
inner join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1, 2, 3)
order by c.c_custkey;

select *
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1, 2, 3)
order by c.c_custkey;

-- Activity Part 2: count() + group by
select c.c_custkey, 
    count(o_orderkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1, 2, 3)
group by c.c_custkey
order by c.c_custkey;

-- Activity Part 3a: Order by
select c.c_custkey, 
    count(o_orderkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1, 2, 3, 4, 5, 6, 7)
group by c.c_custkey
order by orders_count asc;

select c.c_custkey, 
    count(o_orderkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1, 2, 3, 4, 5, 6, 7)
group by c.c_custkey
order by orders_count desc;

-- Activity Part 3b: Having
select c.c_custkey, 
    count(o_orderkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1, 2, 3, 4, 5, 6, 7)
group by c.c_custkey
having orders_count >= 10
order by orders_count desc;

-- Activity Part 4: Using Cortex Code
-- Which orders have more than 10 line items?
select l_orderkey,
    count(*) as lineitem_count
from lineitem
group by l_orderkey
having lineitem_count > 5
order by lineitem_count desc;

-- How many orders are there for every lineitem count?
select lineitem_count,
    count(*) as order_count
from (
    select l_orderkey,
        count(*) as lineitem_count
    from lineitem
    group by l_orderkey
)
group by lineitem_count
order by lineitem_count;
