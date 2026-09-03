
-- Show and describe tables
-- Basics of SELECT with WHERE, ORDER BY, JOIN, and then also limit and sample


-- Part 1: Show and describe

USE DATABASE DB_MODULE1;
USE SCHEMA ACADEMIC;

show tables;

describe table students;
describe table classes;
describe table classes_students;

-- Part 2: Select all columns, specific columns, aliases for tables and columns
select *
from students;

select student_id, first_name, last_name
from students;

select student_id as id
from students;

select s.student_id as id
from students s;

-- Part 3: Add where clauses
select *
from students;

select *
from students 
where city = 'Fort Collins';

select *
from students 
where GPA > 3.75;

select *
from students 
where enrollment_date > '2023-01-01';

select *
from students 
where gpa > 3.75 and enrollment_date > '2023-01-01';

-- Part 4: Order by
select *
from students
order by last_name asc;

select *
from students
order by personal_projects nulls first;

-- Part 5: Limit and sample
select *
from students
limit 2;

select *
from students sample(2 rows);

select *
from students sample(50);

-- Part 6: Inner Join
select *
from students s
inner join classes_students cs on s.student_id = cs.student_id
where s.student_id = 1
order by s.student_id, cs.class_id;

--limit
select students
limit 5;

--sample
select *
from students sample(50);