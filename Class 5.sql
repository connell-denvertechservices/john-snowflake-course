-- Module 2 Structured Class 3

-- Activity Part 1: SQL Challenge
-- For each market segement, how many orders in total?
select c.c_mktsegment, 
    count(o.o_orderkey) as order_count,
    avg(o_totalprice) as order_avg_total_price,
    sum(o_totalprice) as order_sum_total_price
from customer c
inner join orders o on c.c_custkey = o.o_custkey
group by c.c_mktsegment
limit 10;

-- Activity Part 
-- RFM Metrics

-- Cortex Code Prompt: Please create the sql for a view that calculates recency, frequency, and monetary metrics for every customer in the customer table. Definitions are as follows. Recency: How recently a customer has made a purchase. Frequency: How often a customer makes a purchase. Monetary value: How much money a customer spends on purchases. RFM analysis numerically ranks a customer in each of these three categories, generally on a scale of 1 to 5 (the higher the number, the better the result). The “best” customer would receive a top score in every category.
-- Source for definition: https://www.investopedia.com/terms/r/rfm-recency-frequency-monetary-value.asp

-- https://workik.com/claude-code-generator




--CREATE OR REPLACE VIEW db_instructor1.module2.V_CUSTOMER_RFM AS
WITH customer_metrics AS (
    SELECT 
        c.C_CUSTKEY,
        c.C_NAME,
        DATEDIFF('day', MAX(o.O_ORDERDATE), CURRENT_DATE()) AS recency_days,
        COUNT(DISTINCT o.O_ORDERKEY) AS frequency,
        SUM(l.L_EXTENDEDPRICE * (1 - l.L_DISCOUNT)) AS monetary
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER c
    LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS o ON c.C_CUSTKEY = o.O_CUSTKEY
    LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM l ON o.O_ORDERKEY = l.L_ORDERKEY
    GROUP BY c.C_CUSTKEY, c.C_NAME
),
rfm_scores AS (
    SELECT
        C_CUSTKEY,
        C_NAME,
        recency_days,
        frequency,
        monetary,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_score
    FROM customer_metrics
    WHERE frequency > 0
)
SELECT
    C_CUSTKEY,
    C_NAME,
    recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score AS rfm_total_score,
    recency_score || frequency_score || monetary_score AS rfm_segment
FROM rfm_scores
limit 10;

-- Look at the data
select *
from db_instructor1.module2.v_customer_rfm
limit 10;

-- Is it right?
select recency_days, recency_score
from db_instructor1.module2.v_customer_rfm
order by recency_days desc;

select recency_days, recency_score
from db_instructor1.module2.v_customer_rfm
order by recency_days asc;

select frequency, frequency_score
from db_instructor1.module2.v_customer_rfm
order by frequency desc;

select frequency, frequency_score
from db_instructor1.module2.v_customer_rfm
order by frequency asc;

select monetary, monetary_score
from db_instructor1.module2.v_customer_rfm
order by monetary desc;

select monetary, monetary_score
from db_instructor1.module2.v_customer_rfm
order by monetary asc;

select *
from db_instructor1.module2.v_customer_rfm
order by rfm_segment desc;

-- Activity Part 3: Subquery using Cortex/Claude Code

-- Example 1: Subquery in FROM (high-frequency customers)
--prompt: Write the sql for a query that includes a subquery in FROM and focuses on recency.


SELECT c.c_name, freq.order_count
FROM customer c
INNER JOIN (
    SELECT o_custkey, COUNT(*) AS order_count
    FROM orders
    GROUP BY o_custkey
    HAVING COUNT(*) >= 20
) freq ON c.c_custkey = freq.o_custkey
ORDER BY freq.order_count DESC
LIMIT 10;

-- Example 2: Subquery in WHERE IN (customers with above-average monetary value)
--prompt: Write the SQL for a query that includes a subquery in a WHERE IN clause and focuses on recency.

SELECT c.c_custkey, c.c_name
FROM customer c
WHERE c.c_custkey IN (
    SELECT o.o_custkey
    FROM orders o
    JOIN lineitem l ON o.o_orderkey = l.l_orderkey
    GROUP BY o.o_custkey
    HAVING SUM(l.l_extendedprice) > (SELECT AVG(o_totalprice) * 10 FROM orders)
)
LIMIT 10;

-- Activity Part 4 CTEs: Using Cortex Code

-- Example 1 as CTE: High-frequency customers
WITH high_frequency AS (
    SELECT o_custkey, COUNT(*) AS order_count
    FROM orders
    GROUP BY o_custkey
    HAVING COUNT(*) >= 20
)
SELECT c.c_name, hf.order_count
FROM customer c
INNER JOIN high_frequency hf ON c.c_custkey = hf.o_custkey
ORDER BY hf.order_count DESC
LIMIT 10;

-- Example 2 as CTE: Customers with above-average monetary value
WITH avg_threshold AS (
    SELECT AVG(o_totalprice) * 10 AS threshold
    FROM orders
),
high_spenders AS (
    SELECT o.o_custkey
    FROM orders o
    JOIN lineitem l ON o.o_orderkey = l.l_orderkey
    GROUP BY o.o_custkey
    HAVING SUM(l.l_extendedprice) > (SELECT threshold FROM avg_threshold)
)
SELECT c.c_custkey, c.c_name
FROM customer c
WHERE c.c_custkey IN (SELECT o_custkey FROM high_spenders)
LIMIT 10;

-- CTE on our own
-- Simple CTE: Total orders per market segment
with cte as (
    select c.c_mktsegment, 
        count(o.o_orderkey) as order_count,
        avg(o_totalprice) as order_avg_total_price,
        sum(o_totalprice) as order_sum_total_price
    from customer c
    inner join orders o on c.c_custkey = o.o_custkey
    group by c.c_mktsegment
    limit 10
)
select * 
from cte;

-- Activity Part 5: Views
create or replace view db_instructor1.module2.v_mktsegment_stats as
select c.c_mktsegment, 
    count(o.o_orderkey) as order_count,
    avg(o_totalprice) as order_avg_total_price,
    sum(o_totalprice) as order_sum_total_price
from snowflake_sample_data.tpch_sf1.customer c
inner join snowflake_sample_data.tpch_sf1.orders o on c.c_custkey = o.o_custkey
group by c.c_mktsegment;

select *
from db_instructor1.module2.v_mktsegment_stats
limit 10;

-- Activity Part 6: Create table as select
create or replace table db_instructor1.module2.mktsegment_stats as
select *
from db_instructor1.module2.v_mktsegment_stats;

select *
from db_instructor1.module2.mktsegment_stats;

-- Create a table from the view
--CREATE or replace TABLE Z_DB_INSTRUCTOR1.module2.customer_rfm AS
--SELECT * FROM Z_DB_INSTRUCTOR1.module2.V_CUSTOMER_RFM;

-- Now check the table
select *
from db_instructor1.module2.customer_rfm
limit 10;




