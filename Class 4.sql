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




-- Activity for class

select student_id,
student_profile,
student_profile:major
from students;


-- differentiating 
select student_id,
student_profile,
student_profile:major::string as major
from students
order by major;

--classes

select class_id,
syllabus,
syllabus:textbook:: string as textbook
from classes;


--array within JSON

select class_id,
syllabus,
syllabus:textbook:: string as textbook,
syllabus:readings::array as readings,department,
readings[0]::string as reading_first,
readings[1]::string as reading_second
from classes;

--latteral flattening


select student_id, 
student_profile,
f.*
from students,
lateral flatten(input => student_profile) f;


--simplify

select student_id,
student_profile,
f.key as key,
f.value as value,
from students,
lateral flatten(input => student_profile) f;


--simplify


--summarize
select class_id,
class_code,
class_name,
learning_outcomes
from classes
where learning_outcomes is not null;


---ai summarize

select ai_summarize_agg(learning_outcomes)
from classes
where learning_outcomes is not null;


--multiple

select ai_summarize_agg(
learning_outcomes
)
from classes
where learning_outcomes is not null;

--students table
select ai_summarize_agg(
personal_statement
)
from students;





