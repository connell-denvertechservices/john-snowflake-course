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
from openalex_works_index 
limit 10;

select *
from openalex_authors_index 
limit 10;


--activity==

show tables;
show views;

select *
from information_schema.views;


--openalex extract--

select * 
from information_schema.views
where table_name ilike 'openalex%';

select * 
from openalex_authors_index
limit 5;

select count(*)
from openalex_authors_index;

select * 
from openalex_works_index
limit 5;

select * 
from openalex_works_index
where openalex_work_id = 'https://openalex.org/W3124166904';

--activity oct 19th--

select *
from information_schema.views
where table_name ilike 'openalex%'; 

describe view openalex_works_index;

select *
from information_schema.columns
where table_name ilike 'openalex%'
order by table_name, ordinal_position;

--looking of semi structured data--
select * 
from information_schema.columns
where table_name ilike 'openalex%' and 
data_type in ('ARRAY', 'VARIANT')
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
limit 5; 

select openalex_author_id,
author_name,
ALTERNATIVE_AUTHOR_NAMES,
OPENALEX_CONCEPT_IDS,
OPENALEX_CONCEPT_DETAILS,
WORKS_COUNTS_BY_YEAR,
SUMMARY_STATS
from openalex_authors_index
limit 5; 

select table_name,
column_name,
data_type,
from information_schema.columns
where table_name = 'OPENALEX_SOURCES_INDEX' and
data_type = 'ARRAY'
order by ordinal_position;

--

select table_name,
column_name,
data_type,
ordinal_position
from information_schema.columns
where table_name ilike '%SOURCES%' and
data_type = 'ARRAY'
order by ordinal_position;

--activity--
select *
from  openalex_sources_index
where source_name = 'MIS Quarterly'
limit 5;

--2 IS jounrals--
select *
from  openalex_sources_index
where source_name in ('MIS Quarterly', 'Information Systems Research') 

limit 5;

