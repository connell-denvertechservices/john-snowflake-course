-- Activity Part 1
show tables;
show views;

select *
from information_schema.views
where table_name ilike 'openalex%';

describe view openalex_works_index;
describe view openalex_authors_index;

select *
from openalex_works_index 
limit 10;

select *
from openalex_authors_index 
limit 10;

-- Activity Part 2: Finding a single work in OpenAlex
select *
from openalex_works_index
where openalex_work_id = 'https://openalex.org/W3124166904';

select openalex_work_id,
    openalex_concept_ids,
    works_counts_by_year
from openalex_works_index
where openalex_work_id = 'https://openalex.org/W3124166904';

-- Activity Part 3
select *
from information_schema.views
where table_name ilike 'openalex%'
order by table_name;

select *
from information_schema.columns
where table_name ilike 'openalex%'
order by table_name, ordinal_position;

select table_name,
    column_name,
    data_type
from information_schema.columns
where table_name ilike 'openalex%' and
    data_type in ('ARRAY', 'VARIANT')
order by table_name, ordinal_position;

select ALTERNATIVE_AUTHOR_NAMES, 
    OPENALEX_CONCEPT_IDS, 
    OPENALEX_CONCEPT_DETAILS, 
    WORKS_COUNTS_BY_YEAR, 
    SUMMARY_STATS
from openalex_authors_index
limit 10;