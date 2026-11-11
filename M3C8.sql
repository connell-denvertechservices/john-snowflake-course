-- Activity Part 1a: Arrays
select *
from information_schema.columns
where table_name ilike 'openalex%' and
    data_type = 'ARRAY'
order by table_name, ordinal_position;

-- 1b
select openalex_work_id,
    work_title,
    openalex_author_ids,
    openalex_author_ids[0]::string as first_author_id
from openalex_works_index 
where array_size(openalex_author_ids) > 1
limit 3;

-- 1c
select openalex_work_id,
    work_title,
    openalex_author_ids,
    array_size(openalex_author_ids) as num_of_authors
from openalex_works_index 
where array_size(openalex_author_ids) > 1
limit 3;

-- 1d
select openalex_work_id,
    work_title,
    openalex_author_ids,
    f.path,
    f.value::string
from openalex_works_index, 
    lateral flatten(input => openalex_author_ids) f
where array_size(openalex_author_ids) > 1
limit 10;

-- Activity Part 2a: JSON
select *
from information_schema.columns
where table_name ilike 'openalex%' and
    data_type = 'VARIANT'
order by table_name, ordinal_position;

-- 2b
select openalex_author_id,
    author_name,
    summary_stats:h_index as h_index
from openalex_authors_index
where h_index > 0
limit 5;

-- 2c
select openalex_publisher_id,
    publisher_name,
    works_counts_by_year,
    f.value:year::number as year,
    f.value:works_count::number as works_count
from openalex_publishers_index, 
    lateral flatten (input => works_counts_by_year) f
where openalex_publisher_id = 'https://openalex.org/P4310322413'
order by year;

-- 2d

--activity for Nov 9th--

select *
from information_schema.columns
where table_name ilike 'openalex%' and 
data_type = 'ARRAY'
order by table_name, ordinal_position;


---1b---
select openalex_work_id,
work_title,
openalex_concept_details,
openalex_concept_details[0] as first_concept,
openalex_concept_details[1] as second_concept
from openalex_works_index
limit 5;

--1c

select openalex_work_id,
work_title,
openalex_concept_ids,
array_size(openalex_concept_ids) as num_of_concepts
from openalex_works_index
limit 5;




--activity 2a--
select *
from information_schema.columns
where table_name ilike 'openalex%' and 
data_type = 'VARIANT'
order by table_name, ordinal_position;

----2b --dot notation
select openalex_author_id,
author_name,
summary_stats,
summary_stats:h_index as h_index,
from openalex_authors_index
limit 5;

--

----2b --bracket notation
select openalex_author_id,
author_name,
summary_stats,
summary_stats['h_index'] as h_index,
from openalex_authors_index
limit 5;





