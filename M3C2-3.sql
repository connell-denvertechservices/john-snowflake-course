-- ASSIGNMENT Assistance
select table_name,
    column_name,
    data_type
from information_schema.columns
where table_name = 'OPENALEX_AUTHORS_INDEX'
order by table_name, ordinal_position;

select table_name,
    column_name,
    data_type
from information_schema.columns
where table_name = 'OPENALEX_WORKS_INDEX'
order by table_name, ordinal_position;

-- Activity Part 1: SQL Challenge
select table_name,
    column_name,
    data_type
from information_schema.columns
where table_name = 'OPENALEX_SOURCES_INDEX' and
    data_type = 'ARRAY'
order by table_name, ordinal_position;

-- ACTIVITIES Admin: Create view
create or replace view v_works_counts_is_journals as
SELECT 
    source_name,
    ARRAY_AGG(f.VALUE:works_count) WITHIN GROUP (ORDER BY f.VALUE:year DESC) AS works_counts_by_year_array
FROM snowflake_public_data_free.public_data_free.openalex_sources_index,
LATERAL FLATTEN(input => WORKS_COUNTS_BY_YEAR) f
WHERE source_name IN ('MIS Quarterly', 'Information Systems Research', 'Journal of the Association for Information Systems', 'Journal of Management Information Systems', 'European Journal of Information Systems', 'Decision Support Systems', 'Information & Management', 'Information and Organization', 'Information Systems Journal') and
    source_type = 'journal'
GROUP BY source_name;

-- Compare to raw data
select openalex_source_id, 
    source_name,
    works_counts_by_year
from snowflake_public_data_free.public_data_free.openalex_sources_index
where source_name in ('MIS Quarterly', 'Information Systems Research');

-- Check view
select *
from v_works_counts_is_journals;

-- Activity Part 3: Array Function and Technique Demos
select *,
    array_size(works_counts_by_year_array) as num_years
from v_works_counts_is_journals
order by num_years;

select *, 
    works_counts_by_year_array[0] as most_recent_year_data, 
    array_slice(works_counts_by_year_array, 0, 3) as most_recent_3r_data
from v_works_counts_is_journals;

    -- SIDE NOTE: Comparison to lateral flatten
    select source_name, array_agg(f.value)
    from v_works_counts_is_journals v,
        lateral flatten(input => works_counts_by_year_array) f
    where f.value > 100
    group by source_name;

select *, 
    filter(works_counts_by_year_array, x -> x > 100) as num_years_more_than_100,
    array_size(num_years_more_than_100) as count_num_years_more_than_100
from v_works_counts_is_journals
order by count_num_years_more_than_100 desc;

select *,
    reduce(works_counts_by_year_array, 0, (acc, val) -> acc + val)
from v_works_counts_is_journals;

select *,
    reduce(works_counts_by_year_array, 0, (acc, val) -> acc + val) as total_works_counts,
    transform(works_counts_by_year_array, x -> round(x / total_works_counts, 2)::NUMBER(10,2))
from v_works_counts_is_journals;

-- Activity Part 4: Cortex Code and Business Questions

-- Normalize each journal's yearly output as a percentage of their peak year
select 
    source_name,
    reduce(works_counts_by_year_array, 0, (acc, val) -> iff(val > acc, val, acc)) as peak_year,
    transform(works_counts_by_year_array, x -> round(x / peak_year * 100, 1)::NUMBER(10,1)) as pct_of_peak
from v_works_counts_is_journals;

-- Is each journal trending up or down? Compare the sum of the first half of their history against the sum of the second half.
select 
    source_name,
    array_size(works_counts_by_year_array) as num_years,
    array_slice(works_counts_by_year_array, 0, num_years / 2) as recent_half,
    array_slice(works_counts_by_year_array, num_years / 2, num_years) as older_half,
    reduce(recent_half, 0, (acc, val) -> acc + val) as recent_sum,
    reduce(older_half, 0, (acc, val) -> acc + val) as older_sum,
    case 
        when recent_sum > older_sum then 'Trending Up'
        when recent_sum < older_sum then 'Trending Down'
        else 'Stable'
    end as trend
from v_works_counts_is_journals
order by trend, source_name;

-- Which journals have the most volatile publication output, i.e.,  highest variance between their best and worst years?
select 
    source_name,
    reduce(works_counts_by_year_array, 0, (acc, val) -> iff(val > acc, val, acc)) as max_works,
    reduce(works_counts_by_year_array, 999999, (acc, val) -> iff(val < acc, val, acc)) as min_works,
    max_works - min_works as range_volatility
from v_works_counts_is_journals
order by range_volatility desc;

-- Which journals have been growing or declining over the past 5 years
select 
    source_name,
    array_slice(works_counts_by_year_array, 0, 5) as recent_5_years,
    array_slice(works_counts_by_year_array, 5, 10) as prior_5_years,
    reduce(recent_5_years, 0, (acc, val) -> acc + val) as recent_sum,
    reduce(prior_5_years, 0, (acc, val) -> acc + val) as prior_sum,
    recent_sum - prior_sum as change,
    case 
        when recent_sum > prior_sum then 'Growing'
        when recent_sum < prior_sum then 'Declining'
        else 'Stable'
    end as trend
from v_works_counts_is_journals
order by change desc;


