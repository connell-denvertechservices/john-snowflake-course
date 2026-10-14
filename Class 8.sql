
describe table supplier;
describe table part;
describe table partsupp;


-- Look at suppliers and pick one (s_suppkey = 1)
select *
from supplier
where s_suppkey = 1;

select s_suppkey,
    s_name,
    s_nationkey,
    n_name,
    r_regionkey,
    r_name
from supplier s
inner join nation n on s.s_nationkey = n_nationkey
inner join region r on n_regionkey = r_regionkey
where s_suppkey = 1;

select *
from partsupp
where ps_suppkey = 1;

-- Prompt: Write the sql to show parts for supplier 1 with no sales
SELECT 
    ps.ps_partkey,
    p.p_name,
    l.l_quantity,
    l.l_extendedprice
FROM partsupp ps
LEFT JOIN lineitem l ON ps.ps_partkey = l.l_partkey AND ps.ps_suppkey = l.l_suppkey
LEFT JOIN part p ON ps.ps_partkey = p.p_partkey
WHERE ps.ps_suppkey = 1
    AND l.l_orderkey IS NULL;

-- Activity Part 2: Aggregations

-- How many different products does supplier 1 sell?
select count(*), avg(ps_supplycost)
from partsupp
where ps_suppkey = 1;

-- Prompt: Write the sql for: For supplier 1, where s_suppkey = 1, how many of each product that this supplier offers have been sold and for how much revenue?
SELECT 
    p.p_partkey,
    p.p_name,
    SUM(l.l_quantity) AS total_quantity_sold,
    SUM(l.l_extendedprice) AS total_revenue
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM l
JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.PART p ON l.l_partkey = p.p_partkey
WHERE l.l_suppkey = 1
GROUP BY p.p_partkey, p.p_name
ORDER BY total_revenue DESC;


-- Activity Part 3: CTEs

-- Prompt: Write the Supplier 1 revenue per product vs average revenue from other suppliers
WITH supplier1_revenue AS (
    SELECT 
        l.l_partkey,
        SUM(l.l_extendedprice) AS supplier1_revenue
    FROM lineitem l
    WHERE l.l_suppkey = 1
    GROUP BY l.l_partkey
),
other_suppliers_avg AS (
    SELECT 
        l.l_partkey,
        AVG(l.l_extendedprice) AS avg_other_revenue
    FROM lineitem l
    WHERE l.l_suppkey != 1
    GROUP BY l.l_partkey
)
SELECT 
    p.p_partkey,
    p.p_name,
    s1.supplier1_revenue,
    oa.avg_other_revenue,
    s1.supplier1_revenue - oa.avg_other_revenue AS revenue_difference
FROM supplier1_revenue s1
JOIN other_suppliers_avg oa ON s1.l_partkey = oa.l_partkey
JOIN part p ON s1.l_partkey = p.p_partkey
ORDER BY revenue_difference DESC;


-- Activity Part 4: CASE

-- Categorize supplier 1's products by revenue tier
SELECT 
    p.p_partkey,
    p.p_name,
    SUM(l.l_extendedprice) AS product_revenue,
    CASE 
        WHEN SUM(l.l_extendedprice) >= 500000 THEN 'High'
        WHEN SUM(l.l_extendedprice) >= 200000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_tier
FROM lineitem l
JOIN part p ON l.l_partkey = p.p_partkey
WHERE l.l_suppkey = 1
GROUP BY p.p_partkey, p.p_name
ORDER BY product_revenue DESC;

