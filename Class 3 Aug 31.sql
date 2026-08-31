-- Class 3 Aug 31
-- Finish inner join  Semi-structured data

use database db_module1;
use schema academic;

-- Quick SQL challenges
select *
from classes
where max_capacity > 30;

-- Inner join
select cs.class_id,
    c.class_name,
    c.class_code,
    cs.term,
    cs.student_id,
    s.first_name, 
    s.last_name,
    cs.status
from classes_students cs
inner join students s on cs.student_id = s.student_id
inner join classes c on cs.class_id = c.class_id
where status = 'ENROLLED'
order by class_id, student_id;

-- Arrays
-- Students: Interests, Clubs
-- Classes: prerequisites, meeting_days
-- Classes_Students: exam_scores, assignment_scores 

select student_id, 
    first_name, 
    last_name, 
    interests, 
    clubs
from students;

select student_id, 
    first_name, 
    last_name, 
    interests[0]::varchar as first_interest,
    interests[1]::varchar as second_interest,
    interests[2]::varchar as third_interest,
    clubs
from students
where student_id = 3;

select s.student_id, 
    s.first_name, 
    s.last_name, 
    f.*
from students s, 
    lateral flatten(input => interests) f
where student_id = 3;

select s.student_id, 
    s.first_name, 
    s.last_name, 
    f.value::varchar as interest,
    f.index as interest_index
from students s,
    lateral flatten(input => interests) f
--where student_id = 3;
where interest = 'CS';

-- JSON
-- Students: student_profile
-- Classes: Syllabus
select student_id,
    first_name,
    last_name,
    student_profile
from students;

select student_id,
    first_name,
    last_name,
    student_profile:major::varchar as major,
    student_profile:minor::varchar as minor,
    student_profile:track::varchar as track
from students;

select class_id,
    class_name,
    syllabus
from classes;

select class_id,
    class_name,
    syllabus:textbook::varchar as textbook
from classes;

-- JSON + Arrays
select class_id,
    class_name,
    syllabus:software[0]::varchar,
    syllabus:software[1]::varchar
from classes;




-- In Class
-- Activity Part 1
-- Question: Which classes have a maximum capacity of more than 30?
