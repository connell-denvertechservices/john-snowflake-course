-- Module 2 Structured Data



-- Activity Part : Order by
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

-- Activity Part : Having
select c.c_custkey, 
    count(o_orderkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c.c_custkey in (1, 2, 3, 4, 5, 6, 7)
group by c.c_custkey
having orders_count >= 10
order by orders_count desc;


--for today

select c.c_custkey,
count(c.c_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
--where c_custkey in (1, 2, 3)
group by c.c_custkey 
order by orders_count asc
limit 10;

--activity for having
select c.c_custkey,
count(c.c_custkey) as orders_count
from customer c
left join orders o on c.c_custkey = o.o_custkey
where c_custkey in (1, 2, 3)
group by c.c_custkey
having orders_count > 35 
order by orders_count asc;

--challenege activity


select c.c_mktsegment,
count(o_orderkey) as orders_count,
round(avg(o_totalprice),2) as orders_total_avg,
sum(o_totalprice) as orders_total_sum
from customer c
left join orders o on c.c_custkey = o.o_custkey
group by c.c_mktsegment
limit 10;



