-- ============================================================
-- AGGREGATE SUMMARY: What is the overall order price range?
-- Business Question: The finance team needs a quick snapshot
-- of order totals — the minimum, maximum, and average — to
-- set baseline expectations for revenue forecasting and to
-- flag any unusually large or small orders for review.
-- ============================================================
SELECT
    MIN(O_TOTALPRICE)  AS MIN_ORDER_TOTAL,
    MAX(O_TOTALPRICE)  AS MAX_ORDER_TOTAL,
    AVG(O_TOTALPRICE)  AS AVG_ORDER_TOTAL
FROM ORDERS;

-- ============================================================
-- DISTINCT VALUES: What order statuses exist in the system?
-- Business Question: The operations team needs to confirm the
-- set of possible order statuses (F = Fulfilled, O = Open,
-- P = Pending) to ensure reporting dashboards and downstream
-- ETL pipelines account for every valid status code.
-- ============================================================
SELECT DISTINCT O_ORDERSTATUS
FROM ORDERS;

-- ============================================================
-- INNER JOIN: Which market segment generates the most revenue?
-- Business Question: The sales team wants to understand how
-- total order revenue breaks down by customer market segment
-- (e.g. AUTOMOBILE, BUILDING, MACHINERY) to prioritize
-- segment-specific marketing campaigns.
-- ============================================================
SELECT
    C.C_MKTSEGMENT,
    COUNT(O.O_ORDERKEY)            AS TOTAL_ORDERS,
    ROUND(SUM(O.O_TOTALPRICE), 2)  AS TOTAL_REVENUE,
    ROUND(AVG(O.O_TOTALPRICE), 2)  AS AVG_ORDER_VALUE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
INNER JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O
    ON C.C_CUSTKEY = O.O_CUSTKEY
GROUP BY C.C_MKTSEGMENT
ORDER BY TOTAL_REVENUE DESC;

-- ============================================================
-- LEFT JOIN: Which nations have customers but little revenue?
-- Business Question: The international expansion team needs to
-- identify nations where customers exist but order activity is
-- low, indicating untapped markets that may benefit from
-- targeted outreach or localized promotions.
-- ============================================================
SELECT
    N.N_NAME                                     AS NATION,
    COUNT(C.C_CUSTKEY)                           AS TOTAL_CUSTOMERS,
    COUNT(O.O_ORDERKEY)                          AS CUSTOMERS_WITH_ORDERS,
    COUNT(C.C_CUSTKEY) - COUNT(O.O_ORDERKEY)     AS CUSTOMERS_WITHOUT_ORDERS,
    ROUND(COALESCE(SUM(O.O_TOTALPRICE), 0), 2)  AS TOTAL_REVENUE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION N
LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
    ON N.N_NATIONKEY = C.C_NATIONKEY
LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O
    ON C.C_CUSTKEY = O.O_CUSTKEY
GROUP BY N.N_NAME
ORDER BY TOTAL_REVENUE DESC;

-- ============================================================
-- GROUP BY: How does order revenue trend by year and status?
-- Business Question: The finance team wants to see how total
-- order revenue and volume break down by year and order status
-- (F = Fulfilled, O = Open, P = Pending) to identify trends
-- and assess fulfillment performance over time.
-- ============================================================
SELECT
    YEAR(O.O_ORDERDATE)                AS ORDER_YEAR,
    O.O_ORDERSTATUS                    AS ORDER_STATUS,
    COUNT(O.O_ORDERKEY)                AS TOTAL_ORDERS,
    ROUND(SUM(O.O_TOTALPRICE), 2)      AS TOTAL_REVENUE,
    ROUND(AVG(O.O_TOTALPRICE), 2)      AS AVG_ORDER_VALUE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O
GROUP BY YEAR(O.O_ORDERDATE), O.O_ORDERSTATUS
ORDER BY ORDER_YEAR, ORDER_STATUS;

-- ============================================================
-- HAVING: Which customers are high-value repeat buyers?
-- Business Question: The loyalty team wants to identify
-- customers who have placed more than 20 orders and generated
-- over $500,000 in total revenue, to target them for a
-- premium rewards program.
-- ============================================================
SELECT
    C.C_CUSTKEY,
    C.C_NAME,
    C.C_MKTSEGMENT,
    COUNT(O.O_ORDERKEY)                AS TOTAL_ORDERS,
    ROUND(SUM(O.O_TOTALPRICE), 2)      AS TOTAL_REVENUE
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
INNER JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O
    ON C.C_CUSTKEY = O.O_CUSTKEY
GROUP BY C.C_CUSTKEY, C.C_NAME, C.C_MKTSEGMENT
HAVING COUNT(O.O_ORDERKEY) > 20
   AND SUM(O.O_TOTALPRICE) > 500000
ORDER BY TOTAL_REVENUE DESC;

-- ============================================================
-- CTE: Which nations rank in the top 5 for average order value?
-- Business Question: The pricing strategy team wants to compare
-- each nation's average order value against the global average
-- to identify high-spend regions where premium product lines
-- could be expanded.
-- ============================================================
WITH nation_avg AS (
    SELECT
        N.N_NAME                           AS NATION,
        COUNT(O.O_ORDERKEY)                AS TOTAL_ORDERS,
        ROUND(SUM(O.O_TOTALPRICE), 2)      AS TOTAL_REVENUE,
        ROUND(AVG(O.O_TOTALPRICE), 2)      AS AVG_ORDER_VALUE
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION N
    INNER JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER C
        ON N.N_NATIONKEY = C.C_NATIONKEY
    INNER JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS O
        ON C.C_CUSTKEY = O.O_CUSTKEY
    GROUP BY N.N_NAME
),
global_avg AS (
    SELECT ROUND(AVG(O_TOTALPRICE), 2) AS GLOBAL_AVG_ORDER_VALUE
    FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS
)
SELECT
    na.NATION,
    na.TOTAL_ORDERS,
    na.TOTAL_REVENUE,
    na.AVG_ORDER_VALUE,
    ga.GLOBAL_AVG_ORDER_VALUE,
    ROUND(na.AVG_ORDER_VALUE - ga.GLOBAL_AVG_ORDER_VALUE, 2) AS DIFF_FROM_GLOBAL
FROM nation_avg na
CROSS JOIN global_avg ga
ORDER BY na.AVG_ORDER_VALUE DESC
LIMIT 5;
