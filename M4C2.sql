use database snowflake_public_data_free;
use schema public_data_free;

-- Activity Part 1: SQL Challenge
-- Extract the abstract for one patent
-- Abstract: One paragraph
select patent_id,
    invention_title,
    patent_raw_json,
    patent_raw_json:"abstract".p[0]."#text"::string
from uspto_patent_index
limit 1;

-- Abstract: Lateral Flatten
select patent_id,
    invention_title,
    patent_raw_json,
    f.*
from uspto_patent_index,
    lateral flatten (input => patent_raw_json:"abstract".p) f
limit 5;

-- Abstract: In the patent text attributes
select pi.patent_id,
    pi.invention_title,
    pta.value
from uspto_patent_text_attributes pta
inner join uspto_patent_index pi on pta.patent_id = pi.patent_id
where variable = 'Abstract'
limit 1;

-- Activity Part 2: Describe our subset
use database db_instructor1;
use schema module4;

select *
from uspto_patents_g06
limit 5;



-- Activity Part 3a: AI_COMPLETE
-- See: https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql#choosing-a-model
select patent_id,
    invention_title,
    ai_complete(
        'mistral-7b', 
        prompt('Explain the main ideas of this patent to someone who does not have any technical knowledge. Patent Title: {0}. Patent Abstract: {1}', invention_title, abstract)
    ) as patent_ai_summary
from uspto_patents_g06 sample (1 rows);

-- Activity Part 3b: AI_SIMILARITY
select patent_id,
    invention_title,
    ai_similarity('System and method for distributed management of configurable hardware to satisfy user intent', invention_title) as title_similarity
from uspto_patents_g06 sample (10 rows)
order by title_similarity desc;

-- Activity Part 3c: AI_FILTER
select patent_id,
    invention_title,
    ai_filter(
        prompt('This patent is related to distirbuted management of hardware: {0}', invention_title)
    ) as is_distributed_management
from uspto_patents_g06 sample(10 rows);

-- Activity Part 3d: AI_SUMMARY_AGG
select ai_summarize_agg(invention_title)
from uspto_patents_g06
where invention_title ilike '%distributed%'
limit 10;

-- Activity Part 3e: AI_CLASSIFY
select patent_id,
    invention_title,
    ai_classify(
        invention_title,
        ['hardware', 'software', 'other']
    ) as classification,
    classification:labels[0]::string
from uspto_patents_g06
limit 5;


