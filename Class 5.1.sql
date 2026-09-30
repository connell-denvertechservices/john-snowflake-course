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
