


-- Activity Part 1: SQL Challenge
-- How many more (or less) articles did Decision Support Systems publish in 2025 vs. 2024? 
use database db_instructor1;
use schema module3;

select source_name,
    works_counts_by_year_array[0] as wc_2025,
    works_counts_by_year_array[1] as wc_2024,
    wc_2025 - wc_2024 as wc_2025_minus_2024
from v_works_counts_is_journals
where source_name = 'MIS Quarterly';

-- Activity Part 2: Working with JSON
use database snowflake_public_data_free;
use schema public_data_free;

select openalex_source_id,
    source_name,
    summary_stats,
    works_counts_by_year
from openalex_sources_index
where source_name = 'MIS Quarterly';

-- Dot Notation: summary_stats
select openalex_source_id,
    source_name,
    summary_stats, 
    summary_stats:"2yr_mean_citedness",
    summary_stats:h_index,
    summary_stats:i10_index
from openalex_sources_index
where source_name = 'MIS Quarterly';

-- Bracket Notation: summary_stats
select openalex_source_id,
    source_name,
    summary_stats, 
    summary_stats['2yr_mean_citedness'],
    summary_stats['h_index'],
    summary_stats['i10_index']
from openalex_sources_index
where source_name = 'MIS Quarterly';

-- Dot Notation: works_counts_by_year
select openalex_source_id,
    source_name,
    works_counts_by_year,
    works_counts_by_year[0],
    works_counts_by_year[0]:cited_by_count,
    works_counts_by_year[0]:oa_works_count,
    works_counts_by_year[0]:works_count,
    works_counts_by_year[0]:year,
    works_counts_by_year[1],
    works_counts_by_year[1]:cited_by_count,
    works_counts_by_year[1]:oa_works_count,
    works_counts_by_year[1]:works_count,
    works_counts_by_year[1]:year
from openalex_sources_index
where source_name = 'MIS Quarterly';

--  Activity Part 3: Union
select openalex_source_id,
    source_name,
    works_counts_by_year,
    works_counts_by_year[0],
    works_counts_by_year[0]:cited_by_count as cited_by_count,
    works_counts_by_year[0]:oa_works_count as oa_works_count,
    works_counts_by_year[0]:works_count as works_count,
    works_counts_by_year[0]:year as year
from openalex_sources_index
where source_name = 'MIS Quarterly'
union
select openalex_source_id,
    source_name,
    works_counts_by_year,
    works_counts_by_year[1],
    works_counts_by_year[1]:cited_by_count,
    works_counts_by_year[1]:oa_works_count,
    works_counts_by_year[1]:works_count,
    works_counts_by_year[1]:year
from openalex_sources_index
where source_name = 'MIS Quarterly';

-- Activity Part 4: Lateral Flatten
select openalex_source_id,
    source_name,
    f.*
from openalex_sources_index,
    lateral flatten(input => works_counts_by_year) f
where source_name = 'MIS Quarterly';

select openalex_source_id,
    source_name,
    f.index as year_index,
    f.value:year::number as year,
    f.value:works_count::number as works_count,
    f.value:cited_by_count::number as cited_by_count
from openalex_sources_index,
    lateral flatten(input => works_counts_by_year) f
where source_name = 'MIS Quarterly'
order by year;

