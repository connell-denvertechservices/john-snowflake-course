-- Module 2 Structured Data
-- Class 3-4


-- Activity Part : Describe a couple of columns in the customer table

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


--activity for today
select * 
from customer c
limit 10;

select *
from customer c
inner join orders o on c.c_custkey = o.o_custkey
where c_custkey in (1, 2, 3)
order by c.c_custkey;

--left join
select *
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c_custkey in (1, 2, 3)
order by c.c_custkey;

--group by using left join
select c.c_custkey,
count(o.o_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c_custkey in (1, 2, 3)
group by c.c_custkey 
order by c.c_custkey;

--group by using inner join
select c.c_custkey,
count(o.o_custkey) as orders_count
from customer c
inner join orders o on c.c_custkey = o.o_custkey
where c_custkey in (1, 2, 3)
group by c.c_custkey 
order by c.c_custkey;

select c.c_custkey,
count(c.c_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c_custkey in (1, 2, 3)
group by c.c_custkey 
order by c.c_custkey;

select c.c_custkey,
count(o.o_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c_custkey in (1, 2, 3)
group by c.c_custkey 
order by c.c_custkey;

select c.c_custkey,
count(c.c_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
--where c_custkey in (1, 2, 3)
group by c.c_custkey 
order by c.c_custkey
limit 10;



