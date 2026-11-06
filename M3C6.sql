-- Activity: SQL Challenge
use database snowflake_public_data_free;
use schema public_data_free;

select openalex_source_id,
    source_name,
    works_counts_by_year,
    f.value:year as year,
    f.value:cited_by_count as cited_by_count
from openalex_sources_index,
    lateral flatten(input => works_counts_by_year) f
where source_name = 'MIS Quarterly'
order by cited_by_count desc
limit 1;

-- Activity Part 1: Browse the concepts
select *
from openalex_concepts_index
limit 10;

select count(*)
from openalex_concepts_index;

select *
from openalex_concepts_index
where array_size(ancestor_openalex_concept_ids) = 0;

select *
from openalex_concepts_index
where concept_name = 'Business';

select *
from openalex_concepts_index
where ancestor_openalex_concept_ids[0] = 'https://openalex.org/C144133560';

select *
from openalex_concepts_index
where ancestor_openalex_concept_ids[0] = 'https://openalex.org/C144133560'
order by works_cited_by_count desc;

-- DEMO: Creation of view that generates a hierarchy
-- Hierarchy (using CONNECT BY)
CREATE OR REPLACE VIEW DB_INSTRUCTOR1.MODULE3.V_CONCEPT_HIERARCHY AS
WITH direct_parent AS (
    SELECT
        c.OPENALEX_CONCEPT_ID AS CONCEPT_ID,
        c.CONCEPT_NAME,
        anc.OPENALEX_CONCEPT_ID AS PARENT_ID,
        anc.CONCEPT_NAME AS PARENT_NAME
    FROM SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.OPENALEX_CONCEPTS_INDEX c,
         LATERAL FLATTEN(INPUT => c.ANCESTOR_OPENALEX_CONCEPT_IDS) a
    JOIN SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.OPENALEX_CONCEPTS_INDEX anc
      ON anc.OPENALEX_CONCEPT_ID = a.VALUE::STRING
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY c.OPENALEX_CONCEPT_ID
        ORDER BY ARRAY_SIZE(COALESCE(anc.ANCESTOR_OPENALEX_CONCEPT_IDS, ARRAY_CONSTRUCT())) DESC
    ) = 1

    UNION ALL

    SELECT
        OPENALEX_CONCEPT_ID,
        CONCEPT_NAME,
        NULL,
        NULL
    FROM SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.OPENALEX_CONCEPTS_INDEX
    WHERE ARRAY_SIZE(COALESCE(ANCESTOR_OPENALEX_CONCEPT_IDS, ARRAY_CONSTRUCT())) = 0
)
SELECT
    h.CONCEPT_ID,
    h.CONCEPT_NAME,
    h.PARENT_ID AS PARENT_CONCEPT_ID,
    h.PARENT_NAME AS PARENT_CONCEPT_NAME,
    LEVEL AS HIERARCHY_LEVEL,
    LTRIM(SYS_CONNECT_BY_PATH(h.CONCEPT_NAME, ' > '), ' > ') AS HIERARCHY_PATH,
    c.WORKS_COUNTS_BY_YEAR,
    c.SUMMARY_STATS
FROM direct_parent h
JOIN SNOWFLAKE_PUBLIC_DATA_FREE.PUBLIC_DATA_FREE.OPENALEX_CONCEPTS_INDEX c
  ON c.OPENALEX_CONCEPT_ID = h.CONCEPT_ID
    START WITH h.PARENT_ID IS NULL
    CONNECT BY h.PARENT_ID = PRIOR h.CONCEPT_ID
ORDER BY HIERARCHY_PATH;

-- Activity Part 3: Concept Hierarchy
use database z_db_instructor1;
use schema module3;

select count(*)
from v_concept_hierarchy;

select *
from db_instructor1.module3.v_concept_hierarchy
order by hierarchy_level
limit 5;

select *
from db_instructor1.module3.v_concept_hierarchy
where hierarchy_path ilike 'Business%'
order by hierarchy_path;

-- Activity Part 4: Business Questions (on your own)

-- Question: For Business concepts with a hierarchy level of 3 or more, what are the top 5 by works_counts in 2025? 
select concept_id, 
    concept_name,
    hierarchy_level,
    hierarchy_path,
    works_counts_by_year[0], 
    works_counts_by_year[0]:works_count as wc_2025
from v_concept_hierarchy
where hierarchy_path ilike 'Business%' and
    hierarchy_level > 2
order by wc_2025 desc
limit 5;

-- Bottom 5?
select concept_id, 
    concept_name,
    hierarchy_level,
    hierarchy_path,
    works_counts_by_year[0], 
    works_counts_by_year[0]:works_count as wc_2025
from v_concept_hierarchy
where hierarchy_path ilike 'Business%' and
    hierarchy_level > 2
order by wc_2025
limit 6;

-- For “Business > Marketing > Service (business)”, generate a time series chart for the number of citations received per year
select concept_id,
    concept_name,
    f.value:year as year,
    f.value:cited_by_count as cited_by_count
from v_concept_hierarchy, 
    lateral flatten(input => works_counts_by_year) f
where concept_id = 'https://openalex.org/C2780378061'
order by year;

-- Activity Part 4b: Business Questions (use Corex Code)

-- What are the most well cited concepts?
select concept_id,
    concept_name,
    hierarchy_path,
    summary_stats:cited_by_count as cited_by_count
from v_concept_hierarchy
order by cited_by_count desc
limit 10;

-- What concepts are trending downward?
select concept_id,
    concept_name,
    hierarchy_path,
    works_counts_by_year[1]:works_count as works_2024,
    works_counts_by_year[0]:works_count as works_2025,
    works_counts_by_year[0]:cited_by_count as cited_by_2025,
    round((works_2025 - works_2024) / nullif(works_2024, 0) * 100, 2) as pct_decline
from v_concept_hierarchy
where works_2024 > 100
order by pct_decline asc
limit 10;

-- What are the most promising emerging concepts?
select concept_id,
    concept_name,
    hierarchy_path,
    works_counts_by_year[1]:works_count as works_2024,
    works_counts_by_year[0]:works_count as works_2025,
    works_counts_by_year[0]:cited_by_count as cited_by_2025,
    round((works_2025 - works_2024) / nullif(works_2024, 0) * 100, 2) as pct_growth
from v_concept_hierarchy
where works_2024 > 100
order by pct_growth desc
limit 10;

-- Which concepts have the most consistent year-over-year growth?
select concept_id,
    concept_name,
    hierarchy_path,
    round(avg(f.value:works_count), 0) as avg_works,
    round(variance(f.value:works_count), 2) as works_variance,
    round(stddev(f.value:works_count) / nullif(avg(f.value:works_count), 0), 4) as coefficient_of_variation,
    count(f.value) as years_of_data
from v_concept_hierarchy,
    lateral flatten(input => works_counts_by_year) f
where f.value:year >= 2015
group by concept_id, concept_name, hierarchy_path
having avg_works > 500 and years_of_data >= 10
order by coefficient_of_variation asc
limit 10;

