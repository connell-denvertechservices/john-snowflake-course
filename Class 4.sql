-- Class 4 

use database db_module1;
use schema academic;

-- SQL Challenge (Activity Part 1)
-- Which classes do not have a specified textbook?

select class_id,
    class_code,
    class_name,
    syllabus:textbook::string as textbook
from classes
where textbook is null;

-- Activity Part 2: AI_SUMMARIZE_AGG
select class_id,
    class_code,
    class_name,
    learning_outcomes
from classes
where learning_outcomes is not null;

select ai_summarize_agg(learning_outcomes) as learning_outcomes_summary
from classes
where learning_outcomes is not null;




-- Activity
-- Part 1: SQL Challenge











