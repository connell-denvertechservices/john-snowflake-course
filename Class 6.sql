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
